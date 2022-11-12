---
title: Kilka koncepcji na zabezpieczanie PHP przy obróbce plików z podaniem ich ścieżki + wykonywaniem poleceń systemowych
author: Daniel Skowroński
type: post
date: 2014-07-08T11:10:41+00:00
excerpt: "Problem ten dotyka głównie skrypty siedzące w katalogach <i>hardadmin</i>, mających super zabezpieczenia i przeznaczonych do wygodnej edycji plików konfiguracyjnych przez WWW bez konieczności wpinania się do SSH (głównie tam, gdzie nie jest to możliwe). Jeśli mamy stałą liczbę plików to nic prostszego jak je stablicować i nadać nawet prymitywne indeksy numeryczne. Ale szczególnie gdy chcemy mieć możliwość dodawania plików sprawa się komplikuje. Naszym zadaniem będzie uniemożliwić atakującemu podanie <b>../</b> lub innych cudów aby ten mógł w najgorszym wypadku namieszać tylko z tą jedną usługą którą zarządza nasz skrypt (np. konfigami nginx'a)."
url: /2014/07/kilka-koncepcji-na-zabezpieczanie-php-przy-obrobce-plikow-z-podaniem-ich-sciezki-wykonywaniem-polecen-systemowych/
tags:
  - php

---
Problem ten dotyka głównie skrypty siedzące w katalogach _hardadmin_, mających super zabezpieczenia i przeznaczonych do wygodnej edycji plików konfiguracyjnych przez WWW bez konieczności wpinania się do SSH (głównie tam, gdzie nie jest to możliwe). Jeśli mamy stałą liczbę plików to nic prostszego jak je stablicować i nadać nawet prymitywne indeksy numeryczne. Ale szczególnie gdy chcemy mieć możliwość dodawania plików sprawa się komplikuje. Naszym zadaniem będzie uniemożliwić atakującemu podanie **../** lub innych cudów aby ten mógł w najgorszym wypadku namieszać tylko z tą jedną usługą którą zarządza nasz skrypt (np. konfigami nginx'a).

Tworzenie skomplikowanej listy tokenów jest nie na miejscu, szczególnie gdy zależy nam na szybkim stworzeniu skryptu. Najprostszym rozwiązaniem jest przekazywanie przez GET czy POST (choć tu GET jest lepszy - w logach widać co kto robił) dwóch zmiennych - ścieżki i "tokenu". Ścieżka - koniecznie względna i najlepiej nigdzie w interfejsie nieujawniana - wystarczy zapisać ją jako zmienną i dodawać potem do parametru z get-a i po sprawie. Tokenem może być po prostu md5 z pełnej ścieżki pliku z dodaniem losowej wartości, której to wartości pod żadnym pozorem nie przekazujemy kanałem użytkownika! Najlepiej użyć $_SESSION i aktualizować co listowanie obiektów - może i powolne, ale za to bezpieczne.

Jeśli obrabiamy pliki i chcemy mieć dodatkowy bonus - uniemożliwienie aktualizacji pliku, gdy ktoś zrobił to w międzyczasie (np. my edytujemy przez web-ui a inny admin zrobił to szybciej via sftp) jest kolejny sposób, znowu z md5. Tym razem funkcja md5_file - znowu przekazujemy jej wartość przez get /post i problem z głowy.

No ale co z _tworzeniem_ plików? Tu starczy regex ;] Przykładowo 

<pre class="lang:default EnlighterJSRAW " >function isOK( $string ) {
  if ( empty( $string ) ) return false;
  $string = preg_replace( "/[a-zA-Z0-9\.\-\_]/i", "", $string );
  if ( ! empty( $string ) ) return false;
  return true;
}
</pre>

zabezpiecza nas przed: L2 - pustym stringiem (możliwość uszkodzenia katalogu - prefiksu),  
L3..L4 - jeśli zamienimy wszystkie litery, cyfry, kropki, myślniki i podłogi to powinien zostać nam pusty string; jeśli coś tam było - są to niebezpieczne znaki - wówczas stringa odrzucamy

Na koniec bonus - zabezpieczanie wykonywania poleceń systemowych. Czasem trzeba wykonać coś jako root - np. przeładować nginxa żeby konfigi załadował. Jest na to sposób - w /etc/sudoers dodajemy: 

<pre class="lang:default EnlighterJSRAW " >nginx ALL = NOPASSWD: /tajna_ścieżka_z_prawami_110/tajny_plik.sh</pre>

i w tym tajnym_pliku.sh dopisujemy logowanie do pliku.  
Ryzyko - spore, jeśli komendy mogą namieszać w systemie. Czy nie powinniśmy wyłączyć w ogóle shell_exec'a i innych? Najlepiej, jeśli już musimy używać takiego własnego cpanel'a postawić drugą instancję php-fpm, która będzie miała takie możliwości i solidnie oddzielić tego vhosta od pozostałych, szczególnie blokując prawa do zapisu na plikach wykonywalnych.  
Jeśli mamy dobrze skonfigurowany system to każda próba wywołania sudo z poleceniem nieuwzględnionym w /etc/sudoers root dostanie maila. Domyślnie w CentOS.