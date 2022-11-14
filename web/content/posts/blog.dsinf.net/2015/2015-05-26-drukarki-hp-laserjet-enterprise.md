---
title: Drukarki HP Laserjet Enterprise
author: Daniel Skowroński
type: post
date: 2015-05-26T19:43:32+00:00
summary: Konfigurowanie zwykłych drukarek HP w choć trochę nietypowym środowisku (gdzie typowe = Win7 x86, łącze po USB) to mordęga, ale Laserjet Enterpeise to już tragedia. Kilka porad po tym jak uporałem się z Laserjetem 500.
url: /2015/05/drukarki-hp-laserjet-enterprise/
tags:
  - drukarka
  - hp

---
Konfigurowanie zwykłych drukarek HP w choć trochę nietypowym środowisku (gdzie typowe = Win7 x86, łącze po USB) to mordęga, ale Laserjet Enterpeise to już tragedia. Kilka porad po tym jak uporałem się z Laserjetem 500.

Problem polegał na tym, że w LANie drukarka "się dodawała i drukowała", ale z zewnątrz mimo przekierowań portów była głucha na polecenia.

Po pierwsze - aktualziacja firmware'u. W web-gui jest pod _General > Firmware upgrade_, obrazy pobieralne są ze strony HP, najprościej wyszukać nasz model po numerze seryjnym. Warto zaznaczyć, że żadne ustawienia nie zostaną skasowane. HP wypuszcza aktualizacje i łatają aktualne problemy (np. POODLE), ale i dodają funkcjonalności (ten model dostał natywnego Google Cloud Printa).

Druga sprawa - opuszczamy GUI i wchodzimy w konsolę, a konkretniej telnet. PuTTY może być przydatny na Windowsie bez dodanej funkcji "klient telnet". Dostępne jest menu konfiguracyjne, które daje ciut więcej możliwości niż webowy odpowiednik (jak ręczne dodawanie raw-portów, które jakimś sposobem miałem niekatywne przez co wydruk poza siecią lokalną przez NAT był niemożliwy). Warto używać telnetu do automatyzacji zarządzania drukarką.

Warto zwrócić uwagę, że jeśli dodajemy drukarkę do komputera w tej samej sieci LAN to zostanie użyty protokół DOT4, a nie stanadrdowy TCP/IP więc przy wynoszeniu komputera poza sieć nawet dodanie drukarki do DMZ routera nie wystarczy - trzeba ręcznie skonfigurować "9100 printing", czyli dostęp RAW do portu LPT/USB po TCP. Może się zdarzyć, że jest to niewyklikiwalne, mimo długiej listy protokołów dostępnych do konfiguracji.