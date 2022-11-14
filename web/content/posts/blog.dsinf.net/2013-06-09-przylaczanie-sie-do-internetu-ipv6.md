---
title: Przyłączanie się do Internetu IPv6
author: Daniel Skowroński
type: post
date: 2013-06-09T19:28:05+00:00
url: /2013/06/przylaczanie-sie-do-internetu-ipv6/
tags:
  - ipv6

---
Nie wszyscy ISP dają użytkownikom adres IPv6. Jest wiele opcji aby się podłączyć przez tunel ipv6-over-v4. Opiszę wymagający najmniej zabawy - Freenet6.  
<!--break-->

  
Dostawcą tej usługi jest gogo6 (http://gogo6.com). Jeśli nie mamy NATu, albo chcemy konfigurować router to rozwiązanie Hurricane Electrics (http://tunnelbroker.net/, http://he.net) jest jak najbardziej adekwatne. Na innej ich stronie - http://ipv6.he.net/ możemy uzyskać certyfikat znajomości IPv6, ale co ważniejsze przejść krótki kurs.

Gogo6 dostarcza gogoCLIENT - jedną aplikację tunelującą nasz ruch automatycznie. Dostępna pod Windows jako binarka x86/x64 i na Linuksa jako kod źródłowy. Swoją drogą dostępna w repozytorium użytkowników Archa (AUR) i zapewne innych dystrybucji też. Pakiet nazywa się **gogoc**. Można podpiąć się jako anonymous i dostać dynamiczny IP lub zarejestrowawszy się wcześniej na http://www.gogo6.com/freenet6/account skorzystać ze statycznego adres. Niestety broker nie raczy nam podać jakie dokładnie dostajemy, ale wystarczy ifconfig. Dane logowania i serwer definiujemy w 

```bash
/etc/gogoc/gogoc.conf
```


w którym znajdziemy obszerną dokumentację.

Bardzo praktyczną stroną jest http://test-ipv6.com/, gdzie możemy sprawdzić jak wygląda nasza sytuacja.  
Warto zaznaczyć, że dostęp do stron WWW używając ich adresu IPv6 odbywa się poprzez podanie go w nawiasach kwadratowych np. `http://[2001:5c0:1400:a::a00]`. 

Warto oczywiście dodać odpowiednie rekordy AAAA w swoim DNSie, bo trochę trudniej spamiętać 128-bitowy adres 😉