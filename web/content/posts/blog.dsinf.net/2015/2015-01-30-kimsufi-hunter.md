---
title: Kimsufi Hunter
author: Daniel Skowroński
type: post
date: 2015-01-30T10:04:32+00:00
summary: 'Lekko zdnerwowany nietrafianiem na czas kiedy dostępny jest jakiś dedyk Kimsufi napisałem skrypt w Pythonie <i>Kinsufi Hunter</i>. Idea prosta - cyklicznie &quot;parsuj&quot; HTMLa i jeśli oferta jest dostępna wyślij maila. Całość chodzi sobie 24/7 na dowolnej masyznie (np. VPSie).'
url: /2015/01/kimsufi-hunter/
tags:
  - python

---
Lekko zdnerwowany nietrafianiem na czas kiedy dostępny jest jakiś dedyk Kimsufi napisałem skrypt w Pythonie _Kinsufi Hunter_. Idea prosta - cyklicznie "parsuj" HTMLa (wszelkie parsery drzewa DOM są albo mało przenośne, albo nieaktualne, a te XML-owe wariują przy nie XHMTLu czyli tam gdzie choćby przecinek nie przestrzega ścisłych oderwanych od rzeczywistości reguł) i jeśli oferta jest dostępna wyślij maila. Całość chodzi sobie 24/7 na dowolnej masyznie (np. VPSie).

Przez chwilę miałem zamiar zamiast e-maili użyć [Azure Notifications Hub][1] ale te są bezużyteczne bez stworzenia odpowiedniej aplikacji (+ulotne), a tenże skrypt miał być bardzo prosty i przenośny. Ale prawdopodobnie będę zmuszony napisać coś takiego żeby obsłużyć narastającą liczbę systemów które o czymś chcą mnie poinformować 😉

Sam "myśliwy" dostępny na [github.com/danielskowronski/kimsufi-hunter][2].

 [1]: http://azure.microsoft.com/en-us/documentation/services/notification-hubs/
 [2]: https://github.com/danielskowronski/kimsufi-hunter