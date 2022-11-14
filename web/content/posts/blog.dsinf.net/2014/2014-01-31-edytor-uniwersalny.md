---
title: 'W poszukiwaniu edytora uniwersalnego [Sublime Text]'
author: Daniel Skowroński
type: post
date: 2014-01-30T23:04:50+00:00
summary: |
  Edytor to najważniejsze narzędzie każdego informatyka niezależnie od jego specjalności. Od wyboru głównego edytora zależy komfort codziennej pracy.<br />
  Artykuł jak najbardziej subiektywny :)
url: /2014/01/edytor-uniwersalny/
tags:
  - edytor
  - linux
  - sublime text

---
Edytor to najważniejsze narzędzie każdego informatyka niezależnie od jego specjalności. Od wyboru głównego edytora zależy komfort codziennej pracy. Artykuł jak najbardziej subiektywny 🙂

![n++](http://www.zoneas.com/images/icons/notepad.png "Notepad++") Na Windowsie wybór jest oczywisty - **Notepad++**. Ma system pluginów, zaznaczanie kolumnowe, szukanie i zamienianie przez wyrażenia regularne, całkiem przyzwoite motywy, dobrze radzi sobie z dużymi plikami w dużej ilości, zapamiętuje niezapisane pliki, posiada zakładki oraz umie otworzyć dwa pliki obok siebie w podzielonym widoku (jak Terminator pod Linuksem) [itp.][1]  
<br clear="all" />  
Na Linuksie powstaje problem.

![gedit](http://osx.wdfiles.com/local--files/icon:gedit/gedit.png "gedit") Początkujący i średniozaawansowany użytkownik nie-KDE powie: **Gedit**. Funkcje są tylko podstawowe (rzecz jasna sporo więcej od notatnika z MS Windows), ale solidny i wystarczający. Cóż... po tym co wyczynia zespół Gnome'a można tkwić w Gnome 2, albo nie używać gedita. Wariactwo zwane Gnome 3 ma w taki oto sposób okaleczyć jeden z najważniejszych edytorów tekstowych z GUI:  
![Gedit z nowym interfejsem](http://www.omgubuntu.co.uk/wp-content/uploads/2014/01/gedit2.jpg "Gedit z nowym interfejsem")  
Aż patrzeć smutno.<br clear="all" />  
![leafpad](http://svgicons.o7a.net/official/leafpad.png "leafpad") Jako szybka alternatywa jest **Leafpad** - ma interfejs i funkcje z dawnych wersji; popularny zasadniczo w XFCE.  
<br clear="all" />  
![kate](https://cdn1.iconfinder.com/data/icons/nuvola2/128x128/apps/kate.png "kate") Użytkownik KDE powie: **Kate**.<br clear="all" /> Ale kochana Kate ma trzy wady: 

  1. wymaga całego dyskożernego KDE
  2. jest w stylu nowego KDE
  3. wymaga całego KDE

Z tego powodu niektórzy ludzie kurczowo trzymają się Kubuntu - bo jest Kate. Z ważnych funkcji należy wymienić tryb pracy jako IDE do niektórych języków, obszerne pola wyszukiwania funkcji i ładne kolorowanie składni. Cóż, jako edytor uniwersalny się nie nadaje.  
![kate](http://kate-editor.org/wp-content/uploads/2014/01/kwrite.png "kate") 

Są i tacy (jedni to super-power-guru Unixowi, drudzy to dzieciaki, które ledwo co odpaliły gnome-terminal na Ubuntu), co powiedzą **vi**, albo co gorsza **emacs**. 

Vi jest prawdziwie uniwersalne - jest wszędzie. Zatem trzeba go umieć obsłużyć (jeśli nie wiesz co robią komeny`:q :q! :wq / dd` i używasz Linuksa jako administrator to wypada się podszkolić bo jak nie uda się wystartować inita to gedita nie będzie).  
Mała dygresja: na Linuksach nie ma już vi - jest Vim w trybie zgodności z vi (poznać można po helpie wyświetlanym po uruchomieniu bez pliku). Ale na FreeBSD czy gołym Unixie jest tylko vi. Swoją drogą zagadka: <a onClick="alert('Posadzić newbie przed vi z klawiaturą dvoraka i kazać mu wyjść z programu');">Jak stworzyć idealny generator losowy?</a>  
Tak, wiem, że teraz lansowany jest nano - ma przyjazne sterowanie widoczne cały czas, ale przyzwyczajenie się do niego to nic dobrego. Dla mnie tym co go wyklucza jest komenda zapisująca - `Ctrl+O` - taka sama jak przełącznik konsoli i commandera w MC - czasem używam innego niż wbudowany edytor w trakcie pracy z plikami w Midnight Commanderze. Ctrl+O ubija jakąkolwiek komunikację - dostęp stracony.  
Ostatnia dygresja: jak na szybko zamknąć vi? `Ctrl+Z` 😉

![St. Ignucius](http://static3.wikia.nocookie.net/__cb20051225123709/uncyclopedia/images/b/bb/Ignucius.jpg "St. Ignucius") Emacs to dla mnie koszmar jeśli chodzi o edytory - poza wszystkim co można wymyślić w trybie edycji plików mamy klienta poczty, przeglądarkę WWW, _PIM_ (Personal Information Manager - np. kalendarz, kontakty) i chyba tylko sam [święty iGNUcjusz][2] wie jeszcze.  
Przypomina to coś w rodzaju:  
![](http://www.ultraedit.com/assets/images/ppUE/htmltools.png)  
tylko, że w konsoli tekstowej z miliardem dziwnych skrótów klawiaturowych.

Z konsolowych jest jeszcze mój ulubieniec - **mcedit** będący częścią Midnight Commander'a. Potrafi podświetlać składnię, szukać w pliku, oraz kopiować, wklejać i tym podobne proste zadania wykonywać. Ma zasadniczą zaletę - łatwo go ogarnąć: poza akcjami przypisanymi do F1-F10 opisanymi na dole (dziedzictwo Norton Commandera, znane windowsowcom m.in. z Total Commandera) trzeba znać tylko Ctrl+Ins, Shift+Ins i Shift+Del (kolejno: kopiuj, wklej, skasuj zaznaczenie - intuicyjnie strzałki+shift). Bardzo prosty, ale najwygodniejszy do prostych edycji - zwłaszcza przez Putty'ego gdy [Esc] wariuje.  
![mcedit](http://sclive.files.wordpress.com/2006/07/mcedit.jpg "mcedit") 

![bluefish](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Bluefish-icon.svg/120px-Bluefish-icon.svg.png "bluefish") **Bluefish** jest aż za bardzo zorientowany an HTMLa - autowstawki, tablice znaków, FTP, podgląd w przeglądarce (nic dziwnego, że nazywał się Thtml editor). Najbliżej mu do Windowskowego kED'a.

![komodo edit](http://rocketdock.com/images/screenshots/komodo_edit.png "komodo edit") **Komodo Edit** jest doskonały dla tych, którzy programują w językach mających swoje wersje wydane przez ActiveState - Perl, Python, Tcl. Poza tym wyposażony w developerskie opcje dla WWW - np. przeglądarkę drzewa DOM, czy narzędzia do walidacji. 

![geany](http://upload.wikimedia.org/wikipedia/commons/a/a0/Geany_logo.svg "geany") Idąc dalej spotkamy **Geany** - przyjemny edytor, ale znowu - zbyt bardzo zintegrowane środowisko programistyczne zamiast edytora!  
<br clear="all" />  
![ultraedit](http://www.iconhot.com/icon/png/quiet/256/ultra-edit.png "ultraedit") **UltraEdit** to komercyjne wszystko-w-jednym-na-wszystkie-platformy. Przerost formy nad treścią - spójrz na screen obrazujący przerost emacsa - to właśnie UltraEdit. Okropna cena $80 za sam edytor - inne komponenty (np. odpowiednik diffa) to osobne produkty. Trial ograniczony czasowo.  
<br clear="all" />  
![sublime text](http://c758482.r82.cf2.rackcdn.com/sublime_text_icon_2181.png "sublime text") I na sam koniec mój ulubiony edytor. Niestety własnościowy. Niestety $70. Ale trial polega na tym, że co kilkanaście zapisów pokazuje dodatkowe okienko zachęcające do zakupu licencji (nieoficjalnie: jest [crack][3]). **Sublime Text**. Lista funkcji jest tak duża, że aż twórca na swojej stronie pominął niektóre. Poza tym co jest wszędzie znajdziemy w nim: 

  * skok do dowolnego miejsca - _goto anything_ (linii, funkcji, elementu DOM...)
  * natywnego HUD (menu z wyszukiwarką)
  * potężną zaznaczarkę - nie tylko kolumnowa /blokowa, ale wielosegmentowa (zaznaczamy trzy fragmenty tekstu i do nich _jednocześnie_ dopisujemy)
  * tryb nierozpraszający - wycentrowany fullscreen
  * tryb podziału okna - jak w Notepad++
  * mapę kodu - po prawej
  * oczywiście wewnętrzną konsolę bazującą na Pythonie, a więc tym samym kalkulator 🙂
  * dowolne transformacje tekstu - wielkość liter, podział na linie, komentowanie blokowe, wcięcia, ucinanie do linijki (np. do klasycznej szerokości 80 znaków)...

Pewną dziwnostką, a zarazem wyjątkowością jest brak graficznego edytora ustawień - z menu wykonamy polecenia i zmienimy z list rozwijanych podstawowe rzeczy - zmienimy język programowania do składni, motyw, czy rozmiar czcionki. Kliknięcie na "Settings - default", czy "Settings - user"... otworzy plik do edycji. Wszystkie z ładnymi komentarzami - można ustawić dowolne parametry, a by je zatwierdzić wystarczy plik zapisać. Oczywiście można także tworzyć pluginy i pobierać miliardy motywów.

![sublime text](http://www.sublimetext.com/screenshots/alpha_goto_anything2_large.png "sublime text")  
Lista przydatnych linków do subl'a:  
<ui>

  * [Strona domowa][4]
  * [Dokumentacja producencka][5]
  * [Nieoficjalna dokumentacja][6]
  * [Jedna ze stron opisujących sztuczki][7]
  * [Blog ze sztuczkami i opisami mnogich pluginów][8]
  * [Pierwsza strona z motywami][9]
  * [Druga strona z motywami][10]
  * [Subiektywny zbiór ładnych motywów][11]</li> 

&nbsp;  
&nbsp;  
Reasumując: moje ulubione edytory to graficzny Sublime Text (za potęgę funkcji i nie targetujący w żadne konkretne zastosowanie interfejs) i konsolowy mcedit (za elementy GUI i łatwość sterowania). A zawsze znać trzeba vi.

 [1]: http://notepad-plus-plus.org/features/
 [2]: http://uncyclopedia.wikia.com/wiki/St._Ignucius
 [3]: http://codifyme.wordpress.com/2013/02/04/convert-sublime-text-2-to-licensed-version/
 [4]: http://www.sublimetext.com/
 [5]: http://www.sublimetext.com/docs/3/
 [6]: http://docs.sublimetext.info/en/latest/index.html
 [7]: http://net.tutsplus.com/tutorials/tools-and-tips/sublime-text-2-tips-and-tricks/
 [8]: http://www.hongkiat.com/blog/sublime-text-tips/
 [9]: http://devthemez.com/themes/sublime-text-2
 [10]: http://colorsublime.com/
 [11]: http://www.masnun.com/2013/07/08/beautiful-themes-for-sublime-text-3.html