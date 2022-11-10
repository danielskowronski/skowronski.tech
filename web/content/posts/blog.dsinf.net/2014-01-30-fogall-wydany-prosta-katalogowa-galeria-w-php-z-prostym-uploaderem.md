---
title: FoGall wydany. Prosta katalogowa galeria w PHP z prostym uploaderem
author: Daniel Skowroński
type: post
date: 2014-01-30T20:51:31+00:00
url: /2014/01/fogall-wydany-prosta-katalogowa-galeria-w-php-z-prostym-uploaderem/

---
Trochę poddenerwowany brakiem sensownego webowego skryptu galerii, który by bazował na katalogach systemu plików (wgrywam przez SFTP i oglądam jak są zapisane na dysku), a tym bardziej wyposażonego w jakiś webowy system wgrywania, stworzyłem własny &#8211; **FoGall**.  
W ogólności jest to remix [Simple Metro PHP Gallery][1] odpowiadającego za wyświetlanie obrazków i robienie miniatur z potężnym [Plupload][2]em, który zapewnia łatwe wgrywanie wielu plików za pomocą m.in. HTML5, HTML4, Flasha, Silverlighta i jQuery&#8217;ego. 

&nbsp;&nbsp;&nbsp;&nbsp;Pierwsza zasadnicza zmiana, która była mi potrzebna to możliwość ukrywania zadanych katalogów: normalnie skrypt pokazuje katalogi jako linki do listy ich zawartości, jednak te z <span class="lang:php EnlighterJSRAW  crayon-inline " >$zakazane</span> zostaną pominięte. Ponadto zabronione jest także listowanie ich bezpośredniej zawartości &#8211; dopiero wskazanie ścieżki do podkatalogu katalogu ukrytego, np. /priv/tajna_galeria , wyświetli obrazki.  
&nbsp;&nbsp;&nbsp;&nbsp;Druga korekta to, zbyt proste by działało ale jednak działające, wskazywanie katalogu docelowego do wgrywania plików &#8211; <span class="lang:js EnlighterJSRAW  crayon-inline " >prompt()</span> sprawdzający null&#8217;owość i pustość, jego zawartość idzie potem jako parametr GET lekko zmodyfikowanego skryptu PHP wziętego z katalogu _examples_ Plupload&#8217;a. Ten z kolei weryfikuje podstawową sztuczkę &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline " >&#8222;../&#8221;</span>.  
&nbsp;&nbsp;&nbsp;&nbsp;Cały <span class="lang:default EnlighterJSRAW  crayon-inline " >upload/</span> jest chroniony przez htpasswd. Rozwiązanie na szybko, ale w miarę bezpieczne; w kolejnej wersji będzie zamienione na normalne logowanie z formularza.

Projekt do pobrania z [SourceForge][3].

 [1]: http://metro.windowswiki.info/smpg/
 [2]: http://www.plupload.com/
 [3]: https://sourceforge.net/projects/fogall/