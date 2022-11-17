---
title: Debugging tale of HTTP/1.0 healthcheck
date: 2022-11-16
tags:
  - debugging
  - http
  - proxy 
  - load ballancer
  - networking
  - netcat
cover_image_copyright: https://www.reddit.com/r/ProgrammerHumor/comments/g5i5zp/netcat/
---

Time for a short tale about an interesting debugging challenge I had recently. Programming issue itself was not the hardest or most involving of all time, probably not even of this year for me, but the mixture of circumstances and debugging techniques used makes it worth telling.

Obviously, many details will be skipped, but I can mention some common components used. But keep in mind that’s a real-world scenario, so the initial environment could definitely be better.

<!--more-->

## The setup

We have some 3rd party application that's mission-critical, let's call it **N**. N is a Java app which uses Jetty and has two HTTPS endpoints (on separate ports). Due to its nature it's available from across all application environments (dev, QA, staging and prod across all datacenters and clouds), as well as over VPN for human users. It is deployed to 3 stateful VMs and can be accessed in three ways: 
- from some environments - directly over IP using round-robin DNS entry
- from some others - via other instances of N acting as caching proxy understanding content of data 
- from the rest of network (intranet) - via internal reverse proxy and load-balancing solution (Brocade vTM) that uses health checks to select healthy node.

## Introduction and confirmation of issue existence

### Morning deploy

First, all the test we could've afforded to perform on the dev environment were done (scope was severely limited by it being a 3rd party application, but all functionality was confirmed to work). Then, we got production upgrade scheduled and approved under change management for Thursday morning, so we can do it before human users start pushing data. It is also done not to let any potential issues to happen during afternoons when production workloads start relying more on data availability (plus getting vendor support is easier on business hours). 

Deploy/upgrade went quite smoothly - it's just a backup, service stop, yum package update, change of path and service restart. Downtime shorter than 3 minutes, automated functionality checks all green, no alerts. Easy job. 

One thing that should alert me more was that the aforementioned vTM made the cluster unavailable when I tried to each service from my workstation. However, it was a known issue for health checks to get stuck from time to time, so I just logged in to management console and restarted it, which cleared the issue. The fact I needed to manually kick it was noted in a change management ticket and left for review later.

### Issue being noticed

Two or three hours passed, and no alerts were appearing, so we were happy, as upgrades of N can be problematic at times. It turned out it was such case again - as we were notified by some users that the service is not working. Initially, they were slightly neglected as automated tester was still flagging all services as green, and it was just two users. When the third report came in on community channel, I did a few more checks. Then I discovered that while one of the endpoints that serve few services and browser console was fine (and reporting in admin panel that everything is all right), the other one was showing HTTP 500 error coming from vTM.

A quick attempt to repeat morning mitigation in pre-incident mode worked, but just for a minute, so a proper incident was declared shortly and users were notified we're working on it. I quickly run the tester utility manually from various points of network and confirmed that the service is still 100% OK, and it's just the vTM thinking it's dead and therefore returning 500 for users that cannot reach it directly.

## Mitigation phase

As the service is critical, but can serve part of users only from a single node, I decided to disable health checks for that problematic endpoint and let it always point to a single node. This made the service run successfully and let me lower incident severity.

## Investigation

Obviously, leaving such manual change lowering resiliency is not something I could leave for long, so investigation phase had to start right away.

### Initial healthcheck verification and replication attempts

The health check for the second endpoint was quite simple - just checking if there's valid HTTP response to `GET /` request with code ranging from 100-499 with an actual expectation to get 401. The main endpoint has more sophisticated health check as the service provides proper JSON API. So, it must have been getting 500 or above to mark endpoint as unhealthy. Quick check using cURL from various points in network confirmed we have expected response.

The health check issue was not spotted on dev environment as it has different network topology and can be accessed directly from Intranet. It's a first orange flag that the service is not deployed onto a staging environment that has exactly the same setup as production.


### Disappearing requests and SSL lessons

First idea was to check if health checks are reaching the server at all. `requests.log` was telling us that they are not - just the ones I was running from cURL. So `tcpdump` we employed right away and that did confirm some HTTP over SSL is coming in and getting responses. Not being skilled enough with vTM and wanting to avoid any further reconfiguration, I took the other approach. 

Assuming N may be still using older cryptography, I wanted to try traffic decryption. I restarted `tcpdump` to only look for packets from or to health check IPs (bastion on prod I used to test with cURL and vTM instances), took SSL key from secret store and tried to used Wireshark to decrypt traffic. After a few minutes of investigation, it turned out that (fortunately for security) embedded web server (Jetty) was using Diffie-Hellman for key exchange - so the RSA key is used just to sign DH params. It's still possible to decrypt such traffic, but would require Jetty reconfiguration and restart to store so called *SSL key log file* on disk which could be later fed to Wireshark. The alternative would be to disable DH, which again would mean service restart. Both options were unacceptable from security and service stability point of view, so I discarded them. 

### Plaintext request and response validation

The next idea to check was to duplicate health check on vTM and point it to a dummy service that just logs everything. `nginx` was employed using N's certificate to run on different port and validate if health check requests are coming in - they were. From there, the duplicated health check was configured to not use SSL, so I could just run `netcat` and see what's going on. Nothing was out of ordinary, I was able to replicate the entire request using cURL and was still getting proper response.

After checking with Network team I did one slightly risky thing - I enabled verbose logging for a dummy vTM pool that had duplicated health check and seen that in deed, it's getting HTTP 500 from the underlying Jetty, which indicates `NullPointerException`. Having details extracted, I quickly turned off verbose logging. Few minutes of log querying later, I found that the issue was happening so early in processing stage it's not getting to `resuests.log` - just being noted as `WARN` in main application log. Application is throwing so many `WARN`s that we didn't have any alerting enabled for this level. 

### HTTP/1.0 and RFCs

I went back to cURL and tried to force service to return 500 for me. After some more time, I spotted one tiny detail -  `HTTP/1.0` in request dump coming from health check. cURL by default (as every sane client) uses HTTP/1.1, so I just had to use `curl -0` to use the older protocol. And then I got same result as health check. Changing port and path to other endoint - perfectly valid 200.

So, it was time to check RFCs. I compared [RFC1945 defining HTTP/1.0](https://www.rfc-editor.org/rfc/rfc1945.html) and [RFC2616 defining HTTP/1.1](https://www.rfc-editor.org/rfc/rfc2616) for differences based on headers I've seen in my requests. The difference was `Host` header:

- HTTP/1.0 has no such header, meaning one server IP-port pair serves just one host / virtual server, therefore, application cannot crash due to lack of it
- HTTP/1.1 strictly requires presence of this field and mandates server to return 400 error immediately; some servers modify error description from generic *Bad Request* to *No Host*

### The culprit

It meant that Jetty violently ignored protocol specification and just assumed HTTP versions 1.0 and 1.1 are the same. The issue [was known](https://github.com/eclipse/jetty.project/issues/5443) and [apparently fixed](https://github.com/eclipse/jetty.project/pull/5445) around 2 years ago in Jetty upstream, but for some unknown reasons while N was upgrading to version well after that patch was applied. I won't mention specific Jetty versions as it'd be very easy to find vendor and shame them ;) 

## Resolution

The issue was immediately raised with the vendor, but they decided not to fix it, recommending a change to health check configuration (which apparently was also affecting some more common software solutions like nginx).

It turned out that enabling "advanced" feature host header in vTM health monitor settings was upgrading protocol and sending what N was expecting, letting us re-enable health checks.

Technical RCA and formal update in change management ticket followed.

## Lessons learned

Other than it being yet another case of being let down by N, some things were learned, or rather re-learned as important:

1. Always test in staging environment that is configured 1:1 as production, especially network and access-wide.
1. Testers or probes should be deployed in several network segments to spot and identify issues earlier - even if it seems to be overkill for intranet, a small version of BGPlay that only stores response status and latency can be helpful. In this case, it'd be enough to have one probe per application environment and datacenter pair, plus one going via that vTM.
1. Even when we have HTTP/3 coming, HTTP/1.0 is still alive, and it's good to be able to talk to it using netcat or telnet.
1. DH is enabled in most places, rendering most attempts to decrypt traffic using SSL key and Wireshark futile.
1. It's worth considering more advanced log-based monitoring for repeated messages, even at `WARN` level, to indicate there's something wrong.
