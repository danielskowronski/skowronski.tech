---
title: Okresowy przegląd bezpieczeństwa i prywatności oraz narzędzie do list kontrolnych – Process Street
author: Daniel Skowroński
type: post
date: 2021-01-26T22:55:41+00:00
excerpt: 'Listy kontrolne, w światach korpo-szczurów oraz IT znane bardziej jako checklisty, są bardzo przydatnym sposobem powtarzalnego wykonywania zadań, zwłaszcza okresowych. Jednym z nich może (moim zdaniem powinien) być przegląd bezpieczeństwa i prywatności osobistej - zestaw zadań od sprawdzenia, począwszy od weryfikacji czy do managera haseł nie wkradło się jakieś zbyt proste np. stworzone poza nim, poprzez wykonanie backupu kodów odzyskiwania MFA, aż po weryfikację uprawnień aplikacji na naszym telefonie.'
url: /2021/01/okresowy-przeglad-bezpieczenstwa-i-prywatnosci-oraz-narzedzie-do-list-kontrolnych-process-street/
featured_image: https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.43.50.png

---
Listy kontrolne, w światach korpo-szczurów oraz IT znane bardziej jako _checklisty_, są bardzo przydatnym sposobem powtarzalnego wykonywania zadań, zwłaszcza okresowych. Jednym z nich może (moim zdaniem powinien) być przegląd bezpieczeństwa i prywatności osobistej &#8211; zestaw zadań od sprawdzenia, począwszy od weryfikacji czy do managera haseł nie wkradło się jakieś zbyt proste np. stworzone poza nim, poprzez wykonanie backupu kodów odzyskiwania MFA, aż po weryfikację uprawnień aplikacji na naszym telefonie.

### Dygresja na dobry początek &#8211; kilka słów o narzędziu

Zanim przejdę do opisu mojej listy kontrolnej, to opiszę narzędzie, z którego korzystam od ponad 2 lat. Można bowiem trzymać plik tekstowy (na przykład w formacie Markdown) w repozytorium kodu i kopiować go za każdym razem do pliku z datą wykonania lub drukować, lecz w tym wypadku jestem fanem narzędzi z interfejsem przeglądarkowym i możliwością bardziej zaawansowanego budowania samych list &#8211; moje pierwotne wykorzystanie tego typu rozwiązania było powiązane z ręcznym okresowym przeglądem utrzymywanych systemów w labie &#8211; aktualizacji oprogramowania krytycznych serwerów, przeglądu logów, metryk itp. 

Mój wybór w czasach, kiedy infrastrukturą prywatnie nie zarządzałem centralnie (choć i dziś nie wszystkie maszyny restartuję automatycznie tuż po aktualizacji kernela) padł na Process Street &#8211; [process.st][1]. Jest to narzędzie darmowe, umożliwiające zespołową pracę nad listami kontrolnymi z dość zaawansowaną paletą elementów list (w tym approvali), a także możliwością edycji templatki listy w trakcie jej wypełniania &#8211; co jest dość częstą potrzebą w przypadku list wykonywanych rzadziej niż raz na miesiąc.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="611" src="https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-1024x611.png" alt="" class="wp-image-2120" srcset="https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-1024x611.png 1024w, https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-300x179.png 300w, https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-768x458.png 768w, https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-1536x917.png 1536w, https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40-2048x1222.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][2]<figcaption>Ekran edycji kroku w checkliście na Process Street</figcaption></figure> 

### Lista kontrolna &#8211; bezpieczeństwo

#### Hasła

Pierwsza grupa zadań jest związana z hasłami internetowymi. Zakładam, że używamy managera haseł &#8211; bez niego nie da się mieć oglądu na posiadane konta, a zwłaszcza hasła, które wówczas i tak pewnie należą do dość małoelementowego zbioru, co dalekie jest od bezpieczeństwa. 

Większość czynności wykona za nas porządne narzędzie wewnątrz takowego (osobiście polecam [Bitwarden][3]) &#8211; sprawdzenie, czy nie wkradły się do naszego zbioru duplikaty, słabe hasła (zwykle w przypadku kont tworzonych spoza zaufanej maszyny gdzie dobry zwyczaj nakazuje kliknąć przycisk random w dodatku do przeglądarki, zamiast samodzielnie coś wymyślać) oraz czy hasło nie pojawiło się w jakimś wycieku. 

W kwestii wycieków warto zapisać na powiadomienia &#8211; na przykład na [haveibeenpwned.com][4], czy [Firefox Monitor][5]. Dla pewności jednak warto raz na kilka miesięcy ręcznie wykonać zapytania w takich serwisach, najlepiej dodając nowe do kolekcji.

#### MFA

Jeśli korzystamy (a powinniśmy) z uwierzytelniania wieloskładnikowego należy zrobić także przegląd wszystkich miejsc, gdzie wykorzystujemy dodatkowe składniki. W niektórych miejscach zapewne pojawi się zapewne dodatkowy sposób, na przykład klucze U2F oprócz kodów TOTP lub cokolwiek poza kodami SMS &#8211; warto od razu dodać dodatkowe metody i jeśli jesteśmy na to gotowi &#8211; pozbyć się autoryzacji kodami SMS, aby zapobiec niebezpieczeństwu sim-swappingu. 

Poza tym, głównym celem przeglądu kont, gdzie używamy MFA, jest upewnienie się, że posiadamy kopię kodów odzyskiwania, których użyjemy, jeśli stracimy tokeny sprzętowe lub smartfona z aplikacją do kodów jednorazowych. Jeśli nie mamy paranoi bezpieczeństwa to przechowywanie kopii tychże w postaci wydruku w bezpiecznym miejscu lub na prawdziwie sprzętowo szyfrowanym nośniku nie wydaje się złym pomysłem. 

Natomiast na pewno trzymanie zdjęć wspomnianych kodów na iCloudzie czy innej tego typu usłudze nie jest roztropne &#8211; nawet jeśli używamy MFA i iPhone czyści się po 10 błędnych próbach wpisania kodu blokady. Cała idea MFA polega na utrzymaniu składników w formie oddzielonej od siebie &#8211; jeśli mamy aplikację na telefonie do kodów to niech korzysta z Secure Enclave, czy podobnego koprocesora kryptograficznego &#8211; backupy w formie jawnego tekstu w niezabezpieczonej dodatkowo aplikacji podważają ten model bezpieczeństwa.

Z tego samego powodu używanie generatora kodów jednorazowych w managerze haseł synchronizującym się ze wszystkimi naszymi urządzeniami, moim zdaniem jest pomysłem bardzo złym. 

#### Pozostałe sekrety

Poza hasłami i kodami odzyskiwania warto zadbać o klucze SSH, GPG i certyfikaty SSL w miejscach, gdzie nie następuje ich automatyczna rotacja. 

Wymiana klucza SSH do własnej infrastruktury raz na 12-24 miesięcy może wydawać się paranoją, lecz przezorny zawsze strzeżony &#8211; zwłascza, jeśli przy okazji wymienimy algorytmy kryptograficzne z RSA an ECDSA, czy przejrzymy listę kluczy dających dostęp do konta roota na naszych maszynach. 

Jeśli korzystamy z GPG w codziennym życiu to i tak mamy paranoję, zatem czemu nie rotować, lub przedłużać ważności klucza co roku?

Natomiast certyfikaty SSL nienależące do automatycznie zarządzanej infrastruktury klucza prywatnego (PKI) i ich wygasanie zwykle zależy od podmiotów zewnętrznych podpisujących nasze CSR-y certyfikatów stron WWW, czy e-maili. Poza utrzymywaniem narzędzi monitorujących ważność takowych warto raz na jakiś czas przejrzeć je dodatkowo ręcznie i przedłużyć zawczasu, na przykład wszystkie na raz.

### Lista kontrolna &#8211; prywatność

#### Smartfon/tablet

Czynnością, którą i tak wykonywałem w miarę regularnie, zanim stworzyłem checklistę bezpieczeństwa, był przegląd wszystkich ustawień oraz aplikacji na moim telefonie i tablecie &#8211; po części, by odkryć nowe funkcje, zmienić irytujące ustawienia, o których zapomniałem, czy dokonać optymalizacji przestrzeni usuwając stare aplikacje, a po części, by zwiększyć swoją prywatność.

Teraz w mojej liście kontrolnej są dwie pozycje na każde urządzenie ze sklepem z aplikacjami (co zasadniczo uwzględnia też przeglądarkę internetową), które mają kontrolowalne uprawnienia &#8211; usunięcie nieistotnych oraz przegląd uprawnień tych, które zostały. Jedno po drugim. Może się to wydawać męczące, ale jest istotne, kiedy powiadomienia z prośbami o kolejny dostęp do funkcji systemu można zbyt łatwo zamykać, zatwierdzając dostęp do naszych danych podmiotom, którym nie za bardzo można ufać. Przy okazji można świadomie podjąć decyzję o udostępnieniu Messengerowi aparatu, Google Chromowi mikrofonu, czy wyłączyć irytujące powiadomienia z jakiejś innej aplikacji.

#### Facebook lub inne media społecznościowe

Sekcja głównie skupia się na Facebooku, gdyż przy swojej popularności ma chyba najwięcej dostępnych narzędzi &#8222;kontroli&#8221; nad swoimi danymi. O części na pewno większość słyszała (chociażby o tematach, jakie Facebook uważa za interesujące dla nas, a zatem bardzo interesujące dla reklamodawców &#8211; razem z absurdalnymi kategoriami typu &#8222;ser&#8221;), ale jest ich zdecydowanie więcej. Świetnie opisuje je artykuł na Zaufanej Trzeciej Stronie &#8211; <https://zaufanatrzeciastrona.pl/post/podstawy-bezpieczenstwa-facebook-jak-zadbac-o-bezpieczenstwo-i-prywatnosc/>

Od siebie dodam wyselekcjonowane linki, w które paranoik bezpieczeństwa raczej nie będzie klikał, ale dadzą mu przynajmniej pomysły czego szukać w artykule i panelu ustawień Facebooka.

  * https://www.facebook.com/adpreferences/ 
  * https://www.facebook.com/adpreferences/advertisers/
  * https://www.facebook.com/adpreferences/?section=audience\_based\_advertising
  * https://www.facebook.com/adpreferences/advertisers/?section=clicked_advertisers
  * https://www.facebook.com/mobile/facebook/contacts/
  * https://www.facebook.com/settings?tab=location
  * https://www.facebook.com/settings?tab=facerec
  * https://www.facebook.com/settings?tab=applications&ref=settings

Dzięki takiemu przeglądowi danych można też zacząć myśleć o usunięciu konta 😉 

Oczywiście inne platformy typu Twitter, czy Instagram mają podobne narzędzia, ale ich eksplorację pozostawiam czytelnikowi.

#### Konta internetowe

Dodatkowym benefitem porządnego korzystania z managera haseł jest lista wszystkich posiadanych kont internetowych. Korzystając z prawa do bycia zapomnianym z RODO/GDPR możemy skutecznie pozbyć się ich z miejsc, których nie korzystamy, a które mogą potencjalnie przetwarzać dane, których byśmy nie chcieli. 

Za pierwszym razem będzie to żmudne &#8211; w moim wypadku usunąłem od razu lub zażądałem e-mailowo usunięcia moich danych na 183 z 333 serwisów internetowych &#8211; czyli na ponad połowie. Oczywiście przed usunięciem zazwyczaj korzystałem z innego prawa zapisanego w RODO &#8211; przeniesienia danych, czyli eksportu najczęściej do formatu JSON wszelkich danych, jakie mieli. 

Taki przegląd dokonywany regularnie zapewnia spokój ducha i redukuje spam w skrzynce mailowej.

### Podsumowanie

Jeśli chcemy dbać o własne bezpieczeństwo i prywatność w internecie, poza dobrymi praktykami na co dzień, warto też regularnie przeglądać listy kontrolne i zawartość managera haseł tak, by nic nam nie umknęło. Mimo iż za pierwszym razem praca będzie się wydawać żmudna i może zająć cały weekend to warto zrobić pierwszy przegląd, by wybrać tematy, nad którymi będziemy chcieli regularnie pracować.

Niektórzy do opisanych wyżej kategorii i przykładów okresowych zadań dodadzą zapewne zupełnie inne pozycje jak na przykład audyty bezpieczeństwa, aktualizowanie oprogramowania w routerach itp &#8211; w moim wypadku te znajdują się na cotygodniowej checkliście maintenance&#8217;owej.

 [1]: https://process.st
 [2]: https://blog.dsinf.net/wp-content/uploads/2021/01/Screenshot-2021-01-26-at-23.40.40.png
 [3]: http://bitwarden.com/
 [4]: https://haveibeenpwned.com/
 [5]: https://monitor.firefox.com/