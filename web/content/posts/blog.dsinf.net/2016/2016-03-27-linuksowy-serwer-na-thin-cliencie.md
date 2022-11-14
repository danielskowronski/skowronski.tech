---
title: Linuksowy serwer na thin-cliencie
author: Daniel Skowroński
type: post
date: 2016-03-27T21:23:08+00:00
summary: Linux podobno chodzi wszędzie i nie wymaga nic poza kilkudziesięcioma megabajtami pamięci, kilkuset megabajtami dysku i na pewno pójdzie na każdym starym procesorze z peceta. To prawda, ale żeby postawić serwer na takim Fujitsu Siemens Futro A250 (AMD Geode @500MHz, 256MB RAM, 1GB karta CF) i móc dołożyć tam coś więcej niż serwer ssh i nie zwariować od co chwila łamanych przekonań to nie taka prosta sprawa...
url: /2016/03/linuksowy-serwer-na-thin-cliencie/
tags:
  - linux embedded

---
Linux podobno chodzi wszędzie i nie wymaga nic poza kilkudziesięcioma megabajtami pamięci, kilkuset megabajtami dysku i na pewno pójdzie na każdym starym procesorze z peceta. To prawda, ale żeby postawić serwer na takim [Fujitsu Siemens Futro A250][1] (AMD Geode @500MHz, 256MB RAM, 1GB karta CF) i móc dołożyć tam coś więcej niż serwer ssh i nie zwariować od co chwila łamanych przekonań to nie taka prosta sprawa...

Problemy jakie napotkałem przy próbie użycia wspomnianego thin-clienta przekroczyły wszelkie granice. Zanim przejdę do opisu męki wspomnę, że zużywa on naprawdę <9W więc spokojnie można go wstawić gdziekolwiek. No i ma gigabit ethernet co jest rzadkością w tego typu platformach. Ale po kolei.

Większość dystrybucji linuksowych (a raczej ich developerzy) błędnie zakłada, że instrukcja NOPL (czyli zajmujące więcej miejsca "nic"; NOP = "no operation" - instrukcja każąca procesorowi nic nie robić) jest w standardzie i586, podczas gdy w AMD Geode LX800, który realizuje i586 jej nie ma (i nie musi mieć bo nie jest to część standardu) co powoduje, że kiedy kompilowane są 32-bitowe wersje dystrybucji pojawiają się problemy. I pół biedy kiedy jest to opisane jako "32 bit", ale niektóre strony WWW twierdzą, że build jest pod starawy i386 a tak naprawdę jest pod i686. W ogóle termin "32 bit" jest bardzo szeroki. Niektóre dystrybucje nawet ignorują inne procesory jak x64 (np. openSUSE zrezygnowało z takich buildów). Podobne problemy tyczą się innych optymalizowanych pod prądooszczędność architektur - dlatego najlepiej szukać jawnej deklaracji kompilacji pod i386.

Druga sprawa to miejsce na dysku. Najbardziej zawiódł mnie pod tym względem Arch Linux - system w którym wszystko instaluje się ręcznie więc powinien mieć najmniejszy footprint. Po instalacji przez pacstrapa systemu "base" (bo innych już nie ma! - kiedyś była jakaś lżejsza wersja), dodaniu kompilatorów zostaje niewiele miejsca na karcie 1GB. A kiedy wpadnie nam do głowy zainstalować cupsa... to w zależnościach pojawi się... wayland (gdzieś pomiędzy jest libpng). Wszystko OK. Podziwiam modułowość. Ale dowodzi to tylko faktu, że Arch nie jest uniwersalnym distro, tylko uniwersalnym desktopowym distro. Po zamianie karty CF na większą albo użyciu pendrive'a jest niby lepiej, ale pojawiają się kłopoty z AURem kiedy chcemy wgrać cokolwiek niestandardowego porządnie (np. niezbędne dla mnie drivery foo2xqx dla drukarki HP); o tym, że makepkg -asroot nie działa "bo tak" tylko [wspomnę][2]. Dodatkowo odstraszyły mnie liczne problemy z sumami kontrolnymi w AURze - ogólnie jak na serwerek za dużo zabawy.

Postawiłbym tam gentoo, ale jak niby ma mi się tam skompilować w skończonym czasie kernel?!

Testowałem także odmiany BSD, głównie NetBSD (i ich flagowe "Of course it runs NetBSD"). Cóż - działa. Ale problem pojawia się z driverami do drukarek, oprogramowaniem, które odruchowo byśmy tam wrzucili i sposobem instalacji oprogramowania, który jest nieco irytujący na małych dyskach - trzeba mieć ściągnięte porty, a one trochę zajmują. FreeBSD odpada bo mamy ten sam problem co w Gentoo - "skompiluj sobie sam" - trochę za słabe CPU.

Zaszedłem nawet po Windowsa. Ale było to bolesne - zwykłe odmiany XP oczekują dysku wielkości 4GB - udało mi się zmodować WinServer 2003 żeby wszedł ale miejsca miał mało no i za wiele to mi się tam nie udało postawić. Windows Embedded trzeba skomponować ze składników ręcznie - trzeba wiedzieć jakie moduły się chce i jakie sterowniki. O ile od edycji równoległej do Win7 da się odpalić instalkę na maszynie docelowej to niestety XP/2003 (jedyne, które wejdą na tak mały dysk i tak małą ilość RAMu) potzrebuje być zrobionym gdzie indziej przez SDK, którego obsługa jest trudna. A jak się nie wie jakich sterowników potrzeba to jeszcze trudniejsza...

Ubuntu stworzyło odmianę snappy dla systemów embedded i chmurę, ale obecnie działa tylko na kilku konkretnych architekturach i pod KVM więc odpada. A szkoda bo akurat prostota ubuntu na takim systemie by się przydała.

Warty wspomnienia jako odpalający się i całkiem przyjemnie działający jest SliTaz, ale jest on za bardzo nastawiony na bycie desktopem - znalazł on zastosowanie na innym thin-cliencie - HP T5720 (też AMD Geode ale NX1500 - "pełne" i686 @1GHz, 512MB RAM i kość flash 512MB - bez gniazda CF) który jedyne co robi to wyświetla przeglądarkę pokazującą stan serwerowni ([SauronWeb][3]) z planami na rozszerzenie funkcjonalności i streamuje radio internetowe. Oryginalnie był tam Windows XP embedded, ale zostawia strasznie mało miejsca na kości flash (ledwie wchodzi driver wifi) i jest ekstremalnie niewydajny.

To że SliTaz działa na HP z poprzedniego akapitu to zasługa głównie starego kernela - 2.6.37, a serwer żeby działał powinien mieć nowe jądro bo inaczej inne pakiety też będą stare i sporo oprogramowania odpadnie.

Zanim przejdę do sedna to dodam, że Puppy Linux też działa, ale podobnie jak SliTaz - nastawiony jest na bycie desktopem. Jednak SliTaz okazuje się lepszy na thin-cliencie bo jest istotnie lżejszy. Do starego peceta włożyć dysk kilku gigabajtowy to nie problem. Do systemu embedded dołożyć kość pamięci - już tak.

I tu pojawia się [Linux Voyage][4] - okrojony Debian - mały serwerek na x86 (bo na ARMa czyli de facto Raspberry Pi dystrybucji i kompilacji popularnych dystrybucji jest wiele) z jajkiem z serii 3.16 a więc dającym już sporo możliwości. Ponieważ jest to dystrybucja pomyślana do takich rozwiązań więc nie ma niespodzianek klasy "zainstaluj waylanda żeby działała drukarka", a "debianowatość" daje stabilność i bezpieczeństwo nie tak dużym nakładem. Problem, który mnie dotknął 2 lata tamu przy pierwszym zetknięciu z tym distro polegał na tym, że jedyny mirror stał w Honkongu i prędkości pobierania były tragiczne. Ale teraz w Europie stoi ich kilka więc problem zniknął. Są dwie odmiany Voyage - "Linux" czyli wspomniany zwykły serwer bez GUI i "MPD" (Music Player Daemon) przeznaczony do bycia porządnym ale lekkim odtwarzaczem muzyki (z web gui, driverami do kart dźwiękowych i zoptymalizowany pod odtwarzanie real-time bez zawieszeń). Można pobrać obraz do wgrania na docelowy nośnik i ISO instalacyjne (do wgrania np. na pendrive'a przez dd). Dostępne buildy to i386 (zgodny ze wszystkimi 32-bitowymi procesorami powyżej i286 (no ale tam najszybszy był wiatraczek)), amd64 (czyli normalne "64-bit") i przez edycję CuBox także na ARM => Raspberry Pi.

Należy się jeszcze słowo wyjaśnienia "czemu nie Raspberry Pi?". W porównaniu z ceną używanych thin-clientów (rynkowo 50-70zł, a w większości wypadków po prostu odzyskiwane za darmo z zaprzyjaźnionych firm likwidujących to ciekawe rozwiązanie) rozmiar traci na znaczeniu. Znane są problemy z malinami (chociażby pomysł z użyciem microSD bywa zawodny), a narosły wokół nich hype odbiera mi ochotę na pójście tą drogą. Fakt, chodzi tam Windows 10 core, ale jest on bardziej nastawiony na IoT i pisanie prostych appek, nie zaś na postawienie tam webservera i CUPSa czy OpenVPN.

 [1]: http://www.parkytowers.me.uk/thin/Futro/index.shtml
 [2]: http://blog.dsinf.net/2015/02/makepkg-asroot/
 [3]: https://github.com/KSIUJ/sauron/tree/master/web
 [4]: http://linux.voyage.hk/