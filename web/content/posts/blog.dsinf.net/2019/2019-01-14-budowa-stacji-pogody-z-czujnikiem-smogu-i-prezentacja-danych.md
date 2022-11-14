---
title: Budowa stacji pogody z czujnikiem smogu i prezentacja danych
author: Daniel Skowroński
type: post
date: 2019-01-14T00:03:44+00:00
url: /2019/01/budowa-stacji-pogody-z-czujnikiem-smogu-i-prezentacja-danych/
featured_image: /wp-content/uploads/2019/01/smog.png
tags:
  - elektronika
  - grafana
  - hardware
  - influxdb
  - luftdaten
  - pomiary
  - smog
  - środowisko

---
Co prawda zajęcie bardziej manualno-odtwórcze niż większość do tej pory opisywanych projektów, ale nadal bardzo satysfakcjonujące. Cel: zmontowanie (z gotowego kitu od Nettigo) stacji pogody (sensor temperatury, wilgotności i ciśnienia) wraz z czujnikiem smogu (NovaFitnes SDS011 z miniaturki) oraz postawienie infrastruktury do zbierania danych i ładnej prezentacji.

![NovaFitnes SDS011](/wp-content/uploads/2019/01/smog.png "NovaFitnes SDS011")

Post nie jest sponsorowany, ale Nettigo naprawdę zrobiło kawał dobrej roboty w usprawnianiu oryginalnego projektu od  
[Luftdaten.info][1], którego największym problemem jest znikoma dokumentacja w języku angielski (strona niemal wcale nie przetłumaczona z niemieckiego). Kit sprzedawany prawie ze wszystkim [wygląda tak][2].

Co było potrzeba? Po pierwsze kit (~200zł) składający się z całej elektroniki (czujnik smogu SDS011, modem wifi z kontrolerem, płytka łącząca całość, grzałka i czujnik temperatury sprawdzający pracę grzałki, złącza, śruby, rurkę do czujnika i naprawdę długi _płaski_ (co jest przydane do montażu za oknem) kabel USB). Do tego kilka części hydraulicznych, które osobiści kupiłem w Castoramie za około 25zł. Oraz opaski zaciskowe.

Ja do zestawu standardowego dołożyłem czujnik [Bosch BME280][3]. Dodaje to odczyt temperatury, wilgotności i ciśnienia z rozsądną precyzją. Do płytki od Nettigo można podłączyć urządzenia I2C na 3.3V oraz 5V i moduł GPS. Obsługiwana jest większość popularnych wśród hobbystów czujników i kilka wyświetlaczy.

Lista narzędzi opisana na stronie jest nieco nadmiarowa jeśli ma się trochę fantazji. Poza wkręcaniem śrubek potrzeba zasadniczo przepiłować rurkę 25mm i wykonać 4 otwory - 2 po 6mm, jeden 8mm oraz ostatni - 25mm. W około 2-3h zależnie od stopnia zaangażowania można te manipulacje wykonać Leathermanem (nóż, szydło, pilnik) i nożem do chleba. Poza tym rzecz jasna lutownica (jakakolwiek, bo mamy tylko elementy przewlekane).


![Elektronika złożona, czas na testy](/wp-content/uploads/2019/01/smog0.png "Elektronika złożona, czas na testy")

Montaż elektroniki wraz z wgraniem oprogramowania i testami przed złożeniem obudowy trwa około godziny-półtorej. Potrzeba komputera (macOS/Windows/Linuks) którym wgramy firmware oraz ustawimy parametry WiFi. Zasada działania jak większość urządzeń IoT WiFi - bez konfigu wystawia swój AP, wpisujemy dane do naszej domowej sieci i działa.


![Strona domowa czujnika](/wp-content/uploads/2019/01/smog3.png "Strona domowa czujnika")

![Widok aktualnego pomiaru](/wp-content/uploads/2019/01/smog4.png "Widok aktualnego pomiaru")

Istotną cechą oprogramowania pokładowego jest obsługa wielu API (w tym OpenSenseMap) oraz generycznego wysyłania JSONa za pomocą HTTP POSTa i zapis do Influxa.

![Strona konfiguracyjna](/wp-content/uploads/2019/01/smog5.png "Strona konfiguracyjna")

Pierwsze co przetestowałem to _własne&nbsp;API_. Przez kilka sekund miałem zamiar zbudować własny system wykresów, ale potem ujrzałem Influxa. Jednak API nie zostało porzucone - moja [aplikacja do podglądu stanu wszechświata][8] świetnie korzysta z danych w JSONie. Kod "zbieracza" danych powstał w php bo akurat takie CGI było najbardziej pod ręką. Jedna nieoczywistość - nie można wykorzystać zmiennej $_POST bo _Content-Type_ to nie odmiana _application/x-www-form-urlencoded_ tylko _application/json_. Trzeba wtedy odczytać _php://input_. Rzecz jasna skrypt poniżej wymaga dorobienia jakiejkolwiek autoryzacji - ale można wykorzystać HTTP Basic Auth.

```php
<?php
 $current = fopen("current.json", "w") or die("fopen failed");
 $data=file_get_contents('php://input')."\n";
 fwrite($current, $data);
 fclose($current);
```




Ale co ze zbieraniem danych i robieniem ładnych wykresów? Od InfluxDB prosta i krótka droga do Grafany. Na Linuksie wystarczy zainstalować pakiet influxdb, influxdb-client oraz grafana. W samym influxdb trzeba stworzyć bazę, dodać użytkowników i granty. Poniżej przykładowy konfig dla admina, użytkownika zapisującego dane i grafany (read-only).

```sql
create database luftdaten
create user admin with password '...' with all privileges
create user luftdaten with password '...'
create user grafana with password '...'
grant all on luftdaten to luftdaten
grant read on luftdaten to grafana
```


W grafanie wystarczy dodać influxa jako źródło danych a potem wyklikać panele z wykresami.

![Konfiguracja wykresu z przykładem zapytania do Influxa](/wp-content/uploads/2019/01/smog6.png "Konfiguracja wykresu z przykładem zapytania do Influxa")


I to wszystko! Całość u mnie zamknęła się w 6 godzinach - z aktualizacją mojego serwera i zmodyfikowaniem istniejącej aplikacji żeby korzystała z danych na żywo tuż za oknem.

![Panel pomiarów z Grafany](/wp-content/uploads/2019/01/smog2.png "Panel pomiarów z Grafany")

![Czujnik za oknem](/wp-content/uploads/2019/01/smog1.png "Czujnik za oknem")

 [1]: https://luftdaten.info/
 [2]: https://nettigo.pl/products/nettigo-air-monitor-kit-0-2-1-zbuduj-wlasny-czujnik-smogowy
 [3]: https://www.bosch-sensortec.com/bst/products/all_products/bmp280
 [4]: /wp-content/uploads/2019/01/smog0.png
 [5]: /wp-content/uploads/2019/01/smog3.png
 [6]: /wp-content/uploads/2019/01/smog4.png
 [7]: /wp-content/uploads/2019/01/smog5.png
 [8]: https://blog.dsinf.net/2018/02/aplikacja-do-podgladu-stanu-wszechswiata/
 [9]: /wp-content/uploads/2019/01/smog6.png
 [10]: /wp-content/uploads/2019/01/smog2.png
 [11]: /wp-content/uploads/2019/01/smog1.png