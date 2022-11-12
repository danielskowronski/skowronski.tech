---
title: Szybka podmiana zakazanych znaków pod NTFS
author: Daniel Skowroński
type: post
date: 2013-03-27T00:43:55+00:00
url: /2013/03/szybka-podmiana-zakazanych-znakow-pod-ntfs/
tags:
  - linux
  - ntfs

---
Zdarza się, że przyjdzie nam do głowy nazwać pliki wykorzystując dwukropki, np. ładnie formatując dane. Pod systemem plików ext nic się nie dzieje, ale gdy zrobimy to na współdzielonej z Windowsem partycji NTFS to po starcie Windy przywita nas **chkdsk** robiąc na dysku sieczkarnię...  
<!--break-->

  
  
Naszym zadaniem jest szybka zamiana dwukropków i innych znaków zakazanych we wszystkich plikach - najlepiej rekursywnie. A jeszcze lepiej mieć wybór 😉 Więc po kolei:

Najpierw zajmiemy się obsłużeniem znaku na jaki podmieniamy. Ponieważ nie chce się nikomu co chwila dopisywać parametru "_", więc wypada obsłużyć nulla - "-z" sprawdza, czy zmienna jest pusta i zwraca true jeśli nic nie podstawiono. Zmienna $k jest tu pomocnicza.

<pre class="EnlighterJSRAW bash">if [ -z $1 ]
then
  k="_"
elif [ "$1" == "help" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    #tekst pomocy
    exit
else
    k=$1
fi
</pre>

Obsługa rekurencji katalogowej jest o tyle ciekawa, że to co jest w zmiennej zostanie potem wykonane - **"eval #{nazwa_zmiennej}"**.

<pre class="EnlighterJSRAW bash">if [ -z $2 ] || [ "$2" != "-" ]
then
  r="find . -name '*'"
else [ "$2" == "-" ]
  r="find . -maxdepth 1 -name '*'"
fi
</pre>

Czas na gwóźdź do trumny programisty - REGEXPY, czyli po ludzku mówiąc wyrażenia regularne. Większość programistów ten temat omija szerokim łukiem dlatego powstały strony w rodzaju http://www.regular-expressions.info/reference.html, gdzie znajdziemy listę znaków nas interesujących. Składnia sed'a jest w rodzaju "s/co/na_co/coś". To "coś" to zwykle g - jeśli chcemy podmienić wszystkie wystąpienia. Chyba.  
Poniższe piękne wyrażonko zamienia na $k każdy znak należący do grupy (grupy do wyboru zapisujemy w [ ]): gwiazdka (poprzedzona backslashem, bo inaczej sed pomyśli, ze chcemy uzyskać wieloznacznik), nawiasy trójkątne, dwukropek, ciapki: pojedynczy i podwójny, cofnięty ukośnik, pałę pionową i znak zapytania.

<pre class="EnlighterJSRAW bash">s="s/[\*&lt;>:'\"\\\|\?]/$k/g"
</pre>

Warto zwrócić uwagę na obsługę faktu, że pliki ze spacjami psują wszystko - pętla for uzna spację za rozdzielacz i potworzy kilka nowych plików, które nie istnieją. Aby temu zaradzić wystarczy przedefiniować rozdzielacz:

<pre class="EnlighterJSRAW bash">IFS=$'\n'
</pre>



Główna pętelka skryptu zawiera dwa warunki, któe formalnie optymalizują kod - bo po cozmieniać nazwę pliku na taką samą, zwłaszcza, że wygeneruje się tylko błąd?  
Warunek w 7 linii <pre class="brush" bash">[ -f $nf ]</pre> 

sprawdza, czy docelowy plik już istnieje. Może się bowiem zdarzyć istnienie plików o nazwach "coś<>coś" i "coś\*>coś". Wówcza po pierwszej podmiance mamy "coś__coś" i "coś\*>". Żeby uniknąć nadpisać, czy konfliktów tworzony jest dopisek, żeby pliki miały w miarę oryginalne nazwy i się nie gryzły. Zmienna $d o wartości \`date +%s%N\` to bardzo unikalny dopisek: %s zwraca liczbę sekund od początku epoki (1 stycznia 1970) - bez spacji, ale mało unikalne. Dopisanie %N, czyli nanosekundy wg. zegara procesora tworzy bardzo unikalną nazwę pliku.

<pre class="EnlighterJSRAW bash">for f in `eval ${r}`
do
  nf=`echo $f | sed $s`
  if [ "$nf" != "$f" ]
  #jeśli zmiana nazwy się odbywa (tj. plik ma zmienianą nazwę, a nie tylko jest pomijany)
  then
    if [ -f $nf ]
    then
      d=`date +%s%N` 
      mv -nu "$f" "$nf.$d"  2>/dev/null 1>/dev/null
    else
      mv -nu $f $nf
    fi
    echo "$f -> $nf"
  fi
done
</pre>

Cały kod, będący owocem kilku godzin dopieszczania prostego aliasu dla rename poniżej. 

<pre class="EnlighterJSRAW bash">#!/bin/bash
if [ -z $1 ]
then
  k="_"
elif [ "$1" == "help" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Jako pierwszy parametr mozesz podac na co zamienic dwukropki
    echo Domyslnie jest to podloga \'_\'
    echo Drugi parametr gdy przyjmie wartosc minus \'-\' wylaczy rekursje
    exit
else
    k=$1
fi
#rekursywnie, czy nie
if [ -z $2 ] || [ "$2" != "-" ]
then
  r="find . -name '*'"
else [ "$2" == "-" ]
  r="find . -maxdepth 1 -name '*'"
fi

#wyrazenie regularne
s="s/[\*&lt;>:'\"\\\|\?]/_/g"

IFS=$'\n' #obsługa plików ze spacjami
for f in `eval ${r}`
do
  nf=`echo $f | sed $s`
  if [ "$nf" != "$f" ]
  #jeśli zmiana nazwy się odbywa (tj. plik ma zmienianą nazwę, a nie tylko jest pomijany)
  then
    if [ -f $nf ]
    #jesli plik docelowy już istnieje bo nazwa rozni sie tylko znakami zakazanymi (ale sa one w tej samej liczbie)
    then
      d=`date +%s%N` #dosyc unikalny dopisek - licza sekund od epoki+nanosekundy zegara systemowego
      mv -nu "$f" "$nf.$d"  2>/dev/null 1>/dev/null
    else
      mv -nu $f $nf
    fi
    echo "$f -> $nf"
  fi
done

exit 0
</pre>