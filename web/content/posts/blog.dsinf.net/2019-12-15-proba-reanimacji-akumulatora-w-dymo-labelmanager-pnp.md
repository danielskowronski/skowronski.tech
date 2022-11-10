---
title: Próba reanimacji akumulatora w Dymo LabelManager PnP
author: Daniel Skowroński
type: post
date: 2019-12-15T13:28:03+00:00
excerpt: 'Dymo LabelManager PnP to dość zgrabna i tania drukarka etykiet na taśmach o szerokości do pół cala, a więc znalazła się i na moim biurku do etykietowania pojemników z elektroniką, podpisywania kabli czy puszek z herbatą (stworzyłem nawet generator etykiet na puszki - DymoTeaLabel). Jest z nią jednak pewien problem - akumulator. W tym artykule opiszę diagnozę problemu, próbę naprawy, odkrycie powszechności problemu i jego hackerskie obejście.'
url: /2019/12/proba-reanimacji-akumulatora-w-dymo-labelmanager-pnp/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2.jpg
tags:
  - dymo
  - hardware

---
Dymo LabelManager PnP to dość zgrabna i tania drukarka etykiet na taśmach o szerokości do pół cala, a więc znalazła się i na moim biurku do etykietowania pojemników z elektroniką, podpisywania kabli czy puszek z herbatą (stworzyłem nawet generator etykiet na puszki &#8211; [DymoTeaLabel][1]). Jest z nią jednak pewien problem &#8211; akumulator. W tym artykule opiszę diagnozę problemu, próbę naprawy, odkrycie powszechności problemu i jego hackerskie obejście.

<div class="wp-block-image">
  <figure class="aligncenter size-large is-resized"><a href="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1.jpg"><img decoding="async" loading="lazy" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1-935x1024.jpg" alt="" class="wp-image-1627" width="349" height="382" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1-935x1024.jpg 935w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1-274x300.jpg 274w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1-768x841.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-22-18.49.26_2-1.jpg 1841w" sizes="(max-width: 349px) 100vw, 349px" /></a><figcaption>Bohater artykułu wraz z lekkim spoilerem</figcaption></figure>
</div>

#### Diagnoza i plan reanimacji

Akumulator po okresie względnie losowego używania (urządzenie nie było cały czas podłączone do komputera) w pewnym momencie zaczął słabnąć co objawiało się komunikatem _Not charging. Battery level low._ i odmową drukowania.

Model pracy drukarki jest dość specyficzny gdyż kompensowany fakt, że niektóre komputery i laptopy zgodnie ze specyfikacją USB dostarczają max 500mA, co jest zbyt małym prądem do druku termotransferowego i poruszania napędu. Akumulator jest zatem buforem. Dodatkowo łatwo producentowi rozszerzyć urządzenie o tryb bezprzewodowej pracy (gdzie akumulator jest niezbędny). 

Urządzenie niestety odmawia pracy bez akumulatora, który znamionowo ma 7.4V 650mAh i jest typu typ Li-Ion &#8211; nawet gdy podłączone jest do portu USB dostarczającego 2A.

Zacząłem od pomiaru akumulatora wyjętego z obwodu &#8211; wskazywał około 7.5V co jest OK, lecz po chwili pracy napięcie spadało niemal do zera.

Kolejnym krokiem był demontaż całego urządzenia w poszukiwaniu potencjalnie uszkodzonych komponentów, ale wizualnie i zapachowo wszystko się zgadzało, sekcja ładowania także trzymała parametry, a sam układ dawał około 8.5V na zaciskach baterii &#8211; także wszystko w normie.

Cena nowego akumulatora to około 70zł &#8211; zasugerowało mi to potrzebę zakupu 4 razy droższego zasilacza laboratoryjnego (bo jeszcze takowego nie posiadałem) i podjęcie próby reanimacji 😉

Reanimacja zakładała naładowanie &#8222;ręczne&#8221; akumulatora które powinno spowodować, że ładowarka w drukarce uzna iż ten jest wystarczająco sprawny, a nie martwy ze względu na charakterystykę napięcia pod obciążeniem.

#### Mój lab na potrzeby reanimacji

  * regulowany zasilacz laboratoryjny dający do 10V 1A, ja do tego celu nabyłem [Zhaoxin TRK-325D][2] (0-32V, 0-5A) bowiem urzekł mnie sposobem sterowania wartościami prądu i napięcia
  * multimetr &#8211; żeby wygodniej badać zmiany w czasie warto żeby miał interfejs szeregowy albo USB &#8211; na przykład [UNI-T UT61C][3]
  * trochę przewodów do multimetru w tym z aligatorkami, w moim wypadku:
      * banan-banan z dodatkowymi gniazdami na wtykach ([UNI-T UT-L10][4]) &#8211; łączące zasilacz z multimetrem
      * banany-aligatorki łączące multimetr ze złączami drukarki etykiet 
      * banany-aligatorki łączące zasilacz z akumulatorem
      * przydały się jeszcze tymczasowo dolutowane kable do samego akumulatora gdyż żadne aligatorki nie były w stanie stabilnie złapać jego złączy<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-16-23.48.02-1024x768.jpg" alt="" class="wp-image-1621" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-16-23.48.02-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-16-23.48.02-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-16-23.48.02-768x576.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][5]</figure> 

#### Wstępne ładowanie

Powoli zwiększając napięcie ładowania z 7.4V do 8.5V (od znamionowego do zmierzonego jako to, którym próbuje ładować drukarka) i stosując limit prądu na 100mA ładowałem akumulator około 4-5h. 

Napięcie zwiększałem gdy prąd płynący przez akumulator spadał (max 40mA, min 4mA).

Następnie podłączyłem akumulator do drukarki etykiet i monitorowałem co wskaże oprogramowanie &#8211; firmware uznał że są 2 z 3 kresek, ale nie ładuje akumulatora. Całość pozostawiłem na noc (około 10 godzin). Efektów niestety brak, pomiar po odciążeniu na kilka minut: 7.4V

#### Drugie ładowanie

  1. Przez około godzinę: 8.2V, pobór prądu średnio 130mA, limitowany do 150mA
  2. Przez około godzinę: 8.4V, pobór prąd średnio 100mA
  3. Przez około godzinę: 8.6V , pobór prądu średnio 120mA
  4. Przez kilkanaście minut: Spadek poboru prądu do około 50mA utrzymujący się przy zwiększeniu napięcia 8.7V
  5. Na dwóch różnych komputerach &#8222;ładowanie nie odbywa się&#8221; 

Przy okazji zbadałem napięcia wedle których software zwraca ilość &#8222;kresek&#8221; baterii.<figure class="wp-block-table">

<table class="">
  <tr>
    <td>
      Napięcie
    </td>
    
    <td>
      <5.2V
    </td>
    
    <td>
      5.2V-6.1V
    </td>
    
    <td>
      6.1V-8.6V
    </td>
    
    <td>
      >8.6V
    </td>
  </tr>
  
  <tr>
    <td>
      Ilość &#8222;kresek&#8221;
    </td>
    
    <td>
    </td>
    
    <td>
      1
    </td>
    
    <td>
      2
    </td>
    
    <td>
      3
    </td>
  </tr>
</table></figure> 

#### Review na amazonie

Po eweidentnym braku sukcesu postanowiłem sprawdzić czy tylko ja mam taki problem. Otóż okazuje się że nie bardzo, poniżej kilka co ciekawszych review z amazona:

  * [https://www.amazon.com/gp/customer-reviews/R1X9IT256W0NOL/ref=cm\_cr\_arp\_d\_rvw_ttl?ie=UTF8&ASIN=B00464E5P2][6]
  * [https://www.amazon.com/gp/customer-reviews/R3NJJ4COCTB1LO/ref=cm\_cr\_arp\_d\_rvw_ttl?ie=UTF8&ASIN=B00464E5P2][7]
  * [https://www.amazon.com/gp/customer-reviews/R37WZ32UO8Y5U5/ref=cm\_cr\_getr\_d\_rvw_ttl?ie=UTF8&ASIN=B00464E5P2][8] &#8211; tutaj autor zrealizował zasilacz sieciowy
  * [https://www.amazon.com/gp/customer-reviews/R5D4P9BEXZVKH/ref=cm\_cr\_arp\_d\_rvw_ttl?ie=UTF8&ASIN=B00464E5P2][9] &#8211; ten z kolei hackersko wlutował gniazdo baterii 9V 

#### Co kryje wnętrze akumulatora i celowe postarzanie

Może nieco w tonie teorii spiskowej o celowym postarzaniu sprzętu postanowiłem sprawdzić co znajduje się w akumulatorze &#8211; może jakiś podejrzanie wyglądający kondensator&#8230;<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="713" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-22.04.06-1024x713.jpg" alt="" class="wp-image-1622" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-22.04.06-1024x713.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-22.04.06-300x209.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-22.04.06-768x535.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][10]<figcaption>Całość trzeba było zacząć od rozładowania baterii żeby uniknąć przypadkowego wybuchu</figcaption></figure> <figure class="wp-block-image size-large"><img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.54.25-1024x768.jpg" alt="" class="wp-image-1625" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.54.25-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.54.25-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.54.25-768x576.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" /><figcaption>Tuż po otwarciu plastikowej obudowy</figcaption></figure> <figure class="wp-block-image size-large">[<img decoding="async" loading="lazy" width="1024" height="392" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.56.25-1024x392.jpg" alt="" class="wp-image-1623" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.56.25-1024x392.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.56.25-300x115.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.56.25-768x294.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][11]<figcaption>Wewnątrz pakietu ogniw owiniętego limonkową taśmą znajduje się tylko ta płytka</figcaption></figure> <figure class="wp-block-image size-large">[<img decoding="async" loading="lazy" width="1024" height="410" src="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.57.31-1024x410.jpg" alt="" class="wp-image-1624" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.57.31-1024x410.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.57.31-300x120.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.57.31-768x308.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][12]<figcaption>Druga strona poprzedniej płytki z terminalami ogniw i całego pakietu</figcaption></figure> 

Płytka podłączona do ogniw 3.7V jest opisana jako **SP-PCM-0025** to wedle tego co udało mi się znaleźć na [starej aukcji z allegro][13] &#8211; układ zabezpieczający i balansujący ładowanie/rozładowanie ogniw, czyli coś czego by się można było spodziewać.

Są na niej dwa scalaki &#8211; dwukanałowy tranzystor MOSFET **D2017A** (<http://m.dzsc.com/product/915939-2018119113831455.html>) i dwukanałowy wzmacniacz operacyjny **PADK** (<http://www.ti.com/lit/pdf/slos475>).

Wszystkie elementy pasywne trzymały parametry więc to chyba rzeczywiście zużycie samych ogniw &#8211; co nie zmienia faktu że ich obowiązkowa obecność wygląda mocno na próbę ustawienia limitu życia dla bardziej konsumenckiego produktu od Dymo.

#### Obejście i zakończenie historii

**Problem można obejść montując zwykłą baterię 9V (6LR61).** 

Tolerancja napięć jest naprawdę duża jeśli tylko są wyższe, a nie niższe, montaż łatwy (wystarczy złożona kilka razy karta papieru żeby bateria się trzymała), a można też hack sprzętowy ulepszyć stosując akumulator zamiast baterii (choć mało kto posiada tak egzotyczne akumulatorki i ładowarki do nich).

Cała historia skończyła się wystawieniem na aukcji starego urządzenia i zakupem bardziej profesjonalnego &#8211; **LabelWriter 4500 Duo**, które póki co mogę polecić gdyż poza drukarką etykiet na taśmie aż do 1 cala ma też drukarkę zwykłych etykiet w formie naklejek aż do 59x190mm. No i zasilanie sieciowe bez żadnych akumulatorków.

 [1]: https://github.com/danielskowronski/DymoTeaLabel
 [2]: https://www.gotronik.pl/trk-325d-zasilacz-laboratoryjny-0-32-00v-0-5-000a-p-4255.html
 [3]: https://www.uni-t.cz/en/p/multimeter-uni-t-ut-61c
 [4]: https://www.aliexpress.com/i/32827231119.html
 [5]: https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-16-23.48.02.jpg
 [6]: https://www.amazon.com/gp/customer-reviews/R1X9IT256W0NOL/ref=cm_cr_arp_d_rvw_ttl?ie=UTF8&ASIN=B00464E5P2
 [7]: https://www.amazon.com/gp/customer-reviews/R3NJJ4COCTB1LO/ref=cm_cr_arp_d_rvw_ttl?ie=UTF8&ASIN=B00464E5P2
 [8]: https://www.amazon.com/gp/customer-reviews/R37WZ32UO8Y5U5/ref=cm_cr_getr_d_rvw_ttl?ie=UTF8&ASIN=B00464E5P2
 [9]: https://www.amazon.com/gp/customer-reviews/R5D4P9BEXZVKH/ref=cm_cr_arp_d_rvw_ttl?ie=UTF8&ASIN=B00464E5P2
 [10]: https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-22.04.06.jpg
 [11]: https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.56.25.jpg
 [12]: https://blog.dsinf.net/wp-content/uploads/2019/12/2019-11-18-21.57.31.jpg
 [13]: https://allegro.pl/oferta/2s-7-4v-8-4v-10a-pcb-bms-pcm-do-ogniw-li-ion-1szt-7018583908