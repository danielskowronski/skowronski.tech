---
title: Windows 10 i problemy z wybudzaniem z uśpienia
author: Daniel Skowroński
type: post
date: 2018-12-20T04:22:03+00:00
excerpt: Moja główna stacja robocza to Dell Precision T5500 – nie taki mały potworek z mocno przesadzoną konfiguracją (kto montuje w niemal 10-letnim sprzęcie GTX1060?). Chodzi sobie grzecznie na Windowsie 10 głównie ze względu na gry. Poza tym głównie wykorzystywana jako host wirtualizacji laba i stacja robocza admina. Zazwyczaj odpalona nieprzerwanie. No ale jakoś parę miesięcy temu (jak się później okaże to dokładnie w kwietniu tego roku) komputer zaczął mieć problemy z trybem uśpienia.
url: /2018/12/windows-10-i-problemy-z-wybudzaniem-z-uspienia/
featured_image: https://blog.dsinf.net/wp-content/uploads/2018/12/dellt5500.jpg
tags:
  - bios
  - hardware
  - nehalem
  - windows 10
  - x58

---
Moja główna stacja robocza to Dell Precision T5500 - nie taki mały potworek z mocno przesadzoną konfiguracją (kto montuje w niemal 10-letnim sprzęcie GTX1060?). Chodzi sobie grzecznie na Windowsie 10 głównie ze względu na gry. Poza tym głównie wykorzystywana jako host wirtualizacji laba i stacja robocza admina. Zazwyczaj odpalona nieprzerwanie. No ale jakoś parę miesięcy temu (jak się później okaże to dokładnie w kwietniu tego roku) komputer zaczął mieć problemy z trybem uśpienia.

Na samym początku było to losowe wybudzanie się z trybu uśpienia - pomogło oczywiście wyłączenie _magic packetów_ na karcie sieciowej, wybudzania po urządzeniach USB i PCI. Potem problem wrócił, ale temat nieco zignorowałem uznając że i tak rzadko wyłączam stację a rachunki za prąd mnie nie zabijają (ten potworek na luzie ciągnie około 250W). 

Kolejny problem który się pojawił to całkowity brak możliwości wybudzenia komputera z trybu uśpienia. Przejście do S3 odbywa się poprawnie, wybudzenie do pewnego momentu (gdzieś po odpaleniu dysków) też. A potem zanim wystartuje m.in. karta graficzna i pełne zasilanie USB nic - nawet wentylatory nie zmieniają prędkości. Po kilku minutach zasilanie się wyłącza - to pewnie zasługa BIOSu który wykrywa że CPU nie robi nic.

Można by pomyśleć że to jakiś BSOD zanim wystartuje zasilanie wszystkich komponentów. Ale ciężko cokolwiek zgadywać kiedy system nie jest w stanie zapisać żadnych informacji na dysk a więc szperanie w dzienniku zdarzeń nic nie daje. Podstawowe tweakowanie BIOSU w opcjach związanych z zasilaniem oczywiście nic nie dało (bo inaczej temat nie warty byłby artykułu). Analiza ustawień zasilania systemu też. Nawet aktualizacja wszystkich sterowników. Spróbowałbym wówczas jeszcze hibernacji ale akurat dysk systemowy mam naprawdę mały przez przesadną oszczędność jakiś czas temu - 2 rozsądne dyski SSD 128GB w RAID1 - także hiberfil.sys się nie mieści (zapomniałbym dodać - RAMu mam 48GB).

Potestowałem dla pewności Linuksa. I okazuje się że problemu nie było także to zapewne kwestia Windowsa i braku dogadania się z CPU/BIOSem/ACPI/czymkolwiek. Ale jak wspomniałem na początku Windowsa potrzebuję do gier 🙂 

Dopiero jakieś kilka tygodni temu problem zaczął mnie irytować kiedy chciałem szybko wznawiać pracę - sekwencja POST stacji roboczych trwa tyle co serwerów (a przez dysk SSD system podnosi się ułamek czasu startu BIOSu...). Kiedy po trudach optymalizacji dysku C: (**protip**: NTFS ma tryb kompresji plików) włączyłem w końcu hibernację okazało się że z niej także windows się nie podnosi poprawnie. 

Podstawowa checklista wyglądała tak: 

  * googlanie problemu (to jest serio nietrywialne bo ludzie mają prymitywne problemy które zapychają internet)
  * tryb awaryjny
  * aktualizacja Windowsa (a raczej upewnienie się że jest najnowsza wersja)
  * aktualizacja sterowników wszystkiego (strona Della ma fajną opcję sortowania plików po dacie wydania)
  * aktualizacja BIOSu do wersji A18 (szacunek dla Della że udało się to bez żadnych zmian mimo aktywnego Bitlockera)
  * zweryfikowanie obsługiwanych przez Windowsa stanów zasilania (_powercfg&nbsp;/a_) i przejrzenie raportów zasilania (inne przełączniki powercfg)
  * ponowne przegrzebanie opcji w BIOSie w zakresie zasilania
  * odpięcie wszelkich urządzeń USB (poza prostą klawiaturą USB) i kart rozszerzeń PCI (włącznie z wymianą GPU na prymitywną starą nVidię) 

Dalej nic. A więc uznałem że czas przetestować _tryb&nbsp;debugowania_ po starym dobrym połączeniu szeregowym. Można włączyć przez _msconfig_ albo _bcdedit_ (szczegóły na [stronie Microsoftu][1]). Zacząłem od prymitywnego odczytu gołych danych bez użycia _windbg_ (nie mam drugiej maszyny z windowsem więc liczyłem na brak konieczności stawiania wirtualki). W momencie startu windows nadaje sygnały dla debuggera - _KDTARGET: Refeshing&nbsp;KD&nbsp;connection._ Ale w krytycznym momencie crashu wysyła także jakąś sekwencję danych której nie udało mi się odcyfrować - mimo testowania wszelkich baudrate'ów.  
Tak oto prezentuje się dump ASCII przy 115200bps (wedle ustawień z windowsa) z podziałem na linie gdzie przewiduję granice sekwencji wiadomości:<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="439" src="https://blog.dsinf.net/wp-content/uploads/2018/12/msg-1024x439.png" alt="" class="wp-image-1292" srcset="https://blog.dsinf.net/wp-content/uploads/2018/12/msg-1024x439.png 1024w, https://blog.dsinf.net/wp-content/uploads/2018/12/msg-300x129.png 300w, https://blog.dsinf.net/wp-content/uploads/2018/12/msg-768x329.png 768w, https://blog.dsinf.net/wp-content/uploads/2018/12/msg.png 1231w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

Czas więc na _windbg_. [Pobrać go można łatwo][2], w obsłudze jest nieco trudniej. No i trzeba uważać na to które windbg odpalamy. Bo do menu start dodane są wersje x86, amd64 i arm. No i jak łatwo zgadnąć armowa się na x64 nie odapli.  
Ale zasadniczo trzeba kliknąć _File/Kernel&nbsp;debug..._, wskazać parametry połączenia (polecam wybrać _reconnect_), warto ustawić _View/Verbose&nbsp;output_ i na koniec zrebootować windowsa którego się debuguje (inaczej się nie podłączy). Przez tryb verbose będzie się bootować długo, ale zobaczymy wszelkie moduły które są ładowane do jądra. Do normalnych celów testowania np. sterownika można by dać Ctrl+Break, ale to nie jest normalne debugowanie więc o tym nie w tym wpisie. <figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2018/12/VirtualBox_windbg_20_12_2018_04_35_45-1024x768.png" alt="" class="wp-image-1293" srcset="https://blog.dsinf.net/wp-content/uploads/2018/12/VirtualBox_windbg_20_12_2018_04_35_45.png 1024w, https://blog.dsinf.net/wp-content/uploads/2018/12/VirtualBox_windbg_20_12_2018_04_35_45-300x225.png 300w, https://blog.dsinf.net/wp-content/uploads/2018/12/VirtualBox_windbg_20_12_2018_04_35_45-768x576.png 768w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

Co widać powyżej? Do zaznaczonego fragmentu mamy moduły ładowane na starcie, potem 2 zaznaczone linijki to moduły ładowane w czasie przechodzenia do trybu uśpienia S3. Na samym końcu nieistotny błąd samego windbg wynikający z odłączenia adaptera RS232 na USB. Jednak wcale nie uzyskujemy żadnych informacji o najważniejszej transmisji z crashu przy próbie wznowienia S0.  
Po zdiagnozowaniu problemu i jego ostatecznych obejściu sprawdziłem czy tajemniczy sygnał się pojawia podczas normalnego przejścia S3->S0. Otóż nie.

W tym momencie uznałem że spróbuję w BIOSie wyłączyć wszystko co nie jest niezbędne do rozruchu, odepnę wszystko poza dyskiem systemowym (jednym z macierzy), zawieszę bitlockera i będę uruchamiał tryb awaryjny. 

I wybudzanie z S3 zadziałało. Metodą prób i błędów włączając jedną opcję na raz doszedłem do zasadniczego problemu - **VT-d. Wystarczy go wyłączyć.**<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="768" src="https://blog.dsinf.net/wp-content/uploads/2018/12/bios-1024x768.jpg" alt="" class="wp-image-1295" srcset="https://blog.dsinf.net/wp-content/uploads/2018/12/bios-1024x768.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2018/12/bios-300x225.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2018/12/bios-768x576.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" /> <figcaption>W moim BIOSie VT-d wygląda tak</figcaption></figure> 

[VT-d][3] w skrócie pozwala maszynom wirtualnym na bezpośredni (bez udziału OSu) dostęp do urządzeń PCI. Szansa że zechcemy skorzystać z jego mocy na starym sprzęcie jest niska więc nie zaszkodzi żyć z wyłączonym.

Trochę googlania i okazuje się że VT-d zaczęło robić problemy starszym komputerom z Windows 10 po aktualizacji z kwietnia 2018. Co dokładnie sprzętowo powoduje problem? **Procesory Intel serii Nehalem** (np. Xeon E5540) **i chipset X58**. Sam problem polega na tym że Windows 10 w wersji 1803 przyniósł patche mikrokodu procesora dla [podatności Spectre i Meltdown][4]. Ale chipset X58 nie jest wspierany od 2013 roku i nie dostał patchy które są wymagane żeby pewne mapowania pamięci przy aktywnym VT-d zgadzały się z tymi w procesorze. Na którymś forum trafiłem na hackerskie patche mikrokodu dla płyt głównych producentów takich jak Asus czy ASRock, ale dla profesjonalnych stacji roboczych Della ich brakuje. 

Problem okazał się zasadniczo nietrywialny i niezbyt łatwo googlalny, ale przynoszący sporo satysfakcji. Kiedyś zapewne wrócę do badania tajemniczych wiadomości z crashu przy VT-d.

Na koniec kilka linków które pomogły mi rozwikłać zagadkę. 

  * wątek z technetu który wskazuje że problem występuje także przy instalacji windowsa: <https://social.technet.microsoft.com/Forums/en-US/f609f769-b6ea-48fd-8055-04a37de17b45/i-have-a-pc-that-will-not-wake-from-standby-since-build-1709-fall-creators-update?forum=win10itprogeneral>
  * wątek z techpowerup o patchach dla X58: <https://www.techpowerup.com/forums/threads/meltdown-and-spectre-patched-bios-for-x58-motherboards.246101/page-6>
  * i podobny z bios-mods: <https://www.bios-mods.com/forum/Thread-Asrock-X58-SuperComputer-anti-spectre-microcode-and-vt-d-upgrade>

 [1]: https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--debug
 [2]: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools
 [3]: https://software.intel.com/en-us/blogs/2009/06/25/understanding-vt-d-intel-virtualization-technology-for-directed-io
 [4]: https://meltdownattack.com/