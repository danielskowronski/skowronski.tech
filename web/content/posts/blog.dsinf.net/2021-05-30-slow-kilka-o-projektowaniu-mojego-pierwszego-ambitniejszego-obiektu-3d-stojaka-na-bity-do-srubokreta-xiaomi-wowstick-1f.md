---
title: Słów kilka o projektowaniu mojego pierwszego ambitniejszego obiektu 3D – stojaka na bity do śrubokręta Xiaomi Wowstick 1F
author: Daniel Skowroński
type: post
date: 2021-05-29T22:03:02+00:00
url: /2021/05/slow-kilka-o-projektowaniu-mojego-pierwszego-ambitniejszego-obiektu-3d-stojaka-na-bity-do-srubokreta-xiaomi-wowstick-1f/
featured_image: /wp-content/uploads/2021/05/XWH_0-scaled.jpg
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1
tags:
  - 3d
  - hardware
  - openscad

---
 

Moja przygoda z drukiem 3D zaczęła się jeszcze na studiach, kiedy to w Kole Studentów Informatyki UJ zacząłem korzystać z drukarki SLA (Prusa i3 mk1). Stworzyłem wówczas kilka prostych obiektów w webowym Tinkercadzie. Korzystałem głównie z konwersji grafiki wektorowej na obiekty 3D poprzez prymitywnie "wyciąganie" ich, by uzyskały wysokość oraz sklejania takich elementów ze sobą. Kilka lat później kupiłem swoją drukarkę DLP (Anycubic Photon S) i stanął przede mną problem praktyczny, którego tak łatwo nie można było rozwiązać w prymitywnych narzędziach - stojak na bity do śrubokręta elektrycznego Xiaomi Wowstick 1F. Oczywiście żaden ze znalezionych w internecie projektów nie odpowiadał moim potrzebom, a generyczne stojaki czy organizery nie były zbyt dobrze dopasowane, mimo iż tytułowy śrubokręt używa standardowych 4mm bitów. Ponadto chciałem, aby bity były uporządkowane według typu - poza zamiłowaniem do porządku chciałem po prostu szybko znajdować konkretny typ, co nie jest aż tak proste, mając kilka podobnych końcówek w małym rozmiarze.

## Idea ogólna i planowanie

Pierwszym etapem projektowania była ogólna idea, którą od samego początku miałem w głowie - kształt schodkowy z przeznaczeniem do postawienia na biurku. Z mojego doświadczenia stojaki, czy bardziej etui, gdzie wszystkie bity są na tym samym poziomie, a ich końcówki widoczne jedynie z góry są mało praktyczne do wyjmowania. <figure class="is-layout-flex wp-block-gallery-43 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/bit_holder_flat.jpg">![](/wp-content/uploads/2021/05/bit_holder_flat.jpg)</a><figcaption class="blocks-gallery-item__caption">Dość popularny generyczny zestaw bitów, <br />w niepraktycznym dla mnie etui</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/Screenshot-2021-05-19-at-22.40.09.png">![](/wp-content/uploads/2021/05/Screenshot-2021-05-19-at-22.40.09.png)</a><figcaption class="blocks-gallery-item__caption">Inspiracja formy, jaką chciałem osiągnąć</figcaption></figure>
  </li>
</ul></figure> 

Kolejny etap to zbadanie potrzeb szczegółowych, czyli posortowanie bitów wedle typów, opisanie ich oraz zaprojektowanie ich przestrzennego ułożenia. Mało ambitnie użyłem w tym celu MS Excela, ale zadziałało.  
Przy okazji spędziłem nieco za dużo czasu, wędrując po stronach Wikipedii o śrubokrętach...<figure class="wp-block-image size-large">

![](/wp-content/uploads/2021/05/Screenshot-2021-05-19-at-05.56.34-300x231.png)</figure> 

Wiedząc już, co chciałbym osiągnąć, nadszedł czas, żeby znaleźć narzędzie do realizacji. Wybór padł na otwartoźródłowy program OpenSCAD (<https://openscad.org/>), który zdaje się dość popularny w środowisku hobbystycznych projektantów 3D, a także jest używany przez portal ThingVerse do personalizowania projektów poprzez ich narzędzie Customizer. Nauka podstaw nie jest trudna - wystarczy jakikolwiek zmysł geometryczny i można już szukać w internecie jak budować konkretne bloki składowe naszego projektu - za pomocą kodu. Poza tym jest cała masa tutoriali, więc szybko można poznać bardziej zaawansowane sposoby opisywania naszego obiektu 3D.

## Rozbicie na elementy składowe

Po oswojeniu się z narzędziem wydzieliłem trzy elementy składowe obiektu wymienione poniżej. Pod listą pokazuję przykładowy obiekt (używa on finalnego kodu, zmodyfikowanego do celów demonstracyjnych).

  * Prostopadłościan z wgłębieniem na bit od góry, najlepiej z miejscem na dwie litery identyfikujące rodzaj bitu od przodu (wedle planu w Excelu); stałe rozmiary; kolor żółty
  * Pełny prostopadłościan bez wgłębienia na bit umożliwiający tworzenie odstępów między różnymi typami bitów; również stałe rozmiary; kolor różowy
  * Prostopadłościan o szerokości i głębokości segmentu na bit, ale o wysokości będącej wielokrotnością wysokości segmentu na bit - znajdującego się pomiędzy segmentem na bit a podłożem; kolor zielony<figure class="wp-block-image size-large">

![](/wp-content/uploads/2021/05/xwh_elements.jpg)</figure> 

Ze względu na naturę obiektów 3D nie widać wszystkich granic między elementami składowymi. Żółtych jest co widać 10, różowych 2, a zielonych 8 (lub licząc także elementy o zerowej wysokości - 12). Te ostatnie występują w czwórkach: dwu-, jedno- i zerowo- krotnie wysokich względem obiektów żółtych i różowych.

Mając wizję całości, czas było przystąpić do tworzenia kodu opisującego elementy składowe. Dla uproszczenia będę nazywał elementy kolorami z wizualizacji idei ogólnej w poprzednim akapicie. Elementy różowe i zielone to po prostu prostopadłościany (sześciany foremne przekształcone parametrami funkcji `cube()`).

Zasadnicze wyzwanie to elementy żółte, czyli te, które mają trzymać pojedynczy bit i mieć wytłoczone oznaczenie. Punktem wyjścia znowu będzie `cube()`, lecz będziemy chcieli od niego "odjąć" (poprzez operację `difference()`) wgłębienie na bit i kształt liter. 

Wgłębienie na bit to graniastosłup o podstawie sześciokąta foremnego - tak jak sam bit. _Hexagon_ nie jest kształtem podstawowym, do jego generowania pozwoliłem sobie pożyczyć kod z <https://www.youtube.com/watch?v=KAKEk1falNg>, choć później znalazłem nieco inne podejście do tego tematu.

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">module fhex(wid,height){
  hull(){
    cube([wid/1.7,wid,height],center = true);

    rotate([0,0,120])
      cube([wid/1.7,wid,height],center = true);

    rotate([0,0,240])
      cube([wid/1.7,wid,height],center = true);
  }
}</pre>

Same napisy to połączenie generowanych z fontów dostępnych w systemie obiektów dwuwymiarowych przy pomocy `text()`, uwypuklania takich obiektów przez nadanie im wysokości używając `linear_extrude()`, obrotów powstałym obiektem by znajdował się na ścianie prostopadłościanu przy pomocy `rotate()` oraz finalnie pozycjonowania w przestrzeni poprzez `translate()`. 

Kod segmentu poniżej:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">module segment(txt=""){
  difference(){
    cube([$segment_width,$segment_width,$segment_height]);

    translate([$segment_width/2,$segment_width/2,$segment_height-$hole_height/2])
    fhex($hole_width,$hole_height);
   
    extrusion=1;
    translate([0,extrusion,0])
    rotate([90,0,0])
    linear_extrude(extrusion){
      divider=3.0*len(txt);
      translate([$segment_width/divider,$segment_height-$segment_width/2,0]){
        text(txt, size=$segment_width/2, font="Ubuntu Mono:style=Bold");
      }
    }
  }
}</pre>

## Składanie w całość

Cały taki element można upakować jeszcze w `module`, czyli coś na kształt funkcji i można brać się za generowanie ich docelowych instancji oraz rozmieszczanie ich w przestrzeni. 

Za rozmieszczenie przestrzenne odpowiada tablica tablic zawierających etykiety segmentów (bądź puste stringi gdzie element ma być bez otworu) - przeniesiona 1:1 z planu w Excelu.

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">$plan=[
  ["PH","PH",""  ,""  ,""  ,"PH","PH","PH","PH","PH","PH"],
  ["SL",""  ,""  ,""  ,"SL","SL","SL","SL","SL","SL","SL"],  
  ["H" ,""  ,""  ,"H" ,"H" ,"H" ,"H" ,"H" ,"H" ,"H" ,"H" ],
  ["T" ,"T" ,"T" ,"T" ,"T" ,"T" ,"T" ,"T" ,"T" ,"T" ,"T" ],
  ["TR","TR","TR","TR",""  ,""  ,"Y" ,"Y" ,"Y" ,"Y" ,"Y" ],
  ["S" ,"S" ,"S" ,""  ,""  ,""  ,""  ,""  ,"P" ,"P" ,"P" ],
  ["U" ,"U" ,"U" ,""  ,""  ,""  ,""  ,""  ,"W" ,""  ,"C" ],
];</pre>

Po całości możemy przemieszczać się pętlą `for` zagnieżdżoną w pętli `for`. Kod takiego przebiegu wraz z wyodrębnioną dla czytelności funkcją `segment_in_grid` zamieszczam poniżej, a całość oczywiście znajduje się w zalinkowanym na końcu artykułu repozytorium Githuba i na Thingverse.

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">module segment_in_grid(x,y,txt=""){
  translate([x*$segment_width, y*$segment_width, y*$segment_height]){
    if (len(txt)>0) segment(txt);                               //segment żółty
    else cube([$segment_width,$segment_width,$segment_height]); //segment różowy
  }
  translate([x*$segment_width, y*$segment_width, 0]){
    cube([$segment_width, $segment_width, y*$segment_height]);  //segment zielony
  }
}

yl=len($plan)-1;
for (y=[0:yl]){
  for (x=[0:len($plan[yl-y])-1]){
    segment_in_grid(x,y,txt=$plan[yl-y][x]);
  }
}</pre>

Zachowanie `segment_in_grid` jest takie samo w każdym wierszu, a więc na najniższym "schodku" tworzy segment zielony o wysokości 0.

## Dostrajanie parametrów

Żeby całość stojaka pasowała do rzeczywistości, wymiary elementów składowych należy odpowiednio dobrać - łącząc znane wartości z pomiarów samych bitów i ogólnego pomysłu z testowymi wydrukami, tak by uwzględnić dokładność druku oraz oczywiście z testami UX - żeby wygodnie się tego używało 🙂

Dzięki opracowanemu systemowi znakowania slotów na bity przy okazji udało mi się dość łatwo otrzymać system znakowania prototypów, by nie pogubić się, jakie mają parametry zadane (rzeczywiste jednak mogą się różnić). 

Prototypy na zdjęciach poniżej nie mają docelowej czytelności znakowania - nie zostały idealnie utwardzone ani oczyszczone, a kąpiel zaliczyły w izopropanolu wymagającym filtracji lub wręcz wymiany. Finalna wersja jest dużo ładniejsza.<figure class="is-layout-flex wp-block-gallery-45 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/IMG_3418.jpeg">![](/wp-content/uploads/2021/05/IMG_3418-300x225.jpeg)</a><figcaption class="blocks-gallery-item__caption">testowanie średnicy slotu - <code>$hole_width</code></figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/IMG_3413-scaled.jpeg">![](/wp-content/uploads/2021/05/IMG_3413-300x225.jpeg)</a><figcaption class="blocks-gallery-item__caption">testowanie głębokości slotu - <code>$hole_height</code></figcaption></figure>
  </li>
</ul></figure> <figure class="is-layout-flex wp-block-gallery-47 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/IMG_3420.jpeg">![](/wp-content/uploads/2021/05/IMG_3420-300x225.jpeg)</a><figcaption class="blocks-gallery-item__caption">różne warianty rozmiaru segmentu - <code>$segment_width</code></figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/IMG_3426.jpeg">![](/wp-content/uploads/2021/05/IMG_3426-300x225.jpeg)</a><figcaption class="blocks-gallery-item__caption">jeden z ostatnich testów - orientacja na drukarce</figcaption></figure>
  </li>
</ul></figure> 

## Zakończenie

Na sam koniec należy już tylko złożyć kod w całość, wygenerować obiekt STL i wrzucić do slicera. Do mojej drukarki DLP używam płatnej wersji LycheeSlicer (<https://mango3d.io/lychee-slicer-for-sla-3d-printers/>).<figure class="is-layout-flex wp-block-gallery-49 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/XWH_0-scaled.jpg">![](/wp-content/uploads/2021/05/XWH_0-scaled.jpg)</a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="/wp-content/uploads/2021/05/XWH_1-scaled.jpg">![](/wp-content/uploads/2021/05/XWH_1-scaled.jpg)</a></figure>
  </li>
</ul></figure> 

Obiekt, wraz z kodem źródłowym opublikowałem na Thingversie - [**https://www.thingiverse.com/thing:4859145**][3] i Githubie.

Obiekt został pozbawiony wnętrza _(hollow)_ z wypełnieniem w trybie _lattice 20%_, dodałem dwa kwadratowe otwory odpływowe na nieutwardzoną żywicę z wnętrza _(drain holes)_ z tyłu: kilka milimetrów od dołu i boków, po jednym z każdej strony. Żadne supporty nie były wymagane.<figure class="wp-block-image size-large">

![](/wp-content/uploads/2021/05/IMG_3560.jpg)<figcaption>wypełnienie i jeden z _drain holes_ widoczne pod silnym światłem (całkiem porządnej latarki Nitecore Tup)</figcaption></figure> 

Od rozpoczęcia prac do gotowego wydruku minęło kilka wieczorów kodowania, cięcia i testowania wydruków, a efekt bardzo mnie cieszy, bo stojak w 100% odpowiada moim oczekiwaniom i jeśli kiedyś będę potrzebował podobnego, ale dla innego zestawu bitów - wystarczy kilka zmian w parametrach kodu, render i obiekt będzie gotowy do wydruku. Zabawę polecam każdemu.

 [1]: /wp-content/uploads/2021/05/Screenshot-2021-05-19-at-05.56.34.png
 [2]: /wp-content/uploads/2021/05/xwh_elements.jpg
 [3]: https://www.thingiverse.com/thing:4859145
 [4]: /wp-content/uploads/2021/05/IMG_3560.jpg