---
title: VPN site-to-site oparty o strongSwan IPsec i XFRM
author: Daniel Skowroński
type: post
date: 2022-02-13T14:20:06+00:00
excerpt: "Chcąc połączyć ze sobą dwa data-center lub dwa serwery hostujące kontenery potrzebujemy łączności site-to-site. Można to osiągnąć zwykłym VPNem w rodzaju OpenVPN i ręcznym ustawianiem routingu, jednak nie jest to zbyt wydajne, ani eleganckie. Zaprezentuję jak zestawić takie połączenie dzięki strongSwan sterującym zaimplementowanym w jądrze stosem IPsec - XFRM. Dodatkowo pokażę jak się do takiej sieci podłączyć z zewnątrz i podam kilka wskazówek dotyczących zestawienia tego u Hetznera - łącząc dedykowany serwer używający vSwitch'a z serwerem w Hetzner Cloud. Na koniec kilka słów o podłączaniu się do takiego VPNa z zewnątrz."
url: /2022/02/vpn-site-to-site-oparty-o-strongswan-ipsec-i-xfrm/
featured_image: https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan_square_large.png
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1
tags:
  - ipsec
  - lxc
  - vpn

---
Chcąc połączyć ze sobą dwa data-center lub dwa serwery hostujące kontenery potrzebujemy łączności site-to-site. Można to osiągnąć zwykłym VPNem w rodzaju OpenVPN i ręcznym ustawianiem routingu, jednak nie jest to zbyt wydajne, ani eleganckie. Zaprezentuję jak zestawić takie połączenie dzięki strongSwan sterującym zaimplementowanym w jądrze stosem IPsec &#8211; XFRM. Dodatkowo pokażę jak się do takiej sieci podłączyć z zewnątrz i podam kilka wskazówek dotyczących zestawienia tego u Hetznera &#8211; łącząc dedykowany serwer używający vSwitch&#8217;a z serwerem w Hetzner Cloud. Na koniec kilka słów o podłączaniu się do takiego VPNa z zewnątrz.

## Topologia i wymagania wstępne {#topologia-i-wymagania-wstepne}

Zacznijmy od wyjaśnienia, czym zajmują się poszczególne komponenty:

  * strongSwan to narzędzie do zestawiania tuneli VPN wykorzystujące protokół IPsec; zarządzane przez plik [ipsec.conf][1] oraz usługę `ipsec.service`
  * XFRM to implementacja IPsec w linuksowym jądrze; wykorzystuje routing za pomocą VRF, czyli bez zarządzanych za pomocą ifconfig interfejsów tun/tap znanych głównie z OpenVPN; zarządzane przez komendę [ip xfrm][2]
  * VRF (Virtual Routing and Forwarding) &#8211; technologia zaimplementowana w kernelu pozwalająca na istnienie dodatkowych tablic routingu, przypomina VLANy dla protokołu IP; zarządzana przez użytkownika za pomocą komendy [ip vrf][3]
  * IKE (Internet Key Exchange) to protokół do wymiany kluczy kryptograficznych, jeden z wielu dostępnych dla strongSwan i dość szeroko przyjęty przez nielinuksowych klientów

Co będzie nam potrzebne:

  * dwie prywatne podsieci dla serwerów wewnątrz dwóch lokalizacji &#8211; na przykład `10.1.0.0/16` i `10.2.0.0./16`
  * interfejsy sieciowe głównych serwerów, za pomocą których chcemy łączyć się między nimi &#8211; mogą to być tranzytowe linki do internetu, albo dedykowane &#8211; często dostawcy usług jak Hetzner dostarczając prywatne łącza o wyższej dostępności i niższym koszcie (często darmowe) &#8211; tu będą na serwerze A interfejs `eth0` na VLANie 4444 oraz na serwerze B osobny interfejs `eth1`; połączenie to jest routowalne &#8211; w tym wypadku w sieci `172.16.0.0/24` (konfiguracja routingu po stronie Hetzner Cloud &#8211; <https://docs.hetzner.com/cloud/networks/connect-dedi-vswitch>; serwer A jest fizyczny i używa vSwitch, serwer B jest wirtualny)
  * PSK (_pre shared key_) / hasło (np. długi alfanumeryczny ciągi) dla połączenia site-to-site
  * opcjonalnie dla klientów zewnętrznych: PKI, którego proste tworzenie opiszę pod koniec artykułu

Topologia przykładowej sieci i usług wygląda następująco:<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="889" src="https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-1024x889.png" alt="" class="wp-image-2367" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-1024x889.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-300x260.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-768x666.png 768w, https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-1536x1333.png 1536w, https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1-2048x1777.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][4]</figure> 

## Instalacja pakietów {#instalacja-pakietow}

Wstępnym założeniem jest używanie Ubuntu Server z pakietem `netplan` do zarządzania połączeniami sieciowymi. Oczywiście każdy inny Linuks też zadziała z odpowiednimi modyfikacjami dla sterowania siecią.

Do samego VPNa będą nam potrzebne dodatkowo `strongswan libcharon-extra-plugins libstrongswan-extra-plugins iptables`. 

## Konfiguracja dodatkowych interfejsów (Hetzner vSwitch) {#konfiguracja-dodatkowych-interfejsow-hetzner-vswitch}

Jeśli połączenie VPN będziemy realizować po sieci prywatnej takiej jak Hetzner vSwitch, na początek musimy skonfigurować odpowiednie interfejsy. Na maszynach wirtualnych Hetzner Cloud najlepiej skorzystać z gotowego narzędzia `hc-utils` (<https://docs.hetzner.com/cloud/networks/server-configuration/>). Na maszynach dedykowanych interfejs można ustawić za pomocą `netplan`. Przykładowy plik konfiguracyjny `/etc/netplan/01-netcfg.yaml` może wyglądać tak:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">---
network:
  version: 2
  renderer: networkd
  ethernets:
    enp9s0:
      addresses:
        - 1.1.1.1/32
        - 1.1.1.2/32
      routes:
        - on-link: true
          to: 0.0.0.0/0
          via: 1.1.1.255
      nameservers:
        addresses:
          - 213.133.100.100
          - 213.133.98.98
          - 213.133.99.99
  vlans:
    vlan.4444:
      mtu: 1450
      id: 4444
      link: enp9s0
      addresses: [172.16.0.18/28]
      routes:
        - on-link: true
          to: 172.16.0.0/24
          via: 172.16.0.17</pre>

Sekcja `ethernets` w powyższym prawdopodobnie będzie już skonfigurowana przez instalatora. Po zmianie pliku zmiany można zaaplikować przez użycie `netplan apply` lub `netplan try`.

## Pułapka z MTU {#pulapka-z-mtu}

To, co okazało się dla mnie istotne podczas używania połączenia to odpowiednie MTU. Linuks powinien sam dobrać odpowiednie, ale w moim wypadku ustawił wartość maksymalnego rozmiaru jednostki transportu na taką samą jak fizyczny interfejs, czyli 1500 bajtów. Ze względu na specyfikę Hetznerowego vSwitcha, wartość ta powinna być mniejsza, na przykład 1450 bajtów. Problem odkryłem, kiedy łączność z serwera dedykowanego do maszyny wirtualnej nawiązywana przez VLAN vSwitcha niby działała, ale połączenia SSH zawieszały się całkowicie na komunikacie `expecting SSH2_MSG_KEX_ECDH_REPLY` (widocznym przy trybie debugowania `ssh -vvvv`).

## Konfiguracja strongSwan &#8211; site-to-site {#konfiguracja-strongswan-site-to-site}

Składnia pliku `/etc/ipsec.conf` jest dość prosta &#8211; sekcja `setup` określa globalne ustawienia, takie jak poziom szczegółowości logów, a sekcje `conn ...` określają konkretne połączenia. W sekcjach połączeń strona lewa to strona &#8222;nasza&#8221;, a prawa to zdalna. Parametr `left` określa IP, na którym zostanie zestawione połączenie IPsec, a `leftsubnet` to podsieć, którą będziemy routować (podobnie dla `right`). Przykładowe pliki konfiguracyjne poniżej.

Na serwerze A:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">config setup
  charondebug="ike 1, knl 1, cfg 1"
  uniqueids=no

conn a-to-b
  authby=secret
  type=tunnel
  auto=route

  left=172.16.0.18
  leftsubnet=10.0.0.1/16

  right=172.16.0.2
  rightsubnet=10.1.0.1/16

  ike=aes256-sha2_256-modp1024!
  keyexchange=ikev2
  esp=aes256-sha2_256!
  reauth=no</pre>

Na serwerze B:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">config setup
  charondebug="ike 1, knl 1, cfg 1"
  uniqueids=no

conn b-to-a
  forceencaps=yes # required because of Hetnzer Cloud weird setup of NATed DMZ

  authby=secret
  type=tunnel
  auto=route

  left=172.16.0.2
  leftsubnet=10.1.0.1/16

  right=172.16.0.18
  rightsubnet=10.0.0.1/16

  ike=aes256-sha2_256-modp1024!
  keyexchange=ikev2
  esp=aes256-sha2_256!
  reauth=no</pre>

Dodatkowo należy skonfigurować PSK w pliku `/etc/ipsec.secrets` (w obie strony PSK jest taki sam):

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">172.16.0.2  172.16.0.18 super-secret-psk
172.16.0.18 172.16.0.2  super-secret-psk</pre>

Konfiguracja zawiera aż trzy pułapki. 

## Pułapka pierwsza &#8211; NAT {#pulapka-pierwsza-nat}

Pierwsza dotyczy środowiska Hetzner Cloud, a więc maszyny wirtualnej &#8211; choć oczywiście problem występuje także w innych konfiguracjach. Czasami strongSwan nie jest w stanie wykryć, że znajduje się za NATem. W takiej sytuacji należy dodać `forceencaps=yes` do sekcji połączenia &#8211; ale tylko na tym serwerze, gdzie mamy do czynienia z NATem.

## Pułapka druga &#8211; renegocjacja klucza {#pulapka-druga-renegocjacja-klucza}

Jeśli połączenie ma być stabilne, a za dodatkową warstwę bezpieczeństwa odpowiada prywatny link, najlepiej będzie zrezygnować z okresowego renegocjowania kluczy szyfrujących połączenie. W przeciwnym wypadku pojawiać się będzie dziwny packet loss. Aby to ustawić, należy dodać `reauth=no` i usunąć sekcję `ikelifetime=1h`. 

Namierzenie tego problemu zajęło mi dość dużo czasu, a było o tyle irytujące, że Prometheus, którego używam do monitorowania serwerów, bardzo szybko zauważał brak połączenia i wywoływał alerty w PagerDuty. Doprowadziło to do odświeżenia przeze mnie starego projektu _Sauron_, czyli narzędzia do monitorowania packet lossu do zadanych adresów IP i przepisania go tak, żeby mógł wysyłać wyniki do bazy danych InfluxDB. Projekt jest dostępny na GitHubie &#8211; <https://github.com/danielskowronski/sauron4/> 

Moje pierwsze podejrzenie dotyczyło stabilności łącza prywatnego, jednak okazało się błędne. W celu badania jakichś zależności postawiłem taki oto dashboard w Grafanie:<figure class="is-layout-flex wp-block-gallery-51 wp-block-gallery has-nested-images columns-default is-cropped"> <figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1728" height="848" data-id="2376"  src="https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana.png" alt="" class="wp-image-2376" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana.png 1728w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana-300x147.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana-1024x503.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana-768x377.png 768w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana-1536x754.png 1536w" sizes="(max-width: 1728px) 100vw, 1728px" />][5]</figure> <figure class="wp-block-image size-large">[<img decoding="async" loading="lazy" width="1728" height="848" data-id="2379"  src="https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana.png" alt="" class="wp-image-2379" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana.png 1728w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana-300x147.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana-1024x503.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana-768x377.png 768w, https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana-1536x754.png 1536w" sizes="(max-width: 1728px) 100vw, 1728px" />][6]</figure> <figcaption class="blocks-gallery-caption">Jak widać &#8211; nic konkretnego nie widać poza pozorami regularności</figcaption></figure> 

Dopiero analiza logów z `journalctl` skorelowanych z kilkoma punktami gdzie pokazał się packet loss jedynie na sieci routowanej przez VPN pokazał, w czym tkwi problem &#8211; `172.16.0.2 is initiating an IKE_SA` występował zawsze przed utratą połączenia. 

## Pułapka trzecia &#8211; maskarada {#pulapka-trzecia-maskarada}

Żeby kontenery na naszych serwerach mogły łączyć się z internetem (będąc w podsieciach sieci 10.0.0.0/8) potrzeba nam klasycznej maskarady w iptables. Jeślibyśmy poprzestali na skonfigurowaniu LXD tak, żeby zarządzane interfejsy (tu `lxdbr0`) miały automatycznie zarządzany NAT to łączność z internetem zadziała, jednak między podsieciami (10.1.0.0/16 i 10.2.0.0/16) połączenie się nie uda &#8211; reguły `PREROUTING` będą źle kierować ruchem. 

Aby tego uniknąć, należy zmienić ustawienie interfejsu sieciowego lxc za pomocą `lxc network edit lxdbr0` tak, by `config.ipv4.nat` miał wartość `false` oraz ręcznie ustawić maskaradę. Można to osiągnąć za pomocą takiego ustawienia iptables: 

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">MY_NET=10.1.0
REMOTE_NET=10.2.0

iptables-legacy \
  -t nat -A POSTROUTING \
  -s "${MY_NET}.0/16" ! -d 10.0.0.0/8 \
  -m comment --comment "10.0.0.0/8 lxdbr0" \
  -j MASQUERADE</pre>

Aby wykonywał się przy każdym zrestartowaniu połączenia VPN, można dodać do `/etc/ipsec.conf` do sekcji `conn x-to-y` wpisy `rightupdown=` i `leftupdown=` z podaną ścieżką do naszego skryptu.

## Startowanie i testowanie połączenia {#startowanie-i-testowanie-polaczenia}

Mając wszystkie pliki na miejscu można startować &#8211; serwis zazwyczaj nazywa się ipsec, choć może to być jedynie alias. W Ubuntu 21.10 usługa to `strongswan-starter.service`. Stan połączeń możemy sprawdzić za pomocą `ipsec status`:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">Routed Connections:
ulthar-to-rlyeh{1}:  ROUTED, TUNNEL, reqid 1
ulthar-to-rlyeh{1}:   10.1.0.0/16 === 10.2.0.0/16
Security Associations (2 up, 0 connecting):
ulthar-to-rlyeh[685]: ESTABLISHED 100 seconds ago, 172.16.0.2[172.16.0.2]...172.16.0.18[172.16.0.18]
ulthar-to-rlyeh{695}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: xxxxxxxx_i xxxxxxxx_o
ulthar-to-rlyeh{695}:   10.1.0.0/16 === 10.2.0.0/16
ulthar-to-rlyeh[684]: ESTABLISHED 35 minutes ago, 172.16.0.2[172.16.0.2]...172.16.0.18[172.16.0.18]
ulthar-to-rlyeh{696}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: xxxxxxxx_i xxxxxxxx_o
ulthar-to-rlyeh{696}:   10.1.0.0/16 === 10.2.0.0/16</pre>

Sama komenda `ipsec` pozwala na restartowanie połączeń, jednak jeśli używamy `systemctl` do startowania połączeń może pojawić się konflikt &#8211; osobiście używam `ipsec` tylko do diagnostyki, nie kontroli.

## Połączenie client-to-site {#polaczenie-client-to-site}

Do kompletu warto dodać też możliwość podłączenia się klienta do naszej sieci 10.0.0.0/8 &#8211; na przykład ze stacji roboczej. Użyjemy tego samego strongSwana, jednak z nieco innymi ustawieniami szyfrowania tak, by używać natywnych klientów dostępnych w systemach operacyjnych i nieco mocniej zabezpieczyć połączenie. Konkretniej będzie to szyfrowanie asymetryczne z wykorzystaniem prywatnego PKI oraz protokołu MS-CHAPv2

Do zarządzania PKI używam narzędzia [smallstep][7]. Można oczywiście używać ręcznie `openssl`, ale szansa przegapienia ważnych flag w certyfikacie CA, czy za długo czasu życia certyfikatu serwera przy obecnie ciągle ulepszanych standardach jest tak duża, że warto nieco pójść na łatwiznę. Przy okazji smallstep potrafi więcej niż tylko ułatwiać generowanie certyfikatów ręcznie. 

Na początek potrzebny będzie nam Root CA &#8211; możemy to załatwić jedną komendą `step ca init` opisaną na <https://smallstep.com/docs/step-cli/reference/ca/init>. Rzecz jasna klucz prywatny musimy bezpiecznie przechowywać. Karta inteligentna wydaje się dobrym rozwiązaniem. Sam certyfikat Root CA trzeba zapisać i zdeployować na wszystkie maszyny, które mają mu ufać oraz ustawić całkowite zaufanie &#8211; na Linuksach za pomocą `/usr/sbin/update-ca-certificates`, na macOS za pomocą `Keychain Access.app`. 

Następnie potrzebujemy certyfikatu dla serwera. Jeśli będziemy używać macOS lub iOS do łączenia się nie możemy używać ECDSA do tego certyfikatu (sam Root CA może być ECDSA) tylko standardowego RSA. Problem polega na tym, że niby macOS obsługuje kryptografię krzywej eliptycznej w IKEv2 (<https://support.apple.com/pl-pl/guide/deployment/depae3d361d0/web>), to nie można tego ustawić z normalnego interfejsu &#8211; jedynie przez narzędzia do generowania profili konfiguracyjnych (<https://wiki.strongswan.org/projects/strongswan/wiki/AppleIKEv2Profile> i <https://github.com/skowronski-cloud/skowronski-cloud-wiki/blob/master/rlyeh/03_vpn.md#note-on-key-type-selection>). Taki certyfikat ważny przez 5 lat możemy wygenerować w ten sposób:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">step certificate create ipsec.example.com ipsec.crt ipsec.key \
     --kty RSA --size 4096 --ca root_ca.crt --ca-key root_ca_key \
     --no-password --insecure \
     --san ipsec.example.com --san 1.1.1.1 \
     --not-after 43800h
</pre>

Flaga `--insecure` jest potrzebna, by ustawić brak hasła do klucza prywatnego. Jako SAN należy podać domenę, warto dodać też adres IP.

Certyfikat CA, serwera oraz klucz serwera wrzucamy jako pliki PEM odpowiednio do `/etc/ipsec.d/cacerts/`, `/etc/ipsec.d/certs/` oraz `/etc/ipsec.d/private/`. Certyfikat serwera podajemy potem w konfigu jako `leftcert`

Aby dodać klientów do naszego VPNa, do `/etc/ipsec.conf` dodajemy:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">conn ikev2-vpn
  auto=add
  compress=no
  type=tunnel
  keyexchange=ikev2
  fragmentation=yes
  forceencaps=yes
  dpdaction=clear
  dpddelay=300s
  rekey=no
  left=%any
  leftid=@ipsec.example.com
  leftcert=server-cert.pem
  leftsendcert=always
  leftsubnet=10.0.0.0/8
  right=%any
  rightauth=eap-mschapv2
  rightsendcert=never

conn ikev2-vpn-client_a
  also=ikev2-vpn
  rightid=client_a
  eap_identity=client_a
  rightsourceip=10.0.255.100/32

conn ikev2-vpn-client_b
  also=ikev2-vpn
  rightid=client_b
  eap_identity=client_b
  rightsourceip=10.0.255.200/32</pre>

Poprawność instalacji kluczy możemy zweryfikować przy użyciu `ipsec listcerts` i `ipsec listcacerts`.

Sekcja `conn ikev2-vpn` pozwala stworzyć szablon dla konkretnych połączeń doprecyzowanych w tym przykładzie jako `ikev2-vpn-client_a` i `ikev2-vpn-client_b`. `client_a` i `client_b` to loginy użytkowników, a `rightsourceip` to adresy IP, jakie otrzymają po zalogowaniu się. Parametr `leftid` jest bardzo ważny &#8211; musi to być parametr, który klienci podadzą w ustawieniach połączenia.

W pliku `/etc/ipsec.secrets` musimy wskazać na certyfikat serwera oraz zdefiniować hasła każdego z klientów (dopasowywane według pola `eap_identity`):

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">: RSA /etc/ipsec.d/private/server-key.pem
client_a : EAP plaintext-password-for-client_a
client_b : EAP plaintext-password-for-client_b</pre>

Przykładowa konfiguracja zaufania certyfikatu i klienta VPN na macOS:<figure class="is-layout-flex wp-block-gallery-53 wp-block-gallery has-nested-images columns-default is-cropped"> <figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1728" height="1478" data-id="2384"  src="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3.png" alt="" class="wp-image-2384" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3.png 1728w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3-300x257.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3-1024x876.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3-768x657.png 768w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3-1536x1314.png 1536w" sizes="(max-width: 1728px) 100vw, 1728px" />][8]</figure> <figure class="wp-block-image size-large">[<img decoding="async" loading="lazy" width="1336" height="1152" data-id="2388"  src="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1.png" alt="" class="wp-image-2388" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1.png 1336w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1-300x259.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1-1024x883.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1-768x662.png 768w" sizes="(max-width: 1336px) 100vw, 1336px" />][9]</figure> <figure class="wp-block-image size-large">[<img decoding="async" loading="lazy" width="1336" height="1152" data-id="2391"  src="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2.png" alt="" class="wp-image-2391" srcset="https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2.png 1336w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2-300x259.png 300w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2-1024x883.png 1024w, https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2-768x662.png 768w" sizes="(max-width: 1336px) 100vw, 1336px" />][10]</figure> </figure> 

## Podsumowanie {#podsumowanie}

Konfiguracja strongSwan jest w miarę prosta, lecz można wpaść na wiele pułapek sieciowych i kryptograficznych. Dodatkowo XFRM nie jest tak oczywisty, jak klasyczny routing w Linuksie i wymaga trochę nauki, lecz jest dalece wydajniejszy i bardziej elastyczny od starych rozwiązań.

 [1]: https://wiki.strongswan.org/projects/strongswan/wiki/IpsecConf
 [2]: https://www.man7.org/linux/man-pages/man8/ip-xfrm.8.html
 [3]: https://man7.org/linux/man-pages/man8/ip-vrf.8.html
 [4]: https://blog.dsinf.net/wp-content/uploads/2022/02/strongswan.drawio-1.png
 [5]: https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-16-Sauron-Rlyeh-Grafana.png
 [6]: https://blog.dsinf.net/wp-content/uploads/2022/02/Screenshot-2022-02-13-at-11-51-50-Sauron-Rlyeh-Grafana.png
 [7]: https://smallstep.com/docs/step-cli/reference/ca/certificate
 [8]: https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_3.png
 [9]: https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_1.png
 [10]: https://blog.dsinf.net/wp-content/uploads/2022/02/macos_vpn_2.png