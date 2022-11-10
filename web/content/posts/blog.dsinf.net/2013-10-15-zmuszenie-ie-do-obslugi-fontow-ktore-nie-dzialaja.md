---
title: Zmuszenie IE do obsługi fontów, które nie działają
author: Daniel Skowroński
type: post
date: 2013-10-15T19:46:32+00:00
excerpt: 'Czasem czcionki z Google Fonts nie działają z &quot;wspaniałą&quot; przeglądarką Miocrosoftu...  Na szczęście jest sposób by się przed tym ustrzec! &nbsp;&nbsp;'
url: /2013/10/zmuszenie-ie-do-obslugi-fontow-ktore-nie-dzialaja/
tags:
  - html
  - www

---
Czasem czcionki z Google Fonts nie działają z "wspaniałą" przeglądarką Miocrosoftu&#8230;  
Żeby mieć pewność, że IE nie wystrzeli nam z brakiem obsługi niektórych fontów (na jednej stronie jeden mi działał, a drugi &#8211; nie) warto wyposażyć się w czcionkę w formacie EOT (_Embedded OpenType_) i jakimkolwiek normalnym, np. TTF (_True Type Font_ &#8211; natywne w Windows) i stworzyć CSS, podobny do poniższego:

<pre>@font-face {
	font-family: "Andika";
	src: url("/andika-r-webfont.eot") !important;
	src: url("/andika-r-webfont.eot") format('embedded-opentype');
	src: url('/Andika-R.ttf') format('truetype') ;			
}</pre>

Kilka słów wyjaśnienia: EOT jest obsługiwany zdaje się tylko przez IE &#8211; zostanie załadowany najpierw, <u>ale</u> nie wiem czemu bez _!important_ czcionka nie jest ładowana &#8211; może występuje próba użycia wpisu z TTF? Kolejna linijka to zabezpieczenia dla starych wersji IE, które nie radzą sobie z detekcją, co to za typ czcionki i dopiero _last but not the least_ wpis dla "reszty świata" spoza rezerwatu IE. Lepiej dać na wszystkie czcionki niż mieć niespodziankę &#8211; brak zgodności zauważyłem przypadkiem.  
Na koniec przydatny link: online&#8217;owy konwerter czcionek &#8211; http://onlinefontconverter.com/