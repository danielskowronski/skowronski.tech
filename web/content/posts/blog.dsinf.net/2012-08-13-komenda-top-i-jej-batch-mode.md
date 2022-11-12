---
title: Komenda top i jej batch mode
author: Daniel Skowroński
type: post
date: 2012-08-13T17:46:00+00:00
url: /2012/08/komenda-top-i-jej-batch-mode/
tags:
  - bash
  - linux

---
Wśród czeluści parametrów **top**a można znaleść _batch mode_, który wg. man'a służy do zapisu do pliku: staje się nieinteraktywny i zrzuca całą swoją zawartość na standardowe wyjście do wystąpienia ^C lub konkretną ilość razy określaną przez parametr -n.  
Gdyby chcieć zapisać dane deo zmiennej żeby móc wyciągnąć z nich dajmy na to obciążenie procesora wywołamy komedę:

<pre class="EnlighterJSRAW bash">top -bn 1</pre>

Ale naszym oczom nie ukaże się aktualne obciążenie procesora tylko średnie od rozruchu. Tak samo zachowuje się interaktywny top po starcie: najpierw wartość średnia i dopiero drugie odświeżenie to wartość właściwa.  
Rozwiązanie problemu przychodzi po chwili zastanowienia. W kodzie parsera (np. Perlowym):

<pre class="EnlighterJSRAW perl">$top_raw=`top -bn 2`;
$top_pojedynczy = substr($top_raw, index($top_raw, "top - ", 1));
</pre>

Ważny szczegół: index musi zaczynać od offset'u równego 1, gdyż inaczej natrafiłby na nagłówek topa w pozycji zerowej tym samym nic nie robiąc.

Niestety dodanie parametru _delay_ (-d sekundy.dziesiąte_części) zaburza iteracje i wciąż wartością widzianą jest obciążenie średnie 🙁