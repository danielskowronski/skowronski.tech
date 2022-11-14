---
title: Moje środowisko pracy zdalnej na Windowsie (i macOS)
author: Daniel Skowroński
type: post
date: 2017-09-03T18:07:51+00:00
summary: 'Jako że jednak potrzebuję windowsa jako głównego systemu na stacji roboczej od zawsze nasuwał się problemy - jak się podłączyć do serwerów linuksowych czy zbudować lokalnie jakąś paczkę. Po długich eksperymentach z cygwinem, mingw i innymi wynalazkami doszedłem do wniosku że jak potrzebuję mieć shella linuksowego żeby użyć grepa, seda i awka to wystarczy bash wbudowany w dowolnego klienta gita - na przykład cudowną aplikację Github Desktop. A jeśli chodzi o prawdziwe zainstalowanie prawdziwego pakietu to nie ma innej opcji jak maszyna wirtualna. Warto jednak dołożyć kilka kroków żeby było przyjemniej. Warto wspomnieć iż o słynnym Linuksie w Windowsie wydanym przez Microsoft nie warto wspominać. To cygwinowe ubuntu (lub SuSE) które nada się do basha, ale nawet emulatora terminala nie ma porządnego...'
url: /2017/09/moje-srodowisko-pracy-zdalnej-na-windowsie-i-macos/
featured_image: /wp-content/uploads/2017/09/13.png
tags:
  - linux
  - sftp
  - software
  - środowisko
  - ssh
  - sublime text
  - windows

---
Jako że jednak potrzebuję windowsa jako głównego systemu na stacji roboczej od zawsze nasuwał się problemy - jak się podłączyć do serwerów linuksowych czy zbudować lokalnie jakąś paczkę. Po długich eksperymentach z cygwinem, mingw i innymi wynalazkami doszedłem do wniosku że jak potrzebuję mieć shella linuksowego żeby użyć grepa, seda i awka to wystarczy bash wbudowany w dowolnego klienta gita - na przykład cudowną aplikację [Github Desktop][1]. A jeśli chodzi o prawdziwe zainstalowanie prawdziwego pakietu to nie ma innej opcji jak maszyna wirtualna. Warto jednak dołożyć kilka kroków żeby było przyjemniej.

![wspomniany Github Desktop](/wp-content/uploads/2017/09/7.png)

## **Linuks na windowsie - maszyna wirtualna**

Sercem mojego setupu jest maszyna wirtualna, którą nazwałem _devARCH_ bo służy mi głównie do budowania binarek i stoi na Archu. Gołym archu bez środowiska graficznego nawet. Osobiście używam VMware Workstation ale jakikolwiek hyperwizor się nada. Przez to że mam trochę mocy na zbyciu to dostała wszystkie rdzenie procesora, limit pamięci na 32GB i dysk 128GB. Do mojej pracy aż nadto. Póki co nie miałem potrzeby parsować dużych plików z hosta gospodarza ale wtedy wystarczy zainstalować dodatek typu _guest additions_ i zdefiniować folder współdzielony.

Warto wspomnieć iż o słynnym [Linuksie w Windowsie wydanym przez Microsoft][3] nie warto wspominać. To cygwinowe ubuntu (lub SuSE) które nada się do basha, ale nawet emulatora terminala nie ma porządnego...

## Dostęp zdalny

Ale jak się wygodnie zasshować do tejże maszyny? PuTTY osobiście używam tylko do łączenia się do portu szeregowego - otwieranie każdej sesji w osobnym oknie, własny fikuśny agent ssh i dość ograniczone możliwości powodują że jest świetny jako coś na szybko co mieści się w jednej binarce ale na dłuższą metę - bez przesady.

![Bugs, More bugs, PuTTY...](/wp-content/uploads/2017/09/8.png)

Cygwinowe ssh ma swój urok, ale kiedy wpadnie nam do głowy support dziwnych terminali ($TERM) i kodowań przy ncurses - da się, ale można wygodniej. Ostatnio jest hype na emulator [Hyper][5] - cóż, użycie frameworka [Electron][6] czyli silnika chrome odpalającego aplikację w JS - tego samego co do [Atoma][7] kończy jego użyteczność na krótkiej sesji ssh.

Z ciekawej listy na <https://www.slant.co/topics/1552/~terminal-emulators-for-windows> przetestowałem większość. I jedyny bezpłatny który zdał egzamin to [MobaXterm][8]. Plusuje mnogością obsługiwanych protokołów i opcji ich konfiguracji. W tym opcją wysyłania heartbeatu po SSH żeby sesja się nie urwała. Działa także mini przeglądarka plików (która eksperymentalnie podąża za $PWD), tunelowanie Xów i własny, ale kompatybilny z normalnymi kluczami agent. Poza tym miliard innych opcji które mogą się przydać w przyszłości - kolorowanie składni, logowanie sesji do pliku tekstowego, narzędzia jak GUI nmapa czy wbudowane serwery.  Dla użytkowników domowych jest darmowy z pewnymi ograniczeniami (jak liczba sesji na raz ograniczona do 12 - da się wytrzymać oraz limitem życia usług takich jak _serwer NFS_ do 6 minut). $69/usera to nie tak drogo za wersję pro zważywszy na stertę funkcjonalności wspomagających.  Ma także wbudowanego cygwina więc i lokalny shell nadaje się do jakiegokolwiek użytku.

![MobaXterm - protokoły](/wp-content/uploads/2017/09/9.png)

![MobaXterm - okno sesji](/wp-content/uploads/2017/09/10.png)

## Dostęp zdalny - GUI

Może się okazać że z jakiegoś graficznego programu trzeba będzie jednak skorzystać. Albo podłączyć się do całej sesji (mam taki dziwny setup w jednym miejscu że najwygodniej mi łączyć się do laptopa ze stacji roboczej żeby nie marnować ekranu). Tu rozwiązaniem jest [x2go][11]. Opiera się na NX i działa znacznie efektywniej niż VNC i wygodniej niż czyste tunelowanie Xorga. Wymaga paczki na serwerze linuksowym, a programy klienckie dostępne są na wszystkie systemy. Warto dodać że poza zwykłym podłączaniem się do nowej sesji X i jej wznawianiem w czasie późniejszym można także podpiąć się do fizycznego TTY lub odpalić pojedynczą aplikację zamiast środowiska graficznego. Projekt jest bardzo dojrzały - obsługuje także MFA w SSH, włączając w to yubikeyowe OTP dzięki mojemu requestowi na kilka godzin przed releasem 😀

![Klient x2go na windowsie](/wp-content/uploads/2017/09/12.png)

## Pliki

Zatem mamy jak się podłączyć do linuksa lokalnego bądź też do serwera zdalnego. Ale jak dobrać się do plików - można niby używać zdalnego emacsa czy vi ale czasem przydaje się coś większego. Na UNIXach naturalny jest SFTP. Najlepiej byłoby mieć foldery zamontowane jako dysk sieciowy bo używanie WinSCP przy całym jego uroku nie nadaje się do jakkolwiek poważnej pracy poza edycją skryptów PHP w locie. Tylko że Windows nie ma klienta SSHFS. Jest niby [Dokan][13] który implementuje FUSE przez co używa linuksowego sshfs ale rozwiązanie jest tragicznie niestabilne. MountainDuck wygląda i działa obiecująco, ale jest płatny.

Istnieje na szczęście alternatywa - [SFTP Net Drive][14], który dla użytkowników domowych jest darmowy ma jednak pewne ograniczenie logiczne w GUI - nie da się użyć kilku połączeń na raz, a z jakiegoś powodu da się mieć tylko jedną instancję okienka na raz. Da się to jednak obejść wpierw tworząc w GUI profile a następnie używając trybu CLI i puszczania aplikacji w tle:

```
[Daniel.YGGDRASIL] ➤ cd "/cygdrive/c/Program Files (x86)/SFTP Net Drive 2017"
[Daniel.YGGDRASIL] ➤ ./SftpNetDrive.exe start /profile:"devarch-proj" &
[2] 32
[Daniel.YGGDRASIL] ➤ ./SftpNetDrive.exe start /profile:"####-home" &
[1] 42980
```


Sama konfiguracja w GUI jest przyjemna i ma mnóstwo opcji:

![](/wp-content/uploads/2017/09/3.png)

![](/wp-content/uploads/2017/09/4.png)

![](/wp-content/uploads/2017/09/5.png)

![](/wp-content/uploads/2017/09/6.png)

W windowsie pojawia nam się nowy dysk sieciowy i nie ma problemu z rozszerzonymi atrybutami (nie psują się po stronie serwera)

![](/wp-content/uploads/2017/09/2.png)

![](/wp-content/uploads/2017/09/1.png)

## Edytor plików

Mój wybór zasadniczo nie zmienił się względem [tego sprzed trzech lat][21] (poza faktem że kupiłem licencję; info praktyczne - licencji można używać na dowolnej liczbie urządzeń, w tym w pracy) - dalej [Sublime Text][22] mimo głosów że edytor się skończył to [pluginów przybywa][23], a aktualizacje też się pojawiają.  Co do pluginów to nie używam wielu (większość pomocna jest przy HTMLu): A File Icon, Color Highlighter, ColorPick, Emmet, Git, MarkdownLivePreview, Perforce (głównie w pracy), SideBarEnhancements, SublimeLinter, SublimeREPL oraz motywu Material-Theme-Darker.tmTheme. Rozszerzanie możliwości jest także wygodne - napisałem już kilka podświetlaczy składni dla dziwnych formatów logów i konfiguracji.

![SublimeText w całej okazałości wraz z menu Ctrl+Shift+P](/wp-content/uploads/2017/09/11.png)

## Łączność

O użyciu ZeroTiera [pisałem jakiś czas temu][25] - generalnie jest to Software Defined Network. Dzięki temu można dostać się do takowej wirtualki z zewnątrz, a nawet zwiększyć bezpieczeństwo całej floty serwerów dopuszczając logowanie tylko z sieci zerotier (warto jednak zabezpieczyć sobie dostęp KVM do VPSów czy serwerów kolokowanych na wypadek awarii). O estetycznej adresacji nie wspominając. Kiedy dołożymy współdzielone foldery do maszyny wirtualnej można zdalnie dostać się do stacji roboczej i korzystać z jej zasobów - przez SSH.

## Podsumowanie na Windowsie

Dla pełnej wygody z używania Linuksa pod Windowsem w mojej opinii trzeba jednak maszyny wirtualnej z prawdziwym Linuksem i zestawu narzędzi do podłączenia się do niej - jest on też niezbędny żeby pracować na innych serwerach. W skład zestawu wchodzi odpowiednik sshfs, wygodny terminal i edytor tekstu.

## A co z macOS?

Nie jest to mój główny system, używam go tylko na kanapie, w terenie i serwerowni. No i przez to że jest systemem unixowym (zgodny z POSIX? to cicho!) i ma basha to da się działać prawie jak na Linuksie. Osobiście kiedy mogę to używam natywnych rozwiązań (gcc, kompilator go, python, perl, ruby i reszta działają przecież dobrze i nie ma gimnastyki z dziwnymi ścieżkami jak na Windowsie) które można instalować przez [brew][26]. Jakiś czas temu miałem maszynę wirtualną z Linuksem do budowania paczek, ale macbook air nie ma kolosalnej mocy więc przerzuciłem się na budowanie na zdalnym serwerze na którym i tak cały projekt działał.

Jeśli chodzi o terminal to cóż - jak używam SSH to wbudowana aplikacja jest wystarczająca (głównie dlatego że prawie zawsze używam jej na 13- ekranie - cudów nie wymagam, a prawdziwe SSH to prawdziwe SSH). Oczywiście kwestia edytora i ZeroTiera pozostaje bez zmian.

 [1]: https://desktop.github.com/
 [2]: /wp-content/uploads/2017/09/7.png
 [3]: https://msdn.microsoft.com/en-us/commandline/wsl/about
 [4]: /wp-content/uploads/2017/09/8.png
 [5]: https://hyper.is/
 [6]: https://electron.atom.io/
 [7]: https://atom.io/
 [8]: http://mobaxterm.mobatek.net/
 [9]: /wp-content/uploads/2017/09/9.png
 [10]: /wp-content/uploads/2017/09/10.png
 [11]: https://wiki.x2go.org/doku.php
 [12]: /wp-content/uploads/2017/09/12.png
 [13]: https://github.com/dokan-dev/dokan-sshfs
 [14]: http://www.sftpnetdrive.com/
 [15]: /wp-content/uploads/2017/09/3.png
 [16]: /wp-content/uploads/2017/09/4.png
 [17]: /wp-content/uploads/2017/09/5.png
 [18]: /wp-content/uploads/2017/09/6.png
 [19]: /wp-content/uploads/2017/09/2.png
 [20]: /wp-content/uploads/2017/09/1.png
 [21]: https://blog.dsinf.net/2014/01/edytor-uniwersalny/
 [22]: https://www.sublimetext.com/3
 [23]: https://packagecontrol.io/
 [24]: /wp-content/uploads/2017/09/11.png
 [25]: https://blog.dsinf.net/2017/02/zerotier-czyli-software-defined-network-czyli-alternatywa-dla-klasycznego-vpna/
 [26]: https://brew.sh/index_pl.html