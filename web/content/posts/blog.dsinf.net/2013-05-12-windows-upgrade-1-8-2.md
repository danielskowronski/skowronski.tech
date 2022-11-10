---
title: Windows Upgrade 1 – 8
author: Daniel Skowroński
type: post
date: 2013-05-12T15:26:00+00:00
url: /2013/05/windows-upgrade-1-8-2/
tags:
  - windows
  - windows upgrade

---
Zrealizowany w lutym 2012 roku projekt Windows Upgrade 1-8 to **zakończona sukcesem próba aktualizacji systemu Windows od najstarszej wersji** (od samego MS-DOS 3.30) **do najnowszej w czasie trwania projektu wersji Windows 8** &#8211; Developer Preview.  
Każdą kolejną wersję poprzedza slajd opisujący datę wydania, wymagania sprzętowe oraz dołączone narzędzia. Ponadto prezentowane jest środowisko pracy &#8211; tzw. &#8222;okienka&#8221; i testowana gra Doom. Całość procesu można zobaczyć na http://youtu.be/DYtJnAlB3eA

Obserwacje:

  * Windows 1.0 posiadał dość ciekawy menedżer okien. Funkcja maksymalizacji i jej cofania przez oderwanie okna  
    za belkę tytułową od góry ekranu to pierwsza z nich. Swoją drogą funkcja znana dopiero z siódemki. Drugą wartą odnotowania  
    funkcją jest minimalizacja do ikonki, którą można przemieszczać po całym ekranie.
  * Windows aż do wersji 95 jest jedynie nakładką graficzną na MS-DOS.
  * Do 3.11 w pole _numer seryjny_ można było wpisać byle co &#8211; system nie sprawdzał poprawności, ani nawet nie wymagał  
    podania go.
  * Instalowanie 3.11 z dyskietek to męczarnia &#8211; 13 sztuk, które na dodatek nie są ponumerowane tylko nazwane  
    _Font floppy 1_, pdczas gdy niemal wszystkie zestawy ich obrazów mają numery kolejne.
  * Dopiero 95 poprawnie połączył się z siecią Internet
  * W czasach kiedy sen Billa, że _640 kB pamięci wsytarczy każdemu użytkownikowi_ upadał tj. około wersji 3.0  
    niezbędny stał się _Windows in Enhanced Mode_. Wykorzystywał on możliwości procesorów Intel 80386 (m.in.  
    pracę w czasie rzeczywistym obsługę większej ilości RAMu no i sam tryb 32-bitowy). Potrzebnym plikiem stał się  
    <u>WINA20.386</u>
  * Windows 95 miał ciekawe podejście do haseł &#8211; wystarczyło wpisać nowy login i nowe hasło i już byliśmy wpuszczeni
  * Vista by zaktualizować się z Win XP wymagała **niesitnienia** katalowu c:\Windows co jest pewnym kuriozum, zważywszy, że  
    aktualizacja systemu odbywa się tylko wewnątrz działającego systemu. Ale cóż, dało się przemianować c:\Windows na c:\Windows.2,  
    ponieważ system trzyma tylko dojścia do plików, a nie ścieżki.
  * Na systemie Win8 niestety brakuje bibliotek do grafiki pełnoekranowej i Doom się nie mógł uruchomić,  
    ale Norton Commander zadziałał
Wnioski:

  * Najbardziej irytująca była instalacja Visty, (instalacja trwająca wieczność, zabawa z c:\Windows, liczne kłopoty  
    ze zgodnością sprzętu), kolejna była instalacja Win 3.11 (przez konieczność przekładania 13 dyskietek) i moją pierszą  
    trójkę zamyka Windows 2.0 &#8211; wybieranie karty graficznej dla wirtualki zajęło kilka godzin.
  * Najprzyjemniej przebiegło umieszczenie i odpalenie Win 1.01 &#8211; razem z MS-DOS 3.30: 
    <pre>#dyskietka MS-DOS
A> format c:
A> sys c:
A> c:
#zmiana dyskietki na Win 1.01
C> mkdir windows
C> cp a:\*.* c:\windows
C> cd windows
C> win
</pre>

  * Windows 8 wygląda jak 2.0 &#8211; brak menu start, kwadratowe krawędzie okien, uproszczone ikonki, nawet logo MS jakieś podobne&#8230;
  * Aktualizacja do Win 8 na komputerze z 1987 byłaby możliwa o ile miałby na pokładzie i386 i 1GB RAMu. Co ciekawe żaden system, który  
    nie widział całych zasobów nie mial problemu z wyprzedzjącym o 20 last epokę powstania Windowsa sprzętem
Wyniki w postaci filmu można zobaczyć na: http://youtu.be/DYtJnAlB3eA  
Pomysłodawca /inspirator: Tomasz &#8222;iDzik&#8221; Idzikowski  
Realizacja /montaż: Daniel Skowroński, 2012