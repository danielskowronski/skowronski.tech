---
title: Grafana bez logowania wystawiona na świat, ale z filtrowaniem IP
author: Daniel Skowroński
type: post
date: 2019-03-05T09:18:22+00:00
url: /2019/03/grafana-bez-logowania-wystawiona-na-swiat-ale-z-filtrowaniem-ip/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/03/AppLogo_Grafana.png
tags:
  - grafana
  - proxy
  - sysadmin

---
Podczas tworzenia strony z metrykami w Grafanie którą chciałem wyświetlać w kilku miejscach w mojej sieci (m.in. na &#8222;stronie admina&#8221; która oprócz linków do wewnętrznych systemów ma też kilka wykresów) dotarłem do problemu niezbyt popularnego ale mimo wszystko występującego. Grafana sama z siebie posiada tryb [auth.anonymous][1], który tworzy możliwość podglądu danych bez zalogowania, ale wystawienie takowego na świat ma 2 problemy &#8211; ujawniamy dane i umożliwiamy zajechanie serwera przez złych ludzi w Internecie &#8211; od prymitywnego ładowania maksymalnie długich zakresów na dashboardach po wykonywanie własnych kwerend na naszych datasource&#8217;ach &#8211; a więc nawet Postgresie.

Żeby tego uniknąć chciałoby się do _auth.anonymous_ dodać jakiś filtr adresów IP. Ale Grafana nie ma takiej możliwości. Skorzystamy zatem z zaawansowanych funkcji reverse proxy w Caddym. Cały setup wykorzystuje poza tym ZeroTiera (którego [jakiś czas temu opisywałem][2]) do dostarczenia prywatnej sieci dostępowej. Całość wygląda tak:

  * Grafana stoi na lokalnym porcie, niedostępnym z internetu
  * Caddy robi standardowe reverse proxy (transparent) na domenę dostępną z internetu &#8211; powiedzmy _grafana.example.org_
  * Poza tym mamy drugą instancję domeny z reverse proxy która dodaje nagłówki do obsługi proxy level auth na innej domenie &#8211; np. _grafana.intranet.example.com_; ta domena powinna być rozwiązywalna do adresu prywatnego!
  * Grafana ma użytkownika z rolą _viewer_ który jest &#8222;autoryzowany&#8221; i &#8222;logowany&#8221; przez reverse proxy dla prywatnej sieci, w przykładzie poniżej jest to _readonly_

**Caddyfile** potrzebuje zatem takiej sekcji:

<pre class="EnlighterJSRAW" data-enlighter-language="raw" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">grafana.intranet.example.com:80 {
  proxy / http://localhost:3333 {
    transparent
    header_upstream X-GrafanaUser readonly
  }
  ipfilter / {
    rule allow
    ip 192.168.88.1/24
  }
}</pre>

  * Niestety certyfikatu z Let&#8217;s Encrypt nie uzyskamy &#8211; domena musi być routowalna z całego internetu
  * Port _3333_ to port na którym słucha serwer Grafany
  * _192.168.88.1/24_ to nasz prywatny subnet
  * _X-GrafanaUser_ to header autoryzacyjny, który musi matchować z grafana.ini; w najprostszej wersji może tam być zahardkodowany nasz użytkownik z rolą _viewer_

Natomiast w pliku **grafana.ini **potrzeba takiej modyfikacji sekcji:

<pre class="EnlighterJSRAW" data-enlighter-language="raw" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">grafana.intranet.example.com:80 {
  proxy / http://localhost:3333 {
    transparent
    header_upstream X-GrafanaUser readonly
  }
  ipfilter / {
    rule allow
    ip 192.168.88.1/24
  }
}</pre>

Gdzie _header_name_ musi matchować z _header_upstream_ z Caddyfile, a whitelist pozwalać tylko na adres IP serwera Caddy który łączy się z Grafaną (a więc loopback).

Przy założeniu że nasza sieć prywatna jest naprawdę prywatna, jej użytkownicy naprawdę zaufani (możemy to być na przykład tylko my jako jej właściciele) oraz że Grafana nie zawiera naprawdę poufnych danych setup można uznać za względnie bezpieczny.

 [1]: http://docs.grafana.org/auth/overview/#anonymous-authentication
 [2]: https://blog.dsinf.net/2017/02/zerotier-czyli-software-defined-network-czyli-alternatywa-dla-klasycznego-vpna/