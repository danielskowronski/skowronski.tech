---
title: Szybka optymalizacja C++ przy wczytywaniu zmiennych
author: Daniel Skowroński
type: post
date: 2012-11-19T23:19:24+00:00
excerpt: Wiele optymalizacji kodu C++ jest łudzących, ale zmiana formatu wczytywania dużej ilości danych nie jest jedną z nich. W końcu to konsola i ekran są najwolniejsze.
url: /2012/11/szybka-optymalizacja-c-przy-wczytywaniu-zmiennych/
tags:
  - c++
  - optymalizacja

---
Wiele optymalizacji kodu C++ jest łudzących, ale zmiana formatu wczytywania dużej ilości danych nie jest jedną z nich. W końcu to konsola i ekran są najwolniejsze.

Większość operacji we/wy na konsolę w C++, zwłaszcza tych w interakcji z użytkownikiem, wykonywanych jest przez _cin_ i _cout_. Operacje na tych strumieniach nie są oszałamiająco szybkie, lecz zestawiwszy to z czasem reakcji użytkownika zdecydowanie akceptowalne. Zwłaszcza, że są wygodne w użyciu.  
Część programistów jednak i w programach o których z góry wiadomo, że wczytują dość dużo danych z konsoli nadal ich używa. Dwie metody z klasyczego C: **scanf** oraz **printf** są zdecydowanie szybsze. Scanf jest o tyle ciekawy, że można na raz wczytać kilka zmiennych definiując ich format, czy długość. Printf będzie istotny tam, gdzie chcemy np. dodać tłumaczenia a zmienne mają być w różnych miejscach lub formatach, np:

<pre class="EnlighterJSRAW cpp">#include &lt; stdio.h >
/* */
float score; string name, rank;
if (lang=="en")
  printf("Hi %s, your score is %f. Your rank is %s. Congratulations", name, score, rank);
else if (lang=="pl")
  printf("Cześć %s, Twój wynik to %0.3f. Gratulacje, Twoja ranga to teraz %s!", name, score, rank);
</pre>

Jak widać można zformatować nie tylko kolejność stringów, ale także format liczb. Dokładnie rozpisane jest to na [tej stronie][1]. 

Ale wróćmy do meritum, czyli wydajności. Poniższy kod został użyty do testowania na maszynie x86_64, na standardowe wejście przekazałem plik składający się ze 100'000 linijek z wartością 100000:

<pre class="EnlighterJSRAW cpp">#include &lt; iostream >
#include &lt; cstdlib >
#include &lt; time.h >
#include &lt; stdio.h >
#include &lt; sys/timeb.h >

using namespace std;
long long int t1,t2;

void strumieniowo(){
	int zmienna;
	for (int i=0; i&lt; 50000; i++) cin >> zmienna;
}
void skanf(){
	int zmienna;
	for (int i=0; i&lt; 50000; i++) scanf("%d", &zmienna);
}

long long int czas(){
	struct timeb tmb;
	ftime(&tmb);
	return tmb.time*1000+tmb.millitm;
}

int main(){
	srand((unsigned)time(NULL));
	struct timeb tmb;
	cout&lt;&lt;"STREAM:  ";
	t1=czas();
	strumieniowo();
	t1=czas()-t1;
	cout&lt;&lt; t1&lt;&lt; "ms"&lt;&lt; endl;
	t2=czas();
	skanf();
	t2=czas()-t2;
	cout&lt;&lt; "SCANF:   "&lt;&lt; t2&lt;&lt; "ms"&lt;&lt; endl;
	return 0;
}
</pre>

Wyniki są zatrważające: **strumieniowe wczytanie zajmowało średnio 94ms, podczas gdy klasyczne 32ms**.  
I to często jest ostatni krok do" wzorcówki" na OI 😉

 [1]: http://www.mkssoftware.com/docs/man1/printf.1.asp