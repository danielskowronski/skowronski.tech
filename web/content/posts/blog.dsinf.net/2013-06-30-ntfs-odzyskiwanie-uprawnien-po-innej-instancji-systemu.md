---
title: 'NTFS: Odzyskiwanie uprawnień po innej instancji systemu'
author: Daniel Skowroński
type: post
date: 2013-06-30T20:33:18+00:00
url: /2013/06/ntfs-odzyskiwanie-uprawnien-po-innej-instancji-systemu/
tags:
  - ntfs
  - windows

---
Po reinstalacji Windowsa może nas przywitać smutna niespodzianka &#8211; pliki na dysku z danymi mają prawa własności na poprzednią instancję i z jakichś powodów reszta świata ma _readonly_.  
Oczywiście &#8211; można pod Linuksem pliki skopiować, oryginały usunąć i wgrać z powrotem, ale dziś rozwiązanie mniej brutalne i dodatkowo &#8222;server friendly&#8221;, czyli bez restartu.  
<!--break-->

Oto lista kroków niezbędnych do odzyskania pełnej kontroli nad plikami (oczywiście najlepiej byłoby mieć uprawnienia administratora na naszym systemie):

**1.**  
<img decoding="async" src="http://www.ds.lublin.pl/sites/default/files/permreset.png" />  
Wchodzimy we właściwości obiektu w Eksploratorze Windows &#8211; prawe kliknięcie pliku bądź katalogu. Tamże w karcie _Zabezpieczenia_ wybieramy _Zaawansowane_

**2.**  
<img decoding="async" src="http://www.ds.lublin.pl/sites/default/files/permreset2.png" />  
Wybieramy opcję zmiany właściciela

**3.**  
<img decoding="async" src="http://www.ds.lublin.pl/sites/default/files/permreset3.png" />  
Teraz albo wpisujemy pełną ścieżkę do nauszego użytkownika, albo tylko login i klikamy uzupełnianie nazw.

**4.**  
<img decoding="async" src="http://www.ds.lublin.pl/sites/default/files/permreset4.png" />  
Jeśli obiektem jest katalog na 99% chodzi nam także o dziedziczenie praw &#8211; odpowiedzialny jest za to najniżej położony checkbox. Uwaga: naprawdę trzeba całkiem zamknąć oknieko własciwowści obiektu i wywołac je ponownie, żeby zobaczyć zmiany.

**5.**  
<img decoding="async" src="http://www.ds.lublin.pl/sites/default/files/permreset5.png" />  
Teraz pozostaje nam w podstawowym widoku edytora uprawnień odnaleźć siebie i wybrać _Zezwól_ -> _Pełen dostęp_