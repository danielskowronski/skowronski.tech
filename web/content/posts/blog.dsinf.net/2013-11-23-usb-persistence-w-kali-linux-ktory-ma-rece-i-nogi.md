---
title: USB persistence w Kali Linux, który ma ręce i nogi
author: Daniel Skowroński
type: post
date: 2013-11-23T19:14:40+00:00
excerpt: "Kali Linux to następca BackTracka - uznana dystrybucja wyposażona w narzędzia do <i>pentestingu</i> i te z kategorii <i>forensic</i>. Podstawowym trybem pracy jest Live DVD, jest opcja zainstalowania na twardym dysku (dzięki Debian-Installer). Według twórców można też łatwo i wygodnie używać trybu <i>pesistence</i>, czyli zgrać ISO na pendrive'a za pomocą DD lub <i>Win32 DiskImager</i> i dodać jedną partycję, która będzie zbierać zmiany w stosunku do oryginalnego obrazu. Jest jeden szkopuł - <i>Add the word “persistence” to the end of the boot parameter line <b>each time</b> you want to mount your persistent storage</i> - czyli za każdym rozruchem trzeba dodawać parametr jądra &quot;z palca&quot;..."
url: /2013/11/usb-persistence-w-kali-linux-ktory-ma-rece-i-nogi/
tags:
  - kali linux
  - linux
  - persistence
  - usb

---
Kali Linux to następca BackTracka &#8211; uznana dystrybucja wyposażona w narzędzia do _pentestingu_ i te z kategorii _forensic_. Podstawowym trybem pracy jest Live DVD, jest opcja zainstalowania na twardym dysku (dzięki Debian-Installer). Według twórców można też łatwo i wygodnie używać trybu _persistence_, czyli zgrać ISO na pendrive&#8217;a za pomocą DD lub _Win32 DiskImager_ i dodać jedną partycję, która będzie zbierać zmiany w stosunku do oryginalnego obrazu. Jest jeden szkopuł &#8211; _Add the word “persistence” to the end of the boot parameter line **each time** you want to mount your persistent storage_ &#8211; czyli za każdym rozruchem trzeba dodawać parametr jądra "z palca"&#8230;

Jeśli skorzystamy z metody DD mamy taką sytuację:  
&nbsp;&nbsp;Menadżer rozruchu, w tym wypadku isolinux, znajduje się na pierwszej partycji urządzenia z systeme plików _iso9660_ (ok. 2.5GB; flagi: _hidden_, _boot_). Oznacza to, że **nie zmienimy NIC** &#8211; w żaden sposób &#8211; systemy po zamontowaniu zinterpetują to jak napęd CD. Można teoretycznie próbować zmienić źródłowe iso przed "wypaleniem", ale nie udało mi się zachować oryginalnych danych o układzie partycji i bootsectorze korzystając z wielu różnorakich programów &#8211; ISO master, K3B, Daemon Tools, Alcohol 120%, Magic ISO &#8211; wszystko przepadało. A próby delikatnego dopisywania kawałków informacji przez dd z offsetami skazane było z góry na porażkę&#8230;

**Szybki sposób jednak istnieje!** A oto on:  
&nbsp;&nbsp;Partycjonujemy nośnik USB na samym początku tak, że pierwsza partycja to FAT32 o rozmiarze pliku iso plus kilka mega (dla wersji 1.0.5, która waży ok. 2600MB dałem dla pewności wszelkiej 2700MB) i reszta (czyli do końca) to ext4 nazwany dokładnie _persistence_.  
&nbsp;&nbsp;Używając klasycznego **Universal USB Installer**&#8217;a do popbrania np. [stąd][1] postępujemy jak dla każdej instalacji &#8211; wybieramy dystrybucję z listy, wskazujemy plik ISO, wybieramy dysk (Windows widzi jedynie pierwszą partycję więc wskazujemy tą, która ma 2,5GB) i klikamy _Create_. Metoda ta polega na wypakowaniu ISO na FATa i zaplikowaniu właściwego bootsectora.  
&nbsp;&nbsp;Kolejny krok musimy podjąć na Linuksie &#8211; trzeba utworzyć plik persistence.conf i wpisać do niego co następuje: <span class="lang:default EnlighterJSRAW  crayon-inline " >/ union</span>.  
&nbsp;&nbsp;_Last but not the least_ &#8211; uczynienie rozruchu z flagą _presistence_ automatycznym. Na pierwszej partycji w katalogu isolinux znajduje się plik live.cfg &#8211; najlepiej dodać w nim drugi wpis dla trybu persistence i ustawić go jako domyślny:

<pre class="lang:default EnlighterJSRAW " title="isolinux/live.cfg" >#nowa sekcja
label persistence-686-pae #nazwa dowolna
	menu label ^PERSISTENT (686-pae) #znowuż dowolna nazwa
	menu default #wpis czyniący tą sekcję domyślnie wybieraną
	linux /live/vmlinuz
	initrd /live/initrd.img
	append boot=live noconfig=sudo username=root hostname=PC persistence #ostatnia flaga
	
#oryginalna zawartość pliku, powinna zostać poniżej
label live-686-pae
	menu label ^Live (686-pae)
	#menu default #tą linię kasujemy lub komentujemy
	linux /live/vmlinuz
	initrd /live/initrd.img
	append boot=live noconfig=sudo username=root hostname=kali

label live-686-pae-failsafe
	menu label ^Live (686-pae failsafe)
	linux /live/vmlinuz
	initrd /live/initrd.img
	append boot=live config memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal

label live-forensic
	menu label Live (^forensic mode)
	linux /live/vmlinuz
	initrd /live/initrd.img
	append boot=live noconfig=sudo username=root hostname=kali noswap noautomount
</pre>

 [1]: http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/