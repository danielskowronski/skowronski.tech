---
title: 'Windows 8: aktualizacja RP do RTM aka eval. Niestety się nie da.'
author: Daniel Skowroński
type: post
date: 2012-08-19T22:48:49+00:00
url: /2012/08/windows-8-aktualizacja-rp-do-rtm-aka-eval-niestety-sie-nie-da/
tags:
  - windows
  - windows 8

---
Powodowany głównie ciekawością pobrałem ponad trzygigabajtowe iso Windowsa 8 RTM. Jak zawsze na świeżą instalację nie miałem czasu, więc chciałem dokonać aktualizacji.  
Niby to powinno być proste, ale MS jakoś nie lubi aktualizować wersji Preview swoich systemów (chyba po to, żeby nie korzystać z nich jako podstawowych i nie dawać możliwości posiadania legalnego i aktualnego systemu przez rok). 

Zrobiwszy backup odpaliłem setup.exe, który otrzymał obrzydliwy kolorek w okolicach fioletu. Niestety aktualizator uparł się, że wersji Release Preview aktualizować się nie da. Spróbowałem nawet trybu zgodności 😉  
Wujek google mi nie pomógł &#8211; w sieci krąży opis takiej aktualizacji, ale jest on kopią procesu z Win7. Tam trzeba było podmienić numer minimalnej kompilacji. **Ta metoda po prostu nie działa**.  
To wygląda mi na trolla, bo słowo w słowo przepisana jest na kilka podrzędnych for i wszędzie dostaje pozytywne komentarze, poza jednym. 

Po długich analizach i porównaniach z poprzednini wydaniami mogę stwierdzić, że **aktualizacja z Win8 RP jest niemożliwa**.  
A to za sprawą nowego modelu licencjonowania (eval), który jest nieaktualizowalny i złośliwy w kwestii ajtywacji (automatyczne wyłączenie co godzinę po 90 dniach itp.).

Jest metoda brutalna, ale nie warta zachodu, bo lepiej poczekać na wersję box (albo TPB): gdyby zmienić info o rodzinie systemu z eval na prev w pliku ei.cfg, oraz zmodyfikować plik install.wim, który zawiera obraz systemu, tak by w jego nagłówku była info o innej wersji to mając dodatkowo poprawny klucz (chyba, że wybity jest w binarkę, ale zmiana rodziny prawdopodobnie zdezaktywowałaby go) to można by dokonać upgrade&#8217;u.