---
title: Kindle Comic Converter na Linuksie – zbiór rozwiązań problemów
author: Daniel Skowroński
type: post
date: 2014-08-24T21:24:03+00:00
excerpt: |
  <a href="http://kcc.iosphe.re/">![KCC Logo](/wp-content/uploads/2014/08/KCCLogo-1024x204.png)</a><a href="http://kcc.iosphe.re/">Kindle Comic Converter</a> to świetne narzędzie do konwersji grafiki (w zamierzeniu zawierającej komiksy /mangę) w formatach PNG, JPG, GIF, CBZ, CBR, CB7 lub PDF na EPUB lub MOBI z zastosowaniem różnych zmian tak, żeby działały i wyglądały na wskazanym czytniku (presety dla wszystkich edycji Kindle i Kobo + własne preferencje). Lista modyfikacji, które można zaaplikować obrazkom jest długa i zawiera m.in. tryb manga (RTL), obracanie, rozciąganie, przycinanie, tryb webtoon, poprawę marginesów...
  
  Ogromny plus dla autorów, że działa wszędzie (czyt. Windows+Linux+OS X). Jest jednak jedno ale - <strong>postawić to na Linuksie - to wyzwanie tylko dla power-userów z kilkuletnim stażem. A więc... do dzieła!</strong>
url: /2014/08/kindle-comic-converter-na-linuksie-zbior-rozwiazan-problemow/
tags:
  - kindle
  - linux

---
![KCC Logo](/wp-content/uploads/2014/08/KCCLogo.png)[Kindle Comic Converter][1] to świetne narzędzie do konwersji grafiki (w zamierzeniu zawierającej komiksy /mangę) w formatach PNG, JPG, GIF, CBZ, CBR, CB7 lub PDF na EPUB lub MOBI z zastosowaniem różnych zmian tak, żeby działały i wyglądały na wskazanym czytniku (presety dla wszystkich edycji Kindle i Kobo + własne preferencje). Lista modyfikacji, które można zaaplikować obrazkom jest długa i zawiera m.in. tryb manga (RTL), obracanie, rozciąganie, przycinanie, tryb webtoon, poprawę marginesów...

Ogromny plus dla autorów, że działa wszędzie (czyt. Windows+Linux+OS X). Jest jednak jedno ale - **postawić to na Linuksie - to wyzwanie tylko dla power-userów z kilkuletnim stażem. A więc... do dzieła!**

Wymagania, które są nam stawiane na samym początku są całkiem spore, a instrukcje od autorów - tylko dla debianowców (patrz: readme.md). Po kolei:  
**kindlegen** czyli strasznie własnościowa binarka od Amazona do tworzenia MOBI. Nieobowiązkowa, jak tworzymy EPUBy. Dostępna [na ich stronie][2], na szczęście wersja na wszystkie OSy (w końcu Kindle stoją na Linuksach). Wgrać należy gdziekolwiek do PATHa, a najlepiej do <span class="lang:default EnlighterJSRAW  crayon-inline " >/usr/local/bin</span> .  
**Python 3.3+** - ale to akurat jest wszędzie tam, gdzie Kernel 3+. Uwaga: nie wszędzie /usr/local/bin/python linkuje do pythona-3.x, czasem jest to python-2.x. Niby #! deklaruje chęć użycia wersji trzeciej, ale jakby co - warto w pliku .desktop dodać uruchamianie _via_ python3.  
**PyQt5**, czyli _hooki_ Qt5 dla Pythona. Dla openSUSE i innych erpeemowców oraz m.in. Arch'a i Gentoo pakiet nazywa się <span class="lang:default EnlighterJSRAW  crayon-inline ">python3-qt5</span> , opcjonalnie: <span class="lang:default EnlighterJSRAW  crayon-inline ">python-qt5</span> , debiany i pochodne mają <span class="lang:default EnlighterJSRAW  crayon-inline">pyqt5</span>. Uwaga: w openSUSE jak zawsze trzeba przejrzeć bogate w wyniki [software.opensuse.org][3] [odpowiedni [plik YMP][4]].  
**Pillow 2.5.0+**. To jest pakiet pythona, wiec pod żadnym pozorem nie szukamy pakietów dystrybucji tylko ciągniemy PIP (wewnętrzny menadżer pakietów). Pakiet standardowo nazywa się <span class="lang:default EnlighterJSRAW  crayon-inline " >python-pip</span> i powinien mieć w zależnościach pakiety deweloperskie pythona - <span class="lang:default EnlighterJSRAW  crayon-inline " >python-devel</span> w normalnych systemach lub <span class="lang:default EnlighterJSRAW  crayon-inline " >python-dev</span> w pochodnych Debiana. Jak nie ma to musimy ręcznie zainstalować.  
Po zainstalowaniu PIPa wydajemy jako superużytkownik komendę <span class="lang:default EnlighterJSRAW  crayon-inline " >pip install pillow</span>.  
**Psutil 2.0+** - jak wyżej - <span class="lang:default EnlighterJSRAW  crayon-inline " >pip install psutil</span>.  
**Slugify** - jak wyżej (choć ten akurat bywa w repozytoriach) - <span class="lang:default EnlighterJSRAW  crayon-inline " >pip install slugify</span>.  
**Inne**, a wśród nich: 7zip (co dystrybucja to inna nazwa, poddaję się z wymienianiem, jednak zwykle zaczyna się na p7zip), unrar (jeśli plik wejściowy jest rar'em).

Problem, który możemy napotkać, szczególnie na czystych systemach - **problemy z dekodowaniem obrazków, a konkretniej sypanie błędami od razu** (i przerywanie pracy). Problem polega na tym, że program nie sprawdza, czy w systemie jest biblioteka umiejąca obsłużyć obrazki. Bo i po co? Pakiety: <span class="lang:default EnlighterJSRAW  crayon-inline " >libjpeg-devel</span> /<span class="lang:default EnlighterJSRAW  crayon-inline " >libjpeg-dev</span> i <span class="lang:default EnlighterJSRAW  crayon-inline " >libpng-devel</span> /<span class="lang:default EnlighterJSRAW  crayon-inline " >libpng-dev</span>.  
Uwaga: po dodaniu bibliotek trzeba ponownie zainstalować Pillow'a - <span class="lang:default EnlighterJSRAW  crayon-inline " >pip install pillow</span>.

Kolejny problem to **global name 'unicode' is not defined** w pliku podobnym do <span class="lang:default EnlighterJSRAW  crayon-inline " >/usr/lib/python3.3/site-packages/slugify.py</span>. Przyczyna - nieaktualny Slugify. Pobieramy [ze strony PyPI][5] wersję 0.0.9 (serio, to jest najnowsza - z sierpnia), rozpakowywujemy i instalujemy (znowu jako root) - <span class="lang:default EnlighterJSRAW  crayon-inline " >python3 setup.py install</span>.

Jeśli nadal są błędy to celem debugowania polecam pobrać wersję nieskompilowaną (z Githuba) i sprawdzać linia po linii co zawodzi (na szczęście autorzy rozsądnie posługiwali się try...catch...'em więc łatwo wyłapać zawodzącą linijkę /linijki /funkcje /pliki...).

A jak nie mamy cierpliwości? To pobieramy wersję dla Windowsa i odpalamy przez Wine - mniej zachodu 😛

 [1]: http://kcc.iosphe.re/
 [2]: http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
 [3]: http://software.opensuse.org
 [4]: http://software.opensuse.org/download.html?project=KDE%3AQt5&package=python3-qt5
 [5]: https://pypi.python.org/pypi/python-slugify