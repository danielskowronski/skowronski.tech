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
W kindlach definitywnie brakowało mi zegarka. Podobno w pierwszej generacji dało się wyświetlić tekstowy za pomocą Alt+T. Dla nowszych modeli istnieje porada &#8222;wciśnij klawisz menu&#8221; &#8211; pojawia się pasek systemowy na górze z zegarkiem. Ale to nie jest żadne rozwiązanie.  
Oczywiście &#8211; napisałem na to skrypt 🙂

[<img decoding="async" loading="lazy" class="alignnone size-large wp-image-435" src="http://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001-1024x768.jpg" alt="Kindle - zegarek" width="665" height="498" srcset="https://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001-660x495.jpg 660w, https://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001-900x675.jpg 900w" sizes="(max-width: 665px) 100vw, 665px" />][1]

Po pierwsze &#8211; **potrzebny nam będzie Launchpad**. LP to program pozwalający odpalać komendy za pomocą skrótów klawiaturowych. Rzecz jasna &#8211; &#8222;<span style="text-decoration: underline;">it may void your varranty</span>&#8222;, ale kto by się przejmował. Szansa, że coś wybuchnie jest znikoma. Instrukcje &#8211; [tutaj][2] (minimum to LP). W skrócie instalacja polega na wgraniu na główną pamięć (tą dostępną po wpięciu do komputera przez USB) pliku .bin i wykonanie aktualizacji systemu.

Teraz możemy zacząć tworzyć skrypty.

Mój **zegar.sh** wykorzystuje polecenie <span class="lang:default EnlighterJSRAW  crayon-inline ">eips</span> pozwalające na prymitywne, acz sprawne pisanie po ekranie w trybie znakowym lub obrazkowym. Jego pełne możliwości są opisane [na wiki][3]. Nam będzie potrzebne ustawienie pozycji kursora i tekstu &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline ">eips pozycja_X pozycja_Y 'napis&#8217;</span> .

Chwilę się zastanawiałem jak aktualizować zegar. Niestety zmiana strony angażuje pełne przeładowanie ekranu e-Ink, więc odświeżanie co 60 sekund czyli tyle ile wynosi precyzja tego zegara jest nieskuteczne.

Pierwsza wersja odświeżała (czyli dopisywała do ekranu) zegar co 1 sekundę. Ale to do rozwiązania produkcyjnego się nie nadaje &#8211; zużywa baterię (na wygaszaczu też to działa!) i chyba dla ekranu zdrowe nie jest.

Druga wersja miała korzystać z Launchpadowego przypisania do &#8222;Left<&#8222;, &#8222;Left>&#8221;, &#8222;Right<&#8221; i &#8222;Right>&#8221;, czyli bocznych klawiszy zmiany stron, ale okazało się, że tego LP nie umie. Spory research przyniósł poszukiwane polecenie \`waitforkey\`. Bez parametrów zwróci kod pierwszego wciśniętego klawisza i zakończy działanie (oczywiście dopiero po wciśnięciu). Kiedy dodamy kod klawisza w parametrze &#8211; zwróci exitcode 0 tylko po tym klawiszu.

Wersja ostateczna robi co następuje w pętli nieskończonej:

  * czeka na dowolny klawisz (wymusza zegar w każdym miejscu systemu &#8211; nawet w menu)
  * wstawia czas w formacie HH:MM w prawy dolny róg &#8211; niezagospodarowany przez system
  * czeka sekundę &#8211; ewentualne opóźnienie związane z wolniejszym ładowaniem strony (zwłaszcza poprzedniej w dużych książkach)
  * i ponownie wstawia zegar &#8211; czasami ekran nie zdąży się przeładować zanim wstawiony będzie tekst za pierwszym razem, a tryb wyświetlenia delay->show zamiast show->delay->show powoduje niemiłe opóźnienie, jeśli jednak ekran przeładowany będzie szybciej 😉

Kod do wstawienia gdziekolwiek do pliku <span class="lang:default EnlighterJSRAW  crayon-inline ">zegar.sh</span> , jednak modelowo umieszczam go w głównym katalogu

<pre class="lang:default EnlighterJSRAW">while [ true ]; do
    waitforkey && 
    eips 45 39 `date +"%H:%M"` && 
    sleep 1 && 
    eips 45 39 `date +"%H:%M"`
done;</pre>

Kod do wstawienia do pamięci głównej do pliku <span class="lang:default EnlighterJSRAW  crayon-inline ">launchpad/zegar.ini</span> :

<pre class="lang:default EnlighterJSRAW">[Actions]
Z = !/mnt/us/zegar.sh &
Z X = !kill `pgrep -f ".*zegar.sh"`</pre>

Ten plik ini ustawia, że wciśnięcie Shift, a potem szybko Z odpali skrypt <span class="lang:default EnlighterJSRAW  crayon-inline ">zegar.sh</span>  z <span class="lang:default EnlighterJSRAW  crayon-inline ">/mnt/us</span> , czyli dostępnej dla użytkownika pamięci (tej w FAT). Shift-Z-X ubija pętlę zegara.

Po wgraniu wciskamy Shift-Shift-Spacja (nie na raz, tylko z krótkimi odstępami), na ekranie pojawia się &#8222;**Success!**&#8221; &#8211; właśnie przeładowaliśmy LP &#8211; wystarczy tylko raz. Można dla odmiany zrobić restart urządzenia, ale to trwa wieczność. Aby odpalić nasz zegrar wciskamy Shift-Z i wracamy do czytania książek.

&nbsp;

Przydatne linki:

  * Hacki na Kindle od strony systemowej: <http://www.turnkeylinux.org/blog/kindle-root>
  * Polskojęzyczny tutorial: <http://www.eksiazki.org/odpicuj-swojego-kindle/>
  * O triggerach i zdarzeniach: <http://www.mobileread.mobi/forums/showthread.php?t=176090>
  * Lista modyfikacji &#8211; główny wątek z najnowszymi wersjami plików: <http://www.mobileread.com/forums/showthread.php?t=128704>
  * Inna strona z modyfikacjami: <http://jevopi.blogspot.com/2011/07/pimp-your-kindle.html>

&nbsp;

 [1]: http://blog.dsinf.net/wp-content/uploads/2014/05/WP_20140502_001.jpg
 [2]: http://www.eksiazki.org/odpicuj-swojego-kindle/
 [3]: http://wiki.mobileread.com/wiki/Eips