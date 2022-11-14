---
title: 'VirtualBox na Linuksie: nie można podpiąć niestandardowych urządzeń USB'
author: Daniel Skowroński
type: post
date: 2015-07-11T20:10:57+00:00
excerpt: 'Ostatnio na Linuksie (openSUSE dokładniej) napotkałem na problem z podpięciem niestandardowego urządzenia USB (Lumii w trybie bootloadera). Wystarczy doinstalować <i>VirtualBox Extension Pack</i> i dodać odpowiednie regułki udeva...'
url: /2015/07/virtualbox-na-linuksie-nie-mozna-podpiac-niestandardowych-urzadzen-usb/
tags:
  - linux
  - opensuse
  - usb
  - virtualbox

---
Ostatnio na Linuksie (openSUSE dokładniej) napotkałem na problem z podpięciem niestandardowego urządzenia USB (Lumii w trybie bootloadera).

Pierwszym problemem okazał się być brak wsparcia dla USB 2.0 (EHCI) _out of the box_ - jest to kwestia licencyjna. Dlatego trzeba doinstalować _VirtualBox Extension Pack_ ze strony [Oracle][1]. Plik *.vbox-extpack powinien się otworzyć zwykłym kliknięciem ale jeśli nie ma podpiętych skojarzeń - odpowiednią binarką będzie sam VirtualBox. Trzeba ubić wszystkie instancje vboxa i odpalić je ponownie żeby wszystko działało.

Kolejna sprawa to brak auto dostępu do urządzeń USB - enumerowanie odbywa się tylko na starcie głównego programu co mocno ubija zwłaszcza flashowanie telefonów. To z kolei związane jest z potencjalną luką bezpieczeństwa opisaną szerzej na [bugzilli Novela][2]. Generalnie aby obejść zabezpieczenia należy dodać odpowiednie reguły udeva. Należy skopiować plik `/usr/lib/udev/rules.d/60-vboxdrv.rules`  do katalogu `/etc/udev/rules.d/`  i odkomentować cztery ostatnie linijki. Teraz reboot i gotowe.

 [1]: https://www.virtualbox.org/wiki/Downloads
 [2]: https://bugzilla.novell.com/show_bug.cgi?id=664520