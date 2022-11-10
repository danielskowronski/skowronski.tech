---
title: Manipulacja na systemie plików rootfs na żywo
author: Daniel Skowroński
type: post
date: 2017-09-26T12:52:55+00:00
excerpt: 'Kiedy trzeba pomanipulować rootfs-em (na przykład trochę go pomniejszyć) to oczywiście najbezpieczniej i najprościej jest zabootować się do livecd i wykonać to wszystko poza systemem. Jednak nie zawsze jest to możliwe - głównym takim środowiskiem są VPSy wszelkiej maści nie pozwalające zabootować się do środowiska rescue. Jednak nic straconego - da się!'
url: /2017/09/manipulacja-na-systemie-plikow-rootfs-na-zywo/
tags:
  - linux

---
Kiedy trzeba pomanipulować rootfs-em (na przykład trochę go pomniejszyć) to oczywiście najbezpieczniej i najprościej jest zabootować się do livecd i wykonać to wszystko poza systemem. Jednak nie zawsze jest to możliwe &#8211; głównym takim środowiskiem są VPSy wszelkiej maści nie pozwalające zabootować się do środowiska rescue. Jednak nic straconego &#8211; da się!

Warto jednak zacząć od prostszych metod czyli poszperania w panelu klienta dostawcy usług &#8211; w przypadku wirualizacji na poziomie jądra linuksa często dostępny będzie &#8222;tryb rescue&#8221; wystawiający ssh ale z minimalnym systemem który nie zamontował naszego rootfs. W przypadku dedyków jest duża szansa że możemy wręcz zadysponować rozruch maszyny z takiego nośnika. Zanim przejdziemy do psucia systemu który działa trzeba też spojrzeć czy nie da się customizować templatki systemu przy zamawianiu usługi &#8211; zwykle problem złego layoutu ukazuje się od razu (np. potrzeba dodania DRBD kiedy cały dysk jest popartycjonowany).

Ext4 sprawia zwykle problemy bo nie da się go w locie pomniejszać &#8211; trzeba go najpierw odmontować. Ale jak wiadomo dostaniemy taki przyjemny komunikat:

<pre class="lang:sh EnlighterJSRAW">vps&gt; umount /
umount: /: target is busy
        (In some cases useful info about processes that
         use the device is found by lsof(8) or fuser(1).)
vps&gt;</pre>

Rozwiązanie polega na wykorzystaniu narzędzia które zwykle pracuje tylko w initiowym ramdysku &#8211; **pivot_root**. W środowiskach z ograniczoną pamięcią w tmpfs (mało RAMu) skopiowanie minimalnego rootfsa z żywego systemu będzie kłopotliwe, ale zawsze można sobie taki minimalny system zbootstrapować. Przykładowo dla ubuntu:

<pre class="lang:sh EnlighterJSRAW">vps&gt; apt install debootstrap
vps&gt; mkdir /tmp/tmproot/
vps&gt; mount -t tmpfs none /tmp/tmproot
vps&gt; debootstrap --arch i386 xenial /tmp/tmproot/ 'http://archive.ubuntu.com/ubuntu'
vps&gt; chroot /tmp/tmproot/
chrooted&gt; apt install lvm2 lsof ssh psmisc 
chrooted&gt; useradd # for ubuntu
chrooted&gt; passwd
chrooted&gt; exit
vps&gt; mkdir /tmp/tmproot/{proc,sys,dev,run,usr,var,tmp,oldroot}</pre>

Ważna uwaga &#8211; dla ubuntu trzeba dodać osobne konto (bo zbootstrapowany system nie ma ani naszych kluczy ssh ani nie pozwoli na sshowanie się jako root) i ustawić jakieś hasło roota żeby użyć potem su. Będąc w chroocie trzeba przetestować czy wszystko działa (narzędzia do raida, LVMa, LUKSa itp.) i ew. doinstalować.

Żeby przełączyć się do nowego systemu należy wykonać:

<pre class="lang:default EnlighterJSRAW">vps&gt; mount --make-rprivate / 
vps&gt;  pivot_root /tmp/tmproot /tmp/tmproot/oldroot
pivoted&gt; for i in dev proc sys run; do mount --move /oldroot/$i /$i; done</pre>

Główna zabawa czyli odmontowanie rootfsa &#8211; teraz na /oldroot:

<pre class="lang:default EnlighterJSRAW ">pivoted&gt; systemctl daemon-reexec # init startuje już z nowego rootfs
pivoted&gt; systemctl restart sshd
### spradź SSH z innego terminala; tak - klucze hosta się zmienią i ssh będzie narzekać ###
pivoted&gt; lsof /oldroot/ | awk '{print $2}' | sort | uniq | xargs
pivoted&gt; kill -9 &lt;PIDy z powyższego&gt;
pivoted&gt; fuser /oldroot/ # nie powinno zwrócić nic

pivoted&gt; systemctl status # ewentualnie trzeba ubijać po kolei usługi
pivoted&gt; systemctl disable systemd-journald systemd-udevd rsyslog.service systemd-timesyncd udev
pivoted&gt; systemctl stop systemd-journald systemd-udevd rsyslog.service systemd-timesyncd udev

### dla LVM ###
pivoted&gt; systemctl disable lvm2-lvmetad.service
pivoted&gt; systemctl stop lvm2-lvmetad.service

pivoted&gt; umount /oldroot/
### jeśli zwraca:
### lsof: WARNING: can't stat() fuse.lxcfs file system /oldroot/var/lib/lxcfs
pivoted&gt; umount /oldroot/var/lib/lxcfs
pivoted&gt; umount /oldroot/

### dla błędu:
### xt2fs_check_mount_point: Can't check if filesystem is mounted due to missing mtab file while determining whether /dev/vg/lv_root is mounted.
pivoted&gt; touch /etc/mtab</pre>

Teraz można już dokonać manipulacji, na przykład:

<pre class="lang:default EnlighterJSRAW">pivoted&gt; lvresize -L8G -r /dev/vg/lv_root
pivoted&gt; vgreduce --removemissing vg
pivoted&gt; sync
pivoted&gt; reboot</pre>

Lub żeby zrevertować pivot_roota:

<pre class="lang:default EnlighterJSRAW">pivoted&gt; mount --make-rshared /
vps&gt; systemctl enable &lt;disabled&gt;
vps&gt; systemctl isolate default.target</pre>

&nbsp;

Bazowane na https://unix.stackexchange.com/questions/226872/how-to-shrink-root-filesystem-without-booting-a-livecd/227318#227318 i przetestowane na dwóch maszynach, ale mimo wszystko wymaga trochę doświadczenia!