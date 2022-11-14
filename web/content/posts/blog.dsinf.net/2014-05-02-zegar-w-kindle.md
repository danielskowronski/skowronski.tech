---
title: Zegar w Kindle
author: Daniel Skowroński
type: post
date: 2014-05-02T13:35:40+00:00
excerpt: |
  W kindlach definitywnie brakowało mi zegarka. Podobno w pierwszej generacji dało się wyświetlić tekstowy za pomocą Alt+T. Dla nowszych modeli istnieje porada "wciśnij klawisz menu" - pojawia się pasek systemowy na górze z zegarkiem. Ale to nie jest żadne rozwiązanie.
  Oczywiście - napisałem na to skrypt :)
url: /2014/05/zegar-w-kindle/
tags:
  - kindle
  - linux

---
W kindlach definitywnie brakowało mi zegarka. Podobno w pierwszej generacji dało się wyświetlić tekstowy za pomocą Alt+T. Dla nowszych modeli istnieje porada "wciśnij klawisz menu" - pojawia się pasek systemowy na górze z zegarkiem. Ale to nie jest żadne rozwiązanie.  
Oczywiście - napisałem na to skrypt 🙂

![Kindle - zegarek](/wp-content/uploads/2014/05/WP_20140502_001-300x225.jpg)

Po pierwsze - **potrzebny nam będzie Launchpad**. LP to program pozwalający odpalać komendy za pomocą skrótów klawiaturowych. Rzecz jasna - "<span style="text-decoration: underline;">it may void your varranty`", ale kto by się przejmował. Szansa, że coś wybuchnie jest znikoma. Instrukcje - [tutaj][2] (minimum to LP). W skrócie instalacja polega na wgraniu na główną pamięć (tą dostępną po wpięciu do komputera przez USB) pliku .bin i wykonanie aktualizacji systemu.

Teraz możemy zacząć tworzyć skrypty.

Mój **zegar.sh** wykorzystuje polecenie `eips` pozwalające na prymitywne, acz sprawne pisanie po ekranie w trybie znakowym lub obrazkowym. Jego pełne możliwości są opisane [na wiki][3]. Nam będzie potrzebne ustawienie pozycji kursora i tekstu - `eips pozycja_X pozycja_Y 'napis'`.

Chwilę się zastanawiałem jak aktualizować zegar. Niestety zmiana strony angażuje pełne przeładowanie ekranu e-Ink, więc odświeżanie co 60 sekund czyli tyle ile wynosi precyzja tego zegara jest nieskuteczne.

Pierwsza wersja odświeżała (czyli dopisywała do ekranu) zegar co 1 sekundę. Ale to do rozwiązania produkcyjnego się nie nadaje - zużywa baterię (na wygaszaczu też to działa!) i chyba dla ekranu zdrowe nie jest.

Druga wersja miała korzystać z Launchpadowego przypisania do "Left<", "Left>", "Right<" i "Right>", czyli bocznych klawiszy zmiany stron, ale okazało się, że tego LP nie umie. Spory research przyniósł poszukiwane polecenie \`waitforkey\`. Bez parametrów zwróci kod pierwszego wciśniętego klawisza i zakończy działanie (oczywiście dopiero po wciśnięciu). Kiedy dodamy kod klawisza w parametrze - zwróci exitcode 0 tylko po tym klawiszu.

Wersja ostateczna robi co następuje w pętli nieskończonej:

  * czeka na dowolny klawisz (wymusza zegar w każdym miejscu systemu - nawet w menu)
  * wstawia czas w formacie HH:MM w prawy dolny róg - niezagospodarowany przez system
  * czeka sekundę - ewentualne opóźnienie związane z wolniejszym ładowaniem strony (zwłaszcza poprzedniej w dużych książkach)
  * i ponownie wstawia zegar - czasami ekran nie zdąży się przeładować zanim wstawiony będzie tekst za pierwszym razem, a tryb wyświetlenia delay->show zamiast show->delay->show powoduje niemiłe opóźnienie, jeśli jednak ekran przeładowany będzie szybciej 😉

Kod do wstawienia gdziekolwiek do pliku `zegar.sh`, jednak modelowo umieszczam go w głównym katalogu

```bash
while [ true ]; do
    waitforkey && 
    eips 45 39 `date +"%H:%M"` && 
    sleep 1 && 
    eips 45 39 `date +"%H:%M"`
done;
```


Kod do wstawienia do pamięci głównej do pliku `launchpad/zegar.ini`:

```
[Actions]
Z = !/mnt/us/zegar.sh &
Z X = !kill `pgrep -f ".*zegar.sh"`
```


Ten plik ini ustawia, że wciśnięcie Shift, a potem szybko Z odpali skrypt `zegar.sh` z `/mnt/us`, czyli dostępnej dla użytkownika pamięci (tej w FAT). Shift-Z-X ubija pętlę zegara.

Po wgraniu wciskamy Shift-Shift-Spacja (nie na raz, tylko z krótkimi odstępami), na ekranie pojawia się "**Success!**" - właśnie przeładowaliśmy LP - wystarczy tylko raz. Można dla odmiany zrobić restart urządzenia, ale to trwa wieczność. Aby odpalić nasz zegrar wciskamy Shift-Z i wracamy do czytania książek.

&nbsp;

Przydatne linki:

  * Hacki na Kindle od strony systemowej: <http://www.turnkeylinux.org/blog/kindle-root>
  * Polskojęzyczny tutorial: <http://www.eksiazki.org/odpicuj-swojego-kindle/>
  * O triggerach i zdarzeniach: <http://www.mobileread.mobi/forums/showthread.php?t=176090>
  * Lista modyfikacji - główny wątek z najnowszymi wersjami plików: <http://www.mobileread.com/forums/showthread.php?t=128704>
  * Inna strona z modyfikacjami: <http://jevopi.blogspot.com/2011/07/pimp-your-kindle.html>

&nbsp;

 [1]: /wp-content/uploads/2014/05/WP_20140502_001.jpg
 [2]: http://www.eksiazki.org/odpicuj-swojego-kindle/
 [3]: http://wiki.mobileread.com/wiki/Eips