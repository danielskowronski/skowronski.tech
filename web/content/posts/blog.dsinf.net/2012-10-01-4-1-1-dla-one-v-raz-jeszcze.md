---
title: 4.1.1 dla One V raz jeszcze
author: Daniel Skowroński
type: post
date: 2012-10-01T20:15:49+00:00
excerpt: |
  Jak było do przewidzenia, długo nie wytrzymałem korzystając "tylko" ze stabilnej wersji od razu jak tylko znalazłem wgrałem wersję nighty. 
  I to był początek nowej przygody.
url: /2012/10/4-1-1-dla-one-v-raz-jeszcze/
tags:
  - android

---
Jak było do przewidzenia, długo nie wytrzymałem korzystając "tylko" ze stabilnej wersji od razu jak tylko znalazłem wgrałem wersję nighty.  
Po nie wartej opisania przeprawie z aktualizacją pozostaje tylko jeden wniosek, szczególnie cenny dla początkujących (tak jak ja) w świecie "psucia" Androida: **każdy ROM musi mieć swój _boot image_**. Oznacza to, że jak developer da nowszy plik boot.img to <u>trzeba</u> go wgrać, bo inaczej system się nie odpali. Odpowiedzialna jest za to komenda

<pre class="EnlighterJSRAW bash">fastboot flash boot obraz.img</pre>

Naturalnie telefon musi być w trybie bootloader'a (Power+VolDown), po aktywowaniu USB (odpowiedni wpis w menu) i przejściu do menu HBOOT.

Jeszcze przedwczoraj najnowszą wersją była _aokp\_primou\_unofficial_Sep-24-12.zip_ wydana 25 września. W stosunku do stabilnej rozwiązała kilka drobnych problemów z obsługą urządzeń: głównie obsługi SIM, radia GSM - szczególnie ponownego włączania danych pakietowych (co wcześniej zabierało sporo czasu, a i tak często wymagało po prostu przeinicjalizowania tegoż radia - najprościej tryb samolotowy on/off lub aktywować force 2G i zdezaktywować) oraz bluetooth.  
Ale ta wersja zawierała jeden spory błąd: <u>system w ogóle nie przechwytywał klawisza menu</u>. Recovery zgłasza, że klawisz jest OK, po wyciemnieniu podświetlenia klawiszy dotykowych można je ponownie włączyć klikając nań, więc to wina tylko i wyłącznie software'u. Potwierdziło to włączeniu w _ROM control_ paska nawigacji i dodanie doń przycisku menu. Rezultat ten sam - nie działa. Wygląda jakby nowy model Google, czyli <u>żadnego przycisku menu!</u> wchodził w życie - to aplikacja ma wyświetlić trzy kropki w pasku tytułu. Podczas prób zaradzenia temu problemowi zmieniłem nawet gęstość ekranu do 120 oraz wymusiłem interfejs tabletu - wówczas menu nie działa, a telefon trzeba obsługiwać rysikiem o bardzo cienkim końcu, choć palcem od biedy też się da.  
Innym krytycznym błędem jest <u>brak kont Google (sic!)</u>.

Ale w końcu (po aż 5 dniach przerwy) wyszła wersja _aokp\_primou\_unofficial_Sep-30-12.zip_ (do pobrania [tu][1]). Pojawia się ponownie konto Google, Google Now działa od nowości, przycisk menu działa, a nic (przynajmniej nie zauważyłem) krytycznego nie jest napsute. ROM w tej wersji jest już stabilniejszy.  
Pojawiła się także nowa animacja rozruchowa.  
Coś bardzo dziwnego, ale to nic nie ujmuje pracy developerów projektu Android Open Kang Project - za <u>każdym</u> rozruchem Android startuje aplikacje oraz finalizuje rozruch, co powinno zadziać się tylko raz po fazie optymalizacji aplikacji (aktualizacja OS lub wyczyszczony cache Dalvik). Na szczęście nie trwa to długo.

Podsumowywując: _bootimage_ ważny jest, _nightlies_ mogą mieć spore błędy, acz zazwyczaj działają, a kombinacja Power+VolDown stała się moim przyjacielem w podróży po świecie "psucia" Andka 😉

 [1]: http://goo.im/devs/gannon5197/aokp/primou/nightlies