---
title: NTP bez NTP
author: Daniel Skowroński
type: post
date: 2017-11-14T15:36:25+00:00
excerpt: |
  Kiedy potrzeba ustawić czas w systemie na szybko można odpalić następujące: 
  <pre>date -s @`curl http://time.akamai.com`</pre><br />
  
  time.akamai.com to serwer używany do synchronizacji streamów z dokładnością około sekundy więc na potrzeby ustawienia rozjechanego czasu systemowego nada się akurat. Można go odkryć przypadkiem podczas analizowania własnego ruchu sieciowego. Happy hacking!
url: /2017/11/ntp-bez-ntp/
tags:
  - linux
  - ntp

---
Kiedy potrzeba ustawić czas w systemie na szybko można odpalić następujące:

<span class="lang:default EnlighterJSRAW crayon-inline ">date -s @`curl http://time.akamai.com`</span>

time.akamai.com to serwer używany do synchronizacji streamów z dokładnością około sekundy więc na potrzeby ustawienia rozjechanego czasu systemowego nada się akurat. Można go odkryć przypadkiem podczas analizowania własnego ruchu sieciowego. Happy hacking!