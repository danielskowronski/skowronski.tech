---
title: Pliki AVI z kodekiem H/264 dla Adobe Premiere
author: Daniel Skowroński
type: post
date: 2013-02-11T19:04:48+00:00
url: /2013/02/pliki-avi-z-kodekiem-h264-dla-adobe-premiere/
tags:
  - adobe premiere
  - avi
  - ffmpeg
  - h/264

---
Adobe Premiere z niewyjaśnionych przyczyn nie chce importować plików AVI z kodekiem H/264. Czasem importuje z nich jedynie ścieżkę dźwiękową. Ale jest prosty sposób by bez wielkiego zachodu i konwertowania _sensu stricto_ plików wimportować je.<!--break-->

Potrzebny będzie **ffmpeg** do pobrania we wszelakich wersjach ze strony http://ffmpeg.zeranoe.com/builds/. Teraz należy rozpakować ffmpeg.exe do katalogu, z którego pliki nas interesują lub dodać go do PATHa i wywołać polecenie

```bash
for %%a in (*.avi) do ffmpeg -i "%%a" -vcodec copy -acodec copy -f mp4 -y "%%~na".mp4
```


Wynikiem jego pracy będzie _przepisanie_ kontenera obrazu ze wszystkich plików w katalogu do plików mp4, które Adobe Premiere przyjmie. Jedyny problem to ew. brak ścieżki audio. Ale wówczas problemem nie będzie dodanie pliku AVI jako dźwięku równoległego do obrazu z MP4.  
Prawda, jakie pokrętne?



<div id="zrodlo">
  źródło: http://forums.adobe.com/thread/854115
</div>