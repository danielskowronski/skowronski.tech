---
title: Hackowanie smart żarówek TP-Linka (LB1xx)
author: Daniel Skowroński
type: post
date: 2018-05-28T02:36:30+00:00
excerpt: 'Internet rzeczy to zwykle wdzięczy temat do reverse engineeringu - standardowy Linux 2.6.32, dziurawe antyczne mini serwery HTTP, brak zabezpieczeń... TP-Link w swojej ofercie posiada smart żarówki sterowane za pomocą aplikacja na Androida i iOS. Jakiś czas temu kupiłem dwie sztuki - LB120 (z kontrolą temperatury bieli) i LB130 (full RGB). No i wszystko fajnie, ale można by sterować światłem z poza telefonu. Niezbyt zależało mi na integracji z Apple HomeKit, ale bardziej na podpięciu jakichś akcji pod stację roboczą, czy w przyszłości pod kolejną wersję budzika. A więc czas na research.'
url: /2018/05/hackowanie-smart-zarowek-tp-linka-lb1xx/
featured_image: /wp-content/uploads/2018/05/LB130-01_1517973391940L-660x495.jpg
tags:
  - hardware
  - iot
  - lb110
  - lb120
  - lb130
  - tp-link

---
Internet rzeczy to zwykle wdzięczny temat do reverse engineeringu - standardowy Linux 2.6.32, dziurawe antyczne mini serwery HTTP, brak zabezpieczeń... TP-Link w swojej ofercie posiada smart żarówki sterowane za pomocą aplikacja na Androida i iOS. Jakiś czas temu kupiłem dwie sztuki - LB120 (z kontrolą temperatury bieli) i LB130 (full RGB). No i wszystko fajnie, ale można by sterować światłem z poza telefonu. Niezbyt zależało mi na integracji z Apple HomeKit, ale bardziej na podpięciu jakichś akcji pod stację roboczą, czy w przyszłości pod kolejną wersję budzika. A więc czas na research.

![](/wp-content/uploads/2018/05/LB130-01_1517973391940L.jpg) 

Interfejs aplikacji na iOS - Kasa:

![](/wp-content/uploads/2018/05/IMG_5269.png) ![](/wp-content/uploads/2018/05/IMG_5270.png) ![](/wp-content/uploads/2018/05/IMG_5272.png) ![](/wp-content/uploads/2018/05/IMG_5271-1.png)

Pierwszym punktem w poszukiwaniach była lektura artykułu o reverse engineeringu podobnego produktu TP-Linka w postaci sterowalnego gniazdka - <https://www.softscheck.com/en/reverse-engineering-tp-link-hs110/>, gdzie dostajemy garść informacji o całym urządzeniu - filesystemie squashfs z obrazem firmware'u, sshd z hasłem niemal plaintextowym, własnym "szyfrowany" protokole sterującym/API (port 9999), protokole diagnostycznym (port 1040). Warta uwagi jest też lista komend API (<https://github.com/softScheck/tplink-smartplug/blob/master/tplink-smarthome-commands.txt>). Jak można przypuszczać gotowe projekty kontrolujące żarówkę już są. Warte odnotowania są trzy:

  * <https://github.com/plasticrake/tplink-smarthome-api> - najbardziej uniwersalna biblioteka/program standalone, ale nie do końca działa z LB1xx
  * <https://github.com/konsumer/tplink-lightbulb> - działa najlepiej z LB1xx
  * <https://github.com/cullenbass/tplight> - biblioteka w Go

Analiza jednak wykazała że są istotne różnice pomiędzy LB1xx as HS110. Oto co wiem:

  * LB tak samo jak HS posiada API - jednak komendy nieco się różnią (klasa Bulb z <https://github.com/plasticrake/tplink-smarthome-api>)
  * brak serwera SSHD
  * inny format firmware

Brak serwera SSHD zasmucił mnie najbardziej. Portów otwartych również brak:

<pre class="lang:default EnlighterJSRAW">Starting Nmap 7.60 ( https://nmap.org ) at 2018-05-28 03:13 CEST
NSE: Loaded 146 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 03:13
Completed NSE at 03:13, 0.00s elapsed
Initiating NSE at 03:13
Completed NSE at 03:13, 0.00s elapsed
Initiating ARP Ping Scan at 03:13
Scanning 192.168.1.26 [1 port]
Completed ARP Ping Scan at 03:13, 0.22s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 03:13
Completed Parallel DNS resolution of 1 host. at 03:13, 0.00s elapsed
Initiating SYN Stealth Scan at 03:13
Scanning lb120.home (192.168.1.26) [65535 ports]
...
Completed SYN Stealth Scan at 03:32, 1139.32s elapsed (65535 total ports)
Initiating Service scan at 03:32
Scanning 1 service on lb120.home (192.168.1.26)
Completed Service scan at 03:32, 21.11s elapsed (1 service on 1 host)
Initiating OS detection (try #1) against lb120.home (192.168.1.26)
NSE: Script scanning 192.168.1.26.
Initiating NSE at 03:32
Completed NSE at 03:32, 0.03s elapsed
Initiating NSE at 03:32
Completed NSE at 03:32, 1.01s elapsed
Nmap scan report for lb120.home (192.168.1.26)
Host is up (0.0073s latency).
Not shown: 65534 filtered ports
PORT     STATE SERVICE VERSION
9999/tcp open  abyss?
MAC Address: 50:C7:BF:BF:DB:C6 (Tp-link Technologies)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: specialized|WAP|phone
Running: iPXE 1.X, Linux 2.4.X|2.6.X, Sony Ericsson embedded
OS CPE: cpe:/o:ipxe:ipxe:1.0.0%2b cpe:/o:linux:linux_kernel:2.4.20 cpe:/o:linux:linux_kernel:2.6.22 cpe:/h:sonyericsson:u8i_vivaz
OS details: iPXE 1.0.0+, Tomato 1.28 (Linux 2.4.20), Tomato firmware (Linux 2.6.22), Sony Ericsson U8i Vivaz mobile phone
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   7.30 ms lb120.home (192.168.1.26)

NSE: Script Post-scanning.
Initiating NSE at 03:32
Completed NSE at 03:32, 0.00s elapsed
Initiating NSE at 03:32
Completed NSE at 03:32, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1165.61 seconds
           Raw packets sent: 197008 (8.671MB) | Rcvd: 334 (15.076KB)</pre>

Uznałem zatem że czas znaleźć firmware i poddać go szybkiemu reversowi. Aplikacja (czyli podstawowy sposób aktualizacji urządzenia) nie jest podatna na MITM (z użyciem mitmproxy udało mi się zdobyć tylko jednego JSONa z z listą krajów) więc ten sposób odpadł. Lokalizację pliku na serwerach TP-Linka postanowiłem namierzyć używając znanej nazwy ZIPa z pierwszego artykułu. Googlając mamy pewien skrypt pythonowy (<https://github.com/curesec/Blog/blob/master/kasa_control.py>) który zdradza ścieżkę - <span class="lang:default EnlighterJSRAW crayon-inline ">http://www.tp-link.us/res/down/soft/HS100(US)_V1_151016.zip</span> , jednak żadna manipulacja parametrami na podstawie znanej wersji obecnego obrazu i sprzętu nie pomagała. Poniżej szczegóły urządzenia:

<pre class="lang:default EnlighterJSRAW" title="tplight details 192.168.1.26">{
  "sw_ver": "1.7.1 Build 171109 Rel.163935",
  "hw_ver": "1.0",
  "model": "LB120(EU)",
  "description": "Smart Wi-Fi LED Bulb with Tunable White Light",
  "alias": "Biurko ",
  "mic_type": "IOT.SMARTBULB",
  "dev_state": "upgrade",
  "mic_mac": "&lt;redacted&gt;",
  "deviceId": "&lt;redacted&gt;",
  "oemId": "&lt;redacted&gt;",
  "hwId": "&lt;redacted&gt;",
  "is_factory": false,
  "disco_ver": "1.0",
  "ctrl_protocols": {
    "name": "Linkie",
    "version": "1.0"
  },
  "light_state": {
    "on_off": 1,
    "mode": "normal",
    "hue": 0,
    "saturation": 0,
    "color_temp": 6000,
    "brightness": 100
  },
  "is_dimmable": 1,
  "is_color": 0,
  "is_variable_color_temp": 1,
  "preferred_state": [
    {
      "index": 0,
      "hue": 0,
      "saturation": 0,
      "color_temp": 3500,
      "brightness": 100
    },
    {
      "index": 1,
      "hue": 0,
      "saturation": 0,
      "color_temp": 6500,
      "brightness": 50
    },
    {
      "index": 2,
      "hue": 0,
      "saturation": 0,
      "color_temp": 2700,
      "brightness": 50
    },
    {
      "index": 3,
      "hue": 0,
      "saturation": 0,
      "color_temp": 2700,
      "brightness": 1
    }
  ],
  "rssi": -56,
  "active_mode": "schedule",
  "heapsize": 291620,
  "err_code": 0,
  "lamp_beam_angle": 270,
  "min_voltage": 110,
  "max_voltage": 120,
  "wattage": 10,
  "incandescent_equivalent": 60,
  "max_lumens": 800,
  "color_rendering_index": 80
</pre>

Okazało się jednak że wątek na forum TP-Linka (<https://forum.tp-link.com/showthread.php?93906-lb-110-bulb-loses-connection>) posiada odnośnik do narzędzia "iotUpgradeTool". Nie namyślając się wiele ściągnąłem i odpaliłem. W paczce znajduje się tool który potrafi to co aplikacja (aktualizuje do najnowszej wersji), binarki (yay!) i plik z definicjami - czyli na upartego można by pewnie zrobić downgrade (ale nie testowałem).

![](/wp-content/uploads/2018/05/iotupgradetool.png) 

TP-Link nie ułatwia znalezienie najnowszej wersji (v1.0 miała stary firmware) bo nie mają listowania folderów na swojej stronie. A przynajmniej na głównej w domenie .com - bo ta .de już takowy ma włączony. To ogólny protip - producenci bardzo często zapominają patchować (w tym wyłączać listing) serwery swoich oddziałów (a szczególnie te w domenie .ru - tam swego czasu znalazłem pliki DRACa o które pewnie Della musiałbym się długo prosić). Dla potomnych (gdyby TP-Link postanowił usunąć pliki) załączam zipa z najnowszą wersją - [iotUpgradeTool_V1.3.zip][5]

Mamy binarkę, czas na binwalka! (odpowiedni plik to smartBulb\_FCC\_1.7.1\_Build\_171109\_Rel.163935\_2017-11-09_16.42.10.bin dla wszystkich smart żarówek)

<pre class="lang:default EnlighterJSRAW ">DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
33820         0x841C          Certificate in DER format (x509 v3), header length: 4, sequence length: 1149
34973         0x889D          Certificate in DER format (x509 v3), header length: 4, sequence length: 1232
36209         0x8D71          Certificate in DER format (x509 v3), header length: 4, sequence length: 1024
37556         0x92B4          Base64 standard index table
38484         0x9654          Certificate in DER format (x509 v3), header length: 4, sequence length: 1235
40153         0x9CD9          StuffIt Deluxe Segment (data): fServerUrl
52745         0xCE09          StuffIt Deluxe Segment (data): fServerUrl
61216         0xEF20          HTML document header
61299         0xEF73          HTML document footer
62244         0xF324          HTML document header
62447         0xF3EF          HTML document footer
455040        0x6F180         HTML document header
459220        0x701D4         HTML document footer
459236        0x701E4         JPEG image data, JFIF standard 1.01
481772        0x759EC         XML document, version: "1.0"
482040        0x75AF8         HTML document header
482124        0x75B4C         HTML document footer
</pre>

Skład trochę dziwny - mamy znane z artykułu certyfikaty (SSL pinning w akcji), jakieś pliki HTML (czyżby interfejs webowy?), obrazek, plik XML i coś co jest danymi binarnymi (pewnie wykonywalnymi) w formacie tak egzotycznym że binwalk sobie nie radzi. W trybie "-b" wykrył sporo instancji "EFS2 Qualcomm filesystem super block". Ale nic więcej. Czas więc wypakować i spojrzeć co my tam mamy.

Plik XML to... examplowe dane z ezXML (<https://github.com/lxfontes/ezxml/blob/master/README>). Pliki HTML ze znacznikiem <span class="lang:default EnlighterJSRAW crayon-inline "><title>IOE QCA4010 OTA</title></span>  zaś zaprowadziły mnie do takiego oto maleństwa:

![](/wp-content/uploads/2018/05/qca4010chip.jpg) 

QCA4010 (<https://developer.qualcomm.com/hardware/qca4010-12>) to gotowiec IoT od Qualcomma. Pliki HTML znowu okazały się examplem (<https://developer.qualcomm.com/download/qca4010/qca4010-sdk2-user-guide.pdf>) którgo TP-Linkowi nie chciało się usunąć - testowałem wszelkie opcje żeby uzyskać dostęp do URLi widocznych w HTMLu - bezskutecznie.

Binwalk co prawda nie poradził sobie z wydzieleniem samego pliku wykonywalnego, ale zwykłe strings wskazuje gdzie one zapewne są. Inspekcję IDĄ czy radare2 uznałem za zbędną gdyż całość wygląda na gotowy framework Qualcomma (no i muszę przyznać że nie bawiłem się nigdy w deasemblację SoC'ów)  - dość bezpieczny po pobieżnej analizie dokumentacji.

Dodatkowych argumentów dostarczyła analiza funkcji API (potwierdzonych wyciągnięciem stringów) - żaden nie daje dostępu do shella; nawet setup WiFi korzysta z biblioteki a nie polecenia systemowego. Parametr reboota - "delay" trochę mi śmierdzi ale nie udało mi się tego wykorzystać w żaden sposób. Nawet shellshock nie jest możliwy bo jak zauważył autor pierwotnego artykuły klient DHCP ignoruje wszelkie stringi.

Samo API także jest bezpieczne - walidowane i escapowane są stringi - numer z nullem, ciapkiem czy ostatnim [znaczkiem-zabójcą dla iOS][6] nie przechodzą - system radośnie akceptuje wszystko (i pokazuje ładnie w aplikacji). No - nie wszystko, bo jest limit długości. Dla osób szukających szczęścia (może nazwą uda się zabić serwery TP-Linka?) komenda tplinght (bo moduł tplink-smarthome-api nie działa) do ustawiania nazwy:

<pre class="lang:default EnlighterJSRAW">tplight raw $IP '{"smartlife.iot.common.system":{"set_dev_alias":{"alias":"&lt;&gt;"}}}'</pre>

&nbsp;

Ogólnie rzecz biorąc bezpieczeństwo nie jest takie tragiczne - jest wręcz dobre. Rzecz jasna fuzzing pewnie coś wykaże, ale wątpię w możliwość zrootowania żarówki z (i ponownego męczenia Krebsa - tym razem na googlowym CDNie). Jedyny mankament to autoryzacja "przez obecność w tej samej sieci". Bo w ten sposób można nawet przerejestrować żarówkę na cudze konto. Już widzę złośliwe aplety flashowe/javowe/kiedyś-JSowe (jak raw sockety na frontendzie wejdą; póki co zwykłe strony HTMLowe nie są groźne) które wysyłają requesty do żarówek. O dowcipnych gościach nie mówiąc. Jedyna chyba opcja to wydzielnie VLANu dla IoT - najlepiej osobnego dla urządzeń każdego producenta (żeby odkurzacz nie zhackował nam światła). I jeśli ufamy że nasz telefon nie zacznie wysyłać requestów to można go wpiąć do tego vlanu. A jak nie - to zostaje sterowanie z proxy w postaci serwerów producenta - a one mogą mieć awarię. No i zawsze pakiet trochę daleko leci...

 [1]: /wp-content/uploads/2018/05/IMG_5269.png
 [2]: /wp-content/uploads/2018/05/IMG_5270.png
 [3]: /wp-content/uploads/2018/05/IMG_5272.png
 [4]: /wp-content/uploads/2018/05/IMG_5271-1.png
 [5]: /wp-content/uploads/iotUpgradeTool_V1.3.zip
 [6]: https://niebezpiecznik.pl/post/tym-artykulem-zabijesz-komus-iphona-i-maca/