---
title: Naprawa aktywnego huba USB i rzecz o narzędziach diagnostycznych zasilania po USB (wraz z dygresją o samym zasilaniu USB i trybach ładowania)
author: Daniel Skowroński
type: post
date: 2021-02-07T20:09:16+00:00
excerpt: 'Aktywny hub USB od D-linka model DUB-H7 to leciwa, ale bardzo mocna konstrukcja - zwłaszcza, jeśli chodzi o wykorzystanie jej w roli aż 7-portowej ładowarki. Niestety obydwa porty oznaczone symbolem pioruna, a więc te, które powinny dostarczać większy prąd jakiś czas temu przestały działać. Chcąc przywrócić sprzęt do świetności, musiałem zanurkować trochę w odmętach rosyjskojęzycznych forów internetowych i dość długo czekać na elementy zastępcze z Chin. Jednakże dzięki temu może powstać ten artykuł, który dodatkowo opowie o wykorzystywanych przeze mnie narzędziach diagnostycznych zasilania po USB, a także o samym zasilaniu USB i trybach ładowania.'
url: /2021/02/naprawa-aktywnego-huba-usb-i-rzecz-o-narzedziach-diagnostycznych-zasilania-po-usb-wraz-z-dygresja-o-samym-zasilaniu-usb-i-trybach-ladowania/
featured_image: https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary.jpg
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1

---
Aktywny hub USB od D-linka model `DUB-H7` to leciwa, ale bardzo mocna konstrukcja - zwłaszcza, jeśli chodzi o wykorzystanie jej w roli aż 7-portowej ładowarki. Niestety obydwa porty oznaczone symbolem pioruna, a więc te, które powinny dostarczać większy prąd jakiś czas temu przestały działać. Chcąc przywrócić sprzęt do świetności, musiałem zanurkować trochę w odmętach rosyjskojęzycznych forów internetowych i dość długo czekać na elementy zastępcze z Chin. Jednakże dzięki temu może powstać ten artykuł, który dodatkowo opowie o wykorzystywanych przeze mnie narzędziach diagnostycznych zasilania po USB, a także o samym zasilaniu USB i trybach ładowania.

## Zasilanie po USB - krótki wstęp do trybów

Zasilanie, czy też ładowanie za pomocą interfejsu USB to bardzo obszerny temat. Pominę tutaj Power Delivery, czyli rozszerzenie standardu USB 3.0, które pozwala na ładowanie dużych laptopów w rodzaju MacBooka Pro - skupię się jedynie na tym, co można znaleźć na typowym złączu USB-A 2.0

Ogólnie rzecz biorąc interfejs USB 2.0 to dwie linie danych (D+ i D-) oraz dwie linie zasilania o napięciu nominalnym 5 V. Już to napięcie jest problematyczne, ponieważ nie ma standardu określającego dopuszczalne odchyły, najczęściej jednak zakres bezpiecznego napięcia to od 4.5 V do 5.2 V. Domyślnie hosty USB w wersji 2.0 (czyli urządzenia, do których podłączamy inne urządzania podrzędne) dostarczają maksymalnie 500 mA (poprzednie wersje - 100 mA). 

Aby urządzenie mogło pobierać większy prąd, musi wynegocjować z hostem maksymalne natężenie. Pierwszą iteracją protokołu "szybszego" ładowania był _Dedicated Charging Port_ (DCP) - zwykle z gniazdem w innym kolorze niż reszta złączy USB, na przykład w ThinkPadach, a później ogólnie Lenovo jest to port w kolorze żółtym (który ponadto może być aktywny także, kiedy laptop jest wyłączony). Porty takie mają zwarte linie danych i dostarczają do 1.5 A. 

Wyższe prądy, a także czasem inne niż 5 V napięcia dostępne są przy pomocy innych protokołów szybkiego ładowania. Najpopularniejsze z nich to stworzony przez Apple 2.1 A (zwany czasem "ładowarką do iPada", gdyż dostarczane z iPadami korzystają z tego trybu w przeciwieństwie do jednoamperowych ładowarek, które można znaleźć w pudełkach iPhonów, mimo iż iPhony chętnie korzystają z trybu Apple 2.1 A), Samsung Adaptive Fast Charging (AFP) i seria QuickCharge od firmy Qualcomm. 

W większości wypadków deklaracja dostępnego trybu zasilania ze strony ładowarki, czy urządzenia hosta polega na ustawieniu odpowiednich napięć na liniach danych. Przykładowo poniżej schemat potrzebny do uzyskania trybu Apple 2.1 A - napięcia to odpowiednio `D-: 2.0V` i `D+: 2.75V`<figure class="wp-block-image size-large is-resized">

[<img decoding="async" loading="lazy" src="https://blog.dsinf.net/wp-content/uploads/2021/02/x5tSD.gif" alt="" class="wp-image-2141" width="-431" height="-708" />][1]<figcaption>Źródło: https://electronics.stackexchange.com/a/177792</figcaption></figure> 

Jak widać - temat jest dość szeroki. Zazwyczaj, jeśli ładowarka ma dwa lub więcej portów USB z różnymi oznaczeniami, np. "1 A" i "2 A" to oba porty mogą dostarczyć 2 A, często są one wręcz połączone równolegle - jedynie konfiguracja linii danych jest różna. Czemu zatem nie oznaczyć obu portów jako "2 A"? Otóż nie wszystkie urządzenia "zrozumieją" inne tryby zasilania i mogą uznać, że port dostarczy maksymalnie 500 mA, co znacznie ograniczy czas ładowania. Rzecz jasna co nowocześniejsze ładowarki, czy power banki nie mają dyskretnych zworek lub dzielników napięć, lecz dedykowane układy scalone dokonujące negocjacji z ładowanym urządzeniem ustalając najwyższy możliwy prąd ładowania. 

Warto dodać, że nic nie stoi na przeszkodzie z portu oznaczonego "2 A" pobierać 3 A, jeśli tylko ładowarka fizycznie tyle jest w stanie dostarczyć. Nic też nie zabroni nam "zażądać" niemal nieskończonego prądu po prostu zwierając linie zasilania, lecz wtedy w najlepszym wypadku zasilanie zostanie odcięte przez wbudowane zabezpieczenie prądowe 🙂 

## Diagnostyka ładowarek USB - narzędzia

Aby zdiagnozować ładowarkę potrzeba będzie przynajmniej miernika napięcia i natężenia prądu oraz jakiegoś obciążenia dla portu, by zbadać jego zdolność prądową. O ile część pomiarową można zaimprowizować z multimetru i złącz USB, to prościej i wygodnie wyposażyć się w dedykowany miernik - zwłaszcza że za kilka dolarów więcej możemy uzyskać urządzenie wykrywające tryb ładowania bardziej inteligentnej ładowarki oraz komplet złączy. 

Obciążeniem dla portu może być dowolne urządzenie, ale te zwykle bywają kapryśne - telefony nie zawsze i nie przez cały czas chcą pobierać pełen prąd (zwłaszcza pod koniec ładowania), a mogą także odmówić ładowania, jeśli napięcie będzie niestabilne. Najprostszą opcją jest użycie rezystora o mocy kilku watów, ale po pierwsze nie jest to rozwiązanie wygodnie regulowane, po drugie dość niedokładne i po trzecie nie obsługuje różnych trybów ładowania - warto wyposażyć się więc w regulowane elektroniczne obciążenie - najlepiej z sensownym radiatorem i wentylatorem dla większych mocy.

### Regulowane obciążenie elektroniczne

Mój wybór padł na HD35 - na AliExpress można znaleźć za około $10-$12. Sprzęt generuje maksymalnie 35 W obciążenia, prąd 5 A i współpracuje ze znaczną większością popularnych trybów szybkiego ładowania. Ponadto ma aktywnie sterowany wentylator, regulację prądu co 10 mA, zestaw ustawień (chociażby tak ważne, jak automatyczne załączanie obciążenia po pojawieniu się zasilania) i ręczne wyzwalanie negocjacji trybów QuickCharge. Podłączymy go do złącza USB-A, USB-C i microUSB. Instrukcja wraz ze specyfikacją jest dostępna między innymi na <https://needful.co.ua/image/catalog/product/rd-hd35/HD25-35-USB-load-user-manual.pdf><figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="473" src="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00-1024x473.png" alt="" class="wp-image-2144" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00-1024x473.png 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00-300x138.png 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00-768x355.png 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00.png 1460w" sizes="(max-width: 1024px) 100vw, 1024px" />][2]</figure> 



### Miernik USB

Mając na wyposażeniu dość prosty miernik "CHARGER Doctor", a kupiwszy solidne obciążenie elektroniczne, uznałem, że czas na upgrade - również do wysokiego poziomu i kupiłem UM34C. Poza pomiarem napięcia pomiędzy 4 V a 24 V i prądu do 4 A wyróżnia go też pomiar napięcia na liniach danych oraz oczywiście detekcja trybów ładowania na tej podstawie. Posiada też możliwość pomiaru temperatury oraz zliczania energii - np. by zbadać pojemność ładowanej baterii. Wszystkie pomiary można transmitować po Bluetooth do telefonu z Androidem lub iOS, a następnie eksportować do Excela, by później przeanalizować charakterystykę ładowania. Cena - około $18 na AliExpress. Instrukcja wraz ze specyfikacją - <https://supereyes.ru/img/instructions/Instruction_UM34(C).pdf> <figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="911" height="398" src="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.20.51.png" alt="" class="wp-image-2145" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.20.51.png 911w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.20.51-300x131.png 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.20.51-768x336.png 768w" sizes="(max-width: 911px) 100vw, 911px" />][3]</figure> 

## Naprawa huba USB

Objawem awarii huba był całkowity brak napięcia na obydwu portach o wyższym prądzie ładowania. Pozostałe pięć działało dobrze, deklarując tryb DCP 1.5 A, a dostarczając aż 3 A (tyle ma zasilacz samego huba, więc uznałem, że więcej pobierać nie będę). 

### Co kryje wnętrze

Czas było więc odkryć, jak mawia pewien Szary Jeleń - "co kryje wnętrze".<figure class="is-layout-flex wp-block-gallery-37 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa.jpg"><img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-1024x768.jpg" alt="" data-id="2147" data-full-url="https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa.jpg" data-link="https://blog.dsinf.net/?attachment_id=2147" class="wp-image-2147" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-768x576.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-1536x1152.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/01_obudowa-2048x1536.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka.jpg"><img decoding="async" loading="lazy" width="1024" height="766" src="https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-1024x766.jpg" alt="" data-id="2148" data-full-url="https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka.jpg" data-link="https://blog.dsinf.net/?attachment_id=2148" class="wp-image-2148" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-1024x766.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-300x224.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-768x574.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-1536x1148.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/02_plytka-2048x1531.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
</ul></figure> 

Problem okazał się dość szybki do zlokalizowania po naocznym przejrzeniu płytki komponent po komponencie - dwa tranzystory `Q31` i `Q32` eksplodowały.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-1024x768.jpg" alt="" class="wp-image-2150" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-768x576.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-1536x1152.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory-2048x1536.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][4]</figure> 

Można zaryzykować zatem twierdzenie, że wystarczy je wymienić i sprzęt powinien działać. Problem polegał na tym, że eksplozja zniszczyła oznaczenia komponentów, a dość prawdopodobne jest, że to jedyne takie dwa tranzystory przełączające porty wysokoprądowe.

### Poszukiwania tranzystorów

Rzecz jasna D-Link nie udostępnia schematów swoich płytek drukowanych wraz z listą materiałów. Nie warto też było ryzykować używania komponentów z bardzo odległych rewizji tego samego modelu, D-Link bowiem ma zwyczaj korzystania z różnych konstrukcji pod tym samym modelem, różniącym się jedynie jedną literką wersji.

Po długich poszukiwaniach udało mi się zlokalizować identyczny problem pewnego użytkownika rosyjskojęzycznego forum elektronicznego - <https://www.rlocman.ru/forum/showthread.php?t=15481>, a znalazł się tam też inny posiadacz tego samego huba, ale bez zniszczonych nadruków i po dziwnym oznaczeniu `S0120` udało się dojść do właściwego modelu - `SI2023`. 

Chcąc uniknąć eksperymentów oraz inżynierii wstecznej postanowiłem poszukać dokładnie tego komponentu, nie zaś zamienników o nieco innych parametrach. W Polsce nie udało mi się nigdzie znaleźć wspomnianego tranzystora (także na TME), nie słyszał o nim DigiKey, na pomoc przyszły dopiero Chiny pod postacią AliExpressu. Oczywiście nikt nie oferował akurat sensownej wysyłki, czekałem więc 3 miesiące, zamówiłem dwie paczki znudziwszy się czekaniem na pierwszą... Finalnie za pierwsze dwa dolary mam 100 sztuk, a za kolejne dwa dolary - cztery sztuki od innego sprzedawcy. 

### Naprawa i weryfikacja

Zdjęcie poniżej jest dość drastyczne dla elektroników z doświadczeniem - kompletnie nie umiem lutować elementów SDM ;\___;

Najważniejszy jednak jest fakt, że mimo urwania padu udało mi się wlutować oba tranzystory oraz naprawić uszkodzoną ścieżkę od `Q32` do `Q34` solidnym kawałkiem cyny. <figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-1024x768.jpg" alt="" class="wp-image-2151" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-768x576.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-1536x1152.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie-2048x1536.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][5]</figure> 

Weryfikacja pobiegała pomyślnie - wszystkie porty działają, a te "szybsze" używają trybu Apple 2.1 A<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="858" src="https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-1024x858.jpg" alt="" class="wp-image-2152" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-1024x858.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-300x251.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-768x644.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-1536x1287.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary-2048x1716.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][6]</figure> 

## Podsumowanie

Naprawa udana, pacjent nie zmarł, pożaru nie było. 

Koszt (poza zapleczem elektronika-bardzo-amatora lubiącego kupować sprzęt nieco na wyrost) - $6 z wysyłką obu paczek tranzystorów i kilka miesięcy przeleżenia na stercie projektów do realizacji.

Lekcje wyniesione: nie umiem lutować elementów powierzchniowych i muszę to poprawić, ładowanie po USB jest ciekawe, a cyrylica przydaje się inżynierom wielu dziedzin.

 [1]: https://blog.dsinf.net/wp-content/uploads/2021/02/x5tSD.gif
 [2]: https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.06.00.png
 [3]: https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-20.20.51.png
 [4]: https://blog.dsinf.net/wp-content/uploads/2021/02/03_uszkodzone_tranzystory.jpg
 [5]: https://blog.dsinf.net/wp-content/uploads/2021/02/04_lutowanie.jpg
 [6]: https://blog.dsinf.net/wp-content/uploads/2021/02/05_pomiary.jpg