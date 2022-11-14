---
title: Instalacja Windows Server na dysku sieciowym iSCSI
author: Daniel Skowroński
type: post
date: 2016-02-05T17:22:00+00:00
excerpt: Bezdyskowe stacje robocze mają wiele zalet w środowiskach, gdzie mamy wiele stacji roboczych, które mają posiadać jeden zestaw plików udostępniając jedynie zapamiętywanie profilu nieuprawnionego użytkownika. Procedura nie jest skomplikowano, lecz nie poświęcono jej wiele artykułów stąd opisuję najprostszą wersję, by mieć od czego zacząć i potem dokładać kolejne składniki.
url: /2016/02/instalacja-windows-server-na-dysku-sieciowym-iscsi/
tags:
  - boot
  - iSCSI
  - windows

---
Bezdyskowe stacje robocze mają wiele zalet w środowiskach, gdzie mamy wiele stacji roboczych, które mają posiadać jeden zestaw plików udostępniając jedynie zapamiętywanie profilu nieuprawnionego użytkownika. Procedura nie jest skomplikowano, lecz nie poświęcono jej wiele artykułów stąd opisuję najprostszą wersję, by mieć od czego zacząć i potem dokładać kolejne składniki.

**Wymagania wstępne:**  
1) serwer iSCSI (np. starwind) - będzie potrzebny na produkcji - udostępnia dysk  
2) serwer PXE (np. tinypxe) - będzie potrzebny na produkcji - za każdym rozruchem montuje dysk  
3) serwer udziałów samby (np. zwykły windows) - służy do udostępniania zawartość ISO instalacyjnego - powinien stać w tej samej sieci  
4) serwer HTTP (np. apache) - może to być też produkcyjny serwer WWW bo w gruncie rzeczy służy tylko do ładowania WinPE podczas instalacji

**Procedura instalacji systemu:**  
1) W starwindo tworzymy cel i konkretny dysk iSCSI, zapisując sobie jego IQN  
2) Odpalamy TinyPXE,  
- definiujemy konfig sieci Option 54 - ustawiamy adres IP serwera rozruchu (nasz), definiujemy pulę adresów dostępnych, Option 1,3,6, i 28 przepisujemy z konfigu naszej sieci macierzystej,  
- bootfile ustawiamy na ipxe.kpxe,  
- Option 17 to rootpath dysku iSCSI - jest formatu: `iscsi:ADRES_IP:PROTO:PORT:LUN_NUM:IQN ` np. `iscsi:192.168.1.160:tcp:3260:0:iqn.ovh.ksi:eregion-winsrv` ,  
- Extra Option: `175.6.1.1.1.8.1.1` ([wyjaśnienie][1])  
3) Na udział windowsowy (samby) wypakowywujemy całe ISO instalacyjne (np. za pomocą 7zip'a)  
4) Na serwer HTTP wgrywamy [paczkę z wimbootem WinPE][2] (polecam krótkie URLe bo będziemy to wpisywać z palca) i plikiem boot.ipxe postaci:

```
sanhook -d 0x80 ADRES_ISCSI
set keep-san 1
cpuid --ext 29 && set arch amd64 || set arch x86
kernel wimboot
initrd ${arch}/media/bootmgr                      bootmgr
initrd ${arch}/media/Boot/BCD                     BCD
initrd ${arch}/media/Boot/boot.sdi                boot.sdi
initrd ${arch}/media/sources/boot.wim             boot.wim
boot
```

5) Bootujemy komputer wzorcowy po sieci, powinien wykryć poprawnie dysk SAN i zasugerować wciśnięcie Ctrl+B aby przejść do konsoli bo na czystym dysku nie ma jeszcze MBR. Tak czynimy i wykonujemy chainload na WinPE po HTTP komendą `chain http://DOMENA/ścieżka/boot.ipxe`. Jeśli sypią się błędy warto wywołać polecenie `dhcp`, które odnowi połączenie i spróbować ponownie.  
6) Po chwili załaduje nam się środowisko WinPE, w którym montujemy stworzony w kroku 3 udział komendą: net use d: \\ADRES_IP\udział\ścieżka  
7) Po zamontowaniu przecghodzimy do dysku (udaje on CDROM) i uruchamiamy setup.exe  
8) Instalacja windowsa przebiega dalej tak jak normalna z DVD na zwykły HDD.

**Działanie:**  
Po instalacji nie musimy chainloadować się do WinPE, TinyPXE samo bootuje dysk SAN i tym samym Windowsa. Voilà.

**Wariant drugi<sup>aktualizacja</sup>**  
Niektóre karty sieciowe nie wspierają bootowania po iSCSI (np. Intel I217-V w odróżnieniu od wersji "serwerowej" z końcówką -LM) i wtedy trzeba zaaktywować programowy inicjalizator iSCSI + zmienić kolejność ładowania usług związanych ze sterownikami sieci. Najprościej jest to uczynić isntalując na jednej maszynie system na dysku twardym, uruchomić tam `iscsicpl`, zaakcpetować autostart tej usługi i zmienić w rejestrze klucz typu REG_DWORD `HKLM\SYSTEM\*ControlSet*\Services\<nazwa_usługi>\Start` na 0 (\*ControlSet\* => CurrentControlSet, ControlSet001, ControlSet002, ...). Nazwą usługi dla wspomnianej karty intela będzie to coś w stylu `e1dexpress`.  
Teraz można skopiować zawartość dysku (w stylu unixowego dd - całość bajt po bajcie) na macierz iSCSI (może być konieczne zainicjalizowanie dysku przez `diskmgmt.msc`) - Macrium Reflect okazał się całkiem sprawny pod Windowsem.

**Powolne działanie:**  
Jeśli komputer bardzo wolno się podnosi i ma UEFI to trzeba zastosować [hotfix od MS][3].

 [1]: http://sourceforge.net/p/etherboot/mailman/message/23632640/
 [2]: https://mega.nz/#!ahEgSLYa!WbYWVBYMEmgkxcSguZTIX53jdB_nyxXt9ghMFuyH1vg
 [3]: https://support.microsoft.com/en-us/kb/2974735