---
title: DRAC5 – "Error when reading from SSL socket connection"
author: Daniel Skowroński
type: post
date: 2015-08-28T10:25:04+00:00
excerpt: 'Karta zdalnego zarządzania od Della - DRAC5 stosowana m.in. w PowerEdge 1950 jest tak stara jak sam serwer. Serwer dalej chodzi, ale koncepcje bezpieczeństwa - już nie. Kiedy spróbujemy się podłączyć ze zaktualizowanego hosta do zdalnego sterowania (console redirection), albo menadżera nośników wirtualnych (virtual media) wyskoczy nam komunikat z maszyny wirtualnej Javy "Error when reading from SSL socket connection". Winny jest pudel (a dokładniej POODLE).'
url: /2015/08/drac5-error-when-reading-from-ssl-socket-connection/
tags:
  - dell
  - drac5
  - java
  - security
  - serwer
  - sslv3

---
Karta zdalnego zarządzania od Della - DRAC5 stosowana m.in. w PowerEdge 1950 jest tak stara jak sam serwer. Serwer dalej chodzi, ale koncepcje bezpieczeństwa - już nie. Kiedy spróbujemy się podłączyć ze zaktualizowanego hosta do zdalnego sterowania (console redirection), albo menadżera nośników wirtualnych (virtual media) wyskoczy nam komunikat z maszyny wirtualnej Javy "Error when reading from SSL socket connection". Winny jest pudel (a dokładniej POODLE).

Sprawę, że ten aplet w ogóle się nie uruchomi na nowej Javie rozwiązuje [paragraf w innym moim artykule][1].

W związku z ubiegłoroczną dziurą w SSLv3 Oracle postanowił po jakimś czasie wyłączyć ten protokół - patrz [komunikat na ich stronie][2]. Niestety nawet najnowsza wersja firmware'u DRACa piątki - 1.65 A00 nie przewiduje innego protokołu komunikacji. [Bez znaczenia jest też jeśli używamy wbudowanego certyfikatu ważnego na okres 2005-2010 - klient nie sprawdza tego!]

Jedyną opcją jest globalne włączenie protokołu - mało bezpieczne, ale innej opcji nie ma.  
Szukamy pod Linuksem pliku <span class="lang:default EnlighterJSRAW  crayon-inline " >/usr/lib/jvm/*/jre/lib/security/java.security</span> lub pod Windowsem <span class="lang:default EnlighterJSRAW  crayon-inline " >C:\Program Files (x86)\Java\jre1.8.0_60\lib\security\java.security</span> i tamże linijki <span class="lang:default EnlighterJSRAW  crayon-inline " >jdk.tls.disabledAlgorithms=</span> - nie wystarczy skasować zapisu SSLv3, ale także trzeba zaniżyć _DH Key Size_ i usunąć RC4 - słowem zakomentować całą linijkę. 

Kiedyś dało się to zrobić przez GUI. Liczmy na to, że i z konfiga plikowego tego nie usuną.

DRAC5 jest zbyt przydatny, żeby uznawać argument o małym bezpieczeństwie jeśli używa się tak starej maszyny. Najlepiej jednak po użyciu przywrócić wyłączenie tych protokołów i nie łączyć się do DRACa z innych produkcyjnych serwerów. Szkoda jednak, że Dell nie zrobił aktualizacji, no ale jest serwer ma obecnie 10 lat!

Dokumentacja DELLa dot. bezpieczeństwa tych kart - <http://www.dell.com/downloads/global/solutions/DellRemoteAccessController5Security.Pdf>

 [1]: /2014/11/ciecie-skanow-pod-kindle/#JavaWylaczanieBezpieczenstwa
 [2]: http://www.oracle.com/technetwork/java/javase/documentation/cve-2014-3566-2342133.html