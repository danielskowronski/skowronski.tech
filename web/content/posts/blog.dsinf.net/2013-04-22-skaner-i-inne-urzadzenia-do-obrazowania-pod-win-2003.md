---
title: Skaner i inne urządzenia do obrazowania pod Win 2003
author: Daniel Skowroński
type: post
date: 2013-04-22T19:33:20+00:00
url: /2013/04/skaner-i-inne-urzadzenia-do-obrazowania-pod-win-2003/
tags:
  - windows
  - windows 2003

---
Jeden z moich ulubionych kwiatków w Windowsach to _urządzenia do obrazowania_ co nawet po angielsku brzmi dziwnie (_imaging devices_). Windows 2003 ukrywa przed użytkownikami obsługę aparatów i skanerów w dość pokrętny sposób.  
<!--break-->

  
System pozwala instalować sterowniki, ale ani nie ma wpisów w Menedżerze Urządzeń, ani pozycja w Paincie nie jest dostępna.  
Rozwiązaniem jest uruchomienie usługi **Windows Image Acquisition (WIA)**. W konsoli services.msc należy zmienić _Startup type_ na _Automatic_ i ew. wystartować usługę ręcznie. Reboot nie jest konieczny.



<div id="zrodlo">
  źródło: http://www.404techsupport.com/2008/01/installing-a-scanner-on-windows-server-2003/
</div>