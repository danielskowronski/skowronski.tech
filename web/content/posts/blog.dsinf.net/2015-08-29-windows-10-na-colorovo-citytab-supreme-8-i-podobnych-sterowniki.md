---
title: Windows 10 na Colorovo CityTab Supreme 8 i podobnych – sterowniki
author: Daniel Skowroński
type: post
date: 2015-08-29T17:32:04+00:00
excerpt: Po długiej walce z bezsensownym błędem i przez nikogo nieprzewidzianym scenariuszu instalacji udało mi się postawić Windows 10 na tablecie Colorovo CityTab Supreme 8. Opiszę zestaw metod, które powinny działać na wszelkich podobnych platformach (Intel SoC).
url: /2015/08/windows-10-na-colorovo-citytab-supreme-8-i-podobnych-sterowniki/
tags:
  - colorovo
  - hardware
  - kionix
  - tablet
  - windows 10

---
Po długiej walce z bezsensownym błędem i przez nikogo nieprzewidzianym scenariuszu instalacji udało mi się postawić Windows 10 na tablecie Colorovo CityTab Supreme 8. Opiszę zestaw metod, które powinny działać na wszelkich podobnych platformach (Intel SoC).

Zacznę od najważniejszego, które zmogło mnie na półtora dnia: jak już mamy fantazję ściągać obraz z MSDNu i oszczędzać na miejscu to trzeba wiedzieć, że wersje windowsa oznaczone **N** i KN są bez Windows Media Playera. A bez niego (a raczej tego co dostarcza) nie działają sensory obrotu i kamery. Jeśli już ma się tą N-kę to można pobrać [Media Feature Pack for N and KN versions of Windows 10][1] od Microsoftu. I pomoże.

Istota wpisu, czyli sterowniki. Działają w 100% te z Win8.1. Można albo jakiś narzędziem je zbackupować, albo pobrać. Colorovo (a raczej jego polski dystrybutor ABC Data) uciął dostęp do tych sterowników i robi straszne roszady na oficjalnym FTP więc ludzie pomirrorowali. Na przykład [tutaj][2]. W razie czego można próbować szczęścia ze sterownikami od innych tabletów i instalować w ciemno (raczej nic nie zepsujemy). Warto googlać po nazwie urządzenia, ew. hardware ID. Podobne urządzenia ma <strike title="mój błąd - uwagę zwrócił Piotr Plenzler">Ondo i Dell</strike> Onda i HP (zwłaszcza ich Stream 7).

Instalacja wymaga wejścia do menadżera urządzeń (devmgmt.msc), do właściwości pierwszego z brzegu urządzenia z wykrzyknikiem, właściwości, sterownik, aktualizuj, przegladaj mój komputer... i wskazania ścieżki wypakowanej paczki. I tak po kolei dla każdego urządzenia - a będzie ich przybywać, bo jak już zainstalujemy sterowniki GPIO, I2C, UART i innych magistrali to system wychwyci, że do nich wpięte są kolejne urządzenia. Sensor obrotu (Kionix'a) i Bluetooth wymagają odpalenia pliku exe który jest w paczce i odpowiednim katalogu. Po restarcie zgaśnie led przy aparacie a system zacznie śmigać - bo bez sterowników "GPU" (w ciapkach, bo intelowskiego) wszystko liczy się na CPU.

Jeżeli wystąpi problem z rotacją może być wymagane załadowanie wpisu rejestru.

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ROOT\SENSOR\0000\Device Parameters\kxfusion]
"ACPI\SMO8500\1-0"="{DBCFFCEA-38C5-4386-9945-92F183AA5700}"
"Orientation"=hex:01,00,00,00,01,01,02
```


To wymusi prawidłowy obrót - a przynajmniej na Colorovo CityTab Supreme 8 H. Na inne urządzenia trzeba poeksperymentować z wartościami w hexie lub pogooglać podobnych wpisów dla konkretnych urządzeń. Klucz zaczynajacy się od ACPI zależy takze od urządzenia. Teoretycznie bez niego Windows załapie o co chodzi. W razie problemów można znowu posiłkować się googlem.

Jeśli jednak mamy backup windowsa to można odzyskać klucze rejestru. Jeśli obraz dysku mamy robiony dd-kiem pod linuksem to montujemy `mount -o ro,loop,offset=<początek partycji w bajtach, odczytane z parted> plik.img /mountpoint`, kopiujemy plik `Windows/System32/config/DEFAULT` i na Windowsie (koniecznie prawdziwym windowsie - wine nie pomoże) odpalamy edytor rejestru, stajemy na HKEY\_LOCAL\_MACHINE, plik->załaduj gałąź rejestru i nawigujemy się gdzie trzeba. Uwaga: zamiast CurrentControlSet trzeba użyć ControlSet00X (np. 001) - inny windows nie wie co było obecnym zestawem dla gałęzi załadowanej z pliku więc nie utworzy nam wirtualnego dowiązania.

 [1]: https://www.microsoft.com/en-us/download/details.aspx?id=48231
 [2]: http://przeklej.org/file/download/6XKd9wxfRsV7lWPFoejk