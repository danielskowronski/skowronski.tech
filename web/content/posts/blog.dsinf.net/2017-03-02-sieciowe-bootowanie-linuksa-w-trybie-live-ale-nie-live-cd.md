---
title: Sieciowe bootowanie Linuksa w trybie „live” ale nie live-cd
author: Daniel Skowroński
type: post
date: 2017-03-02T20:36:53+00:00
excerpt: 'Po długiej batalii o bezpieczeństwo 3 publicznych stacji roboczych (docodząc do paranoi w stylu totalnie ograniczony windows server) doszedłem do wniosku że najlepiej będzie jednak bootować je po sieci w trybie read-only - wówczas trzeba by się włamać na serwer, co już nieco łatwiej ograniczyć. Wystarczy teoretycznie postawić coś co wystawia storage i tyle. I tu zaczyna się zabawa - w TFTP, iPXE, NFS.'
url: /2017/03/sieciowe-bootowanie-linuksa-w-trybie-live-ale-nie-live-cd/
featured_image: https://blog.dsinf.net/wp-content/uploads/2017/03/ipxe-660x495.png
tags:
  - arch
  - boot
  - linux
  - nfs
  - overlayfs
  - pxe
  - tftp

---
Po długiej batalii o bezpieczeństwo 3 publicznych stacji roboczych (docierając do paranoi w stylu totalnie ograniczony windows server) doszedłem do wniosku że najlepiej będzie jednak bootować je po sieci w trybie read-only &#8211; wówczas trzeba by się włamać na serwer, co już nieco łatwiej ograniczyć. Wystarczy teoretycznie postawić coś co wystawia storage i tyle. I tu zaczyna się zabawa.

Jako serwer plików wybrałem NFS &#8211; sprawdzony standard, który dodatkowo działa już na wydziale dość sprawnie. Gdyby jednak szukać szybkiej alternatywy wskazałbym iSCSI. Setup na debianie wymaga dwóch pakietów &#8211; <span class="lang:default EnlighterJSRAW crayon-inline ">nfs-kernel-server nfs-common</span>&nbsp; oraz zasadniczo jednej linii w&nbsp;<span class="lang:default EnlighterJSRAW crayon-inline ">/etc/exports</span>&nbsp;:

<pre class="lang:default EnlighterJSRAW ">/home/linuks 10.20.0.0/16(ro,no_subtree_check,async)</pre>

Wówczas każdy z zadanego subnetu może czytać. Czyli bezpiecznie. Instalacja samego Linuksa w folderze jest prosta &#8211; np. Archa wystarczy zbootstrapować wedle [instrukcji na ArchWiki][1].

Żeby to teraz zabootować można użyć stacku: iPXE serwowane po najprostszym DHCP, które ma zahardkodowaną ścieżkę do skryptu który ładuje właściwe jądro &#8211; dzięki temu można szybko zmieniać parametry jajka i dodać np. menu bez rekompilacji.  
iPXE to opensourcowy firmware bootwania po sieci, który można skompilować jako gołą binarkę żeby zabootować go po sieci &#8211; głównie celem zwiększenia możliwości (obsługuje masę protokołów). Instrukcje embedowania skryptu są na [ich stronie][2]. Ogólnie kompilacja działa tylko na linuksie (nie udalo mi się do tego zmusić macOS) i plik musi się nazywać dokładnie&nbsp;_bin/undionly.kpxe_ żeby makefile ogarnął że chcemy obraz do bootowania po sieci. Potem oczywiście można go przemianować 😉

Tu dochodzimy do pośredniego celu bootowania &#8211; ja wybrałem serwer http jako prosty do utrzymania. Instalacja dowolna (choć oczywiście czemy by nie [caddy][3]). Przydatną sztuczką może być dynamiczne generowanie skryptu ipxe np. za pomocą PHP na podstawie adresu IP (do wyciągnięcia z nagłówków). A adres IP zarządzany bardziej inteligentnie niż &#8222;pierwszy wolny z puli&#8221; przez DHCP pozwala już namierzyć konkretny komputer. Na ten moment jednak wystarczył mi zwykły plik tekstowy wyglądający mniej więcej tak (niestety nie udało mi się znaleźć jak zmienić nfsroot na nazwę domenową zamiast IP):

<pre class="EnlighterJSRAW">#!ipxe
dhcp
kernel http://boot.ksi/vmlinuz-linux quiet ip=:::::eth0:dhcp nfsroot=192.168.88.134:/home/linuks
initrd http://boot.ksi/initramfs-linux-fallback.img
boot</pre>

U mnie webserver wystawia /boot systemu który się bootuje &#8211; łatwiej o porządek.

Żeby Arch&nbsp;miał NFS na starcie trzeba dodać hook do initramu. Dla NFS v4 (defaultowy jest zwykle v3) trzeba trochę [pohackować sedem][4]. Potem (dla obu) wystarczy&nbsp;zmienić plik <span class="lang:default EnlighterJSRAW crayon-inline ">/etc/mkinitcpio.conf</span>&nbsp;:

<pre class="lang:default EnlighterJSRAW">MODULES="... nfs" 
BINARIES="... /usr/bin/mount.nfs" 
HOOKS="... net_nfs"</pre>

Jak teraz przekonać stację roboczą do zabootwania naszego pliku iPXE? Najprościej serwerem dhcp który wystawia ścieżkę TFTP. Ponieważ w mojej konfiguracji występuje NAT to w OpenWRT wystarczyło wyklikać włączenie bootowania i podać ścieżkę. A plik wgrać po SSH (rootfs jest RW). Jednak przy użyciu dnsmasq konfig wymaga jedynie:

<pre class="lang:default EnlighterJSRAW">dhcp-boot=pxelinux.0</pre>

pxelinux.0 to plik na serwerze TFTP zainstalowanym na przykład&nbsp;[w ten sposób][5].

Teoretycznie to wszystko &#8211; dodajemy logowanie sieciowe i koniec. Tylko co wtedy gdy chcemy zrobić konto gościa i pozwolić na lokalnego roota żeby na szybko user mógł sobie zainstalować pakiet (wtedy oczywiście przezorny użytkownik rebootuje przed użyciem)? Rozwiązaniem problemu jest system plików typu&nbsp;_overlay_ (na ten moment są dostępne trzy &#8211; aufs stosowany w livecd, unionfs i overlayFS) &#8211; pozwala on na połączenie dwóch systemów plików w jeden &#8211; np. jeden tylko do odczytu (np. płyta cd) a drugi do zapisu (np. ram-dysk). OverlayFS jest opisany dość dobrze na archwiki &#8211;&nbsp;<https://wiki.archlinux.org/index.php/Overlay_filesystem>

Cała sztuka polega na załadowaniu overlaya&nbsp;_zanim_ wystartuje systemd albo inny init. Po wielu _wielu_ próbach (także z AuFS), które udowniły mi że nie da się przemontować overlaya (tj. zmienić upper i lower) a także że można uszkodzić mount (czyli &nbsp;po przemontowaniu /new_root stracić oryginalne ścieżki) znalazłem&nbsp;_gotowca_. W AURze &#8211; liveroot &#8211;&nbsp;<https://aur.archlinux.org/packages/liveroot/>&nbsp; &#8211; wystarczy do mkinicpio.conf dodać hooka &#8222;<span class=" author-d-iz88z86z86za0dz67zz78zz78zz74zz68zjz80zz71z9iz90za38gz74zohv1o6twuz73zi0oz73zz67zarrz83zgz81zz74z57oz71z">oroot&#8221;. No i przebudować (<span class="lang:default EnlighterJSRAW crayon-inline ">mkinicpio -p linux</span>&nbsp;). Żeby się to ładowało należy dodać do linii kernela (w iPXE po prostu na końcu linii) &#8211;&nbsp;</span>

<pre class="lang:default EnlighterJSRAW">oroot=raw</pre>

tryb raw ładuje zmiany do ramu, a live całość do ramu.

Na koniec kilka słów o administrowaniu tym systemem. Można się wygodnie zchrootować z hosta i wykonywać aktualizacje itp. Przydatny oneliner ładujący bindy:

<pre class="lang:default EnlighterJSRAW ">cd /home/linuks && mount -t proc /proc proc && mount --rbind /sys sys && mount --rbind /dev dev && mount --rbind /run run && chroot .</pre>

Żeby ułatwić sobie pracę można dodać doatkowy wpis w konfigu serwera NFS który dla jednego IP pozwoli na pracę z zapisem&nbsp;(zmiana opcji ro na rw) + oczywiście wywalić oroot z linii jądra &#8211; można to zrobić albo dynamicznym skryptem albo z palca &#8211; iPXE ma linię komend odpalaną Ctrl+B na starcie.

Przy okazji hackowania overlayfs w momencie rozruchu dotarłem do bardzo dobrrej dokumemntacji na ArchWiki na temat [hooków mkinitcpio][6] i procesu tworzenia /new_root

Dla debiana i pochodnych także istnieje gotowe rozwiązanie &#8211;&nbsp;https://github.com/chesty/overlayroot

 [1]: https://wiki.archlinux.org/index.php/Install_from_existing_Linux#Method_A:_Using_the_bootstrap_image_.28recommended.29
 [2]: http://ipxe.org/embed
 [3]: https://caddyserver.com/
 [4]: https://wiki.archlinux.org/index.php/Diskless_system#NFS
 [5]: http://askubuntu.com/a/202548
 [6]: https://wiki.archlinux.org/index.php/mkinitcpio#HOOKS