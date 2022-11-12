---
title: Brak pliku c:\Windows\System32\config\systemprofile\…
author: Daniel Skowroński
type: post
date: 2015-12-30T20:04:04+00:00
url: /2015/12/brak-pliku-cwindowssystem32configsystemprofile/
tags:
  - windows

---
Brak pliku <span class="lang:default EnlighterJSRAW  crayon-inline " >c:\Windows\System32\config\systemprofile\.ssh\id_rsa</span> zgłosił mi serwer Continous Integration (konkretniej TeamCity, swoją drogą naprawdę fajny) podczas próby deploymentu po SSH. Dziwna ścieżka jest spowodowana faktem, że serwer chodzi jako usługa systemowa odpalana przez "NTAUTHORITY\SYSTEM" a jego katalog domowy jest w c:\windows. Plik rzecz jasna tam był. 

Po długim poszukiwaniu okazało się, że jeśli usługa jest 64-bitowa to ścieżka jest fake'owana i tak naprawdę prowadzi do <span class="lang:default EnlighterJSRAW  crayon-inline " >c:\Windows\SysWOW64\config\systemprofile\...</span> (**SysWOW64** zamiast **System32**), jednak w logach nie widać dokąd naprawdę następuje odwołanie. 

Wgranie plików tamże rozwiązuje problem.