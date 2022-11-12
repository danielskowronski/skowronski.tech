---
title: Szybka rada na brak ethernetu w Win8
author: Daniel Skowroński
type: post
date: 2012-08-13T12:26:37+00:00
url: /2012/08/szybka-rada-na-brak-ethernetu-w-win8/
tags:
  - windows
  - windows 8

---
Będąc lekko poddenerwowany "inteligencją" ósemki polegającą na zmianie języka systemowego na ruski po dodaniu nowego układu klawiatury wkurzyłem się kolejnym problem: podpinając kabel sieciowy do laptopa nie ujrzałem żadnego komunikatu systemowego. Wchodzę w cmd, odpalam 

<pre class="EnlighterJSRAW bash">c:\Windows\System32\IPCONFIG.EXE</pre>

(%PATH% jakimś cudem znikł).  
Karta odłączona. 

Jeden z przyjaciół zagubionego w systemie MS - **devmgmt.msc** stwierdza że _Сетевые адаптеры/Qualcomm Athertos (...) PCI-E Gigabit Ethernet Controller_ jest chyba włączony.  
Po jakimś czasie ręcznego grzebania dotarłem do problemu.  
Otóż w parametrach (_свойствах_) na karcie _Advanced_ (_Дополнительно_) należy ustawić adres MAC bo system nie umie go odczytać. Wystarczy wybrać _Network address_ i wpisać MAC w pole _wartość_ (_эначение_).  
I po kłopocie.