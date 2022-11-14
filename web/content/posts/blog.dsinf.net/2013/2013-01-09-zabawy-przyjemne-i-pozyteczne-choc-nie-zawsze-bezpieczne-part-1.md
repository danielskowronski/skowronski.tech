---
title: Zabawy przyjemne i pożyteczne choć nie zawsze bezpieczne. Part 1.
author: Daniel Skowroński
type: post
date: 2013-01-08T23:22:03+00:00
url: /2013/01/zabawy-przyjemne-i-pozyteczne-choc-nie-zawsze-bezpieczne-part-1/
tags:
  - hardware

---
Postanowiłem zacząć cykl krótkich i pouczających historyjek o komputerach rzecz jasna. Jednak wszystkie muszą się zaczynać od _**nie próbuj tego w domu**_, a w części, do której ten wpis należy dodatkowo _**<u>robisz wszystko na własne ryzyko, artykuł w celach edukacyjnych, zrzekam się wszelkiej odpowiedzialności</u></i>**.</p> 

Jak "zhackować" napęd CD w laptopie (typu tacka, slot-in'y odpadają)?  
Bierzemy płytę RW. Dlaczego RW? Bo zwykłej szkoda tak marnować, a chodzi o to, żeby napęd zaczął coś wypalać. Odpalamy jakikolwiek program do wypalnia płyt np. Brasero, tworzymy jakikolwiek projekt lub otwierami ISO z Linuksem, czy Windowsem (nie pirackim rzecz jasna). W okienku obok powinna znaleźć się konsolka.  
Odpalamy wypalanie, pozwalamy napędowy się nieco rozpędzić i wydajemy polecenie

```bash
killall brasero
```


albo nazwę procesu innego programu, którą łatwo znaleźć w programie za pomocą funkcji wyszukiwania - F3.  
Po zabiciu brasero w odpowiednim momencie naped powinien ciągle wirować bo nie miało co przejąć /dev/sr0. 

Całości dopełni uniwersalne urządzenie do awaryjnego otwierania CD-ROMu (takie jak to poniżej) i voila: tacka z wciąż wirującą płytą i co lepsze aktywnym laserem poza obudową. Jako, że sterowniki pod Linuksem są fajniejsze to zajęło mu koło 2-3 sekund, żeby odłączyć zasilanie silniczka i wygasić laser, który był bardzo dobrze widoczny.