---
title: Sleep w JavaScript
author: Daniel Skowroński
type: post
date: 2013-05-08T00:08:58+00:00
url: /2013/05/sleep-w-javascript/
tags:
  - js

---
Ustawianie opóźnień w skryptach Javy nie jest takie oczywiste...  
<!--break-->

Z języków programowania chciałoby się użyć funckji sleep(int miliseconds); która zatrzyma CPU na jakiś czas - wiadomo, że jest to nieeleganckie, ale skuteczne. Jednak w przypadku stron WWW przykładowa implementacja

```js
function sleep(milliseconds) {
  var start = new Date().getTime();
  while (true)
    if ((new Date().getTime() - start) > milliseconds)
      break;
}

```


naprawdę zawiesza procesor - nie jest to znane z C# System.Threading.Thread.Sleep(100) - więc wskazujące, że zawieszamy wątek, ale zawieszamy cały interpreter JS co równoznaczen jest z tym, że aktualizacje DOM czy po prostu tego co widzi użytkownik są niewidoczne. Ponadto monolity takie jak Mozilla Firefox zawisną w całej okazałości, czym może zainteresować się Windows - w skrajnej konfiguracji sam ubije nieodpowiadający proces. Przykład:

```js
document.write("1 <br />"); sleep(1000);
document.write("2 <br />"); sleep(1000);
document.write("3 <br />"); sleep(1000);
document.write("4 <br />"); sleep(1000);

```


Wykonanie zawiesi wszystko i dumnie ukaże nam po ok. 4 sekundach 1-2-3-4, a nie po kolei tak jakbyśmy chcieli.

Przejdźmy do jedynego słusznego rozwiązania , tj. **setTimeout**

```js
setTimeout(function() { coś(); }, 1000); 

```


Wszystko pięknie, ale sposób w jaki to zostanie zinterpretowane jest zaskakujący jak na trochę prymitywny względem wysokopoziomowców JavaScript. Otóż setTimeout znaczy to co znaczyć powinno tj. "zarejestruj event/przerwwanie, że za tyle milisekund wywołasz coś();, ale bez czekania tych milisekund wykonaj kolejną linię kodu", a nie "odczekaj i wykona coś(); dopiero wtedy następną linię". Oznacza to, że kod

```js
setTimeout(function() {document.write('1 <br />'); }, 1000);
setTimeout(function() {document.write('2 <br />'); }, 1000);
setTimeout(function() {document.write('3 <br />'); }, 1000);
setTimeout(function() {document.write('4 <br />'); }, 1000);

```


odczeka sekundę i wypluje wszystko na raz!

**Właściwe rozwiązanie to kolejne setTimeout'y <u>większe od poprzednich</u>**:

```js
setTimeout(function() {document.write('1 <br />'); }, 1000);
setTimeout(function() {document.write('2 <br />'); }, 2000);
setTimeout(function() {document.write('3 <br />'); }, 3000);
setTimeout(function() {document.write('4 <br />'); }, 4000);

```
