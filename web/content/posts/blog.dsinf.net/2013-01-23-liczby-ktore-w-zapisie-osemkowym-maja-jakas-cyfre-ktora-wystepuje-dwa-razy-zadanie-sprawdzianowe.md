---
title: Liczby, które w zapisie ósemkowym mają jakąś cyfrę, która występuje dwa razy – zadanie sprawdzianowe
author: Daniel Skowroński
type: post
date: 2013-01-23T11:19:02+00:00
url: /2013/01/liczby-ktore-w-zapisie-osemkowym-maja-jakas-cyfre-ktora-wystepuje-dwa-razy-zadanie-sprawdzianowe/
tags:
  - algorytmika
  - c++

---
Ciekawe zadanie programistyczne, które umożliwia stworzenie gotowych funkcji do naszego zbioru. Treść brzmi dziwnie: wypisać liczby, które w zapisie ósemkowym mają cyfrę występującą dokładnie dwa razy. <!--break-->

Po pierwsze musimy zkonwertować na inny zapis.

<pre class="EnlighterJSRAW cpp">string dec2other(int x, int base){
	int l=x,t;
	string napis="";
	while (l){
		t=l%base;
		if (t&lt;10) 
			napis=char(t+48)+napis;
		else 
			napis=char(t+55)+napis;
		l/=base;
	}
	return napis;
}
</pre>

Kod opiera się na dzieleniu modulo i rzutowaniu na znak - dla cyfr większych od 9 potrzeba nam cyfry z hex'a: A,B,C... Warto zauważyć, że należałoby dołożyć jeszcze założenia podobne do tych:

<pre class="EnlighterJSRAW cpp">if (base&lt;2) return "---";
</pre>

oraz w pętli (po bieżącym if /else) w celu obsługi dużych cyfr "po ludzku", a nie kolejnymi w ASCII [, \ ] itd.:

<pre class="EnlighterJSRAW cpp">if (t>35) napis="["+t+"] "+napis;
</pre>

Liczba [54] A567 [36] nie jest zbytnio czytelna. Można zatem zglobalizować zmianę w taki sposób:

<pre class="EnlighterJSRAW cpp">bool big = false;
if (base>35) big = true;

//w pętli:
if (big) napis="["+t+"] ";
else 
    if (t&lt;10) napis=char(t+48)+napis;
    else napis=char(t+55)+napis;
</pre>



Teraz należy sprawdzić warunek z cyframi. Skoro liczba jest już w tablicy znaków (string) to można stworzyć pomocniczą tablicę ilość_występowania(cyfra), a następnie ją sprawdzić pod kątem z treści zadania. Dwie funkcje są alternatywne, ale pierwsza przyjmująca za parametr string obsługuje systemy o ograniczonej podstawie, druga wymaga tablicy kolejnych cyfr. base to podstawa systemu liczenia

<pre class="EnlighterJSRAW cpp">bool czy(string napis, int base){
	int* tab = new int [base]; for (int i=0; i&lt; base; i++) tab[i]=0;
	int tmp;
	
	for (int i=0; i&lt; napis.length(); i++){
		tmp=(int)(napis[i]-48);
		if (tmp >10) tmp-=7;
		tab[tmp]++;
	}
	
	for (int i=0; i&lt; base; i++){
		//obsługa warunku
		if (tab[i]==2){
			return true;
		}
	}
	
	return false;
}


bool czy(int* tab_we, int rozm, int base){
	int* tab = new int [base]; for (int i=0; i&lt; base; i++) tab[i]=0;
	int tmp;
	
	for (int i=0; i&lt; rozm; i++){
		tab[tab_we[i]]++;
	}
	
	for (int i=0; i&lt; base; i++){
		//obsługa warunku
		if (tab[i]==2){
			return true;
		}
	}
	
	return false;	
}
</pre>

Przykładową implementację dla podanego założenia można pobrać [zad5.cpp][1].

 [1]: /wp-content/uploads/2013/01/zad5.cpp_.txt