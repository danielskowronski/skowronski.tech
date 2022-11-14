---
title: Omijanie spowalniaczy, głupich stron każących kliknąć by kontynuować itp. na przykładzie 3owl’owego cpanelu
author: Daniel Skowroński
type: post
date: 2013-03-08T22:47:14+00:00
url: /2013/03/omijanie-spowalniaczy-glupich-stron-kazacych-kliknac-by-kontynuowac-itp-na-przykladzie-3owlowego-cpanelu/
tags:
  - jquery
  - js
  - userscripts

---
Niektóre serwisy nie lubią jak ktoś im nie płaci, ale, że ich polityka daje niemal wszystkie opcje za free, a płatny jedynie jest support, więcej baz danych i czasem miejsca na serwerach, toteż muszą sobie podenerwować użytkownika, żeby jednak zapłacił. Często jednak ich trudy są nadaremne...  
<!--break-->

  
  
Czasami wystarczy jedynie przestawić jedną zmienną by ładować stronę docelową (kiedy developer postarał się i są jakieś tokeny, czy coś takiego), czasem wystarczy zmniejszyć time, albo po prostu wywołać funkcję, która po upływie czasu się aktywuje, lub... zmienić atrybut z

```css
display: none;

```


na

```css
display: block;

```


Przykładowa implementacja tego śmiesznie prostego skryptu używająca jQuery to:

```js
$('#landing').attr('style', 'display: none');
$('#container').attr('style', 'display: block');

```


O tym jak tworzyć userscripty jest wiele publikacji, np. http://greasemonkey.mozdev.org/authoring.html. Jest jednak jedno ale, dotyczące paranoicznego podejścia do bezpieczeństwa przez Google Chrome. O ile na Firefoxie wystarczy zainstalować Grease Monkey (https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/) to niby w Chrome USy działają od razu. Z jednym problemem - importowanie zewnętrznych skryptów przez @require nie działa. Dlaczego? Bo nie.  
Stąd można zrobić dwie rzeczy:

  * wkleić całe jQuery do kodu (dosyć mocne lenistwo, ale ile taki user.js będzie potem zajmował?!)
  * albo zastosować ładną funkcję ładującą samodzielnie zewnętrzny skrypt

Rzeczona funkcja:

```js
function addJQuery(callback) {
  var script = document.createElement("script");
  script.setAttribute("src", "//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js");
  script.addEventListener('load', function() {
    var script = document.createElement("script");
    script.textContent = "window.jQ=jQuery.noConflict(true);(" + callback.toString() + ")();";
    document.body.appendChild(script);
  }, false);
  document.body.appendChild(script);
}

```


Teraz należy umieścić nasz kod w jakiejś funkcji i wywołać addJQuery(nasza_funkcja). Jedyna zmiana to zamiana dolara na "jQ", ażeby uniknąć konfliktów (np. ktoś już ładował jQuery'ego w innej wersji i się będą gryzły).



mój skrypt publicznie: [http://userscripts.org/scripts/show/161408](http://userscripts.org/scripts/show/161408)


źródło: [http://stackoverflow.com/questions/2246901/how-can-i-use-jquery-in-greasemonkey-scripts-in-google-chrome](http://stackoverflow.com/questions/2246901/how-can-i-use-jquery-in-greasemonkey-scripts-in-google-chrome)
