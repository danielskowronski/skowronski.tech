---
title: "syntax error : missing ’;’ before 'type’ //C w MSVC"
author: Daniel Skowroński
type: post
date: 2013-08-01T11:24:14+00:00
url: /2013/08/syntax-error-missing-before-type-c-w-msvc/
tags:
  - c++
  - msvc
  - visual studio

---
MS Visual C obecny w Visual Studio (_nawet_ w 2013!) jako kompilator czystego C z bliżej nieznanych powodów używa wersji języka z 1990, w której niedozwolone było definiowanie z deklaracją w jednej linii, czyli

```c++
int zmienna = 0;
```


zwróci błąd w czasie kompilacji 

```c++
syntax error : missing ';' before 'type'
```


To, co wydaje się normalne zostało wciągnięte w wersję C z 1999. Zatem trzeba po prostu wpisać dziwnie wyglądające dla programisty C++

```c++
int zmienna; zmienna = 0;
```


Ponadto w C-1990 zmienne należy deklarować na początku bloku, w tym niedozwolone jest deklarowanie zmiennej w pętli for w dyrektywie początkowej - trzeba wyciągnąć deklarację poza blok:

```c++
int i;
for (i=0; i<100; i++){
...
}
```
