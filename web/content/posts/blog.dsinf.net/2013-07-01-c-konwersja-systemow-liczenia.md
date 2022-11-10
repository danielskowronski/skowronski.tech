---
title: 'C++: Konwersja systemów liczenia'
author: Daniel Skowroński
type: post
date: 2013-07-01T09:32:13+00:00
url: /2013/07/c-konwersja-systemow-liczenia/
tags:
  - c++
  - matematyka
  - systemy liczenia

---
Jak nauczył mnie tegoroczny konkurs o dziką kartę NMC trzeba zawsze mieć konwerter wszystkich możliwych systemów liczenia,  
bowiem liczenie zadania na 5 konwersji kilkucyfrowych liczb i jednego XORa to wystarczający powód by się lekko zdenerowować 😉  
<!--break-->

Zadanie brzmiało:  
7. Wybierz poprawny wynik operacji 3A995(11) XOR 153262(7)  
a. 799A(17)  
b. 13BB3(13)  
c. B024(15)

Cóż, nie ma co się załamywać, tylko trzeba pisać program i mieć go potem cały czas przy sobie. Kod, który jakiś czas temu powstał  
jest dość prosty i ograniczony do cyfr jako 0..Z i maksymalnym zakresie _long_a (czyli 10 cyfr), jednak dla bezpieczeństwa  
dałem long longa &#8211; nigdy nie wiadomo na czym przyjdzie kompilować kod.

_Talk is cheap, I&#8217;ll show you the code_

Dwa kawałki są najbardziej istotne:  
1.konwersja na dziesiętny: 

<pre class="EnlighterJSRAW cpp">long long ll = 0, a; //a=tmp
char c;
int len = x.length();
for (int i = 0; i &lt; len; i++){
    c = x[len - i - 1];     c = toupper(c);

    if (c >= 48 && c &lt;= 57) a = c - 48;
    else if (c >= 65 && c &lt;= 90) a = c - 55;
    
    ll += a * pow(b, i);
}
return ll;
</pre>

2.konwersja z dziesiętnego

<pre class="EnlighterJSRAW cpp">string w = "                                "; //statyczna dlugosc na 32 - max cyfr w tej specyfikacji
long long c = x; int i = 32; int t;
while (i >= 0){
    t = c % b;
    if (t &lt; 10) w[--i] = 48 + t;
    else w[--i] = 55 + t;

    //czy koniec dzieleń?
    if ((float) (c / b) >= 1) c /= b;
    else break;
}

//utnij spacje poczatkowe
int j;
for (j = 0; j &lt; 32; j++) if (w[j] != ' ') break;
w = w.substr(j);

return w;
</pre>

Całość do pobrania poniżej.



<div id="zrodlo">
  pytanko pojawiło się na: http://www.chip.pl/konkursy/konkurs-wygraj-201edzika-karte201d-na-net-masters-cup
</div>