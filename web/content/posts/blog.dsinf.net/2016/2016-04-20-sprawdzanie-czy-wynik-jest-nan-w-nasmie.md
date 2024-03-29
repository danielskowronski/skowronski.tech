---
title: Sprawdzanie czy wynik jest NaN w NASMie
author: Daniel Skowroński
type: post
date: 2016-04-20T01:33:10+00:00
summary: Podczas pisania zadania na laborki z programowania niskopoziomowego z powodu nieutrzymania konwencji C i zostawienia po sobie bałaganu na stosie FPU wyskoczyła mi wartość "-nan" czyli "Not a Number". Postanowiłem bliżej przyjrzeć się możliwościom niskopoziomowej detekcji tego stanu w logice aplikacji (choć rozwiązaniem problemu z zadaniem było wyczyszczenie stosu a nie pisanie mijaka ;) ).
url: /2016/04/sprawdzanie-czy-wynik-jest-nan-w-nasmie/
tags:
  - assembler
  - ieee754
  - nasm
  - prognisk
  - x86

---
Podczas pisania zadania na laborki z programowania niskopoziomowego z powodu nieutrzymania konwencji C i zostawienia po sobie bałaganu na stosie FPU wyskoczyła mi wartość "-nan" czyli "Not a Number". Postanowiłem bliżej przyjrzeć się możliwościom niskopoziomowej detekcji tego stanu w logice aplikacji (choć rozwiązaniem problemu z zadaniem było wyczyszczenie stosu a nie pisanie mijaka 😉 ).  
W tym artykule zakładam że Czytelnik wie jak działa FPU i co to jest ST0, ST1 itd.

Problem wejściowy - mamy funkcję, która jest podatna na wystąpienie stanu NaN - dla celów artykułu przyjąłem zwykłe dzielenie. Mamy też kod w C, który służy tylko jako ułatwiacz wypisywania wartości na ekran. Jest też skrypt kompilujący i uruchamiający - zabrany wprost z mojego środowiska na laboratorium - oczekuje on plików NAZWA.c i NAZWA.asm i parametru wiersza poleceń NAZWA.

```bash
gcc -m32 -o $1_c.o -c $1.c &&
nasm -felf32 -o $1_a.o $1.asm &&
gcc -m32 -o $1 $1_a.o $1_c.o &&
./$1
```


```c++
#include <stdio.h>
extern int funkcja(double a, double b, double* c);

int main()
{
  double a=0.0, b=0.0, c;
  int statusOK = funkcja(a,b,&c);
  if (statusOK){
    printf("f(%f,%f)=%f\n", a,b,c);
  }
  else{
    printf("NaN catched!\n");
  }
  return 0;
}
```


```nasm
segment .text
global funkcja
funkcja:

push ebp
mov ebp, esp

%define a qword [ebp+8]
%define b qword [ebp+16]
%define c dword [ebp+24]

mov eax, c
fld a       ; a
fld b       ; b,a
fdivp st1   ; b/a
fstp qword [eax]

mov eax, 1 ; always OK :)

fstp
mov esp, ebp
pop ebp

ret
```


W kodzie NASMowym linia 21 na razie zawsze zakłada że NaNa nie było. Na koniec będzie już lepiej 🙂

Pośród licznych rozkazów z FPU jest dostępny FXAM (Float eXAMine), który bada ST0 i ustawia odpowiednio flagi FPU CS0,CS1,CS2,CS3 (gdzie CS1 to bit znaku wartości z ST0) a pozostałe jak niżej:

<div>
  <table class="grid">
    <tr>
      <th>
        Class
      </th>
      <th>
        C3
      </th>
      <th>
        C2
      </th>
      <th>
        C0
      </th>
    </tr>
    <tr>
      <td>
        Unsupported
      </td>
      <td>
      </td>
      <td>
      </td>
      <td>
      </td>
    </tr>
    <tr>
      <td>
        NaN
      </td>
      <td>
      </td>
      <td>
      </td>
      <td>
        1
      </td>
    </tr>
    <tr>
      <td>
        Normal finite number
      </td>
      <td>
      </td>
      <td>
        1
      </td>
      <td>
      </td>
    </tr>
    <tr>
      <td>
        Infinity
      </td>
      <td>
      </td>
      <td>
        1
      </td>
      <td>
        1
      </td>
    </tr>
    <tr>
      <td>
        Zero
      </td>
      <td>
        1
      </td>
      <td>
      </td>
      <td>
      </td>
    </tr>
    <tr>
      <td>
        Empty
      </td>
      <td>
        1
      </td>
      <td>
      </td>
      <td>
        1
      </td>
    </tr>
    <tr>
      <td>
        Denormal number
      </td>
      <td>
        1
      </td>
      <td>
        1
      </td>
      <td>
      </td>
    </tr>
  </table>
</div>

Tak ustawione flagi ściągamy do rejestru AH rozkazem FSTSW (Store Floating-Point Status Word), a potem przerzucamy do flag samego CPU rozkazem SAHF (Store AH into Flags) mapując jak niżej. Teraz rzecz jasna możemy wykonywać zwykłe skoki warunkowe (Jxx) choć w nieco niezwykłych warunkach bowiem nadpisaliśmy flagi - normalnie tym zajmuje się np. instrukcja CMP.

<table class="grid">
  <tr>
    <th>
      Flaga FPU
    </th>
    <th>
      Flaga CPU
    </th>
    <th>
      Rozkaz skoku Jxx
    </th>
    <th>
      Uwagi
    </th>
  </tr>
  
  <tr>
    <td>
      C0
    </td>
    <td>
      CF
    </td>
    <td>
      JC / JNC
    </td>
    <td>
      carry flag
    </td>
  </tr>
  
  <tr>
    <td>
      C1
    </td>
    <td>
      -
    </td>
    <td>
      -
    </td>
    <td>
      nie jest przenoszona
    </td>
  </tr>
  
  <tr>
    <td>
      C2
    </td>
    <td>
      PF
    </td>
    <td>
      JP=JNP / JPE=JPO
    </td>
    <td>
      parity flag (dwie konwencje Jxx)
    </td>
  </tr>

  <tr>
    <td>
      C3
    </td>
    <td>
      ZF
    </td>
    <td>
      JZ / JNZ
    </td>
    <td>
      zero flag
    </td>
  </tr>
</table>

Tworząc kombinacje ifów możemy wyłapać NaN. Warto zwrócić uwagę, że można użyć tych flag do zwykłych porównań liczb (JG,JB itp.) ale zmiennoprzecinkowych. Ale dzisiaj nie o tym.

Można jednak uprościć program pomijając krok z SAHF (chociaż skoro już tak się zgłębiamy to warto wiedzieć o możliwościach tego rozkazu - dlatego nie pominąłem szczegółów) i sprawdzając sam rejestr AH po odczycie FSTSW.

```
SF:ZF:xx:AF:xx:PF:xx:CF
```


A więc NaN będzie odpowiadał pseudoregexowi: \*0\**\*0\*1 - czyli XOR na 01000100 (\*->0, reszta negowana) a potem OR na 10111010 (\*->1, reszta na zera). Potem można zaNOTować wynik i użyć JZ.  
Co lepsze? Tak czy inaczej kod będzie mało czytelny (jak chyba wszystko w assemblerze) więc pytanie czy potrzebujemy obsłużyć wszystkie stany z FXAM czy tylko jeden - jeśli jeden to 3 operacje bitowe i jeden skok warunkowy wydają się lepsze od etykiet na wszystkie kombinacje 3 stanów logicznych. Tak czy inaczej użycie któregokolwiek z tych rozwiązań bez kilku linijek komentarza to samobójstwo, albo umyślne zabójstwo naszego następcy...

Ja proponuję wersję bez SAHF jako prostszą realizację tytułowego problemu (nadpisujemy linię 21 z funkcja.asm):

```nasm
fxam 
fstsw ax
sahf 

mov bh,01000100b
xor ah,bh
mov bh,10111010b
or  ah,bh
not ah
cmp ah,0
jz nan

ok:
mov eax, 1
jmp koniec

nan:
mov eax, 0
jmp koniec

koniec:
```


&nbsp;

Pozostaje jedynie pytanie o znaczenie stanów innych niż NaN, normalna liczba skończona, nieskończoność i zero. Z pomocą przychodzi specyfikacja IEEE754 definiująca zapis liczb zmiennoprzecinkowych.

  * _Denormal number_ to liczby mniejsze od epsilona maszynowego a więc mniejsze niż najmniejsza reprezentowalna liczba w danej arytmetyce - ich ślad pozostaje po różnych operacjach których wynik bliski jest zeru.
  * _Unsupported_ to stan niezgodny ze specyfikacją IEEE754 - niezgodny w tym sensie że żadna kombinacja bitów go nie spowoduje.
  * _Empty_ to już stan samego FPU - oznacza że ten element (ST0) nie został jeszcze zapełniony lub został zwolniony.