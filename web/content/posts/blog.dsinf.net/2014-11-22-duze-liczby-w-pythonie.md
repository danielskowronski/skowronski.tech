---
title: Duże liczby w Pythonie
author: Daniel Skowroński
type: post
date: 2014-11-22T19:10:19+00:00
excerpt: |
  Python jest językiem wyjątkowym. Jednym z reprezentantów tej wyjątkowości jest sposób przechowywania liczb.<br />
  Badanie "dokładności", zakresu
url: /2014/11/duze-liczby-w-pythonie/
tags:
  - python

---
Python jest językiem wyjątkowym. Jednym z reprezentantów tej wyjątkowości jest sposób przechowywania dużych liczb.

Liczby zmiennopozycyjne Python przechowuje jak każdy inny język &#8211; cecha i mantysa. Dla liczb liczb całkowitych stosowany jest całkowicie inny sposób przechowywania. Jeżli liczba mieści się w zakresie <span class="lang:python EnlighterJSRAW  crayon-inline " >sys.maxint</span> (czyli 2\*\*63-1 lub 2\*\*31-1 w zależności od bitowości instalacji Pythona) to wszystko jest jak w &#8222;normalnych&#8221; środowiskach C-podobnych. Jednak po czymś w rodzaju &#8222;inta&#8221; nie ma &#8222;longa&#8221; tylko bardziej &#8222;BigInteger&#8221;.

Kiedy wykorzystujemy środowisko do obliczeń wypada poznać zakres i dokładność dostępnych struktu liczbowych.  
Najprostszy pomiar dokładności polega na sprawdzaniu kolejnych potęg 10 na wrażliwość na dodanie jakiejś małej wartości, która nas interesuje &#8211; będzie to _miara dokładności_ &#8211; dla zmiennoprzecinkowych weźmiemy celem przykładu 0.1, a całkowitych najmniejszą możliwą &#8211; 1. (Można zapytać po co sprawdzać dokładność inta &#8211; chcemy zapobiec typowego dla środowisk skryptowych cichego zrzutowania na typ inny niż integer np. double)

W pętli wystarczy teraz mnożyć liczbę razy 10 i porównać wartość zmiennej liczba i (liczba+encjaTestowa). Przykładowy kod w języku, który rozważamy wygląda następująco: 

<pre class="lang:python EnlighterJSRAW " >def czyDokladneFloat(liczba):
	liczba1 = float(liczba)
	liczba2 = float(liczba+0.1)
	return ( float(liczba1) &lt; float(liczba2) )
def czyDokladneInt(liczba):
	liczba1 = int(liczba)
	liczba2 = int(liczba+1)
	return ( int(liczba1) &lt; int(liczba2) )

licznik = 1
dokladna = True
print("Sprawdzam zmiennoprzecinkowe:")
while dokladna:
	liczba = 10**licznik
	dokladna = czyDokladneFloat(liczba)
	print ("10^"+str(licznik)+": "+("NIE" if not dokladna)+"dokładna")
	licznik+=1

licznik = 1
dokladna = True
print("Sprawdzam stałopozycyjne:")
while dokladna:
	liczba = 10**licznik
	dokladna = czyDokladneInt(liczba)
	print ("10^"+str(licznik)+": "+("NIE" if not dokladna)+"dokładna")
	licznik+=100 #+=100 bo inaczej idzie strasznie powoli
</pre>

Castowanie w funkcjach wymusza użycie tego konkretnie typu bez &#8222;sprytnych&#8221; konwersji i ewentualnych operacji na łańcuchach znaków.

Co się okazuje? Maksymalna wartość float&#8217;a dokładnego do 0.1 to 10^16 (podobnie jak w typowych językach kompilowanych i skryptowych), a dla 1 w integerach&#8230; jest **nieskończona**. To znaczy jak poczekamy odpowiednio długo skończy nam się pamięć. 

Oczywiście w językach/środowiskach, które zapewniają rozróżnienie na liczby ze znakiem i w wyniku przepelnienia &#8222;przekręcają się&#8221; dając dla MAX+1 wartość MIN należy implementując powyższe testy pamiętać o ograniczeniu pętli do liczb dodatnich. 

W ogólności dokładność Integera w Pythonie 3 to stała = 1. Tak też jest w językach niższego poziomu. Jednak wysokopoziomowe środowiska mogą stosować rzutowanie na różne dziwne struktury i niekoniecznie rozwróżniać gogol od (gogol+1).

Wiedza o obsłudze ogromnych (>10**30) liczb calkowitych pozwala np. generować dane do stablicowania. W Pythonie można się nawet pokusić o osłonienie liczb zmiennoprzecinkowych jako klasy składającej się z Int liczba i Int dokładność &#8211; potęga dziesiątki. Umożliwia to prawie nieskończoną dokładność tak cenną w wielu projektach pomocniczych przy jednocześnie niskim koszcie implementacji (zamiast tworzenia własnych struktur w C++ wystarczy jeden skrypt w Pythonie).