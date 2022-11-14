---
title: (Darmowe) powiadomienia na iOS na podstawie API HTTP na przykładzie sprawdzania ważności biletu MPK z mobilnego nośnika Karty Krakowskiej
author: Daniel Skowroński
type: post
date: 2020-03-01T12:23:52+00:00
url: /2020/03/darmowe-powiadomienia-na-ios-na-podstawie-api-http-na-przykladzie-sprawdzania-waznosci-biletu-mpk-z-mobilnego-nosnika-karty-krakowskiej/
featured_image: /wp-content/uploads/2020/03/2020-03-01-12.48.13.jpg

---
Zacznijmy od zdefiniowania problemu - w Krakowie posiadacze Karty Krakowskiej mogą korzystać z biletu na dwóch nośnikach - klasycznej karty zbliżeniowej (takiej jak KKM, albo plastikowa KK), albo w aplikacji mobilnej. I można by oczekiwać że aplikacja raczy przypomnieć że bilet się kończy. Ale najwyraźniej nie w Krakowie.

Zatem trzeba coś samemu wytworzyć. Zacząłem od próby napisania aplikacji na iPhona, ale nieco poległem - trochę to jak strzelanie z armaty na komara - wszak pobranie informacji o ważności biletu to najwyżej 2 strzały HTTP, obliczenie różnicy czasu i wysłanie powiadomienia. Alternatywa wydawałoby się pozostała jedna - skrypt na serwerze który wysyła powiadomienia przez Telegrama, albo inny komunikator obsługujący boty i posiadający przyjemne API - coś w rodzaju [skryptu, który napisałem do crawlowania portalu JustJoinIT][1].

Szukając zupełnie innej rzeczy na iPhona - sposobu na dodanie skrótu łączenia się z VPN (przez natywnego klienta IPsec, nie z aplikacji typu NordVPN) przypomniałem sobie że przecież iOS od wersji 13 posiada aplikację _Shortcuts_ w której można automatyzować czynności między innymi na podstawie wyniku pobierania treści z internetu czy skryptów SSH.

Wystarczyło teraz wystawić tylko proste API, które zwróci liczbę dni do końca ważności biletu i stworzyć automatyzację wyświetlającą ładne natywne powiadomienie. Zalążek projektu [krakow-tickets-api wrzuciłem na githuba][2] i zahostowałem w pokątnym miejscu na serwerze zabezpieczając się przez nieprzewidywalną ścieżkę. Docelowo API powinno obsługiwać hasło dostępu do samego siebie i parametry w postaci loginu i hasła do strony posiadającej właściwe dane - takie informacje także można przekazać przez _Shortcuts_.

Czas na programowanie graficzne. Aplikacja jest odinstalowywalna więc pewnie większość użytkowników się jej pozbyła po aktualizacji. Dostępna jest oczywiście [w AppStore][3].

![](/wp-content/uploads/2020/03/2020-03-01-12.48.41.png)

![](/wp-content/uploads/2020/03/2020-03-01-12.48.50.png)

Kroki przedstawione powyżej raczej nie wymagają komentarza. Testować można klikając przycisk w prawym dolnym rogu. Teraz jeszcze tylko harmonogram - wschód słońca wydał mi się dobrym wyborem i można cieszyć się powiadomieniami.

![](/wp-content/uploads/2020/03/2020-03-01-12.48.29.png)

![](/wp-content/uploads/2020/03/2020-03-01-13.17.20.png)


Aplikacja działa całkowicie na telefonie więc możemy wyświetlać tyle natywnych powiadomień ile chcemy. A i zapytania do API mogą lecieć o ciekawsze i potencjalnie bardziej skomplikowane rzeczy niż liczba dni ważności biletu 🙂 _Happy hacking!_

 [1]: https://github.com/danielskowronski/jjit
 [2]: https://github.com/danielskowronski/krakow-tickets-api
 [3]: https://apps.apple.com/pl/app/shortcuts/id915249334?l=pl