---
title: Windows 8 a multiboot oraz przedziwny atrybut AMI BIOSu "SATA mode"
author: Daniel Skowroński
type: post
date: 2012-06-25T16:14:28+00:00
url: /2012/06/windows-8-a-multiboot-oraz-przedziwny-atrybut-ami-biosu-sata-mode/
tags:
  - bios
  - windows
  - windows 8

---
Artykuł ten pisałem jako luźną notatkę jeszcze do wersji Consumer Preview ósemki. Od tego czasu trochę się zmieniło, lecz to, co można znaleźć w Internecie nt. tego problemu - nie.

Mało kto w etapie Preview (swoją drogą od zawsze nazywano to Release Candidate, ale MS lubi podglądy więc niech im będzie) korzysta tylko z Bety – większość ludzi doinstalowywuje go obok wysłużonego XP, czy Siódemki oraz nierzadko Linuksa. Bo trzeba mieć działający system.  
Po setupie, który jest jak na systemy z Redmond szybki widzimy graficzny(!) bootloader, ale 99% z nas kliknie Enter lub pobawi się myszką. I to był statni raz kiedy w normalnych warunkach ujrzymy ten ekran, dający także zaawansowane opcje rozruchu, takie jak chociażby Tryb Awaryjny. Dlaczego? Część czytelników zapewne powie "Wciśnij F8". I tu zaczynają się schody. Genialni programiści pracujący pod skrzydłami Steven’a Sinofsky’iego uznali, że skoro system odpala się 7 sekund (czysty może i tak, ale nie czepiajmy się...) to czas na kliknięcie F8 to... 200 milisekund. Naturalnie trzymanie od POSTa F8 nic nie da, bo trzeba kliknąć i wstrzelić się w ten okres czasu. Ale (na szczęście) to nie jedyny sposób aby dostać się do boot menu.  
Jak dowiadujemy się przez przypadek (bo po co informować użytkownika o opcjach systemu, niech się pobawi): klikając Restart (także nieźle ukryty; Ctrl+Alt+Del to jedyne graficzne miejsce z opcjami wyłączania) trzeba wcisnąć Shift. I co ujrzymy? Bootloader. Cóż. Trochę dziwne miejsce jak na uruchamianie trybu awaryjnego, ale OK. Co to znaczy? Że Okienka muszą działać, by dostać się do boot menu. Ale chyba tryb awaryjny odpalamy, jak coś nie działa.  
Wydawać by się mogło, że MS trochę przewidział i po awarii systemu pokazuje się niebieski ekran z bialamy literkami z listą wyboru opcji rozruchu. Otóż nie. Windows zyskal inteligencję i nawet po jednym nieudanym rozruchu (co osiąga się chociażby pięciosekundowym power buttonem) zaczyna się naprawiać. WTF?!  
Ratunek? Metoda zajmująca każdorazowo kilka minut: płyta instalacyjna (lub pendrive). Uwaga, to nie jest wcale takie oczywiste. Po załadowaniu całego OSa (jakby nie można tego było umieścić w menu rozruchowym samej płyty) wybieramy klawiaturę, potem Repair, następnie Advanced aż wrzeszcie Select another OS. Ręce opadają. \o/  
Ale to nie koniec. Jestem w trudniejszej sytuacji, bo na laptopie, którego używam (dość powszechny problem) mam do wyboru dwa tryby magistrali SATA: Enchanced i Compatibile. Systemy do Win2k3r2, w tym XP nie wspólpracują z "fajniejszym" trybem tylko BSoDują się. Zaś Win8 nie jest wstecznie zgodny i na trybie kompatybilnym też się BSoDuje, tym razem z minką. Co ciekawe ten tryb zmienia też zachowanie hybrydowej karty graficznej, ale to temat na oddzielny tekst. Wracając do meritum. Windows używając opcji restart (też przy wyborze innego systemu operacyjnego w nowym bootloaderze) odwołuje się do trochę innef funkcji BIOSu, tak, że można łatwo się zagapić i nie wejść do SETUPa. A co z "Press any key to boot from DVD..."? Żeby było zabawnie pojawia się po kilkusekundowym blackscreenie, kiedy to płytka sprawdza dysk -.-  
Reasumując: żeby odpalić inny system najefektywniej i najprościej trzeba odpalić komputer z DVD, odczekać swoje i... już. Dziękujmy MS za tak dobry system. Ale zaraz? To chyba parzysta wersja.

Posłowie:  
A czym wita mnie z trudem odpalony Windows 2003? Przegapionym CHKDSK. 

Update:  
Po dogłębnej analizie doszedłem do wniosku, że (przynajmniej w RP) bootloader ukazuje sie naszym oczom <u>po</u> ekranie startowym Windowsa - tym kręcącym się kółku z kropek. Nasuwa to wątpliwości dotyczące magicznego sposobu przejścia z załadowanego częściowo do pamięci Windowsa, gotowego do kontynuacji rozruchu do innej jego wersji. Jak na MS przystało jest mijak: ciepły restart, który na szczęscie w moim laptopie pozwala mi wejść do BIOSu i zmienić "SATA mode". Na kilka słów uwagi zasługuje właśnie ten atrybut: otóż zmienia nie tylko tryb SATY, ale także sposób zachowania hybrydowej grafiki, tak, że Linuksy "widzą" Nvidię, co umożliwia instalację sterowników, czy w nowszych dystrybucjach w ogóle widzenie złącza HDMI. Pewnie komuś się nie chciało robić paru opcji i co można trochę wywnioskować z helpa zrobiono dwa tryby: stare systemy takie jak 2000&XP i nowsze. Swoją drogą... sam bym tak chyba zrobił, ale przyzwoitość nakazałaby mi albo dopisać w helpie co także jest zmieniane, ale nazwać to w stylu "tryb ogólnej kompatybilności: stary OS/nowy OS".