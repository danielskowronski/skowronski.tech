---
title: Drukarka etykiet DYMO LabelWriter (450 DUO i nie tylko) udostępniana po sieci dla macOS i Windowsa
author: Daniel Skowroński
type: post
date: 2020-12-18T23:38:52+00:00
excerpt: 'Kontynuując przygodę z moją drukarką etykiet DYMO (najpierw analizując baterię poprzednika, a potem instalując ją na Linuksie) postanowiłem udostępnić ją w sieci lokalnej - tak, żeby uniknąć przepinania kabla USB między urządzeniami. Tym razem jednak do wspieranych platform należy dodać Windowsa i macOS. W roli serwera druku - Raspberry Pi i stary, dobry CUPS.'
url: /2020/12/drukarka-etykiet-dymo-labelwriter-450-duo-i-nie-tylko-udostepniana-po-sieci-dla-macos-i-windowsa/

---
 

Kontynuując przygodę z moją drukarką etykiet DYMO (najpierw [analizując baterię poprzednika][1], a potem [instalując ją na Linuksie][2]) postanowiłem udostępnić ją w sieci lokalnej &#8211; tak, żeby uniknąć przepinania kabla USB między urządzeniami. Tym razem jednak do wspieranych platform należy dodać Windowsa i macOS. W roli serwera druku &#8211; Raspberry Pi i stary, dobry CUPS.

## Wybór protokołów udostępniania

CUPS może udostępniać lokalne drukarki za pomocą kilku protokołów &#8211; między innymi mDNS, IPP, Samby i LPD. Ze względu na specyfikę drukarki DYMO, a raczej jej oprogramowania na Windowsa i macOS konieczne jest użycie protokołu, który wspiera użycie drivera samej drukarki do obsługi specjalnych trybów; pozostawia nam to mDNS i Sambę. Dość fajne podsumowanie zapewnia jak zwykle [wiki Arch Linuxa][3].

Teoretycznie mDNS powinien działać zarówno na Windowsie (jako natywny protokół auto-discovery), jak i macOS za pomocą Bonjour. Niestety, sama drukarka DYMO po mDNS w Windowsie jest widoczna, ale DYMO radośnie ją ignoruje, natomiast macOS nie za bardzo chce widzieć drukarki udostępniane &#8222;po windowsowemu&#8221; przy użyciu serwera Samba4. Zatem nie pozostaje nic innego jak zainstalować obsługę obydwu protokołów w naszym serwerze druku.

## Instalacja serwera druku i sterowników

Najpierw należy zainstalować kilka pakietów: `cups avahi-daemon avahi-discover libnss-mdns samba`.

Kolejny krok to instalacja sterowników (plików PPD) dla DYMO. To, co znajdziemy w paczce `printer-driver-dymo` to snapshot oficjalnych plików, który niestety nie do końca działa w nowej wersji CUPSa i Samby. Na szczęście znalazła się dobra dusza w community opensource, która trochę je podrasowała &#8211; można je znaleźć na Githubie &#8211; <https://github.com/matthiasbock/dymo-cups-drivers> 

Trzeba przy nich nieco więcej zachodu niż proste `apt install...`, ale sprawa jest dość prosta:

<pre class="wp-block-code"><code>apt install autoconf
git clone https://github.com/matthiasbock/dymo-cups-drivers/
cd dymo-cups-drivers
bash build.sh
make install
cp src/lw/raster2dymolw /usr/lib/cups/filter/
cp src/lm/raster2dymolm /usr/lib/cups/filter/
systemctl restart cups</code></pre>

## Dodawanie drukarki

Kolejny krok to włączenie CUPSowi zdalnego panelu administracyjnego &#8211; tak, żebyśmy mogli dodawać drukarki spoza localhosta &#8211; `sudo cupsctl --remote-admin`. Teraz można użyć `http://RASPBERRY_PI_ADDRESS:631` w przeglądarce.

Następny etap to dodanie drukarki lub dwóch &#8211; w przypadku urządzeń DUO (osobno do etykiet o stałym rozmiarze i etykiet na ciągłej taśmie). W webowym UI, do którego autoryzujemy się login i hasłem użytkownika root będziemy chcieli osiągnąć coś takiego:<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="770" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-770x1024.png" alt="" class="wp-image-2058" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-770x1024.png 770w, https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-226x300.png 226w, https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-768x1022.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-1155x1536.png 1155w, https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups-1539x2048.png 1539w, https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups.png 1804w" sizes="(max-width: 770px) 100vw, 770px" />][4]</figure> 

## Współdzielenie drukarki

Udostępnianie po mDNS jest automatyczne w CUPSie &#8211; wystarczy pilnować zaznaczenia pola _Share This Printer_. Aby współdzielić drukarkę po Sambie trzeba&#8230; skonfigurować serwer Samby 😉 

Minimalny plik konfiguracyjny `/etc/samba/smb.conf`, który udostępni drukarki całej sieci lokalnej (grupie _WORKGROUP_) bez autoryzacji wygląda tak:

<pre class="wp-block-code"><code>&#91;global] 
  workgroup = WORKGROUP
  server string = RPi
  log file = /var/log/samba/log.%m
  max log size = 1000
  server role = standalone
  load printers = yes 
  printing = cups
  use client driver = yes

&#91;printers]
  path = /var/spool/samba
  printable = yes
  public = yes
  guest ok = yes
  read only=no
  use client driver = yes</code></pre>

Wskazany w konfigu folder `/var/spool/samba` może nie istnieć &#8211; wystarczy go stworzyć i zostawić defaultowe uprawnienia &#8211; zarówno Samba, jak i CUPS działają jako root.

Po restarcie `smdb` można konfigurować urządzenia klienckie.

## Ustawianie drukarki na Windowsie

Na Windowsie sprawa wygląda następująco: należy podłączyć się pod udział sieciowy `\\RASPBERRY_PI_ADDRESS`, wybrać drukarkę i wskazać sterownik &#8211; ważne by wcześniej mieć już zainstalowany program _DYMO Connect_. <figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="973" height="374" src="https://blog.dsinf.net/wp-content/uploads/2020/12/03.png" alt="" class="wp-image-2059" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/03.png 973w, https://blog.dsinf.net/wp-content/uploads/2020/12/03-300x115.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/03-768x295.png 768w" sizes="(max-width: 973px) 100vw, 973px" />][5]</figure> 

Po dodaniu drukarki warto potwierdzić, że wybraliśmy odpowiedni sterownik &#8211; ja miałem sporo zamieszania, przez fakt, że model 450 DUO to tak naprawdę dwa urządzenia w jednym, a dodatkowo model DUO to nie to samo.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="463" height="528" src="https://blog.dsinf.net/wp-content/uploads/2020/12/04.png" alt="" class="wp-image-2060" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/04.png 463w, https://blog.dsinf.net/wp-content/uploads/2020/12/04-263x300.png 263w" sizes="(max-width: 463px) 100vw, 463px" />][6]</figure> 

Po zakończeniu instalacji drukarki musimy koniecznie zrestartować _DYMO Connect_. Po uruchomieniu będziemy widzieć drukarkę/drukarki nazwaną zgodnie ze ścieżką udziału sieciowego &#8211; nie mamy na to wpływu.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="673" src="https://blog.dsinf.net/wp-content/uploads/2020/12/01-1024x673.png" alt="" class="wp-image-2062" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/01-1024x673.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/01-300x197.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/01-768x505.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/01.png 1123w" sizes="(max-width: 1024px) 100vw, 1024px" />][7]</figure> 

## Ustawianie drukarki na macOS

Na macOS sprawa wygląda równie prosto, jak nie prościej. W _Preferencjach systemowych_ należy wybrać _Drukarki i skanery_, a następnie kliknąć plusik w lewym dolnym rogu.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="726" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1024x726.png" alt="" class="wp-image-2063" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1024x726.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-300x213.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-768x545.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27.png 1472w" sizes="(max-width: 1024px) 100vw, 1024px" />][8]</figure> 

Odnalezione za pomocą Bonjour drukarki ujrzymy na liście &#8211; sterownik zostanie wybrany automatycznie, o ile wcześniej zainstalowaliśmy _DYMO Label_. Ciekawostka z nazwami programów od DYMO &#8211; jakiś czas temu na obu platformach program nazywał się _Label_, ale z pół roku temu windowsowa wersja została przebudowana i nazwana _Connect_, a mackintoshowa &#8211; nie. Chociaż ta druga dalej dostaje aktualizacje. `</dygresja>`<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="726" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1-1024x726.png" alt="" class="wp-image-2064" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1-1024x726.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1-300x213.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1-768x545.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1.png 1472w" sizes="(max-width: 1024px) 100vw, 1024px" />][9]</figure> 

W programie _DYMO Label_ mamy teraz dostępne drukarki i wszystko działa:<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="623" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55-1024x623.png" alt="" class="wp-image-2065" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55-1024x623.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55-300x182.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55-768x467.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55-1536x934.png 1536w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55.png 2036w" sizes="(max-width: 1024px) 100vw, 1024px" />][10]</figure> 

## Podsumowanie

Kluczem do udostępniania drukarki DYMO w sieci lokalnej na kilka platform jest odpowiedni sterownik na serwerze wydruku i wybór protokołów. Obie sprawy nie są oczywiste, gdyż sterowniki dostępne w repozytoriach Debiana i na stronie samego DYMO nie działają z nowymi wydaniami innych pakietów, a ręcznie stawiany serwer druku nie zawsze jest zgodny z oczekiwaniami różnych systemów operacyjnych.

Jako bonus ciekawostka: w macOS BigSur wydanym kilka miesięcy temu hosty Windowsowe dalej mają ikonkę antycznego monitora CRT z widocznym Blue Screenem.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="775" src="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14-1024x775.png" alt="" class="wp-image-2066" srcset="https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14-1024x775.png 1024w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14-300x227.png 300w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14-768x581.png 768w, https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14.png 1448w" sizes="(max-width: 1024px) 100vw, 1024px" />][11]</figure>

 [1]: https://blog.dsinf.net/2019/12/proba-reanimacji-akumulatora-w-dymo-labelmanager-pnp/
 [2]: https://blog.dsinf.net/2020/05/dymo-tape-labels-na-linuksie/
 [3]: https://wiki.archlinux.org/index.php/CUPS/Printer_sharing
 [4]: https://blog.dsinf.net/wp-content/uploads/2020/12/dymo_in_cups.png
 [5]: https://blog.dsinf.net/wp-content/uploads/2020/12/03.png
 [6]: https://blog.dsinf.net/wp-content/uploads/2020/12/04.png
 [7]: https://blog.dsinf.net/wp-content/uploads/2020/12/01.png
 [8]: https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27.png
 [9]: https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.16.27-1.png
 [10]: https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.18.55.png
 [11]: https://blog.dsinf.net/wp-content/uploads/2020/12/Screenshot-2020-12-18-at-21.30.14.png