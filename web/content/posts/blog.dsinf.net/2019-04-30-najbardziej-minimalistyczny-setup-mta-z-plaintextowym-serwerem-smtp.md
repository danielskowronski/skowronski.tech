---
title: Najbardziej minimalistyczny setup MTA z plaintextowym serwerem SMTP
author: Daniel Skowroński
type: post
date: 2019-04-30T13:04:16+00:00
excerpt: Wymaganie które postawiłem gotowemu setupowi to MTA który umie przesyłać maile od lokalnych użytkowników unixowych zalogowanych zdalnie po SMTP za pomocą auth plain w trybie plaintext, a relay jest zablokowany (żeby serwer nie stał się ofiarą spamerów).
url: /2019/04/najbardziej-minimalistyczny-setup-mta-z-plaintextowym-serwerem-smtp/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/04/1200px-Postfix-logo.svg_.png
tags:
  - linux
  - postfix
  - smtp

---
W tym artykule opiszę najbardziej mininimalistyczny, niezbyt najwyższych lotów setup _Mail Transfer Agenta_ który dostarcza plaintextowy tryb SMTP.

Jeśli pominąć wymaganie trybu plaintext przy autoryzacji temat można zamknąć na [OpenSMTPD][1].  
`invalid listen option: auth requires tls/smtps` to kwestia nie do przeszkoczenia. Poza tym MTA które ma 4 linijkowy konfig jest nieco zbyt małym wyzwaniem 😉 

Wymaganie które postawiłem gotowemu setupowi to MTA który umie przesyłać maile od lokalnych użytkowników unixowych zalogowanych zdalnie po SMTP za pomocą _auth plain_ w trybie plaintext, a relay jest zablokowany (żeby serwer nie stał się ofiarą spamerów).

System na którym instalowałem swój serwer to ubuntu, ale konfigi dołączane wydają się być czyste wprost od twórców. Potrzebne są 2 pakiety - **postfix** (jego zapewne już mamy) i **sals2-bin**. Pierwszy to właściwe MTA z kilkoma protokołami dostępowymi, a drugi to zestaw narzędzi SASL porzebnych postfixowi do auroryzacji użykowników.

Po instalacji trzeba wprowadzić kilka zmian w domyślnych plikach konfiguracyjnych:

  * **/etc/postfix/main.cf**
      * powinien posiadać kilka wpisów zapewniających integrację z SASL:  
        `smtpd_sasl_auth_enable = yes`  
        `smtpd_sasl_security_options = noanonymous`  
        `broken_sasl_auth_clients = yes` 
      * linijkę pozwającą na wprowadzanie credentiali bez TLSa:  
        `smtpd_tls_auth_only = no`
      * oraz otwierać się na świat:  
        `inet_interfaces = all`
      * tu uwaga - **nie chcemy** zmieniać _mynetworks_ na coś w rodzaju 0.0.0.0/0 - inaczej dopuścimy do relayowania maili przez każdego
  * nowy plik **/etc/postfix/sasl/smtpd.conf**  
    `pwcheck_method: saslauthd`  
    `mech_list: PLAIN LOGIN`
  * **/etc/deafult/saslauthd**  
    `MECHANISMS="shadow"`

Poza trzeba stworzyć jeden symlink który rozwiąże problem wynikający z tego że saslauthd działa jako root a postfix jest jailrootowany. Całość warto opakować zatrzymaniem i wznowieniem usług żeby na pewno sockety się utworzyły i były dostępne.

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">systemctl stop saslauthd postfix
rm -fr /var/run/saslauthd
mkdir -p /var/spool/postfix/var/run/saslauthd
ln -s /var/spool/postfix/var/run/saslauthd /var/run
chgrp sasl /var/spool/postfix/var/run/saslauthd
adduser postfix sasl
systemctl start saslauthd postfix
systemctl enable saslauthd postfix
systemctl status saslauthd postfix</pre>

Kolejny etap to dodanie lokalnego użytkownika i przetestowanie czy wszystko działa. Tu warto pokazać jak działa _auth plain_ bo jednak nie podajemy tam loginu i hasła gołym tekstem.

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">perl -MMIME::Base64 -e 'print encode_base64("\0$USERNAME\0$PASSWORD");'</pre>

Ciąg autoryzacyjny jak widać wyżej to base64 z ciągu null, użykownik, null i hasło. Jeśli użytkownik ma w nazwie małpę to należy ją wyeacapować. Poniżej przykładowa sesja odpalana "z palca":

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">zsh % perl -MMIME::Base64 -e 'print encode_base64("\0uzytkownik\@host\0haslo12345");'
AHV6eXRrb3duaWtAaG9zdABoYXNsbzEyMzQ1
zsh % perl -MMIME::Base64 -e 'print encode_base64("\0uzytkownik\0haslo12345");'
AHV6eXRrb3duaWsAaGFzbG8xMjM0NQ==
zsh % telnet localhost 25
Trying 127.0.0.1...
Connected to localhost.localdomain.
Escape character is '^]'.
220 example.org ESMTP Postfix
ehlo host_albo_i_cokolwiek
250-example.org
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-STARTTLS
250-AUTH PLAIN LOGIN
250-AUTH=PLAIN LOGIN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250-DSN
250 SMTPUTF8
auth plain
334
AHV6eXRrb3duaWsAaGFzbG8xMjM0NQ==
235 2.7.0 Authentication successful
mail from: uzytkownik@example.org
250 2.1.0 Ok
rcpt to: uzytkownik@example.com
250 2.1.5 Ok
data
354 End data with &lt;CR>&lt;LF>.&lt;CR>&lt;LF>
From: test &lt;uzytkownik@example.org>
Subject: test session

test test test
.
250 2.0.0 Ok: queued as C57FC1C004E
quit
221 2.0.0 Bye
Connection closed by foreign host.
zsh % </pre>

Pokazana tu sesja jest absolutnie minimalna poza linijką _Subject_. RFC jednak go wymaga. Gmail będzie maile bez niego odrzucał rzucając w mail.log coś takiego:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">Apr 30 12:18:21 XXXX postfix/smtp[26482]: C57FC1C004E: to=XXXXX@dsinf.net, relay=aspmx.l.google.com[64.233.166.27]:25, delay=28, delays=27/0.01/0.09/0.61, dsn=5.7.1, status=bounced (host aspmx.l.google.com[64.233.166.27] said: 550-5.7.1 [5.9.88.142      11] Our system has detected that this message is not
 550-5.7.1 RFC 5322 compliant: 550-5.7.1 'From' header is missing. 550-5.7.1 To reduce the amount of spam sent to Gmail, this message has been 550-5.7.1 blocked. Please visit 550-5.7.1  https://support.google.com/mail/?p=RfcMessageNonCompliant 550 5.7.1 and review RFC 5322 specifications for more information. j192si1309453wmb.131 - gsmtp (in reply to end of DATA command))</pre>

Na koniec warto sprawdzić czy bez zalogowania się serwer odrzuci maile wysyłane poza jego domenę podczas połączenia spoza localhosta:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">daniel@MJOLNIR:/mnt/c/Users/Daniel$ telnet example.org 25
Trying XXXXXXXXXXXXXXXXXXXXXXXXX...
Connected to example.org.
Escape character is '^]'.
220 example.org ESMTP Postfix
ehlo dupa
250-example.orget
//...
mail from: test@example.org
250 2.1.0 Ok
rcpt to: root@example.com
454 4.7.1 &lt;root@example.com>: Relay access denied
rcpt to: root@example.org
250 2.1.5 Ok
//...</pre>

 [1]: https://wiki.archlinux.org/index.php/OpenSMTPD