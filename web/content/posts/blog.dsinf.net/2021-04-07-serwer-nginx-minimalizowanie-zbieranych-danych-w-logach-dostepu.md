---
title: Serwer nginx – minimalizowanie zbieranych danych w logach dostępu
author: Daniel Skowroński
type: post
date: 2021-04-07T21:00:51+00:00
excerpt: Kończąc opisane dwa miesiące temu zmiany w polityce prywatności (https://blog.dsinf.net/2021/02/niedawne-ulepszenia-prywatnosci-uzytkownikow-blog-dsinf-net-i-foto-dsinf-net/), skończyłem projekt usuwania zbędnych danych z logów dostępu nginxa. Opiszę pokrótce gotowy fragment pliku konfiguracyjnego serwera i pokażę, jak skonfigurować Promtaila, żeby przetwarzał logi w nowym formacie.
url: /2021/04/serwer-nginx-minimalizowanie-zbieranych-danych-w-logach-dostepu/
featured_image: https://blog.dsinf.net/wp-content/uploads/2021/04/nginx.jpg
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1
tags:
  - logi
  - loki
  - nginx
  - privacy
  - promtail

---
Kończąc opisane dwa miesiące temu zmiany w polityce prywatności (<https://blog.dsinf.net/2021/02/niedawne-ulepszenia-prywatnosci-uzytkownikow-blog-dsinf-net-i-foto-dsinf-net/>), skończyłem projekt usuwania zbędnych danych z logów dostępu nginxa. Opiszę pokrótce gotowy fragment pliku konfiguracyjnego serwera i pokażę, jak skonfigurować Promtaila, żeby przetwarzał logi w nowym formacie.

W nginxie dyrektywa `access_log` (i często towarzysząca `log_format`) mogą być zdefiniowane na poziomie bloku `http` lub `server`. W moim wypadku są to globalne ustawienia dla wszystkich wirtualnych hostów i wygląda następująco:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">map $remote_addr $remote_addr_anon {
  ~(?P&lt;ip>\d+\.\d+\.\d+)\.    $ip.0;
  ~(?P&lt;ip>[^:]+:[^:]+):       $ip::;
  127.0.0.1                   $remote_addr;
  ::1                         $remote_addr;
  default                     0.0.0.0;
}

map $http_x_forwarded_for $http_x_forwarded_for_anon {
  ~(?P&lt;ip>\d+\.\d+\.\d+)\.    $ip.0;
  ~(?P&lt;ip>[^:]+:[^:]+):       $ip::;
  127.0.0.1                   $http_x_forwarded_for;
  ::1                         $http_x_forwarded_for;
  default                     0.0.0.0;
}

log_format main 
  '[$time_local] $http_host '
  '$remote_addr_anon $http_x_forwarded_for_anon'
  '"$request" $status $body_bytes_sent';

access_log /var/log/nginx/access.log  main;</pre>

Format `main` zawiera absolutne minimum informacji przydatnych dla utrzymania serwera. Są to kolejno:

  * Czas requestu
  * Nagłówek `Host` z żądania, co przydatne jest, jeśli mamy kilka wirtualnych hostów w jednym logu
  * Adresy IP zdalnego hosta i z nagłówka`X-Forwarded-For`, z których usunięto ostatni oktet
  * Metodę HTTP (np. `GET`, `POST`), ścieżkę URL żądania oraz wersję protokołu (np. `HTTP/1.1`)
  * Kod odpowiedzi
  * Ilość przesłanych bajtów odpowiedzi

Usunięcie ostatniego oktetu realizowane jest przez dyrektywy `map`. Gotowiec za: <https://chriswiegman.com/2019/09/anonymizing-nginx-logs/> 

Warto zwrócić uwagę, że względem standardowego formatu logów nginxa nie kolekcjonujemy zbędnych:

  * Pełnych adresów IP
  * Nagłówka `Referrer`, co uniemożliwia śledzenie skąd użytkownik do nas trafił
  * Nagłówka `User-Agent` co anonimizuje używaną przeglądarkę



Jeśli używamy Promtaila do przekazywania logów do centralnego serwera przyda nam się zaktualizowany plik konfiguracyjny do parsowania linii logów:

<pre class="EnlighterJSRAW" data-enlighter-language="yaml" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">scrape_configs:
- job_name: nginx_access
  static_configs:
  - targets:
      - localhost
    labels:
      hostname: "webserver.tld"
      job: nginx_access
      __path__: /var/log/nginx/access.log

  pipeline_stages:
  - match:
      selector: '{job="nginx_access"}'
      stages:
      - regex:
          expression: '^\[(?P&lt;time_local>.*)\] (?P&lt;http_host>[^ ]*) (?P&lt;remote_addr_anon>[^ ]*) (?P&lt;http_x_forwarded_for_anon>[^ ]*) "(?P&lt;method>[^ ]*) (?P&lt;request>[^ ]*) (?P&lt;proto>[^ ]*)" (?P&lt;status>[\d]+) (?P&lt;body_bytes_sent>[\d]+)'
      - labels:
          http_host: 
          method:
          status:</pre>



Efektem zbierania logów przez Promtaila są takie oto dane widoczne w Loki:<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="647" src="https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-1024x647.jpg" alt="" class="wp-image-2210" srcset="https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-1024x647.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-300x190.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-768x485.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-1536x970.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-2048x1294.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]</figure>

 [1]: https://blog.dsinf.net/wp-content/uploads/2021/04/Screenshot-2021-04-07-at-22.55.53-scaled.jpg