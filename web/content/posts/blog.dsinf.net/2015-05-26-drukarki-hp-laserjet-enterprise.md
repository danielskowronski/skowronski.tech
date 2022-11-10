---
title: Drukarki HP Laserjet Enterprise
author: Daniel Skowroński
type: post
date: 2015-05-26T19:43:32+00:00
excerpt: Konfigurowanie zwykłych drukarek HP w choć trochę nietypowym środowisku (gdzie typowe = Win7 x86, łącze po USB) to mordęga, ale Laserjet Enterpeise to już tragedia. Kilka porad po tym jak uporałem się z Laserjetem 500.
url: /2015/05/drukarki-hp-laserjet-enterprise/
tags:
  - drukarka
  - hp

---
Konfigurowanie zwykłych drukarek HP w choć trochę nietypowym środowisku (gdzie typowe = Win7 x86, łącze po USB) to mordęga, ale Laserjet Enterpeise to już tragedia. Kilka porad po tym jak uporałem się z Laserjetem 500.

Problem polegał na tym, że w LANie drukarka &#8222;się dodawała i drukowała&#8221;, ale z zewnątrz mimo przekierowań portów była głucha na polecenia.

Po pierwsze &#8211; aktualziacja firmware&#8217;u. W web-gui jest pod _General > Firmware upgrade_, obrazy pobieralne są ze strony HP, najprościej wyszukać nasz model po numerze seryjnym. Warto zaznaczyć, że żadne ustawienia nie zostaną skasowane. HP wypuszcza aktualizacje i łatają aktualne problemy (np. POODLE), ale i dodają funkcjonalności (ten model dostał natywnego Google Cloud Printa).

Druga sprawa &#8211; opuszczamy GUI i wchodzimy w konsolę, a konkretniej telnet. PuTTY może być przydatny na Windowsie bez dodanej funkcji &#8222;klient telnet&#8221;. Dostępne jest menu konfiguracyjne, które daje ciut więcej możliwości niż webowy odpowiednik (jak ręczne dodawanie raw-portów, które jakimś sposobem miałem niekatywne przez co wydruk poza siecią lokalną przez NAT był niemożliwy). Warto używać telnetu do automatyzacji zarządzania drukarką.

Warto zwrócić uwagę, że jeśli dodajemy drukarkę do komputera w tej samej sieci LAN to zostanie użyty protokół DOT4, a nie stanadrdowy TCP/IP więc przy wynoszeniu komputera poza sieć nawet dodanie drukarki do DMZ routera nie wystarczy &#8211; trzeba ręcznie skonfigurować &#8222;9100 printing&#8221;, czyli dostęp RAW do portu LPT/USB po TCP. Może się zdarzyć, że jest to niewyklikiwalne, mimo długiej listy protokołów dostępnych do konfiguracji.