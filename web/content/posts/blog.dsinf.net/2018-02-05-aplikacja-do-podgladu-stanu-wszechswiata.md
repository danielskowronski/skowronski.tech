---
title: Aplikacja do podglądu stanu wszechświata
author: Daniel Skowroński
type: post
date: 2018-02-05T15:40:28+00:00
excerpt: 'Projekt jest w zasadzie respinem cyklu zegarków które popełniłem bazując na arduino i raspberry pi, przechodząc wreszcie na tablet z przeglądarką i prostą aplikacją w JavaScript. Główne zadanie to wyświetlanie czasu w przyjemnej formie (wybrałem zegar kartkowy) i innych przydatnych informacji - takich jak pogoda czy stan maszyn - wykorzystując projekt sauron3. Nazwa kodowa to colorovo, ale tylko dlatego że tak nazywa się producent tabletu na którym ją uruchamiam.'
url: /2018/02/aplikacja-do-podgladu-stanu-wszechswiata/

---
Projekt jest w zasadzie respinem cyklu zegarków które popełniłem bazując na arduino i raspberry pi, przechodząc wreszcie [na tablet][1] z przeglądarką i prostą aplikacją w JavaScript. Główne zadanie to wyświetlanie czasu w przyjemnej formie (wybrałem zegar kartkowy) i innych przydatnych informacji - takich jak pogoda czy stan maszyn - wykorzystując projekt sauron3. Nazwa kodowa to colorovo, ale tylko dlatego że tak nazywa się producent tabletu na którym ją uruchamiam.

![](https://blog.dsinf.net/wp-content/uploads/2018/02/colorovo.png) 

Ciężko było taki system stworzyć uniwersalnym (a na pewno byłoby to więcej roboty niż można by poświęcić na coś takiego) więc kod nie trafi na GitHuba, tylko tutaj. Głównie dlatego że pełen jest rzeczy które zapewne tylko ja znajdę użytecznymi, ale pewne tricki mogą się okazać przydatne dla innych.

## Zegar

Jeżeli chodzi o zegar to wykorzystałem nie tylko sam [FlipClock.js][2] - na czasie dostarczanym przez system operacyjny nie można za bardzo polegać, a nawet jeśli jest zsynchronizowany to impulsy sterujące flipclockiem to niestety prymitywne oczekiwanie 1 sekundę co ma bardzo niską dokładność - z moich obserwacji w poprzednich wersjach systemu nawet kilka minut w ciągu tygodnia - zwłaszcza że platforma powolna i kilka operacji w tle robionych - głównie sieciowych. Trzeba było zatem zapewnić synchronizację czasu. Na ratunek przychodzi [time.akamai.com][3]

W kodzie ma to następujące odzwierciedlenie - zaczynamy z czasem lokalnym żeby cokolwiek wyświetlić, a funkcja syncTime parsuje datę w formacie ISO i ustawia ją jako czas startu zegara; czas zwracany jest w UTC, ale obiekt Date by default zwraca czas w lokalnej strefie czasowej - więc wypada żeby przeglądarka posiadała dobre dane.

<pre class="lang:js EnlighterJSRAW ">//starting with anything - local clock
var clock = $('.clock').FlipClock({ 
  clockFace: 'TwentyFourHourClock'
});

function syncTime(){
  $.get( "https://time.akamai.com/?iso", function( data ) {
    var date = new Date(data);
    var clock = $('.clock').FlipClock(date, {
      clockFace: 'TwentyFourHourClock'
    });
  });  
}

setInterval(function(){ syncTime();  }, 100000);</pre>

## Stan serwerów

Kolejna kwestia to stan serwerów. Ponieważ frontend saurona komunikuje się z backendem po JSONowym API więc można postawić zwykłego [saurona][4] jako osobną aplikację i wykorzystać jego dane.Prawdopodobnie będziemy chcieli wystawić go za reverse proxy (co da nam chociażby możliwość dodania autoryzacji) takie jak caddy - trzeba jednak pamiętać o CORS - we wspomnianym caddym jest to jedna linijka - <span class="lang:default EnlighterJSRAW crayon-inline ">cors</span> . Kiedy mamy standardową instancję saurona czas pożyczyć kod frontendu do naszej aplikacji.

Przykładowy statyczny HTML z listą czujek - sauron normalnie pobiera z konfigu listę serwerów i czujek renderując je w locie, ale wolałem mieć tylko kilka z nich - co pozwala na dodatkowe formatowanie

<pre class="lang:default EnlighterJSRAW " title="HTML">&lt;div id="display"&gt;
  &lt;div 
  class="hostCheck probe" data-host="thor" data-probe="ssh"&gt;thor&lt;/div&gt;&lt;div 
  class="hostCheck probe" data-host="vps" data-probe="ssh"&gt;vps/ssh&lt;/div&gt;&lt;div 
  class="hostCheck probe" data-host="vps" data-probe="www"&gt;vps/www&lt;/div&gt;
  &lt;br /&gt;&lt;div 
  class="hostCheck NU probe" data-host="fenrir" data-probe="ssh"&gt;fenrir&lt;/div&gt;&lt;div 
  class="hostCheck NU probe" data-host="hyrrokkin" data-probe="ssh"&gt;hyrrokkin&lt;/div&gt;
  &lt;br /&gt;&lt;div 
  class="hostCheck NU probe" data-host="odin" data-probe="ssh"&gt;odin&lt;/div&gt;&lt;div 
  class="hostCheck NU probe" data-host="sleipnir" data-probe="vmware"&gt;sleipnir&lt;/div&gt;&lt;div 
  class="hostCheck NU probe" data-host="yuggoth_vm" data-probe="ssh"&gt;yuggoth_vm&lt;/div&gt;
&lt;/div&gt;</pre>

Style można albo zaimportować [wprost z saurona][5], albo wyciąć tylko to co nas interesuje - co zwiększa wygodę poprawiania (w tym wypadku dodałem klasę NU - NotUrgent - czujki wówczas nie migają dla nieistotnych maszyn)

<pre class="lang:css EnlighterJSRAW " title="CSS saurona">.hostCheck {
	display: inline-block;
	width: 300px;
	text-align: center;
	padding: 5px;
	margin: -2.5px;
	border: 5px solid yellow;
	color: 			  yellow;
}
.hostCheck.dead.NU{
	color: red;
	animation: none;
}
.hostCheck.dead{
	border: 5px solid red;
	animation: pulse 5s infinite;
	z-index: 100 !important;
	position: relative;
}
@keyframes pulse {
  0% {
    background-color: transparent;
    color: red;
  }
  50% {
    background-color: red;
    color: black;
  }
  100% {
    background-color: transparent;
    color: red;
  }
}
.hostCheck.alive{
	color: green;
	border: 5px solid green;
	background: none;
}</pre>

I wreszcie na koniec kod JS do pobierania danych. Ten [całkowicie bez zmian][6].

## Dane pogodowe - źródło

Do pobierania wykorzystałem [OpenWeatherMap][7], [sunrise-sunset.org][8] i API [aplikacji Smok Smog][9]. W kwestii dostępu do tychże było różnie. Pogoda była najtrudniejsza gdyż z wiadomych przyczyn takie API są zwykle płatne, a apki na telefony względnie zabezpieczone przed sztuczkami w stylu [mitmproxy][10] (chociaż nie Weather Underground, przynajmniej na iOS). OWM posiada wersję darmową API dostępną po rejestracji, ale z rate-limitingiem - Hourly forecast: 5 / Daily forecast: 0 / Calls 1min: 60.

Jak się zabezpieczyć przed trzymaniem klucza na wierzchu aplikacji (nawet jeśli mamy autoryzację i tylko zaufanych użytkowników to nadal trzymanie klucza na froncie to nie jest najlepszy pomysł)? Można proxować zapytania przez jakiś skrypt cgi na serwerze (nawet niech będzie to PHP). Ale to dalej nie zabezpiecza przed ratelimitingiem - nawet jeśli nasza aplikacja nie odpytuje serwera za często to zostawienie jej gdzieś na drugim komputerze może wygenerować problem. Brutalnym, ale działającym rozwiązaniem jest odpalany przez crona skrypt wołający curla który ściąga wynik do pliku js w odpowiednich interwałach - w przypadku pogody i podobnych 2 razy na godzinę raczej wystarczą.

Idąc dalej jako że obecnie mieszkam w Krakowie przydałyby się dane o smogu. Tu nieco nadużyłem API Smok Smog które nie mogło mieć nawet certificate pinning bo hula po gołym HTTP. Co prawda jedyne co robi to formatuje dane z WIOŚ na potrzeby aplikacji, ale to akurat przydatne. Żeby wyciągnąć parametr z ID stacji trzeba pobawić się mitmproxy na własnym telefonie.

Ostatnia kwestia to z danych okołopogodowych to wschód i zachód słońca. Tu bez niespodzianek, API jest otwarte, ale żeby go nie nadużywać także proxuję przez brutalny skrypt w cronie.

<pre class="lang:default EnlighterJSRAW" title="API proxy">#!/bin/bash
#&gt; crontab:
#&gt; 0,30     *       *       *       *       /XXX/weather/get.sh

cd /XXX/weather/
curl 'http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl&appid=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&units=metric' &gt; weather.js
curl 'http://api.openweathermap.org/data/2.5/forecast?q=Krakow,pl&appid=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&units=metric' &gt; forecast.js
curl 'http://api.smoksmog.jkostrz.name/api/stations/62' &gt; smog.js
curl 'https://api.sunrise-sunset.org/json?lat=50.089243&lng=19.946331&formatted=0&date='`date +%Y-%m-%d` &gt; sun.js
</pre>

## Dane pogodowe - wyświetlanie

<pre class="lang:default EnlighterJSRAW " title="kontenery HTML">&lt;div id="content"&gt;
  &lt;div id="line0"&gt;
    &lt;div  id="weather_now"&gt;&lt;/div&gt;
    &lt;span id="smog"&gt;&lt;/span&gt;
  &lt;/div&gt;
  &lt;div id="line1"&gt;
    &lt;div  id="weather_next"&gt;&lt;/div&gt;
  &lt;/div&gt;
  &lt;div id="line2"&gt;
    &lt;div  id="date_sun"&gt;&lt;/div&gt;
  &lt;/div&gt;

  &lt;br /&gt;
  &lt;div class="clock"&gt;&lt;/div&gt;
  
  &lt;br /&gt;
  &lt;div id="display"&gt;
    &lt;!--sauron--&gt;
  &lt;/div&gt;
&lt;/div&gt;</pre>

<pre class="lang:css EnlighterJSRAW " title="style kontenerów">#line0, #line1, #line2{
	color: black;
	font-size: 28px;
}
#line0, #line2{ background: rgba(255,255,255,0.5);}
#line0 { font-size: 52px; }
#line1 { background: rgba(200,200,255,0.5); }

.small{
	font-size: 32px;
}

#weather_now, #smog, #weather_next, #date_sun{
	display: inline-block;
}</pre>

I funkcja pobierająca i renderująca dane (tak jak syncTime dodana w setInterval):

<pre class="lang:js EnlighterJSRAW ">function getWeather(){
  $.get( "/weather/weather.js", function( data ) {
    d=jQuery.parseJSON(data);
    txt="";
    $(d.weather).each(function( index ) {
    txt+="&lt;img src='http://openweathermap.org/img/w/"+this.icon+".png' /&gt; "+this.main+"&nbsp;"
    })
    txt+="| "+d.main.temp+"&deg;C&nbsp;"
    txt+="| "+d.main.pressure+"hPa&nbsp;"
    txt+="| "+d.main.humidity+"%&nbsp;"

    $("#weather_now").html(txt)
  });

  $.get( "/weather/forecast.js", function( data ) {
    d=jQuery.parseJSON(data);
    txt="";
    cnt=6;
    for (var i=0; i&lt;cnt; i++){
    date=new Date(d.list[i].dt_txt)
    date.setHours(date.getHours() + 2);
    txt+=date.getHours()+":00"
    $(d.list[i].weather).each(function( index ) {
      txt+="&lt;img style='height: 1em' src='https://openweathermap.org/img/w/"+this.icon+".png' /&gt;"
    })
    txt+=parseInt(d.list[i].main.temp)+"&deg;C&nbsp;"
    if (i&lt;cnt-1) txt+="|&nbsp;"
    }
    
    $("#weather_next").html(txt)
  });
  
  $.get("/weather/sun.js", function( data ) {
    d=jQuery.parseJSON(data);
    dateSunrise=new Date(d.results["sunrise"])
    dateSunset =new Date(d.results["sunset"])
    date=dateSunrise

    var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var month   = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]


    $("#date_sun").html(
    weekday[date.getDay()]+", "+month[date.getMonth()]+"/"+fmtMin(date.getDate())+" | sun "+
    dateSunrise.getHours()+":"+fmtMin(dateSunrise.getMinutes())+ " - "+
    dateSunset.getHours() +":"+fmtMin(dateSunset.getMinutes())
    );
  });

  $.get("/weather/smog.js", function( data ) {
    d=jQuery.parseJSON(data);
    $("#smog").html(
    "| &lt;span class='small'&gt;"+d.particulates[0].short_name+"&lt;/span&gt;"+
    parseInt(d.particulates[0].value)+""+d.particulates[0].unit
    );
  });
}</pre>

## Podsumowanie i dalsze pomysły

Nadzwyczaj satysfakcjonujące okazało się stworzenie takiej prostej strony w HTMLu ciągnącej dane z kilku API i w miły dla oka sposób wyświetlającej je na dodatkowym ekranie na biurku. Prawdopodobnie do aplikacji będę dodawał kolejne źródła danych, takie jak bardziej inteligentne alerty o stanie systemu lub zastąpię informacje o bieżącej pogodzie danymi z własnego systemu pomiarowego.

&nbsp;

 [1]: https://blog.dsinf.net/2018/02/jeszcze-raz-o-linuksie-na-typowym-tablecie-z-win8-1/
 [2]: http://flipclockjs.com/
 [3]: https://developer.akamai.com/learn/Akamai_Time_Reference/AkamaiTimeReference.html
 [4]: https://github.com/danielskowronski/sauron3
 [5]: https://github.com/danielskowronski/sauron3/blob/master/assets/style.css
 [6]: https://github.com/danielskowronski/sauron3/blob/master/assets/script.js
 [7]: https://openweathermap.org/api
 [8]: https://sunrise-sunset.org/api
 [9]: http://smoksmog.malopolska.pl/
 [10]: https://mitmproxy.org/