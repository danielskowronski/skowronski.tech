---
title: Manipulacja na systemie plików rootfs na żywo
author: Daniel Skowroński
type: post
date: 2017-09-26T12:52:55+00:00
summary: 'Kiedy trzeba pomanipulować rootfs-em (na przykład trochę go pomniejszyć) to oczywiście najbezpieczniej i najprościej jest zabootować się do livecd i wykonać to wszystko poza systemem. Jednak nie zawsze jest to możliwe - głównym takim środowiskiem są VPSy wszelkiej maści nie pozwalające zabootować się do środowiska rescue. Jednak nic straconego - da się!'
url: /2017/09/manipulacja-na-systemie-plikow-rootfs-na-zywo/
tags:
  - linux

---
Kiedy trzeba pomanipulować rootfs-em (na przykład trochę go pomniejszyć) to oczywiście najbezpieczniej i najprościej jest zabootować się do livecd i wykonać to wszystko poza systemem. Jednak nie zawsze jest to możliwe - głównym takim środowiskiem są VPSy wszelkiej maści nie pozwalające zabootować się do środowiska rescue. Jednak nic straconego - da się!

Warto jednak zacząć od prostszych metod czyli poszperania w panelu klienta dostawcy usług - w przypadku wirualizacji na poziomie jądra linuksa często dostępny będzie "tryb rescue" wystawiający ssh ale z minimalnym systemem który nie zamontował naszego rootfs. W przypadku dedyków jest duża szansa że możemy wręcz zadysponować rozruch maszyny z takiego nośnika. Zanim przejdziemy do psucia systemu który działa trzeba też spojrzeć czy nie da się customizować templatki systemu przy zamawianiu usługi - zwykle problem złego layoutu ukazuje się od razu (np. potrzeba dodania DRBD kiedy cały dysk jest popartycjonowany).

Ext4 sprawia zwykle problemy bo nie da się go w locie pomniejszać - trzeba go najpierw odmontować. Ale jak wiadomo dostaniemy taki przyjemny komunikat:

```bash
vps> umount /
umount: /: target is busy
        (In some cases useful info about processes that
         use the device is found by lsof(8) or fuser(1).)
vps>
```


Rozwiązanie polega na wykorzystaniu narzędzia które zwykle pracuje tylko w initiowym ramdysku - **pivot_root**. W środowiskach z ograniczoną pamięcią w tmpfs (mało RAMu) skopiowanie minimalnego rootfsa z żywego systemu będzie kłopotliwe, ale zawsze można sobie taki minimalny system zbootstrapować. Przykładowo dla ubuntu:

```bash
vps> apt install debootstrap
vps> mkdir /tmp/tmproot/
vps> mount -t tmpfs none /tmp/tmproot
vps> debootstrap --arch i386 xenial /tmp/tmproot/ 'http://archive.ubuntu.com/ubuntu'
vps> chroot /tmp/tmproot/
chrooted> apt install lvm2 lsof ssh psmisc 
chrooted> useradd # for ubuntu
chrooted> passwd
chrooted> exit
vps> mkdir /tmp/tmproot/{proc,sys,dev,run,usr,var,tmp,oldroot}
```


Ważna uwaga - dla ubuntu trzeba dodać osobne konto (bo zbootstrapowany system nie ma ani naszych kluczy ssh ani nie pozwoli na sshowanie się jako root) i ustawić jakieś hasło roota żeby użyć potem su. Będąc w chroocie trzeba przetestować czy wszystko działa (narzędzia do raida, LVMa, LUKSa itp.) i ew. doinstalować.

Żeby przełączyć się do nowego systemu należy wykonać:

```bash
vps> mount --make-rprivate / 
vps>  pivot_root /tmp/tmproot /tmp/tmproot/oldroot
pivoted> for i in dev proc sys run; do mount --move /oldroot/$i /$i; done
```


Główna zabawa czyli odmontowanie rootfsa - teraz na /oldroot:

```bash
pivoted> systemctl daemon-reexec # init startuje już z nowego rootfs
pivoted> systemctl restart sshd
### spradź SSH z innego terminala; tak - klucze hosta się zmienią i ssh będzie narzekać ###
pivoted> lsof /oldroot/ | awk '{print $2}' | sort | uniq | xargs
pivoted> kill -9 <PIDy z powyższego>
pivoted> fuser /oldroot/ # nie powinno zwrócić nic

pivoted> systemctl status # ewentualnie trzeba ubijać po kolei usługi
pivoted> systemctl disable systemd-journald systemd-udevd rsyslog.service systemd-timesyncd udev
pivoted> systemctl stop systemd-journald systemd-udevd rsyslog.service systemd-timesyncd udev

### dla LVM ###
pivoted> systemctl disable lvm2-lvmetad.service
pivoted> systemctl stop lvm2-lvmetad.service

pivoted> umount /oldroot/
### jeśli zwraca:
### lsof: WARNING: can't stat() fuse.lxcfs file system /oldroot/var/lib/lxcfs
pivoted> umount /oldroot/var/lib/lxcfs
pivoted> umount /oldroot/

### dla błędu:
### xt2fs_check_mount_point: Can't check if filesystem is mounted due to missing mtab file while determining whether /dev/vg/lv_root is mounted.
pivoted> touch /etc/mtab
```


Teraz można już dokonać manipulacji, na przykład:

```bash
pivoted> lvresize -L8G -r /dev/vg/lv_root
pivoted> vgreduce --removemissing vg
pivoted> sync
pivoted> reboot
```


Lub żeby zrevertować pivot_roota:

```bash
pivoted> mount --make-rshared /
vps> systemctl enable <disabled>
vps> systemctl isolate default.target
```


&nbsp;

Bazowane na https://unix.stackexchange.com/questions/226872/how-to-shrink-root-filesystem-without-booting-a-livecd/227318#227318 i przetestowane na dwóch maszynach, ale mimo wszystko wymaga trochę doświadczenia!