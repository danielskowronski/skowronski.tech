---
title: Kilka wskazówek przy ustawianiu domowego WiFi
author: Daniel Skowroński
type: post
date: 2018-06-18T15:13:43+00:00
summary: Domowe routery z WiFi wykazują problemy z wydajnością dla konfiguracji z za dużą ilością urządzeń i masą pobliskich sieci. Kilka wskazówek jak rozwiązać typowe problemy.
url: /2018/06/kilka-wskazowek-przy-ustawianiu-domowego-wifi/
tags:
  - network
  - wifi

---
Domowe routery z WiFi wykazują problemy z wydajnością dla konfiguracji z za dużą ilością urządzeń i masą pobliskich sieci. Kilka wskazówek jak rozwiązać typowe problemy.

#### 802.11ac czyli 5GHz

Najprostszym sposobem na zwiększenie zasięgu naszej sieci (a szczególnie przebicia przez ściany) i wykorzystanie rzadko używanego pasma jest włączenie radia 5GHz czyli standardu ac. Obsługuje go _większość_ współczesnych laptopów czy telefonów. Z moich obserwacji wynika że domowe routerki dostarczane przez ISP rzadko mają opcję ac i mało ludzi z tego korzysta. Więcej wolnego pasma dla nas!

Jest jednak jeden haczyk (poza ograniczonym wsparciem - zwłaszcza dla IoT o czym zaraz) - pomysł nazwania sieci 5GHz tak samo jak 2.4GHz nie jest najlepszy - urządzenia potraktują taką sytuację jak zwykły scenariusz z dwoma AP o tym samym SSID - czyli podłączą się do tego co im się wydaje za lepsze. A niektóre urządzenia będą dość długo pamiętać swój wybór. Dlatego najlepiej jest jednak dodać "_5GHz" do naszej sieci i mieć możliwość ręcznego wyboru pasma.

#### Wybór kanału

Niby routery mają opcję "auto" która skanuje pobliskie AP i wybiera najlepszy kanał, ale w praktyce zawodzi to kompletnie kiedy mamy 20 takich samych urządzeń obok siebie bo dany ISP dostarczył je wszystkim albo jakiś geniusz wciął się na np. kanał numer 2. Grafiki obrazujące zachodzenie kanałów na siebie są na Wikipedii - [https://en.wikipedia.org/wiki/List\_of\_WLAN_channels][1]

#### Kanały 12 i 13

Przez długi czas wydawało mi się że w Europie "legalne" (czyli dopuszczone do użytku) są kanały 1-11 a pozostałe 12-14 tylko w dziwnych krajach jak Japonia. Mało się  przejmując tym problemem od dawna ustawiałem w zatłoczonych miejscach kanał 13 bo żadne router nie wydawał się go używać - co znacznie poprawiało jakość sygnału. Nic bardziej mylnego - kanał 14 owszem jest dopuszczony tylko w Japonii, ale 12 i 13 są teoretycznie zabronione tylko w USA. Prawdopodobnie lenistwo developerów powoduje że większość routerów na rynek międzynarodowy zwyczajnie ignoruje ich istnienie w panelu sterowania - choć samo radio nie ma z tym problemów. Ciekawym wyjątkiem od reguły jest Funbox 3.0 od Orange. No i oczywiście wszelkie DD-WRT, Tomato i Mikrotiki 😉

Jedyny problem z użytkownikiem takiej sieci miałem w przypadku biznesowego Della który prawdopodobnie był sprowadzany ze stanów. Windows 8 udawał że naszej sieci nie widzi.

Zmiana kanału już raz wybawiła od problemu z IoT - żarówki TP-Linka w strasznie zatłoczonym otoczeniu lubiły gubić sygnał i wymagały resetu raz na jakiś czas.

#### Problemy z IoT i zasięgiem

IoT w domowej sieci to generator problemów. Poza scenariuszem [z poprzedniego wpisu][2], gdzie opisywałem jak urządzenia bez autoryzacji mogą być przejmowane (a takie które wystawiają HTTP to już zupełnie z internetu - wystarczy wejście na stronę z obrazkiem z dziwnego powodu hostowanym w sieci 192.168.0.0/16) klasycznym problemem jest przeciążenie sieci. Dodajmy do mieszkania z dwoma użytkownikami gdzie każdy ma telefon i laptopa, tabletem, kindlem, 1-2 konsolami jeszcze ze 3 żarówki, odkurzacz i żarówkę i już zwyczjne urządzenia nie będą wyrabiać. Dodatkowo praktycznie żadne takie urządzenie nie słyszało o ac - więc drugi koniec mieszkania może mieć problemy z łącznością.

Pewnym rozwiązaniem które się u mnie sprawdziło jest range extender (np. [taki od TP-Linka za około 70zł][3]). Rozwiązało to mój problem z traceniem sygnału przez jedną żarówkę i nie high-endowy tablet któremu (jak to we wszystkich tego typu konstrukcjach) radia 5GHz. Samo urządzenie jest o tyle przydatne że można wbudowany ethernet używać do podłączenia czegoś po kablu jak i zamienić całość w mały AP - co często okazuje się przydatne. A dla upartych można z niego zrobić osobną sieć dla IoT - wystarczy zmienić SSID repeatera.

#### Standardowe porady

Jeśli mamy jakiekolwiek niestandardowe urządzenia w sieci (odkurzacze które mają hostname typu "PC120" (np. Neato), zbridgowane interfejsy wirtualek, serwery itp.) warto przydzielić wszystkiemu statyczne dzierżawy DHCP, a we własnej wiki udokumentować ich MACi i adresy - żeby kiedy przyjdzie do śledztwa albo podłączania SDNa do domowej sieci nie zwariować. No i oczywiście backup konfiguracji wszelkich urządzeń infrastruktury 😉

 [1]: https://en.wikipedia.org/wiki/List_of_WLAN_channels
 [2]: https://blog.dsinf.net/2018/05/hackowanie-smart-zarowek-tp-linka-lb1xx/
 [3]: https://www.tp-link.com/us/products/details/cat-5508_TL-WA850RE.html