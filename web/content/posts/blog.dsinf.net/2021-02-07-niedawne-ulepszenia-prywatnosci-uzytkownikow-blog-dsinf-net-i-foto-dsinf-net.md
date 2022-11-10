---
title: Niedawne ulepszenia prywatności użytkowników blog.dsinf.net i foto.dsinf.net
author: Daniel Skowroński
type: post
date: 2021-02-07T14:19:39+00:00
excerpt: Od jakiegoś czasu moje osobiste celowanie w prywatność stało się jeszcze większym priorytetem i uznałem, że czas zająć się także moim blogiem. Efektem tych działań było między innymi pozbycie się usług Google oraz WordPressa.
url: /2021/02/niedawne-ulepszenia-prywatnosci-uzytkownikow-blog-dsinf-net-i-foto-dsinf-net/
featured_image: https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-14.57.48.jpg
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1

---
Od jakiegoś czasu moje osobiste celowanie w prywatność stało się jeszcze większym priorytetem i uznałem, że czas zająć się także moim blogiem. Efektem tych działań było między innymi pozbycie się usług Google oraz WordPressa.

Jeśli w życiu prywatnym przesiada się człowiek na DuckDuckGo, to utrzymywanie na blogu Google Analytics czy Google Fonts nie jest do końca uczciwe. Dlatego też na moich platformach blog.dsinf.net, foto.dsinf.net (i w najmniejszym stopniu, ale zawsze &#8211; na www.skowron.ski) dokonałem prac mających zredukować liczbę zbędnych usług śledzących odwiedzających wspomniane strony WWW. Podsumowaniem tego jest polityka prywatności dostępna na <https://skowron.ski/privacy_policy.html>, którą można podsumować następująco: Plausible Analytics, Cloudflare, logi diagnostyczne na serwerze i brak zewnętrznych dostawców fontów, skryptów itp.

## Plausible Analytics

Do tej pory za analitykę ruchu na blogu odpowiadały Google Analytics i Jetpack (od WordPressa). Z ich obszernych funkcjonalności zasadniczo wykorzystywałem tylko ilość gości, najpopularniejsze posty oraz zewnętrzne strony i zapytania w Google, po których ludzie do mnie trafiali. 

Jetpack po prostu kiedyś zainstalowałem i zostawiłem aktywny (dodawał bowiem kilka funkcjonalności, które oczywiście obecnie są zastąpione innymi wtyczkami), nie będąc świadomym, że większa część przetwarzania dzieje się na serwerach wordpress.com, a ich skrypty śledzące są dorzucane do treści strony. Jedyny zysk z tej analityki polegał na lepszej integracji z samym backendem WordPressa. Lepszy oczywiście wordpress.com niż Google, ale po co dawać innym dane użytkowników.

Google Analytics był ze mną od bardzo dawna, gdyż nie było za bardzo lepszych alternatyw, zwłaszcza udostępniających tak wygodny interfejs, jak GA kilka lat temu. Obecnie to dość duży bałagan.

Przez pewien czas próbowałem używać Matomo, czyli nowej inkarnacji Piwika, gdyż skusiła mnie możliwość importu danych z GA, lecz powolność procesu związana z ograniczeniami w API Googole spowodowała, że go porzuciłem. Podstawowy problem polegał na zbyt dużej mnogości dashboardów, które autora prostego bloga mało interesują. 

Wówczas odkryłem Plausible Analytics ([plausible.io][1]) &#8211; skupioną na prywatności i zgodności z GDPR minimalistyczną platformę opensource, która oferuje także wariant hostowany u twórców (za naprawdę niską opłatą). Skrypt jest lekki, a dashboardy skupione na tym, co jest dla mnie ważne. No i przede wszystkim, nie są zbierane zbędne, czyli w tym wypadku identyfikujące personalnie (PII) dane. 

## Cloudflare

W kwestii prywatności można mieć wątpliwości, czy dodatkowy pośrednik w ruchu między użytkownikiem końcowym a serwerem WWW to coś niezbędnego. Z jednej strony są tylko jak kolejny ISP po drodze, z drugiej odpowiadają oni za ruch już rozszyfrowany. 

Technicznie jest to zło konieczne dla stabilności bloga i jego dostępności w sensownym czasie dla użytkowników końcowych. Pomijając ilość funkcji dostępnych za darmo dla dobra internetu, Cloudflare jest mocno zaangażowany w prywatność internetu i (na razie) nie idzie w kierunku Google. Dla sceptyków dość interesujący może okazać się ten artykuł: <https://blog.cloudflare.com/privacy-and-compliance-reading-list/>

## Zewnętrzni dostawcy treści osadzonych

Umieszczanie na swojej stronie, czy webowej aplikacji odnośnika do jQuery, czy Font Awesome hostowanego na publicznym CDNie twórców, Google, Microsoftu czy GitHuba może się wydawać bardzo kuszące, zwłaszcza że w dłuższej perspektywie, jeśli wiele stron korzysta z tego samego pliku, to użytkownik końcowy oszczędza ruch sieciowy. Jednak przy pewnych warunkach właściciele takich CDNów mogą uzyskać informację, jaka strona odesłała tam konkretnego użytkownika, tym samym zdradzając im jaką stronę odwiedził. Podobny problem wygenerował bardzo słaby ruch ze strony maintainerów Raspberry Pi OS &#8211; patrz [https://www.reddit.com/r/raspberry\_pi/comments/lc07um/microsoft\_repo\_stealth\_added\_in\_latest_rpios/][2]. Użytkownik końcowy może walczyć z tym używając plug-inów do przeglądarki w rodzaju [Decentral Eyes][3], ale prywatność w internecie to przełącznik, który powinien domyślnie być ustawiony na &#8222;on&#8221;.

Dlatego też na moich stronach wszystkie skrypty i multimedia są hostowane razem z resztą treści &#8211; dostarczane są i tak za pośrednictwem Cloudflare. 

Problem, z którym borykałem się najdłużej to usługa Google Fonts. Jest uzależniająco łatwa do użycia &#8211; wystarczy dodać jedną linijkę z importem ich kodu CSS i można już przypisywać fonty do elementów HTMLowych &#8211; bez żadnego wgrywania wielu plików na serwer (zwłaszcza, w czasach braku jednego formatu czcionek internetowych). Kiedy zająłem się spisywaniem polityki prywatności, odkryłem, że Google nie ma żadnej polityki prywatności dotykającej obszaru Google Fonts i innych treści z gstatic.com. Nie dziwi to, jeśli śledzi się temat unikania przez nich aktualizowania aplikacji na iOS &#8211; tak, żeby nie użyć _privacy labels_ wymaganych a App Store jasno deklarujących jakich danych użytkowników używają w swoich celach (patrz &#8211; <https://www.theverge.com/2021/1/26/22250648/google-apple-app-store-privacy-label>). 

Ponieważ (prawdopodobnie za bardzo) lubię fonty Ubuntu i Ubuntu Mono to jakiś hosting tychże jest mi potrzebny. Dlaczego jednak nie trzymać po prostu dwóch plików `woff2` na swoim własnym serwerze i zamiast używania specjalizowanych plug-inów do WordPressa (np. WP Google Fonts), skorzystać z takiego, którego i tak wykorzystuję do wstawek HTML/CSS/JS (który pozwala dodawać treść z UI WordPressa, bez edycji kodu motywu) &#8211; <https://pl.wordpress.org/plugins/custom-css-js/> <figure class="wp-block-image size-large is-resized">

[<img decoding="async" loading="lazy" src="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21-1024x729.png" alt="" class="wp-image-2136" width="843" height="600" srcset="https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21-1024x729.png 1024w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21-300x214.png 300w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21-768x547.png 768w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21-1536x1094.png 1536w, https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21.png 1724w" sizes="(max-width: 843px) 100vw, 843px" />][4]<figcaption>Rozwiązanie może i nieco mniej eleganckie (zwłaszcza, jeśli motyw nie daje możliwości wyboru własnego fonta),  
ale dające dużo więcej władzy nad ustawieniami.</figcaption></figure> 

## Standardowe logi na serwerze

To obszar wymagający ode mnie jeszcze trochę pracy &#8211; logi serwerów `nginx` i `php-fpm` są przeze mnie przechowywane w domyślnym formacie &#8211; razem z _prawdziwymi IP_ dostarczanymi przez Cloudflare, jak i pełnymi nagłówkami uwzględniającymi _User agent_. Logi te trafiają poza centralnym serwerem logów także na zewnętrzne backupy. 

Jest to dość standardowa praktyka w internecie, lecz moim zdaniem wymagająca poprawy &#8211; oczywiście i tak serwer WWW musi przetworzyć zapytanie od użytkownika w pełnej treści, nawet jeśli za chwilę ma odrzucić wszystkie PII, to przez kilka cykli procesora będą one w pamięci &#8211; to nieuniknione. Jednak zwykle nie trzeba przechowywać bliżej nieznany czas całego adresu IP czy wszystkich szczegółów o komputerze, którymi chwalą się przeglądarki internetowe. 

Chciałbym, żeby kiedyś serwery takie jak nginx miały w konfiguracji flagę, którą trzeba specjalnie ustawić tak, żeby logować wszystkie szczegóły połączeń, domyślnie odrzucając zbędne zazwyczaj dane. Na razie przede mną jednak trochę zmian w plikach konfiguracyjnych, a żeby miało to sens &#8211; wypada zrobić to kompleksowo, upewniając się, że przy okazji nie pozbawiam się istotnych danych diagnostycznych, czy związanych z bezpieczeństwem mojej platformy.

## Podsumowanie

Prywatność ma znaczenie, warto więc jako webmaster przemyśleć, czy używanie prostego rozwiązania jest warte zmniejszania prywatności swoich użytkowników i karmienia potworów internetu kolejnymi danymi.

 [1]: https://plausible.io/
 [2]: https://www.reddit.com/r/raspberry_pi/comments/lc07um/microsoft_repo_stealth_added_in_latest_rpios/
 [3]: https://decentraleyes.org/
 [4]: https://blog.dsinf.net/wp-content/uploads/2021/02/Screenshot-2021-02-07-at-15.01.21.png