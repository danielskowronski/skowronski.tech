---
title: BedsideTableDisplay czyli zegar na szafkę nocną mocno z InfluxDB korzystający
author: Daniel Skowroński
type: post
date: 2019-03-22T14:52:43+00:00
summary: Zegar to mój powracający od dawna projekt konstruktorsko-elektroniczny. Bieżąca iteracja zapisuje dane o temperaturze do InfluxDB (chwilowo just for fun) oraz pobiera dane ze stacji pogody.
url: /2019/03/bedsidetabledisplay-czyli-zegar-na-szafke-nocna-mocno-z-influxdb-korzystajacy/
featured_image: /wp-content/uploads/2019/03/btd.png

---
Zegar to mój powracający od dawna projekt konstruktorsko-elektroniczny. Bieżąca iteracja zapisuje dane o temperaturze do InfluxDB (chwilowo _just for fun_) oraz pobiera dane [ze stacji pogody][1].

Poprzednie iteracje zegara to [zegar-beta][2] - bazujący na arduino nano służący głównie jako budzik (alfa to niezrealizowany projekt olbrzymiego wyświetlacza), [zegar-delta][3] - zasadniczo RaspberryPi z wyświetlaczem oraz webgui do konfiguracji budzika i prymitywnym zbieraniem danych oraz [zegar-gamma][4] czyli powrót do korzeni w formie arduino, ale ze sterowaniem na pilota.

![zegar-beta - pierwszy z serii](/wp-content/uploads/2019/03/zegarbeta.jpg)

**BedsideTableDisplay** to przede wszystkim przedłużenie [Nettigo Air Monitor][1]a oraz zegar. Niby dane można odczytać z telefonu ale wyświetlacz zawsze bardziej zachęca do spojrzenia na odczyty i docelowo ładniej się prezentuje.

![BedsideTableDisplay (czyli teoretycznie zegar-epsilon)](/wp-content/uploads/2019/03/btd-1.png)

Ponieważ postanowiłem że nie będę dodawał dodatkowych bridgy do łączności mikrokontroler-internet (np. bluetootha aktywnego w RaspberryPi) tylko wejdę w "IoT".

Uznałem że skorzystam z tego samego modułu co NettigoAirMonitor, czyli Wemos D1 Pro - najładniej (z tych które wydziałem) upakowanego układu ESP8266. Konkretny model opisany jest na [wiki Wemos][6]. Cena to około 30zł, a więc również jest dobrze - tyle można zapłacić za arduino nano, a wartość dodana w postaci WiFi i procesora obsługującego bez problemu SSL w HTTPS jest ogromna.  
Co prawda jest w Internecie trochę narzekania na obsługę ESP8266 w środowisku Arduino, ale da się to przeżyć.

Skoro mamy już WiFi warto dodać obsługę NTP żeby ręcznie zegara nie ustawiać. TimeLib to gotowa biblioteka do obsługi czasu w Arduino, ma też [gotowca do obsługi NTP][7] pod ESP8266 (konkretniej używając ESP8266WiFi.h). Dodałem do niego drobne usprawnienie - zapewnienie czasu innego niż 00:00 na starcie poprzez ponawianie zapytań.

UX zapewnia wyświetlacz OLED (niestety lekko mały, znacznie większych nie ma na rynku) i pilot na podczerwień - oszczędza to liczbę pinów i problemu z fizycznym umiejscowieniem przycisków, zwłaszcza w ew. obudowie.

Poza czujnikiem podczerwieni (VS1838B - taki był pod ręką) są jeszcze 2 sensory - fotorezystor (obsługiwany przez jedyny ADC w ESP8266) i klasyczny Dallas DS18B20 czyli termometr na OneWire.

Ważna uwaga o OneWire w ESP8266, a przynajmniej w Wemosie D1 mini pro - na pewno nie działa port D0 (brak obsługi przerwań) ale jedyny port na którym chciał ruszyć to D4 - kupiłem nawet trzeci czujnik myśląc że 2 poprzednie spaliłem złą polaryzacją napięcia...  

![Pinout dla Arduino, bowiem numery i możliwości portów to mała pułapka; źródło: https://escapequotes.net/wp-content/uploads/2016/02/d1-mini-esp8266-board-sh_fixled.jpg](/wp-content/uploads/2019/03/d1-mini-esp8266-board-sh_fixled.jpg)

Szkieletem konstrukcji są 2 płytki prototypowe 3x7cm, śruby łączące wspomniane płytki oraz nóżki. W kanapce między płytkami mamy przestrzeń na kable z górnej płytki łączące peryferia z mikrokontrolerem, dolna płytka nie ma żadnych elementów poza nóżkami. Zasilanie to port microUSB samej płytki Wemos. 

Kod w C++ oczywiście trafił [na Githuba][8]. Ale co ze schematem? Szukałem długo narzędzia niezbyt dziecinnego (czyli bez klasycznych arduinowych kabelków i breadboarda) ale i takiego żebym je obsłużył. Ostateczny wybór to CircuitMaker od Altium. Jest co prawda tylko pod Windows, ale jako że nie ma za bardzo standardu pliku do schematów elektronicznych to uznałem że export do PDF/obrazka wystarczy na potrzeby projektu. Poza tym środowisko całkiem fajne gdyż mamy wbudowaną bazę elementów elektronicznych (w sumie jedyne środowisko które miało pinout ESP8266!), obsługę projektowania płytek drukowanych (export plików gerber) i system hostowania projektów - podobny do Thingverse (gdzie można trzymać projekty do druku 3D). Projekt części fizycznej BTD trafił zatem [na CircuitMakera][9].

![Schemat stworzony w CircuitMakerze](https://raw.githubusercontent.com/danielskowronski/btd/master/hw/schematics.png)

Co z tytułowym [InfluxDB][10]? Otóż dane z NettigoAirMonitor pobierane są właśnie z tej bazy danych. Otrzymuje ona też aktualne wartości temperatury i natężenia światła. Stąd tylko krok do wrzucenia pomiarów w Grafanę. Tu jeszcze jedna uwaga - Grafana wymaga zrobienia jednego _Data Source_ na każdą bazę danych Influxa.<figure class="wp-block-image">

![Jak InfluxDB to i Grafana](/wp-content/uploads/2019/03/Screenshot_2.png)

 [1]: https://blog.dsinf.net/2019/01/budowa-stacji-pogody-z-czujnikiem-smogu-i-prezentacja-danych/
 [2]: https://github.com/danielskowronski/zegar-beta
 [3]: https://github.com/danielskowronski/zegar-delta
 [4]: https://github.com/danielskowronski/zegar-gamma
 [5]: /wp-content/uploads/2019/03/zegarbeta.jpg
 [6]: https://wiki.wemos.cc/products:retired:d1_mini_pro_v1.1.0
 [7]: https://github.com/PaulStoffregen/Time/blob/master/examples/TimeNTP_ESP8266WiFi/TimeNTP_ESP8266WiFi.ino
 [8]: https://github.com/danielskowronski/btd
 [9]: https://circuitmaker.com/Projects/Details/danielskowronski/btd
 [10]: https://www.influxdata.com/