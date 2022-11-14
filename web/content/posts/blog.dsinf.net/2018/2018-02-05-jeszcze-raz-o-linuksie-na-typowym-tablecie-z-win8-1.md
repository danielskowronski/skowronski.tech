---
title: Jeszcze raz o Linuksie na typowym tablecie z Win8.1
author: Daniel Skowroński
type: post
date: 2018-02-05T07:54:10+00:00
summary: '2.5 roku temu podjąłem pierwszą próbę zrobienia czegoś ciekawego z tabletem Colorovo CityTab pracującego na Windows 8.1 - na próbie wgrania tam sensownego Linuksa poległem, udało mi się jakimś cudem wgrać Windows 10 który jednak ciut zamula. Ostatnimi czasy tablet służy mi jako dodatkowy wyświetlacz na którym trzymam drobną webaplikację pokazującą zegar kartkowy (zawsze ładnie wyglądały), stan maszyn (projekt sauron3) i dane pogodowe wyciągane z otwartych API. Ot taki dodatek do centrum sterowania wszechświatem. Problem zaczyna się kiedy Windows 10 upiera się że chce zrobić update i wymaga 8GB wolnego dysku podczas gdy sam zużywa jakieś 11 z 16 dostępnych. No i poza chromem nie za wiele da się odpalić żeby system nie umarł z braku ramu.'
url: /2018/02/jeszcze-raz-o-linuksie-na-typowym-tablecie-z-win8-1/
tags:
  - hardware
  - linux
  - tablet

---
2.5 roku temu [podjąłem pierwszą próbę][1] zrobienia czegoś ciekawego z tabletem Colorovo CityTab pracującego na Windows 8.1 - na próbie wgrania tam sensownego Linuksa poległem, udało mi się jakimś cudem wgrać Windows 10 który jednak ciut zamula. Ostatnimi czasy tablet służy mi jako dodatkowy wyświetlacz na którym trzymam drobną webaplikację pokazującą zegar kartkowy (zawsze ładnie wyglądały), stan maszyn (projekt [sauron3][2]) i dane pogodowe wyciągane z otwartych API. Ot taki dodatek do centrum sterowania wszechświatem. Problem zaczyna się kiedy Windows 10 upiera się że chce zrobić update i wymaga 8GB wolnego dysku podczas gdy sam zużywa jakieś 11 z 16 dostępnych. No i poza chromem nie za wiele da się odpalić żeby system nie umarł z braku ramu.

Wróciłem więc do poddania w wątpliwość czy naprawdę nie da się czegoś sensownego postawić. Znalazłem kilka artykułów żeby [ściągnąć gotowy bootloader][3] bootia32.efi ładujący gruba na 32-bitowych dystrybucjach. Okazało się że mam trochę więcej szczęścia bo Debian w wersji x86 zawierał już ten plik i całą resztę niezbędną żeby podnieść system. Nie wiem czy za pierwszym razem to było moje przeoczenie czy Debian nie miał wówczas supportu EFI w wersji dla starych komputerów. Swoją drogą chyba tylko Debian został jedyną dużą dystrybucją z kompilacjami desktopowymi na coś więcej niż x64. Bo oczywiście można stawiać Gentoo (Arch już zerwał support x86 - a więc i sporo pochodnych dystrybucji cierpi) i bawić się w cross-kompilację - tylko że tablet odpalający przeglądarkę internetową i być może coś jeszcze przy okazji nie jest wystarczająco porywającym projektem żeby się w takie cuda bawić.

Debiana wystarczy pobrać ([live i386][4]), wgrać na nośnik USB przez [Rufusa][5] i można zaczynać zabawę. Oczywiście 2 rzeczy trzeba zrobić: backup (to już z samego debiana raczej) i... pobrać sterowniki WiFi, bo Debian to Debian i na 99% nasz tablet posiada coś niewolnego. Albo pobrać niekoszerną wersję non-free ([live i386 non-free][6]). W kwestii identyfikowania sprzętu najprościej posiłkować się devmgmt.msc z Windowsa - lsusb/lspci nie zawsze pomagają na SoC gdzie część urządzeń dostępna jest za dziwnymi magistralami. Dla mojego Colorovo kontroler WiFi (i bluetootha przy okazji) to Realtek 8723BS - wiki debiana [ma instrukcje][7]. Chociaż jak się okazuje - nieaktualne bo driver rtl8723bs jest już w kernel-next, na debianie wystarczy zainstalować paczkę `linux-image-4.15` . Oczywiście do całego procesu przydaje się karta sieciowa na USB.

W kwestii środowiska graficznego - na sprzęcie z tak małą ilością pamięci do wyboru są okrojone managery okien (jak Xmonad czy i3), LXDE albo XFCE. Przetestowałem wszystkie inne "główne" (te z kompilacją live cd debiana) i wszystkie cięły niemiłosiernie. Osobiście jestem fanem XFCE więc wybrałem XFCE.

Jeśli chodzi o ekran dotykowy to działa to out-of-the-box, trzeba tylko zaktualizować system żeby wszystko co podczas instalacji nie zostało wykryte zostało wykryte. Zabawa zaczyna się w momencie obrotu tabletu - ja pominąłem automatykę czyli obsługę czujnika (w moim wypadku Kionix) bo urządzenie cały czas stoi w jednej pozycji. Ale problem polega na tym że obrócenie ekranu przez xrandra nie wystarcza - obraz się obróci, ale mapowanie ekranu dotykowego - nie. Do tego trzeba pomanipulować przy użyciu xinput. Całkiem zgrabny skrypt, który zapewne można podpiąć pod coś co będzie łapało eventy obrotu urządzenia [jest na githubie][8].

Jeszcze w kwestii zarządzania takim setupem - bardzo przydaje się x11vnc bo pozwala na dopięcie się do bieżącej sesji Xów (coś jak TeamViewer). Komenda odpalająca serwer to:

```bash
x11vnc -noxdamage -display :0 -safer -once -xrandr [-nopw|-auth $xauth_file]
```


Na sam koniec warto dodać jak pozbyć się wyłączania ekranu. Wystarczy z autostartu (ustawiania/zarządzanie sesją) wywalić deamona blokady ekranu (`light-locker`) i do `.xinitrc`  dodać na początku:

```bash
xset s off         
xset -dpms
xset s noblank

# exec session-manager 
# i reszta
```


 [1]: https://blog.dsinf.net/2015/06/uruchamianie-czegokolwiek-poza-windowsem-na-tablecie-typu-win8-1-z-uefi/
 [2]: https://github.com/danielskowronski/sauron3
 [3]: https://askubuntu.com/a/775507
 [4]: https://cdimage.debian.org/debian-cd/current-live/i386/iso-hybrid/
 [5]: https://rufus.akeo.ie
 [6]: https://cdimage.debian.org/images/unofficial/non-free/images-including-firmware/9.3.0-live+nonfree/i386/
 [7]: https://wiki.debian.org/InstallingDebianOn/Lenovo/100S-11IBY/jessie#WiFi
 [8]: https://gist.github.com/mildmojo/48e9025070a2ba40795c