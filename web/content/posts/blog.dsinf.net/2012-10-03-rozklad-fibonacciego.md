---
title: Rozkład Fibonacciego
author: Daniel Skowroński
type: post
date: 2012-10-03T21:34:37+00:00
excerpt: 'Proste zadanie z zeszłorocznej OI - rozkład Fibonacciego. Naszym zadaniem jest przedstawić minimalną liczbę dodawań lub odejmowań gdzie składnikami są tylko wyrazy ciągu Fibonacciego dla wskazanej liczby. Jest to przykład, że niektóre zadania można, a nawet trzeba rozwiązywać metodą siłową. Ale problem nie tkwi w algorytmie...'
url: /2012/10/rozklad-fibonacciego/
tags:
  - algorytmika
  - c++
  - matematyka

---
Proste zadanie z zeszłorocznej OI - rozkład Fibonacciego. Naszym zadaniem jest przedstawić minimalną liczbę dodawań lub odejmowań gdzie składnikami są tylko wyrazy ciągu Fibonacciego dla wskazanej liczby. Jest to przykład, że niektóre zadania można, a nawet trzeba rozwiązywać metodą siłową. Ale problem nie tkwi w algorytmie...

Przykładowe dane:

<pre class="EnlighterJSRAW bash">10=5+5
19=21-2
17=13+5-1
1070=987+89-5-1</pre>

Liczby wejściowe to maksymalnie 1e17, więc najmniejszy większy lub równy wyraz ciągu Fibonacciego ma numer 88 i wynosi 1100087778366101931. Tą wielkosć można łatwo uzyskać z [Wikiźródeł][1] - tam jest prawie wszytsko.  
Ale jak uzyskać takie dane podczas warunków olimpijskich? Bardzo prosto - przez Pythona. OI odbywa się na maszynach z Ubuntu, a więc interpreter Pythona tam jest. A jak Pythona nie ma to zawsze zostaje C++ i liczenie na typie 

<pre class="EnlighterJSRAW cpp">unsigned long long</pre>

dla pewności.  
Osobiście ztablicowałem ciąg Fibonacciego napychając strukurę statycznie do pliku przez krótki skrypcik:

<pre class="EnlighterJSRAW python">wyraz1=0
wyraz2=1
for i in range(1, 101):
    if (i>1):
        wyraz1, wyraz2 = wyraz2, wyraz1
        wyraz2=wyraz2+wyraz1
    print("Tfib["+str(i-1)+"]="+str(wyraz2)+";")
</pre>

Wszystko działa dzięki temu, że Python domyślnie sumę/różnicę bardzo dużych liczb przedstawia precyzyjnie, a nie przybliżenie na dodatek w notacji wykładniczej (co dzieje się przy mnożeniu). Czy można inaczej uzyskać dostęp do n-tego wyrazu ciągu? Ależ oczywiście, można na przykład:

  * zrobić funkcję fib(liczba) i wywoływać ją za każdym razem
  * korzystać z cudownego wzoru, na który dowód jest na wikipedii:<img decoding="async" src="http://upload.wikimedia.org/math/5/7/e/57eaa418ea8df41ac1473eb5430ca6c9.png" /> 
  * wprowadzić ztablicowane przedziały w celu przyspieszenia wybierania przedziału w którym należy szukać wyrazu ciągu, ale stąd już tylko krok do pełnego ztablicowania

Jednak w tym zadaniu chyba trzeba było odkryć, że można je łatwo zrobić siłowo.

Dalej mamy pętlę szukającąnajbliższego wyrazu ciągu:

<pre class="EnlighterJSRAW cpp">int znajdz_najblizszy2(int liczba, int beg=0, int end=88){
int a=0;
	while (a&lt;50){
		a++;
		if (Tfib[beg]==liczba) return Tfib[beg];
		if (Tfib[end]==liczba) return Tfib[end];


		if ((beg-end)==1 || (beg-end)==-1)
			if ((liczba-Tfib[beg])&lt;(Tfib[end]-liczba)) return Tfib[beg];
			else return Tfib[end];	

		if (Tfib[beg+(end-beg)/2]>=liczba) end=beg+(end-beg)/2;
		else beg=beg+(end-beg)/2;
	}
}
</pre>

Tutaj brak komentowania linii się na mnie zemścił, bo nie mam 100% pewności, co while(a<50) robi, ale to raczej ograniczenie zagłębienia, bo maksimum wynosi log(2)(88) co się równa około 7. Tak generalnie z while'a można zrezygnować, gdyż zawsze trafimy na zadany przedział o długości 2. Ale przezorny zawsze ubezpieczony ;)  
Sama funkcja po prostu dzieli w kółko przedział na mniejsze, podobnie jak robi to quicksort, z kilkoma różnicami:

  1. nie jest to metoda rekursywna
  2. nie swap'uję wartości, a jedynie czekam, aż będą dwie - wówczas wybieram "bliższą" liczbie zadanej

Ostatnim krokiem jest główna pętla programu, razem z we/wy i wczytaniem do pamięci tablicy ciągu:

<pre class="EnlighterJSRAW cpp">zaladuj_fib();
int p; int l; int k;//p - liczba liczb do obliczenia, l - liczba, k -liczba kroków
int tmp;
for (cin>>p;p>0;p--){
	cin>>l;
	k=0;
	while (l!=0){
		tmp=znajdz_najblizszy2(abs(l));
		if (l&lt;0) l+=tmp;
		else l-=tmp;
		k++;
	}
	cout&lt;&lt;">>>"&lt;&lt;k&lt;&lt;endl;
}
</pre>

Po prostu najpierw szukamy najbliższej liczby w ciągu (ale musi to być <u>wartość bezwzgledna</u>!), a potem robimy:

  * jeśli liczba (l) jest większa od zera to odejmujemy najbliższy wyraz
  * jeśli liczba jest mniejsza od zera to dodajemy tenże wyraz (dążymy do zera)
  * jeśli już jest zerem to po prostu koniec

Wsytarczy zliczyć liczbę kroków i zadanie rozwiązane. [Całościowe rozwiązanie w C++][2].

 [1]: http://pl.wikisource.org/wiki/Ci%C4%85g_Fibonacciego
 [2]: http://blog.dsinf.net/wp-content/uploads/2012/10/rozklad_fibonacciego.txt