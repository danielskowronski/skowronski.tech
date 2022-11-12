---
title: Moje środowisko pracy zdalnej na Windowsie (i macOS)
author: Daniel Skowroński
type: post
date: 2017-09-03T18:07:51+00:00
excerpt: 'Jako że jednak potrzebuję windowsa jako głównego systemu na stacji roboczej od zawsze nasuwał się problemy - jak się podłączyć do serwerów linuksowych czy zbudować lokalnie jakąś paczkę. Po długich eksperymentach z cygwinem, mingw i innymi wynalazkami doszedłem do wniosku że jak potrzebuję mieć shella linuksowego żeby użyć grepa, seda i awka to wystarczy bash wbudowany w dowolnego klienta gita - na przykład cudowną aplikację Github Desktop. A jeśli chodzi o prawdziwe zainstalowanie prawdziwego pakietu to nie ma innej opcji jak maszyna wirtualna. Warto jednak dołożyć kilka kroków żeby było przyjemniej. Warto wspomnieć iż o słynnym Linuksie w Windowsie wydanym przez Microsoft nie warto wspominać. To cygwinowe ubuntu (lub SuSE) które nada się do basha, ale nawet emulatora terminala nie ma porządnego...'
url: /2017/09/moje-srodowisko-pracy-zdalnej-na-windowsie-i-macos/
featured_image: https://blog.dsinf.net/wp-content/uploads/2017/09/13.png
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

<figure id="attachment_1077" aria-describedby="caption-attachment-1077" style="width: 665px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1077 size-large" src="http://blog.dsinf.net/wp-content/uploads/2017/09/7-1024x609.png" alt="" width="665" height="395" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/7-1024x609.png 1024w, https://blog.dsinf.net/wp-content/uploads/2017/09/7-300x179.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/7-768x457.png 768w, https://blog.dsinf.net/wp-content/uploads/2017/09/7-660x393.png 660w, https://blog.dsinf.net/wp-content/uploads/2017/09/7.png 1109w" sizes="(max-width: 665px) 100vw, 665px" />][2]<figcaption id="caption-attachment-1077" class="wp-caption-text">wspomniany Github Desktop</figcaption></figure>

## **Linuks na windowsie - maszyna wirtualna**

Sercem mojego setupu jest maszyna wirtualna, którą nazwałem _devARCH_ bo służy mi głównie do budowania binarek i stoi na Archu. Gołym archu bez środowiska graficznego nawet. Osobiście używam VMware Workstation ale jakikolwiek hyperwizor się nada. Przez to że mam trochę mocy na zbyciu to dostała wszystkie rdzenie procesora, limit pamięci na 32GB i dysk 128GB. Do mojej pracy aż nadto. Póki co nie miałem potrzeby parsować dużych plików z hosta gospodarza ale wtedy wystarczy zainstalować dodatek typu _guest additions_ i zdefiniować folder współdzielony.

Warto wspomnieć iż o słynnym [Linuksie w Windowsie wydanym przez Microsoft][3] nie warto wspominać. To cygwinowe ubuntu (lub SuSE) które nada się do basha, ale nawet emulatora terminala nie ma porządnego...

## Dostęp zdalny

Ale jak się wygodnie zasshować do tejże maszyny? PuTTY osobiście używam tylko do łączenia się do portu szeregowego - otwieranie każdej sesji w osobnym oknie, własny fikuśny agent ssh i dość ograniczone możliwości powodują że jest świetny jako coś na szybko co mieści się w jednej binarce ale na dłuższą metę - bez przesady.

<figure id="attachment_1069" aria-describedby="caption-attachment-1069" style="width: 450px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1069 size-full" src="http://blog.dsinf.net/wp-content/uploads/2017/09/8.png" alt="" width="450" height="410" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/8.png 450w, https://blog.dsinf.net/wp-content/uploads/2017/09/8-300x273.png 300w" sizes="(max-width: 450px) 100vw, 450px" />][4]<figcaption id="caption-attachment-1069" class="wp-caption-text">Bugs, More bugs, PuTTY...</figcaption></figure>

Cygwinowe ssh ma swój urok, ale kiedy wpadnie nam do głowy support dziwnych terminali ($TERM) i kodowań przy ncurses - da się, ale można wygodniej. Ostatnio jest hype na emulator [Hyper][5] - cóż, użycie frameworka [Electron][6] czyli silnika chrome odpalającego aplikację w JS - tego samego co do [Atoma][7] kończy jego użyteczność na krótkiej sesji ssh.

Z ciekawej listy na <https://www.slant.co/topics/1552/~terminal-emulators-for-windows> przetestowałem większość. I jedyny bezpłatny który zdał egzamin to [MobaXterm][8]. Plusuje mnogością obsługiwanych protokołów i opcji ich konfiguracji. W tym opcją wysyłania heartbeatu po SSH żeby sesja się nie urwała. Działa także mini przeglądarka plików (która eksperymentalnie podąża za $PWD), tunelowanie Xów i własny, ale kompatybilny z normalnymi kluczami agent. Poza tym miliard innych opcji które mogą się przydać w przyszłości - kolorowanie składni, logowanie sesji do pliku tekstowego, narzędzia jak GUI nmapa czy wbudowane serwery.  Dla użytkowników domowych jest darmowy z pewnymi ograniczeniami (jak liczba sesji na raz ograniczona do 12 - da się wytrzymać oraz limitem życia usług takich jak _serwer NFS_ do 6 minut). $69/usera to nie tak drogo za wersję pro zważywszy na stertę funkcjonalności wspomagających.  Ma także wbudowanego cygwina więc i lokalny shell nadaje się do jakiegokolwiek użytku.

<figure id="attachment_1070" aria-describedby="caption-attachment-1070" style="width: 730px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1070 size-full" src="http://blog.dsinf.net/wp-content/uploads/2017/09/9.png" alt="" width="730" height="545" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/9.png 730w, https://blog.dsinf.net/wp-content/uploads/2017/09/9-300x224.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/9-660x493.png 660w" sizes="(max-width: 730px) 100vw, 730px" />][9]<figcaption id="caption-attachment-1070" class="wp-caption-text">MobaXterm - protokoły</figcaption></figure>

<figure id="attachment_1071" aria-describedby="caption-attachment-1071" style="width: 665px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1071 size-large" src="http://blog.dsinf.net/wp-content/uploads/2017/09/10-1024x497.png" alt="" width="665" height="323" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/10-1024x497.png 1024w, https://blog.dsinf.net/wp-content/uploads/2017/09/10-300x146.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/10-768x373.png 768w, https://blog.dsinf.net/wp-content/uploads/2017/09/10-660x320.png 660w, https://blog.dsinf.net/wp-content/uploads/2017/09/10.png 1237w" sizes="(max-width: 665px) 100vw, 665px" />][10]<figcaption id="caption-attachment-1071" class="wp-caption-text">MobaXterm - okno sesji</figcaption></figure>

## Dostęp zdalny - GUI

Może się okazać że z jakiegoś graficznego programu trzeba będzie jednak skorzystać. Albo podłączyć się do całej sesji (mam taki dziwny setup w jednym miejscu że najwygodniej mi łączyć się do laptopa ze stacji roboczej żeby nie marnować ekranu). Tu rozwiązaniem jest [x2go][11]. Opiera się na NX i działa znacznie efektywniej niż VNC i wygodniej niż czyste tunelowanie Xorga. Wymaga paczki na serwerze linuksowym, a programy klienckie dostępne są na wszystkie systemy. Warto dodać że poza zwykłym podłączaniem się do nowej sesji X i jej wznawianiem w czasie późniejszym można także podpiąć się do fizycznego TTY lub odpalić pojedynczą aplikację zamiast środowiska graficznego. Projekt jest bardzo dojrzały - obsługuje także MFA w SSH, włączając w to yubikeyowe OTP dzięki mojemu requestowi na kilka godzin przed releasem 😀

<figure id="attachment_1083" aria-describedby="caption-attachment-1083" style="width: 610px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1083 size-full" src="http://blog.dsinf.net/wp-content/uploads/2017/09/12.png" alt="" width="610" height="552" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/12.png 610w, https://blog.dsinf.net/wp-content/uploads/2017/09/12-300x271.png 300w" sizes="(max-width: 610px) 100vw, 610px" />][12]<figcaption id="caption-attachment-1083" class="wp-caption-text">Klient x2go na windowsie</figcaption></figure>

## Pliki

Zatem mamy jak się podłączyć do linuksa lokalnego bądź też do serwera zdalnego. Ale jak dobrać się do plików - można niby używać zdalnego emacsa czy vi ale czasem przydaje się coś większego. Na UNIXach naturalny jest SFTP. Najlepiej byłoby mieć foldery zamontowane jako dysk sieciowy bo używanie WinSCP przy całym jego uroku nie nadaje się do jakkolwiek poważnej pracy poza edycją skryptów PHP w locie. Tylko że Windows nie ma klienta SSHFS. Jest niby [Dokan][13] który implementuje FUSE przez co używa linuksowego sshfs ale rozwiązanie jest tragicznie niestabilne. MountainDuck wygląda i działa obiecująco, ale jest płatny.

Istnieje na szczęście alternatywa - [SFTP Net Drive][14], który dla użytkowników domowych jest darmowy ma jednak pewne ograniczenie logiczne w GUI - nie da się użyć kilku połączeń na raz, a z jakiegoś powodu da się mieć tylko jedną instancję okienka na raz. Da się to jednak obejść wpierw tworząc w GUI profile a następnie używając trybu CLI i puszczania aplikacji w tle:

<pre class="lang:default EnlighterJSRAW ">[Daniel.YGGDRASIL] ➤ cd "/cygdrive/c/Program Files (x86)/SFTP Net Drive 2017"
[Daniel.YGGDRASIL] ➤ ./SftpNetDrive.exe start /profile:"devarch-proj" &
[2] 32
[Daniel.YGGDRASIL] ➤ ./SftpNetDrive.exe start /profile:"####-home" &
[1] 42980</pre>

Sama konfiguracja w GUI jest przyjemna i ma mnóstwo opcji:

[<img decoding="async" loading="lazy" class="alignnone wp-image-1073 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/3-300x209.png" alt="" width="300" height="209" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/3-300x209.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/3-200x140.png 200w, https://blog.dsinf.net/wp-content/uploads/2017/09/3.png 527w" sizes="(max-width: 300px) 100vw, 300px" />][15][<img decoding="async" loading="lazy" class="alignnone wp-image-1074 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/4-300x214.png" alt="" width="300" height="214" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/4-300x214.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/4.png 514w" sizes="(max-width: 300px) 100vw, 300px" />][16][<img decoding="async" loading="lazy" class="alignnone wp-image-1075 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/5-300x214.png" alt="" width="300" height="214" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/5-300x214.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/5.png 514w" sizes="(max-width: 300px) 100vw, 300px" />][17][<img decoding="async" loading="lazy" class="alignnone wp-image-1076 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/6-300x214.png" alt="" width="300" height="214" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/6-300x214.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/6.png 514w" sizes="(max-width: 300px) 100vw, 300px" />][18]

W windowsie pojawia nam się nowy dysk sieciowy i nie ma problemu z rozszerzonymi atrybutami (nie psują się po stronie serwera)

[<img decoding="async" loading="lazy" class="alignnone wp-image-1080 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/2-300x298.png" alt="" width="300" height="298" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/2-300x298.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/2-150x150.png 150w, https://blog.dsinf.net/wp-content/uploads/2017/09/2-144x144.png 144w, https://blog.dsinf.net/wp-content/uploads/2017/09/2.png 443w" sizes="(max-width: 300px) 100vw, 300px" />][19][<img decoding="async" loading="lazy" class="alignnone wp-image-1079 size-medium" src="http://blog.dsinf.net/wp-content/uploads/2017/09/1-300x156.png" alt="" width="300" height="156" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/1-300x156.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/1-768x400.png 768w, https://blog.dsinf.net/wp-content/uploads/2017/09/1-1024x534.png 1024w, https://blog.dsinf.net/wp-content/uploads/2017/09/1-660x344.png 660w, https://blog.dsinf.net/wp-content/uploads/2017/09/1.png 1063w" sizes="(max-width: 300px) 100vw, 300px" />][20]

## Edytor plików

Mój wybór zasadniczo nie zmienił się względem [tego sprzed trzech lat][21] (poza faktem że kupiłem licencję; info praktyczne - licencji można używać na dowolnej liczbie urządzeń, w tym w pracy) - dalej [Sublime Text][22] mimo głosów że edytor się skończył to [pluginów przybywa][23], a aktualizacje też się pojawiają.  Co do pluginów to nie używam wielu (większość pomocna jest przy HTMLu): A File Icon, Color Highlighter, ColorPick, Emmet, Git, MarkdownLivePreview, Perforce (głównie w pracy), SideBarEnhancements, SublimeLinter, SublimeREPL oraz motywu Material-Theme-Darker.tmTheme. Rozszerzanie możliwości jest także wygodne - napisałem już kilka podświetlaczy składni dla dziwnych formatów logów i konfiguracji.

<figure id="attachment_1081" aria-describedby="caption-attachment-1081" style="width: 665px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class="wp-image-1081 size-large" src="http://blog.dsinf.net/wp-content/uploads/2017/09/11-1024x789.png" alt="" width="665" height="512" srcset="https://blog.dsinf.net/wp-content/uploads/2017/09/11-1024x789.png 1024w, https://blog.dsinf.net/wp-content/uploads/2017/09/11-300x231.png 300w, https://blog.dsinf.net/wp-content/uploads/2017/09/11-768x592.png 768w, https://blog.dsinf.net/wp-content/uploads/2017/09/11-660x509.png 660w, https://blog.dsinf.net/wp-content/uploads/2017/09/11.png 1168w" sizes="(max-width: 665px) 100vw, 665px" />][24]<figcaption id="caption-attachment-1081" class="wp-caption-text">SublimeText w całej okazałości wraz z menu Ctrl+Shift+P</figcaption></figure>

## Łączność

O użyciu ZeroTiera [pisałem jakiś czas temu][25] - generalnie jest to Software Defined Network. Dzięki temu można dostać się do takowej wirtualki z zewnątrz, a nawet zwiększyć bezpieczeństwo całej floty serwerów dopuszczając logowanie tylko z sieci zerotier (warto jednak zabezpieczyć sobie dostęp KVM do VPSów czy serwerów kolokowanych na wypadek awarii). O estetycznej adresacji nie wspominając. Kiedy dołożymy współdzielone foldery do maszyny wirtualnej można zdalnie dostać się do stacji roboczej i korzystać z jej zasobów - przez SSH.

## Podsumowanie na Windowsie

Dla pełnej wygody z używania Linuksa pod Windowsem w mojej opinii trzeba jednak maszyny wirtualnej z prawdziwym Linuksem i zestawu narzędzi do podłączenia się do niej - jest on też niezbędny żeby pracować na innych serwerach. W skład zestawu wchodzi odpowiednik sshfs, wygodny terminal i edytor tekstu.

## A co z macOS?

Nie jest to mój główny system, używam go tylko na kanapie, w terenie i serwerowni. No i przez to że jest systemem unixowym (zgodny z POSIX? to cicho!) i ma basha to da się działać prawie jak na Linuksie. Osobiście kiedy mogę to używam natywnych rozwiązań (gcc, kompilator go, python, perl, ruby i reszta działają przecież dobrze i nie ma gimnastyki z dziwnymi ścieżkami jak na Windowsie) które można instalować przez [brew][26]. Jakiś czas temu miałem maszynę wirtualną z Linuksem do budowania paczek, ale macbook air nie ma kolosalnej mocy więc przerzuciłem się na budowanie na zdalnym serwerze na którym i tak cały projekt działał.

Jeśli chodzi o terminal to cóż - jak używam SSH to wbudowana aplikacja jest wystarczająca (głównie dlatego że prawie zawsze używam jej na 13- ekranie - cudów nie wymagam, a prawdziwe SSH to prawdziwe SSH). Oczywiście kwestia edytora i ZeroTiera pozostaje bez zmian.

 [1]: https://desktop.github.com/
 [2]: http://blog.dsinf.net/wp-content/uploads/2017/09/7.png
 [3]: https://msdn.microsoft.com/en-us/commandline/wsl/about
 [4]: http://blog.dsinf.net/wp-content/uploads/2017/09/8.png
 [5]: https://hyper.is/
 [6]: https://electron.atom.io/
 [7]: https://atom.io/
 [8]: http://mobaxterm.mobatek.net/
 [9]: http://blog.dsinf.net/wp-content/uploads/2017/09/9.png
 [10]: http://blog.dsinf.net/wp-content/uploads/2017/09/10.png
 [11]: https://wiki.x2go.org/doku.php
 [12]: http://blog.dsinf.net/wp-content/uploads/2017/09/12.png
 [13]: https://github.com/dokan-dev/dokan-sshfs
 [14]: http://www.sftpnetdrive.com/
 [15]: http://blog.dsinf.net/wp-content/uploads/2017/09/3.png
 [16]: http://blog.dsinf.net/wp-content/uploads/2017/09/4.png
 [17]: http://blog.dsinf.net/wp-content/uploads/2017/09/5.png
 [18]: http://blog.dsinf.net/wp-content/uploads/2017/09/6.png
 [19]: http://blog.dsinf.net/wp-content/uploads/2017/09/2.png
 [20]: http://blog.dsinf.net/wp-content/uploads/2017/09/1.png
 [21]: https://blog.dsinf.net/2014/01/edytor-uniwersalny/
 [22]: https://www.sublimetext.com/3
 [23]: https://packagecontrol.io/
 [24]: http://blog.dsinf.net/wp-content/uploads/2017/09/11.png
 [25]: https://blog.dsinf.net/2017/02/zerotier-czyli-software-defined-network-czyli-alternatywa-dla-klasycznego-vpna/
 [26]: https://brew.sh/index_pl.html