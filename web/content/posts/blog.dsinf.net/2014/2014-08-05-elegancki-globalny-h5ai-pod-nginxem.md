---
title: Elegancki globalny h5ai pod nginxem
author: Daniel Skowroński
type: post
date: 2014-08-05T11:55:58+00:00
summary: "h5ai to lister plików w katalogach dla webserwerów oparty o PHP. Zamiast nudnego `<ul><li>...` produkowanego przez Apache'a, nginxa i całą resztę możemy dostać dowolnie ułożony spis plików (siatka, lista, szczegóły...) z ikonkami, podglądem w colorboxie, kody QR z linkami oraz m.in. filtr. Twórca twierdzi, że żadna specyficzna dla serwera funkcja w tym aliasy (w nginxie <kbd>server { ... }</kbd>  jest już takim aliasem) nie działa. Ma rację, ale dziś pokażę jak mu tę rację odebrać ;)"
url: /2014/08/elegancki-globalny-h5ai-pod-nginxem/
tags:
  - nginx
  - php

---
[h5ai][1] to lister plików w katalogach dla webserwerów oparty o PHP. Zamiast nudnego `<ul><li>...` produkowanego przez Apache'a, nginxa i całą resztę możemy dostać dowolnie ułożony spis plików (siatka, lista, szczegóły...) z ikonkami, podglądem w colorboxie, kody QR z linkami oraz m.in. filtr [patrz: [demo][2]]. Twórca twierdzi, że żadna specyficzna dla serwera funkcja w tym aliasowane katalogi [w nginxie <kbd>server { ... }</kbd> jest już takim aliasem] nie działa. Ma rację, ale dziś pokażę jak mu tę rację odebrać 😉

Żeby nie duplikować wpisów konfigurację nginxa dla h5ai robimy sami. Najpierw zakładamy plik o nazwie np. `h5ai.conf` , który trafia do głównego katalogu z konfigami nginxa (dla ręcznie kompilowanych instancji będzie to zapewne `/opt/nginx/conf` ); zawartość jak następuje:

```cfg
location ~ /_h5ai/ {
	root   /var/www/h5ai/; # ścieżka do wypakowanego h5ai
	autoindex on;
}
location ^~ /_h5ai/server/php/index.php {
	include        fastcgi_params;
	fastcgi_param SCRIPT_FILENAME /var/www/h5ai/_h5ai/server/php/index.php; # ścieżka do index.php należącego do h5ai
	fastcgi_pass   127.0.0.1:9000;
}
```


Uzasadnieniem dla tak brutalnego wskazania index.php są dwa fakty:  
1) ma być na szybko więc nie brudzimy sobie rąk w sprytnych mapowaniach fastcgi dla niepublicznych aliasów  
2) index.php jest tu jedynym żądanym przez użytkownika plikiem

Następnie musimy dodać stosowne wpisy do sekcji server{}, przykładowo dla klasycznego folderu /pub:

```cfg
include /opt/nginx/conf/_h5ai.conf; # pełna ścieżka do konfiga h5ai.conf
location /pub{
	index index.php index.html /_h5ai/server/php/index.php;
}
```


Na sam koniec - najważniejsze - modyfikacja kodu PHP.  
Zmieniamy w pliku `h5ai/_h5ai/server/php/inc/setup.php`  
z `define("ROOT_PATH", normalize_path(dirname(APP_PATH), false));`  
na `define("ROOT_PATH", normalize_path($_SERVER["DOCUMENT_ROOT"], false));`  
co przy zachowaniu ludzkich wartości zmiennych fastcgi powinno działać w 99% wypadków - DOCUMENT_ROOT przekazany do fastcgi jest właściwym katalogiem, którego zawartość chcemy wylistować.

Na sam koniec, rzecz jasna, restartujemy nginxa i gotowe.

Reasumując: dokonując zmiany jednej wartości w kodzie i tworząc jeden plik konfiguracyjny uzyskaliśmy potężne narzędzie listujące pliki w katalogach na nginxie. Na dodatek nie trzeba teraz mnożyć teraz konfigów - wystarczy jeden include i dodanie indexu dla wybranej ścieżki. Działa i jest zrobione porządnie. A samego h5ai warto postawić na każdym serwerze - sprawia wrażenie profesjonalizmu i jest niezastąpiony przy nagłej potrzebie udostępnienia wielu plików.

 [1]: http://larsjung.de/h5ai/
 [2]: http://larsjung.de/h5ai/sample/