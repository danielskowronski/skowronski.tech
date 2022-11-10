---
title: Szybki gotowiec na ochronę przed SQL Injection w PHP
author: Daniel Skowroński
type: post
date: 2013-08-10T18:55:13+00:00
url: /2013/08/szybki-gotowiec-na-ochrone-przed-sql-injection-w-php/
tags:
  - php
  - zabezpieczenia

---
Kod krótki, ale jakże niezbędny.  
<!--break--> Podstawowa wersja podmienia wszystkie zmienne przekazane przez GET i POST: 

<pre class="EnlighterJSRAW php">foreach ($_GET as &$z)  $z = preg_replace('/[^a-zA-Z0-9_ \[\]\.\(\)\{\}\^\@\#\?\!.,&]/s', '', $z);
foreach ($_POST as &$z)  $z = preg_replace('/[^a-zA-Z0-9_ \[\]\.\(\)\{\}\^\@\#\?\!.,&-]/s', '', $z);
</pre>

Regexa (pomiędzy ukośnikami) można dostroić do naszych potrzeb i pokusić się o ładną funkcję, która będzie zależna od typu danych &#8211; coś w rodzaju 

<pre class="EnlighterJSRAW php">function make_string_safe($string, $type){
  $regex_inters = array ( 
    'unsigned_int' => '0-9', 
    'float' => '0-9-,.', 
    'alphanum' => 'a-zA-Z0-9',
    'safe_all' => 'a-zA-Z0-9_ \[\]\.\(\)\{\}\^\@\#\?\!.,&' /* bezpieczne dla zapytań SQL */
  );
  $used_regex_inter = $regex_inters[$type];
  return preg_replace('/[^'.$used_regex_inter.']/s', '', $string);
}
</pre>

Pewną modyfikacją byłoby zmienienie parametru 

<pre style="display: inline !important;">$string</pre>

na 

<pre style="display: inline !important;">&&#36;string</pre>

i w ostatniej linii funkcji zmiana z 

<pre style="display: inline !important;">return...</pre>

na 

<pre style="display: inline !important;">&#36;string=...</pre>

(przekazanie przez referencję).