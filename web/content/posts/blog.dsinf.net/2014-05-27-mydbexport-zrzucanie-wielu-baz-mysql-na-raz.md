---
title: myDbExport – zrzucanie wielu baz MySQL na raz
author: Daniel Skowroński
type: post
date: 2014-05-27T11:29:57+00:00
excerpt: 'Przy stronach WWW ważne jest zarówno wykonywanie kopii plików jak i baz danych. Te pierwsze często są zabezpieczane przez dostawców hostingu. Warto by mieć lepsze rozwiązanie niż korzystanie do tego z phpMyAdmina, a najlepiej w pełni automatyczne - takie, które można wstawić w crona. I z tej potrzeby narodził się myDbExport.'
url: /2014/05/mydbexport-zrzucanie-wielu-baz-mysql-na-raz/
tags:
  - linux
  - mysql
  - perl

---
Przy stronach WWW ważne jest zarówno wykonywanie kopii plików jak i baz danych. Te pierwsze często są zabezpieczane przez dostawców hostingu. Warto by mieć lepsze rozwiązanie niż korzystanie do tego z phpMyAdmina, a najlepiej w pełni automatyczne &#8211; takie, które można wstawić w crona. I z tej potrzeby narodził się myDbExport.

Można go znaleźć na [about.dsinf.net/products/mde][1] i [SourceForge.][2] 

Działa rzecz jasna pod Linuksem (na upartego można zmienić $cmd i odpalić także na Windowsie). Plik konfiguracyjny config.php zawiera hasła jawnym tekstem, ale przecież katalog obok w systemie plików jest nasz wp-config.php czy coś innego z tymże samym hasłem do bazy danych. Najlepiej umieścić całość w katalogu niepublicznym na naszym hostingu (poza public_html), dodać odpowiedni wiersz do crona (jeśli jest) lub obsłużyć to przez PHP i pozostawić. Od teraz wraz z kopią plików mamy kopie bazy danych.

 [1]: http://about.dsinf.net/products/mde "http://about.dsinf.net/products/mde"
 [2]: https://sourceforge.net/projects/mydbexport "https://sourceforge.net/projects/mydbexport"