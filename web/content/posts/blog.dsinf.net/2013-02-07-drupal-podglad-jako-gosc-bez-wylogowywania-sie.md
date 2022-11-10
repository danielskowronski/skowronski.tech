---
title: 'Drupal: podgląd jako gość bez wylogowywania się'
author: Daniel Skowroński
type: post
date: 2013-02-07T20:06:57+00:00
url: /2013/02/drupal-podglad-jako-gosc-bez-wylogowywania-sie/
tags:
  - drupal
  - www

---
Częsty problem przy zarządzaniu Drupalem na poziomie modułów, czy konfiguracji witryny &#8211; chcemy podejrzeć stronę jako osoba postronna, czyli gość. <!--break-->

  
Najprostszy sposób &#8211; druga przeglądarka, albo inna stacja robocza. Ale można o wiele prościej. Każdy z nas ma odruch wpisywania <u>www&#46;</u>example&#46;com albo example&#46;com &#8211; mało jest witryn, w których www przekierowywuje na inny serwer. Wiedząc, że przeglądarki traktują _www&#46;cokolwiek_ i samo _cokolwiek_ jako dwie inne witryny wobec tego na jednej z nich jesteśmy zalogowani, na drugiej &#8211; nie. Jeśli tak nie jest to czemu nie wylogować się na jednej z nich?  
Teraz wystarczy jedynie wejść na www.example.com w karcie obok i gotowe &#8211; np. widzimy, czy ukryliśmy przed gośćmi komunikaty o błędach.