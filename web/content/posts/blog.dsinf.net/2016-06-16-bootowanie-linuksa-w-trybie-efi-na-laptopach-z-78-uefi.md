---
title: Bootowanie Linuksa w trybie EFI na laptopach z 7/8 UEFI
author: Daniel Skowroński
type: post
date: 2016-06-16T08:54:43+00:00
excerpt: |
  |
    Stopień implementacji EFI na komputerach, a zwłaszcza laptopach bardzo długo dążył do 100% i często był nakierowany tylko na Windowsa - od sytuacji gdy mamy EFI zablokowane na tryb BIOS (Insyde H2O w netbookach Acera), przez blokadę tylko na podpisane cyfrowo bootloadery, po laptopy które mają UEFI, ale nie można z poziomu systemu operacyjnego manipulować efiibootmgr. Dziś o bootowaniu Linuksa z tych ostatnich.
url: /2016/06/bootowanie-linuksa-w-trybie-efi-na-laptopach-z-78-uefi/
tags:
  - hp
  - linux
  - uefi

---
Stopień implementacji EFI na komputerach, a zwłaszcza laptopach bardzo długo dążył do 100% i często był nakierowany tylko na Windowsa - od sytuacji gdy mamy EFI zablokowane na tryb BIOS (Insyde H2O w netbookach Acera), przez blokadę tylko na podpisane cyfrowo bootloadery, po laptopy które mają UEFI, ale nie można z poziomu systemu operacyjnego manipulować efiibootmgr. Dziś o bootowaniu Linuksa z tych ostatnich.

Część dystrybucji ma sprytny instalator, na części trzeba to zrobić ręcznie - tu się nie będę rozpisywał i tylko odeślę na klasyczne [wiki Archa][1]. W skrócie potrzeba nam jednej partycji sformatowanej jako FAT32. Mając UEFI instalator gruba sam dodaje sobie wpis w bootmanagerze samego EFI i wszystko działa. Ale na części laptopów (m.in. HP EliteBook 25xx) komputer ignoruje zapis. Wówczas mamy do wyboru (na szczęście chociaż tyle) korzystanie z file browsera w menu wyboru urządzenia startowego (oczywiście za każdym rozruchem), albo... skopiowanie pliku rozruchowego (.EFI) do lokalizacji zgodnej z Windowsową.

Windows trzyma plik .EFI w następującej lokacji:

<pre class="lang:default EnlighterJSRAW " >&lt;partycja EFI&gt;\EFI\BOOT\BOOTX64.EFI</pre>

Nazwa pliku musi być dokładnie taka. Niestety symlink nie pomoże bo to FAT + na tym etapie nie ma montowania innych partycji, trzeba plik brutalnie skopiować, Po takiej manipulacji BIOS, tfu... UEFI wykrywa system samoczynnie.

Dlaczego uważam że brak możliwości zmiany efibootmgr to 7/8 UEFI? Może dlatego że Win7 i Win8 tego do szczęścia nie potrzebują 😛

 [1]: https://wiki.archlinux.org/index.php/GRUB