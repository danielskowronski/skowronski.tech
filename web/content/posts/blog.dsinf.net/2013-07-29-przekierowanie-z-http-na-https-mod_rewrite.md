---
title: Przekierowanie z HTTP na HTTPS (mod_rewrite)
author: Daniel Skowroński
type: post
date: 2013-07-29T09:59:44+00:00
url: /2013/07/przekierowanie-z-http-na-https-mod_rewrite/
tags:
  - apache2
  - webserver

---
Często chcielibyśmy, żeby użytkownik nie miał szans wysłać danych w plain-text. Można to zrobić dzięki mod_rewrite &#8211; pluginowi Apache&#8217;a domyślnie zitegrowanego z większością instalacji.

<!--break-->

  
Zmiany możemy wprowadzić w głównym konfigu &#8211; /etc/apache2/http.conf &#8211; wówczas docelowe linie wprowadzamy w znaczniku 

<pre class="EnlighterJSRAW bash">&lt;Directory /nasz/katalog/z/witryną>
jakieś  dyrektywy
&lt;/Directory></pre>

Alternatywnie konfig można wprowadzić do pliku **.htaccess** umieszczonego w interesującym nas katalogu &#8211; jedyna opcja przy hostingu.

Typowo przekierowanie powinno wyglądać tak:

<pre class="EnlighterJSRAW bash">RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</pre>

Jednak część serwerów (np. autorski perser htaccessów dla nginxa w MyDevilu) nie rozumieją drugiej linijki prowadząc do pętli przekierowań &#8211; _ERR\_TOO\_MANY_REDIRECTS_. Rozwiązaniem jest zmiana logiki &#8211; nie protokół, a port:

<pre class="EnlighterJSRAW bash">RewriteCond %{SERVER_PORT} ^80$</pre>