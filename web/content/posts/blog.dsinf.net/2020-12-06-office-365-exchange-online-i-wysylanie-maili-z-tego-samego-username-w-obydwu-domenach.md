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

![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042-300x190.png)</figure> 

Odkąd Microsoft stworzył PowerShella, część zadań administracyjnych da się wykonać tylko z PowerShella - także w hostowanym przez Microsoft Exchange Online. Wyłączenie domyślnej polityki może brzmieć groźnie, ale jeśli tyczy się to administratorów Office 365 (najczęściej nas samych) to raczej wiedzą co robią 😉

Problem polega na tym, że Knowledge Base Microsoftu zaleca w opisanej powyżej sytuacji użycie cmldetu `Set-Mailbox` z przełącznikiem `-EmailAddressPolicyEnabled:$false` (<https://docs.microsoft.com/en-us/powershell/module/exchange/set-mailbox?view=exchange-ps>). Poza koniecznością odpalenia tego na Windowsie - żaden problem - prawda?<figure class="wp-block-image size-large">

![](https://blog.dsinf.net/wp-content/uploads/2020/12/screen3.png)</figure> 

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
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_043-300x221.png)</a><figcaption class="blocks-gallery-item__caption">Najpierw należy zlokalizować formularz nowego Shared Mailbox,</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_044.png)</a><figcaption class="blocks-gallery-item__caption">potem wskazać adres skrzynki i jej nazwię wyświetlaną</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_045.png)</a><figcaption class="blocks-gallery-item__caption">i na koniec ustawić, kto będzie miał do niej uprawnienia.</figcaption></figure>
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
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_047-1.png)</a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_048-1.png)</a></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_049-1.png)</a></figure>
  </li>
</ul></figure> 

## Zakończenie implementacji od strony użytkownika {.has-medium-font-size}

Skoro mamy gotową skrzynkę współdzieloną użytkownik musi ją jeszcze podpiąć do swojej własnej. Jak to zrobić pokażę na przykładzie Outlook Web App (OWA).<figure class="is-layout-flex wp-block-gallery-33 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_051.png)</a><figcaption class="blocks-gallery-item__caption">Podpięcie skrzynki współdzielonej</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_052-300x192.png)</a><figcaption class="blocks-gallery-item__caption">Oraz dodanie na niej przekierowania na skrzynkę główną</figcaption></figure>
  </li>
</ul></figure> 

## Testowanie {.has-medium-font-size}

Aby potwierdzić, że wszystko działa, jak należy, sprawdzimy, czy możemy wysłać maile z nowego aliasu poprawnie oraz, czy możemy je odebrać. Najłatwiej wykorzystać darmowe usługi online do testowania maili - ja użyłem <a href="http://10minutemail.com" data-type="URL" data-id="10minutemail.com">10minutemail.com</a> do testu poczty wychodzącej oraz [ismyemailworking.com][3] do testu maili przychodzących.<figure class="wp-block-image size-large">

![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053-300x137.png)<figcaption>Mail wpada do spamu, ale przychodzi poprawnie</figcaption></figure> <figure class="is-layout-flex wp-block-gallery-35 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_055.png)</a><figcaption class="blocks-gallery-item__caption">Żeby wysłać maila z aliasu - trzeba dodać sobie w widoku pole From</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><a href="https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056.png">![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_056.png)</a><figcaption class="blocks-gallery-item__caption">Mail wychodzi z poprawnego adresu email</figcaption></figure>
  </li>
</ul></figure> 

## Podsumowanie {.has-medium-font-size}

Exchange jest nietrywialny, a w wersji Online - tym bardziej. Na szczęście da się obejść pewne problemy i cieszyć się wysyłaniem maili z aliasów w innych domenach.

Na zakończenie - taki oto maili wpada na główną skrzynkę odbiorczą, informując, iż skrzynka współdzielona właśnie zaczęła forwardowanie wszystkich maili - na tę główną 😉<figure class="wp-block-image size-large">

![](https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054.png)</figure>

 [1]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_042.png
 [2]: https://blog.dsinf.net/wp-content/uploads/2020/12/screen3.png
 [3]: http://ismyemailworking.com/
 [4]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_053.png
 [5]: https://blog.dsinf.net/wp-content/uploads/2020/12/Selection_054.png