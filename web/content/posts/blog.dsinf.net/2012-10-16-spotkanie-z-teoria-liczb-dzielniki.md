---
title: Spotkanie z teorią liczb – dzielniki.
author: Daniel Skowroński
type: post
date: 2012-10-16T21:23:13+00:00
url: /2012/10/spotkanie-z-teoria-liczb-dzielniki/
tags:
  - algorytmika
  - c++
  - matematyka

---
  
  
  
Artykuł ten zacznę od małego wprowadzenia, żeby uporządkować to, co wiemy.  
Metoda rozkładu liczb na czynniki pierwsze to sito Eratostenesa (nie Erastotenesa - do tej pory zdaje się, że używałem błędnego imienia za co przepraszam). Skoro mowa o człowieku to warto wspomnieć, że poza oczywistem faktem, że był filozofem (jak każdy kto myślał w starożytnej Grecji) to jest także odpowiedzialny za obwód Ziemii, pewne odległości w astronomii. Obwód naszej planety obliczył dość ciekawie - przez różnicę długości cienii i założenie, że Słońce jako bardzo odległe to między mało odległymi miejscami rzuca nieomal równoległe promienie.  
Ale wróćmy do sita.  
Najpierw jakoś tablicujemy wszystkie liczby w naszym zbiorze. Może ku temu posłużyć tablica zmiennych typu boolean domyślnie wyzerowana na True. Dla każdej liczby od 2 do pierwiastka z maksimum tj. granicy zadanego zbioru wykonujemy wykreślanie: wykreślamy wszystkie jej wielokrotności poza nią samą, nie przejmując się, że niektóre wykreślimy dwukrotnie. Wykreślaniem może być na przykład przypisanie False. Teraz wystarczy wypisać wszystkie niewykreślone.  
  
Przykładowa implementacja:

```c++
#include < iostream >
using namespace std;
const int granica = 100;
bool tab[n + 1];  
int main()
{
    for (int i = 2; i*i <= n; i++ ) //od 2 do sqrt(n), 0 i 1 nie są pierwsze, poza tym przez 0 nic się nie dzieli ;)
    {
        if (!tab[i]) //jeśli już wykreśliliśmy (jako wielokrotność liczby mniejszej)
            continue; //to wszystkie wielokrotności tej liczby są już wykreślone i nie mamy co robić
        for (int j = 2 * i ; j <= n; j += i) // przejdź od liczby 2 * i do n przesuwając się o i
            numbersTable[j] = true; // i każdą z nich usuwaj ze zbioru
    }
 
    cout << "Liczby pierwsze z przedziału od 2 do " << n << ":" << endl;
 
    for (int i = 2; i <= n; i++) // przeszukaj liczby od 2 do n
        if (numbersTable[i]) // jeśli liczba nie została usunięta ze zbioru
            cout << i << endl; // to ją wypisz
//funkcja Skowrońskiego
    int q; cin>>q;
    return 0;
}
```

Jedyne, co rzuca się w oczy to tzw. **funkcja Skowrońskiego**. Jest to jak najbardziej nieoficjalne, niewiążace określenie - po prostu lokalny protest przeciwko ludziom, którzy z nieznanych przyczyn piszą zamiast już nawet tego obrzydliwego <kbd>getch();</kbd> takiego potworka:

```c++
system("PAUSE");
return EXIT_SUCCESS;
```

Po pierwsze kod na Linuksie się wywali (command not found), a druga linijka jest objawem posiadania sporej ilości czasu, bo EXIT_SUCCESS to tylko <kbd>#define</kbd> o wartości 0;

Zajmijmy się teraz tym co możemy zrobić z tymi czynnikami, a więc ich sumą i iloczynem.  
Za **sumę dzielników** odpowiada **funkcja $ \sigma $**. Jak wiadomo "każda nieznana litera alfabetu greckiego w matematyce otrzymuje kryptonim roboczy <u>sigma</u>". "Z tym, że to akurat jest sigma". Prosty przykład zanim przejdę do dłuższych wywodów: ?(8)=1+2+4+8;  
Zdefiniujmy liczbę naturalną n (parametr dla $ \sigma $ (n)) jako $ n = p\_1^{\alpha\_1} \ast p\_2^{\alpha\_2} \ast ... \ast p\_i^{\alpha\_i} $  
, gdzie $ p\_i $ to czynnik pierwszy danej liczby (a $ \alpha\_i $ to liczba jego wystąpień w rozkładzie na czynniki pierwsze).  
Każdy dzielnik można przedstawić jako $ d=p\_1^{\lambda\_1} \ast p\_2^{\lambda\_2} \ast ... \ast p\_i^{\lambda\_i} $, $ 0 \le \lambda\_i \ge \alpha\_i $.  
Różnym ilościom występowania czynników pierwszych w rozkładzie liczby naturalnej - $ \lambda\_1 $ do $ \lambda\_k $, więc $ \sigma(n) = \sum p\_1^{\lambda\_1} \ast p\_2^{\lambda\_2} \ast ... \ast p\_k^{\lambda\_k} $, stąd wynika, że:  
<font color="blue">$ \sigma(n) = \sum \frac{p_i^{\alpha_i+1}-1}{p_i-1} $</font>  
Kod funkcji bazującej na tablicy liczb pierwszych:

```c++
int dzielniki[sqrt(n)]; for (int i=0; i < n; i++) dzielniki[i]=0;

for (int i=2; i*i < =n; i++){
	if (numbersTable[i]){
		while((n%i)==0 || n!=1){
			n%=i;
			dzielniki[i]++;
		}
	}
}

int suma=0;
for (int i=2; i< sqrt(n); i++){
	suma+=( (pow(i, dzielniki[i]+1) -1) / (i - 1));
}
```

Jeśli wiemy, że liczba główna jest kwadratem jakiejś liczby naturalnej to wówczas suma jest liczbą nieparzystą - wynika to z dłuższego dowodu, wynikającego po części z ich liczby w takiej sytuacji - $ 2n+1 $: dzielniki od 1 do $ sqrt{x} $ (bez) i od tejże liczby bez niej do $ x $ - jest ich po tyle samo, a poza tym dzielnikiem jest jeszcze samo $ sqrt{x} $.

**Iloczyn** tych dzielników jest sprawą ciewaką. Wyrażona jest funkcją $ \tau $ (tau lub częściej spotykana nazwa angielska _divisor function_ stąd <u>d(n)</u>) przybiera formę wzoru $ \tau(n) = \sum (a_i + 1) $, czyli jest to iloczyn powiększonych o jeden ilości dzielników. Np. $ n = 28 = 2^2+3^0+5^0+7^1;\n \tau(28) = (2+1)\*(0+1)\*(0+1)\*(1+1) = 3\*1*2 =6 $  
  
Funkcja ta ma dość ciekawy wykres:  
![](http://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Divisor.svg/600px-Divisor.svg.png) 

```c++
int iloczyn=1;
for (int i=2; i < sqrt(n); i++){
	if (dzielniki[i]==0) continue;//*(0+1) tylko marnuje czas
	iloczyn*=(dzielniki[i]+1);
}
```