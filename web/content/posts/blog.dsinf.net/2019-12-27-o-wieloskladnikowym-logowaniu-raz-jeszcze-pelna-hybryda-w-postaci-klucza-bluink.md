---
title: O wieloskładnikowym logowaniu raz jeszcze. Pełna hybryda w postaci klucza Bluink
author: Daniel Skowroński
type: post
date: 2019-12-27T15:09:39+00:00
excerpt: 'Podejść do U2F jest wiele i jak pokazuje Krypton - mogą być one ciekawsze od noszenia wielu Yubikeyów. Dziś krótka prezentacja klucza sprzętowego Bluink Key będącego w zasadzie najpełniejszą hybrydą sprzętowego klucza z aplikacją w zaufanym urządzeniu mobilnym.'
url: /2019/12/o-wieloskladnikowym-logowaniu-raz-jeszcze-pelna-hybryda-w-postaci-klucza-bluink/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/12/bluink_logo.png
tags:
  - mfa
  - security
  - u2f
  - zabezpieczenia

---
Podejść do U2F jest wiele i [jak pokazuje Krypton][1] &#8211; mogą być one ciekawsze od noszenia wielu Yubikeyów. Dziś krótka prezentacja klucza sprzętowego Bluink Key będącego w zasadzie najpełniejszą hybrydą sprzętowego klucza z aplikacją w zaufanym urządzeniu mobilnym.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-1024x768.jpg" alt="" class="wp-image-1661" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-768x576.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-1536x1152.jpg 1536w, https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-2048x1536.jpg 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][2]<figcaption>Dwie instancje bohatera artykułu. Jeden z nich na skipassie z kartą dostępu.</figcaption></figure> 

Rozwiązanie Bluink Key (<https://bluink.ca/key>) składa się z dwóch składników: aplikacji w smartfonie (iOS/Android) i dongla USB (korzystającego z Bluetooch 4.0) kosztującego $30 i dostarczanego przez kandayjską firmę Bluink Inc.

Sam dongle jest _injectorem_ i pełni dwie funkcje: zwykłego klucza zabezpieczeń U2F oraz wirtualnej klawiatury i myszki co pozwala na wpisywanie tekstowych haseł. Ponieważ urządzenie nie wymaga sterowników działa z każdym systemem, w dowolnym etapie jego działania &#8211; także podczas podawania hasła do LUKSa czy Bitlockera. 

Trochę przypomina to znane od jakiegoś czasu [&#8222;wpisywacze&#8221; exploitów][3] (dongle wyglądające jak pendrive, a wpisujące kod powershella ściągający exploita), więc trzeba pilnować kontroli nad kluczem. Ale Bluink to przewidział i tylko pierwszy smartfon połączy się z kluczem ot tak, kolejne muszą zdobyć wcześniej klucz autoryzacji (gdybyśmy chcieli mieć współdzielony klucz) lub się wyrejestrować z używania klucza.

Zdecydowanie **ogromny jest zysk z minimalizacji ekspozycji sekretu na ekranie** (TOTP czy hasła) &#8211; zarówno komputera jak i smartfona. O [atakach na podsłuchiwanie klawiatury po dźwięku jaki wydają konkretne klawisze,][4] czy **o prostym zaglądaniu przez ramię na klawiaturę nie wspominając**. <figure class="is-layout-flex wp-block-gallery-9 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="576" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2019/12/4-1-576x1024.jpg" alt="" data-id="1670" data-full-url="https://blog.dsinf.net/wp-content/uploads/2019/12/4-1.jpg" data-link="https://blog.dsinf.net/?attachment_id=1670" class="wp-image-1670" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/4-1-576x1024.jpg 576w, https://blog.dsinf.net/wp-content/uploads/2019/12/4-1-169x300.jpg 169w, https://blog.dsinf.net/wp-content/uploads/2019/12/4-1.jpg 750w" sizes="(max-width: 576px) 100vw, 576px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="576" height="1024" src="http://blog.dsinf.net/wp-content/uploads/2019/12/2-576x1024.jpg" alt="" data-id="1658" data-link="http://blog.dsinf.net/?attachment_id=1658" class="wp-image-1658" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/2-576x1024.jpg 576w, https://blog.dsinf.net/wp-content/uploads/2019/12/2-169x300.jpg 169w, https://blog.dsinf.net/wp-content/uploads/2019/12/2.jpg 750w" sizes="(max-width: 576px) 100vw, 576px" /></figure>
  </li>
</ul><figcaption class="blocks-gallery-caption">Ekrany aplikacji &#8211; parowanie używanego klucza i lista sekretów tekstowych z listą kluczy.</figcaption></figure> <figure class="is-layout-flex wp-block-gallery-11 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="576" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2019/12/5-1-576x1024.jpg" alt="" data-id="1664" data-link="https://blog.dsinf.net/?attachment_id=1664" class="wp-image-1664" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/5-1-576x1024.jpg 576w, https://blog.dsinf.net/wp-content/uploads/2019/12/5-1-169x300.jpg 169w, https://blog.dsinf.net/wp-content/uploads/2019/12/5-1.jpg 750w" sizes="(max-width: 576px) 100vw, 576px" /></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="576" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2019/12/3-1-576x1024.jpg" alt="" data-id="1665" data-full-url="https://blog.dsinf.net/wp-content/uploads/2019/12/3-1.jpg" data-link="https://blog.dsinf.net/?attachment_id=1665" class="wp-image-1665" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/3-1-576x1024.jpg 576w, https://blog.dsinf.net/wp-content/uploads/2019/12/3-1-169x300.jpg 169w, https://blog.dsinf.net/wp-content/uploads/2019/12/3-1.jpg 750w" sizes="(max-width: 576px) 100vw, 576px" /></figure>
  </li>
</ul><figcaption class="blocks-gallery-caption"> Prompt U2F z listą tekstowych sekretów w tle oraz tryb zdalnego sterowania klawiatury i myszki.</figcaption></figure> 

Same sekrety zapisane są w aplikacji (na iPhonach wykorzystywany jest oczywiście moduł _Secure Enclave_ oraz FaceID/TouchID). Ponieważ smartfon ma jednak ogromną pojemność w kontekście przechowywania po kilkadziesiąt-kilkaset bajtów na sekret to możliwości przechowywania haseł deklasują tryb _static password_ dostępny w niektórych Yubikeyach &#8211; także w wygodzie ich wprowadzania. Zamiast wciskania przycisku na kluczu sprzętowym wybieramy hasło z listy w aplikacji, jeśli trzeba klikamy pomocniczo klawisz typu _Enter_ czy _Tab_ i wszystko zostaje wysłane do odbiornika. Producent przewidział też możliwość sterowania myszką 🙂 

Sekretem tekstowym nie musi być zwykłe hasło do komputera czy aplikacji &#8211; może nim też być kod TOTP. Aplikacja zapewnia tą funkcjonalność. Ergonomia sięgnięcia po aplikację żeby przepisać 6 cyfr postawiona na przeciw ergonomii sięgnięcia po inną aplikację żeby te same 6 cyfr zostało wysłanych do komputera jeszcze nie przekonała mnie do migracji samego TOTP do Bluinka &#8211; głównie przez potrzebę migracji do innej aplikacji.

Oczywiście **samo U2F po prostu działa** &#8211; zamiast klikania przycisku na kluczu sprzętowym dostajemy prompt w telefonie, który w większości przypadków zawiera także nazwę strony proszącej o dostęp.

Fakt, że sekrety przechowywane są w telefonie ułatwia skalowanie rozwiązania o większą ilość kluczy &#8211; nie trzeba parować nowych dongli z każdą aplikacją czy stroną internetową gdzie używamy U2F (a co czasem potrafi być kłopotliwe żeby o jakiejś nie zapomnieć). Dongle nie przechowują w sobie nic poza kluczem parowania z telefonem więc i zgubienie takowego nie przedstawia żadnego ryzyka &#8211; należy jedynie mieć go na oku podczas klikania w aplikacji. 

Reasumując jest to dość ciekawa alternatywa, a na pewno praktyczny dodatek do kompletu klasycznych kluczy sprzętowych o ile ufamy swojemu smartfonowi. Sam posiadam dwa dongle &#8211; jeden na stałe wpięty w domową stację roboczą i drugi, który noszę ze sobą (najczęściej razem z kartą dostępu do pracy) tak by mieć dostęp do chronionych zasobów także poza domem.

Na koniec ważna uwaga &#8211; ostatnio klucze przestały być dostępne na Amazonie i wygląda na to że Bluink przerzucił się na sprzedaż na swojej stronie (<https://bluink.ca/buy>). Jeśli jednak byłyby ponownie dostępne na Amazonie to możliwe że wysyłka do Polski będzie dostępna tak jak poprzednio tylko z kanadyjskiej wersji serwisu (dostawa zajęła 5-6 tygodni).

 [1]: https://blog.dsinf.net/2019/08/mfa-dzieki-smartfonowi-oraz-garsc-dygresji-o-bezpieczenstwie/
 [2]: https://blog.dsinf.net/wp-content/uploads/2019/12/1-1-scaled.jpg
 [3]: https://sekurak.pl/pendrive-przejmujacy-komputer-za-30-zlotych/
 [4]: https://www.schneier.com/blog/archives/2005/09/snooping_on_tex.html