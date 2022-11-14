---
title: Ochrona własnego intranetu za pomocą rozwiązania Authelia i historia odejścia od web serwera Caddy
author: Daniel Skowroński
type: post
date: 2020-08-22T19:10:12+00:00
excerpt: 'Jak większość osób mających małą sieć hostującą laba z eksperymentami i kilka prywatnych rozwiązań, które nie powinny być otwarte dla całego świata z szerokiego wachlarza powodów (od bezpieczeństwa infrastruktury po ratelimiting kluczy API zewnętrznych aplikacji) jednym z wyzwań, przed jakimi stoję, jest zabezpieczenie czegoś, co można by nazwać intranetem. Niekoniecznie VPNem, bo nie zewsząd da się do takowego podłączyć, a zwykle i tak chodzi o zestaw webaplikacji - nierzadko napisanych na kolanie bez cienia autoryzacji.'
url: /2020/08/ochrona-wlasnego-intranetu-za-pomoca-rozwiazania-authelia-i-historia-odejscia-od-webserwera-caddy/
featured_image: /wp-content/uploads/2020/08/authelia_square.png
tags:
  - caddy
  - https
  - nginx
  - proxy
  - security

---
Jak większość osób mających małą sieć hostującą laba z eksperymentami i kilka prywatnych rozwiązań, które nie powinny być otwarte dla całego świata z szerokiego wachlarza powodów (od bezpieczeństwa infrastruktury po ratelimiting kluczy API zewnętrznych aplikacji) jednym z wyzwań, przed jakimi stoję, jest zabezpieczenie czegoś, co można by nazwać intranetem. Niekoniecznie VPNem, bo nie zewsząd da się do takowego podłączyć, a zwykle i tak chodzi o zestaw webaplikacji - nierzadko napisanych na kolanie bez cienia autoryzacji.

#### Pierwsze podejście z Caddy'm i ucieczka od niego

Moje pierwsze podejście do tego tematu zaczęło się ze zgłębianiem dostępnych plug-inów do web serwera Caddy - wówczas w wersji pierwszej. Natknąłem się na sprytny plugin _http.login_, który za pomocą innego pluginu - _jwt_ umożliwiał integrację z dostawcami tożsamości takimi jak Google, czy GitHub. Wystarczyło utworzyć w panelu własną aplikację OAuth, przekopiować tokeny do konfiguracji plug-inu i wylistować użytkowników mogących się zalogować do zasobów intranetu. Jak to rozwiązanie wygląda w praktyce, można zobaczyć na innym blogu - [https://etherarp.net/github-login-on-caddy/index.html](https://etherarp.net/github-login-on-caddy/index.html)

_Umożliwiał_, bowiem twórcy Caddy'ego postanowili wydać wersję drugą, całkowicie niszcząc system plug-inów. Stara dokumentacja nie jest dostępna - [na Web Archive można zobaczyć][1] jak prosto wyglądała konfiguracja - całkowicie zgodna z duchem tego ekosystemu. Wiele miesięcy od otworzenia [issue dotyczącego przyszłości plug-inów autoryzacyjnych][2] twórcy dalej nie mają planów na oddanie użytkownikom dość istotnej funkcjonalności.

Dodatkowo od jakiegoś czasu dostawałem maile od Githuba, zatytułowanych _`[GitHubAPI] Deprecation notice for authentication via URL query parameters`_, a prowadzących do [https://developer.github.com/changes/2020-02-10-deprecating-auth-through-query-param/](https://developer.github.com/changes/2020-02-10-deprecating-auth-through-query-param/). Przy okazji planowanej jeszcze wówczas migracji do nowej wersji Caddy'ego (nie spodziewając się takich problemów z kompatybilnością) miałem zamiar poprawić ów plugin, żeby GitHub nie narzekał, a sam kod nie przestał działać.

Dlatego też postanowiłem poszukać alternatyw, nawet jeśli miały uwzględniać używanie Nginxa, którego porzuciłem w mojej domowej sieci z wielu względów - między innymi przewagi Caddy'ego na polu współpracy z Let's Encryptem i pogmatwanych konfigów w małych i niezbyt wymagających projektach.

#### Drugie podejście - Authelia + nginx

Szukając alternatyw uznałem, że priorytetem będzie dwuskładnikowe uwierzytelnianie, najlepiej w formie powiadomień push - tak żeby działało to wygodnie na telefonie - cały czas, nie tylko w momencie posiadania pod ręką Yubikeya NFC. Authelia poza klasycznymi TOTP supportuje też Duo, które jest darmowe dla 10 użytkowników w organizacji.

Jednym z pierwszych wyników, a na pewno najbardziej obiecującym rozwiązaniem okazała się Authelia - middleware autoryzacji dla nginxa, traefika i haproxy. 

Twórcy dostarczają gotowe setupy dla dockera i integrację z ingress proxy kubernetesa, lecz mój lab oparty na trwałych kontenerach LXC wymagał setupu jak dla baremerala - co okazało się nieco trudniejsze w mmomencie kiedy chciałem za pierwszym razem wyprodukować coś, co przejmie ruch z istniejącego rozwiązania, ale czego się nie robi siedząc do 3 rano 😉

#### Instalacja i wymagania wstępne

Na serwer obsługujący ruch HTTP wybrałem znanego sobie nginxa. W tym setupie terminuje także TLSa z certyfikatem z [prywatnego CA obsługiwanego przez smallstepa][3], o którym powinienem kiedyś więcej napisać.

Do kompletu potrzeba będzie także Redisa do przechowywania tokenów sesyjnych - przydaje się to bardziej przy skalowani Authelii, ale pomaga także rozdzielić storage od samego proxy.

Sama instalacja jest dość prosta - nie ma jeszcze co prawda paczek, ale poniższy playbook ansibla rozwiązuje sprawę. Zmienna `authelia_ver` ma wartość taga z githuba (na przykład v4.21.0) - [https://github.com/authelia/authelia/releases](https://github.com/authelia/authelia/releases)

```yaml
- name: install software
  apt:
    name:
      - nginx
      - redis

- name: protect redis
  lineinfile:
    path: /etc/redis/redis.conf
    line: requirepass {{redis_pass}}

- name: prepare authelia html dir
  file:
    path: /srv/authelia
    state: directory
    owner: www-data

- name: fetch authelia binary
  unarchive:
    src: https://github.com/authelia/authelia/releases/download/{{authelia_ver}}/authelia-linux-amd64.tar.gz
    remote_src: true
    dest: /srv/authelia

- name: deploy systemd service
  template:
    src: authelia/authelia.service.j2
    dest: /lib/systemd/system/authelia.service

- name: enable and restart systemd services
  systemd:
    name: '{{item}}'
    state: restarted
    enabled: true
  with_items:
    - redis
    - nginx
    - authelia

```


Użyty template serwisu systemd wygląda następująco:

```ini
[Unit]
Description=Authelia authentication and authorization server
After=network.target

[Service]
ExecStart=/srv/authelia/authelia-linux-amd64 --config /srv/authelia/configuration.yml
SyslogIdentifier=authelia

[Install]
WantedBy=multi-user.target
```


#### Konfigurowanie nginxa

Czas skonfigurować nginxa tak, żeby coś prostego nam proxował, a Authelia broniła dostępu. Będą nam potrzebne następujące pliki:

  * `/etc/nginx/sites-enabled/default` usunięty
  * `/etc/nginx/authelia.conf` definiujący endoint `/authelia` do obsługi autoryzacji:

```nginx
location /authelia {
    internal;
    set $upstream_authelia http://127.0.0.1:9091/api/verify;
    proxy_pass_request_body off;
    proxy_pass $upstream_authelia;
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header Content-Length "";

    # Timeout if the real server is dead
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

    # Basic Proxy Config
    client_body_buffer_size 128k;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Forwarded-Ssl on;
    proxy_redirect  http://  $scheme://;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
    proxy_cache_bypass $cookie_session;
    proxy_no_cache $cookie_session;
    proxy_buffers 4 32k;

    # Advanced Proxy Config
    send_timeout 5m;
    proxy_read_timeout 240;
    proxy_send_timeout 240;
    proxy_connect_timeout 240;
}
```


  * `/etc/nginx/auth.conf` konfigurujący użycie middleware'u autoryzacji i odpowiedni redirect do strony logowania (którego konfig opisany jest nieco dalej - tutaj jest to domena `auth.example.com`): 

```nginx
auth_request /authelia;
auth_request_set $target_url $scheme://$http_host$request_uri;
auth_request_set $user $upstream_http_remote_user;
auth_request_set $groups $upstream_http_remote_groups;
proxy_set_header Remote-User $user;
proxy_set_header Remote-Groups $groups;
error_page 401 =302 https://auth.example.com/?rd=$target_url;
```


  * `/etc/nginx/ssl.conf` opisujący gdzie szukać certyfikatów SSL - bardziej przydatne kiedy używamy certyfikatu wildcard; oczywiście potrzeba także `/etc/nginx/intranet.*` 

```nginx
listen              443 ssl;
ssl_certificate     /etc/nginx/intranet.crt;
ssl_certificate_key /etc/nginx/intranet.key;
ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers         HIGH:!aNULL:!MD5;
```


  * `/etc/nginx/sites-enabled/proxy.conf` zawierający konfigurację przezroczystego proxy - to jest coś, co w Caddym można by zapisać jako, `proxy / { transparent }`, jednak nginx jest bardziej jak Debian w tej kwestii 😉

```nginx
client_body_buffer_size 128k;

proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

send_timeout 5m;
proxy_read_timeout 360;
proxy_send_timeout 360;
proxy_connect_timeout 360;

proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Uri $request_uri;
proxy_set_header X-Forwarded-Ssl on;
proxy_redirect  http://  $scheme://;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_cache_bypass $cookie_session;
proxy_no_cache $cookie_session;
proxy_buffers 64 256k;

set_real_ip_from 10.0.0.0/8;
set_real_ip_from 172.0.0.0/8;
set_real_ip_from 192.168.0.0/16;
set_real_ip_from fc00::/7;
real_ip_header X-Forwarded-For;
real_ip_recursive on;
```


  * `/etc/nginx/sites-enabled/auth_portal.conf` definiujący domenę odpowiedzialną za panel logowania; `http://127.0.0.1:9091` to standardowy endpoint Authelii

```nginx
server {
    listen 80;
    server_name auth.example.com;

    location / {
        return 301 https://$server_name$request_uri;
    }
}

server {
    server_name auth.example.com;
    include /etc/nginx/ssl.conf;

    location / {
        add_header X-Forwarded-Host auth.example.com;
        add_header X-Forwarded-Proto $scheme;
        set $upstream_authelia http://127.0.0.1:9091;
        proxy_pass $upstream_authelia;
        include proxy.conf;
    }
}
```


  * odpowiednie `/etc/nginx/sites-enabled/domena.conf` wyglądające na przykład tak (oczywiście `http://{{ips.grafana}}:{{ports.grafana}}` to jinjowa templatka wykorzystująca ansiblowe zmienne)

```nginx
server {
        server_name grafana.example.com;
        listen 80;
        return 301 https://$server_name$request_uri;
}

server {
        server_name grafana.example.com;
        include ssl.conf;
        include authelia.conf;

        location / {
                set $upstream_target http://{{ips.grafana}}:{{ports.grafana}};
                proxy_pass $upstream_target;
                include auth.conf;
                include proxy.conf;
        }
}
```


#### Konfigurowanie authelii

Sama authelia wymaga już tylko jednego pliku konfiguracyjnego oraz bazy użytkowników - może być to plik YAML (który wykorzystamy w tym prostym przykładzie), LDAP lub klasyczna baza danych - SQLite, MySQL tudzież PostgreSQL.

Tu powinna pojawić się także konfiguracja serwera SMTP, ale twórcy Authelii przewidzieli naprawdę małe setupy i jest możliwość zapisywania wiadomości zawierających np. linki do aktywacji MFA czy resetowania hasła w pliku tekstowym na serwerze - idealne dla jednego użytkownika lub celów testowych.

Ścieżka do pliku podana jest w commandline, w tym przykładzie zdefiniowana jest w konfiguracji usługi w systemd (`/srv/authelia/configuration.yml`).

```yaml
host: 127.0.0.1
port: 9091

server:
  read_buffer_size: 4096
  write_buffer_size: 4096
  path: ""

log_level: debug
jwt_secret: {{LONG_RANDOM_STRING}}

default_redirection_url: https://example.com

duo_api:
  hostname: {{DUO_HOSTNAME}}
  integration_key: {{DUO_INTEGRATION_KEY}}
  secret_key: {{DUO_SECRET}}

authentication_backend:
  disable_reset_password: false
  refresh_interval: 5m
  file:
    path: /srv/authelia/users_database.yml
    password:
      algorithm: sha512
      iterations: 1
      key_length: 32
      salt_length: 16
      memory: 512
      parallelism: 8

access_control:
  default_policy: two_factor

  rules:
    - domain: example.com
      policy: bypass

    - domain: "*.example.com"
      policy: two_factor

session:
  name: authelia_session
  secret: insecure_session_secret
  expiration: 1h
  inactivity: 5m
  remember_me_duration: 1M
  domain: example.com
  redis:
    host: 127.0.0.1
    port: 6379
    password: {{redis_pass}}
    database_index: 0

regulation:
  max_retries: 3
  find_time: 2m
  ban_time: 5m

storage:
  local:
    path: /srv/authelia/db.sqlite3

notifier:
  disable_startup_check: false
  filesystem:
    filename: /tmp/notification.txt
```


Zmienne związane z Duo opiszę w następnej części. Poza tym podmienić należy oczywiście losowy sekret JWT, domenę, hasło do Redisa i zdefiniować odpowiednie reguły chronienia domen. Przykładowe zapewniają dostęp bez logowania do domeny głównej i chroniony MFA dla wszelkich subdomen. Więcej opcji opisanych jest w bardzo dobrej dokumentacji - <https://www.authelia.com/docs/configuration/access-control.html>

Ostatnim klockiem w układance jest plik `/srv/authelia/users_database.yml`. O tym jak wygenerować hash hasła wspomina dokumentacja - <https://www.authelia.com/docs/configuration/authentication/file.html#passwords>

Coś, co jest warte uwagi przy deploymencie na lekkich kontenerach (mój ma 128 MB RAMu i 1 vCPU) to fakt, że domyślnie używany algorytm hashujący argon2id jest wybitnie ciężki - użyłem zamiast niego sha512.

```yaml
users:
  daniel:
    displayname: "Daniel Skowroński"
    password: "{{HASHED}}"
    email: daniel@example.com
    groups:
      - admins
```


#### Konfigurowanie Duo

Na koniec konfiguracji potrzebujemy ustawionego Duo. Wystarczy konto _Duo Free_, które na stronie opisane jest jako trial, ale nim nie jest - jest darmowe ([https://duo.com/pricing/duo-free](https://duo.com/pricing/duo-free)). W procesie rejestracji potrzebujemy aplikacji Duo na telefonie, bowiem _Admin Login_ chroniony jest przez Duo 😉

Po zalogowaniu się w domenie admin.duosecurity.com należy wybrać _Protect new application_ i odnaleźć pozycję _Partner Auth API_. Powstanie nowa aplikacja, którą możemy przemianować scrollując jej stronę niżej do _Settings._ To, co na pewno trzeba zrobić to zapisać w konfiguracji Authelii wartości _integration key, secret key_ oraz _domain_. 

![](/wp-content/uploads/2020/08/1.png)
![](/wp-content/uploads/2020/08/2.png)

#### Logowanie do systemu

Po zrestartowaniu nginxa oraz Authelii czas na logowanie. 

![](/wp-content/uploads/2020/08/5.png)
![](/wp-content/uploads/2020/08/9.png)

#### Enrollowanie użytkownika do Duo

Proces enrolowania wykonujemy całkowicie po stronie panelu administracyjnego Duo. Aby dodać użytkownika należy wybrać _Users -> Add user_. Trzeba pamiętać, żeby dodać mu odpowiednie aliasy i adres e-mailowy pasujące do tych z bazy danych Authelii. Nie można wykorzystać użytkownika panelu administracyjnego Duo, ale nic nie stoi na przeszkodzie, by używać tego samego maila czy loginu.

![](/wp-content/uploads/2020/08/3.png)
![](/wp-content/uploads/2020/08/4a.png)

Kolejny krok to dodanie urządzenia autoryzującego, w naszym wypadku telefonu z aplikacją Duo do obsługi powiadomień push. Po przewinięciu strony użytkownika do dołu znajdziemy link _Add phone_

![](/wp-content/uploads/2020/08/10aa.png)

Następnie wybieramy typ urządzenia. _Phone_ jest przydatne przy enrollmencie po numerze telefonu - kod przychodzi SMSem, _Tablet_ to wybór dla urządzeń bez numeru telefonu - wiadomość przyjdzie mailem.

![](/wp-content/uploads/2020/08/11.png)

Teraz należy aktywować urządzenie poprzez wysłanie maila z linkiem i kodem.<

![](/wp-content/uploads/2020/08/12aaa.png)
![](/wp-content/uploads/2020/08/13.png)

Mail przychodzi od Duo - co jest wygodniejsze niż opisana za chwilę opcja z TOTP od Authelii. Instrukcje dla użytkownika są dość proste.

![](/wp-content/uploads/2020/08/14.png)

#### Enrollowanie użytkownika do klasycznego TOTP

Zawsze można używać klasycznego TOTP jako backupu - za pomocą dowolnej aplikacji typu Authy czy Google Authenticator. Tutaj procedura jest nieco bardziej zawiła i wymaga użycia wspomnianego pliku z powiadomieniami lub setupu SMTP. Pierwszym krokiem jest wybranie po zalogowaniu do Authelii _Methods -> One-Time Password -> Not registered yet._ Następnie należy przegrepować plik z powiadomieniami, wybrać z niego link do rejestracji, otworzyć go i zeskanować dowolną aplikacją do TOTP kod QR.


![](/wp-content/uploads/2020/08/6.png)
![](/wp-content/uploads/2020/08/7.png)
![](/wp-content/uploads/2020/08/8.png)

#### Podsumowanie

Niewielkim nakładem konfiguracji można dodać Authelię do istniejącego intranetu - wystarczy nginx wystawiony na świat by obsługiwał HTTP/HTTPS, middleware Authelii decyduje czy dana domena ma być dostępna dla wszystkich, czy nie, a jeśli potrzeba uwierzytelnia użytkowników - łącząc się z bazą danych, LDAPem lub prostym plikiem YAML, a całości dopełnia darmowe konto Duo i powiadomienia push. Ponadto w razie potrzeby całość łatwo się skaluje.

A decyzje twórców Caddiego łatwo się szkaluje - okazało się to kolejne oprogramowanie opensource (swoją drogą z dostępną wersją z supportem, ale z irytującą praktyką doklejania headerów http dla wersji free, czyli oficjalnych buildów i zakazem jej używania do celów komercyjnych - póki samodzielnie się go nie zbuduje), które kusząc bardzo atrakcyjnymi ułatwiaczami w rodzaju implementacji inicjatywy _HTTPS Everywhere_, supportowi HTTP/2 od wczesnych dni, czy banalnym plikiem konfiguracyjnym jednocześnie robione jest na szybko i bez przemyślenia - co wyszło zwłaszcza przy aktualizacji do v2, która zniszczyła system plug-inów, nie zapewniając kompatybilności wstecznej ani nawet przeniesienia API dla wielu middlewerów tak, że nie da się ich nawet portować na nową wersję. Ba, usunięto też możliwość pobrania wersji binarki z wybranymi plug-inami - ponieważ Caddy napisany jest w Go, jest skompilowany statycznie i plug-iny są częścią pliku wykonywalnego. Do tej pory można było pobrać plik z URLa w formie `?plugins=jwt,auth,...`, teraz trzeba kompilować całość samodzielnie lub wybrać wersję bez supportu dla innych plug-inów.

 [1]: https://web.archive.org/web/20190701123752/https://caddyserver.com/docs/http.login
 [2]: https://github.com/caddyserver/caddy/issues/2894
 [3]: https://smallstep.com/docs/cli/ca/certificate/
 [4]: /wp-content/uploads/2020/08/1.png
 [5]: /wp-content/uploads/2020/08/5.png
 [6]: /wp-content/uploads/2020/08/9.png
 [7]: /wp-content/uploads/2020/08/3.png
 [8]: /wp-content/uploads/2020/08/4a.png
 [9]: /wp-content/uploads/2020/08/10aa.png
 [10]: /wp-content/uploads/2020/08/11.png
 [11]: /wp-content/uploads/2020/08/12aaa.png
 [12]: /wp-content/uploads/2020/08/13.png
 [13]: /wp-content/uploads/2020/08/14.png
 [14]: /wp-content/uploads/2020/08/6.png
 [15]: /wp-content/uploads/2020/08/7.png