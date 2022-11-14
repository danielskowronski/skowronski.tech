---
title: 'WordPress: wiele kategorii w jednym archiwum wpisów + filtrowanie wpisów na stronie głównej'
author: Daniel Skowroński
type: post
date: 2013-12-07T16:27:21+00:00
excerpt: 'Dwie ciekawostki dotyczące kategorii na Wordpressie. Pierwsza to chyba jedyny odpowiednik potężnego dodatku do Drupala <i>Views</i> - możliwość konstruowania zapytań do artykułów, a druga - modyfikacja treści prezentowanych na stronie głównej - jak na Wordpressa przystało trzeba to &quot;z palca&quot; dopisać do motywy i rzecz jasna potem go omyłkowo nie zaktualizować.'
url: /2013/12/wordpress-wiele-kategorii-w-jednym-archiwum-wpisow-filtrowanie-wpisow-na-stronie-glownej/
tags:
  - wordpress
  - www

---
Dwie ciekawostki dotyczące kategorii na WordPressie. Pierwsza to chyba jedyny odpowiednik potężnego dodatku do Drupala _Views_ - możliwość konstruowania zapytań do artykułów, a druga - modyfikacja treści prezentowanych na stronie głównej - jak na WordPressa przystało trzeba to "z palca" dopisać do motywy i rzecz jasna potem go omyłkowo nie zaktualizować.

Aby dodać kolejny id do filtrowania, np. kolejną kategorię zapytanie będzie wyglądało tak: `/?cat=1,2,3,4,5,6,7`, jeśli bedą to nazwy, nie ID to przecinek zamieniamy w `+` np. przy tagach. Oczywiście działa to też przy tzw. ładnych linkach `/tag/tag_pierwszy+drugi`. 

Dodanie filtrowania zaawansowanego może przysporzyć problemów osobom nieobeznanym z edycją kodu motywów WP. Należy przejść do katalogu `/wp-content/themes/nazwa_motywu` i odnaleźć plik odpowiedzialny za wyświetlanie artykułów na stronie głównej. Zasadniczo powinien być to index.php, ale na 99% będzie tam `<div id="content"> <article>` i następujący po nim kod PHP. Tym co odpowiada za wyświetlenie treści jest 

```php
if(have_posts()){
  while(have_posts()){
   the_post();
```


występujący w przeróżnych konfiguracjach. Czasem index.php będzie od razu obsługiwał archiwa i tym podobne, wówczas należy znaleźć takiego _if_'a albo _else_'a, które nie doklejają tekstu w rodzaju "archive for". Przed wspomnianym kodem umieszczamy 

```php
$args = array(
  'cat' => '16',
  'post_type' => 'post',
  'posts_per_page' => 6,
  'paged' => ( get_query_var('paged') ? get_query_var('paged') : 1),
);
query_posts($args);
```


Zmienne rzecz jasna można dowolnie zmieniać - `cat` można zastąpić przez tag, author lub cokolwiek innego dostępnego w WP; podobnie `posts_per_page`. Wartość `paged` jest najciekawsza i lepiej jej nie dotykać, gdyż można nie tylko zepsuć licznik i nawigator stron (na dole strony), ale też samo wyświetlanie atykułów.