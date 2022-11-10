---
title: MegaRAID w stacji roboczej i poszukiwanie SMARTa
author: Daniel Skowroński
type: post
date: 2019-01-09T18:58:58+00:00
excerpt: 'Kolejny artykuł o zabawie z moją stacją roboczą (Dell T5500) - tym razem w roli głównej kontroler RAID firmy LSI - MegaRAID SAS6IR. A konkretniej podejrzenie awarii jednego z dysków w macierzy.'
url: /2019/01/megaraid-w-stacji-roboczej-i-poszukiwanie-smarta/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a.png
tags:
  - hardware
  - raid
  - storage

---
Kolejny artykuł o zabawie z moją stacją roboczą (Dell T5500) &#8211; tym razem w roli głównej kontroler RAID firmy LSI &#8211; MegaRAID SAS6IR (Windowsy driver widzi to jako _Karta&nbsp;LSI,&nbsp;seria&nbsp;SAS&nbsp;3000,&nbsp;8&nbsp;portów&nbsp;z&nbsp;1068E_). A konkretniej podejrzenie awarii jednego z dysków w macierzy.

Ale po kolei. Mój setup wykorzystujący sprzętowy RAID to proste mirrorowanie dwóch dysków SAS od Seagate&#8217;a (były w zestawie z komputerem i o dziwo jeszcze żyją) o przyjemnej prędkości obrotowej 15.7k RPM. Dla windowsa jest prezentowany wirtualny dysk i tyle. Nie pamiętam dokładnie setupu ale widziałem maszynę Della na której WinServer widział składniki macierzy i dyski logiczne &#8211; tu nie ma to miejsca. Podczas któregoś polowania na sterowniki doinstalowałem sobie _MegaRAID Storage Manager_a czyli konsolę administracyjną karty PCI która zarządza dyskami &#8211; dość wygodna żeby nie rebootować maszyny do BIOSu kontrolera. 

<ul class="is-layout-flex wp-block-gallery-1 wp-block-gallery columns-2 is-cropped">
  <li class="blocks-gallery-item">
    <figure><a href="http://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a-1024x620.png"><img decoding="async" loading="lazy" width="1024" height="620" src="http://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a-1024x620.png" alt="" data-id="1316" data-link="http://blog.dsinf.net/2019/01/megaraid-w-stacji-roboczej-i-poszukiwanie-smarta/megaraid0a/" class="wp-image-1316" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a-1024x620.png 1024w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a-300x182.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a-768x465.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0a.png 1200w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="http://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0-1024x768.png"><img decoding="async" loading="lazy" width="1024" height="768" src="http://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0-1024x768.png" alt="" data-id="1313" data-link="http://blog.dsinf.net/2019/01/megaraid-w-stacji-roboczej-i-poszukiwanie-smarta/megaraid0/" class="wp-image-1313" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0-1024x768.png 1024w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0-300x225.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0-768x576.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid0.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
</ul>

Aż pewnego pięknego dnia zaczął wyskakiwać komunikat o wypadnięciu dysku z macierzy. W logach pojawiał się z datą &#8222;2000-01-01 12:00:00&#8221;. Co ciekawe eventy o pomyślnym logowaniu do konsoli mają poprawną datę. W każdym razie okazało się że leci rebuild. Po czym drugi raz. I trzeci.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="950" height="858" src="https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid1.png" alt="" class="wp-image-1314" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid1.png 950w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid1-300x271.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/megaraid1-768x694.png 768w" sizes="(max-width: 950px) 100vw, 950px" /> </figure> 

Wtedy postanowiłem zbadać stan SMARTa dysków (niektórzy mogą się domyślić że nie ma to sensu, ale o tym potem). Czas pobrać pakiet _smarrtmontools_. Bash na Windowsa był pierwszym strzałem. Pudło bo to kontener który nie ma bindowań do devfs (w sumie nie ma za bardzo jak mieć). Kolejna próba to build smartctl na Windowsa. Nawet [wiki projektu][1] potwierdza że się powinno dać &#8211; przez CSMI. Znowu pudło bo support megaraida wyparował z wersji windowsowej. Próby enumerowania ukrytych urządzeń przez cygwina też upadły (_smartctl &#8211;scan_). 

Czas zatem na najlepszego przyjaciela użytkownika Gentoo i nie tylko &#8211; _SystemRescueCD_. I tu kolejna porażka &#8211; driver megaraida w smartctl wymaga podania ID kontrolera (ale nie SCSI tylko samego megaraida). [Wiki Thomas-Krenn][2]a daje sporo informacji ale nie mogę się natknąć na szukane ID (bruteforcowy for-loop sugeruje że może jednak go tam nie ma&#8230;) Jedyne co mam to zlistowane LUNy fizycznych urządzeń od _lsscsi_:

<pre class="lang:default EnlighterJSRAW  ">[1:0:0:0]    disk    ATA      INTEL SSDSA2BW16 0365  /dev/sda 
[3:0:0:0]    disk    ATA      WDC WD1002FBYS-0 NA01  /dev/sdb 
[4:0:0:0]    disk    ATA      KINGSTON SA400S3 71E0  /dev/sdc 
[6:0:0:0]    disk    Generic  STORAGE DEVICE   1532  /dev/sdd 
[7:0:0:0]    disk    Samsung  Flash Drive      1100  /dev/sde 
[8:0:0:0]    disk    DYMO     PnP              1.00  /dev/sdf 
[9:0:0:0]    disk    SEAGATE  ST3300657SS      ES02  -        
[9:0:1:0]    disk    SEAGATE  ST3300657SS      ES02  -        
[9:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sdg 
</pre>

Wtedy dotarło do mnie że może brakuje mi jakiegoś modułu jądra. Znalazłem też wzmiankę o narzędziu _megacli_. Które teraz nazywa się _[StorCLI][3]_. Tym sposobem na gentoo odpaliłem [stronę z Wiki Debiana][4]. Po potwierdzeniu przez lspci okazało się że szukam _mptsas_. Kilka modprobów później mpt-status ożył.

<pre class="lang:default EnlighterJSRAW  ">root@sysresccd % lspci | grep SAS
23:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
root@sysresccd % modprobe mptsas
root@sysresccd % storcli show | grep Number
Number of Controllers = 0
root@sysresccd % storcli show | grep Number
root@sysresccd % lsiutil
zsh: command not found: lsiutil
root@sysresccd % mpt-status
open /dev/mptctl: No such file or directory
  Try: mknod /dev/mptctl c 10 220
Make sure mptctl is loaded into the kernel
root@sysresccd % mknod /dev/mptctl c 10 220
root@sysresccd % mpt-status                 
open /dev/mptctl: No such device
  Are you sure your controller is supported by mptlinux?
Make sure mptctl is loaded into the kernel
root@sysresccd % ls /dev/mptctl 
/dev/mptctl
root@sysresccd % mpt-status    
open /dev/mptctl: No such device
  Are you sure your controller is supported by mptlinux?
Make sure mptctl is loaded into the kernel
root@sysresccd % mknod /dev/mptctl c 10 220
mknod: /dev/mptctl: File exists
root@sysresccd % modprobe mptctl
root@sysresccd % mpt-status                
ioc0 vol_id 0 type IM, 2 phy, 278 GB, state DEGRADED, flags ENABLED RESYNC_IN_PROGRESS
ioc0 phy 0 scsi_id 8 SEAGATE  ST3300657SS      ES02, 279 GB, state ONLINE, flags NONE
ioc0 phy 1 scsi_id 1 SEAGATE  ST3300657SS      ES02, 279 GB, state ONLINE, flags OUT_OF_SYNC
root@sysresccd % </pre>



Czas na narzędzie do zarządzania &#8211; _lsiutil_. Ciężkie do znalezienia ale są [dobrzy ludzie którzy mirrorują][5] na blogach. Okazuje się że to narzędzie to koszmarek podobny do fdiska z milionem menu, ale chociaż działa.

Szczęśliwy człowiek wraca do smartctla a tam&#8230; przypomina sobie że dyski SAS nie mają SMARTa z dysków [S]ATA. <facepalm />

<pre class="lang:default EnlighterJSRAW ">LSI Logic MPT Configuration Utility, Version 1.57, April 28, 2008

1 MPT Port found

     Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev  IOC
 1.  /proc/mpt/ioc0    LSI Logic SAS1068E B3     105      00192f00     0

Diagnostics menu, select an option:  [1-99 or e/p/w or 0 to quit] 12
Adapter Phy 0:  Link Up, No Errors
Adapter Phy 1:  Link Up
  Invalid DWord Count                                   1,413,606
  Running Disparity Error Count                         1,372,067
  Loss of DWord Synch Count                                     2
  Phy Reset Problem Count                                       0

Adapter Phy 2:  Link Down, No Errors
Adapter Phy 3:  Link Down, No Errors
Adapter Phy 4:  Link Down, No Errors
Adapter Phy 5:  Link Down, No Errors
Adapter Phy 6:  Link Down, No Errors
Adapter Phy 7:  Link Down, No Errors

Main menu, select an option:  [1-99 or e/p/w or 0 to quit] l

 1.  Identify firmware, BIOS, and/or FCode
 2.  Download firmware (update the FLASH)
 4.  Download/erase BIOS and/or FCode (update the FLASH)
 8.  Scan for devices
10.  Change IOC settings (interrupt coalescing)
13.  Change SAS IO Unit settings
16.  Display attached devices
20.  Diagnostics
21.  RAID actions
22.  Reset bus
23.  Reset target
42.  Display operating system names for devices
45.  Concatenate SAS firmware and NVDATA files
60.  Show non-default settings
61.  Restore default settings
69.  Show board manufacturing information
97.  Reset SAS link, HARD RESET
98.  Reset SAS link
99.  Reset port
 e   Enable expert mode in menus
 p   Enable paged mode
 w   Enable logging
</pre>



Kilka eksperymentów z diagnostyką dostępną w lsiutilu wykazuje że dysk (bo failował tylko jeden) w zasadzie żyje i nie udało mi się złapać badsectorów. Cóż, przy kolejnej awarii posiedzę w menu diagnostyki dłużej albo przepnę do maszyny z kontrolerem SAS który pracuje w trybie JBOD i wykonam destrukcyjny test powierzchni &#8211; z wynikami które rozumiem 🙂

Na sam koniec jeszcze [mój mirror lsiutil&#8217;a][6] na wszelki wypadek.

 [1]: https://www.smartmontools.org/wiki/Supported_RAID-Controllers
 [2]: https://www.thomas-krenn.com/en/wiki/Smartmontools_with_MegaRAID_Controller
 [3]: https://www.thomas-krenn.com/en/wiki/StorCLI
 [4]: https://wiki.debian.org/LinuxRaidForAdmins#megaraid
 [5]: https://www.dzhang.com/blog/2013/03/22/where-to-get-download-lsiutil
 [6]: http://blog.dsinf.net/wp-content/uploads/2019/01/lsiutil.zip