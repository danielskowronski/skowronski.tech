---
title: Problem z instalacją .NET 4.0 podczas instalacji SQL Servera na Windows Server 2008 R2
author: Daniel Skowroński
type: post
date: 2015-11-15T16:55:24+00:00
summary: 'Na problem natknąłem się przy okazji isntalacji SQL Servera 2012 - instalator w logach - `%programfiles%\Microsoft SQL Server\130\Setup Bootstrap\Log\Summary_<host>_<data>_<godzina>.log"`  zgłaszał exit code 1 dla .NET 4 (jest wymaganą zależnością). Kilka prób instalacji osobno, bowiem w setup SQL Server wbudowany jest już instalator, (wersja offline, online, 23 bity, 64 bity itp.) zawiodło...'
url: /2015/11/problem-z-instalacja-net-4-0-podczas-instalacji-sql-servera-na-windows-server-2008-r2/
tags:
  - .net
  - sql server
  - windows
  - windows server

---
Na problem natknąłem się przy okazji isntalacji SQL Servera 2012 - instalator w logach - `%programfiles%\Microsoft SQL Server\130\Setup Bootstrap\Log\Summary_<host>_<data>_<godzina>.log"`  zgłaszał exit code 1 dla .NET 4 (jest wymaganą zależnością). Kilka prób instalacji osobno, bowiem w setup SQL Server wbudowany jest już instalator, (wersja offline, online, 23 bity, 64 bity itp.) zawiodło.

Błąd dokładnie jest następujący:

```
Detailed results:
  Feature:                       Database Engine Services
  Status:                        Failed: see logs for details
  Reason for failure:            An error occurred for a dependency of the feature causing the setup process for the feature to fail.
  Next Step:                     Use the following information to resolve the error, and then try the setup process again.
  Component name:                Microsoft .NET Framework 4.0
  Component error code:          1
  Component log file:            c:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\Log\20151115_171900\DotNetCore_Cpu64_1.log
  Error description:             Microsoft .NET Framework 4.0 installation has failed with exit code 1.
  Error help link:               http://go.microsoft.com/fwlink?LinkId=20476&ProdName=Microsoft+SQL+Server&EvtSrc=setup.rll&EvtID=50000&ProdVer=11.0.2100.60&EvtType=DotNetCore%40Install%400x1
```


Rozwiąnie lekko na około, ale działające - instalacja .NET 4.5 która zawiera pliki dla 4.0 np. z [serwerów Microsoftu][1]. Wówczas instalator SQL Servera wykryje, że 4.0 jest już zainstalowane i wszystko będzie OK.

 [1]: http://www.microsoft.com/pl-pl/download/details.aspx?id=30653