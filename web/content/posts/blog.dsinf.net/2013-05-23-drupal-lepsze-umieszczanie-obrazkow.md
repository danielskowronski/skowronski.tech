---
title: Drupal – lepsze umieszczanie obrazków
author: Daniel Skowroński
type: post
date: 2013-05-23T18:50:29+00:00
url: /2013/05/drupal-lepsze-umieszczanie-obrazkow/
tags:
  - drupal
  - www

---
Wszystko pięknie się dzieje w czystym Drupalu póki nie dodajemy obrazków do każdego postu - wówczas trzeba mieć dwie rzeczy: plugin do formatowania galerii i plugin do wrzucania obrazków.  
<!--break-->

  
Osobiście używam dwóch modułów - YOX view (http://drupal.org/project/yoxview, http://www.yoxigen.com/yoxview/) i FileField Sources (http://drupal.org/project/filefield_sources).  
Pierwszy z nich całkiem porządnie generuje pokazy slajdów i klasyczne galerie typu Lightbox (wyskakujące nad treść artykułu). Poza obrazkami akceptuje filmy. Oferuje sporo możliwość konfiguracji (m.in. pełen dostęp do skórki bez konieczności modyfikowania CSS). Jego sporą zaletą jest ładowanie obrazków z wyprzedzeniem - na wolnych łączach nie widać dużych opóźnień. Aby go włączyć należy zedytować interesujący nas typ treści (_content type_), np. artykuł z menu Struktura. Aby dokonać zmiany sposobu wyświetlania plików trzeba zmodyfikować sposób wyśiwetlania pola _Images_. Tam też, jeśli tego wcześniej nie zrobiliśmy, trzeba ustawić maksymalną dopuszczalną liczbę plików - najlepiej na nieskończoność, zamiast domyślnego - 1.  
FileField Sources to wyższy poziom umieszczania zdjęć - można je klasycznie wrzucać przez uploadowanie w locie, ale także wklejać zewnętrzne URLe (pliki są rzecz jasna ściągane na nasz serwer by uniknąć wpadki po awarii serwera hostującego), wybrać plik z już umieszczonych (bazujac na jego nazwie - jest wyszukiwarka) oraz... wklejać je ze schowka (działa pod Chrome'm i Firefoxem). Przydatny jest też kolejny plugin - http://drupal.org/project/filefield\_sources\_plupload, który z kolei umożliwia wgrywanie wielu zdjęć na raz (praktyczne przy zrzucaniu fotorelacji itp.). Moduł aktywujemy w tym samym miejscu co YOX view, ale wybierając edycję kontrolki.

Problemy jakich wiele przy wielu zależnościach wymaganych przez te pakiety są zbyt duże by je tu opisać - rozwiązania opisane są głównie na stronie Drupala. W gruncie rzeczy należy pamiętać o umieszczeniu rozszerzeń i ich bibliotek w 

<pre>/sites/all/libraries</pre>

(niezbędny moduł Libraries API - http://drupal.org/project/libraries) - są zawsze do pobrania od developera /producenta ze strony zlinkowanej w opisie modułu ładującego je (na stronie drupal.org).