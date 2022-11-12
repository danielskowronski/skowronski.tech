---
title: 'Mozilla Thunderbird: S/MIME w dodatku Owl lub Exquilla (Exchange)'
author: Daniel Skowroński
type: post
date: 2020-07-30T19:50:39+00:00
excerpt: Mozilla Thunderbird wraz z dodatkiem Owl lub Exquilla (oba od tej samej firmy) świetnie współpracuje z sererami mailowymi Microsoft Exchange (głównie używany w wypadku Office 365). Jednak z jakiegoś powodu nie można z ich pomocą skonfigurować S/MIME, czyli cyfrowego podpisywania i/lub szyfrowania maili za pomocą osobistych certyfikatów SSL. A przynajmniej nie w oczywisty sposób.
url: /2020/07/mozilla-thunderbird-s-mime-w-dodatku-owl-lub-exquilla-exchange/
featured_image: https://blog.dsinf.net/wp-content/uploads/2020/07/exchange-thunderbird-smime-colage.png

---
 

Mozilla Thunderbird wraz z dodatkiem Owl lub Exquilla (oba od tej samej firmy) świetnie współpracuje z sererami mailowymi Microsoft Exchange (głównie używany w wypadku Office 365). Jednak z jakiegoś powodu nie można z ich pomocą skonfigurować S/MIME, czyli cyfrowego podpisywania i/lub szyfrowania maili za pomocą osobistych certyfikatów SSL. A przynajmniej nie w oczywisty sposób.

Drobna dygresja na start - darmowy certyfikat S/MIME do celów prywatnych można dostać od firmy Actalis (<https://www.actalis.it/products/certificates-for-secure-electronic-mail.aspx>). Nie sponsorują mnie, po prostu są chyba jednym z ostatnich dostawców darmowych usług tego typu.

Jak już mamy nasz certyfikat w formacie PFX/P12 należy go zainstalować w Thunderbirdzie w analogiczny sposób do Firefoxa - też posiada własny cert store, dostępny przez _Menu -> Preferences -> Advanced -> Certificates -> Manage Certificates -> Import..._<figure class="wp-block-image size-large">

<img decoding="async" loading="lazy" width="1024" height="1007" src="https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_001-1024x1007.png" alt="" class="wp-image-1791" srcset="https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_001-1024x1007.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_001-300x295.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_001-768x755.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_001.png 1451w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

Następny krok to wybranie certyfikatu w ustawieniach konta mailowego - docelowo tak żeby zgadzało się identity jeśli mamy na przykład kilka adresów mailowych i odpowiadające im certyfikaty. Nie ma czegoś w rodzaju globalnego defaultowego certyfikatu.

I to właśnie miejsce gdzie zaczyna się problem - ani _Owl_ ani _Exquilla_ nie mają w ustawieniach zakładki _Security_. Po kilkugodzinnym dłubaniu dla samego dłubania odkryłem jak to uczynić.<figure class="wp-block-image size-large">

<img decoding="async" loading="lazy" width="1024" height="967" src="https://blog.dsinf.net/wp-content/uploads/2020/07/Account-Settings_002-1024x967.png" alt="" class="wp-image-1792" srcset="https://blog.dsinf.net/wp-content/uploads/2020/07/Account-Settings_002-1024x967.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/07/Account-Settings_002-300x283.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/07/Account-Settings_002-768x726.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/07/Account-Settings_002.png 1050w" sizes="(max-width: 1024px) 100vw, 1024px" /> <figcaption>Konto mailowe _daniel@skowron.ski_ dostarczane jest przez Owl i ma wyraźnie mniej zakładek</figcaption></figure> 

W trakcie tego dłubania skowertowałem 3 pluginy w starym formacie tak, żeby dały się zainstalować na nowym silniku firefoxowym. Osiągnąłem to konwertując stare formaty manifestów _install.rdf_ i _chrome.manifest_ na _manifest.json_. Jest to dość proste co opisuje [dokumentacja Thunderbirda][1]. Same pluginy w formacie _.xpi_ to tak naprawdę przemianowane archiwa ZIP. Niestety żaden z nich nie pomógł mi wybrać certyfikatu do podpisywania maili, lecz jeden z nich dał wskazówkę - tym czego szukałem była modyfikacja konfiguracji Thunderbirda - taka jak w firefoxie dostępna jest przez `about:config`_._ W kliencie mailowym dostępne są one pod ścieżką menu: _Menu -> Preferences -> Advanced -> General -> Config Editor_.<figure class="wp-block-image size-large">

<img decoding="async" loading="lazy" width="1024" height="762" src="https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003-1024x762.png" alt="" class="wp-image-1793" srcset="https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003-1024x762.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003-300x223.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003-768x572.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003-1536x1143.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/07/Thunderbird-Preferences-Mozilla-Thunderbird_003.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

Klucze konfiguracji które nas interesują są poniżej. `X` w `idX` to numeryczny ID profilu klienta poczty - wystarczy wpisywać w pole _search_ wpisywać kolejno id1, id2, id3... żeby połapać się który profil ma który ID, ale generalnie są one numerowane po kolei.

  * `mail.identity.idX.signing_cert_dbkey` - klucz, którym jest zaszyfrowana baza certyfikatów Thunderbirda (base64)
  * `mail.identity.idX.signing_cert_name` - wartość CN naszego certyfikatu czyli na 99% po prostu adres emailowy

Zasadnicza kwestia to ustalenie wartości `signing_cert_dbkey`. Najprostszym sposobem na jej zdobycie jest uwtorzenie na chwilę dodatkowego profilu poczty, który nie musi działać, lecz musi używać wbudowanych w Thunderbirda protokołów (SMTP/IMAP) tak aby ujawniło się nam menu _Security_. Tamże wystarczy wybrać certyfikat za pomocą _Select..._ i już z powrotem w konfiguracji namierzyć wartość `signing_cert_dbkey` i przekleić ją do gałęzi identity Exchanga. Jeśli któryś z kluczy nie istnieje wystarczy kliknąć prawym klawiszem myszy i wybrać _New -> String_. 

Przy okazji warto polecić plugin Enigmail, który poza supportem OpenPGP umożliwia łatwy podgląd stanu podpisu S/MIME wiadomości email.<figure class="is-layout-flex wp-block-gallery-27 wp-block-gallery columns-2 is-cropped">

<ul class="blocks-gallery-grid">
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="1010" height="649" src="https://blog.dsinf.net/wp-content/uploads/2020/07/Write-cert-test-Thunderbird_004.png" alt="" data-id="1795" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/07/Write-cert-test-Thunderbird_004.png" data-link="https://blog.dsinf.net/?attachment_id=1795" class="wp-image-1795" srcset="https://blog.dsinf.net/wp-content/uploads/2020/07/Write-cert-test-Thunderbird_004.png 1010w, https://blog.dsinf.net/wp-content/uploads/2020/07/Write-cert-test-Thunderbird_004-300x193.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/07/Write-cert-test-Thunderbird_004-768x493.png 768w" sizes="(max-width: 1010px) 100vw, 1010px" /><figcaption class="blocks-gallery-item__caption">Tworzenie...</figcaption></figure>
  </li>
  <li class="blocks-gallery-item">
    <figure><img decoding="async" loading="lazy" width="1024" height="597" src="https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005-1024x597.png" alt="" data-id="1794" data-full-url="https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005.png" data-link="https://blog.dsinf.net/?attachment_id=1794" class="wp-image-1794" srcset="https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005-1024x597.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005-300x175.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005-768x448.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/07/Selection_005.png 1061w" sizes="(max-width: 1024px) 100vw, 1024px" /><figcaption class="blocks-gallery-item__caption">i odczytywanie podpisanego maila.</figcaption></figure>
  </li>
</ul></figure>

 [1]: https://developer.thunderbird.net/add-ons/updating/tb68/overlays