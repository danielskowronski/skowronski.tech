---
title: O stacji pogody z czujnikiem smogu raz jeszcze – alerty, obudowa i klient mobilny
author: Daniel Skowroński
type: post
date: 2019-02-23T14:12:40+00:00
excerpt: 'Jakiś czas temu zbudowałem stację pogody z czujnikiem smogu w oparciu o projekt Nettigo Air Monitor. Od tego czasu przybył do niej system alertowania za pomocą grafany i obudowa której co prawda daleko do stacji meteorologicznej ale rozwiązała najpoważniejszy problem - padające bezpośrednio słońce generujące w środku zimy odczyty około 40°C (umiejscowienie poza balkonem odpadało).'
url: /2019/02/o-stacji-pogody-z-czujnikiem-smogu-raz-jeszcze-alerty-obudowa-i-klient-mobilny/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/02/nam3.jpg

---
Jakiś czas temu [zbudowałem stację pogody z czujnikiem smogu][1] w oparciu o projekt Nettigo Air Monitor. Od tego czasu przybył do niej system alertowania za pomocą grafany i obudowa której co prawda daleko do stacji meteorologicznej ale rozwiązała najpoważniejszy problem - padające bezpośrednio słońce generujące w środku zimy odczyty około 40°C (umiejscowienie poza balkonem odpadało).

## Obudowa stacji meteo<figure class="wp-block-image">

![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam2.jpg) <figcaption>Tak wygląda właściwa stacja meteorologiczna; [© Marek Argent [CC BY-SA 4.0]][2]</figcaption></figure> 

Jako że skrzynki z ażurowymi ściankami budować mi się nie chciało poszedłem w rozwiązanie prostsze ale dość skutecznie pozbywające się problemu słońca - pudełko po butach i folia aluminiowa. Pudełko nie zamknięte całkowicie zapewnia dostęp ciepła. Pomiary od kilku dni prowadzone także zwykłą sklepową stacją meteo i porównywane z prognozami wykazują brak odchyleń. 

Płaski kabel USB dostarczony przez Nettigo okazał się bardzo przydatny do montażu za oknem i generalnie polecam płaskie przedłużacze USB jeśli odległość czujnika od źródła prądu ma być większa.

<ul class="is-layout-flex wp-block-gallery-3 wp-block-gallery columns-2 is-cropped">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2019/02/nam3-1024x768.jpg">![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam3.jpg)</a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2019/02/nam4-1024x768.jpg">![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam4.jpg)</a></figure>
  </li>
</ul>

## Alerty pogodowe

Alarmów pogodowych można wymyślić co najmniej kilka, ja zacząłem od dwóch - wysokiego poziomu cząstek zawieszonych czyli smogu (>75µg/m³) i faktu że czujnik przestał transmitować dane - wbrew pozorom dość łatwo odłączyć zasilanie i zapomnieć podłączyć je ponownie. No i crashe też się mogą zdarzyć. Ten drugi pomiar powiązałem z wysyłaną do InfluxDB siłą sygnału WiFi.

Do alertowania użyłem modułu Grafany do obsługi mojego ulubionego systemu page'owania - Telegrama. Jako że na stronie Grafany brak dokumentacji jak całość ustawić wrzucę tutaj skrócone instrukcje.

  * Z menu bocznego grafany należy wybrać dzwoneczek (_alerting_), następnie _notifications channels_
  * Kliknąć _New channel_ i wybrać _Type_ - _Telegram_
  * Teraz trzeba stworzyć bota (pomijam tworzenie konta w Telegramie) - <https://core.telegram.org/bots#6-botfather> 
  * Zasadniczo wysyłamy do bota _BotFather_ komendę `/newbot`, odpowiadamy na pytanie o nazwę i w odpowiedzi dostajemy token do HTTP API - i ten token podajemy w polu _BOT API Token_ w Grafanie
  * Druga zmienna potrzebna do ustawienia powiadomień to _Chat&nbsp;ID_ czyli adres docelowy powiadomień - zwykle będzie to nasz własny ID lub ID grupy zainteresowanej alertami, np. administratorów
  * Najprostszy sposób na uzyskanie ID chatu to użycie _IDBot_ - wystarczy zacząć z nim konwersację lub dodać do grupy i wydać komendę `/getid` lub `/getgroupid`
  * Pozostaje tylko _Send&nbsp;test&nbsp;&nbsp;_i _Save_
  * Same alerty dodajemy na konkretnym wykresie - _Edit_ i zakładka _Alert_

Mój dashboard grafany aktualizuję na bieżąco jak pojawią się tylko drobne pomysły ale umieszczę poniżej wersję którą można uznać za podstawę do użycia u siebie.<figure class="wp-block-image">

![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam1.png)</figure> 

<div class="wp-block-file">
  <a href="http://blog.dsinf.net/wp-content/uploads/2019/02/nettigo-air-monitor-grafana.json_.txt">nettigo-air-monitor-grafana.json</a><a href="http://blog.dsinf.net/wp-content/uploads/2019/02/nettigo-air-monitor-grafana.json_.txt" class="wp-block-file__button" download>Pobierz</a>
</div><figure class="wp-block-image is-resized">

![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam6.jpg)<figcaption>Przykładowy alert wysłany przez Grafanę</figcaption></figure> 

## Lekki klient mobilny

Na koniec jeszcze kilka słów o kliencie mobilnym. Otóż Grafana na telefonie działa wybitnie beznadziejnie i co prawda można by tworzyć osobny dashboard z ograniczoną liczbą wykresów ale czasem lekki klient też jest przydatny.

Jedyne co nam potrzebne poza plikiem HTML to plik JSON wysyłany przez czujnik na wskazany serwer - dokładnie to co zbiera [collect.php z poprzedniego wpisu][1]. Tutaj umieszczony w tym samym folderze serwera www pod nazwą smog.json (dla ułatwienia i obejścia problemów z CORS jeśli stosujemy różne domeny można na serwerze stworzyć symlink).<figure class="wp-block-image is-resized">

![](https://blog.dsinf.net/wp-content/uploads/2019/02/nam5.jpg)</figure> 

<pre class="EnlighterJSRAW" data-enlighter-language="html" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">&lt;!DOCTYPE html>
&lt;html>
&lt;head>
	&lt;link href="https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,400i,700,700i" rel="stylesheet">
	&lt;style>
	body{
		padding: 25px;
		background: black;
		color: white;
		font-family: "Ubuntu Mono",Consolas,Monospace;
		font-size: 72px;
	}
	td{
		padding-left: 25px;
		padding-right: 25px;
		text-align: right;
		width: 50%;
	}
	table,tbody,tr{
		width: 100%;
	}
	.val{
		font-weight: bold;
		color: gold;
		text-align: left;
	}
	.diag{
		font-size: 42px;
	}
	&lt;/style>
	&lt;title>29L193 - Nettigo Air Monitor&lt;/title>
&lt;body>
	&lt;center>
		&lt;h3>29L193&lt;br />&lt;i>Nettigo Air Monitor&lt;/i>&lt;/h3>
		&lt;table>
			&lt;tr>&lt;td>Temperature&lt;/td>&lt;td class="val" id="temperature">&lt;/td>&lt;/tr>
			&lt;tr>&lt;td>Humidity&lt;/td>&lt;td class="val" id="humidity">&lt;/td>&lt;/tr>
			&lt;tr>&lt;td>Pressure&lt;/td>&lt;td class="val" id="pressure">&lt;/td>&lt;/tr>
			&lt;tr>&lt;td>PM 2.5&lt;/td>&lt;td class="val" id="pm25">&lt;/td>&lt;/tr>
			&lt;tr>&lt;td>PM&nbsp;&nbsp;10&lt;/td>&lt;td class="val" id="pm10">&lt;/td>&lt;/tr>
			&lt;tr>&lt;td>&nbsp;&lt;/td>&lt;td>&lt;/td>&lt;/tr>
			&lt;tr class="diag">&lt;td>Diagnostics&lt;/td>&lt;td class="val" id="diag">&lt;/td>&lt;/tr>
		&lt;/table>
	&lt;/center>

	&lt;script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js">&lt;/script>
	&lt;script>
		function fetch(){
			$.get( "/smog.json?"+Date.now(), function( data ) {
				$("#temperature").html(Math.round(data.sensordatavalues[4].value,1)+"&deg;C")
				$("#humidity").html(Math.round(data.sensordatavalues[5].value,0)+"%")
				$("#pressure").html(Math.round(data.sensordatavalues[6].value/100,0)+"&nbsp;hPa")
				$("#pm25").html(Math.round(data.sensordatavalues[1].value,1)+"&nbsp;µg/m³")
				$("#pm10").html(Math.round(data.sensordatavalues[0].value,1)+"&nbsp;µg/m³")
				$("#diag").html(
					Math.round(data.sensordatavalues[2].value,1)+"&deg;C/"+
					Math.round(data.sensordatavalues[3].value,1)+"%/"+
					data.sensordatavalues[7].value+""
				)

				var pm25=Math.round(data.sensordatavalues[1].value,0)
				if (pm25>=50)  $("#pm25").append(" &lt;span style='color: black; background: yellow'>!!&lt;/span>")
				if (pm25>=100) $("#pm25").append(" &lt;span style='color: black; background: red'>!!&lt;/span>")

				var pm10=Math.round(data.sensordatavalues[0].value,0)
				if (pm10>=50)  $("#pm10").append(" &lt;span style='color: black; background: yellow'>!!&lt;/span>")
				if (pm10>=100) $("#pm10").append(" &lt;span style='color: black; background: red'>!!&lt;/span>")
			});
		}
		fetch();
		setInterval(function(){ fetch(); },60000);
	&lt;/script>
&lt;/body>
&lt;/html>
</pre>

 [1]: https://blog.dsinf.net/2019/01/budowa-stacji-pogody-z-czujnikiem-smogu-i-prezentacja-danych/
 [2]: https://commons.wikimedia.org/wiki/File:20150114_1555_008_radzyn_stacja_hydrologiczna_imgw_a.jpg
 [3]: https://blog.dsinf.net/wp-content/uploads/2019/02/nam1.png
 [4]: https://blog.dsinf.net/wp-content/uploads/2019/02/nam6.jpg
 [5]: https://blog.dsinf.net/wp-content/uploads/2019/02/nam5.jpg