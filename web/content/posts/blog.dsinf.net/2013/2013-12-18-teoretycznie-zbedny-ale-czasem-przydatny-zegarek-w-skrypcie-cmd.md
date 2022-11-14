---
title: Teoretycznie zbędny, ale czasem przydatny zegarek w skrypcie CMD
author: Daniel Skowroński
type: post
date: 2013-12-17T23:27:36+00:00
summary: 'Dziś coś śmiesznie zbędnego, ale czasem jak się okazuje przydatnego - zegarek napisany na szybko w skrypcie CMD.'
url: /2013/12/teoretycznie-zbedny-ale-czasem-przydatny-zegarek-w-skrypcie-cmd/
tags:
  - cmd

---
Dziś coś śmiesznie zbędnego, ale czasem jak się okazuje przydatnego - zegarek napisany na szybko w skrypcie CMD. Ostatnią rzeczą przed odpaleniem będzie zmiana rozmiaru fontu na maksimum, żeby było coś widać oraz zredukowanie rozmiaru okna konsoli.

```cmd
title zegarynka
@echo off
cls

:petla
time /t
ping 1.1.1.1 -n 1 -w 1000 > nul
cls
goto petla
```


Pewna uwaga: w MS-DOS nie ma sleepa, wiec trzeba użyć mijaka w postaci pinga, który pójdzie "w kosmos" i zostanie _ztimeout'owany_ po zadanym czasie.