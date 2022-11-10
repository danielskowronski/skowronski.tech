---
title: Systemd i proste rozwiązanie prostego błędu wywołującego emergency mode
author: Daniel Skowroński
type: post
date: 2014-06-05T08:50:39+00:00
excerpt: |
  Chyba każdy Linuksowiec korzystający z dystrybucji z systemd ujrzał kiedyś taki napis w trakcie rozruchu:
  <pre class="lang:default EnlighterJSRAW">Welcome to emergency mode! 
  After login in, type "journalctl -xb" to view system logs, "systemctl reboot" to
   reboot, "systemctl default" to try again to boot in default mode.</pre>
  Okazuje się, że rozwiązanie problemu może być bardzo proste. A jego przyczyną jest zwykle Windows, który psuje swoje dyski tak, że Linuks nie chce ich montować.
url: /2014/06/systemd-i-proste-rozwiazanie-prostego-bledu-wywolujacego-emergency-mode/

---
Chyba każdy Linuksowiec korzystający z dystrybucji z systemd ujrzał kiedyś taki napis w trakcie rozruchu:

<pre class="lang:default EnlighterJSRAW">Welcome to emergency mode! 
After login in, type "journalctl -xb" to view system logs, "systemctl reboot" to reboot, 
"systemctl default" to try again to boot in default mode.</pre>

Okazuje się, że rozwiązanie problemu może być bardzo proste.

Po pierwsze &#8211; warto użyć sugerowanego <span class="lang:default EnlighterJSRAW  crayon-inline">journalctl -xb</span> i kliknąć End (journalctl ładuje logi do less&#8217;a) aby przejść na sam koniec. Jeśli błąd nam nic nie mówi, albo nie ma nic do rzeczy z rozruchem, jak chociażby:

<pre class="lang:default EnlighterJSRAW">systemd[456]: Failed at step EXEC spawning /bin/plymouth: No such file or directory
Subject: Process /bin/plymouth coud not be executed and failed
Defined by: systemd</pre>

to nawet jeśli faktycznie przykładowy /bin/plymouth nie istnieje należy się zastanowić, **czy nie ma problemu z montowaniami jakiejkolwiek partycji**. Jeśli mamy w <span class="lang:default EnlighterJSRAW  crayon-inline ">/etc/fstab</span> na sztywno wpisanego jakiegoś NTFSa (np. wspólną dla Win i Linuks partycję na dane) to w ciemno obstawiam &#8222;nie-czyste&#8221; (_Volume not cleanly unmounted_) odmontowanie partycji (czyt. wymuszone ubicie Windowsa) lub hibernację (flaga hibernacji sprawia kłopoty; co ciekawsze &#8211; niektóre Windowsy wykazują chęć usuwania wszystkich modyfikacji systemu plików, które powstały w trakcie hibernacji &#8211; czyli hibernacja Win, zmiana plików pod Linuksem, wybudzenie Win nic nie da). Może to też być zachcianka (szczególnie Win8) do zmiany identyfikatorów partycji lub czegoś podobnego. Nawet, żebyśmy używali jako identyfikatorów partycji do montowania ścieżek z /dev/ zamiast UUID= to systemd i tak może uznać to za błąd. A ze swojej głupoty odmówi ich montowania i co gorsza przerwie rozruch sypiąc losowym błędem (albo niekrytycznym błędem który akurat wystąpił).

Rozwiązanie: na początek w <span class="lang:default EnlighterJSRAW  crayon-inline ">/etc/fstab</span> komentujemy wszystko poza rootfs&#8217;em, zapisujemy i <span class="lang:default EnlighterJSRAW  crayon-inline">reboot</span> &#8211; sugerowany <span class="lang:default EnlighterJSRAW  crayon-inline">systemctl default</span> nie przeładuje systemd od odpowiedniego momentu. Jeśli po restarcie wszystko działa trzeba ręcznie sprawdzić każdy wpis w fstab&#8217;ie i zaktualizować plik odpowiednimi zmianami.