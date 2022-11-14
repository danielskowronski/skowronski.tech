---
title: BedsideTableDisplay ciąg dalszy – problemy z temperaturą i obudowa
author: Daniel Skowroński
type: post
date: 2019-05-05T10:33:49+00:00
summary: BedsideTableDisplay czyli zegar na szafkę nocną mocno z InfluxDB korzystający opisywałem jakiś czas temu. Tym razem opiszę nieoczekiwane problemy z grzaniem się mikroprocesora, kwestię pomiaru temperatury "przy łóżku" oraz jak rozwiązałem kwestię jasności wyświetlacza.
url: /2019/05/bedsidetabledisplay-ciag-dalszy-problemy-z-temperatura-i-obudowa/
featured_image: /wp-content/uploads/2019/05/2.jpg

---
[BedsideTableDisplay czyli zegar na szafkę nocną mocno z InfluxDB korzystający][1] opisywałem jakiś czas temu. Tym razem opiszę nieoczekiwane problemy z grzaniem się mikroprocesora, kwestię pomiaru temperatury "przy łóżku" oraz jak rozwiązałem kwestię jasności wyświetlacza.

Na pierwszy ogień sprawa temperatury. Pomiary były istotnie zawyżone. "Na oko" czyli obserwując pomiary sprawa wydała się podejrzana, więc dołożyłem obok termometr ze starej stacji pogody. Rozbieżność o kilka stopni. Czas na analizę danych w grafanie. Zdecydowanie w sypialni nie miałem cały czas powyżej 26 stopni.

Dalsze badanie zacząłem od pilnowania termometru w BTD i referencyjnego ze stacji pogody w jakkolwiek kontrolowanych warunkach. 

Na początku w lodówce - tu brak odchyłów, choć można było zauważyć że niemal luzem ułożony chip DS28B20 bardzo szybko się ogrzewa od powietrza po otwarciu lodówki. Ciekawostka - ESP8266 w małą powierzchniowo lutowaną antenką Rainsun nie stracił sygnału WiFi.

Kolej na ułożenie w temperaturze lekko wyższej od pokojowej czyli na biurku. Tu znudzony czekaniem na wyrównanie temperatury schładzałem oba termometry sprężonym powietrzem odwróconym do góry nogami. Znowu BTD nagrzewał się dużo szybciej, ale tym razem różnica w pomiarze ustabilizowanym wynosiła 2-3 stopnie. Dużo.

![Zdjęcie późniejsze, radiatory będą dołożone w dalszej fazie eksperymentowania; DS18B20 ukrywa się między nóżkami fotorezystora.](/wp-content/uploads/2019/05/1.jpg "Zdjęcie późniejsze, radiatory będą dołożone w dalszej fazie eksperymentowania; DS18B20 ukrywa się między nóżkami fotorezystora.")

Po zweryfikowaniu że jak każdy chip tak DS28B20 może mieć pewne odchyły spróbowałem go wymienić na zapasowy - dalej to samo. Wtedy dotarło do mnie że może któryś ze scalaków grzeje się nadmiernie i powoduje zwiększenie temperatury całego BTD. Pomiar "z palca" wydawał się potwierdzać teorię więc wyposażyłem się w pirometr - zakup kamery termowizyjnej do tego projektu byłby lekką przesadą 😉 

![](/wp-content/uploads/2019/05/2.jpg)

Pomiary w izolowanej szafce w chłodnym pomieszczeniu potwierdziły że scalaki na Wemos D1 Mini Pro istotnie wpływają na temperaturę całości.

<table class="wp-block-table">
  <tr>
    <td>
    </td>
    <td>
      <strong>seria 1<br />pomiar A</strong>
    </td>
    <td>
      <strong>seria 1<br />pomiar B</strong>
    </td>
    <td>
      <strong>seria 2<br />pomiar A</strong>
    </td>
    <td>
      <strong>seria 2<br />pomiar B</strong>
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>temp. otoczenia</strong>
    </td>
    <td>
      25°C
    </td>
    <td>
      25°C
    </td>
    <td>
      24°C
    </td>
    <td>
      25°C
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>odczyt z DS18B20</strong>
    </td>
    <td>
      25°C
    </td>
    <td>
      27°C
    </td>
    <td>
      24°C
    </td>
    <td>
      27°C
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>ESP8266</strong>
    </td>
    <td>
      31°C
    </td>
    <td>
      31°C
    </td>
    <td>
      29°C
    </td>
    <td>
      30°C
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>CH2104</strong>
    </td>
    <td>
      32°C
    </td>
    <td>
      35°C
    </td>
    <td>
      32°C
    </td>
    <td>
      34°C
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>tranzystor zasilania</strong>
    </td>
    <td>
      25°C
    </td>
    <td>
      31°C
    </td>
    <td>
      34°C
    </td>
    <td>
      36°C
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>wyświetlacz OLED</strong>
    </td>
    <td>
      -
    </td>
    <td>
      -
    </td>
    <td>
      25°C
    </td>
    <td>
      25°C
    </td>
  </tr>
</table>

Pomiar A to pomiar po około pół godziny od schłodzenia ciekłym powietrzem (do około -20°C) gdzie odczyt jest równy realnej temperaturze, pomiar B to odczyt po około godzinie kiedy się ustabilizował. Dla referencji [link do strony producenta][2] tej płytki wraz ze schematem - jest to wersja 1.1

Aż tak wysoka temperatura CH2104 kazała mi przemyśleć czy aby nie za dużo wypycham po porcie szeregowym. [Sprawdziłem][3] i okazało się, że wyłączenie wysyłania czegokolwiek nic nie daje. Ale chociaż kod źródłowy stał się czytelniejszy. Testując dla pewności jeszcze różne zasilacze USB znowu temperatura sekcji zasilania także nie uległa zmianie. 

Jedyne co mogłem zrobić z grzejącymi się scalakami to zamontować aluminiowe radiatory, widoczne na pierwszym zdjęciu. Nie jestem pewien czy to coś dało, ale na pewno nie zaszkodziło elektronice chodzącej 24/7

Rozwiązanie problemu było w zasadzie oczywiste, ale unikałem go trochę by zachować zwartą konstrukcję BTD - wyprowadzić chip termometru na zewnątrz. Efekt natychmiastowy w postaci zrównania pomiarów z termometrem referencyjnym do pół stopnia i mniej więcej ćwierć stopnia z pomiarem powierzchni DS18B20 z pirometru.

![](/wp-content/uploads/2019/05/4.jpg)

![](/wp-content/uploads/2019/05/5.jpg)

Prowizorka jak zwykle okazała się najtrwalsza, więc sonda temperatury to teraz 2x 3 żyły przewodów połączeniowych (bo akurat nie miałem u siebie o odpowiednich końcówkach) połączone między sobą i DS18B20 rurką termokurczliwą.

Skoro termometr miał wrócić do sypialni to czas najwyższy zająć się jasnością OLEDowego wyświetlacza. [Klasyczny model od Adafruit][4] sterowanie podświetleniem teoretycznie ma dzięki [driverowi SSD1306][5]. Jednak zakres jasności jest tak beznadziejny że prawie zwątpiłem w swoją umiejętność sterowania układem przez I2C póki nie stworzyłem testowej pętli zwiększającej jasność krok po kroku, a potem migając wartościami MAX-MIN. Sterowanie napięciem wejściowym niewiele daje - póki jesteśmy w zakresie napięć SSD1306 to nie zmienia się nic - układ ma regulator napięcia. Schodząc poniżej ekran zaczyna zauważalnie migotać. 

Jako że maksymalna jasność potrzebna jest i tak rzadko to dołożyłem mocno hardware'owe rozwiązanie - przyciemnioną plexi. Przy okazji całość trafiła do jakiegoś luźnego pudełka kuchennego - trochę jako stelaż dla plexi (odziedziczonego po innym projekcie więc nieco za dużego), trochę jako stabilizacja, bowiem BTD był tak mały że sztywny kabel zasilający powodował że ciężko było utrzymać go w pożądanym miejscu.

![](/wp-content/uploads/2019/05/3.jpg)

 [2]: https://wiki.wemos.cc/products:retired:d1_mini_pro_v1.1.0
 [3]: https://github.com/danielskowronski/btd/commit/56494c2207eb1bf56aa0e57c7c3ea6bc4db41e0b
 [4]: https://www.adafruit.com/product/326
 [5]: https://cdn-shop.adafruit.com/datasheets/SSD1306.pdf