---
title: 'W poszukiwaniu edytora uniwersalnego [Sublime Text]'
author: Daniel Skowroński
type: post
date: 2014-01-30T23:04:50+00:00
excerpt: |
  Edytor to najważniejsze narzędzie każdego informatyka niezależnie od jego specjalności. Od wyboru głównego edytora zależy komfort codziennej pracy.<br />
  Artykuł jak najbardziej subiektywny :)
url: /2014/01/edytor-uniwersalny/
tags:
  - edytor
  - linux
  - sublime text

---
Edytor to najważniejsze narzędzie każdego informatyka niezależnie od jego specjalności. Od wyboru głównego edytora zależy komfort codziennej pracy. Artykuł jak najbardziej subiektywny 🙂

<img decoding="async" src="http://www.zoneas.com/images/icons/notepad.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="n++" /> Na Windowsie wybór jest oczywisty &#8211; **Notepad++**. Ma system pluginów, zaznaczanie kolumnowe, szukanie i zamienianie przez wyrażenia regularne, całkiem przyzwoite motywy, dobrze radzi sobie z dużymi plikami w dużej ilości, zapamiętuje niezapisane pliki, posiada zakładki oraz umie otworzyć dwa pliki obok siebie w podzielonym widoku (jak Terminator pod Linuksem) [itp.][1]  
<br clear="all" />  
Na Linuksie powstaje problem.

<img decoding="async" src="http://osx.wdfiles.com/local--files/icon:gedit/gedit.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="gedit" /> Początkujący i średniozaawansowany użytkownik nie-KDE powie: **Gedit**. Funkcje są tylko podstawowe (rzecz jasna sporo więcej od notatnika z MS Windows), ale solidny i wystarczający. Cóż&#8230; po tym co wyczynia zespół Gnome&#8217;a można tkwić w Gnome 2, albo nie używać gedita. Wariactwo zwane Gnome 3 ma w taki oto sposób okaleczyć jeden z najważniejszych edytorów tekstowych z GUI:  
<img decoding="async" src="http://www.omgubuntu.co.uk/wp-content/uploads/2014/01/gedit2.jpg" alt="Gedit z nowym interfejsem" />  
Aż patrzeć smutno.<br clear="all" />  
<img decoding="async" src="http://svgicons.o7a.net/official/leafpad.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="leafpad" /> Jako szybka alternatywa jest **Leafpad** &#8211; ma interfejs i funkcje z dawnych wersji; popularny zasadniczo w XFCE.  
<br clear="all" />  
<img decoding="async" src="https://cdn1.iconfinder.com/data/icons/nuvola2/128x128/apps/kate.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="kate" /> Użytkownik KDE powie: **Kate**.<br clear="all" /> Ale kochana Kate ma trzy wady: 

  1. wymaga całego dyskożernego KDE
  2. jest w stylu nowego KDE
  3. wymaga całego KDE

Z tego powodu niektórzy ludzie kurczowo trzymają się Kubuntu &#8211; bo jest Kate. Z ważnych funkcji należy wymienić tryb pracy jako IDE do niektórych języków, obszerne pola wyszukiwania funkcji i ładne kolorowanie składni. Cóż, jako edytor uniwersalny się nie nadaje.  
<img decoding="async" src="http://kate-editor.org/wp-content/uploads/2014/01/kwrite.png" alt="kate" /> 

Są i tacy (jedni to super-power-guru Unixowi, drudzy to dzieciaki, które ledwo co odpaliły gnome-terminal na Ubuntu), co powiedzą **vi**, albo co gorsza **emacs**. 

Vi jest prawdziwie uniwersalne &#8211; jest wszędzie. Zatem trzeba go umieć obsłużyć (jeśli nie wiesz co robią komeny<span class="lang:default EnlighterJSRAW  crayon-inline " >:q :q! :wq / dd</span> i używasz Linuksa jako administrator to wypada się podszkolić bo jak nie uda się wystartować inita to gedita nie będzie).  
Mała dygresja: na Linuksach nie ma już vi &#8211; jest Vim w trybie zgodności z vi (poznać można po helpie wyświetlanym po uruchomieniu bez pliku). Ale na FreeBSD czy gołym Unixie jest tylko vi. Swoją drogą zagadka: <a onClick="alert('Posadzić newbie przed vi z klawiaturą dvoraka i kazać mu wyjść z programu');">Jak stworzyć idealny generator losowy?</a>  
Tak, wiem, że teraz lansowany jest nano &#8211; ma przyjazne sterowanie widoczne cały czas, ale przyzwyczajenie się do niego to nic dobrego. Dla mnie tym co go wyklucza jest komenda zapisująca &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline " >Ctrl+O</span> &#8211; taka sama jak przełącznik konsoli i commandera w MC &#8211; czasem używam innego niż wbudowany edytor w trakcie pracy z plikami w Midnight Commanderze. Ctrl+O ubija jakąkolwiek komunikację &#8211; dostęp stracony.  
Ostatnia dygresja: jak na szybko zamknąć vi? <span class="lang:default EnlighterJSRAW  crayon-inline " >Ctrl+Z</span> 😉

<a href="http://static3.wikia.nocookie.net/__cb20051225123709/uncyclopedia/images/b/bb/Ignucius.jpg"" ><img decoding="async" src="http://static3.wikia.nocookie.net/__cb20051225123709/uncyclopedia/images/b/bb/Ignucius.jpg" alt="St. Ignucius" style="float: left; margin-right: 5px; width: 100px; height: 100px" /></a> Emacs to dla mnie koszmar jeśli chodzi o edytory &#8211; poza wszystkim co można wymyślić w trybie edycji plików mamy klienta poczty, przeglądarkę WWW, _PIM_ (Personal Information Manager &#8211; np. kalendarz, kontakty) i chyba tylko sam [święty iGNUcjusz][2] wie jeszcze.  
Przypomina to coś w rodzaju:  
<img decoding="async" src="http://www.ultraedit.com/assets/images/ppUE/htmltools.png" />  
tylko, że w konsoli tekstowej z miliardem dziwnych skrótów klawiaturowych.

Z konsolowych jest jeszcze mój ulubieniec &#8211; **mcedit** będący częścią Midnight Commander&#8217;a. Potrafi podświetlać składnię, szukać w pliku, oraz kopiować, wklejać i tym podobne proste zadania wykonywać. Ma zasadniczą zaletę &#8211; łatwo go ogarnąć: poza akcjami przypisanymi do F1-F10 opisanymi na dole (dziedzictwo Norton Commandera, znane windowsowcom m.in. z Total Commandera) trzeba znać tylko Ctrl+Ins, Shift+Ins i Shift+Del (kolejno: kopiuj, wklej, skasuj zaznaczenie &#8211; intuicyjnie strzałki+shift). Bardzo prosty, ale najwygodniejszy do prostych edycji &#8211; zwłaszcza przez Putty&#8217;ego gdy [Esc] wariuje.  
<img decoding="async" src="http://sclive.files.wordpress.com/2006/07/mcedit.jpg" alt="mcedit" /> 

<img decoding="async" src="http://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Bluefish-icon.svg/120px-Bluefish-icon.svg.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="bluefish" /> **Bluefish** jest aż za bardzo zorientowany an HTMLa &#8211; autowstawki, tablice znaków, FTP, podgląd w przeglądarce (nic dziwnego, że nazywał się Thtml editor). Najbliżej mu do Windowskowego kED&#8217;a.

<img decoding="async" src="http://rocketdock.com/images/screenshots/komodo_edit.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="komodo edit" /> **Komodo Edit** jest doskonały dla tych, którzy programują w językach mających swoje wersje wydane przez ActiveState &#8211; Perl, Python, Tcl. Poza tym wyposażony w developerskie opcje dla WWW &#8211; np. przeglądarkę drzewa DOM, czy narzędzia do walidacji. 

<img decoding="async" src="http://upload.wikimedia.org/wikipedia/commons/a/a0/Geany_logo.svg" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="geany" /> Idąc dalej spotkamy **Geany** &#8211; przyjemny edytor, ale znowu &#8211; zbyt bardzo zintegrowane środowisko programistyczne zamiast edytora!  
<br clear="all" />  
<img decoding="async" src="http://www.iconhot.com/icon/png/quiet/256/ultra-edit.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="ultraedit" /> **UltraEdit** to komercyjne wszystko-w-jednym-na-wszystkie-platformy. Przerost formy nad treścią &#8211; spójrz na screen obrazujący przerost emacsa &#8211; to właśnie UltraEdit. Okropna cena $80 za sam edytor &#8211; inne komponenty (np. odpowiednik diffa) to osobne produkty. Trial ograniczony czasowo.  
<br clear="all" />  
<img decoding="async" src="http://c758482.r82.cf2.rackcdn.com/sublime_text_icon_2181.png" style="float: left; margin-right: 5px; margin-bottom: 5px; width: 64px; height: 64px;" alt="sublime text" /> I na sam koniec mój ulubiony edytor. Niestety własnościowy. Niestety $70. Ale trial polega na tym, że co kilkanaście zapisów pokazuje dodatkowe okienko zachęcające do zakupu licencji (nieoficjalnie: jest [crack][3]). **Sublime Text**. Lista funkcji jest tak duża, że aż twórca na swojej stronie pominął niektóre. Poza tym co jest wszędzie znajdziemy w nim: 

  * skok do dowolnego miejsca &#8211; _goto anything_ (linii, funkcji, elementu DOM&#8230;)
  * natywnego HUD (menu z wyszukiwarką)
  * potężną zaznaczarkę &#8211; nie tylko kolumnowa /blokowa, ale wielosegmentowa (zaznaczamy trzy fragmenty tekstu i do nich _jednocześnie_ dopisujemy)
  * tryb nierozpraszający &#8211; wycentrowany fullscreen
  * tryb podziału okna &#8211; jak w Notepad++
  * mapę kodu &#8211; po prawej
  * oczywiście wewnętrzną konsolę bazującą na Pythonie, a więc tym samym kalkulator 🙂
  * dowolne transformacje tekstu &#8211; wielkość liter, podział na linie, komentowanie blokowe, wcięcia, ucinanie do linijki (np. do klasycznej szerokości 80 znaków)&#8230;

Pewną dziwnostką, a zarazem wyjątkowością jest brak graficznego edytora ustawień &#8211; z menu wykonamy polecenia i zmienimy z list rozwijanych podstawowe rzeczy &#8211; zmienimy język programowania do składni, motyw, czy rozmiar czcionki. Kliknięcie na &#8222;Settings &#8211; default&#8221;, czy &#8222;Settings &#8211; user&#8221;&#8230; otworzy plik do edycji. Wszystkie z ładnymi komentarzami &#8211; można ustawić dowolne parametry, a by je zatwierdzić wystarczy plik zapisać. Oczywiście można także tworzyć pluginy i pobierać miliardy motywów.

<img decoding="async" src="http://www.sublimetext.com/screenshots/alpha_goto_anything2_large.png" alt="sublime text" />  
Lista przydatnych linków do subl&#8217;a:  
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