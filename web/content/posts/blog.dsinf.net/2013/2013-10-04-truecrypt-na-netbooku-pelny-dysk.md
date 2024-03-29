---
title: TrueCrypt na netbooku – pełny dysk
author: Daniel Skowroński
type: post
date: 2013-10-04T13:13:04+00:00
summary: Jakiś czas temu postanowiłem zwiększyć bezpieczeństwo moich danych na ćwierćterabajtowym dysku w moim netbooku. Czy jednak cena jaką przcyhodzi mi płacić za bezpieczeństwo nie jest zbyt wysoka? I czy na pewno jest to bezpieczeństwo?
url: /2013/10/truecrypt-na-netbooku-pelny-dysk/
tags:
  - linux
  - security
  - szyfrowanie
  - truecrypt
  - windows

---
Jakiś czas temu postanowiłem zwiększyć bezpieczeństwo moich danych na ćwierćterabajtowym dysku w moim netbooku. Czy jednak cena jaką przcyhodzi mi płacić za bezpieczeństwo nie jest zbyt wysoka? I czy na pewno jest to bezpieczeństwo?

Pierwszy problem: TrueCrypt zapewnia szyfrowanie całego dysku tylko kiedy używa bootloadera Windowsa; multiboot jest OK, ale Windowsowy musi być pierwszy.  
Jak to ominąłem? Po pierwsze: zmiana bootsectota.  
A po drugie: dodanie wpisu GRUBa do BCD, czyli menedżera rozruchu od Microsoftu.  
Można albo ręcznie klepać w cmd poleceniem bcdedit.exe, albo... wyklikać. I to jest ten przypadek kiedy wyklikać jest lepiej. Narzędziem, któremu powierzyłem losy psucia tak istotnej części OSu (i chyba jedynym tyle potrafiącym) okazał się być EasyBCD (http://neosmart.net/EasyBCD/), który posiada wersję free - link na samym dole strony producenta. Dodanie specjalnej implementacji GRUBa to kilka sekund - _Add new entry_, karta _NeoGrub_ i _Add_. Przycisk _Configure_ otworzy nam plik z konfiguracją zgodną z _grub legacy_. Tutaj umieszcamy master grub-a, czyli np. zawartość /boot/grub/grub.cfg z istniejącej instalacji Linuksa.

Niby wszystko jak być powinno - do szyfrowania wybrałem Serpenta (żeby nie nadszarpnąć wydajności i tak niezbyt mocarnego Atoma D450 - 1c/2t @1.66GHz), funkcja skrótu Whirpool, hasło rzecz jasna takie, jak trzeba - około 30 znaków - w końcu nie trzymam tam super tajnych dokumentów. Zanim zaczął się kilkugodzinny proces mielenia dysku bit po bicie musiałem ominiąć pewne błędne założenia w postaci wymuszenia sprawdzenia płyty ratunkowej. Cóż - netbook _nie_ ma napędu, a mój napęd DVD przełożyłem do stacjonarki. Rzecz jasna ISO zgrałem sobie na bootowalnego pendrive'a i po sprawie. Ale, żeby formater nas puścił dalej trzeba uruchomić go z opcją /noisocheck, np.:

```cmd
"C:\Program Files\TrueCrypt\TrueCrypt Format.exe" /noisocheck
```


Dysk zaszyfrowany - bezpieczeństwo podniesione, wydajność obniżona. Znacznie.  
Obsługa zaszyfrowanego nośnika w locie nie wpływa specjalnie na wydajność procesora, ale kiedy nie ma wsparcia sprzętowego dla AESa to dysk staje się mocno powolny. Najprostszy test - kopiowanie pliku w obrębie dysku: z 20-30MB/s spadek do 10-15MB/s. W trakcei zwykłej pracy na netbooku wszystko działa w miarę, jak powinno, ale tak jest do czasu pierwszego rozładowania - maszyna się hibernuje, hibernuje, hibernuje... Z wznawianiem jeszcze gorzej - o ile przedtem 2GB RAMu ładowało się góra 3/4 minuty, teraz trwa to co najmniej 2-3 razy dłużej.

Ale czy na pewno mój dysk stał się zabezpieczony? /\*Kwestię mocarnego hasła i plików szyfrujących pominę.\*/ Pewności nigdy nie mam. Przed złodziejami zwykłymi i niezwykłymi - raczej na pewno tak. Przed krajowymi służbami bezpieczeństwa, gdyby hipotetycznie chciały sprawdzić co ja tam trzymam - znowu raczej na pewno tak. Ale przed amerykańskim NSA, gdyby hipotetycznie byli podejrzliwi - tu już pewny nie jestem. Niby to plotki o łamaniu RSA 1024bit w locie, ale...

Podsumowywując: póki nie mamy szybkiego dysku (mocniejszy HDD, jeszcze lepiej SSD) i wielordzeniowego procesora Intela (ze wsparciem sprzętowym dla AESa) to szyfrowanie dysku ot tak może okazać się nieco uciążliwe. Wówczas lepiej ważne dane umieścić w konterach i sprytnie je podmontowywać.