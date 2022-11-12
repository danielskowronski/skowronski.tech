---
title: Kilka słów o Kaspersky PURE 3.0
author: Daniel Skowroński
type: post
date: 2013-11-04T19:40:38+00:00
excerpt: 'Próbowałem wielu antywirusów na Windowsach. Do tej pory ciężko mi znaleźć ten wzorcowy, ale najbogatszy Kaspersky - wersja PURE 3.0 zdaje się spełniać moje oczekiwania. Przynajmniej kiedy jestem na desktopie - na Server rzecz jasna nie chce się zainstalować.'
url: /2013/11/kilka-slow-o-kaspersky-pure-3-0/
tags:
  - anti-virus
  - recenzje
  - software
  - windows

---
Próbowałem wielu antywirusów na Windowsach. Do tej pory ciężko mi znaleźć ten wzorcowy, ale najbogatszy Kaspersky - wersja PURE 3.0 zdaje się spełniać moje oczekiwania. Przynajmniej kiedy jestem na desktopie - na Server rzecz jasna nie chce się zainstalować.

Ze wszystkich antywirusów, które testowałem Kaspersky ma najlepszy interfejs i najwięcej możliwości. Więcej bajerów ma tylko Bitdefender, ale trudno coś w nim znaleźć.  
Jest to kolejny pakiet w którym deaktywacja absolutnie zbędnych modułów jak na przykład u mnie _Mail defence_ skutkuje denerwującym komunikatem - jak wszedzie "jeden ze składników jest wyłączony". Tylko AVG oferuje opcję nieinstalowania zbędnych komponentów. Ale da się przeżyć.

Skrócona lista funkcji z kilkoma słowami komentarza wygląda mniej więcej tak:

  * Standardowo _Self Defence_ - odpowiednik tego jest chyba wszędzie.
  * _File Anti-virus_ - tu miłe zaskoczenie: można zabronić antywirusowi automatycznego podejmowania decyzji co do zagrożeń - w trudnych środowiskach mógłby się zapędzić; całkiem sensowne są opcje definiowane opcje wydajności - można zmienić parametry heurystyki, czy silniki skanu.
  * Kolejne cztery moduły to _Mail anti-virus_, _Anti-Spam_, _IM Anti-virus_ i _Web Anti-virus_; trzy pierwsze nie przydały mi się do tej pory, czwarty wykazuje zdolność blokowania podejrzanych URLi (w tym jak musiałem sprawdzić - stron z crackami do Kasperskiego 😉 ). Znowu - można zmieniać akcje domyślne. 
  * Zakładka _Application control_ w ustawieniach to ciekawe podejście do kontrolowania wyjątków. Znajduje się tu też nico ukryte _Identity protection_ chroniące rejestr i pliki np. przegladarki przed próbą niepowołanego grzebania. Analiza behawioralna znajduje się pod nazwą _System Watcher_ - wykrywanie exploitów odbywa się włąśnie tutaj.
  * _Firewall_ jest zorganizowany dobrze do zwykłych zastosowań - serwery też można stawiać i chronić Kasperskim serwery, ale interfejs programu zdradza, że jest do innych celów. Ładny podglad na karty sieciowe i możliwość ich gaszenia jest bardzo na plus - zwłaszcza przy mnogich kartach wirtualnych. Ciekawie uzupełnia to _Network Attack Blocker_ z opcją autobanowania na jakiś czas.
  * Kompletną ciekawostką jest _Anti-Banner_ - taki AdBlock na warstwie sieciowej. Testowany na czystej przeglądarce na kilku stronach z filmami - naprawdę działa! A ponadto można definiować własne białe i czarne listy. Super!
  * Z kolei kolejny moduł - _Safe money_ być może działa ale uniemożliwia logowanie do banku. "Bezpieczna przeglądarka" się nie otwiera,a gdy dodałem mBank do wyjątków to nie przeszkodziło to w niedziałaniu przekierowaniu PayU->mTransfer :(. Ogólnie nie działa i denerwuje.
  * _Secure Data Input_ to "super bezpieczna" klawiatura ekranowa - być może o tyle lepsza od osk.exe, że kontroluje swoją integralność.
  * W ustawieniach można też odnaleźć tryb gry - żadnych powiadomień dla aplikacji pełnoekranowych - duży plus, choć nie jest to unikalna funkcja - nawet Comodo ma.
  * Po obiecującej karcie _Battery saving_ spodziewałem się więcej niż jednego checkboxa do wyłączania zaplonwanych skanów na baterii. Dobre i to.
  * W zakładce _Network_ można łatwo wykluczyć porty do skanowania.
  * Możemy także synchronizować nasze hasła na wszystkich komputerach z Kaspersky PURE 3.0 - jakoś ja im nie ufam 😉
  * Ważna rzecz - z ikonki w tacce systemowej możemy spauzować ochronę na wybrany czas, do restaru, albo do ponownej aktywacji.
Nie zabrakło rzecz jasna blokowania hasłem, harmonogramu skanowań, czy importu-eksportu profili. Możemy skanować wybrane obszary - _Full_, _Critical Areas_, _Custom_ i last but not least - _Vulnerability Scan_.

Jeśli chodzi o wydajność to po kilku dniach można ustawić go tak by na leciwym laptopie z dwurdzeniowym CPU i 4GB RAM dawał sobie radę. Jak zawsze - przy instalacjach i dużych transakcjach wejścia-wyjścia wypada go zagasić.

Ogólnie moja ocena w skali szkolnej: **5-**. Mogło być lepiej, ale do tej pory to chyba najlepszy desktopowy antywirus.