---
title: Elegancki globalny h5ai pod nginxem
author: Daniel Skowroński
type: post
date: 2014-08-05T11:55:58+00:00
excerpt: "h5ai to lister plików w katalogach dla webserwerów oparty o PHP. Zamiast nudnego &lt;ul&gt;&t;li&gt;... produkowanego przez Apache'a, nginxa i całą resztę możemy dostać dowolnie ułożony spis plików (siatka, lista, szczegóły...) z ikonkami, podglądem w colorboxie, kody QR z linkami oraz m.in. filtr. Twórca twierdzi, że żadna specyficzna dla serwera funkcja w tym aliasy (w nginxie <kbd>server { ... }</kbd>  jest już takim aliasem) nie działa. Ma rację, ale dziś pokażę jak mu tę rację odebrać ;)"
url: /2014/08/elegancki-globalny-h5ai-pod-nginxem/
tags:
  - nginx
  - php

---
[h5ai][1] to lister plików w katalogach dla webserwerów oparty o PHP. Zamiast nudnego <ul><li> produkowanego przez Apache&#8217;a, nginxa i całą resztę możemy dostać dowolnie ułożony spis plików (siatka, lista, szczegóły&#8230;) z ikonkami, podglądem w colorboxie, kody QR z linkami oraz m.in. filtr [patrz: [demo][2]]. Twórca twierdzi, że żadna specyficzna dla serwera funkcja w tym aliasowane katalogi [w nginxie <kbd>server { ... }</kbd> jest już takim aliasem] nie działa. Ma rację, ale dziś pokażę jak mu tę rację odebrać 😉

Żeby nie duplikować wpisów konfigurację nginxa dla h5ai robimy sami. Najpierw zakładamy plik o nazwie np. <span class="lang:default EnlighterJSRAW  crayon-inline " >h5ai.conf</span> , który trafia do głównego katalogu z konfigami nginxa (dla ręcznie kompilowanych instancji będzie to zapewne <span class="lang:default EnlighterJSRAW  crayon-inline " >/opt/nginx/conf</span> ); zawartość jak następuje:

<pre class="lang:default EnlighterJSRAW " >location ~ /_h5ai/ {
	root   /var/www/h5ai/; # ścieżka do wypakowanego h5ai
	autoindex on;
}
location ^~ /_h5ai/server/php/index.php {
	include        fastcgi_params;
	fastcgi_param SCRIPT_FILENAME /var/www/h5ai/_h5ai/server/php/index.php; # ścieżka do index.php należącego do h5ai
	fastcgi_pass   127.0.0.1:9000;
}</pre>

Uzasadnieniem dla tak brutalnego wskazania index.php są dwa fakty:  
1) ma być na szybko więc nie brudzimy sobie rąk w sprytnych mapowaniach fastcgi dla niepublicznych aliasów  
2) index.php jest tu jedynym żądanym przez użytkownika plikiem

Następnie musimy dodać stosowne wpisy do sekcji server{}, przykładowo dla klasycznego folderu /pub:

<pre class="lang:default EnlighterJSRAW " >include /opt/nginx/conf/_h5ai.conf; # pełna ścieżka do konfiga h5ai.conf
location /pub{
	index index.php index.html /_h5ai/server/php/index.php;
}</pre>

Na sam koniec &#8211; najważniejsze &#8211; modyfikacja kodu PHP.  
Zmieniamy w pliku <span class="lang:default EnlighterJSRAW  crayon-inline " >h5ai/_h5ai/server/php/inc/setup.php</span>  
z <span class="lang:default EnlighterJSRAW  crayon-inline " >define(&#8222;ROOT_PATH&#8221;, normalize_path(dirname(APP_PATH), false));</span>  
na <span class="lang:default EnlighterJSRAW  crayon-inline " >define(&#8222;ROOT_PATH&#8221;, normalize_path($_SERVER[&#8222;DOCUMENT_ROOT&#8221;], false));</span>  
co przy zachowaniu ludzkich wartości zmiennych fastcgi powinno działać w 99% wypadków &#8211; DOCUMENT_ROOT przekazany do fastcgi jest właściwym katalogiem, którego zawartość chcemy wylistować.

Na sam koniec, rzecz jasna, restartujemy nginxa i gotowe.

Reasumując: dokonując zmiany jednej wartości w kodzie i tworząc jeden plik konfiguracyjny uzyskaliśmy potężne narzędzie listujące pliki w katalogach na nginxie. Na dodatek nie trzeba teraz mnożyć teraz konfigów &#8211; wystarczy jeden include i dodanie indexu dla wybranej ścieżki. Działa i jest zrobione porządnie. A samego h5ai warto postawić na każdym serwerze &#8211; sprawia wrażenie profesjonalizmu i jest niezastąpiony przy nagłej potrzebie udostępnienia wielu plików.

 [1]: http://larsjung.de/h5ai/
 [2]: http://larsjung.de/h5ai/sample/