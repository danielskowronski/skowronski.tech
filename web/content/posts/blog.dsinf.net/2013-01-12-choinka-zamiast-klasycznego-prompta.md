---
title: '"Choinka" zamiast klasycznego prompta'
author: Daniel Skowroński
type: post
date: 2013-01-12T00:09:40+00:00
url: /2013/01/choinka-zamiast-klasycznego-prompta/
tags:
  - bash
  - linux

---
W Linuksie defaultowy prompt, czyli znak zachęty, oscyluje wokół czegoś na kształt 

<pre class="EnlighterJSRAW bash">user @host working_dir #</pre>

gdzie oczywiście # wskazuje na konto root'a, zamiast niego zwykły użytkownik ma $. Ale czemu prompt ma nie przekazywać innych użytecznych informacji, a przede wszystki przekazywać ich ładnie? 

Mój prompt na tą godzinę (zmiany są niemal natychmiastowe, ale o tym pod koniec) wygląda tak:  
![](http://blog.dsinf.net/wp-content/uploads/2013/01/choinka.png)  
  
Nie to jest ładne, co jest ładne, ale co się komu podoba. Przeanalizujmy jednak taką konfigurację by nauczyć się tworzyć własne. Ale najpierw powiem co jest po kolei bo ciężko się chyba od razu połapać. Kolejno: numer tego polecenia w historii, użytkownik, host, data, stan baterii, temperatura CPU i bieżący katalog. Konfiga pobrać można na dole.

## Koncepcja omawianego prompt'a

Kiedy łączę się przez SSH z komórki to ekran jest za mały by pomieścić dłuższe ścieżki, a zdarza sie, że niemający ograniczeń w jej długości extFS, potrafi zapchać linijkę i trochę na zwykły ekranie; dołóżmy jeszcze inne elementy podstawowe - wówczas w ogóle nie widać naszego polecenia - gdzie jest pocżtek, a gdzie koniec. Dlaetgo rozdzieliłem informacje do jednej linii, a tam, gdzie wprowadzamy polecenia są tylko 3 znaki(dla ozdoby 🙂 ).

## Wstęp do modyfikacji

Pierwsza sprawa to lokalizacja konfigu. Otóż wystarczy wydać komendę w w rodzaju

<pre class="EnlighterJSRAW bash">PS1="nowy ale nic nie robiący prompt #"</pre>

by od razu zmienić wygląd. Ale istnieje przecież plik, który startuje bash'a - <u>.bashrc</u> w katalogu użytkownika lub globalny - <u>/etc/bash.bashrc</u>. Warto zauważyć, że w tym pliku najprawdopodobniej będą co najmniej trzy różne podstawienia do PS1, więc możemy wpisać się w uproszczeniu na końcu pliku.

## Kolorki

Pierwszy fragment mojego kodu definiuje od razu najfajniejsze, czyli kolorki opierające się na Escape kodach, czyli zaczynających się od _\e[_ i służących do sterowania konsolą. Umieszczenie kodów w zmiennych zdecydowanie ułatwi operacje na zmianie kolorów, ale można wykorzystywać ich kombinacje. Spójrzmy na nie:

<pre class="EnlighterJSRAW bash">txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

#przykładowa kombinacja: \e[47; 31m - czerwone na białym tle</pre>

Kody jako zmienne, czyli poprzedzone dolarem można umieszczać zarówno w zmiennej PS1, jak i w wejściu dla echo, z tym, że potrzebny będzie wówczas dodatkowy parametr -e.

## Elementy interaktywne

Moja konfiguracja obsługuje dowolne elemnty interaktywne, czyli takie, które nie są zczytywane z zmiennych środowiskowych (np. data, czy bieżący katalog), o których opowiem niżej. Może to być jakiekolwiek polecenie. Przykładami są wyświetlanie stanu baterii (bardzo praktyczne w laptopach, ale czemu nie zczytywać stanu zasilacza awaryjnego w serwerowni?) i monitorowanie temperatury.  
Zanim przystąpimy do pisania funkcji wykorzystywanych w prompcie należy zwrócić uwagę na pewne modyfikacje w .bashrc. Otóż, gdybyśmy tak po prostu wrzucili funkcje i umieścili do nich odwołania w zmiennych to ich wynik zostałby pobrany tylko raz przy ładowaniu shella. Przecież zmienna ładowa jest tylko raz. Sposobem na ominięcie tego jest przeładowywanie zmiennej za każydym poleceniem. Jest to prostsze niż się może wydawać. Wystarczy definicja funkcji, jej wywołanie, kolejna zmienna i od razu pewne wprowadzenie do innej rzeczy:

<pre class="EnlighterJSRAW bash">function ps1 {
#jakiś fajny kod
}

ps1
PROMPT_COMMAND="LEC=\$?; ps1"</pre>

Funkcja ps1 zawiera wszystkie deklaracje prompta, od których oczekujemy, że przeładują się przy każdym kliknięciu Return na klawiaturze. W skrypcie startowym trzeba najpierw pierwszy raz wywołać ładowanie - piąta linijka. Magiczne PROMPT_COMMAND zawiera spis poleceń do wykonania po zakończeniu działania poprzedniej komendy, a więc wynich wyświetli się pomięcy jednym a drugim pustym wierszem w shellu (czyli takim bez polecenia, tylko czysta linia). Oczywiście funkcja ps1 może nazywać się np. foo i nie będzie problemu.  
Zostało coś jeszcze, czyć nie? _LEC=\$?;_ ładuje do zmiennej exitcode ostatniego polecenia, ponieważ w trakcie wywołania funkcji może się on nadpisywać przez deklaracje lub inne instrukcje robocze. Wykorzystamy to nieco później.

Funkcja wyświetlająca wraz z ładnym formatowaniem stan baterii pochodzi ze strony http://www.basicallytech.com/blog/index.php?/archives/110-Colour-coded-battery-charge-level-and-status-in-your-bash-prompt.html. Wygląda następująco:

<pre class="EnlighterJSRAW bash">battery_status()
{
    BATTERY=/proc/acpi/battery/BAT0

    REM_CAP=`grep "^remaining capacity" $BATTERY/state | awk '{ print $3 }'`
    FULL_CAP=`grep "^last full capacity" $BATTERY/info | awk '{ print $4 }'`
    BATSTATE=`grep "^charging state" $BATTERY/state | awk '{ print $3 }'`

    CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

    NON='\033[00m'
    BLD='\033[01m'
    RED='\033[01;31m'
    GRN='\033[01;32m'
    YEL='\033[01;33m'

    COLOUR="$RED"

    case "${BATSTATE}" in
	'charged')
		BATSTT="$BLD=$NON"
		;;
	'charging')
	    BATSTT="$BLD+$NON"
		;;
        'discharging')
		BATSTT="$BLD-$NON"
		;;
    esac

    if [ "$CHARGE" -gt "99" ]; then
	CHARGE=100
    fi

    if [ "$CHARGE" -gt "15" ]; then
	COLOUR="$YEL"
    fi

    if [ "$CHARGE" -gt "30" ]; then
	COLOUR="$GRN"
    fi

    echo -e "${COLOUR}${CHARGE}%${NON} ${BATSTT}"
}
</pre>

Funkcja wyświetla wynik od razu na ekran więc jej wstawienie do zmiennej będzie wyglądało mniej więcej następująco: 

<pre class="EnlighterJSRAW bash">zmienna="napis"`funkcja`"napis"$zmienna;</pre>

Oczywiście funkcja wstawiona jest w back-ciapkach (zwanych chyba nieco poprawniej grawisami lub back-tick'ami). 

Funkcja wyświetlająca temperaturę (napisana już przeze mnie):

<pre class="EnlighterJSRAW bash">function temperatura {
    TH_ZONE="Core 0" #konfigurowalne i mandatory! zalezy od acpi
    TEMP=`sensors | grep "$TH_ZONE" | sed 's/.*:\s*+\(.*\)  .*(.*/\1/' | sed 's/.\{4\}$//'`
    #4 na koncu to .0`C

    if [ "$TEMP" -le "35" ]; then 
	COLOUR=$bakcyn$txtwht
    elif [ "$TEMP" -le "55" ]; then
	COLOUR=$txtcyn
    elif [ "$TEMP" -le "70" ]; then
	COLOUR=$txtylw
    elif [ "$TEMP" -le "80" ]; then
	COLOUR=$txtpur
    elif [ "$TEMP" -le "90" ]; then
	COLOUR=$txtred
    elif [ "$TEMP" -gt "91" ]; then
	COLOUR=$bakred$txtblk
    fi
    
    echo -ne $COLOUR$TEMP"°C";
}
</pre>

Krytyczne jest wprowadzenie zmiennej TH_ZONE - wystarczy odpalić komendę sensors (oczywiście jeśli jej nie ma to trzeba zainstalować) i wybrać nazwę strefy, która nas interesuje. W laptopach pod Linukem bywa słabo z wykrywaniem sterowników, a w netbookach potrafią być w ogóle tylko dwa - CPU + dysk. Funkcja dodatkowo koloruje napis w zależnosci od przedziału - warto poświęcić chwile na dostosowanie zakresów, gdyż jedne komputery nie wytrzymują i się wyłączają 85, a inne (głównie netbooki) trzymają teoretycznie do 115 (co ciekawe jeden taki sprzęt zagrzałem do 105 - przeżył i obyło się bez swądu palonej elektroniki).  
Porada: pierwsza granica to zazwyczaj temperatura zmierzona po zimnym rozruchu po odstaniu godziny.

## Zmienne środowiskowe i zlepianie wszystkiego do kupy

Teraz ciało funkcji ps1. Zacznujmy od czyszczenia na wszelki wypadek zmiennej (jako, że wszędzie _dopisujemu_, a nie nadpisujemy):

<pre class="EnlighterJSRAW bash">PS1="" #reset</pre>

Pierwszym elementem, który się pojawia (dla tty: _albo i nie_) to zielony tick po pomyślnym wywołaniu komendy poprzedniej wstawiony w border'a lub cała linijka z czerwonym cross'em i podanym exitcodem. Użyteczne, bo programy nie zawsze podają dokładny kod błędu.

<pre class="EnlighterJSRAW bash">if [[ $LEC == 0 ]]; then
    PS1=$PS1"\[\033[01;32m\]\342\234\223\e[0m─"
else
    PS1=$PS1"\[\033[01;31m\]\342\234\227\e[0m [exitcode: $LEC]\n┌─"
fi
</pre>

Mało czytelnie? $LEC to wcześniej opisany kod wyjścia (normalnie **$?**) ostatniej komendy (realnie, a nie tej ze skryptu), natomiast \342\234\223 oraz \342\234\227 to ptaszek i iks w UTF'ie (┌─ odpowiada za "zakręt" ramki zcalającej obie linie prompta).

Warto wiedzieć na kogo się zalogowaliśmy lub jakie konto ktoś zostawił:

<pre class="EnlighterJSRAW bash">red="\[\e[0;33m\]"
yellow="\[\e[0;31m\]"

if [ `id -u` -eq "0" ]; then
    root="${yellow}"
    else
        root="${red}"
fi

PS1=$PS1"[!\!]─[${root}\u\[\e[0;37m\]]─"
</pre>

Ostatnia linia dopisuje kolorki z if'a powyżej, nawiasy i właściwą nazwę użytkownika - parametr **\u**.

Kolejne informacje - host **\h** i data (**\d**) wraz z czasem (**\t**):

<pre class="EnlighterJSRAW bash">PS1=$PS1"[\[\e[0;96m\]\h\[\e[0;37m\]]─[\e[0m\e[0;33m\d \t\e[0m]─"
</pre>

Doklejmy teraz informacje z funkcji. Dodatkowo stan baterii wyświetlany jest tylko, gdy nie ładujemy (ale zmiana jest bardzo prosta - to pierwszy if):

<pre class="EnlighterJSRAW bash">#bateria
if grep --quiet off-line /proc/acpi/ac_adapter/AC/state; then
    PS1=$PS1"[\[\e[0;35m\]"`battery_status`"\[\e[0;37m\]]─"  
fi

#temperatura
PS1=$PS1"[\[\e[0;35m\]"`temperatura`"\[\e[0;37m\]]─"  
</pre>

Na koniec jedynie katalog roboczy (**\w**) i zawinięcie linijki. Deklaracja drugiej linii w prompcie to PS2:

<pre class="EnlighterJSRAW bash">PS1=$PS1"[\[\e[0;32m\]\w\[\e[0;37m\]]\n\[\e[0;37m\]└──| \[\e[0m\]"
PS2="╾──| "
</pre>

## Dalsze możliwości

Wymienione kolory to jedynie podstawowe kombinacje - na buforrze ramki, ale i na emulatorach można pokusić się o kolory w liczbie 256 (https://wiki.archlinux.org/index.php/Color\_Bash\_Prompt#Load.2FMem\_Status\_for_256colors), lub dodać którąś ze zmiennych:

<pre>\D{format} format daty zdeklarowany notacji strftime(3) umieszczonyw w klamrach
\d		data
\t		czas 24h
\h		nazwa hosta do pierwszej kropki (bez sieci)
\H		nazwa hosta 
\j		liczba obecnych zadań w konsoli
\u		nazwa uzytkownika
\v		wersja powłoki
\w		katalog roboczy
\W		katalog roboczy ze skróconym katalogiem domowym do ~
\!		numer tego polecenia w historii (użyteczne jeśli mamy spory bufor ekranu i widzimy co najmniej kilka komend, 
		a nam nie chce się bawić strzałką w górę; można też zapamiętać numerek zamiast bardzo długiej komendy i użyć później
\$		dolar dla użytkowników i # dla super-użytkownika
\\		anulowyany (czyli drukowalny) backslash 
</pre>

Więcej na https://wiki.archlinux.org/index.php/Color\_Bash\_Prompt#Prompt_escapes.

## Dalszy rozwój

Prompt będzie zapewne ewoluował gdy zajdzie taka potrzeba - liczba zalogowanych użytkowników, wolne miejsce na dysku, liczba nowych maili, status usług, czy bezpieczeństwa (np. wykrzyknik dla alertów, daszek dla przeciążeia itp.), prędkość wiatraczka lub losowa linia z pliku z cytatami Torvaldsa... Cokolwiek co, okaże się użytczne i odczytywalne przez basha jako string może być łatwo dodane w nawiasy kwadratowe i cieszyć oko z dobrego wykorzystania potencjału shella.

Dobre źródła informacji:

  * Wiki Archa - https://wiki.archlinux.org/index.php/Color\_Bash\_Prompt
  * Bash HowTo - http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/
  * Testowarka kolorowania i zmiennych basha w przeglądarce - http://www.kirsle.net/wizards/ps1.html