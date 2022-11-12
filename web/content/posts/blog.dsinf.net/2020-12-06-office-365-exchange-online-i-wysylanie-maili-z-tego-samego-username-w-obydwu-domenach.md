---
title: Office 365 (Exchange Online) i wysyłanie maili z tego samego username w obydwu domenach
author: Daniel Skowroński
type: post
date: 2020-12-06T15:59:18+00:00
excerpt: 'Exchange Online, jak to Exchange w ogólności może być irytujący. Tego, że tak oczywista sprawa, jak posiadanie dwóch domen i chęć wysłania maili używając tego samego użytkownika, ale różnych domen może być utrudnione - to się nie spodziewałem. Przykład konkretny i wcale nie tajny - dwa maile daniel@dsinf.net i daniel@skowron.ski hostowane na Office 365.'
url: /2020/12/office-365-exchange-online-i-wysylanie-maili-z-tego-samego-username-w-obydwu-domenach/

---
Exchange Online, jak to Exchange w ogólności może być irytujący. Tego, że tak oczywista sprawa, jak posiadanie dwóch domen i chęć wysłania maili używając tego samego użytkownika, ale różnych domen może być utrudnione - to się nie spodziewałem. Przykład konkretny i wcale nie tajny - dwa maile daniel@dsinf.net i daniel@skowron.ski hostowane na Office 365.

Office 365 dość dobrze obsługuje kilka domen podpiętych do jednej organizacji - domyślnie ustawia każdemu użytkownikowi alias w każdej dostępnej domenie (na przykład jan.kowalski@example.org i jan.kowalski@example.com) i pozwala administratorom na ręczne ustawienie dowolnego aliasu w obrębie wszystkich domen (na przykład dodatkowo jan@example.org, ale już kowalski@example.com). 

## Rozwiązanie pierwsze - `EmailAddressPolicyEnabled` {.has-medium-font-size}

Teoretycznie, jeśli użytkownik Exchange'a posiada kilka aliasów, na które poczta przychodząca trafia do jego skrzynki, to powinien też móc wysyłać z nich maile. Nic bardziej mylnego. Stoi za tym domyślna polityka EmailAddressPolicy. 

W webowym centrum administracyjnym powinna być gdzieś tutaj, ale nie zawsze będzie widoczna.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="649" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-1024x649.png" alt="" class="wp-image-2023" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-1024x649.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-300x190.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-768x487.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-1536x974.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-2048x1299.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]</figure> 

Odkąd Microsoft stworzył PowerShella, część zadań administracyjnych da się wykonać tylko z PowerShella - także w hostowanym przez Microsoft Exchange Online. Wyłączenie domyślnej polityki może brzmieć groźnie, ale jeśli tyczy się to administratorów Office 365 (najczęściej nas samych) to raczej wiedzą co robią 😉

Problem polega na tym, że Knowledge Base Microsoftu zaleca w opisanej powyżej sytuacji użycie cmldetu `Set-Mailbox` z przełącznikiem `-EmailAddressPolicyEnabled:$false` (<https://docs.microsoft.com/en-us/powershell/module/exchange/set-mailbox?view=exchange-ps>). Poza koniecznością odpalenia tego na Windowsie - żaden problem - prawda?<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="714" src="https://blog.dsinf.net/wp-content/uploads/2020/12/screen3-1024x714.png" alt="" class="wp-image-2021" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/screen3-1024x714.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/screen3-300x209.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/screen3-768x536.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/screen3-1536x1071.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/screen3.png 1708w" sizes="(max-width: 1024px) 100vw, 1024px" />][2]</figure> 

Odpowiedź na powyższy błąd znajdziemy w pierwszym akapicie dokumentacji tego cmldetu:

<blockquote class="wp-block-quote">
  <p>
    This cmdlet is available in on-premises Exchange and in the cloud-based service. Some parameters and settings may be exclusive to one environment or the other.
  </p>
  
  <cite>https://docs.microsoft.com/en-us/powershell/module/exchange/set-mailbox?view=exchange-ps</cite>
</blockquote>

## Istota problemu {.has-medium-font-size}

Krótkie uzupełnienie co takiego robi domyślna polityka adresów e-mail: kiedy wysyłamy maila, sprawdza, czy mamy uprawnienia do wysyłania z adresu podanego w polu _From_. Jeśli nie mamy - podmieni adres _From_ na nasz bazowy adres. Niestety polityka ta sprawdza tylko _identity_, czyli odpowiednik _userPrincipalName_, nie zaś aliasy. Także posiadając alias - nie mamy uprawnień do wysyłania z niego maili. 

<blockquote class="wp-block-quote">
  <p>
    To assign a different SMTP address as the primary SMTP address for a recipient, you must disable the option to automatically update an email address based on the email address policy applied to the recipient.
  </p>
  
  <cite>https://docs.microsoft.com/en-us/previous-versions/exchange-server/exchange-150/jj156614(v=exchg.150)?redirectedfrom=MSDN</cite>
</blockquote>

## Rozwiązanie drugie - _Shared Mailbox_ {.has-medium-font-size}

Inne źródła od razu wskazywały konieczność założenia skrzynki współdzielonej (_Shared Mailbox_) o takim adresie, jak alias, z którego chcemy wysyłać maile. Następnie należałoby ustawić sobie uprawnienia do tej skrzynki współdzielonej i przekierowanie maili na nią wpadających na podstawowe konto. 

Zatem do dzieła:<figure class="is-layout-flex wp-block-gallery-29 wp-block-gallery columns-3 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043.png"><img decoding="async" loading="lazy" width="1024" height="754" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-1024x754.png" alt="" data-id="2024" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043.png" data-link="https://blog.dsinf.net/?attachment_id=2024" class="wp-image-2024" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-1024x754.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-300x221.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-768x565.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-1536x1130.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-2048x1507.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" /></a><figcaption class="blocks-gallery-item__caption">Najpierw należy zlokalizować formularz nowego Shared Mailbox,</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044.png"><img decoding="async" loading="lazy" width="769" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044-769x1024.png" alt="" data-id="2025" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044.png" data-link="https://blog.dsinf.net/?attachment_id=2025" class="wp-image-2025" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044-769x1024.png 769w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044-225x300.png 225w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044-768x1023.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044.png 1084w" sizes="(max-width: 769px) 100vw, 769px" /></a><figcaption class="blocks-gallery-item__caption">potem wskazać adres skrzynki i jej nazwię wyświetlaną</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045.png"><img decoding="async" loading="lazy" width="768" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045-768x1024.png" alt="" data-id="2026" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045.png" data-link="https://blog.dsinf.net/?attachment_id=2026" class="wp-image-2026" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045-768x1024.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045-225x300.png 225w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045.png 846w" sizes="(max-width: 768px) 100vw, 768px" /></a><figcaption class="blocks-gallery-item__caption">i na koniec ustawić, kto będzie miał do niej uprawnienia.</figcaption></figure>
  </li>
</ul></figure> 

## Problem drugi - automatyczne aliasy {.has-medium-font-size}

To jednak moment, kiedy w naszym przypadku dostaniemy taki oto przemiły błąd:

<blockquote class="wp-block-quote">
  <p>
    The proxy address "SMTP:daniel@skowron.ski" is already being used by the proxy addresses or LegacyExchangeDN. Please choose another proxy address.
  </p>
</blockquote>

Czy to oznacza, że trzeba jedynie usunąć sobie _proxy address_, czyli alias z konta Exchange i po kłopocie? Otóż nie. 

Problem polega na tym, że kiedy posiadamy kilka domen to Exchange z automatu doda nam alias w każdej domenie - nawet dla skrzynek współdzielonych. Czyli ta świeżo tworzona skrzynka poza adresem daniel@dsinf.net dostanie alias... daniel@skowron.ski

Obejście na szczęście jest dość proste - należy stworzyć _Shared Mailbox_ z adresem o innej nazwie (tutaj: _not_daniel_), a następnie podmienić jej alias w domenie dsinf.net na właściwy daniel@dsinf.net, drugi zaś (not_daniel@skowron.ski) można usunąć.<figure class="is-layout-flex wp-block-gallery-31 wp-block-gallery columns-3 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1.png"><img decoding="async" loading="lazy" width="766" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1-766x1024.png" alt="" data-id="2033" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1.png" data-link="https://blog.dsinf.net/?attachment_id=2033" class="wp-image-2033" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1-766x1024.png 766w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1-224x300.png 224w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1-768x1026.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1.png 844w" sizes="(max-width: 766px) 100vw, 766px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1.png"><img decoding="async" loading="lazy" width="1024" height="986" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1-1024x986.png" alt="" data-id="2034" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1.png" data-link="https://blog.dsinf.net/?attachment_id=2034" class="wp-image-2034" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1-1024x986.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1-300x289.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1-768x740.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1.png 1404w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1.png"><img decoding="async" loading="lazy" width="1024" height="777" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1-1024x777.png" alt="" data-id="2035" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1.png" data-link="https://blog.dsinf.net/?attachment_id=2035" class="wp-image-2035" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1-1024x777.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1-300x228.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1-768x583.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1.png 1189w" sizes="(max-width: 1024px) 100vw, 1024px" /></a></figure>
  </li>
</ul></figure> 

## Zakończenie implementacji od strony użytkownika {.has-medium-font-size}

Skoro mamy gotową skrzynkę współdzieloną użytkownik musi ją jeszcze podpiąć do swojej własnej. Jak to zrobić pokażę na przykładzie Outlook Web App (OWA).<figure class="is-layout-flex wp-block-gallery-33 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png"><img decoding="async" loading="lazy" width="776" height="460" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png" alt="" data-id="2037" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png" data-link="https://blog.dsinf.net/?attachment_id=2037" class="wp-image-2037" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png 776w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051-300x178.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051-768x455.png 768w" sizes="(max-width: 776px) 100vw, 776px" /></a><figcaption class="blocks-gallery-item__caption">Podpięcie skrzynki współdzielonej</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052.png"><img decoding="async" loading="lazy" width="1024" height="655" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-1024x655.png" alt="" data-id="2038" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052.png" data-link="https://blog.dsinf.net/?attachment_id=2038" class="wp-image-2038" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-1024x655.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-300x192.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-768x491.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-1536x982.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-2048x1310.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" /></a><figcaption class="blocks-gallery-item__caption">Oraz dodanie na niej przekierowania na skrzynkę główną</figcaption></figure>
  </li>
</ul></figure> 

## Testowanie {.has-medium-font-size}

Aby potwierdzić, że wszystko działa, jak należy, sprawdzimy, czy możemy wysłać maile z nowego aliasu poprawnie oraz, czy możemy je odebrać. Najłatwiej wykorzystać darmowe usługi online do testowania maili - ja użyłem <a href="http://10minutemail.com" data-type="URL" data-id="10minutemail.com">10minutemail.com</a> do testu poczty wychodzącej oraz [ismyemailworking.com][3] do testu maili przychodzących.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="467" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-1024x467.png" alt="" class="wp-image-2040" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-1024x467.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-300x137.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-768x350.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-1536x700.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-2048x933.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][4]<figcaption>Mail wpada do spamu, ale przychodzi poprawnie</figcaption></figure> <figure class="is-layout-flex wp-block-gallery-35 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055.png"><img decoding="async" loading="lazy" width="1005" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055-1005x1024.png" alt="" data-id="2041" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055.png" data-link="https://blog.dsinf.net/?attachment_id=2041" class="wp-image-2041" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055-1005x1024.png 1005w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055-294x300.png 294w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055-768x783.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055.png 1209w" sizes="(max-width: 1005px) 100vw, 1005px" /></a><figcaption class="blocks-gallery-item__caption">Żeby wysłać maila z aliasu - trzeba dodać sobie w widoku pole From</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056.png"><img decoding="async" loading="lazy" width="1024" height="836" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056-1024x836.png" alt="" data-id="2042" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056.png" data-link="https://blog.dsinf.net/?attachment_id=2042" class="wp-image-2042" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056-1024x836.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056-300x245.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056-768x627.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056.png 1391w" sizes="(max-width: 1024px) 100vw, 1024px" /></a><figcaption class="blocks-gallery-item__caption">Mail wychodzi z poprawnego adresu email</figcaption></figure>
  </li>
</ul></figure> 

## Podsumowanie {.has-medium-font-size}

Exchange jest nietrywialny, a w wersji Online - tym bardziej. Na szczęście da się obejść pewne problemy i cieszyć się wysyłaniem maili z aliasów w innych domenach.

Na zakończenie - taki oto maili wpada na główną skrzynkę odbiorczą, informując, iż skrzynka współdzielona właśnie zaczęła forwardowanie wszystkich maili - na tę główną 😉<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="747" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054-747x1024.png" alt="" class="wp-image-2044" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054-747x1024.png 747w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054-219x300.png 219w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054-768x1053.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054-1120x1536.png 1120w, https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054.png 1267w" sizes="(max-width: 747px) 100vw, 747px" />][5]</figure>

 [1]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042.png
 [2]: https://blog.dsinf.net/wp-content/uploads/2020/12/screen3.png
 [3]: http://ismyemailworking.com/
 [4]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053.png
 [5]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054.png