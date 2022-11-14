---
title: 'Zegar w Kindle: ulepszenia part 1'
author: Daniel Skowroński
type: post
date: 2014-06-20T10:17:35+00:00
summary: 'Jakiś czas temu zirytowany brakiem zegarka w moim Kindle 3 napisałem własny. Przyszedł jednak czas na ulepszenia - nowy tryb pracy aktywowany podczas czytania książki.'
url: /2014/06/zegar-w-kindle-ulepszenia-part-1/
tags:
  - kindle
  - linux

---
Jakiś czas temu zirytowany brakiem zegarka w moim Kindle 3 napisałem własny. Pełna historia [w tym wpisie][1]. Przyszedł jednak czas na ulepszenia. Poza wybranym z czasem opóźnieniem w dopisywaniu się do ekranu pojawił się zupełnie nowy tryb - mniejszy zegar w czasie czytania książki. Natywny dla interfejsu rozmiar czcionki nie rozprasza i nie przykrywa paska postępu.

Pierwszym wyzwaniem było sprawdzenie czy aktualnie otwarta jest książka, czy też nie. Wykorzystałem zasoby procfs z katalogu fd wskazujące otwarte pliki. Długi czas się głowiłem dlaczego cały czas mam informacje o otwartej książce, aż połapałem się że launcher KUAL jest otwarty na stałe - stąd wystarczy wykluczyć pliki azw2 zawierające natywne binarki Kindle. Zrealizowane taką oto funkcją:

```bash
isBookOpened(){
  ls -al /proc/`cat /var/run/cvm.pid`/fd | 
  grep documents | 
  grep -v azw2 | # invert search of kindle apps (e.g. KUAL)
  wc -l
}
```


Następnym krokiem było użycie mniejszego fontu. Problem polega na tym, że eips na Kindle 3 niezbyt dobrze radzi sobie z wstawianiem obrazków (a już miałem robić 10+1 bitmap kilka na kilka pikseli). Rysowanie prostokątów na mojej wersji urządzenia też zawodzi. Odnalazłem jednak binarkę fbprint (dostępną na [mobileread.com][2]), która pisze po ekranie w natywny dla interfejsu sposób. 

Trochę kalibracji i efekty są takie:  

![ZEGAR 0.2 - w trybie książki](/wp-content/uploads/2014/06/WP_20140620_001.jpg)

![ZEGAR 0.2 - w reszcie UI](/wp-content/uploads/2014/06/WP_20140620_003.jpg)


```bash
#!/bin/sh

read cvmPid < /var/run/cvm.pid

if [ -z "$cvmPid" ]; then
  eips 0 38 " ZEGAR ERROR: "
  eips 0 39 " cvm is dead :( reboot needed"
  exit 2
fi

isBookOpened(){
  ls -al /proc/`cat /var/run/cvm.pid`/fd | 
  grep documents | 
  grep -v azw2 | # invert search of kindle apps (e.g. KUAL)
  wc -l
}

showTimeBook(){
  /mnt/us/zegar/fbprint 525 767 `date +"%H:%M"` 
  # little nice-fonted kindle-ui-like clock 
  # on right side of the progress bar (opposite to book percentage)
  # to be shown when reading book
}
showTimeGeneral(){
  eips 45 39 `date +"%H:%M"` 
  # huge rough TTY-like clock 
  # in bottom right corner to be shown in UI
}

while :; do
  waitforkey &&
  usleep 100000 &&
  x=$(isBookOpened)

  if [ "$x" == "0" ]; then
    showTimeGeneral
  else
    showTimeBook     
  fi
done
```


Całość ładnie upakowaną można pobrać tutaj: [zegar_0.2][5]

 [1]: http://blog.dsinf.net/2014/05/zegar-w-kindle/
 [2]: http://www.mobileread.com/forums/showthread.php?t=147870
 [3]: /wp-content/uploads/2014/06/WP_20140620_001.jpg
 [4]: /wp-content/uploads/2014/06/WP_20140620_003.jpg
 [5]: /wp-content/uploads/2014/06/zegar_0.2.zip