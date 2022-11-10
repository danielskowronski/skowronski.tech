---
title: Budowa stacji pogody z czujnikiem smogu i prezentacja danych
author: Daniel Skowroński
type: post
date: 2019-01-14T00:03:44+00:00
url: /2019/01/budowa-stacji-pogody-z-czujnikiem-smogu-i-prezentacja-danych/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/01/smog.png
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
Co prawda zajęcie bardziej manualno-odtwórcze niż większość do tej pory opisywanych projektów, ale nadal bardzo satysfakcjonujące. Cel: zmontowanie (z gotowego kitu od Nettigo) stacji pogody (sensor temperatury, wilgotności i ciśnienia) wraz z czujnikiem smogu (NovaFitnes SDS011 z miniaturki) oraz postawienie infrastruktury do zbierania danych i ładnej prezentacji.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="300" height="275" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog-300x275.png" alt="" class="wp-image-1342" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog-300x275.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog-768x705.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog-1024x940.png 1024w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog.png 1096w" sizes="(max-width: 300px) 100vw, 300px" /> <figcaption>NovaFitnes SDS011 </figcaption></figure> 

Post nie jest sponsorowany, ale Nettigo naprawdę zrobiło kawał dobrej roboty w usprawnianiu oryginalnego projektu od  
[Luftdaten.info][1], którego największym problemem jest znikoma dokumentacja w języku angielski (strona niemal wcale nie przetłumaczona z niemieckiego). Kit sprzedawany prawie ze wszystkim [wygląda tak][2].

Co było potrzeba? Po pierwsze kit (~200zł) składający się z całej elektroniki (czujnik smogu SDS011, modem wifi z kontrolerem, płytka łącząca całość, grzałka i czujnik temperatury sprawdzający pracę grzałki, złącza, śruby, rurkę do czujnika i naprawdę długi _płaski_ (co jest przydane do montażu za oknem) kabel USB). Do tego kilka części hydraulicznych, które osobiści kupiłem w Castoramie za około 25zł. Oraz opaski zaciskowe.

Ja do zestawu standardowego dołożyłem czujnik [Bosch BME280][3]. Dodaje to odczyt temperatury, wilgotności i ciśnienia z rozsądną precyzją. Do płytki od Nettigo można podłączyć urządzenia I2C na 3.3V oraz 5V i moduł GPS. Obsługiwana jest większość popularnych wśród hobbystów czujników i kilka wyświetlaczy.

Lista narzędzi opisana na stronie jest nieco nadmiarowa jeśli ma się trochę fantazji. Poza wkręcaniem śrubek potrzeba zasadniczo przepiłować rurkę 25mm i wykonać 4 otwory &#8211; 2 po 6mm, jeden 8mm oraz ostatni &#8211; 25mm. W około 2-3h zależnie od stopnia zaangażowania można te manipulacje wykonać Leathermanem (nóż, szydło, pilnik) i nożem do chleba. Poza tym rzecz jasna lutownica (jakakolwiek, bo mamy tylko elementy przewlekane).<figure class="wp-block-image">

[<img decoding="async" loading="lazy" width="3592" height="3021" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog0.png" alt="" class="wp-image-1339" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog0.png 3592w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog0-300x252.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog0-768x646.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog0-1024x861.png 1024w" sizes="(max-width: 3592px) 100vw, 3592px" />][4]<figcaption>Elektronika złożona, czas na testy</figcaption></figure> 

Montaż elektroniki wraz z wgraniem oprogramowania i testami przed złożeniem obudowy trwa około godziny-półtorej. Potrzeba komputera (macOS/Windows/Linuks) którym wgramy firmware oraz ustawimy parametry WiFi. Zasada działania jak większość urządzeń IoT WiFi &#8211; bez konfigu wystawia swój AP, wpisujemy dane do naszej domowej sieci i działa.<figure class="wp-block-image">

[<img decoding="async" loading="lazy" width="1002" height="770" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog3.png" alt="" class="wp-image-1344" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog3.png 1002w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog3-300x231.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog3-768x590.png 768w" sizes="(max-width: 1002px) 100vw, 1002px" />][5]<figcaption>Strona domowa czujnika</figcaption></figure> <figure class="wp-block-image">[<img decoding="async" loading="lazy" width="1002" height="854" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog4.png" alt="" class="wp-image-1345" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog4.png 1002w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog4-300x256.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog4-768x655.png 768w" sizes="(max-width: 1002px) 100vw, 1002px" />][6]<figcaption>Widok aktualnego pomiaru</figcaption></figure> 

Istotną cechą oprogramowania pokładowego jest obsługa wielu API (w tym OpenSenseMap) oraz generycznego wysyłania JSONa za pomocą HTTP POSTa i zapis do Influxa.<figure class="wp-block-image">

[<img decoding="async" loading="lazy" width="1000" height="1836" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog5.png" alt="" class="wp-image-1343" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog5.png 1000w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog5-163x300.png 163w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog5-768x1410.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog5-558x1024.png 558w" sizes="(max-width: 1000px) 100vw, 1000px" />][7]<figcaption>Strona konfiguracyjna</figcaption></figure> 

Pierwsze co przetestowałem to _własne&nbsp;API_. Przez kilka sekund miałem zamiar zbudować własny system wykresów, ale potem ujrzałem Influxa. Jednak API nie zostało porzucone &#8211; moja [aplikacja do podglądu stanu wszechświata][8] świetnie korzysta z danych w JSONie. Kod &#8222;zbieracza&#8221; danych powstał w php bo akurat takie CGI było najbardziej pod ręką. Jedna nieoczywistość &#8211; nie można wykorzystać zmiennej $_POST bo _Content-Type_ to nie odmiana _application/x-www-form-urlencoded_ tylko _application/json_. Trzeba wtedy odczytać _php://input_. Rzecz jasna skrypt poniżej wymaga dorobienia jakiejkolwiek autoryzacji &#8211; ale można wykorzystać HTTP Basic Auth.

<pre class="lang:php EnlighterJSRAW " title="collect.php">&lt;?php
 $current = fopen("current.json", "w") or die("fopen failed");
 $data=file_get_contents('php://input')."\n";
 fwrite($current, $data);
 fclose($current);</pre>



Ale co ze zbieraniem danych i robieniem ładnych wykresów? Od InfluxDB prosta i krótka droga do Grafany. Na Linuksie wystarczy zainstalować pakiet influxdb, influxdb-client oraz grafana. W samym influxdb trzeba stworzyć bazę, dodać użytkowników i granty. Poniżej przykładowy konfig dla admina, użytkownika zapisującego dane i grafany (read-only).

<pre class="EnlighterJSRAW  ">create database luftdaten
create user admin with password '...' with all privileges
create user luftdaten with password '...'
create user grafana with password '...'
grant all on luftdaten to luftdaten
grant read on luftdaten to grafana</pre>

W grafanie wystarczy dodać influxa jako źródło danych a potem wyklikać panele z wykresami.<figure class="wp-block-image">

[<img decoding="async" loading="lazy" width="1920" height="1016" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog6.png" alt="" class="wp-image-1347" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog6.png 1920w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog6-300x159.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog6-768x406.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog6-1024x542.png 1024w" sizes="(max-width: 1920px) 100vw, 1920px" />][9]<figcaption>Konfiguracja wykresu z przykładem zapytania do Influxa</figcaption></figure> 



I to wszystko! Całość u mnie zamknęła się w 6 godzinach &#8211; z aktualizacją mojego serwera i zmodyfikowaniem istniejącej aplikacji żeby korzystała z danych na żywo tuż za oknem.<figure class="wp-block-image">

[<img decoding="async" loading="lazy" width="1825" height="691" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog2.png" alt="" class="wp-image-1341" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog2.png 1825w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog2-300x114.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog2-768x291.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog2-1024x388.png 1024w" sizes="(max-width: 1825px) 100vw, 1825px" />][10]<figcaption>Panel pomiarów z Grafany</figcaption></figure> <figure class="wp-block-image">[<img decoding="async" loading="lazy" width="2048" height="1536" src="https://blog.dsinf.net/wp-content/uploads/2019/01/smog1.png" alt="" class="wp-image-1340" srcset="https://blog.dsinf.net/wp-content/uploads/2019/01/smog1.png 2048w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog1-300x225.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog1-768x576.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/01/smog1-1024x768.png 1024w" sizes="(max-width: 2048px) 100vw, 2048px" />][11]<figcaption>Czujnik za oknem</figcaption></figure>

 [1]: https://luftdaten.info/
 [2]: https://nettigo.pl/products/nettigo-air-monitor-kit-0-2-1-zbuduj-wlasny-czujnik-smogowy
 [3]: https://www.bosch-sensortec.com/bst/products/all_products/bmp280
 [4]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog0.png
 [5]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog3.png
 [6]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog4.png
 [7]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog5.png
 [8]: https://blog.dsinf.net/2018/02/aplikacja-do-podgladu-stanu-wszechswiata/
 [9]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog6.png
 [10]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog2.png
 [11]: https://blog.dsinf.net/wp-content/uploads/2019/01/smog1.png