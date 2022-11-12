---
title: Grupa video – Nvidia pod Linuksem
author: Daniel Skowroński
type: post
date: 2013-03-24T21:24:14+00:00
url: /2013/03/grupa-video-nvidia-pod-linuksem/
tags:
  - linux
  - nvidia

---
Znane są problemy ze współpracą własnościowych sterowników nvidia i środowiska Gnome Shell. Jeśli jednak środowisko "nie działa" tylko dla użytkowników nie-super to jest na to sposób.  
<!--break-->

  
  
W sysytemie Linuks jest dosyć ciekawa grupa <strng>video</strong>, która w dawnych czasach miała jakieś znaczenie, później praktycznie nie używana. Jednak sterownik nvidii używa dwóch urządzeń znakowych /dev/nvidia0 i /dev/nvdiactl, których właścicielem jest rzecz jasna root, i należą do grupy video. Uprawnienia są restrykcyjne:

<pre class="EnlighterJSRAW bash">daniel@ asus:~> ls -al /dev/nvidia*
crw-rw---- 1 root video 195,   0 03-24 21:09 /dev/nvidia0
crw-rw---- 1 root video 195, 255 03-24 21:09 /dev/nvidiactl
</pre>

W żadnym miejscu instalator sterowników nvidii o tym nie informuje. Co ciekawe metoda jednego kliknięcia (pliki YMP ładujące paczki z repozytoriów), która po raz pierwszy nie uszkodziła systemu do reszty (dla GeForce G210M z 2009 roku - wesraj druga "G02") też nie wprowadziła odpowiednich zmian w grupach.  
Aby dodać użytkownika daniel do grupy video wystarczy komenda:

<pre class="EnlighterJSRAW bash">usermod -a -G video daniel
</pre>

Lepiej na starcie po instalacji sprawdzić, czy jesteśmy w grupie video i na wszelki wypadek pododawać się do co ważniejszych grup (np. vboxusers, games, gdm, cdrom), zeby potem nie szukać. Co dziwne - moje konto utworzył instalator openSUSE 12.3 - nie byłem w żadnej grupie prócz podstawowej users.  
  
UPDATE: Uprawnienia można zmienić w opcjach modprobe w pliku

<pre class="EnlighterJSRAW bash">/etc/modprobe.d/50-nvidia.conf</pre>