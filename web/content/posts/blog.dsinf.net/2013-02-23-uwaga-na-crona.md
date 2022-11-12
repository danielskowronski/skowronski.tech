---
title: Uwaga na cron’a!
author: Daniel Skowroński
type: post
date: 2013-02-23T00:14:04+00:00
url: /2013/02/uwaga-na-crona/
tags:
  - bash
  - cron
  - linux

---
Cron to jeden z przejawów uporządkowania w Linuksie - przejrzysta struktura crontab, katalogi na zadania _daily_, _hourly_ itp. Ale jest kilka zawiłości, na które koniecznie trzeba zwrócić uwagę.  
<!--break-->

Po pierwsze bądźmy pewni, że znamy kolejność kolumn:

<pre class="EnlighterJSRAW bash">MIN HOUR DAY MONTH WEEKDAY USER COMMAND
</pre>

Najczęstszy błąd to oczywiście odruch użycia 

<pre class="EnlighterJSRAW bash">12 54 * * * root cos</pre>

jako skryptu o 12:54. Ten skrypt uruchomi się 12 minut po pięćdziesiątej czwartej.  
Kolejna kwestia: niedziela. Ma numer 0, czy 7. Otóż oba. Stąd trzeba uważać bo odruch programisty C++ każe wszystko iterować od zera. Ale jeśli zaczynaliśmy od JavaScriptu to jesteśmy uratowani 😉 (w JS niedziela to 0).

Coś na co sam się naciąłem to zmienna środowiskowa PATH. Druga linijka pliku /etc/crontab definiuje ją. Łatwo popełnić błąd dodając u siebie jakiś katalog do path'a i dodając goły skrypt do crona. Nic z tego - będzie problem. I nie jest wcale o to tak trudno: jeden z programów zażyczył sobie wgrać się do /usr/local/bin. Dlatego najlepiej używać ścieżek bezwzględnych i dodać nasze katalogi z binarkami do PATHa pliku crontab dla bezpieczeństwa.

Innym zagrożeniem jest pierwsza linia crontab'a: 

<pre class="EnlighterJSRAW bash">SHELL=/bin/sh</pre>

Jest o tyle niebezpieczna, że jeśli nie zaczynamy naszych skryptów basha od standardowego 

<pre class="EnlighterJSRAW bash">#!/bin/bash</pre>

to możliwe, że zajmie się nami starsza i bardziej uboga w funkcje klasyczna powłoka Unixa. Grozi nam to na bardziej niestandardowych lub starych systemach. Zwykle jest to link do bash'a, ale jeśli nie to może się okazać, że cudowne polecenia i _oneliner'y_ zawiodą.