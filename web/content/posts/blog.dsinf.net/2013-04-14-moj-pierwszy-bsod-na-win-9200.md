---
title: Mój pierwszy BSOD na Win 9200
author: Daniel Skowroński
type: post
date: 2013-04-14T19:56:21+00:00
url: /2013/04/moj-pierwszy-bsod-na-win-9200/
tags:
  - windows
  - windows 8

---
Jak do tej pory w czasie mojej niemal dziewięciomiesięcznej przygody z Windowsami kompilacji 9200 (dwie instancje ósemki i trzy Server 2012) nie miałem ani razu _bluescreena_. Aż do dziś.  
<!--break-->

  
Wcześniej wiele razy Windows dostawał zwiechy - albo wystarczyło odczekać parę(set) chwil i system zaczynał odpowiadać (oczywiście realizując wszystkie kliknięcia po kolei - łącznie z Ctrl+alt+Del), albo ubijało się go twardym resetem. Ale nie dziś. Dzień jak co dzień - system trochę muli, czasem dostaje czkawki. Aż po którymś razie - bum!  
Ni z tego ni z owego pojawiła się "animacja" rodem z gier na MS-DOS - ekran odrysowywany kafelkami w rzędach. Z czarnego po którym początkowo latała myszka na kolor Windowsa i nieba, czyli niebieski. Z białymi literkami. Literki tak nie wyraźne jak oglądany przeze mnie niedawno film z VCD (352x288 px) i do tego nie na całość ekranu - ewidentna czarna ramka, jak w monitorach CRT przy których grzebał ktoś z ekipy Młota Hefajstosa. I nawet smutnej minki nie było!  
Porwałem za świeżo sczyszczony telefon i szybko zrobiłem zdjęcie przynaglany postępującym dumpem pamięci. Cóż, Windows był tak leniwy, ze mimo zapowiedzi nie raczył się zrestartować.  
Dosyć podejrzliwy pomogłem komputerowi w przewrotce, ale produkt MS uspokoił mnie - to nie był żaden wirus tylko prawdziwy błąd. Z tego co widać (a raczej nie widać) na zdjęciu to problem z Nvidią (coś w rodzaju SCREEN i TOR było napisane, ale bardzo nieczytelnie). Fakt - sterownik mocno naciągany bo przerobiony ten dla siódemki i visty - raz już rozsadził DWM tak, że się zrestartował cały menadżer okien.  
Bluescreena na mojej ósemce widzę po raz drugi - wcześniej, jeszcze na kompilacjach bodajże 7XXX (około M2) antywirusy odmawiały współpracy.