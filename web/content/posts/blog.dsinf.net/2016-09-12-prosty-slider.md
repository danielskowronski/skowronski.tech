---
title: Prosty slider
author: Daniel Skowroński
type: post
date: 2016-09-12T18:22:21+00:00
excerpt: 'Znalezienie prostego (czyli nie wymagającego includowania tony pluginów do jQuery i pisania konfigu na kiladziesiąt linii) slidera w HTML proste nie jest. Dlatego napisałem własny - sflider (od oryginalnego projektu - sflider - SFI slider).'
url: /2016/09/prosty-slider/
tags:
  - css
  - html
  - javascript
  - webdev

---
Znalezienie prostego (czyli nie wymagającego includowania tony pluginów do jQuery i pisania konfigu na kiladziesiąt linii) slidera w HTML proste nie jest. Dlatego napisałem własny - sflider (od oryginalnego projektu - **<span style="text-decoration: underline;">sf</span>l<span style="text-decoration: underline;">i</span>der** - SFI slider).

Istnieje co prawda opcja oparcia takowego na samym CSS3 i jego atrybucie animation (np. <https://www.smashingmagazine.com/2012/04/pure-css3-cycling-slideshow/>), ale dodanie potem sterowania (poprzedni/następny) jest niemożliwe w wygodny sposób (-> <https://css-tricks.com/controlling-css-animations-transitions-javascript/>) - prosto spauzujemy i wznowimy animację (swoją drogą jak zwykle "kompatybilnie" potrzeba nam dwóch reguł - jednej zwykłej i drugiej z <span class="lang:default EnlighterJSRAW crayon-inline ">-webkit-*</span> ), po przyłożeniu się obliczmy aktualny slajd (ale przejścia są kolejnymi klatkami animacji więc można spauzować w połowie przejścia), a po trudnej pracy zmodyfikujemy klatki animacji żeby jakoś na nią wpłynąć.  Najlepiej przerzucić się na jQuery który w swoim zestawie funkcji **animate** wykorzystuje CSSowy silnik animacji i jest konfigurowalny.

W projekcie **sflider** wykorzystałem kilka wartych wspomnienia rozwiązań:

  * Chcąc osiągnąć pauzowanie przejść animacji po najechaniu myszką bez resetowania odliczania (żeby nie wystąpił efekt że po każdym wyjechaniu myszą ze slajdera czas do następnego przejścia zawsze wynosił przykładowo 5 sekund) a jednocześnie resetowanie odliczania po ręcznej nawigacji (żeby po kliknięciu "wstecz" w czwartej z pięciu sekund odstępu i opuszczeniu slidera nie stracić aktualnego widoku z oczu) wykorzystałem fakt iż <span class="lang:default EnlighterJSRAW crayon-inline">setTimeout</span>  zwraca handle do timera (podobnie jak <span class="lang:default EnlighterJSRAW crayon-inline ">setInterval</span> ), który można podstawić do zmiennej, a następnie zniszczyć funkcją <span class="lang:default EnlighterJSRAW crayon-inline ">clearTimeout</span> .  
    Zastosowana logika jest następująca: stworzenie slidera powołuje pierwszy setTimeout, funkcja przezeń wołana chainowo tworzy kolejny i tak w kółko - efekt podobny do emulowania setInterval. Ale inna funkcja może ten licznik zresetować bez większych problemów.
  * Własna implementacja dzielenia modulo bo JavaScript wariuje na liczbach ujemnych (a to ci niespodzianka).
  * Budowa slidera jest następująca: duży div zawiera mniejsze o tej samej wysokości (<span class="lang:default EnlighterJSRAW crayon-inline ">display: inline-block;</span> )co rodzic ale o szerokości ekranu (<span class="lang:default EnlighterJSRAW crayon-inline ">position: relative; width: 100%;</span> ) -wtedy rodzic ma szerokość n*100% (n - ilość slajdów). Zmiana widoku odbywa się poprzez zmianę parametru offsetu <span class="lang:default EnlighterJSRAW crayon-inline ">left</span> - może być zwykłą animacją, może być zapewne na jakieś inne sprytne sposoby. Ważna uwaga - wielkość fontu diva rodzica musi być ustawiona na zero - inaczej białe znaki (np. łamanie linii + taby) które HTML zawsze zwinie do jednej spacji utworzą nieoverridowalny margines między divami (inline-block!) który spowoduje że mimo układu: n divów po 100% w divie szerokości n*100% ostatni nie zmienści się w wierszu. Jeśli używamy np. bootstrapa lub jakkolwiek overridujemy styl fonta divów ze slajdami to nie musimy nic robić, jednak w przeciwnym wypadku trzeba wymusić czcionkę bo zdziedzicy się ona do zerowej.
  * Automagia polega na przerzuceniu liczenia szerokości divów slajdów względem rodzica na javascript - jest to zbyt skomplikowanie dla CSS na ten moment.

Kod źródłowy: <https://github.com/danielskowronski/sflider>

Demo: https://blog.dsinf.net/wp-content/uploads/2016/09/sflider-demo/01_simple.html