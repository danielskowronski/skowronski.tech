---
title: Wypalanie płyt pod Windows Server
author: Daniel Skowroński
type: post
date: 2013-03-13T14:40:07+00:00
url: /2013/03/wypalanie-plyt-pod-windows-server/
tags:
  - windows server

---
Na Windows Server czasem wypala się płyty. Ale jest to prawie niemożliwe.  
<!--break-->

  
Microsoft ma dziwne zasady co do uprawnień - konto Administrator może więcej niż członkowie grupy administratorzy. Dlatego każdy inny użytkownik widzi napęd optyczny jako read-only: jaki by to model sprzętu nie był - system _odmawia_ wypalania płyt. Czy użyjemy systemowych narzędzi (od 2012 są zintegrowane), czy _third party_ (CD BurnerXP, UltraISO...) - nie da się.  
Zabezpieczenie przed wykradaniem danych? Złośliwość? A może zabezpieczenie przed błędami wynikającymi z nieobsłużenia wypalania płyty na raz przez dwóch userów? To bez znaczenia, nic się na to nie poradzi.  
Reasumując: jeśli ktoś chce wypalić płytę a nie jest Administratorem z wielkiej litery to pozostaje mu łaska sysadmina i RunAs.

```bash
C:\Users\admin1>runas /env /user:Administrator "C:\Program Files (x86)\UltraISO\UltraISO.exe"

```


A sam sysadmin? Cóż, musi zdecydować, czy woli wypalanie płyt, czy sklep z aplikacjami dla 2012 i RunAs.  
No i najważniejsze - musi być dodatek Desktop Experience - wersja Core marnuje nam napędy.

źródło: [http://blogs.technet.com/b/askcore/archive/2010/02/19/windows-server-2008-r2-no-recording-tab-for-cd-dvd-burner.aspx](http://blogs.technet.com/b/askcore/archive/2010/02/19/windows-server-2008-r2-no-recording-tab-for-cd-dvd-burner.aspx)