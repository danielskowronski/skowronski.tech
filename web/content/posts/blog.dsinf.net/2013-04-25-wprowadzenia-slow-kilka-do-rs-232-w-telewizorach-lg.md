---
title: Wprowadzenia słów kilka do RS-232 w telewizorach LG
author: Daniel Skowroński
type: post
date: 2013-04-24T22:22:19+00:00
url: /2013/04/wprowadzenia-slow-kilka-do-rs-232-w-telewizorach-lg/
tags:
  - embedded
  - flatron m2280df
  - lg
  - linux
  - rom
  - rs-232

---
Pewien czas stał i czekał na decyzję o serwisie przez głupi eksperyment ze zmienieniem nieznanej wartości w menu debugowania - LG Flatron serii Mxx80DF. Wprowadzenia słów kilka do RS-232 w telewizorach LG.  
<!--break-->

  
Zastanawiałem się od czego zacząć. I zacznę nie od początku - **LGMOD NIE jest dla sprzętu LG serii Flatron**.  
A teraz po kolei. W każdej instrukcji do telewizora z portem RS-232 dołożony jest opis konfiguracji gniazda i kody sterujące - bardzo praktyczne kiedy chcemy napisać makra, o których kiedyś pisałem - np. czujnik światła i mamy wzorcowy wyświetlacz.  
Aby się podłączyć poza kablem potrzebujemy jeszcze programu do sterowania terminalem - klasyczny PuTTY - także na Linuksa (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html), TeraTerm (http://logmett.com/index.php?/download/tera-term-477-freeware.html), czy Linuksowy CuteCOM (http://cutecom.sourceforge.net/).

Czas na kilka słów o łączeniu się z portem szeregowym.  
Po pierwsze telewizory LG (jak prawie każde urządzenie) mają "chłopczyka", czyli piny, a nie gniazdo. A większość adapterów na USB też - potrzeba nam przelotki dziewczyna-dziewczynka, które bywają droższe od adapterów. Warto pogrzebać w domu albo popytać w starych serwerowniach bo były wykorzystywane do modemów, ale kolejna uwaga - są szerokie (25 pinowe) i wąskie (9 pinowe).  
Ustawienia transmisji:

  * _baudrate_ - prędkość: 9600 bodów dla sterowania i debugowania, (115200 bodów do bootloadera),
  * liczba bitów danych - 8,
  * liczba bitów stopu - 1,
  * kontrola parzystości (_parity_) - brak,
  * kontrola przepływu - _flow control_ - brak!

Podstawowe sterowanie opisane w instrukcji nie jest zbytnio ekscytujące - ot to samo co możemy "wyklikać" pilotem. Debugowanie oferuje nam wiele możliwości. Podgląd wiadomości debugowania uzyskujemy po prostu wysyłając klawisz F9 - jest to istotne bo menu i odpowiedzi trybu debugowania staną się wówczas widoczne, ale także wszelkie informacje o błędach, takie jak dramatyczne

<pre>043.509:MICOM   ] 
 ERROR I2C Read port:0x4 addr:0x90</pre>

Ale póki wiemy co robimy to raczej nie powinniśmy tego zobaczyć.  
Aby dostać się do samego trybu debugowania potrzebne będzie nam hasło, które nie jest specjalnie wymyślne - jest to

<pre>PEŁNY_MODEL_TELEWIZORAelqjrm
np. M2280DF-PZMelqjrm</pre>

istotne jest użycie całej nazwy (w moim wypadku PZM w odróżnieniu od PZ oznacza jedynie fakt, że mam subwoofer), elqjrm to _tajna fraza_.  
Istnieją 4 sposoby jego wpisania:

<pre>1: &lt;HASŁO&gt;dd
2: d&lt;HASŁO&gt;
3: d&lt;HASŁO&gt;debugd
4:</pre>

Listę poleceń można uzyskać przez komendę help lub sam znak zapytania <?>.

Drzwi do zepsucia telewizora zostały uchylone, czas je otworzyć i uwolnić pingwina - dostać się do powłoki systemu. To dosyć delikatna operacja i _bardzo_ zależna od platformy.  
Ogólnie platformy, czyli procesory o jakie oparto LG są trzy - Saturn 6, Saturn 7 i Broadcom. Nie spotkałem się z kompleksową listą modeli i procesorów, ale włoskie wersje instrukcji, które posiadają dodatkowe strony ze schematem logicznym telewizorów mogą pomóc. W ogólności platformy te następowały po sobie; w moim monitorze z 2010 jest Saturn 6.  
Oto kilka metod jak dostać się do shella (a konkretniej busyboxa):

<pre>Saturn6: call debug_os_shell+0xac
Saturn7: call debug_os_shell+0xb0
Broadcom: call debug_os_shell+0x90</pre>

Inne metody i dokładne wskazówki na http://openlgtv.org.ru/wiki/index.php/Debug\_mode\_connection#Busybox\_shell\_access  
Najwaniejszą rzeczą będzie **wykonanie backupu** za pomocą skryptu powloki i podpiętego nośnika USB <u>zformatowanego jako FAT32!</u> do pierwszego (ewentualnie jedynego) złącza z tyłu:

<pre class="EnlighterJSRAW bash">#najpierw sprawdź, czy dysk zamontował się w /mnt/usb1/Drive1, np.
ls -al  /mnt/usb1/Drive1
#jeśli nie to powinien być urządzeniem /dev/sda1, wówczas
mount /dev/sda1 /mnt/usb1/Drive1

#backup
for i in `cat /proc/mtd | grep -v erasesize | awk '{gsub(/[":]/,"");print $1 "_" $4}'`; do echo \
Backup of $i ...; cat /dev/`echo $i | awk '{gsub(/_/," ");print $1}'` &gt; /mnt/usb1/Drive1/$i; done

#odpmontowanie - sync bardzo ważny
sync
umount /dev/sda1
</pre>

Powstałe pliki razem z odnalezionym w czeluściach internetu oprogramowaniem w formie pliku EPK (a najlepiej dodatkowo narzędziami na Linuksa pozwalającymi skonwertować je do obrazu dysku w postaci raw - mirror najnowszej wersji pod artykułem lub na http://openlgtv.org.ru/wiki/index.php/Firmware\_unpack\_tools) wypada wypalić na płytę i trzymać w bezpiecznym miejscu, ażeby nie mieć potem problemu.

Drzwi otwarte - chyba czas je wyważyć razem z futryną i kawałkiem muru 😉 Bootloader we wszystych modelach poza SmartTV nie powinien być zaszyfrowany.  
Pierwsza zmiana to inny baudrate - 115200bps. Wyłączamy telewizor, wpinamy kabel, odpalamy program i w czasie gdy włącza się urządzenie (po wciśnięciu włącznika rzecz jasna) przesyłamy po terminalu jedno z poniższych aż do uzyskania

<pre>mstar #
lub saturn7 #</pre>

&nbsp;

  * przytrzymanie klawisza Escape
  * wciśnięcie Ctrl+C
  * umieszczenie losowych danych - najpraktyczniej z /dev/urandom <pre class="EnlighterJSRAWbash">cat /dev/urandom &gt; /dev/ttyUSB0</pre>

&nbsp;

Wszystkie bootloadery Saturn mają taki sam rozkład komend:

<pre>mstar # help
?       - alias for 'help'
appxip  - copy to ram for appxip
base    - print or set address offset
bbm     - nand bad block management
bootm   - boot application image from memory
bootp   - boot image via network using BootP/TFTP protocol
cmp     - memory compare
cp      - memory copy
cp2ram  - copy to ram for partition name
crc32   - checksum calculation
dcache  - enable or disable data cache
defaultenv - set default env
go      - start application at address 'addr'
help    - print online help
load    - downlaod image file, and write on flash
loadz   - downlaod image file using zmodem, and write on flash
loop    - infinite loop on address range
md      - memory display
mm      - memory modify (auto-incrementing)
mtdinfo - edit or add or remove mtdinfo
mtest   - simple RAM test
mw      - memory write (fill)
nand    - NAND sub-system
nboot   - boot from NAND device
nm      - memory modify (constant address)
nvmdbg  - eeprom test progrm
ping    - send ICMP ECHO_REQUEST to network host
printenv- print environment variables
rarpboot- boot image via network using RARP/TFTP protocol
reboot  - Perform RESET of the CPU
reset   - Perform RESET of the CPU
rs      - downlaod image file,though zmodem
run     - run commands in an environment variable
rz      - downlaod image file,though zmodem
saveenv - save environment variables to persistent storage
setboot - set boot type(root filesystem)
setenv  - set environment variables #przydatne do zmiany parametrów jądra
silent  - silent all or nothing
swu     - downlaod epk image file, and write on flash
swuz    - downlaod epk image file, and write on flash #docelowa metoda pobierania EPK przez zmodem
tftpboot- boot image via network using TFTP protocol
usb     - USB sub-system
version - print monitor version
xip     - copy to ram for xip
</pre>

Jak widać mimo, że model nie ma Ethernetu to ma pinga w menedżerze rozruchu... Ale jeśli nasz model łapie się pod LGMOD (lista na http://openlgtv.org.ru/wiki/index.php/Achievements, warto zapoznać się z uwagami - http://openlgtv.org.ru/wiki/index.php/LGMOD) to na USB można podpiąć adapter i ze starego, taniego telewizorka wystawiać FTP 😉

**Ratowanie sprzętu**  
Cóż, zdarza się przestawić niewiadomo co - nie ma co panikować. Jeśli zrobiliśmy backup, albo mamy oryginalny EPK to po problemie, chyba, że bootloader nie odpowiada. Co warto zauważyć, to fakt, że migająca dioda power włączana jest przez rodzaj BIOSu, a wyłączana lub jej miganie zatrzymywane przez zabootowany do końca system operacyjny.

W razie dziwnych reakcji konsoli warto odciąć zasialnie całkowicie, pozmieniać baudrate (ale zacząć od 115200 dla bootloadera), sprawdzić, czy kabel jest OK. Jeśli wszytsko zawiedzie najlepszym posunięciem jest podpięcie się do konsoli debugowania, czyli zwykłego trybu, włączenie wiadomosći debuggera (zwykle F9) i aktywowanie w Puttym opcji logowania do pliku.  
Dwa świetne fora na których społeczość jestt ciągle aktywna: http://openlgtv.org.ru/forum/index.php i http://www.lg-hack.info/.

**Wskazówki końcowe**

&nbsp;

  * Najlepiej włączyć logowanie do pliku na stałe w naszym kliencie portu szeregowego - zawsze będzie łatwiej sprawdzić co się stało (zwłaszcza, gdy konsola jest zalewana ciągłym komunikatem o błędach pamięci)
  * W wielu menu są opcje niezlinkowane z niczym (gdzieś natknąłem się na _if you really want this you can make it_
  * Zmiana adresowań pamięci to funkcja o której lepiej się trzymać z dala, chyba, że wiemy co robimy i chemy np. rysować po ekranie
  * Najlpeije zrobić backup i ściągnąć oryginalne oprogramowanie zawczasu

&nbsp;

Szczegóły na temat formatu EPK: http://openlgtv.org.ru/wiki/index.php/EPK\_file\_format

&nbsp;

ROM dla Flatrona M80 (np. M2280DF) -> [EPK_\_LG\_FLATRON.zip][1]

 [1]: http://blog.dsinf.net/wp-content/uploads/2015/08/EPK__LG_FLATRON.zip