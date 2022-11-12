---
title: Absolutne centrowanie pionowe w HTML (nawet bez CSS)
author: Daniel Skowroński
type: post
date: 2013-08-19T18:52:19+00:00
url: /2013/08/absolutne-centrowanie-pionowe-w-html-nawet-bez-css/
tags:
  - html

---
Długo można szukać w sieci odpowiedzi na pytanie "jak wycentrować tekst w pionie?".  
A rezultat? Mijaki na statyczny tekst, super skrypty korzystające z jQuery do zmiany marginesów, nieładne cosie oparte na _table-cell_ (http://stackoverflow.com/questions/4180594/vertical-centering-of-a-horizontal-scrolling-div), _top: 50%;_ (http://www.werockyourweb.com/css-vertically-horizontally-center)...  
<!--break-->

  
podczas gdy istnieje rozwiązanie, może mniej eleganckie ale zato skuteczne i działające **nawet w IE** - <u>tabelka</u>.

Brzmi jak wstęp do starożytnej szkoły HTMLa (no dobra - średniowiecznej, bo w starożytności uczono frame'ów), czyż nie?

Jak wygląda kod wycentrowania napisu na całą stronę (np. komunikat błędu, strona zastępcza itp.)? A tak:

<pre class="EnlighterJSRAWphp">



<table height="100%" width="100%">
  <tr>
    <td align="center">
      coś, co ma być w środku
      </tr>
    </td></table>
    </body>
    </html>
    </pre>
    
    
    <p>
      Przykład (odpowiednio zmiejszony + border):
    </p>
    
    
    <table style="width: 100px !important; height: 100px !important; border: 1px solid black !important; ">
      <tr>
        <td align="center">
          napis</tr>
          
        </td>
        </table>