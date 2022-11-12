---
title: MFA dzięki smartfonowi oraz garść dygresji o bezpieczeństwie
author: Daniel Skowroński
type: post
date: 2019-08-27T19:54:14+00:00
url: /2019/08/mfa-dzieki-smartfonowi-oraz-garsc-dygresji-o-bezpieczenstwie/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/07/Kryptonite_DC_Comics.jpg
tags:
  - iphone
  - mfa
  - security
  - ssh
  - u2f
  - windows
  - zabezpieczenia

---
 

Zabezpieczenie cyfrowej tożsamości przy pomocy samego loginu i hasła to jak wiadomo od dawna za mało. MFA (czyli Multi Factor Authentication) dodaje drugi składnik potrzebny do weryfikacji autentyczności - poza znajomością sekretów które wprost podajemy na przykład stronie internetowej potrzebne jest coś, co posiadamy, czyli klucz bezpieczeństwa lub coś co pozwoli nam odebrać token od miejsca, do którego się logujemy.

#### Dwie dygresje o weryfikacji autentyczności

Od razu dygresja - na początek językowa. Weryfikacja autentyczności to nie autoryzacja. Wiele osób używa określenia _autentykacja_ które jest dość wygodną kalką językową, będącą analogią autoryzacji. Ale niektórzy dostają szału słysząc to słowo, więc postaram się go nie używać.

Dygresja do dygresji - tym razem techniczna. _Weryfikacja autentyczności_ to sprawdzenie czy jesteśmy tym za kogo się podajemy, na przykład upewnienie się, że logując się do banku wchodzimy na swoje konto. A autoryzacja zapewni, że przelejemy pieniądze tylko ze swojego rachunku. Te dwa aspekty bezpieczeństwa łączą się, ale zawsze trzeba weryfikować je osobno o czym często developerzy zapominają.

### "Coś co posiadamy"

Idąc za ciosem wyjaśnię kwestię tego słynnego "czegoś co posiadamy". Tak naprawdę w przypadku chyba wszystkich form wieloskładnikowego logowania sprowadza się to jednak do znajomości kolejnego sekretu - najczęściej albo klucza prywatnego w przypadku typowych kluczy bezpieczeństwa jak Yubikey gdzie podpisujemy request i odsyłamy go do systemu logowania lub seedu jak w TOTP. 

Nawet systemy wysyłające SMSy najbardziej zbliżone do kwestii posiadania sprowadzają się możliwości zalogowania się w sieci jako użytkownik z danym numerem telefonu. 

Kwestia bezpieczeństwa drugiego składnika zależy od zabezpieczenia owego sekretu i zabezpieczenia dostępu do urządzenia. Od strony użytkownika na przykładzie aplikacji TOTP takiej jak Google Authenticator są to: uniemożliwienie dostępu złym aktorom do seedów (między innymi innym aplikacjom do miejsca ich przechowywania w pamięci telefonu) i zapewnienie, że tylko właściciel będzie mógł uzyskać kody jednorazowe (zwykle ten ciężar spoczywa na samym OSie telefonu i ekranie blokady).

Są różne poziomy zabezpieczania samego sekretu w MFA. Dedykowane tokeny sprzętowe (takie jak RSA SecurID) często chronione są przed otwarciem w taki sposób, że każde manipulowanie przy nich które umożliwiłoby zrzucenie zawartości pamięci powoduje wymazanie jej zawartości. W kwestii _tamperproofnessu_ polecam [film z kanału EEVblog w którym otwierany jest POS-owy terminal kart płatniczych][1].

#### MFA na czymś co każdy posiada, czyli smartfonie

Znaczna większość ludzi używa smartfonów i nosi je wszędzie. Zatem chociaż w kwestii współczynnika zagubień jest najlepiej - mało kto chodzi wszędzie z tokenem RSA wszędzie, ale telefon zabieramy zwykle do toalety. 

Oczywiście jeśli używamy telefonu do logowania musi być bezwzględnie zabezpieczony przed nieuprawnionym użyciem. Długi kod PIN plus biometria to _must have_. Funkcja wymazania pamięci to kilku niedanych próbach odblokowania także.

W powyższej kwestii oraz bezpieczeństwie samego środowiska (braku możliwości ominięcia ekranu blokady, ochrony przed złośliwym oprogramowaniem itp.) króluje Apple. Jak każde zabezpieczenie jest do złamania i są firmy oferujące organom ścigania (które po angielsku nazywają się adekwatniej w tej kwestii - _wymuszania prawa_) dostęp do sekretów na iPhonach, ale póki nie jesteśmy podejrzani o szpiegostwo czy morderstwo to raczej organy owe nie będą uciekać się do takich metod, które nie są zawsze skuteczne. Przed większością "prywatnych" instytucji też się uchronimy.

## Zabezpieczanie dostępu do portali WWW

### Kody SMS

Przez dość popularne ataki typu _sim swapping_ polegające na wyłudzeniu od operatora duplikatu karty SIM, co umożliwia złym aktorom otrzymanie kodu na swój telefon metoda niezbyt bezpieczna. Oczywiście lepsza niż żadna. 

Ważna uwaga - SMSy trzeba wówczas chronić - zarówno przed odczytaniem na ekranie blokady, jak i przed aplikacjami żądającymi uprawnień odczytu SMSów lub powiadomień w których treści kod może być zawarty. 

Zabawię się w Niebezpiecznika i przypomnę, żeby CZYTAĆ OPIS OPERACJI PRZED PRZEPISANIEM KODU Z SMSA.

#### Dygresja o sim swappingu

Opcją zabezpieczenia się przed przynajmniej częścią przypadków (póki nie trafimy na przestępców mających swoich ludzi głęboko w strukturach operatora) jest korzystanie z usług operatorów wirtualnych, do których dostępu nie ma przez kanały ich "rodziców". Dobrym przykładem jest nju mobile - mimo że nawet rachunki płaci się na rzecz Orange to tak rozgraniczone są usługi, że jedyna opcja kontaktu to własny portal WWW i telefon. Żeby zamówić duplikat karty należy uzyskać dostęp do portalu klienta, zamówić kartę na adres tam podany (jego zmiana wymaga rzecz jasna kodu SMS) i aktywacji telefonicznej wymagającej znajomości kodu abonenckiego. A z mojego doświadczenia operator dzwoni do klienta w sprawie aktywacji nowej karty (co pozwala uniknąć opłaty za kontakt z BOKiem).

#### TOTP czyli kody jednorazowe

Generalnie zabezpieczenie to polega na odczytaniu sześciocyfrowego kodu z urządzenia (fizycznego tokenu lub aplikacji w telefonie) i wpisaniu go w aplikacji po podaniu zwykłego hasła - jako potwierdzenie, że posiadamy dostęp do tego urządzenia, czyli jest większa szansa, że my to my. Oraz że wycieknięte jakkolwiek hasło nie wystarczy do logowania.

<p class="has-text-align-left">
  Kody TOTP nie są do końca jednorazowe - są to zwykle liczby od 0 do 999999 generowane (zwykle) raz na 30 sekund na podstawie daty i seedu, czyli sekretu, który udostępnia strona w trakcie parowania aplikacji. Zazwyczaj w formie kodu QR.
</p>

Jeśli wstrzelimy się w 30 sekundowe okno to przechwytując transmisję jako Man-In-The-Middle możemy wykorzystać ten sam kod raz jeszcze - bez konieczności na przykład spoofowania użytkownikowi strony gmaila samemu w międzyczasie wykonując niecne operacje.

#### U2F czyli nowe możliwości

U2F, czyli Universal 2nd Factor to opensourcowy standard za który obecnie odpowiedzialne jest FIDO. W skrócie jest to sposób na komunikację różnych urządzeń trzymających sekrety z komputerem za pomocą USB lub NFC. Eliminuje to potrzebę przepisywania kodów TOTP i daje możliwość stosowania mocniejszych metod ochrony sekretów czy negocjacji ich przekazywania.

Przeglądarki internetowe (Chrome i Firefox, od niedawna także te w smartfonach) posiadają mechanizm pozwalający na komunikację z takimi urządzeniami. Poza tym w trybie OTP żadne sterowniki nie są potrzebne, gdyż klucz przekazywany jest jako sekwencja emulowanych kliknięć na klawiaturze więc można śmiało korzystać na dowolnej maszynie, także takiej gdzie nie mamy praw administratora.

Kolejna przewaga U2F to możliwość używania wielu kluczy - możemy jeden nosić przy sobie, drugi mieć w zamykanej szafce w domu, a trzeci zakopany w ogródku. Do dostępu wystarczy tylko jeden. Oczywiście w zastosowaniu profesjonalnym administratorów może być kilku, a backup w firmowym sejfie też nie zaszkodzi.

U2F daje jeszcze jedną istotną funkcję - niektóre protokoły dają użytkownikowi możliwość weryfikacji co potwierdzamy - na przykład jaki adres IP zarequestował dostęp do danej części konta internetowego

## Nie tylko webaplikacje...

### Zabezpieczanie logowania SSH

SSH z wykorzystaniem PAM (czyli _Pluggable Authentication Modules_) umożliwia praktycznie nieskończone możliwości rozszerzania standardowego logowania loginem+hasłem bądź kluczem prywatnym. Jedną z nich jest OTP - czyli po zalogowaniu "klasycznym" trzeba podać kod z aplikacji lub wcisnąć przycisk na Yubikeyu. Możliwości oczywiście jest znacznie więcej.

Można to zrobić na przykład [w ten sposób][2].

### Logowanie do stacji roboczej 

#### Windows Hello

Windows Hello to protokół dla oprogramowania na Windowsie umożliwiający odblokowywanie stacji roboczej oraz uwierzytelnianie operacji - klasyczny UAC, dostęp do kluczy kryptograficznych z magazynu systemowego, czy w zasadzie co dowolna aplikacje zewnętrzna zażąda, na przykład 1password może go użyć do odblokowania sejfu.

Zasadniczo miało to służyć sterownikom urządzeń biometrycznych na przykład czytników linii papilarnych, żeby nie tworzyć miliona sposobów omijania logowania (głównie poprzez brutalne zapisanie hasła i wpisanie go na ekranie blokady za użytkownika). Ale nic nie stoi na przeszkodzie, żeby zamiast kupować dedykowany czytnik odcisku palca do komputera użyć ten w iPhonie czy innych telefonach - wystarczy, że będziemy mieć zaufaną aplikację komunikującą się na przykład po Bluetooth z agentem na komputerze. Zatwierdzenie logowania odbywa się tylko po użyciu TouchID albo FaceID

#### GoTrust ID

Przykładem aplikacji, która umożliwia takie logowanie z Windows Hello, a w niedalekiej przyszłości także na macOS jest [GoTrust ID][3]. Za 88zł rocznie możemy z iPhona lub Androida odblokować Windowsa z użyciem TouchID. Darmowa wersja oferuje zatwierdzanie logowania na podstawie odległości (i faktu włączenia aplikacji - zawsze coś). Używam od kilku miesięcy i spisuje się nieźle, proces parowania jest bardzo prosty.

Testowałem także podobne rozwiązanie - [ATKey.Phone][4] i było niestety bardzo zbugowane, jeśli chodzi o windowsowego agenta a także UI aplikacji.

#### Unlox

A co z macOS, póki GoTrust ID nie ogarnia Apple'a? Pozostaje podobna aplikacja o nazwie [Unlox][5]. Bardzo przyjemnie współpracuje z moim macbookiem, a potrafi poza blokowaniem/odblokowaniem ekranu sterować także odtwarzaczem muzyki i głośnością.

## Krypton



<div class="wp-block-media-text alignwide is-vertically-aligned-top" style="grid-template-columns:18% auto">
  <figure class="wp-block-media-text__media">![Znalezione obrazy dla zapytania krypt.co](https://pbs.twimg.com/profile_images/783749088730841091/oc7J3mVX.jpg)</figure>
  
  <div class="wp-block-media-text__content">
    <p>
      Aplikacja, której używanie przeze mnie spowodowało napisanie tego artykułu to <a href="https://krypt.co/">Krypton</a>. <strong>Jest to połączenie aplikacji obsługującej U2F dla aplikacji webowych, agenta SSH umożliwiającego autoryzację pojedynczych logowań oraz agenta GPG służącego do podpisywania commitów gitowych.</strong>
    </p>
    
    <p>
      Od jakiegoś czasu aplikacja dostała także klasyczną funkcjonalność <strong>"aplikacji do TOTP"</strong> czyli alternatywę dla Google Authenticatora do generowania kodów jednorazowych.
    </p>
  </div>
</div>

#### Jak to działa

Poza aplikacją na telefon (która ze względów bezpieczeństwa nie jest backupowalna - tak jak fizyczne klucze U2F; bezpieczeństwo na iPhonie zapewnia [Secure Enclave Processor][6]) potrzebujemy pluginu na komputerze z którego korzystamy. Dla Firefoxa i Chrome'a jest to rozszerzenie, które po sparowaniu za pomocą kodu QR emuluje sprzętowy klucz i strony internetowe nie wiedzą, że po drugiej stronie U2F jest aplikacja - bo nie muszą. 

Do celów jak to nazywa wydawca "deweloperskich" mamy małego daemona unixowego (Linuks i macOS działają dobrze), który nie wymaga uprawnień admina do instalacji (poza oczywiście używaniem managera pakietów). Działa bardzo dobrze z WSL (czyli Windowsowywm Subsystemem Linuksa), tak więc na okienkach też popracujemy w terminalu z Kryptonem. Po sparowaniu poprzez QR kod narysowany ascii-artem należy już tylko zdeployować klucz publiczny ssh kryptona na systemy które chcemy z nim używać - poza serwerami warto użyć go do githuba. Jeśli o githubie mowa - można bardzo łatwo włączyć też podpisywanie commitów.

Generalnie całość jest wygodnie konfigurowalna za pomocą aplikacji mobilnej i polecenia **kr**. 

#### Bezpieczeństwo

Zasadniczo jest bezpiecznie. 

Mamy kod źródłowy, który niedługo ma być open source (na razie jest wrzucony na githuba), przemyślany model zabezpieczania SSH (klucz prywatny przechowywany jest na telefonie, a daemon kr na komputerze dostaje jednorazowy klucz na pojedyncze logowanie), autoryzujemy każde logowanie (lub puszczamy wszystkie dostępy do danego hosta lub wszystkich z jednego komputera (klienta ssh) na 3 godziny). 

Ale oczywiście przy implementacji tego na produkcyjną skalę warto dokonać głębszego audytu. A da się używać Kryptona w większych systemach bowiem po kontakcie z twórcami można dostać wersję biznesową, która dostarcza chociażby możliwość potrzeby autoryzacji dostępu przez kilka osób czy współdzielenie dostępów.

### Dlaczego warto?

**Niskim kosztem** (aplikacja jest darmowa) **i nakładem pracy** (wystarczy przejrzeć wszystkie konta pod katem dostępności TOTP - co ułatwia na przykład 1password na podstawie zapisanych haseł oraz U2F - tu pomaga na przykład [dongleauth.info][7]) **dostajemy znacznie podniesione bezpieczeństwo - jeśli tylko ufamy naszemu telefonowi że ochroni nas przed złymi ludźmi którzy na nas czyhają** (inne to zaufanie będzie zwykłego użyszkodnika, inne SysAdmina, inne CEO większej firmy) **i przed którymi mamy szansę się w ogóle obronić** (NSA puka do Google'a o pominięcie logowania, a Google... już ma nasze dane).

 [1]: https://www.youtube.com/watch?v=tCgtTPwlDSo
 [2]: https://www.privacyidea.org/ssh-keys-and-otp-really-strong-two-factor-authentication/
 [3]: https://www.gotrustid.com/
 [4]: https://authentrend.com/atkey-phone/
 [5]: https://unlox.it/
 [6]: https://support.apple.com/pl-pl/HT208678
 [7]: https://www.dongleauth.info/