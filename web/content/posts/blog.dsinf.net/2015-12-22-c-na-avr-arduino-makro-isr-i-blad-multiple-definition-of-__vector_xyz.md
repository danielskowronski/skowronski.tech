---
title: C++ na AVR (Arduino), makro ISR i błąd multiple definition of `__vector_XYZ’
author: Daniel Skowroński
type: post
date: 2015-12-22T11:53:24+00:00
excerpt: |
  |
    Przy przeorganizowywaniu kodu na Arduino z procesorem AVR w którym wykorzystuję makro ISR (do obsługi przerwań systemowych) umieściłem je w pliku nagłówkowym (.h) co wyrzuciło mi malowniczy i (jak zwykle) nic nie mówiący błąd kompilatora "multiple definition of `__vector_11'".
url: /2015/12/c-na-avr-arduino-makro-isr-i-blad-multiple-definition-of-__vector_xyz/
tags:
  - arduino
  - avr
  - c++
  - hardware

---
Przy przeorganizowywaniu kodu na Arduino z procesorem AVR w którym wykorzystuję makro ISR (do obsługi przerwań systemowych) umieściłem je w pliku nagłówkowym (.h) co wyrzuciło mi malowniczy i (jak zwykle) nic nie mówiący błąd kompilatora &#8222;multiple definition of \`_\_vector\_11&#8242;&#8221;. 

Oczywiście jawnie nigdzie nie użyłem _\_vector\_11, mój kod nie woła także nigdzie indziej przerwań. Okazało się, że biblioteka do obsługi układu DHT11 której używam wykorzystuje millis() i inne funkcje powiązane z timerem systemowym żeby nie czytać z portu szybciej niż urządzenie da radę. Po przesunięciu mojego wywołania makra do pliku z kodem konflikt zmiennych wektorowych przestaje istnieć &#8211; nie udało mi się znaleźć konkretnej ku temu przyczyny, ale zapewne jest to spowodowane momentem rozwijania makr i wynikających z tego nazw im przypisywanych.

W każdym razie na arduino pomaga umieszczenie marka w pliku z kodem (.cpp)