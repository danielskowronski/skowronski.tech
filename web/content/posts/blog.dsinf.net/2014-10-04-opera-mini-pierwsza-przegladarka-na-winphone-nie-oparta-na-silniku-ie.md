---
title: Opera Mini – pierwsza przeglądarka na WinPhone nieoparta na silniku IE
author: Daniel Skowroński
type: post
date: 2014-10-04T18:45:32+00:00
excerpt: 'Analiza Opery Mobile na Windows Phone - test funkcjonalności i działania, refleksje nad jej miejscem w ekosystemie WinPhone i trochę więcej.'
url: /2014/10/opera-mini-pierwsza-przegladarka-na-winphone-nie-oparta-na-silniku-ie/
tags:
  - opera
  - windows phone
  - www

---
Microsoft uznał, że w Windows Phone Makretplace nie będzie przeglądarek nie korzystających z systemowego silnika IE - po pierwsze bezpieczeństwo (przeglądarka to w końcu parser niebezpiecznego internetu, mogą być w niej dziury narażające użytkownika i jego prywatność - np. null na początku JavaScriptu w przeglądarce Androida do wersji 4.4 wyłączało całkowicie ochronę przed XSS - fundament jakiegokolwiek bezpieczeństwa [[źródło][1]]), po drugie - ochrona przed konkurencją. Zresztą - jak można napisać wydajniejszą przeglądarkę od wbudowanej w system, skoro można pisać tylko we frameworku?

Do niedawna wszystko było spokojnie - czyli kilka innych przeglądarek, które albo nie działają w ogóle, albo działają słabo i bardzo niewiele perełek jak [UC Browser][2]. Ta ostatnia dokłada nawet niezły interfejs i sporo dodatków - czytnik kodów QR, lepsze zarządzanie zakładkami, obsługa >6 kart (miało to znaczenie przed WinPhone 8 - wtedy IE obsługiwał tylko 6).

Ale pojawiła się Opera. Opera była już kiedyś dostępna na WinPhone 7.0; od 7.1 (czyli rynkowo "7.5") wycięto możliwość odpalania natywnych binarek więc przeniesiona jeszcze z czasów Windows Mobile 6.5 wersja nie uruchamiała się. (Gwoli ścisłości: na WinPhone 8 da się taka wersję odpalić, ale potrzebny jest Interop Unlock, co do tej pory udaje się tylko na Samsungach ATIV).

![wp_ss_20140912_0002](/wp-content/uploads/2014/10/wp_ss_20140912_0002.png)

Aplikacja dostępna od kilku tygodni [w Marketplace][4] po okresie zamkniętych testów budziła na początku zmienne uczucia. Dlaczego zmienne? Bo co kilkanaście godzin wychodziły aktualizacje w "trybie wersji Windows" - czyli co druga działała. Te niedziałające crashowały się po kilku sekundach. Jak jednak udało się uruchomić to zobaczyliśmy starą, dobrą Operę. Z niezmienionym wyglądem. Działającą dokładnie jak kilka lat temu.<br clear="all" />

Kilka wątpliwości na start- złamano chyba wszelkie reguły aplikacji w Marketplace. Pominę kwestię, że ta przeglądarka wykorzystuje własny silnik renderowania w świetle zgodności tego z założeniami MS. Po pierwsze: aplikacja, która crashuje się podczas startu na kilku różnych telefonach w różnym stanie (w tym "czystych") w ekosystemie WinPhone nie ma prawa istnieć. Podczas certyfikacji, czyli procesu dopuszczania aplikacji do umieszczenia w publicznym sklepie działanie sprawdza automat na maszynach wirtualnych i wadliwe paczki odrzuca; następnie robi to także żywy człowiek na 3-4 losowych telefonach fizycznych (w tym przynajmniej jednym z niższej półki). Dlatego proces trwa 3-5 dni roboczych. Nie ma szans, żeby przeoczono fakt, że "się nie uruchamia" zgłaszany przez rzesze użytkowników.  
Po drugie - interfejs graficzny jest "niezgodny" z wytycznymi Modern UI. "Niekwadratowy" (nie chodzi rzecz jasna tylko o to) wygląd teoretycznie dozwolony jest tylko w przypadku gier. Ten interfejs sugeruje, że nie powstał on w standardowych "formsach" frameworka. Są dwie opcje: albo skorzystano z MSowego frameworka do ręcznego tworzenia UI do WinPhone, albo zostawiono to co było w poprzednich wersjach, czyli aplikacja posiada własny kod renderujący kontrolki. To drugie jest niebezpiecznie prawdopodobne.  
To wszystko podsuwa wątpliwości, że aplikacja została w jakiś brutalny sposób przeportowana żywcem z archaicznej kompilacji na Windows Mobile. To nie jest dobry sygnał dla m.in. wydajności i bezpieczeństwa (hipotetycznie jeżeli Opera ma udzielony dostęp do API systemu, żeby działała poza frameworkiem to może to być zagrożenie - ale to tylko gdybanie). 

Polem do analizy byłoby zapisanie strony WWW (stara funkcja Opery jeszcze z czasów JavaMobile, która zapisuje je w katalogu programu, nie zaś w przestrzeni użytkownika) i wyciągnięcie z karty SD zaszyfrowanego pliku zrzutu. Teoretycznie dałoby to możliwość złamania klucza urządzenia, co za tym idzie sprawdzenia kodu (C# .Net jest w pełni dekompilowalny - czasem nawet z komentarzami). Ale znowu - to tylko teoria.  
Pewna jest tylko <emp>lista</em> plików:

```
\WPSYSTEM\APPS\{B3BF000A-E004-4ECB-A8FB-9FC817CDAB90} 
|
├───TempInstall
│   ├───Installer
│   └───Install
├───TempNI
├───XBF
│   └───pl-PL
│           OperaMini.XbfContainer
│           
├───Install
│   │   AppManifest.xaml
│   │   elements.png
│   │   MDILFileList.xml
│   │   OperaMini.dll
│   │   OperaMiniRuntime.dll
│   │   OperaMiniRuntime.winmd
│   │   prereksio.ini
│   │   RPALManifest.xml
│   │   WMAppManifest.xml
│   │   WMAppPRHeader.xml
│   │   
│   ├───Assets
│   │       opera_icon_110x110.png
│   │       opera_icon_202x202.png
│   │       
│   └───output
│       ├───build
│       │       a
│       │       
│       └───res
│               data-ri-universal.rsc
│               locale-ri-universal.rsc
│               skin-qxga-touch.rsc
│               skin-svga-touch.rsc
│               skin-vga-touch.rsc
│               
└───NI
        OperaMiniRuntime.ni.dll
        OperaMini.ni.dll
```


![4d6fdd0f-578d-47c4-b9c2-cb66cc0c4c6c](/wp-content/uploads/2014/10/4d6fdd0f-578d-47c4-b9c2-cb66cc0c4c6c.png)

Ale przejdźmy do meritum, czyli funkcjonalności. Opera działa. Ma też wszystkie funkcje, które były dla nas zarówno oczywiste jak i niezbędne na skrzypiących telefonach opartych o J2ME, jak chociażby klasyk epoki - Sony Ericcson k800. Są to przede wszystkim: flagowa opcja Opery - oszczędzanie pasma z trybem drastycznym (kompresja obrazków z obniżaniem ich jakości), widok jednokolumnowy (bez którego dawno temu nie dało się w ogóle przeglądać stron innych niż WAP), zawijanie tekstu (super ważne przy rozdzielczościach <= 320x240px) no i karty. Karty, które były fenomenem w dawnych czasach. Jaka jest teraz przydatność tych funkcji? Kompresję pasma oferuje IE11, strony maja już wersje mobilne, systemowa przeglądarka oferuje nieograniczoną liczbę kart. Tylko zawijanie tekstu się przebija bo w IE ta funkcjonalność kuleje.<br clear="all" />

Strony się ładują. Ale ponieważ to stara Opera (nowe bazują na silniku Blink z Chromium) to strony bywają lekko zdeformowane. Pierwszy mierzalny test jaki przyszedł mi do głowy to ACID3. Kiedyś miał on znaczenie, bo jeszcze kilka lat temu nieoczywistym było, że przeglądarki są zgodne ze standardami. Koło 90/100 to był dobry wynik. IE7 miał 23. (Teraz wszystkie znaczące mają 100/100) A jak wyszła Opera z pojedynku z IE11? 97/100 dla Opery i 100/100 dla IE11. Wynik jak na Operę na telefonie świetny 😉 Teoretycznie znaczy to tyle, że HTML4 i towarzyszące JS i CSS2 opanowane. Ale żeby było śmiesznie - Opera kończy test znacznie szybciej niż IE. Te 3 punkty różnicy nie powinny trwać aż tyle.  
*Po napisaniu artykułu sprawdziłem używanego przeze mnie na stacjonarce Google Chrome 37. I wyszło 97/100. [[Strona testu ACID3][6]]  
![ACID3 na Operze](/wp-content/uploads/2014/10/wp_ss_20140912_0006.png)![ACID3 na IE11](/wp-content/uploads/2014/10/wp_ss_20140912_0007.png)

ACID3 na Operze (po lewej) vs. IE11 (po prawej)  
<br clear="all" /> 

No ale mamy czasy HTML5 więc znalazłem [html5test.com][9]. Wyniki dla Opery nie są strasznie tragiczne, IE nie zdaje na maksimum.  
![HTML5TEST na Operze (to jest WinPhone 8.1 - przeglądarka przedstawia się błędnie)](/wp-content/uploads/2014/10/wp_ss_20140912_0008.png)![HTML5TEST na IE11](/wp-content/uploads/2014/10/wp_ss_20140912_0009.png) HTML5TEST na Operze (to jest WinPhone 8.1 - przeglądarka przedstawia się błędnie) po lewej vs. IE 11  
<br clear="all" /> 

Z ciekawości chciałem sprawdzić jak będzie sprawować się wybitnie nieprzyjazny mobilnym przeglądarką nowy [panel OVH][12].<figure id="attachment_583" aria-describedby="caption-attachment-583" style="width: 665px" class="wp-caption alignnone">![Dla porównania: panel OVH na desktopie.](/wp-content/uploads/2014/10/och_porownanie1.png)<figcaption id="caption-attachment-583" class="wp-caption-text">Dla porównania: panel OVH na desktopie.</figcaption></figure><br clear="all" />  
Na IE11 jest lekko mówiąc słabo (jak się pozoomuje i poprzesuwa to od biedy da się wykonać operacje).  
![Panel OVH na IE11](/wp-content/uploads/2014/10/wp_ss_20140913_0001.png)![Panel OVH na IE11](/wp-content/uploads/2014/10/wp_ss_20140913_0002.png)  
<br clear="all" />  
Natomiast na Operze... nie da się zalogować. Przycisk jest nieaktywny.  
![Panel OVH na Operze. Nieaktywny przycisk logowania.](/wp-content/uploads/2014/10/wp_ss_20140913_0003.png)<br clear="all" />

Uznałem, że warto sprawdzić bardziej typowe strony. Zaufana Trzecia Strona wypadła lepiej, ale nadal dziwnie (screeny z najlepszej wersji, na IE11 wybrany tryb żądania wersji mobilnej).  
![Zaufana Trzecia Strona na Operze (najlepsze ustawienia)](/wp-content/uploads/2014/10/wp_ss_20140913_0012.png) ![Zaufana Trzecia Strona na IE11 (żądanie wersji mobilnej).](/wp-content/uploads/2014/10/wp_ss_20140913_0011.png)Zaufana Trzecia Strona na Operze (najlepsze ustawienia) vs. IE11 (żądanie wersji mobilnej).<br clear="all" />

A wracając do kompletnych porażek przeglądarki z Norwegii - postanowiłem odwiedzić w ramach testów stronę [infinite.pl][19], która jest typowym przedstawicielem nowych trendów i projektów wykorzystujących bajery z CSS3 i HTML5.Jak widać - Opera nie jest w stanie sensownie renderować HTML5. No ale co się dziwić - w czasach powstawania tego silnika nikt takich stron jeszcze nie pisał.  
![Infinite.pl na Operze](/wp-content/uploads/2014/10/wp_ss_20140913_0009.png) ![Infinite.pl na IE11](/wp-content/uploads/2014/10/wp_ss_20140913_0010.png) Infinite.pl na Operze vs. IE11<br clear="all" /> 

![wp_ss_20140912_0003](/wp-content/uploads/2014/10/wp_ss_20140912_00031.png)  
Żeby nie było - jakieś strony się ładują. I to nawet ich wersje dla PC.

<br clear="all" />  
![wp_ss_20140913_0013](/wp-content/uploads/2014/10/wp_ss_20140913_0013.png)Podsumowując chcę przede wszystkim powiedzieć, że Opera na WinPhone jest i raczej niezależnie od aktualizacji będzie dla mnie połączeniem z przeszłością, ale też ważnym narzędziem. Nie mamy tu żadnych rewolucyjnych funkcji, a wszystkie są właściwe dla dawnych czasów, kiedy to internet na telefonach ograniczał się do GPRS (30-80 kb/s), był drogi (50gr za 100kB to standard), możliwości telefonu znikome, ekraniki małe. Wtedy to rzeczywiście możność zapisania strony do trybu offline, czy zaniżanie jakości obrazków i skupianie się na tekście strony (zawijanie tekstu itp.) były istotne. Dziś - nie powie, że bezużyteczne. Jak skończy się pakiet internetowy, to na tych 16kB/s możemy się poczuć jak na SE k800i gdzie każdy bod się liczył. A czasem trzeba zmusić stronę internetową by tekst był istotą.

Opery nie odinstaluję z mojego WinPhone. Co najwyżej odepnę kafelek.

 [1]: http://niebezpiecznik.pl/post/powazny-blad-w-androidzie-dotyczacy-50-jego-uzytkownikow/
 [2]: http://www.windowsphone.com/pl-pl/store/app/uc-browser/6cda5651-56b9-48b0-8771-91dbc188f873
 [3]: /wp-content/uploads/2014/10/wp_ss_20140912_0002.png
 [4]: http://www.windowsphone.com/en-us/store/app/opera-mini-beta/b3bf000a-e004-4ecb-a8fb-9fc817cdab90
 [5]: /wp-content/uploads/2014/10/4d6fdd0f-578d-47c4-b9c2-cb66cc0c4c6c.png
 [6]: http://acid3.acidtests.org/
 [7]: /wp-content/uploads/2014/10/wp_ss_20140912_0006.png
 [8]: /wp-content/uploads/2014/10/wp_ss_20140912_0007.png
 [9]: http://html5test.com
 [10]: /wp-content/uploads/2014/10/wp_ss_20140912_0008.png
 [11]: /wp-content/uploads/2014/10/wp_ss_20140912_0009.png
 [12]: http://ovh.com/manager
 [13]: /wp-content/uploads/2014/10/och_porownanie1.png
 [14]: /wp-content/uploads/2014/10/wp_ss_20140913_0001.png
 [15]: /wp-content/uploads/2014/10/wp_ss_20140913_0002.png
 [16]: /wp-content/uploads/2014/10/wp_ss_20140913_0003.png
 [17]: /wp-content/uploads/2014/10/wp_ss_20140913_0012.png
 [18]: /wp-content/uploads/2014/10/wp_ss_20140913_0011.png
 [19]: http://infinite.pl
 [20]: /wp-content/uploads/2014/10/wp_ss_20140913_0009.png
 [21]: /wp-content/uploads/2014/10/wp_ss_20140913_0010.png
 [22]: /wp-content/uploads/2014/10/wp_ss_20140912_00031.png
 [23]: /wp-content/uploads/2014/10/wp_ss_20140913_0013.png