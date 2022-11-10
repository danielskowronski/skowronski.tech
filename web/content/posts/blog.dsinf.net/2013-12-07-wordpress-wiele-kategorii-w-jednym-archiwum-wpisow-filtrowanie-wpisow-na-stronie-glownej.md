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
Dwie ciekawostki dotyczące kategorii na WordPressie. Pierwsza to chyba jedyny odpowiednik potężnego dodatku do Drupala _Views_ &#8211; możliwość konstruowania zapytań do artykułów, a druga &#8211; modyfikacja treści prezentowanych na stronie głównej &#8211; jak na WordPressa przystało trzeba to "z palca" dopisać do motywy i rzecz jasna potem go omyłkowo nie zaktualizować.

Aby dodać kolejny id do filtrowania, np. kolejną kategorię zapytanie będzie wyglądało tak: <span class="lang:default EnlighterJSRAW  crayon-inline " >/?cat=1,2,3,4,5,6,7</span>, jeśli bedą to nazwy, nie ID to przecinek zamieniamy w <span class="lang:default EnlighterJSRAW  crayon-inline " >+</span> np. przy tagach. Oczywiście działa to też przy tzw. ładnych linkach <span class="lang:default EnlighterJSRAW  crayon-inline " >/tag/tag_pierwszy+drugi</span>. 

Dodanie filtrowania zaawansowanego może przysporzyć problemów osobom nieobeznanym z edycją kodu motywów WP. Należy przejść do katalogu <span class="lang:default EnlighterJSRAW  crayon-inline " >/wp-content/themes/nazwa_motywu</span> i odnaleźć plik odpowiedzialny za wyświetlanie artykułów na stronie głównej. Zasadniczo powinien być to index.php, ale na 99% będzie tam <span class="lang:default EnlighterJSRAW  crayon-inline " ><div id=&#8221;content&#8221;> <article></span> i następujący po nim kod PHP. Tym co odpowiada za wyświetlenie treści jest 

<pre class="lang:default EnlighterJSRAW " title="kod rozpoczynający parsowanie artykułów " >if(have_posts()){
  while(have_posts()){
   the_post();</pre>

występujący w przeróżnych konfiguracjach. Czasem index.php będzie od razu obsługiwał archiwa i tym podobne, wówczas należy znaleźć takiego _if_&#8217;a albo _else_&#8217;a, które nie doklejają tekstu w rodzaju "archive for". Przed wspomnianym kodem umieszczamy 

<pre class="lang:default EnlighterJSRAW " title="filtrowanie" >$args = array(
  'cat' =&gt; '16',
  'post_type' =&gt; 'post',
  'posts_per_page' =&gt; 6,
  'paged' =&gt; ( get_query_var('paged') ? get_query_var('paged') : 1),
);
query_posts($args);</pre>

Zmienne rzecz jasna można dowolnie zmieniać &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline " >cat</span> można zastąpić przez tag, author lub cokolwiek innego dostępnego w WP; podobnie <span class="lang:default EnlighterJSRAW  crayon-inline " >posts_per_page</span>. Wartość <span class="lang:default EnlighterJSRAW  crayon-inline " >paged</span> jest najciekawsza i lepiej jej nie dotykać, gdyż można nie tylko zepsuć licznik i nawigator stron (na dole strony), ale też samo wyświetlanie atykułów.