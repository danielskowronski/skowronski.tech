---
title: Prosty choć nie zawsze trywialny w obsłudze system backupowania – urbackup
author: Daniel Skowroński
type: post
date: 2017-07-23T07:02:48+00:00
excerpt: 'Ludzie dzielą się na tych co robią backupy i na tych co je będą robili. A sposób ich wykonywania jest dość ważny. No i warto żeby móc odzyskać dane i mieć coś więcej niż backup z ostatnim błędem. Tym razem pochylę się nad rozwiązaniem urbackup - miłym i przyjemnym serwerem backupów, który jednak nie zawsze jest trywialny w obsłudze.'
url: /2017/07/prosty-choc-nie-zawsze-trywialny-w-obsludze-system-backupowania-urbackup/
featured_image: https://blog.dsinf.net/wp-content/uploads/2017/07/urb.png
tags:
  - backup
  - linux
  - windows

---
Ludzie dzielą się na tych co robią backupy i na tych co je będą robili. A sposób ich wykonywania jest dość ważny. No i warto żeby móc odzyskać dane i mieć coś więcej niż backup z ostatnim błędem. Tym razem pochylę się nad rozwiązaniem **urbackup** - miłym i przyjemnym serwerem backupów, który jednak nie zawsze jest trywialny w obsłudze.

Przez długi czas mój webserverek i kilka maszyn w KSI robiło backup mniej więcej następująco:

<pre class="lang:default EnlighterJSRAW" title="crontab -l">0    3    *    *   Mon  /root/bin/snapshot-vps</pre>

<pre class="lang:default EnlighterJSRAW" title="/root/bin/backup">#!/bin/bash
/root/bin/storsrv attach && tar cz /bin /lib /sbin /var /boot /etc /lib64 /opt /root /selinux /tmp /home /srv /usr | gpg --encrypt --output /data/snapsot_`date +"%s"`.tgz.gpg --recipient XXXX
/root/bin/storsrv detach</pre>

<pre class="lang:default EnlighterJSRAW" title="/root/bin/storsrv">#!/bin/bash

if [[ "$1" == "attach" ]]; then
	umount /data
	sshfs -p XXXX stor_vps@XXXXX.dsinf.net: /data
elif [[ "$1" == "detach" ]]; then
	umount /data
else
	echo "STORSRV v0.1; sytax:\n"
	echo "  $0 &lt;command&gt;"
	echo "  &lt;commad&gt;={attach, detach}"
fi
</pre>

Niezbyt finezyjnie, choć z użyciem GPG więc bezpiecznie. Cały sytem z użyciem prostszej wersji skryptu padł pewnego razu kiedy po modyfikacjach na jednym serwerze po braku możliwości podpięcia się po sshfs backup zaczynał się wykonywać na dysk (pół biedy) ale... rekursywnie. Pewne rozszerzenie dokładało wysyłkę maila ale jednak trzeba przyznać - mizerny sposób. Zwłaszcza jeśli spojrzeć na sposób w jaki sshfs traktuje zepsute endpointy...

&nbsp;

Ale można lepiej. Urbackup (https://www.urbackup.org/) jest właśnie tą lepszą opcją dla rozwiązań domowo-hobbystycznych. Cudów nie ma ale można w łatwy sposób zabezpieczyć swoje dane na domowym NASie lub na dedyku pod storage (tu polecam aukcje Hetnzera). Architektura jest następująca: _serwer centralny_ który ma paczki na większość dystrybucji Linuksa i Windowsa oraz _klienci_ - paczki na Windowsa, macOS, magiczną binarkę na Linuksa. Jest też obraz ISO do odzyskiwania offline.

Serwer posiada webgui na defaultowym porcie 55414 (bezproblemowo stawia się za zwykłym proxy) z którego wyklikamy dodanie nowego klienta zdalnego (za NATem) lub zaakceptujemy lokalnego, przejrzymy logi i wykresy oraz zmodyfikujemy konfigurację. Jest jeszcze komenda <span class="lang:default EnlighterJSRAW crayon-inline ">urbackupsrv</span> która służy do cięższych zadań administracyjnych jak usuwanie starych plików kopii. Warto od razu zaznaczyć że jeśli jakiś backup oznaczymy jako "archived" to nigdy nie zostanie usunięty automatycznie. Ważny z punktu widzenia firewalla jest jeszcze jeden port - 55415 służący do komunikacji klienta z serwerem. Klienci zdalni wymagają hasła ale tu ujawnia się praktyczna funkcja urbackup - po wyklikaniu zdalnego klienta dostajemy command-line do wklejenia w terminal z gotowymi opcjami.

Przechodząc do klienta - generalnie na windowsa i macOS są typowe binarki. Na Linuksa zalecane jest typowe w dzisiejszych czasach podejście <span class="lang:default EnlighterJSRAW crayon-inline">curl | sudo bash</span>. Choć tutaj z użyciem <span class="lang:default EnlighterJSRAW crayon-inline ">mktemp</span> . Klient składa się z usługi <span class="lang:default EnlighterJSRAW crayon-inline ">urbackupclientbackend</span> <span class="s1"> oraz programu kontrolującego - <span class="lang:default EnlighterJSRAW crayon-inline">urbackupclientctl</span> </span><span class="s1"> za pomocą którego można zarządzać folderami do backupowania, wystartować backup, zarządać przywrócenia plików i najważniejsze na początek - sprawdzić status. Na Windowsie oczywiście jest ponadto GUI które poza ikonką w trayu niewiele wnosi.</span>

<pre class="lang:default highlight:0 EnlighterJSRAW" title="urbackupclientctl --help">USAGE:

        urbackupclientctl [--help] [--version] &lt;command&gt; [&lt;args&gt;]

Get specific command help with urbackupclientctl &lt;command&gt; --help

        urbackupclientctl start
                Start an incremental/full image/file backup

        urbackupclientctl status
                Get current backup status

        urbackupclientctl browse
                Browse backups and files/folders in backups

        urbackupclientctl restore-start
                Restore files/folders from backup

        urbackupclientctl set-settings
                Set backup settings

        urbackupclientctl reset-keep
                Reset keeping files during incremental backups

        urbackupclientctl add-backupdir
                Add new directory to backup set

        urbackupclientctl list-backupdirs
                List directories that are being backed up

        urbackupclientctl remove-backupdir
                Remove directory from backup set

</pre>

&nbsp;

Jak wygląda konfiguracja serwera? Zaczynamy od instalacji paczki i zalogowania się do gui chociażby żeby zmienić hasło. I tu pierwsza pułapka. Jeśli w systemie jest tylko jeden użytkownik to formularz będzie zawierał tylko pole na hasło - username zostanie odesłany JSONem (sic!) i wstawiony w pole typu _hidden_. Powoduje to masakryczne problemy m.in. z LastPassem. Warto dodać drugiego użytkownika chociażby dla spokoju. Jeśli pracujemy w LANie to w defaultwej konfiguracji klienci sami się podłączą - linki do binariów są w webgui. Dodanie maszyny poza LANem jest proste i jak wspominałem komendy podane są na tacy. Teraz wystarczy dodać foldery do backupowania i gotowe. W opcjach można ustawić reguły harmonogramu globalne i per-maszyna, zainicjować można backup z serwera lub klienta.

I teraz rzecz nad którą spędziłem sporo czasu - "image backup". Otóż jest dostępny **tylko na Windowsie (NTFS)** (i w sumie tylko tam potrzebny realnie bo inaczej nie da się backupować otwartych plików systemowych) przez Volume Shadow Copy. Na pierwszy rzut oka wydawać się powinno że skoro producent podaje dostępne mechanizmy migawek na LVM, BtrFS i DattoBD to powinny one właśnie służyć do backupowania całych urządzeń blokowych. Otóż nie. Służą tylko jako engine do wydajniejszego migawkowania plików. Testowane z datto i lvm przy ręcznym konfigurowaniu klienta. Serwer zwraca błędy które po zgooglaniu wskazują kod źródłowy i jeden wątek na forum z którego niewiele wynika. I tak - jest to wspomniane na stronie z listą ficzerów w dziale "ograniczenia" <https://www.urbackup.org/features.html>, ale googlalność jest zerowa.

W każdym razie pod Linuksem można bezpiecznie dodać cały root folder "/" do backupowania bowiem urbackup nie podąża za innymi filesystemami - w przeciwieństwie do takiego tara czy 7zipa które wówczas zaczęły by backupować pliki, dyski, procfs... Oczywiście skromniejsze zestawy folderów są również praktyczne. Drobna uwaga - próba czarowania z symlinkami i backupowania np. <span class="lang:default EnlighterJSRAW crayon-inline ">sda</span>  kończą się niepowodzeniem.

&nbsp;

Po dodaniu klienta zdalnego czasem trzeba chwilę odczekać (szczególnie trudny miałem przypadek kiedy dodawałem klienta który miał w LANie jeden serwer a chciałem dodać go tylko do serwera zdalnego). <span class="lang:default EnlighterJSRAW crayon-inline ">urbackupclientctl status</span>  pozawala monitorować stan na bieżąco. Co ciekawe wyrzuca output w JSONie:

<pre class="lang:js EnlighterJSRAW">{
"capability_bits": 4096,
"finished_processes": [{
"process_id": 15,
"success": true
}
...
,{
"process_id": 34,
"success": true
}
],
"internet_connected": true,
"internet_status": "connected",
"last_backup_time": 1500456220,
"running_processes": [{
"action": "FULL",
"done_bytes": 8277567051,
"eta_ms": 977068,
"percent_done": 53,
"process_id": 35,
"server_status_id": 113,
"speed_bpms": 32.1905,
"total_bytes": 15708923925
}
],
"servers": [{
"internet_connection": true,
"name": "10.64.73.6"
}
],
"time_since_last_lan_connection": 7116205514
}
</pre>

&nbsp;

Klient linuksowy ma kilka niestandardowych założeń. Po pierwsze lokalizacja plików - są one trochę po BSDowemu w <span class="lang:default EnlighterJSRAW crayon-inline ">/usr/local/{share,var,etc,sbin}/urbackup</span> . Główny konfig to <span class="lang:default EnlighterJSRAW crayon-inline ">/usr/local/var/urbackup/data/settings.cfg</span> , to co jest w etc określa sposób backupowania m.in. mariadb. Do manipulacji konfigiem najlepszy jest <span class="lang:default EnlighterJSRAW crayon-inline">urbackupclientctl set-settings</span> gdyż zapewnia integralność plików.

Po stronie serwera warto zauważyć że w zakładce logs poza logami konkretnych sesji backupowania na dole można obejrzeć "live log" dla "all clients" który jest logiem w trybie debug całego serwera - otwiera się w nowej karcie i na bieżąco asynchronicznie ładuje kolejne linijki loga - nie trzeba zmieniać trybu logowania do /var/log i restartować usługi żeby podejrzeć co się dzieje.

<p class="p2">
  Dwa sprawdzone przeze mnie scenariusze użycia - lokalny storage server i "cloud storage" na dedyku działają i mają się dobrze. Pierwszy przypadek to postawiony w LANie <strong>OpenMediaVault</strong>, czyli dystrybucja Debiana z GUI do storage'u (warte polecenia ze względu na metodykę "wyklikaj i zostaw") wraz z zainstalowanym rozszerzeniem do urbackup który zrzuca migawki po zbondowanym 2x gigabit ethernet na macierz raid5. Klienci to mix Windowsów Server i Linuksa. I działa.
</p>

![](https://blog.dsinf.net/wp-content/uploads/2017/07/Screenshot-at-13-38-07.png) 

Drugi to zainstalowany z paczki na openSUSE na zdalnym serwerze dedykowanym z łączem gigabitowym backupujący inne serwery (w innych DC) oraz stację roboczą za domowym łączem UPC z uplinkiem 10mbps. Nawet działa. Maszyny spięte są za pomocą SDNa ZeroTier o którym pisałem wcześniej - <https://blog.dsinf.net/2017/02/zerotier-czyli-software-defined-network-czyli-alternatywa-dla-klasycznego-vpna/> - znowu spadku wydajności nie ma.

![](https://blog.dsinf.net/wp-content/uploads/2017/07/Screenshot-at-13-49-07.png) 

Co do interfejsu screenów jeszcze kilka:

![](https://blog.dsinf.net/wp-content/uploads/2017/07/Screenshot-at-13-44-53.png) 

![](https://blog.dsinf.net/wp-content/uploads/2017/07/Screenshot-at-13-45-28.png)![](https://blog.dsinf.net/wp-content/uploads/2017/07/Screenshot-at-13-42-33.png) 

Reasumując: urbackup pomimo pewnych nietrywialności dobrze nadaje się jako pierwszy krok po odejściu od backupowania 7zipem po sshfs.