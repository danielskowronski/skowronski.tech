---
title: Operacje bitowe w prostych funckjach
author: Daniel Skowroński
type: post
date: 2012-12-02T00:25:21+00:00
url: /2012/12/operacje-bitowe-w-prostych-funckjach/
tags:
  - algorytmika
  - c++

---
Operacje bitowe &#8211; dla początkujących to brzmi strasznie. Możemy sumować (OR), mnożyć (AND), odejmować (popularniej ksorować &#8211; XOR), negować (NOT), lub przesuwać bity. Ale dziś dwa zastosowania: podzielność przez 2 bez dzielenia modulo i sprawdzenie, czy liczba jest potęgą dwójki.  
Ale na początek trochę podstaw. Operujemy na dwójkowym zapisie liczb, każdy bit, czyli krótko mówiąc jej cyfra. 0 to fałsz, 1 to prawda, często rozpatrywane w kategoriach bitu ustawionego i nie. Chwilow nie będziemy się zajmować liczbamiujemnymi, które można zapisywać na różne sposoby np. w U2.

**Podzielność przez 2**

<pre class="EnlighterJSRAW cpp">bool parzysta(int liczba){
	return !(liczba&1);
}
</pre>

Kod przeraża prostotą. Równie proste, choć może bardziej czytelne jest

<pre class="EnlighterJSRAW cpp">!(liczba%dzielnik) czyli (liczba%dzielnik)==0</pre>

Podzielność przez 2 w zapisie binarnym jest trywialna: ostatnia cyfra musi być 0 &#8211; nie ma żadnych jedynek dodanych do liczby. Jeśli liczbę, którą sprawdzamy i 1 wymnożymy logicznie to cyfrą isttną będzie ostatnia &#8211; pierwotnie LSB (ang. _least significiant bit_, najmniej znaczący bit). Jeśli będzie zerem, a więc oznaczający parzystość to pomnożny logicznie przez cokolwiek da nam zero, a w przeciwnym wypadku (ostatni bit to 1) da nam jedynkę. Cała reszta liczby &#8211; aż do MSB (_most significiant bit_) się zeruje, gdyż mnożenie czegokolwiek przez 0 da 0.  
Na koniec zostanie nam 0000000000X. Skoro dla parzystej wychodziło X=0 to trzeba jeszcze zanegować wynik i od razu uzyskamy odpowiedź co do parzystości.  
Przykład: 101010110 jest parzysta. 101010110 AND 000000001 = \[1 and 0\]\[0 and 0\]\[1 and 0\]\[0 and 0\]\[1 and 0\]\[0 and 0\]\[1 and 0\]\[1 and 0\] i LSB: [0 and 1] = 000000000, czyli 0, czyli false.

**Sprawdzanie czy liczba jest potęgą dwójki**  
Ta operacja naprawdę pokazuje potencjał operacji bitowych &#8211; nie ma soejego odpowiednika z taką wydajnością.

<pre class="EnlighterJSRAW cpp">bool czyPotegaDwojki(int liczba){
	return (!(liczba & (--liczba)) && liczba);
}
</pre>

Kod znów piękny i nic z niego nie wynika. Ale tylko pozornie.  
&& liczba zapewnia, że liczba jest dodatnia &#8211; jakoś ciężko sobie wyobrazić sqrt(-1) bez typu danych zespolonych i zabawy na U2.

  1. Zakładamy, że gdy liczba & (&#8211;liczba) != 0 to liczba=2^k (k>=0). Pamiętając o jednym z ważnych praw logicznych &#8211; jeśli z prawdy wynika prawda to z nieprawdy wynika nieprawda.
  2. Załóżmy , że gdy x!=2^k to (liczba & (&#8211;liczba)) jest różne od zera. 
  3. Jeśli x!=2^k to co najmniej 2 bity to jedynki (potęgi dwójki to 0, 10, 100, 1000 itd.).
  4. x-1 to x, gdzie idąc od lsb do msb (po ludzku od prawej do lewej) negujemy wszystko do pierwszej jedynki razem z nią (11000 -1 = 10111)
  5. x&(&#8211;x) kończy się zerami, jako, że końcówka aż do pierszej jedynki w x się czyści (z negacji powyżej), 
  6. a pozostałych cyfr jest co najmniej 2 (założenia powyżej) to liczba ta jest różna od zera (XXXXX000000000) CND

Prawda, że proste?