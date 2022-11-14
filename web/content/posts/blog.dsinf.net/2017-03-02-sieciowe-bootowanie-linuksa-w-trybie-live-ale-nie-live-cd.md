---
title: Sieciowe bootowanie Linuksa w trybie "live" ale nie live-cd
author: Daniel Skowroński
type: post
date: 2017-03-02T20:36:53+00:00
excerpt: 'Po długiej batalii o bezpieczeństwo 3 publicznych stacji roboczych (docodząc do paranoi w stylu totalnie ograniczony windows server) doszedłem do wniosku że najlepiej będzie jednak bootować je po sieci w trybie read-only - wówczas trzeba by się włamać na serwer, co już nieco łatwiej ograniczyć. Wystarczy teoretycznie postawić coś co wystawia storage i tyle. I tu zaczyna się zabawa - w TFTP, iPXE, NFS.'
url: /2017/03/sieciowe-bootowanie-linuksa-w-trybie-live-ale-nie-live-cd/
featured_image: /wp-content/uploads/2017/03/ipxe-660x495.png
tags:
  - arch
  - boot
  - linux
  - nfs
  - overlayfs
  - pxe
  - tftp

---
Po długiej batalii o bezpieczeństwo 3 publicznych stacji roboczych (docierając do paranoi w stylu totalnie ograniczony windows server) doszedłem do wniosku że najlepiej będzie jednak bootować je po sieci w trybie read-only - wówczas trzeba by się włamać na serwer, co już nieco łatwiej ograniczyć. Wystarczy teoretycznie postawić coś co wystawia storage i tyle. I tu zaczyna się zabawa.

Jako serwer plików wybrałem NFS - sprawdzony standard, który dodatkowo działa już na wydziale dość sprawnie. Gdyby jednak szukać szybkiej alternatywy wskazałbym iSCSI. Setup na debianie wymaga dwóch pakietów - `nfs-kernel-server nfs-common`&nbsp; oraz zasadniczo jednej linii w&nbsp;`/etc/exports`&nbsp;:

```
/home/linuks 10.20.0.0/16(ro,no_subtree_check,async)
```


Wówczas każdy z zadanego subnetu może czytać. Czyli bezpiecznie. Instalacja samego Linuksa w folderze jest prosta - np. Archa wystarczy zbootstrapować wedle [instrukcji na ArchWiki][1].

Żeby to teraz zabootować można użyć stacku: iPXE serwowane po najprostszym DHCP, które ma zahardkodowaną ścieżkę do skryptu który ładuje właściwe jądro - dzięki temu można szybko zmieniać parametry jajka i dodać np. menu bez rekompilacji.  
iPXE to opensourcowy firmware bootwania po sieci, który można skompilować jako gołą binarkę żeby zabootować go po sieci - głównie celem zwiększenia możliwości (obsługuje masę protokołów). Instrukcje embedowania skryptu są na [ich stronie][2]. Ogólnie kompilacja działa tylko na linuksie (nie udalo mi się do tego zmusić macOS) i plik musi się nazywać dokładnie&nbsp;_bin/undionly.kpxe_ żeby makefile ogarnął że chcemy obraz do bootowania po sieci. Potem oczywiście można go przemianować 😉

Tu dochodzimy do pośredniego celu bootowania - ja wybrałem serwer http jako prosty do utrzymania. Instalacja dowolna (choć oczywiście czemy by nie [caddy][3]). Przydatną sztuczką może być dynamiczne generowanie skryptu ipxe np. za pomocą PHP na podstawie adresu IP (do wyciągnięcia z nagłówków). A adres IP zarządzany bardziej inteligentnie niż "pierwszy wolny z puli" przez DHCP pozwala już namierzyć konkretny komputer. Na ten moment jednak wystarczył mi zwykły plik tekstowy wyglądający mniej więcej tak (niestety nie udało mi się znaleźć jak zmienić nfsroot na nazwę domenową zamiast IP):

```bash
#!ipxe
dhcp
kernel http://boot.ksi/vmlinuz-linux quiet ip=:::::eth0:dhcp nfsroot=192.168.88.134:/home/linuks
initrd http://boot.ksi/initramfs-linux-fallback.img
boot
```


U mnie webserver wystawia /boot systemu który się bootuje - łatwiej o porządek.

Żeby Arch&nbsp;miał NFS na starcie trzeba dodać hook do initramu. Dla NFS v4 (defaultowy jest zwykle v3) trzeba trochę [pohackować sedem][4]. Potem (dla obu) wystarczy&nbsp;zmienić plik `/etc/mkinitcpio.conf`&nbsp;:

```
MODULES="... nfs" 
BINARIES="... /usr/bin/mount.nfs" 
HOOKS="... net_nfs"
```


Jak teraz przekonać stację roboczą do zabootwania naszego pliku iPXE? Najprościej serwerem dhcp który wystawia ścieżkę TFTP. Ponieważ w mojej konfiguracji występuje NAT to w OpenWRT wystarczyło wyklikać włączenie bootowania i podać ścieżkę. A plik wgrać po SSH (rootfs jest RW). Jednak przy użyciu dnsmasq konfig wymaga jedynie:

```
dhcp-boot=pxelinux.0
```


pxelinux.0 to plik na serwerze TFTP zainstalowanym na przykład&nbsp;[w ten sposób][5].

Teoretycznie to wszystko - dodajemy logowanie sieciowe i koniec. Tylko co wtedy gdy chcemy zrobić konto gościa i pozwolić na lokalnego roota żeby na szybko user mógł sobie zainstalować pakiet (wtedy oczywiście przezorny użytkownik rebootuje przed użyciem)? Rozwiązaniem problemu jest system plików typu&nbsp;_overlay_ (na ten moment są dostępne trzy - aufs stosowany w livecd, unionfs i overlayFS) - pozwala on na połączenie dwóch systemów plików w jeden - np. jeden tylko do odczytu (np. płyta cd) a drugi do zapisu (np. ram-dysk). OverlayFS jest opisany dość dobrze na archwiki -&nbsp;<https://wiki.archlinux.org/index.php/Overlay_filesystem>

Cała sztuka polega na załadowaniu overlaya&nbsp;_zanim_ wystartuje systemd albo inny init. Po wielu _wielu_ próbach (także z AuFS), które udowniły mi że nie da się przemontować overlaya (tj. zmienić upper i lower) a także że można uszkodzić mount (czyli &nbsp;po przemontowaniu /new_root stracić oryginalne ścieżki) znalazłem&nbsp;_gotowca_. W AURze - liveroot -&nbsp;<https://aur.archlinux.org/packages/liveroot/>&nbsp; - wystarczy do mkinicpio.conf dodać hooka "oroot". No i przebudować (`mkinicpio -p linux`). Żeby się to ładowało należy dodać do linii kernela (w iPXE po prostu na końcu linii) - `oroot=raw` tryb raw ładuje zmiany do ramu, a live całość do ramu.

Na koniec kilka słów o administrowaniu tym systemem. Można się wygodnie zchrootować z hosta i wykonywać aktualizacje itp. Przydatny oneliner ładujący bindy:

```bash
cd /home/linuks && mount -t proc /proc proc && mount --rbind /sys sys && mount --rbind /dev dev && mount --rbind /run run && chroot .
```


Żeby ułatwić sobie pracę można dodać doatkowy wpis w konfigu serwera NFS który dla jednego IP pozwoli na pracę z zapisem&nbsp;(zmiana opcji ro na rw) + oczywiście wywalić oroot z linii jądra - można to zrobić albo dynamicznym skryptem albo z palca - iPXE ma linię komend odpalaną Ctrl+B na starcie.

Przy okazji hackowania overlayfs w momencie rozruchu dotarłem do bardzo dobrrej dokumemntacji na ArchWiki na temat [hooków mkinitcpio][6] i procesu tworzenia /new_root

Dla debiana i pochodnych także istnieje gotowe rozwiązanie -&nbsp;https://github.com/chesty/overlayroot

 [1]: https://wiki.archlinux.org/index.php/Install_from_existing_Linux#Method_A:_Using_the_bootstrap_image_.28recommended.29
 [2]: http://ipxe.org/embed
 [3]: https://caddyserver.com/
 [4]: https://wiki.archlinux.org/index.php/Diskless_system#NFS
 [5]: http://askubuntu.com/a/202548
 [6]: https://wiki.archlinux.org/index.php/mkinitcpio#HOOKS