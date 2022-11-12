---
title: Firefox wyglądający po ludzku pod Linuksem.
author: Daniel Skowroński
type: post
date: 2014-04-30T13:23:16+00:00
excerpt: 'Na Windowsach 7 i nowszych mamy ładny centralny przycisk "Firefox" oraz usunięty pasek tytułu w trybie maksymalizacji - bo po co on komu no i zajmuje tylko miejsce. Na Linuksach wygląda to tragicznie. Ani GTK, ani Qt czyli silniki utrzymujące Gnome /Unity oraz KDE nijak się z tym kompatowym wyglądem nie integrują. Powoduje to straszne efekty wizualne, tym gorsze na stacjach typu serwer z grafiką 1024x768, gdzie wszystkie paski są monstrualnie wielkie, a ty musisz pilnie pobrać aktualizację od producenta routera czy coś podobnego.'
url: /2014/04/firefox-wygladajacy-po-ludzku-pod-linuksem/
tags:
  - firefox
  - linux

---
Na Windowsach 7 i nowszych mamy ładny centralny przycisk "Firefox" oraz usunięty pasek tytułu w trybie maksymalizacji - bo po co on komu no i zajmuje tylko miejsce. Na Linuksach wygląda to tragicznie. Ani GTK, ani Qt czyli silniki utrzymujące Gnome /Unity oraz KDE nijak się z tym kompatowym wyglądem nie integrują. Powoduje to straszne efekty wizualne, tym gorsze na stacjach typu serwer z grafiką 1024x768, gdzie wszystkie paski są monstrualnie wielkie, a ty musisz pilnie pobrać aktualizację od producenta routera czy coś podobnego.

<figure id="attachment_423" aria-describedby="caption-attachment-423" style="width: 405px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class=" wp-image-423" src="http://blog.dsinf.net/wp-content/uploads/2014/04/firefox304_suse111x64.png" alt="Firefox - mały obszar roboczy" width="405" height="304" srcset="https://blog.dsinf.net/wp-content/uploads/2014/04/firefox304_suse111x64.png 800w, https://blog.dsinf.net/wp-content/uploads/2014/04/firefox304_suse111x64-300x225.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/04/firefox304_suse111x64-660x495.png 660w" sizes="(max-width: 405px) 100vw, 405px" />][1]<figcaption id="caption-attachment-423" class="wp-caption-text">Firefox - mały obszar roboczy</figcaption></figure>

#### Jednak istnieje łatwy i wygodny sposób, żeby FF wyglądał ładniej.

Zanim dokonamy jakiejkolwiek zmiany to pod KDE należy zrobić to co opisano [na wiki Archa][2] - instalujemy oxygen-gtk2 i kde-gtk-config, a w ustawieniach wygląd aplikacji>GTK dajemu motyw oxygen-gtk.

Sednem sprawy jest plugin [<img decoding="async" src="https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13505-64.png?modified=1398299229" alt="" />Hide Caption Titlebar Plus][3]. Jak to w Mozilli bywa jest niekompatybilny z Linuksem. Ale da się to ominąć klikając wyszarzone _Add to Firefox_. Instalacja i restart. Teraz przechodzimy do ustawień. Są one na pierwszy rzut oka nieuporządkowane, dlatego zaprezentuję moją konfigurację wyjściową:

[<img decoding="async" loading="lazy" class="alignnone  wp-image-424" src="http://blog.dsinf.net/wp-content/uploads/2014/04/a1.png" alt="Hide Caption Titlebar Plus - config - 1" width="682" height="455" srcset="https://blog.dsinf.net/wp-content/uploads/2014/04/a1.png 920w, https://blog.dsinf.net/wp-content/uploads/2014/04/a1-300x200.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/04/a1-660x440.png 660w, https://blog.dsinf.net/wp-content/uploads/2014/04/a1-900x600.png 900w" sizes="(max-width: 682px) 100vw, 682px" />][4]

[<img decoding="async" loading="lazy" class="alignnone  wp-image-425" src="http://blog.dsinf.net/wp-content/uploads/2014/04/a2.png" alt="Hide Caption Titlebar Plus - config - 2" width="680" height="456" />][5]

[<img decoding="async" loading="lazy" class="alignnone  wp-image-426" src="http://blog.dsinf.net/wp-content/uploads/2014/04/a3.png" alt="Hide Caption Titlebar Plus - config - 3" width="681" height="454" srcset="https://blog.dsinf.net/wp-content/uploads/2014/04/a3.png 920w, https://blog.dsinf.net/wp-content/uploads/2014/04/a3-300x200.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/04/a3-660x440.png 660w, https://blog.dsinf.net/wp-content/uploads/2014/04/a3-900x600.png 900w" sizes="(max-width: 681px) 100vw, 681px" />][6]

#### Efekt:

[<img decoding="async" loading="lazy" class="alignnone  wp-image-428" src="http://blog.dsinf.net/wp-content/uploads/2014/04/a5.png" alt="Hide Caption Titlebar Plus - efekt - 1" width="685" height="497" srcset="https://blog.dsinf.net/wp-content/uploads/2014/04/a5.png 985w, https://blog.dsinf.net/wp-content/uploads/2014/04/a5-300x217.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/04/a5-660x479.png 660w, https://blog.dsinf.net/wp-content/uploads/2014/04/a5-900x653.png 900w" sizes="(max-width: 685px) 100vw, 685px" />][7]

&nbsp;

Czasem podczas dużych zmian w ustawieniach przeglądarka nie trzyma w ryzach zmian i każde okno wygląda inaczej. Wtedy pozostaje nam <span class="lang:default EnlighterJSRAW  crayon-inline ">killall firefox</span> . Kilkanaście minut i nasza ulubiona przeglądarka wygląda jak powinna.

 [1]: http://blog.dsinf.net/wp-content/uploads/2014/04/firefox304_suse111x64.png
 [2]: https://wiki.archlinux.org/index.php/firefox#KDE_integration
 [3]: https://addons.mozilla.org/firefox/addon/13505/
 [4]: http://blog.dsinf.net/wp-content/uploads/2014/04/a1.png
 [5]: http://blog.dsinf.net/wp-content/uploads/2014/04/a2.png
 [6]: http://blog.dsinf.net/wp-content/uploads/2014/04/a3.png
 [7]: http://blog.dsinf.net/wp-content/uploads/2014/04/a5.png