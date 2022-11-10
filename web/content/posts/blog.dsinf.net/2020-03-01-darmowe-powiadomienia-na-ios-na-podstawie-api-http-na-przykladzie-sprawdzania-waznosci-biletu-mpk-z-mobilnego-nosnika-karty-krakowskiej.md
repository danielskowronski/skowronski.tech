---
title: (Darmowe) powiadomienia na iOS na podstawie API HTTP na przykładzie sprawdzania ważności biletu MPK z mobilnego nośnika Karty Krakowskiej
author: Daniel Skowroński
type: post
date: 2020-03-01T12:23:52+00:00
url: /2020/03/darmowe-powiadomienia-na-ios-na-podstawie-api-http-na-przykladzie-sprawdzania-waznosci-biletu-mpk-z-mobilnego-nosnika-karty-krakowskiej/
featured_image: https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.13.jpg

---
Zacznijmy od zdefiniowania problemu &#8211; w Krakowie posiadacze Karty Krakowskiej mogą korzystać z biletu na dwóch nośnikach &#8211; klasycznej karty zbliżeniowej (takiej jak KKM, albo plastikowa KK), albo w aplikacji mobilnej. I można by oczekiwać że aplikacja raczy przypomnieć że bilet się kończy. Ale najwyraźniej nie w Krakowie.

Zatem trzeba coś samemu wytworzyć. Zacząłem od próby napisania aplikacji na iPhona, ale nieco poległem &#8211; trochę to jak strzelanie z armaty na komara &#8211; wszak pobranie informacji o ważności biletu to najwyżej 2 strzały HTTP, obliczenie różnicy czasu i wysłanie powiadomienia. Alternatywa wydawałoby się pozostała jedna &#8211; skrypt na serwerze który wysyła powiadomienia przez Telegrama, albo inny komunikator obsługujący boty i posiadający przyjemne API &#8211; coś w rodzaju [skryptu, który napisałem do crawlowania portalu JustJoinIT][1].

Szukając zupełnie innej rzeczy na iPhona &#8211; sposobu na dodanie skrótu łączenia się z VPN (przez natywnego klienta IPsec, nie z aplikacji typu NordVPN) przypomniałem sobie że przecież iOS od wersji 13 posiada aplikację _Shortcuts_ w której można automatyzować czynności między innymi na podstawie wyniku pobierania treści z internetu czy skryptów SSH.

Wystarczyło teraz wystawić tylko proste API, które zwróci liczbę dni do końca ważności biletu i stworzyć automatyzację wyświetlającą ładne natywne powiadomienie. Zalążek projektu [krakow-tickets-api wrzuciłem na githuba][2] i zahostowałem w pokątnym miejscu na serwerze zabezpieczając się przez nieprzewidywalną ścieżkę. Docelowo API powinno obsługiwać hasło dostępu do samego siebie i parametry w postaci loginu i hasła do strony posiadającej właściwe dane &#8211; takie informacje także można przekazać przez _Shortcuts_.

Czas na programowanie graficzne. Aplikacja jest odinstalowywalna więc pewnie większość użytkowników się jej pozbyła po aktualizacji. Dostępna jest oczywiście [w AppStore][3].<figure class="is-layout-flex wp-block-gallery-13 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41.png"><img decoding="async" loading="lazy" width="576" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41-576x1024.png" alt="" data-id="1687" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41.png" data-link="https://blog.dsinf.net/?attachment_id=1687" class="wp-image-1687" srcset="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41-576x1024.png 576w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41-169x300.png 169w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.41.png 750w" sizes="(max-width: 576px) 100vw, 576px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50.png"><img decoding="async" loading="lazy" width="576" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50-576x1024.png" alt="" data-id="1688" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50.png" data-link="https://blog.dsinf.net/?attachment_id=1688" class="wp-image-1688" srcset="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50-576x1024.png 576w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50-169x300.png 169w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.50.png 750w" sizes="(max-width: 576px) 100vw, 576px" /></a></figure>
  </li>
</ul></figure> 

Kroki przedstawione powyżej raczej nie wymagają komentarza. Testować można klikając przycisk w prawym dolnym rogu. Teraz jeszcze tylko harmonogram &#8211; wschód słońca wydał mi się dobrym wyborem i można cieszyć się powiadomieniami.<figure class="is-layout-flex wp-block-gallery-15 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29.png"><img decoding="async" loading="lazy" width="576" height="1024" src="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29-576x1024.png" alt="" data-id="1689" data-full-url="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29.png" data-link="http://blog.dsinf.net/?attachment_id=1689" class="wp-image-1689" srcset="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29-576x1024.png 576w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29-169x300.png 169w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-12.48.29.png 750w" sizes="(max-width: 576px) 100vw, 576px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20.png"><img decoding="async" loading="lazy" width="576" height="1024" src="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20-576x1024.png" alt="" data-id="1693" data-full-url="http://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20.png" data-link="http://blog.dsinf.net/?attachment_id=1693" class="wp-image-1693" srcset="https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20-576x1024.png 576w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20-169x300.png 169w, https://blog.dsinf.net/wp-content/uploads/2020/03/2020-03-01-13.17.20.png 750w" sizes="(max-width: 576px) 100vw, 576px" /></a></figure>
  </li>
</ul></figure> 

Aplikacja działa całkowicie na telefonie więc możemy wyświetlać tyle natywnych powiadomień ile chcemy. A i zapytania do API mogą lecieć o ciekawsze i potencjalnie bardziej skomplikowane rzeczy niż liczba dni ważności biletu 🙂 _Happy hacking!_

 [1]: https://github.com/danielskowronski/jjit
 [2]: https://github.com/danielskowronski/krakow-tickets-api
 [3]: https://apps.apple.com/pl/app/shortcuts/id915249334?l=pl