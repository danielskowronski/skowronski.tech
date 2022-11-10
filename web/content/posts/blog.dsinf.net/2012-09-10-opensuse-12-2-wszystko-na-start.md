---
title: OpenSUSE 12.2 – wszystko na start
author: Daniel Skowroński
type: post
date: 2012-09-10T18:07:54+00:00
excerpt: "Dzień przed przedwczoraj ukazała się zapowiadana wersja 12.2 systemu openSUSE. Po dość długiej historii wersji rozwojowych, anulowaniu jednego z Milestone'ów, problemach z kompilatorem developerzy wypuścili finalny produkt. "
url: /2012/09/opensuse-12-2-wszystko-na-start/
tags:
  - linux
  - suse

---
Dzień przed przedwczoraj ukazała się zapowiadana wersja 12.2 systemu openSUSE. Po dość długiej historii wersji rozwojowych, anulowaniu jednego z Milestone&#8217;ów, problemach z kompilatorem developerzy wypuścili finalny produkt. 

Historia z kompilatorem jest dość ciekawa. W okolicy przełomu M3 i Bety wyszła nowa wersja GCC – 4.7. Wszystkie pakiety oczywiście zostały skompilowane najnowszą wersją. Ale w przypadku niektórych, w tym krytycznego libzypp – backendu zyppera (menedżera pakietów) dla całego systemu w tym niestety YaST&#8217;a, czy innych postanowiono pójść na łatwiznę – po prostu skompilowano je poprzednią wersją GCC. Efekt łatwy do przewidzenia, zważywszy, że to C – segmentation fault przy byle powodzie, a w przypadku YaST&#8217;owego instalatora pakietów zawsze. 

Po ściągnięciu i wypaleniu oraz sprawdzeniu dwa razy sumy kontrolnej przystąpiłem do instalacji. MD5 musiałem sprawdzić, gdyż przy testowaniu wersji M2-B2 nad moimi nośnikami ciążyło fatum i albo źle się pobierało (co do tej pory nigdy mi się nie zdarzało), albo nośnik okazywał się uszkodzony/źle wypalony. Ale OK – w yastowym aktualizatorze nic się nie zmieniło poza kolorkami i pełną obsługą dwóch monitorów w czasie instalacji, co prawda tylko klonowanie, lecz poprawnie zadział nigdy nie działający bez sterowników HDMI (jedna z pierwszych grafik hybrydowych daje się we znaki) i rozdzielczością „master” stała się większa 1920&#215;1080.

Jak zawsze zostawiłem tak długi proces sam sobie i poszedłem na zakupy. 

Po przyjściu z powrotem nie oczekiwałem, że wszystko pójdzie OK. Nie działał w ogóle init piąty. Trochę eksperymentów i <u>wróciłem</u> (na razie z GRUBa) <u>do mojego ulubionego programu inicjującego z System V</u>. Jakoś <u>systemd mnie nie przekonuje</u> – głównie tym, że sporo problemów rozwiązuję wyłączając go. I jakoś nie jestem zainteresowany faktem, że „systemd replaces SysV” (~openSUSE wiki), skoro i tak na każdym forum są porady jak pozbyć się systemd. Ciekawy artykuł znajdziemy w LinuxMagazine (PL, jest także jako Community Edition) nr 2/2012 (96) na stronach 56-60.  
Aby rozruszać kernela z init&#8217;em należy w suse&#8217;owskim grubie wybrać F5, a następnie wybrać opcję z menu, lub (na każdej dystrybucji) dopisać do parametrów jądra:

<pre class="EnlighterJSRAW bash" style="display: inline">init=/bin/systemd</pre>

Permanentnie możemy to uzyskać poprzez deznstalację pakietu 

<pre class="EnlighterJSRAW bash" style="display: inline">systemd-sysvinit</pre>

Kolejną rzeczą była instalacja <u>sterowników nvidii</u>. Generalnie pracuje jak zawsze zasada, że albo sterowniki są w systemie, albo należy użyć one-click instalatorów na wiki systemu, albo wariant hardway jest dla nas. Jeśli mamy laptopa to raczej trzeba będzie przestawić BIOS do maksymalnie kompatybilnych ustawień – w tym tych dot. SATA. Własnościowe sterowniki bardzo dobrze działają również z 12.2, lecz możliwe, że będziemy potrzebować najnowsze wersji. Jeśli nie startuje nam X to posiadając już jakąkolwiek wersję instalki możemy wywołać ją z parametrem -update, która dociągnie odpowiedni plik. Wersja 304 beta powinna działać. Ale nie od razu moduł kernela skopilowano&#8230; Wpierw należy dokonać:

<pre class="EnlighterJSRAW bash">cd /usr/src/linux
make cloneconfig
make prepare
cd /lib/modules/`uname -r`/source/arch/x86/include/
cp -v generated/asm/unistd*.h ./asm/
</pre>

Oczywiście o tym, że pakiet 

<pre class="EnlighterJSRAW bash" style="display: inline">kernel-source</pre>

musi być zainstalowany nie warto nawet pisać 😉  
To już prawie wszystko. Jeśli działa to OK, a jak nie &#8211; wówczas należy dodać do opcji jądra nomodeset. Co mnie bardzo zaskoczyło – czcionka na tty, która do tej pory dopasywała się do rozdzielczości bodaj 800&#215;600, co nijak nie licowało z realną rozdzelczością, czy zdroworozsądkowym wyglądem, a wręcz osmieszała: w tym momencie pracuje normalnie – ciężko powiedzieć, czy to zasługa sterowników, czy poprawienia się dystrybucji, ale ważne, że pracuje „normalnie”, czyli 1366&#215;768. 

<u>Vmware</u>. Dziewiąta wersja działa bez pytań o nic, podczas gdy ósma przy rekompilacji (instalacja dla 12.1 i świeżo zaktualizowanym 12.2) utknęła. Jest to ogólnie zaskakujące, gdyż VMware z suse jakoś nie współpracował za dobrze. Plus dla nich.

<u>Hibernacja przebiega dużo sprawniej</u> niż w poprzedniku, zresztą jak samo uruchamianie. Sam system nawet po dwóch dniach pracy zdaje się być <u>stabilniejszy</u> (po wyczerpującym teście jakim jest nie zgłoszenie kernel panic przez komputer na moim biurku).

Z softu zaktualizowano LibreOffice do 3.5, GIMPa do 2.8, Firefoxa do generalnie najnowszej wersji (12), KDE 4.8, Gnome 3.4, XFCE 4.10. Kernel to 3.4 a więc sporo funkcji, w tym poprawiony log systemowy. Xorg 1.12 wprowadza natywny multitouch co ucieszy użytkowników netbooków z ekranami dotykowymi i dość specjalistycznych tabletów. Testerów dziwnych rzeczy zainteresuje ekstremalnie poprawiona obsługa Btrfs &#8211; systemu plików, który zrewolucjonizuje przechowywanie poprzez ideę „kopiuj przy zapisie”, system migawek, sum kontrolnych, kompresji w locie nie obciążającej CPU, czy dynamiczne i-węzły. Ale to przyszłość, gdyż wymaga on jeszcze trochę pracy.

Podsumowywując: zawsze miałem masę argumentów za migracją z ubuntu do openSUSE lub w ogóle zaczęciem przygody z system spod znaku Pingwina od „kameleona”. Dziś 12.2 do nich dołączył poprzez **<u>stabilność, szybkość i rozwiązanie małych bolączek systemu i „ale” ubunciarzy</srong></u>.</p>