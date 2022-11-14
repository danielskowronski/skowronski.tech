---
title: Kombajn KonicaMinolta i "CANNOT CONNECT – SMTP Server"
author: Daniel Skowroński
type: post
date: 2019-04-30T13:29:52+00:00
summary: |
  Od jakiegoś czasu mam u siebie wielofunkcyjne urządzenie KonicaMinolta magicolor 1690MF. Ma ono skaner, który może wysyłać wyniki pracy po FTP, do udziału samby albo mailem. Niestety debugowanie błędów jest tam co najmniej tragiczne.
  
  Po przeklikaniu się przez tragiczne menu webowe (które swoją drogą odcina dostęp do panelu na urządzeniu) udało mi się wprowadzić parametry serwera SMTP. Wybrałem gotowy serwer który mam dostępny razem z hostingiem na mydevilu. Wszystko pięknie a tam: "CANNOT CONNECT – SMTP Server".
url: /2019/04/kombajn-konicaminolta-i-cannot-connect-smtp-server/
featured_image: /wp-content/uploads/2019/04/device.gif
tags:
  - email
  - hardware
  - smtp

---
Od jakiegoś czasu mam u siebie wielofunkcyjne urządzenie KonicaMinolta magicolor 1690MF. Ma ono skaner, który może wysyłać wyniki pracy po FTP, do udziału samby albo mailem. Niestety debugowanie błędów jest tam co najmniej tragiczne. 

Po przeklikaniu się przez tragiczne menu webowe (które swoją drogą odcina dostęp do panelu na urządzeniu) udało mi się wprowadzić parametry serwera SMTP. Wybrałem gotowy serwer który mam dostępny razem z hostingiem na mydevilu. Wszystko pięknie a tam: "CANNOT CONNECT - SMTP Server".

![](/wp-content/uploads/2019/04/error_device.png)

![](/wp-content/uploads/2019/04/error_web-1.png)


**Czas na hackowanie arpspoofem!**  


Drobna uwaga: [windowsowy build][1] wymaga DLLa winpcap'a - jeśli instalowaliśmy wiresharka przez chocolatey trzeba osobno doinstalować globalnie dostępną bibliotekę.<figure class="wp-block-image">

![](/wp-content/uploads/2019/04/wireshark.png) </figure> 

Co się okazuje? Że drukarka zawsze wysyła nazwę hosta w komendzie EHLO jako **DIGITAL_MFP**, a EXIM nie lubi "podłogi" w nazwie hosta. W odpowiedzi rzuca **501 syntactically invalid ehlo argument(s).** 

Rozwiązaniem jest dodanie **_** w konfigu w polu _helo\_allow\_chars_ (tak jak w [tym artykule][2]).

Na współdzielonym hostingu nie za bardzo mogę zmieniać konfig więc **czemu by nie postawić** [**najbardziej minimalistycznego setupu MTA z plaintextowym serwerem SMTP**][3] **na innym serwerze?**

Po chwili, albo i kilku godzinach researchu połączonego z eksperymentowaniem oraz śledzeniem tcpdumpa podczas skanowania mamy działające wysyłanie maili.

Konfiguracja w webpanelu wymaga ustawienia adresu email "od" w trzech polach (E-mail Address, Login Name, User Name), adresu serwera w dwóch (SMTP Server Address, POP3 Server Address) oraz hasła (Password). POP3 nie trzeba ustawiać ale pole musi być wypełnione. Z moich obserwacji wynika że mój model nie umie rozwiązywać DNSów przy wysyłaniu maili więc osobiście podałem po prostu adres IP.<figure class="wp-block-image">

![](/wp-content/uploads/2019/04/config.png) </figure>

 [1]: https://github.com/alandau/arpspoof
 [2]: https://heapdump.wordpress.com/2010/07/07/exim4-helo-config-in-debian/
 [3]: /2019/04/najbardziej-minimalistyczny-setup-mta-z-plaintextowym-serwerem-smtp/