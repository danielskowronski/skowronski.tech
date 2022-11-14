---
title: Hackowanie monitora LG
author: Daniel Skowroński
type: post
date: 2013-02-22T23:32:23+00:00
url: /2013/02/hackowanie-monitora-lg/
tags:
  - hardware
  - linux embedded
  - rs-232

---
LG robi sprzęt porządny. Standardem jest, że w chyba wszystkich telewizorach i monitorach jest złącze przez zwykłych śmiertelników nieużywane złącze RS-232. Co ciekawe instrukcję do jego obsługi można znaleźć w papierowej dostarczanej razem z urządzeniem. Tym razem jeszcze nie wrzucam aplikacji do pełnego sterowania, bo chcę ją dopieścić do granic możliwości. Dziś napiszę o czymś, co zatrzymało mój zapał, a w pewnym momencie udaremniło pracę na jakiś czas. Tym czymś był _tryb PC_.

<!--break-->

  
Zgodnie z tym co podaje instrukcja nie można sterować przez port szeregowy kolorem i odcieniem, kiedy ekran jest w trybie PC. Te kontrolki zresztą są niedostępne i w menu ekranowym. Początkowo wydawało mi się, że chodzi o wejście RGB-PC, czyli D-SUB. Jednak po HDMI też się nie chciało sterować (a dokładniej ACK zwracał NG - _not good_). OK, uznałem, że się nie da, trudno.  
Ale kiedy chciałem zmienić temperaturę koloru, jakiej wartości bym nie podał - zawsze NG. Sprawdzam instrukcję raz jeszcze - "CSM można również regulować w menu obrazu". Co to ma znaczyć - nie mam pojęcia, zwłaszcza, że ów tajemniczy CSM występuje tylko raz. Pokusiło mnie o eksperyment: zmieniłem wejście na component i wydałem komendę zmiany temperatury bieli - odpowiedź brzmiała "OK".

To ostudziło mój zapał, ponieważ często zmieniam biel - do programowania wolę zimną, ale przy filmach, czy grach obraz jest nienaturalny. Spróbowałem napisać makro bazując na kodach IR z pilota (bo po COMie można go emulować - to też jest w instrukcji i to dosyć szczegółowo opisane). W menu ekranowym dostępne są jedynie presety "zimny", zwykły i "ciepły" - numeryczne 0..100 również niedostępne.  
Poległem, bo menu "pamięta" ostatnie pozycje i trzeba wiele trudu, żeby coś z tego wyszło.

Po paru godzinach zacząłem się zastanawiać, czym jest ten tryb PC. I kiedy zmieniałem wejście na antenę zauważyłem, że na liście wejść są ikonki - anteny, komputera, DVD i inne. Przypomniałem sobie, że kiedyś sam oznakowałem wszystko, żeby było przyjemniej. No zaczęło się hackowanie - wybrałem oznaczenie pierwszego HDMI na puste. I nagle w menu odblokowały się wszystkie parametry obrazu (łącznie z różnymi trybami proporcji). Czyli tryb PC to ustawialna przez użytkownika ikonka...  
Jedyny problem, który się pojawił to dziwne mapowanie rozdzielczości: w trybie 16:9 obraz FullHD był lekko przyzoomowany i nie mieścił się na ekranie (1920x1080 jest natywne dla tej matrycy, więc problem bardzo dziwny). Pomogło ratio _1:1 Pixel_. Dziwne, ale najważniejsze, że działa. Na koniec kwadrans ślęczenia nad ekranowym zaawansowanym menu kontroli obrazu, żeby ostrość ustawić - wygląda na to, że każdy "tryb" ma oddzielną pamięć schematów obrazu.

Nie mam pojęcia dlaczego projektant uznał, że na wejściu z PC nie można zmieniać barwy kolorów i temperatury bieli. Ale ważne, że nie był na tyle złośliwy, że nie zrobił jakiegoś protokołu negocjacji z nadawcą, czy jest komputerem 😉



Instrukcja do Flatron'a M2280DF: [http://www.lg.com/lgecs.downloadFile.ldwf?DOC\_ID=KROWM000318205&ORIGINAL\_NAME\_b1\_a1=POL.pdf&FILE_NAME=KROWM000318205.pdf&TC=DwnCmd](http://www.lg.com/lgecs.downloadFile.ldwf?DOC\_ID=KROWM000318205&ORIGINAL\_NAME\_b1\_a1=POL.pdf&FILE_NAME=KROWM000318205.pdf&TC=DwnCmd)