---
title: SFTP na Windows
author: Daniel Skowroński
type: post
date: 2016-03-25T21:10:13+00:00
summary: |
  Może to i niestandardowe wymaganie, ale czasem i na Windowsie potrzeba SFTP - czyli transferu plików po SSH - pewniejsze, bardziej niezawodne i bezpieczne od FTP. No i autoryzacja po kluczu zamiast hasła...
  Porównanie Micorosftowego forka OpenSSH i Cerberusa.
url: /2016/03/sftp-na-windows/
tags:
  - sftp
  - ssh
  - windows

---
Może to i niestandardowe wymaganie, ale czasem i na Windowsie potrzeba SFTP - czyli transferu plików po SSH - pewniejsze, bardziej niezawodne i bezpieczne od FTP. No i autoryzacja po kluczu zamiast hasła...

Microsoft w ramach wpychania Linuksa do Windowsa popełnił własny build OpenSSH (<https://github.com/PowerShell/Win32-OpenSSH/>), który działa poza cygwinem i mingw. Chociaż działa to póki co za duże słowo - SSH niby działa (chociaż emulacja terminala działa tak tragicznie, że putty łącząc się do windowsa może przez backspace kasować prompta, odpalenie powershella po ssh zawiesza sesję, a kliencka binarka nie supportuje kolorów ani UTF-a...), sam serwer plików niby też (swoją drogą z dość nowatorskim sposobem pokazywania ścieżek do dysków - /c**:**/ścieżka - w cygwinie jest /c/ścieżka), ale jest dość mocno ograniczony. Brakuje wsparcia dla chroota (jeden z issues na githubie stwierdza to wprost), crashuje się, by default loguje bardzo gadatliwie masę informacji na dysk i w ogóle mało produkcyjnie. Chociaż warto spróbować jako narzędzie administracyjne (nie do współdzielenia plików) bo jest w pełni standalone i dostępny przez chocolatey - pakiet _win32-openssh._

Po poddaniu MSowego rozwiązania testowałem kilka rozwiązań zewnętrznych - m.in. freeSSHd, aż trafiłem na [Cerberus][1]a - ma _wszystko_. Jest to jednak w pełni wirtualna nakładka - sztuczni (choć integrowalni z systemem) użytkownicy/grupy, władne reguły uprawnień do chrootowanego systemu plików etc. W dłuższych testach sprawdził się całkiem nieźle (zużywa też znikomą ilość zasobów). Warto dodać, że Cerberus obsługuje nie tylko SFTP ale także FTP i FTPS (FTP z SSL) i ma nawet webowe GUI. Darmowy do zastosowań domowych, do firmy wart rozważenia jeśli naprawdę jest potrzebny (a może z powodzeniem zastępować IISowego FTPa).

Mamy jeszcze Cygwinowego OpenSSH - ale wymaga to pobawienia się w zależności, jest to rozwiązanie nie-natywne, czasem zawodne, nie integruje się z Powershellem... Jeśli sięgać po cygwina to prędzej postawiłbym cały serwer na Linuksie i tam wykorzystał pełnię możliwości.

Reasumując: MSowy OpenSSH dopiero startuje, choć jako dodatek do RDP jest całkiem ciekawy (i w pełni współgra z windowsowym mechanizmem uprawnień), natomiast Cerberus umożliwia udostępnianie systemu plików wirtualnym użytkownikom po "linuksowemu" choć dzięki nakładkowości zyskujemy bezpieczeństwo urywając użytkownikom rączki i nóżki żeby nie grzebali gdzie nie chcemy i na pewno nie odpalili shella.

 [1]: http://www.cerberusftp.com/download/