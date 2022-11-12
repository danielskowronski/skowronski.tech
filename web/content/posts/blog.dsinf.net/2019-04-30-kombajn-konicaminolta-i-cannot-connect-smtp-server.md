---
title: Kombajn KonicaMinolta i "CANNOT CONNECT – SMTP Server"
author: Daniel Skowroński
type: post
date: 2019-04-30T13:29:52+00:00
excerpt: |
  Od jakiegoś czasu mam u siebie wielofunkcyjne urządzenie KonicaMinolta magicolor 1690MF. Ma ono skaner, który może wysyłać wyniki pracy po FTP, do udziału samby albo mailem. Niestety debugowanie błędów jest tam co najmniej tragiczne.
  
  Po przeklikaniu się przez tragiczne menu webowe (które swoją drogą odcina dostęp do panelu na urządzeniu) udało mi się wprowadzić parametry serwera SMTP. Wybrałem gotowy serwer który mam dostępny razem z hostingiem na mydevilu. Wszystko pięknie a tam: "CANNOT CONNECT – SMTP Server".
url: /2019/04/kombajn-konicaminolta-i-cannot-connect-smtp-server/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/04/device.gif
tags:
  - email
  - hardware
  - smtp

---
Od jakiegoś czasu mam u siebie wielofunkcyjne urządzenie KonicaMinolta magicolor 1690MF. Ma ono skaner, który może wysyłać wyniki pracy po FTP, do udziału samby albo mailem. Niestety debugowanie błędów jest tam co najmniej tragiczne. 

Po przeklikaniu się przez tragiczne menu webowe (które swoją drogą odcina dostęp do panelu na urządzeniu) udało mi się wprowadzić parametry serwera SMTP. Wybrałem gotowy serwer który mam dostępny razem z hostingiem na mydevilu. Wszystko pięknie a tam: "CANNOT CONNECT - SMTP Server".

<ul class="is-layout-flex wp-block-gallery-5 wp-block-gallery columns-2 is-cropped">
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="916" height="416" src="https://blog.dsinf.net/wp-content/uploads/2019/04/error_device.png" alt="" data-id="1498" data-link="https://blog.dsinf.net/?attachment_id=1498" class="wp-image-1498" srcset="https://blog.dsinf.net/wp-content/uploads/2019/04/error_device.png 916w, https://blog.dsinf.net/wp-content/uploads/2019/04/error_device-300x136.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/04/error_device-768x349.png 768w" sizes="(max-width: 916px) 100vw, 916px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="800" height="336" src="https://blog.dsinf.net/wp-content/uploads/2019/04/error_web-1.png" alt="" data-id="1499" data-link="https://blog.dsinf.net/?attachment_id=1499" class="wp-image-1499" srcset="https://blog.dsinf.net/wp-content/uploads/2019/04/error_web-1.png 800w, https://blog.dsinf.net/wp-content/uploads/2019/04/error_web-1-300x126.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/04/error_web-1-768x323.png 768w" sizes="(max-width: 800px) 100vw, 800px" /></figure>
  </li>
</ul>

**Czas na hackowanie arpspoofem!**  


Drobna uwaga: [windowsowy build][1] wymaga DLLa winpcap'a - jeśli instalowaliśmy wiresharka przez chocolatey trzeba osobno doinstalować globalnie dostępną bibliotekę.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="416" src="https://blog.dsinf.net/wp-content/uploads/2019/04/wireshark-1024x416.png" alt="" class="wp-image-1500" srcset="https://blog.dsinf.net/wp-content/uploads/2019/04/wireshark-1024x416.png 1024w, https://blog.dsinf.net/wp-content/uploads/2019/04/wireshark-300x122.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/04/wireshark-768x312.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/04/wireshark.png 1078w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

Co się okazuje? Że drukarka zawsze wysyła nazwę hosta w komendzie EHLO jako **DIGITAL_MFP**, a EXIM nie lubi "podłogi" w nazwie hosta. W odpowiedzi rzuca **501 syntactically invalid ehlo argument(s).** 

Rozwiązaniem jest dodanie **_** w konfigu w polu _helo\_allow\_chars_ (tak jak w [tym artykule][2]).

Na współdzielonym hostingu nie za bardzo mogę zmieniać konfig więc **czemu by nie postawić** [**najbardziej minimalistycznego setupu MTA z plaintextowym serwerem SMTP**][3] **na innym serwerze?**

Po chwili, albo i kilku godzinach researchu połączonego z eksperymentowaniem oraz śledzeniem tcpdumpa podczas skanowania mamy działające wysyłanie maili.

Konfiguracja w webpanelu wymaga ustawienia adresu email "od" w trzech polach (E-mail Address, Login Name, User Name), adresu serwera w dwóch (SMTP Server Address, POP3 Server Address) oraz hasła (Password). POP3 nie trzeba ustawiać ale pole musi być wypełnione. Z moich obserwacji wynika że mój model nie umie rozwiązywać DNSów przy wysyłaniu maili więc osobiście podałem po prostu adres IP.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="797" height="778" src="https://blog.dsinf.net/wp-content/uploads/2019/04/config.png" alt="" class="wp-image-1501" srcset="https://blog.dsinf.net/wp-content/uploads/2019/04/config.png 797w, https://blog.dsinf.net/wp-content/uploads/2019/04/config-300x293.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/04/config-768x750.png 768w" sizes="(max-width: 797px) 100vw, 797px" /> </figure>

 [1]: https://github.com/alandau/arpspoof
 [2]: https://heapdump.wordpress.com/2010/07/07/exim4-helo-config-in-debian/
 [3]: https://blog.dsinf.net/2019/04/najbardziej-minimalistyczny-setup-mta-z-plaintextowym-serwerem-smtp/