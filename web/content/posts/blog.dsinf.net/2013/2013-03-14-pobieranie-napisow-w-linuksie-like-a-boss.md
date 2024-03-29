---
title: Pobieranie napisów w Linuksie – like a boss.
author: Daniel Skowroński
type: post
date: 2013-03-14T21:35:26+00:00
url: /2013/03/pobieranie-napisow-w-linuksie-like-a-boss/
tags:
  - linux

---
Windowsowcy mają swoją aplikacyjkę z reklamami od autorów projektu Napiprojekt.pl. Na Linuksie są dwa pakiety - Gnapi i Qnapi. Oba pobierają napisy z napiprojektu i opensubitles.<!--break-->

  
Osobiście wolę wersję Q, gdyż jest nowsza [aż o miesiąc ;)] i prostsza. Do pobrania stąd: http://sourceforge.net/projects/qnapi/  
Pewna dość istotna uwaga: parametr plikowy (bowiem Qnapi pracuje tylko w trybie wiersza poleceń - GUI służy jedynie do ustawień oraz pokazywania ew. paska postępu wyszukiwania) musi posiadać ścieżkę bezwzgledną! Podanie ot tak nazwy pliku się nie powiedzie, a złośliwy program nie powie jakiego pliku nie ma tylko, że w ogóle nie ma. 

Terminal terminalem, ale w GUI też by wypadało jakoś wmontować pobieranie napisów. Na Gnome w menedżerze Nautilus można to zrobić za pomocą pakietu  
**nautilus-actions** dostępnego w zdecydowanej wiekszości dystrybucji z głównego repozytorium (nawet w openSUSE). Po instalacji uruchamiamy program nautilus-actions-config-tool (jest oczywiście także w menu gdzieś) i dodajemy nową akcję.  
Kilka słów wyjaśnienia bo jest to narzędzie lekko nastawione na niepowodzenie za pierwszym podejściem. Otóż w karcie _Action_ należy zachaczyć pierwsze dwie opcje dotyczące wyświetlania wpisu. W tym samym miejscu wypada też wybrać ikonkę, żeby był porządek (z listy lub z katalogu /usr/share/icons - tam powinny być wszystkie ikony programów). Karta _Command_ opisana jest bardzo dobrze - na szybko warto zauważyć, że parametr jaki podamy w 99% akcji zawiera **%F** - czyli liestę ścieżek plików rozdzieloną spacjami, czyli tak jak tego oczekuje większość programów. Interesująca jest karta _Mimetypes_: można wybrać jakie pliki nas interesują - w końcu ciężko ściągnąć napisy do instalatora VMware, czyż nie? Jedynym słusznym miejscem gdzie znajdziemy opis listy mime jest http://www.iana.org/assignments/media-types. Oczywiście możemy wyfiltrować rodzaj plików po nazwach czy katalogach. Ostatnia karta, czyli _Properties_ zawiera najważneijszą opcję - _Enabled_.  
Poza skonfigurowaniem wpisu trzeba jeszcze wyświetlić menu kontekstowe. Wchodzimy w tym celu w _Edit/Preferences_ i w kartę _Runtime Preferences_. Należy tutaj rozważyć dwie ostatnie pozycje dotyczące tworzenia gałęzi zbiorczej dla naszych wpisów i dodawanie pozycji _About..._ do niego.  
Jeśli w Nautilusie nie widać nic ubijmy wszystko

```bash
killall nautilus
```


i uruchommy od nowa menedżer plików.

Nie zapomniałem rzecz jasna o KDE. Tu sprawa jest inna - nie ma edytorka - tylko pliki. Dla lokalnego menu (bieżący użytkownik) będzie to katalog w rodzaju ~/.kde/share/kde4/services/ServiceMenus, a globalny - /usr/share/kde4/services/ServiceMenus.  
W pliku należy dopisać coś w rodzaju:

```bash
[Desktop Action qnapi_napisy]
Exec=qnapi "%F"
Name=Pobierz napisy z QNapi
MimeType=video/.*;
Icon=/usr/share/icons/qnapi-48.png

```


Powinno zadziałać, ewentualny restart powłoki się zawsze przyda.



źródło: [http://forum.kde.org/viewtopic.php?f=16&t=10667](http://forum.kde.org/viewtopic.php?f=16&t=10667)

źródło: [http://techthrob.com/2009/03/02/howto-add-items-to-the-right-click-menu-in-nautilus/](http://techthrob.com/2009/03/02/howto-add-items-to-the-right-click-menu-in-nautilus/)
