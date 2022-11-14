---
title: Firefox wyglądający po ludzku pod Linuksem.
author: Daniel Skowroński
type: post
date: 2014-04-30T13:23:16+00:00
summary: 'Na Windowsach 7 i nowszych mamy ładny centralny przycisk "Firefox" oraz usunięty pasek tytułu w trybie maksymalizacji - bo po co on komu no i zajmuje tylko miejsce. Na Linuksach wygląda to tragicznie. Ani GTK, ani Qt czyli silniki utrzymujące Gnome /Unity oraz KDE nijak się z tym kompatowym wyglądem nie integrują. Powoduje to straszne efekty wizualne, tym gorsze na stacjach typu serwer z grafiką 1024x768, gdzie wszystkie paski są monstrualnie wielkie, a ty musisz pilnie pobrać aktualizację od producenta routera czy coś podobnego.'
url: /2014/04/firefox-wygladajacy-po-ludzku-pod-linuksem/
tags:
  - firefox
  - linux

---
Na Windowsach 7 i nowszych mamy ładny centralny przycisk "Firefox" oraz usunięty pasek tytułu w trybie maksymalizacji - bo po co on komu no i zajmuje tylko miejsce. Na Linuksach wygląda to tragicznie. Ani GTK, ani Qt czyli silniki utrzymujące Gnome /Unity oraz KDE nijak się z tym kompatowym wyglądem nie integrują. Powoduje to straszne efekty wizualne, tym gorsze na stacjach typu serwer z grafiką 1024x768, gdzie wszystkie paski są monstrualnie wielkie, a ty musisz pilnie pobrać aktualizację od producenta routera czy coś podobnego.

![Firefox - mały obszar roboczy](/wp-content/uploads/2014/04/firefox304_suse111x64.png)

#### Jednak istnieje łatwy i wygodny sposób, żeby FF wyglądał ładniej.

Zanim dokonamy jakiejkolwiek zmiany to pod KDE należy zrobić to co opisano [na wiki Archa][2] - instalujemy oxygen-gtk2 i kde-gtk-config, a w ustawieniach wygląd aplikacji>GTK dajemu motyw oxygen-gtk.

Sednem sprawy jest plugin [Hide Caption Titlebar Plus](https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13505-64.png?modified=1398299229). Jak to w Mozilli bywa jest niekompatybilny z Linuksem. Ale da się to ominąć klikając wyszarzone _Add to Firefox_. Instalacja i restart. Teraz przechodzimy do ustawień. Są one na pierwszy rzut oka nieuporządkowane, dlatego zaprezentuję moją konfigurację wyjściową:

![Hide Caption Titlebar Plus - config - 1](/wp-content/uploads/2014/04/a1.png)

![Hide Caption Titlebar Plus - config - 2](/wp-content/uploads/2014/04/a2.png)

![Hide Caption Titlebar Plus - config - 3](/wp-content/uploads/2014/04/a3.png)

#### Efekt:

![Hide Caption Titlebar Plus - efekt - 1](/wp-content/uploads/2014/04/a5.png)

&nbsp;

Czasem podczas dużych zmian w ustawieniach przeglądarka nie trzyma w ryzach zmian i każde okno wygląda inaczej. Wtedy pozostaje nam `killall firefox` . Kilkanaście minut i nasza ulubiona przeglądarka wygląda jak powinna.

 [1]: /wp-content/uploads/2014/04/firefox304_suse111x64.png
 [2]: https://wiki.archlinux.org/index.php/firefox#KDE_integration
 [3]: https://addons.mozilla.org/firefox/addon/13505/
 [4]: /wp-content/uploads/2014/04/a1.png
 [5]: /wp-content/uploads/2014/04/a2.png
 [6]: /wp-content/uploads/2014/04/a3.png
 [7]: /wp-content/uploads/2014/04/a5.png