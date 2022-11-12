---
title: 'C++ – dwa słowa o przesunięciu bitowym (<<=, >>=)'
author: Daniel Skowroński
type: post
date: 2013-06-07T20:59:22+00:00
url: /2013/06/c-dwa-slowa-o-przesunieciu-bitowym/
tags:
  - c++

---
Ten artykuł w ogóle nie zasługuje na miano artykułu. Powiedzmy o nim bardzo krótki wpis. A rzecz jest o niby oczywistej, a jednak bez przykładu nie - stosowaniu przesunięcia bitowego.  
<!--break-->

  
  
Przesunięcie bitowe jak wiadomo przesuwa bity: 00001011<<2 = 00101100, 11110100 >>3 00011110 itd. Problem polega na tym, że to niby operator jednoargumentowy, ale nie działa jak inkrementacja/dekrementacja - sama na samą siebie, zatem 

<pre class="EnlighterJSRAW cpp">int a=123; c&lt;&lt;4;</pre>

nie zrobi nic (tak jak a+2;). Potrzeba ją podstawić na przykład tak:

<pre class="EnlighterJSRAW cpp">a= a&lt;&lt;4;</pre>

lub skrótowo:

<pre class="EnlighterJSRAW cpp">a &lt;&lt;= 4</pre>

To drugie jest dużo ładniejsze - piękny potworek wychodzi - **<<=, >>=** ;-).



<div id="zrodlo">
  źródło: http://
</div>