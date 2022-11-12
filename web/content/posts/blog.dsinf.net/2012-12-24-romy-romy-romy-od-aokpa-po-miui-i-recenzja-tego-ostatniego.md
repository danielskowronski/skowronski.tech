---
title: ROMy, ROMy, ROMy… (od AOKPa po MIUI i recenzja tego ostatniego)
author: Daniel Skowroński
type: post
date: 2012-12-24T22:36:44+00:00
url: /2012/12/romy-romy-romy-od-aokpa-po-miui-i-recenzja-tego-ostatniego/
tags:
  - android

---
Kiedyś w ogóle nie rozumiałem androidowców jarających się ROMami, aktualizacjami Custom Recovery i temu podobnymi mając w rękach system idealny i nie wymagający takich manewrów - Maemo. Cóż, teraz rozumiem zawrót głowy każdego, kto używa androidowego telefonu do czegoś poza dzwonieniem i graniem.

Na moim HTC One V (kodowo primoU) **przygodę z "psuciem" zacząłem od odblokowania bootloadera** i konieczności skasowania wszystkiego zaledwie **po jednym dniu używania**. Powód? Żeby zrootować ten telefon trzeba wgrać patch z recovery 🙁

Jakoś miesiąc później wgrałem pierwszy ROM - **AOKP. Prostota, elegancja i stabilność.** Około dwóch miesięcy bawiłem się w aktualizacje raz na tydzień (oczywiście do nigthlies), konfiguracja wszystkiego co się da... ROM ten zapewnia ogromne pole do popisu tzw. grzebaczom - da się zmienić prawie wszystko: od lockscreena, przez ręcznego appkillera (czyli tego otwieranego przytrzymanym Home; do najciekawszych modyfikacji należy przycisk killall oraz pasek zajętości pamięci), po codzienny reboot, czy dostowanie wibracji. Istotą były toggles w pasku notyfikacji dając spore pole manewru. Elementami dopełniającymi elegancję są Nova Launcher i przycisk Swagger robiący... nic.  
Tym co przekonało mnie do zmiany ROMu było spore zaśmiecenie systemu i przerwanie jego rozwoju. I tym oto sposobem zacząłem gonitwę za godnym zastępcą AOKPa. 

Drugim ROMem, który zflashowałem był **PACman - multirom będący połączeniem Paranoid'a Aokp'a i Cyanogen'a**. Wizją twórcy i zresztą moimi pierwszy kilkoma godzina użycia było zmiksowanie elegancji, pełnej dostosowywalności, funkcji dostowania wielkości UI dla każdej aplikacji i ciekawe modyfikacje wraz z popularnym CMem też umożliwiającym niezgorsze osiągi. Przyszedł też czas na zamianę kernela KISS na Hellboy'a, a wraz z tym overclocking do 2GHz.  
Jednak ta **mieszanka okazała się zabójcza**. Miałem wrażnie mobilnej Visty bez Service Packa, bo wszytsko zaczynało lagować, a część funkcji zaczęło duplikować (najwięcej czasu zajęło mi wykrycie miejsca wyłączania toggles).  
Wszystko fajnie, ale to nie na ten telefon. I znowu zmiana. Tym razem na jedną ze skłądowych PACmana...

...**Paranoid Android**. Byłem zaskoczony, gdyż dawał sam z siebie sporo ustawień personalizujących telefon. Ale niestety był zbudowany na CM10 - okazało się to zgubne. Nie chciały mi się instalować AngryBirds - system uparcie twierdził, ze jest za mało pamięci. Odgrzebany problem: okazuje się, że CM trzyma część danych na partycji systemu, która dzięki bardzo przemyślanym decyzjom developerów HTC w primou ma jedynie 100MB to niestety obejścia były dwa: konwersja którejś partycji na EXT4, albo przelinkowanie części danych, z tym, że kończyło się to kilkukrotnie dłuższym updatem ROMu - trzebaby było wsyztskie dane przesuwać.  
I tak jak poprzednik po krócej niż tygodniu zmiana.

Kolejny kandydat na miano mojego ulubionego systemu: **Provision**.  
**Prosty i szybki (do czasu).** Mocno okrojone ustawienia względem AOKP. I właściwie tyle. Tym co wyróżnia go jakoś z odmętów to ciekawe podejście do paska powiadomień (o którym opinia zmieni się za kolejne kilka dni, ale na razie jest nowatorskie) - są 2 karty: jedna na powiadomienia, druga na toggles i jasność. Ładnie wszystko porządkuje pasek notyfikacji. Uzupełnieniem jest sensowne wkomponowanie pogody.  
Ale drobny mankament - nie da się ściągnąć wspomnianego paska. Kilka minut i udaje mi się to zrobić w pełni świadomie: należy to robić pod pewnym skosem. Nasuwa sie tylko jedno: WTF?! Najciekawsze jest to, że czasami można to zrobić normalnie - czyli prosto na dół, a czasem tylko pod dużym skosem. Inaczej po prostu wraca do stanu zwinięcia po pokazaniu podglądu zegra i daty.

**Provision skłonił mnie do reflekcji czego tak naprawdę oczekuję od ROMu. Roboczo nazwę to "duszą ROMu". I tego Provision nie miał.**  
Nie wyróżniało go nic szczególnego. **Osobiście uważam, że system z ramek forum XDA powinien do mnie krzyczeć "zflashuj mnie!"** 😉

I znów poszukiwania. To już chyba ostatni z rozwijanych jakkolwiek portów dla OneV - **MIUI**. Mimo, że akurat gdy chciałem ściągnąć wersję o 2 minor'owe numerki starszą od aktualnej (bo taka została przeniesiona na nieoficjalny build) to serwer MIUI US od romów bł nieosiągnalny to nie zraziłem się. Ruszyłem na podbój rosyjskiego mirrora. Ściągnięte, zflashowane, odpalone.

Ale coś ten system zupełnie nie działa. Lockscreena nie ma, home button nie działa, ustawienia wybrakowane, klawiatua nie działa...  
No i się zorientowałem. Otóż chciałem przeskoczyć developerów, być sprytnym i wgrałem gapps dla wersji 4.2, a najnowsza dostępna dla mnie kompilacja robociego jajka to 4.1.1. Lekki fail. Swoją drogą myślałem, że zadziała jak znany mi z poprzednich ROMów mod nadpisujący część apek systemowych tymi z 4.2. Niestety nie. Mówi się trudno, flashuje starsze gapps i próbuje od nowa.

**Działa. Tym oto sposobem wita mnie zreorganizowany, niemal nie do poznania, brand new Android, którego chyba bardzo polubię na długo.**  
**W UI zakochałem się od pierwszego załadowania. Choćby dlatego, że przypomina mi próby MeeGo na leciwej N900. Proste elementy, a nie inwazyjne i oczo-ofensywne animacje mające przypominać, że dzięki JB cały interfejs renderuje się na GPU.**

**Prostota konceptu** zaczynająca się od wywalenia choćby AppDrawera powaliła mnie. Ale pozytywnie. Tym, co rzuca się jako pierwsze w oczy jest lockscreen przypominający jeśli chodzi o mechanizm ten z Sense'a i czysty JellyBean'owy. Pasek notyfikacji jest powiewem świeżości. 

**System pełen jest praktycznych niespodzianek.** Żeby wymienić wszytskie należałoby poświęcić temu wiele linii. Dlatego tylko najważniejsze.  
*Misuse - wykrywa gdy telefon znajdyje się np. w kieszeni i nie pozwala odblokować ekranu.  
*Szybka latarka w lockscreenie: klawisz home włącza diodę LED do czasu jego zwolnienia.  
*Pomysłowy screenshot: menu+VolDown  
*Statystyki użycia danych pakietowych: nie zajmują wiele, a są w głównym widoku paska powiadomień przekazując nam to, co najważniejsze: wykres kołowy, użycie dziś i pozostały pakiet.

**Każda z wbudowanych aplikacji jest jakby spełieniem idei Unixa - robić dobrze jedną rzecz. Miłe wspomnienie Sense'a - apliakcje ze stylem, a jednocześnie bardzo funkcjonalne.**

Pozytywnie zaskoczył mnie także format customizacji wyglądu: nie jakieś tam klasyczne CMowe motywy. Można zmienić każdy element - od tapety do lockscreenu, przez fonty, wygląd status bar'a po ukłąd lockscreena -wszystko jest przyjemne. A co najważniejsze: można pobrać wiele gotowych zestawów lub tylko pojedyncze elementy.

No, byłbym zapomniał o wielkich możliwościach jeśli chodzi o bezoieczeństwo - aplikacji możemy nadawać lub odbierać uprawnienia - warto ukrócić iecne plany developerów popularnych aplikacji, czy zweryfikować złośliwych programistów, czy po prostu twórców wirusów. Na tym nie koniec - można także m.in limitować interfejsy sieciowe czy wejść do trybu gościa.

Ile zostanę z MIUI? Aż się mi bardzo znudzi, albo wyjdzie coś z Andkiem 4.2+ co będzie stabilne i niezwadne na tym mimo wszystko modelu ze średniej półki.

**I tak to już z Androidem bywa: nie służy do dzwonienia, tylko do zabawy. Bo po co taki potencjał grzebania ma się marnować 😉**