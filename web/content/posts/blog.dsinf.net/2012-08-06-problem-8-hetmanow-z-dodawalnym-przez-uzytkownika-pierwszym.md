---
title: Problem 8 hetmanów z dodawalnym przez użytkownika pierwszym
author: Daniel Skowroński
type: post
date: 2012-08-06T09:45:16+00:00
url: /2012/08/problem-8-hetmanow-z-dodawalnym-przez-uzytkownika-pierwszym/
tags:
  - algorytmika
  - c++

---
Problem, a raczej ćwiczenie programistyczne jest dość szeroko znany - jak ustawić na kwadratowej szachownicy 8x8 dokładnie 8 hetmanów tak, żeby się nie "biły" lub "widziały" tj. żeby w każdej kolumnie, wierszu i skosie był maksymalnie jeden hetman. Moje rozwiązanie problemu postanowiłem poszerzyć o możliwość podania przez użytkownika pozycji pierwszego hetmana - pozwala to ukazać realną pracę algorytmu oraz zgłębić problem rekurencji z powrotami.  
Jeśli spojrzeć na aspekt definiowalnego przez użytkownika pierwszego hetmana to jest to pionerski algorytm, gdyż w momencie tworzenia na pewno nie był dostępny albo był bardzo trudno dostępny w Internecie.

Mamy funkcję sprawdzającą każdą kolumnę w podanym wierszu pod kątem możności wstawienia tu hetmana. Przebieg pracy algorytmu jest następujący:  
1.Dla każdej kolumny sprawdź  
&nbsp; a)czy ta kolumna jest już zajęta?  
&nbsp; b)czy ten skos "lewo-góra" jest już zajęty? <=> czy suma x+y już wystąpiła?  
&nbsp; c)czy ten skos "prawo-góra" jest już zajęty <=> czy różnica x-y już wystąpiła?  
2.Jeśli coś pasuje to zejdź w dół rekurencji (funckcja(wiersz+1)).  
3.Jeśli w tym wierszu doszliśmy do ostatniej kolumny i nie udało się znaleźć dobrego pola to wynurz się z rekurencji, czyli zrób powrót. Wart zauważyć, że ten powrót skoczy do następnej obrabianej kolumny w poprzednim wierszu. Np.: w wierszu 7 wybraliśmy pole 3, wywołaliśmy rekurencyjnie funkcję od wiersza 8, ale nie ma tam wolnych kolumn więc wracamy do wiersza 7 i zaczynamy obrabianie od kolumny 4 do 8.

Zakańczanie jest warte chili uwagi, bowiem, gdybyśmy nie przerwali po dojściu do wiersza n+1 (n to ilość wierszy) to nastąpiłoby pełne wycofanie rekurencji do zerowego wiersza. Dlatego należy wówczas przerwać, wyrysować wynik i wyjść z programu.

Poniżej funkcje "jądra" programu, reszta struktur i metod (głównie rysujących) dostępne są [tutaj][1] pod licencją GNU/GPL v2.

```c++
int hetmany[31];
int wierszPierwszego = 0;//userinput lock for excute - prevents from changing
bool ok;

bool czyMozna(int kolumna, int wiersz)
{
    if (hetmany[wiersz] != -1) return false; //czy wiersz

    for (int i =0;i&lt; ileWierszy; i++)
    {
        if ((hetmany[i] != -1) && (hetmany[i] == kolumna)) 
		return false;//dwutest: kolumna 
    }

   for (int i =0;i&lt; ileWierszy; i++)
   {
       if ((hetmany[i] != -1) &&  (((kolumna+wiersz) == (i+hetmany[i]) ))) 
	return false;//skosy
       if ((hetmany[i] != -1) && (kolumna-wiersz == hetmany[i]-i) ) 
	return false;
       
   }

	return true;
}

void wstawHetmana(int wiersz)
{

    if (wiersz > (ileWierszy-1)) rysujSzachownice();//wiersz 8 --> rysuj, 
						    //potem /dosyc nieelegancko/ dozeruj
     else if (wiersz==wierszPierwszego) 
     {         
         if ((wiersz == (ileWierszy-1)) && (czyMozna(hetmany[wierszPierwszego], wierszPierwszego))) {}
         else {wstawHetmana(wiersz+1);}
     }
    else
    {
         
    for (int i=0; i &lt; ileWierszy; i++)//musi wejsc dodatkowy raz, 
				    //zeby nie zdazyl przerobic wszystkiego na -1
    {
       
        if (czyMozna(i, wiersz))
        {

            if (!(wierszPierwszego == wiersz)) {hetmany[wiersz] = i; }
            ok = true;
            hetmany[wiersz] = i;
            if (!(wiersz+1 == wierszPierwszego))  {wstawHetmana(wiersz+1); }
            else wstawHetmana(wiersz+2);
            hetmany[wiersz] = -1;
          if (!(wierszPierwszego == wiersz)) {hetmany[wiersz] = -1; }
            
        }
       }

    if ((wiersz==0)||(wiersz==(ileWierszy-1) )&&(!ok))
         {
             pozegnanie("nie ma rozwiazania");
         }
    ok = false;

    }
}
```

 [1]: /wp-content/uploads/2012/08/hetmaty.cpp_.txt