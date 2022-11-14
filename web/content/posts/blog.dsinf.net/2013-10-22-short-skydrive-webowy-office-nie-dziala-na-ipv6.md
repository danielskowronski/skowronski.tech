---
title: 'short; Skydrive: webowy Office nie działa [na IPv6]'
author: Daniel Skowroński
type: post
date: 2013-10-22T21:32:10+00:00
excerpt: Jak się okazuje webowa wersja Office z której możemy korzystać na Skydrive nie chce działać gdy łączymy się posiadając IPv6
url: /2013/10/short-skydrive-webowy-office-nie-dziala-na-ipv6/
tags:
  - ipv6
  - web

---
Jak się okazuje webowa wersja Office z której możemy korzystać na Skydrive (i raczej ta z Office 365) nie chce działać gdy łączymy się posiadając IPv6 - można tylko zgadywać o co chodzi, ale prawdopodobnie w jednym miejscu serwer odczytuje IPv4 a wdrugim v6 i poowoduje to niezgodności.  
Objawy: sam Skydrive działa, ale otwarcie dokumentu powoduje załadowanie strony, jednak jeden z serwerów z którego ładowany jest interfejs ma _timeout_  
Rozwiązanie: wyłączyć IPv6 😉

Ten post jest pierwszym z serii **"short;"**, czyli zawierających maksimum 1 akapit prostej porady, czy spostrzeżenia.