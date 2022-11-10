---
title: Możliwe problemy przy aktualizacji PHP pod Suse Linuxem (i nie tylko)
author: Daniel Skowroński
type: post
date: 2013-11-15T19:14:37+00:00
excerpt: Jak udało mi się wykryć pod Suse Linux Enterprise Server (a dokładniej 11 SP2) podczas migraji do PHP 5.3 występują pewne problemy, których wolelibyśmy uniknąć na serwerze produkcyjnym.
url: /2013/11/mozliwe-problemy-przy-aktualizacji-php-pod-suse-linuxem-i-nie-tylko/
tags:
  - apache
  - linux
  - php
  - suse

---
Jak udało mi się wykryć pod Suse Linux Enterprise Server (a dokładniej 11 SP2) podczas migraji do PHP 5.3 występują pewne problemy, których wolelibyśmy uniknąć na serwerze produkcyjnym.

Podczas aktualizacji PHP 5.2 do 5.3 pod SLESem nie aktualizujemy pakietów &#8211; kasujemy stare i instalujemy ich odpowiendiki różniące sie dopiskiem _53_. W różnych dystrybucjach takie rozdrobnienie występuje w innym stopniu. Jednak po kasacji paczki apache2-mod\_php z jednego z konfigów gdzieś w /etc/apache2/ kasowana jest dyrektywa LoadModule, której nie dodaje instalacja apache2-mod\_php53. W związku z tym należy dodać w dowolnym miejscu (najlepiej do tego służy katalog sysconfig.d/ przeznaczony do zmian użytkownika) co następuje:

<pre class="lang:default EnlighterJSRAW " >Include /etc/apache2/conf.d/mod_php5.conf #do upewneinia sie, że mime będą ok
LoadModule /usr/lib64/apache2/mod_php5.so #brakująca biblioteka
</pre>

Po tym wystarczy restart Apache i już pliki PHP się nie &#8222;pobierają&#8221; bo ma je co parsować.