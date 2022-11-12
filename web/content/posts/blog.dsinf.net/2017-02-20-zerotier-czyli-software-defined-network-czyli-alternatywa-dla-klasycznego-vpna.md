---
title: ZeroTier czyli Software Defined Network czyli alternatywa dla klasycznego VPNa
author: Daniel Skowroński
type: post
date: 2017-02-20T07:34:10+00:00
excerpt: "W poszukiwaniu altenatywy dla OpenVPNa znalazłem ZeroTier - czyli Software Defined Network napisany w duchu caddy'ego - po prostu działa. A konfig nie przypomina apache'a."
url: /2017/02/zerotier-czyli-software-defined-network-czyli-alternatywa-dla-klasycznego-vpna/
featured_image: /wp-content/uploads/2017/02/zerotier-icon-660x449.png
tags:
  - network
  - sdn
  - vpn
  - windows
  - zerotier

---
W poszukiwaniu altenatywy dla OpenVPNa znalazłem [ZeroTier][1] - czyli _Software Defined Network_ napisany w duchu caddy'ego - po prostu działa. A konfig nie przypomina apache'a. Oczywiście opensource - na [GitHubie][2].

Kiedy usiłowałem dać sobie możliwość zdalnego połączenia się do RaspberryPi na którym chodzi [Zegar Delta][3] (mój własny budzik ze stacją pogody i kilkoma innymi bajerami) podłączony do internetu zwykłym domowym modemem od UPC napotkałem na klasyczne problemy. Oczywiście port forwarding nie działa. Postanowiłem postawić na jednym z moich serwerów postawić serwer OpenVPN i za pomocą caddy'ego ustawić reverse proxy. Wszystko fajnie w teorii, ale w praktyce - masakryczne rwanie sesji VPN. Żonglowanie ustawieniami, zmiana TCP<->UDP nic nie dawała. A bazowałem na konfigu który działał do tej pory zawsze. Z ciekawości zacząłem szukać czy jest jakaś alternatywa. I znalazłem.

ZeroTier to _Software Defined Network_ a więc trochę _Virtual Private Network. _Podczas gdy VPN to zwykle klasyczny model klient-serwer to SDN jest per-to-peer. A więc znika potrzeba otwierania portów, SPOF (single point of failure) no i oczywiście większa wydajność - kiedy łączę się z telefonu do komputera w mieszkaniu pakiety nie lecą przez  np. USA

ZeroTier jest na tyle sprytny że potrafi omijać większość klasycznych NATów za pomocą _UDP hole punching_, a jako ostatnią deskę ratunku wykorzysta klasyczne tunelowanie przez TCP. Wymagany jest centralny serwer koordynujący połączenia i oczywiście trzymający konfigi naszych sieci.

Twórcy postanowili być jednak hojni i postawić na wspieranych przez community serwerach. Do 100 hostów, nieskończona ilość sieci. Model płatny także występuje. Także można zainstalować tylko klienta i działać. Oczywiście całość jest opensource i można postawić swój kontroler. Klienty dostępne są na Linuksa, Windowsa, OS X, FreeBSD, OpenBSD, NetBSD (w trakcie wdrażania, wisi gdzieś mój pull request), iOS i Anroida.

<figure id="attachment_989" aria-describedby="caption-attachment-989" style="width: 422px" class="wp-caption alignnone">![](/wp-content/uploads/2017/02/zerotier-client.png)<figcaption id="caption-attachment-989" class="wp-caption-text">Klient ZeroTier (tu: Windows)</figcaption></figure>

<figure id="attachment_991" aria-describedby="caption-attachment-991" style="width: 560px" class="wp-caption alignnone">![](/wp-content/uploads/2017/02/zerotier-cli.png)<figcaption id="caption-attachment-991" class="wp-caption-text">zerotier-cli</figcaption></figure>

<figure id="attachment_992" aria-describedby="caption-attachment-992" style="width: 388px" class="wp-caption alignnone">![](/wp-content/uploads/2017/02/FullSizeRender.jpg)<figcaption id="caption-attachment-992" class="wp-caption-text">Klient ZeroTier na iOS</figcaption></figure>

Od strony klienta wystarczy wpisać ID sieci i się połączyć. Tworzony jest interfejs TAP (a więc na 2 warstwie ISO/OSI) i dostaje adres sieciowy. Administrator przez web gui lub po API definiuje sieci, ich adresy oraz zezwala konkretnym klientom na dołączenie. W najprostszej wersji po prostu zaklikuje request. Administrator może także zdefiniować że dany host będzie działał jako "broadcast" czyli bridge'ował się do pozostałych interfejsów sieciowych. Czyli wystarczy jeden taki "injector" w sieci i mamy do niej zdalny dostęp.

<figure id="attachment_988" aria-describedby="caption-attachment-988" style="width: 1921px" class="wp-caption alignnone">![](/wp-content/uploads/2017/02/zerotier_gui.png)<figcaption id="caption-attachment-988" class="wp-caption-text">WebGUI administracyjne</figcaption></figure>

SDN można sprytnie wykorzystać do łączenia sieci maszyn wirtualnych między serwerowniami, omijania NATów czy też po prostu VPNowania się po ręcznym zdefiniowaniu tras (`ip r`). Można także stosować to jako ACL ponieważ narzut jest znikomy. Tylko pierwsze połączenie zajmuje chwilę kiedy hosty próbują się znaleźć ale każde kolejne jest niemal tak szybkie jakby łączyły się po LANie. Dlatego używanie w domu adresacji z ZeroTiera nie stanowi problemu nawet do transferu plików.

Jedna uwaga co do Windowsa - z bliżej nieznanych przyczyn nie zmienia się metryka trasy sieci zerotiera (prawdopodobnie tylko w sytuacji gdy interfejs z IP był dodawany gdy sieć overlapująca nie była podłączona - np. inne WiFi). Jest to problematyczne kiedy subnet ZeroTiera jest wycinkiem LANu fizycznego - np. u mnie jest to 10.12.34.1/24 a LAN w sieci koła naukowego to całe 10.0.0.1/8 - Windows próbuje routować pakiety przez fizyczny zamiast wirtualnego interfejsu. Można w takiej sytuacji ręcznie zmienić metryki tras - np. dla wspomnianej 10.12.34.1/24 (i IP lokalnego interfejsu z końcówką XYZ)

<pre class="lang:default EnlighterJSRAW">route change 10.12.34.0 mask 255.255.255.0 10.12.34.XYZ metric 1</pre>

Po ponad 3 miesiącach testów ZeroTier okazał się maksymalnie stabilny i bezproblemowy - na ten moment backupy w mojej sieci lecą właśnie po nim i nie doświadczyłem żadnych przerw.

&nbsp;

&nbsp;

 [1]: http://zerotier.com
 [2]: https://github.com/zerotier/ZeroTierOne
 [3]: https://github.com/danielskowronski/zegar-delta