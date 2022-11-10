---
title: Teoretycznie zbędny, ale czasem przydatny zegarek w skrypcie CMD
author: Daniel Skowroński
type: post
date: 2013-12-17T23:27:36+00:00
excerpt: 'Dziś coś śmiesznie zbędnego, ale czasem jak się okazuje przydatnego - zegarek napisany na szybko w skrypcie CMD.'
url: /2013/12/teoretycznie-zbedny-ale-czasem-przydatny-zegarek-w-skrypcie-cmd/
tags:
  - cmd

---
Dziś coś śmiesznie zbędnego, ale czasem jak się okazuje przydatnego &#8211; zegarek napisany na szybko w skrypcie CMD. Ostatnią rzeczą przed odpaleniem będzie zmiana rozmiaru fontu na maksimum, żeby było coś widać oraz zredukowanie rozmiaru okna konsoli.

<pre class="lang:default EnlighterJSRAW " title="Kod zegara" >title zegarynka
@echo off
cls

:petla
time /t
ping 1.1.1.1 -n 1 -w 1000 &gt; nul
cls
goto petla</pre>

Pewna uwaga: w MS-DOS nie ma sleepa, wiec trzeba użyć mijaka w postaci pinga, który pójdzie "w kosmos" i zostanie _ztimeout&#8217;owany_ po zadanym czasie.