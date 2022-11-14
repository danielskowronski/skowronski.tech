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
Często chcielibyśmy, żeby użytkownik nie miał szans wysłać danych w plain-text. Można to zrobić dzięki mod_rewrite - pluginowi Apache'a domyślnie zitegrowanego z większością instalacji.

<!--break-->

  
Zmiany możemy wprowadzić w głównym konfigu - /etc/apache2/http.conf - wówczas docelowe linie wprowadzamy w znaczniku 

```bash
<Directory /nasz/katalog/z/witryną>
jakieś  dyrektywy
</Directory>
```


Alternatywnie konfig można wprowadzić do pliku **.htaccess** umieszczonego w interesującym nas katalogu - jedyna opcja przy hostingu.

Typowo przekierowanie powinno wyglądać tak:

```bash
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}

```


Jednak część serwerów (np. autorski perser htaccessów dla nginxa w MyDevilu) nie rozumieją drugiej linijki prowadząc do pętli przekierowań - _ERR\_TOO\_MANY_REDIRECTS_. Rozwiązaniem jest zmiana logiki - nie protokół, a port:

```bash
RewriteCond %{SERVER_PORT} ^80$
```
