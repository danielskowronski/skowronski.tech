---
title: Niedziałanie skanerów zasilanych po USB (Linux, Windows)
author: Daniel Skowroński
type: post
date: 2016-01-27T18:41:13+00:00
excerpt: 'Niemal wszytskie domowe lub przeznaczone do małych biur skanery wolnostojące (a więc nie będące częścią kombajnu drukująco-skanującego) są obecnie zasilane po USB - ma to trochę sensu - zasilacz, który obniżałby napięcie dla jednej płytki drukowanej, silniczka i kilku LEDów to rzecz zbyteczna. Generuje to jednak problem przy współpracy z niektórymi komputerami. '
url: /2016/01/niedzialanie-skanerow-zasilanych-po-usb-linux-windows/
tags:
  - hardware

---
Niemal wszytskie domowe lub przeznaczone do małych biur skanery wolnostojące (a więc nie będące częścią kombajnu drukująco-skanującego) są obecnie zasilane po USB &#8211; ma to trochę sensu &#8211; zasilacz, który obniżałby napięcie dla jednej płytki drukowanej, silniczka i kilku LEDów to rzecz zbyteczna. Generuje to jednak problem przy współpracy z niektórymi komputerami. 

Konfigurując Canona LiDe 220 pod Windowsem na pececie-rzęchu zainstalowałem sterowniki, ale dostałem błąd że skaner jest zablokowany. Skanery zazwyczaj mają blokadę przesuwu głowicy &#8211; tak by podczas transportu się nie przemieszczała. Oczywiście ja zgodnie z instrukcją ją zwolniłem.  
Podpinam do laptopa z Linuksem &#8211; działa. Uznałem, że to wina nietypowej konfiguracji tamtej stacji roboczej (Windows Server 2008 R2). Po testach poszedłem do stacji na której docelowo miał pracować ten skaner (taki sam pecet z mobo Gigabyte, ale pod kontrolą Ubuntu). Coś tam ruszył głowicą, ale sypnął błędem I/O. Za sugestią na forum ubuntu zainstalowałem najnowszą developerską wersję SANE. Dalej to samo (zresztą pod Windowsem podobne zachowanie).  
Aż mnie oświeciło i postanowiłem użyć najkrótszego kabla USB jaki znalazłem. I zadziałało. Kabel dostarczony był za długi i stawiał za duży opór ograniczając tym samym prąd dostarczany. Co prawda na niskim DPI kiedy skaner bardzo szybko przesuwa głowicę podświetlenia z jednego końca szyny nie starcza do drugiego i skany po prawej mają pionowe pasy, ale zwiększenie DPI do więcej jak 300 pomaga (problemu w ogóle nie ma przy dobrym zasilaniu USB). Rozwiązanie &#8211; kabel Y (samoróbka albo za 10zł w x-komie) lub aktywny hub usb (taki z zasilaczem).

Problem stanowi zbyt niski amperaż dostarczany przez kontroler USB &#8211; skaner wymaga 500mA i po żądaniu powinien (zgodnie ze standardem) tyle dostać. W BIOSie (swoją drogą najnowszym) żadnych związanych z tym ustawień nie ma.

Przy okazji przydatny link do do szukania czy skaner jest zgodny z SANE &#8211; <http://www.sane-project.org/cgi-bin/driver.pl>.

Przy okazji #2: skaner, poza zasilaniem po USB na rzęchach, sprawuje się świetnie. 10 sekund na skan A4 @300dpi to czas wyśmienity jak na urządzenie za 300zł.