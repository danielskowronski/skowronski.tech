---
title: 'Na bardzo szybko: automatyczna zmiana rozmiaru iframe w HTML'
author: Daniel Skowroński
type: post
date: 2014-06-26T20:47:32+00:00
summary: |
  Problem irytujący, ale rozwiązanie szybkie (jak się przeczyta ten artykuł ^^).
  
  Skrypt, którego użyjemy to: davidjbradshaw.github.io/iframe-resizer. Są trzy elementy: plik JS dla strony trzymającej iframe, plik JS dla każdej strony, która się pojawi wewnątrz iframe i wywołanie JavaScript na stronie z iframe. Działa wszędzie poza Operą Mobile (ale kogo to dziwi...) i WinPhone_IE10 (na WinPhone_IE11 nie wybucha i blokuje się na maksymalnych rozmiarach).
url: /2014/06/na-bardzo-szybko-automatyczna-zmiana-rozmiaru-iframe-w-html/
tags:
  - html

---
Problem irytujący, ale rozwiązanie szybkie (jak się przeczyta ten artykuł ^^).

Skrypt, którego użyjemy to: <http://davidjbradshaw.github.io/iframe-resizer/>. Są trzy elementy: plik JS dla strony trzymającej iframe, plik JS dla każdej strony, która się pojawi wewnątrz iframe i wywołanie JavaScript na stronie z iframe. Działa wszędzie poza Operą Mobile (ale kogo to dziwi...) i WinPhone\_IE10 (na WinPhone\_IE11 nie wybucha i blokuje się na maksymalnych rozmiarach).

&nbsp;  
Strona "host":

```html
<script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<iframe id="nazwa" width="500px" scrolling="no" src="plik.html"></iframe>
<script src="https://raw2.github.com/davidjbradshaw/iframe-resizer/master/js/iframeResizer.min.js"></script>
<script>$("#nazwa").iFrameResize({});</script>
```


L1: jQuery [opcjonalny - można ładować iFrameResize({}) przez natywny kod JS]  
L2: docelowy iframe; zdefiniowanie na sztywno któregoś z wymiarów zablokuje jego zmiany  
L3: skrypt iframeResizer.min.js  
L4: podpięcie funkcji pod obiekt

&nbsp;  
Strona "gość":

```html
<script src="https://raw.githubusercontent.com/davidjbradshaw/iframe-resizer/master/js/iframeResizer.contentWindow.min.js"></script>
treść lalala-trolololo; lorem ipsum
```


L1: skrypt iframeResizer.contentWindow.min.js  
L2+:treść

&nbsp;  
Oczywiście skrypty należy załadować na swój własny serwer żeby było porządniej. Porządna, ale przydługa jak na błyskawiczne rozwiązanie typu "wirtualny duct-tape" - <http://davidjbradshaw.github.io/iframe-resizer/>.