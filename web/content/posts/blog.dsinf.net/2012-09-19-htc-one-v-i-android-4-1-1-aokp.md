---
title: HTC One V i Android 4.1.1 (AOKP)
author: Daniel Skowroński
type: post
date: 2012-09-19T20:20:08+00:00
url: /2012/09/htc-one-v-i-android-4-1-1-aokp/
tags:
  - android

---
Najnowsza wersja popularnego Andka producencko jest dostarczona nielicznym. Na razie mają go użytkownicy Asusa TF Pad (300), wkrótce Infinity (700), a jeszcze w tym roku (poczekamy - zobaczymy) właściciele Prime - będzie to dość ciekawe - można by go aktualizować dwukrotnie (od Honeycomba). Użytkownicy innego tabletu - Motorola Xoom już są w posiadaniu 4.1.1 Z telefonów wkrótce będzie to Samsung i Htc One S, X oraz XL. Najtańszy smartfon z rodziny One nigdy nie dostanie oficjalnej aktualizacji - nie spełnia wymogów (single core 1GHz, 512MB RAM). Ale to nie znaczy, że ten telefon nie utrzyma JB. Wręcz przeciwnie!

Na początku września można było znaleźć aktualizację do wersji CDMA One V - zapewne przyczyniło się to do wielu bricków bo wersja GSM (czyli ta normalna - CDMA to trochę inny sposób dostępu do sieci komórkowej) jest inna pod wzgledem firmware'u. Ale na szczęście użytkowników kilka dni temu team AOKP, czyli Android Open Kang Project udostępnił build. I tu od razu uwaga - One V ma nazwę kodową **PrimoU**, czasem bez końcowego U, ale PrimoC to wersja CDMA - nie stosować!  
Instrukcje wgrania do tej pory były często dość mało wiarygodne, dopiro teraz na stronie domowej ([link][1]) pojawiła się instrukcja, ale w skrócie jest to:

  * to chyba oczywiste, ale: odblokuj bootloader
  * **zrób backup wszystkiego jak leci**</u> 
      * pobierz 2 zipy: build i Gapps ([post z XDA][2], gdzie można znaleźć aktualne wersje)
      * wrzuć je na kartę SD
      * odpal w trybie recovery; tak, to trzeba najpierw wgrać - można za pomocą [HTC One V All-in-one toolkit][3] lub po prostu <pre class="EnlighterJSRAW bash">fastboot flash boot plik_z_CWM_recovery</pre>
    
      * wyczyść cahce Dalvik
      * wyczyść ustawienia do fabrycznych**!!**. Możesz to pominąć, ale będziesz musiał flashować raz jeszcze
      * Zflashuj po kolei 2 zipy: najpierw build, potem Gapps
      * zrestartuj i już 😉</ul> 
    Metoda jest prosta - recovery jest intuicyjne, wszystko jest w menu. Jedyne co może budzić pytanie - to co to jest Gapps. W buildzie nie ma aplikacji google, takich jak Sklep Play, Kalendarz, Gmail itp. (najprawdopodobniej z kwestii licencyjnych), więc zostały wyciągnięte z działającego JB i wrzucone oddzielnie.
    
    **Pierwsze wrażenia**  
    Po ujrzeniu komunikatu, który widziałem tylko raz na oczy zaraz po odblokowaniu bootloader'a - _This build is for development purposes only. Do not distribute outside HTC..._ zapowiedział coś ciekawego. Potem bootscreen - normalka. Już na początku był drobny zgrzyt z kartą SIM - jako, że trzymam wciąż ten 9 letni zabytek to spodziewałem się problemów, ale nie aż tak dziwnych: wpisuję poprawny PIN i ekran mi się blokuje bynajmniej nie odblokowywując SIM. Drugi raz i trzeci. Sprawdzam z innym telefonem - karta OK. Restartuję. Za drugim razem poszło. Ale już stockowy miał czasem czkawkę z tym jakże istotnym modułem. Ostatnio zaczął wywalać mi _wrong pin_, chociaż jest dobry...  
  
    Jak wystartowało wszystko to pierwszy komunikat poinformował mnie, że _Wyszukiwarka Google przestała działać_. Cóż, można zignorować. Ja nie zignrowałem. Po dwukrotnym wgraniy gaps udało mi się przegonać Sklep Play, żeby zaktualizował mi Wyszukiwarkę Google. Wyszukiwarka Google zmieniła się w Google Now. Sam moduł szukania jest bardzo dobry, ale z jakichś przyczyn nie działała funkcja Now - utrzymywała, że GPS jest potrzebny, ale nie włączony. Jak się łatwo domyślić - był. Rzecz jak zwykle nigdzie nie opisana: jako, że mam konto w domenie to muszę GNow włączyć z panelu admina. Ale, żeby to zrobić trzeba mieć konto Business/Gov/Edu 🙁  
    Jako pierwszy animacjami, a zwłaszcza ich płynnością na tym ponoć słabym urządzeniu zaskoczył mnie launcher - domyślnie wgrana Nova. Kostka pulpitu niebędąca animacją, a realnym wyrenderowaniem rzuciła mi się jako pierwsza w oczy. Poza tym Nova systematyzuje znacząco pulpit. Robi to tym bardziej, że umozliwia zmianę rozmiaru siatki, skalowanie widżetów, czy ich nakładanie się - ale tylko w wersji Prime.  
    Kolejne, chronologicznie, dobre wrażenie wizualne należy do samego systemu. Proste, acz przyciągające uwagę animacje przełączania aktywnosci w ramach aplikacji (np. przejście do konfiguracji systemu) to przerzucanie kart na stosie, a otwieranie zanimowano powiększaniem z prawego dolnego rogu. Takich niespodzianek graficznych w systemie jest wiele więcej.  
    I co najważniejsze **animacje są estetyczne, wymagające od procesora lecz wyświetlane bardzo dobrz**. Mogę się chyba pokusić o stwierdzenie, że **UI 4.1 działa lepiej niż 4.0 od HTC** - to przeczy przyczynom nie wydawania przez HTC update'u dla One V. Ale jak HTC dogra Sense'a to może nie wyrobić, ten dziś już niskiej jak na smartfony z Androidem, procesor.
    
    **Kustomizacja**  
    W AOKP ustawienia są bogate: od możliwości dostosowania paska notyfikacji: switechery wszystkiego (nawet swag), pogoda, dostosowanie wyglądu baterii, sygnału WiFi/radia GSM... Power menu, czy wirtualny pasek z przyciskami to dość istotne dodatki. Co ciekawe trochę miejsca przeznaczono obsłudze dźwięku w zależności od profilu urządzenia. Motywy można wgrywać, ale większość jest płatna.  
    Ale zaraz, zarz - co to jest swag. Generalnie nic nie robi, taki dodatek developera 😉  
    Całkiem sensownie prezentują się też opcje wydajnosci - w ustawieniach można overclockować i downclockować CPU od 200MHz do 2GHz, czy ustawić _daily reboot_.  
  
    **Kompatybilność wsteczna**  
    Generalnie jest słabo, ale stabilnie. Część aplikacji już na starcie wywala _stopped working_. Można próbować reinstallu, jakichś apk'ów z internetu, ale dużych szans nie ma. I tak nie działają: IVONA, Polaris Office (nawet wersja 4.0 wyciągnięta z SGS3), Chrome i Firefox (przeglądarki te po załadowaniu GUI po prostu znikają, choć ich procesy nadal istnieją).  
    Ciekawy problem występuje z programem do szkicowania Skitch od Evernote - gdy rysujemy ołówkiem, zakreślaczem, prostokątem itp. nic nie widać. Jedyne, co jest widoczne to tekst. Ale, kiedy wyeksportujemy szkic do Evernote... okazuje się, że kreski są, gdzie być powinny. Inaczej zachowuje się APG - przy wyborze odbiorców zaszyfrowanej wiadomości w widoku listy gdy wiebiera się kogoś to tick powienien się pojawić - a go nie ma. Ale gdy zatwierdzimy wybór to interesująca nas osoba jest na liście w opisie kontrolki oraz... jest zatickowana gdy przejdziemy raz jeszcze do listy wyboru.  
    Generalnie nie jest to w tym momencie build dla osób chcących po prostu ściągnąć każdą aplikację z GPlay, chociaż zdecydowana większość programów działa.
    
    **Ewidentnie nie działa**  
    Naczelną niedoróbką jest aparat. O tym, że nieomal nie ma strerowników i zdjęcia wychodzą lekko mówiąc słabej jakości nawet jak na OneV informacji nigdzie nie znajdziemy. Problem wynika z faktu, że w OneV jest oddzielny procesor do aparatu. Nie mówię, że na pewno dało się yciągnąć wszystko, co potrzeba ze stockowego ICS'a, ale próżno szukać o tym czegokolwiek.
    
    **Ogólna wydajność**  
    System szybki, wytrzymuje sporo aplikacji. Przy dość intensywnym użytkowaniu ale w granicach rozsądku system raczej nie wymaga restartów, ale co 2-3 dni jednak prewencyjnie go zalecam - w końcu powinien być gotowy do pracy 24/7.  
    Bateria przy podobnym obciążeniu co ICS od Htc z Sense wytrzymuje podobnie, choć wydaje mi się, że nieco dłużej - około 1,75dnia standardowego dnia szkolnego. Wynik bardzo dobry zważywszy na używanie danych mobilnych, WiFi, i BlueTooth.
    
    **Podsumowanie**  
    Każdemu chcącemu mieć najnowszą wersję Androida, płynność, wydajność, ładne animacje, ale nie przejmującemu się aparatem, czy zgodnością wszystkich aplikacji (do czasu, kiedyś JB będzie bardziej popularny) polecam zrobić aktualizację AOKP na swoim OneV.

 [1]: http://www.android.com/about/jelly-bean/
 [2]: http://forum.xda-developers.com/showthread.php?t=1882990
 [3]: http://www.androidauthority.com/one-v-root-bootloader-unlock-custom-recovery-all-in-one-tool-93023/