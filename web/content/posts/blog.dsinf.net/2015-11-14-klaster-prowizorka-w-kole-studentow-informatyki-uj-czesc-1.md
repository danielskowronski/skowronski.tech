---
title: Klaster-prowizorka w Kole Studentów Informatyki UJ -część 1
author: Daniel Skowroński
type: post
date: 2015-11-14T00:59:37+00:00
url: /2015/11/klaster-prowizorka-w-kole-studentow-informatyki-uj-czesc-1/
tags:
  - hardware
  - klaster
  - ksi

---
Kiedy mój współadministrator z serwerowni Kola Studentów Informatyki UJ znalazł informację, że nasz wydział pozbywa się starych bezdyskowych maszyn i jakoś nikt ich nie chce od razu wkroczylismy do akcji i dzięki dobrym stosunkom z administratorami wydziałowymi dostaliśmy aż 30 maszyn. Projekt jaki wymyśliliśmy jest śmiały &#8211; klaster obliczeniowy, ale my nie damy rady? Konfiguracja nie powala, ale do celów edukacyjnych to aż nadto: AMD Athlon X2 5200+ (2 rdzenie @3GHz), 4GB RAM, płyta Gigabyte&#8217;a, nvidiowy Gigabit Ethernet. Procesory z tej serii co mają zepsuty czujnik temperatury, ale ujdą.

Pierwszym etapem było wybranie liczby maszyn do użycia. Bardzo prostym ogranicznikiem okazała się liczba portów w switchach gigabitowych, które można było tanio znaleźć na allegro &#8211; 24 (-1 port na podpięcie się do świata). Skoro o sieci to opowiem jaka na ten moment jest planowana topologia &#8211; 23 maszyny wpięte do switcha, na nieco mocniejszym komputerze nazwanym roboczo &#8222;klaster-master&#8221; (podobny mobo Gigabyte, nieco inny model CPU ale ta sama seria i 8GB RAM) z dwoma interfejsami sieciowymi &#8211; jeden robiący sieć wirtualną dla klastra, drugi wpięty do naszego głównego switcha do sieci wydziałowej.

<figure id="attachment_804" aria-describedby="caption-attachment-804" style="width: 568px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class=" wp-image-804" src="http://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a.jpg" alt="Gigabitowy switch D-Link DGS 1024D znaleziony okazyjnie na Allegro" width="568" height="568" srcset="https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a.jpg 1017w, https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a-150x150.jpg 150w, https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a-300x300.jpg 300w, https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a-144x144.jpg 144w, https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a-660x660.jpg 660w, https://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a-900x900.jpg 900w" sizes="(max-width: 568px) 100vw, 568px" />][1]<figcaption id="caption-attachment-804" class="wp-caption-text">Gigabitowy switch D-Link DGS 1024D znaleziony okazyjnie na Allegro</figcaption></figure>

Zasilanie okazało się ciekawym wyzwaniem ponieważ wiele osób wątpiło w to czy nasza serwerownia, która pierwotnie była salą komputerową wytrzyma takie obciążenie (regularnie pracuje tam &#8222;większe kilka&#8221; solidnych maszyn). Prosty eksperyment został wykonany &#8211; zmierzona maksymalna moc pobierana przez docelowy komputer na pełnym obciążeniu CPU to 120W, zaokrąglamy w górę do 150W. 24*150W = 4kW zaokraglając jeszcze bardziej w górę. Czyli tyle co dwa czajniki elektryczne jakie mamy w samym Kole. A więc jednocześnie wpięliśmy dwa takowe do tego samego kanału w podłodze i odpaliliśmy równolegle. Zagotowały wodę i jakoś nic nie wybuchło. I tak nie planujemy mieć tych 24 jednostek włączonych 24/7 tylko wybudzać je w razie potrzeby przez wake-on-lan.

Zakupy jakie musieliśmy zrobić do tej pory to: wspomniany switch D-Linka (80zł), 3 przedłużacze po 8 gniazd (Acar S8 &#8211; 30zł sztuka), skrętka (około 50m &#8211; 50gr/m) i wtyki RJ45 (20zł/100szt).

Mając 24 maszyny w estetycznej piramidce (ten układ okazał się najbardziej stabilny bez stosowania dodatkowych stelaży) trzeba je przejrzeć, sprawdzić czy działają, spisać adresy MAC i oznakować. Czyli iterując się po każdym komputerze: wpiąć zasilanie, klawiaturę, monitor i sprawdzać i spisywać. Ale komu by się chciało to robić ręcznie. W tym celu przygotowałem Knoppixa na pendrivie na którego wgrałem dodatkowy skrypt, który na starcie pyta użytkownika o ID komputera &#8211; wtedy wybieramy numer kolejny i markerem znakujemy jednostkę, skrypt następnie tworzy plik o takiej nazwie, zapisuje w nim adres MAC i inne szczegóły maszyny (powinny być takie same, ale kto wie &#8211; warto zweryfikować) + odczyty temperatur, a następnie odpala w tle skrypt zajeżdżający CPU sam zapisując co 5 sekund licznik czasu do pliku &#8211; wówczas jeśli komputrer niespodziewanie się wyłączy to będzie można odczytać ile wytrzymał. Oczywiście po 5 minutach warto to ręcznie przerwac bo już wiadomo że nie jest to ekstremalnie uszkodzony układ. Tak zebrane czasy można wykorzystać do posortowania maszyn i zostawienia w klastrze najlepszych.

<figure id="attachment_807" aria-describedby="caption-attachment-807" style="width: 689px" class="wp-caption alignnone">[<img decoding="async" loading="lazy" class=" wp-image-807" src="http://blog.dsinf.net/wp-content/uploads/3015/11/wieza.png" alt="Estetyczna wieża z komputerów - najsolidniejsza forma ustawienia" width="689" height="1093" srcset="https://blog.dsinf.net/wp-content/uploads/3015/11/wieza.png 1376w, https://blog.dsinf.net/wp-content/uploads/3015/11/wieza-189x300.png 189w, https://blog.dsinf.net/wp-content/uploads/3015/11/wieza-645x1024.png 645w, https://blog.dsinf.net/wp-content/uploads/3015/11/wieza-660x1048.png 660w, https://blog.dsinf.net/wp-content/uploads/3015/11/wieza-900x1428.png 900w" sizes="(max-width: 689px) 100vw, 689px" />][2]<figcaption id="caption-attachment-807" class="wp-caption-text">Estetyczna wieża z komputerów &#8211; najsolidniejsza forma ustawienia</figcaption></figure>

Proces czasochłonny, ale nie ma innej opcji. Zarabianie kabli zajmie podobną ilość czasu.

W kolejnym odcinku opiszę konfigurację klaster-master&#8217;a i systemów bootwanych po sieci.

Zapraszam także na [stronę Koła Studnetów Informatyki UJ][3].

 [1]: http://blog.dsinf.net/wp-content/uploads/3015/11/InstagramCapture_58ab547d-16a2-468f-a851-65d12fd3109a.jpg
 [2]: http://blog.dsinf.net/wp-content/uploads/3015/11/wieza.png
 [3]: http://ksi.ii.uj.edu.pl/