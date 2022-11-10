---
title: Odtwarzanie backupu MSSQL ze zdalnego serwera po sieci
author: Daniel Skowroński
type: post
date: 2019-12-05T17:50:28+00:00
excerpt: |
  |
    MSSQL pozwala odtwarzać bazy danych z plików bak za pomocą kwerendy RESTORE DATABASE w TSQL lub zgrabniejszego cmdletu PowerShella Restore-SqlDatabase. Sęk w tym, iż ścieżka przekazywana jest relatywna dla samego silnika bazy danych i konetkstu użytkownika, który ją uruchamia.
    
    Błąd w rozumowaniu objawia się takim komunikatem podczas próby odtwarzania backupu: Msg 3201, Level 16 Cannot open backup device. Operating system error 5(Access is denied.)
url: /2019/12/odtwarzanie-backupu-mssql-ze-zdalnego-serwera-po-sieci/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/12/mssql-1.png
tags:
  - mssql
  - network
  - windows

---
MSSQL pozwala odtwarzać bazy danych z plików bak za pomocą kwerendy **RESTORE DATABASE** w TSQL lub zgrabniejszego cmdletu PowerShella **Restore-SqlDatabase**. Sęk w tym, iż ścieżka przekazywana jest relatywna dla samego silnika bazy danych i konetkstu użytkownika, który ją uruchamia &#8211; co na przykład oznacza że zamapowany na koncie operatora dysk sieciowy nie będzie dostępny.

Błąd w rozumowaniu objawia się takim komunikatem podczas próby odtwarzania backupu: **_Msg 3201, Level 16 Cannot open backup device. Operating system error 5(Access is denied.)_** 

Jest to oczywiste jeśli pracujemy na przykład w SQL Server Management Studio, ale `sqlcmd.exe` i `Restore-SqlDatabase` bardzo przypominają unixowe podejście sugerujące że plik jest odczytywany lokalnie. 

Posiłkując się [dokumentacją cmdletu Restore-SqlDatabase][1] można by zatem podstawić wartość parametru `-BackupFile` jako ścieżkę sieciową w rodzaju `\\sever\\d$\backups\db.bak`, ale w wielu domyślnych setupach nie jest to możliwe.

Żeby zdebugować tą sytuację pomocna jest [pewna odpowiedź na StackOverflow][2], która rozbija dostęp do zasobu sieciowego na mapowanie. Jeśli dostaniemy `System error 53 has occurred. The network path was not found.` to najprawdopodbniej znaczy iż polityki grupowe windowsa są rozsądnie restrykcyjne (pewnym hintemjest pozycja z gpedita `Network Security: Restrict NTLM: Outgoing NTLM traffic to remote servers`, do której odniesienie znalazłem [na technecie][3]). 

<div class="wp-block-image">
  <figure class="aligncenter size-large"><a href="https://blog.dsinf.net/wp-content/uploads/2019/12/sql.png"><img decoding="async" loading="lazy" width="413" height="417" src="https://blog.dsinf.net/wp-content/uploads/2019/12/sql.png" alt="" class="wp-image-1594" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/sql.png 413w, https://blog.dsinf.net/wp-content/uploads/2019/12/sql-150x150.png 150w, https://blog.dsinf.net/wp-content/uploads/2019/12/sql-297x300.png 297w" sizes="(max-width: 413px) 100vw, 413px" /></a><figcaption>Error 53 podczas debugowania niedostępności ścieżki</figcaption></figure>
</div>

Jednak istnieje obejście problemu &#8211; ticket kerberosowy i samo montowanie można obsłużyć z poziomu uzytkownika SYSTEM. Brzmi groźnie, ale jest nawet bezpieczne.

Potrzebny do tego jest **psexec** z pakietu PsTools od Microsoft Sysinternals (https://docs.microsoft.com/en-us/sysinternals/downloads/psexec). Jeśli zamapujemy dysk sieciowy z poziomu SYSTEMu to będzie on widoczny dla każdego użytkownika &#8211; także specjalnych kont serwisowych, które nie mają uprawnień do logowania, ale w kontekście tychże użytkowników. Zatem wystarczy zapewnić uprawnienia do udziału sieciowego dla silnika bazy danych i można samo wywołanie Restore-SqlDatabase opakować mapowaniem, jednocześnie nie martwiąc się że inny użytkownik będzie miał dostęp do czegoś czego nie powinien. Każdy użytkownik zobaczy &#8222;Disconnected Network Drive&#8221; na liście &#8222;Network Locations&#8221;, ale będzie on dostępny dla posiadających uprawnienia do oczytu zdalnej ścieżki, reszta dostanie &#8222;permission denied&#8221;. 

<div class="wp-block-image">
  <figure class="aligncenter size-large"><a href="https://blog.dsinf.net/wp-content/uploads/2019/12/drive_s.png"><img decoding="async" loading="lazy" width="1023" height="610" src="https://blog.dsinf.net/wp-content/uploads/2019/12/drive_s.png" alt="" class="wp-image-1593" srcset="https://blog.dsinf.net/wp-content/uploads/2019/12/drive_s.png 1023w, https://blog.dsinf.net/wp-content/uploads/2019/12/drive_s-300x179.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/12/drive_s-768x458.png 768w" sizes="(max-width: 1023px) 100vw, 1023px" /></a><figcaption>Dysk S jest dyskiem zamontowany z konta SYSTEM, widok z konta lokalnego administratora</figcaption></figure>
</div>

Przykładowo restore dancyh ze wstępu można to zrobić tak (przekierowanie do nulla jest potrzebne bo psexec nie za bardzo umie komunikować sukces):

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">C:\pstools\psexec.exe -s cmd /c "net use S: \\OTHER_DB_SERVER\d$\backups"  | out-null 

Restore-SqlDatabase -ReplaceDatabase -BackupFile S:\SOME_BACKUP_FILE.BAK -Database SOME_DB -ServerInstance SOME_DB_SERVER -RestoreAction Database

C:\pstools\psexec.exe -s cmd /c "net use s: /delete"  | out-null</pre>

 [1]: https://docs.microsoft.com/en-us/powershell/module/sqlserver/restore-sqldatabase?view=sqlserver-ps
 [2]: https://stackoverflow.com/a/20465401/12297075
 [3]: https://social.technet.microsoft.com/Forums/en-US/8c7158ab-cccf-4dd2-a65f-ff4aad0448a8/error-mapping-admin-share-by-ip-system-error-53-has-occurred-the-network-path-was-not-found-dns?forum=winserver8gen