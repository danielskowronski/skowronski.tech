---
title: Niedziałający backspace, tab i control na konsoli linuksowej
author: Daniel Skowroński
type: post
date: 2015-05-20T08:10:36+00:00
excerpt: 'Dziwna sytuacja mnie ostatnio spotkała - na czystej instalacji openSUSE 13.2 na terminalach vtty nie działały mi.. backspace, tab i control (choć jakimś sposobem ctrl+alt+f* przełączał na inne terminale więc zamiast ctrl+c musiałem się przełączać na inny ekran i ubijać przez killall) oraz escape i jeszcze kilka innych. Objaw: albo niewidoczny znak (jak spacja, ale nie spacja) albo "?" czarny na białym tle. Po długich poszukiwaniach odnalazłem przyczynę tego nietypowego zachowania.'
url: /2015/05/niedzialajacy-backspace-tab-i-control-na-konsoli-linuksowej/
tags:
  - linux
  - opensuse

---
Dziwna sytuacja mnie ostatnio spotkała - na czystej instalacji openSUSE 13.2 na terminalach vtty nie działały mi.. backspace, tab i control (choć jakimś sposobem ctrl+alt+f* przełączał na inne terminale więc zamiast ctrl+c musiałem się przełączać na inny ekran i ubijać przez killall) oraz escape i jeszcze kilka innych. Objaw: albo niewidoczny znak (jak spacja, ale nie spacja) albo "?" czarny na białym tle. Po długich poszukiwaniach odnalazłem przyczynę tego nietypowego zachowania.

Ale po kolei.

Nie byłem w stanie uwierzyć, że to porysowana płyta uszkodziła Linuksowi rozpoznawanie backspace'a - i to nie była przyczyna (dla pewności puściłem md5 na płucie dvd).  
Jakoś nie dawałem też wiary drugiemu administratorowi, że to wina openSUSE ("tylko Debian/Gentoo!").

Pierwsze co sprawdziłem to rzecz jasna układ klawiatury i język systemowy - przez <span class="lang:default EnlighterJSRAW  crayon-inline ">localectl status</span> - i nic podejrzanego tam nie było.  
Prewencyjnie zresetowałem do en_US i klawiaturę na en-latin9 - <span class="lang:default EnlighterJSRAW  crayon-inline ">localectl set-keymap -no-convert en-latin9</span> ( <span class="lang:default EnlighterJSRAW  crayon-inline ">localectl list-keymaps</span> listuje dostępne) i dalej nic (oczywiście robiłem zarówno <span class="lang:default EnlighterJSRAW  crayon-inline ">reset</span> konsoli jak i całego systemu).

Naszło mnie na sprawdzenie, czy przypadkiem to nie wina hardware'u - maszyna na której stawiałem ma chyba jakiś lekki problem z USB - opcja z irqpoll nic nie dała (ale klawiatura USB w pewnej konfiguracji BIOSu zaczęła działać; po resecie do fabrycznych była zbędna). Komenda <span class="lang:default EnlighterJSRAW  crayon-inline ">showkeys</span> pokazała mi, że system poprawnie odczytuje kody klawiszy - escape miał 1, backspace 14, tab 15 itd. Wskazówka: showkeys przejmuje klawiaturę i zwalnia ją po 10 sekundach od ostatniego naciśnięcia - można przeoczyć tą informację przy niskiej rozdzielczości i szybkim przejeżdżaniu po klawiaturze).

Ponowne generowanie initramu z różną konfiguracją opcji sd-vconsole, keyboard i consolefont nie pomagało (przez <span class="lang:default EnlighterJSRAW  crayon-inline ">mkinitrd</span> lub <span class="lang:default EnlighterJSRAW  crayon-inline ">mkinitcpio</span> zależnie od dystrybucji).

W końcu uznałem, że warto sprawdzić ostatnią rzecz w locale - czcionkę. Pozornie bez wpływu na zachowanie backspace. Otóż nic bardziej mylnego. Zmiana n najbardziej ograniczoną jaką się da - pomogła. **<span class="font-size:14 lang:default EnlighterJSRAW crayon-inline ">setfont Lat2-Terminus16 -m 8859-2</span>**. Dopisanie w <span class="lang:default EnlighterJSRAW  crayon-inline ">/etc/vconsole.conf</span>

<pre class="lang:default EnlighterJSRAW " title="/etc/vconsole.conf">FONT=Lat2-Terminus16
FONT_MAP=8859-2</pre>

ustawia to na sztywno.