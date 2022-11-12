---
title: TrueCrypt – NSA wsadziło swoje łapska i tu?
author: Daniel Skowroński
type: post
date: 2013-10-22T00:01:58+00:00
excerpt: |
  TrueCrypt zyskał popularność głównie dzięki łatwości używania, przenośności i funkcjonalności - przeciętny script-kiddie używający Windowsa, czy nawet Mac OS może zaszyfrować hasła do botnetu na karcie SD i w razie nalotu miłych panów z Agencji Budzenia Wczesnoporannego dać im hasło, ale do innej części karty. I to wszystko może sobie wyklikać (!)
  Jak wiemy NSA próbuje wejść wszędzie gdzie się da - reakcja Linusa na pytanie o NSA na ostatniej LinuxCon, czy zaszyty backdoor w kodzie jądra to potwierdzają. Dlaczego nie mieliby się zainteresować oprogramowaniem niemal tak samo strategicznym?
url: /2013/10/truecrypt-nsa-wsadzilo-swoje-lapska-i-tu/
tags:
  - backdoor
  - nsa
  - security

---
TrueCrypt zyskał popularność głównie dzięki łatwości używania, przenośności i funkcjonalności - przeciętny script-kiddie używający Windowsa, czy nawet Mac OS może zaszyfrować hasła do botnetu na karcie SD i w razie nalotu miłych panów z Agencji Budzenia Wczesnoporannego dać im hasło, ale do innej części karty. I to wszystko może sobie wyklikać (!)  
Jak wiemy NSA próbuje wejść wszędzie gdzie się da - reakcja Linusa na pytanie o NSA na ostatniej LinuxCon, czy zaszyty backdoor w kodzie jądra to potwierdzają. Dlaczego nie mieliby się zainteresować oprogramowaniem niemal tak samo strategicznym?

**Zaufanie do kodu, nie do serwowanych binarek**  
TrueCrypt jest jak wiadomo oprogramowaniem open-source. Kod pod każdą platformę przejrzeć może każdy - dziwne rzeczy w rodzaju pojedynczego = zamiast podwójnego == łatwo wychwycić. Jednak jeden z researcherów skompilował swoją kopię z kodu źródłowego. Jak się okazało plik wynikowy różnił się od dostępnego do pobrania EXE dla Windowsa. Autor wyczerpujące analizy dostępnej [tutaj][1] zauważył podejrzany segment kodu o którym wiadomo jedyne, że zapisuje pewne niezrozumiałe bajty w zaszyfrowanych danych.  
Czy może umieszczać backdoora używając spreparowanego klucza szyfrującego? Jasne, że może.  
Sprawa wydaje się być poważniejsza, gdyż z anonimowymi twórcami TC nie można się skontaktować. Ich strona wprost [zaprzecza][2] sugestiom o backdoorze. Gdzie indziej używają doniesienia o porażce FBI przy próbie złamania hasła.

**Społeczność kontratakuje**  
W sieci powstał projekt [IsTrueCryptAuditedYet?][3], który ma na celu zbiórkę pieniędzy na międzu innymi profesjonalny audyt dla TC - jest to zbyt męczące zadanie dla nawet profesjonalnych hackerów. Poza tym: w tak palącej i istotnej dla bezpieczeństwa wielu osób sprawie lepiej nie polegać na społeczności, ale na zaufanych osobach. Z zebranych pieniędzy jego twórca, Kenn White, planuje certyfikować wydania binarne oraz wprowadzić program bug-bounty.  
Projekt można wesprzeć na [Indiegogo][4] - celem jest 25 tysięcy dolarów w dwa miesiące.

**Jak żyć?**  
Po pierwsze ściągniętym binariom nie mamy jak ufać - nie dość, że serwer może zostać przejęty, a instalki podmienione na zainfekowane to co gorsza nie mamy kontroli na tym, czy plik został skompilowany z deklarowanych źródeł. O ile to możliwe najlepiej pobrać kod źródłowy, sprawdzić sumy kontrolne (a jeszcze lepiej podpis PGP) i własnoręcznie skompilować program.  
Po drugie sama dokumentacja TrueCrypta przypomina, że nie jest on w stanie w pełni zabezpieczyć danych - keyloggery sprzętowe lub malware czyhają na każdego. A służby bezpieczeństwa mogą po prostu odzyskać klucz z RAMu schładzając go. Zawsze należy zachowywać dobre praktyki związane z bezpieczeństwem: od niezapisywania hasła na kartce po uruchamianie TrueCrypta w środowisku kontrolowanym. O hasłach lepszych od admin1 nie wspominając 😉

Artykuł pojawia się z opóźnieniem z powodu tymczasowego utajnienia jego treśc przez autora.

 [1]: http://blog.cryptographyengineering.com/2013/10/lets-audit-truecrypt.html
 [2]: http://www.truecrypt.org/contact-forms/lost-vol-password
 [3]: http://istruecryptauditedyet.com/
 [4]: http://www.indiegogo.com/projects/the-truecrypt-audit