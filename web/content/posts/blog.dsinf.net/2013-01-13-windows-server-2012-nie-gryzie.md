---
title: Windows Server 2012 nie gryzie…
author: Daniel Skowroński
type: post
date: 2013-01-13T20:07:03+00:00
url: /2013/01/windows-server-2012-nie-gryzie/
tags:
  - windows
  - windows 2012
  - windows server

---
**Windows Server 2012 nie gryzie...  
...tylko zionie ogniem w każdego.** Mam nadzieję, że zebrane tutaj materiały będą swoistą tarczą przeciwogniową;)  
<!--break-->

## Zanim zaczniemy

Pierwsze w co należy się wyposażyć to płyta lub jej obraz. Będzie nam potrzebny po instalacji - od razu do zainstalowania .net Framework 3.5, którego Microsoft jakoś mocno deprecjonuje, oraz później do recovery systemowego. Serio, płyta będzie potrzebna zawsze jak coś się zpsuje i do odtworzenia backupu.

## Instalacja

Nie różni się niczym, tylko nazwą logiem bootowania od instalki Servera 2008 R2. To na co warto zwrócić uwagę, to dostępne systemy plików - długo niejasne stanowisko MS w sprawie ReFS'u jest następujące: na razie tylko na dane, system z niego nie pójdzie, więc nie ma co szukać go w opcjach formatowania. Sama instalacja jest nawet szybka - na trzyletnim laptopie (Core2Duo, 4GB RAM) z dość powolnym napędem optycznym zajmuje maks. 20 minut.  
Ciekawostka: nie mamy już komunikatu-zabójcy: "hasło jest za długie, za krótkie lub zbyt proste"

## Po instalacji

**UWAGA: należy ściągnąć na innym komputerze przeglądarkę internetową!!!** Wbudowany IE trybem zabezpieczonym niemal odcina nas od internetu, a pobranie Firefoxa za pierwszym razem zajmuje koło 15 minut.

Po zainstalowaniu tego jakże fajnego, ale irytującego po instalacji systemu należy niezwłocznie przejść do Menedżera serwera, by dodać odpowiednie funkcje.  
Lista mojej minimalnej konfiguracji jest następująca: 

  * .net 3.5
  * Ink and Handwritng support - wymagany przez środowisko pulpitu
  * Media Foundation - również wymagane
  * Remote Assistance - zdalny pulpit
  * User Interface and Infrastructure - uwaga! podrzędne desktop experience jest elementem krytyczym obsługi pulpitu, lecz nie jest domyślnie wybieranie przy zaznaczeniu tylko górnej gałęzi
  * Windows Search Service
  * Windows Server Backup. Ta funkcja poza znanym i wydajnym kopiowaniem dysków z siódemki/2009 oferuje dodatkowo półroczny trial na wersję beta Online Backup Service w usłudze Azure. 300GB za darmo robi wrażenie.
  * Wireless LAN Service – pełna obsługa WiFi
## Dźwięk

Tu powinno być najmniej problemów. Wystarczy kliknąć klawiszem podręcznym na ikonce głośnika, wybrać urządzenia do odtwarzania i w nowym oknie zatwierdzić aktywację usługi Windows Audio. Gotowe!

## Sterowniki grafiki i inne wymagane cudotwórstwo użytkownika

Po pierwsze należy pobrać sterowniki. Te z płyty dołączonej do komputera na 90% będą złe. Ale może warto spróbować? 

Jeśli nie zadziałało to trzeba pobrać. Które? Najlepiej wszystkie. Bo zapowiada się długie eksperymentowanie. Tak naprawdę powinny nam wystarczyć następujące: najnowszy producenta karty dla Win8, jeśli nie ma to dla Win7, dalej najstarszy dla Win7, najnowszy dla Visty oraz od producenta laptopa: najnowszy dla Win7/8, jakiś dla Visty. Wszystko 64-bitowe i tylko 64 bitowe, jako, że od 2008 R2 systemy Windows Server nie wydawane są w opcji 32-bit.  
Skąd ta Vista? Okazuje się, że Vista miała mniejsze restrykcje co do sterowników niż siódemka.

Teraz następny etap (oczywiście warto spróbować, czy pliki setup.exe nie pomogą, bo czasem podobno się udaje), czyli wyłączenia wymuszania podpisywania sterowników. Domyślnie Windows nawet nie raczy zasygnalizować faktu, że mu się nie chce wgrywać sterowników. Zwróci co mu się podoba, najczęściej błąd 39.  
Aktywacja trybu testowego jest dość pokrętna. Należy się dostać najpierw do bootloadera Windowsa. O ile mamy multiboot to wystarczy zrestartować, wybrać pozycję 2012, kliknąć F8 i przejść do następnego etapu. Jeśli za każdym rozruchem wita nas od razu logo systemu to należy wydać w terminalu komendę 

```
shutdown /r /o /t 0
```


System się zrestartuje i pojawi się bsod-style menu. Wybieramy tam Troubleshoot, Advanced Startup Options i zatwierdzamy kolejny restart.  
Teraz należy wybrać Disable Drivers Signing Enforcement. Voila. 

Teraz instalacja.  
Oczywiście setup.exe nadal sprawdza wersję systemu, więc zapomnijmy. Należy wejść w menedżer urządzeń – devmgmt.msc i zlokalizować naszą kartę graficzną. Może się ukrywać pod kategorią Display Adapters jako podstawowa karta Microsoft, może pod Other Devices jako Unknown Device, albo nie wiadomo gdzie. Pomocne może się okazać kliknięcie podręcznym na urządzeniu, Properties i karta Details. Z listy należy teraz wybrać Hardware Ids i poszukać w Internecie VID (Vendor ID), ew. także PID (Product ID). W moim przypadku przy szukaniu odpowiedniej wersji sterowników niezbędny okazał się REV i SUBSYSTEM.  
  
Gdy odkryjemy o które urządzenie chodzi wchodzimy do Properties, zakładka Driver. Teraz Update Driver, następnie Browse my computer for driver, next, have disk. Wskazujemy teraz katalog z rozpakowanym sterownikiem. Jeśli próbowaliśmy opcji z setup.exe to instalka Nvidii rozpakowała się już do c:\NVIDIA, ale możemy samodzielnie to zrobić używając narzędzia 7-zip. Należy zlokalizować folder z plikami .inf i pozostawić wybór taki jak jest. Windows jakimś cudem wie, w którym pliku są definicje instalacji. Jeśli nic nie jest wybrane to pozostaje nam przeszukać wszystkie pliki pod kątem naszego PID’a urządzenia – pomoże nam w tym np. FAR manager (Alt+F7, maska \*.inf, wypełniamy pole zawartość) lub Notepad++ (otwórz plik \*.inf, Ctrl+F, szukaj we wszystkich otwartych dokumentach). Oczywiście zalecam użycie własnego ulubionego sposobu – może to być upload na serwer Linuksowy i jakiś one liner. 

Nie da się? Tego można się spodziewać. Trzeba dokonać kilku modyfikacji w pliku, w którym znajduje się definicja naszego PID, albo i się nie znajduje. Po pierwsze należy zlokalizować wpisu podobnego do 

```
[Manufacturer]
...
%NVIDIA_A% = NVIDIA_SetA_Devices,NTamd64.6.1
...
```


Generalnie trick polega na zamienieniu wszystkich nazw NTamd64.coś na NTamd64. Wprawdzie inne strony zalecają wpis w rodzaju NTamd64.6.2.2 lub tylko NTamd64.6.2 ale nie zamierzamy publikować nigdzie tych sterowników więc nic nie wybuchnie.  
Na czym polega ta zmiana? NTamd64 definiuje każdy system NT dla 64 bitowców w standardzie AMD – Intele też się łapią, po prostu 64 bitowy standard Intela to nie używane w desktopach Itanium. Oznaczenia Itanium to intel64 lub ia64. Na pewno nie mamy Itanium bo byśmy o tym wiedzieli i system musiałby być specjalnie oznaczony – "for Itanium". Amd64 to Microsoftowy ekwiwalent dla popularnego, choć lekko niepoprawnego x64 – właściwe oznaczenie to x86_64 (wskazuje przezroczystą kompatybilność z kodem 32 bitowym).  
Kolejne cyferki to numery wersji Windows. I tak kolejno XP ma 5.1, Vista 6.0, Siódemka 6.1, a ósemka 6.2. Ostatni numer jest dość rzadko wykorzystywany – 1 definiuje desktop, a 2 Server w ramach par (Win7 i 2008 R2, czy Win8 i 2012). Wystarczy wykasować informacje definiujące wersje i gotowe. Dla pewności warto podmienić wszystkie wpisy, ale trzeba zacząć od wpisu dla Win7 (ew. 8) jako najbliższej wersji. 

Wciąż się nie da? U mnie problem polegał na tym, że urządzenie miało inny SUBSYSTEM niż którykolwiek z wpisów w pliku inf.  
Od razu mówię: dopisanie tej zmiennej do któregoś z istniejących wpisów nie pomoże – trzeba zdefiniować jeszcze poprawny moduł sterownika. I tu potrzebne będą sterowniki producenta komputera. Znów szukanie pliku – tym razem można po SUBSYSTEM. Wpis, który nas interesuje wygląda mniej więcej tak (nagłówek, parę wpisów, i dopiero właściwa linijka):

```
[NVIDIA_SetA_Devices.NTamd64]
%NVIDIA_DEV.0A74.01% = Section010, PCI\VEN_10DE&DEV_0A74&SUBSYS_1AF21043 
```


Teraz skopiować tą linijkę i dokleić do analogicznej strefy w docelowym katalogu, przerobionej na zgodność z Win2012. 

Dalej nie działa? To źle. Zostają eksperymenty, bądź fora, choć bardzo mała jest szansa, że ktoś z identycznym jak my laptopem wpadł na szalony pomysł instalacji Win2012. W razie czego mogę spróbować pomóc mailowo, ale nic nie obiecuję. 

## Programy zewnętrzene

W uproszczeniu wszystko inne działa, ewentualnie należy wybrać tryb zgodności. Nie natrafiłem na większe kłopoty poza jednym – Office 2013 Preview. To, ze się zawiesza jest podobno winą sterowników grafiki. I dlatego warto przemodyfikować najnowsze wersje i nie męczyć się z od razu działającymi producenckimi, ale starszymi niekiedy o kilkadziesiąt wersji. 

## Konwersja na stację roboczą?

To nic trudnego. A Microsoft to ułatwił w stosunku do 2008 R2. Wszystko chyba zmierza ku temu, żeby biedni studenci mogli się cieszyć legalnym desktopowym Windowsem.  
Wszystkie modyfikacje można znaleźć na stronie www.win2012workstation.com, ale najważniejsze z nich warte są umieszczenia i tutaj.

Po pierwsze wydajność. Windows Server uważa, zresztą całkiem słusznie, że będzie używany wraz z usługami takimi jak IIS, czy MS-SQL, które działają w tle. Trochę to mało optymalne do desktopa wykorzystanie zasobów. W menu Start poszukajmy słowa performance (karta Settings), wybierzmy pierwszy wynik. I tu pole do manewru. Możemy włączyć lub wyłączyć naprawdę zasobożerne animacje (na maszynach bez karty graficznej – prawdziwych starych serwerach, gdzie każdy megabajt z tych czterech jest cenny, czy po prostu netbookach), lub w zakładce Advanced zmienić cel optymalizacji oraz rozmiar i lokalizację pliku stronicowania.

W menu Start powinien nas razić ten zielony kafelek – Sklep z aplikacjami. WTF?! Tak, mając produkcyjny serwer na którym stoi dajmy na to Sekretariat Optivum admin może sobie na dedykowanej aplikacji przeglądać Kwejka, poczytać ruskie dowcipy lub pograć w Fruit Ninja, czy Cut the Rope. Jedyne co trzeba zrobić to założyć nowe konto, bo Metro nie działa na wbudowanym koncie admina. Ale nie przeszkadza mu nie-wbudowany admin. Dziwne, ale działa.

## Podsumowanie

Windows Server 2012 dość łatwo doprowadzić do używalności jako stacja robocza. Może jesteśmy studentami i chcemy mieć legalnego Windowsa, może mamy na zbyciu firmowe licencje, albo chcemy okraść Microsoft na więcej (obecnie Standard dostępny w Dreamspark’u to 805 euro (z ograniczeniem 2 wirtualnych instancji), a Datacenter (bez ograniczeń instancyjnych) to tylko 4500 euro) to nie będzie to mordęga dopóki nie mamy dziwnej karty graficznej.