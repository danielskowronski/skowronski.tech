---
title: Przełączanie sesji użytkownika z konta administratora w Windows 8+
author: Daniel Skowroński
type: post
date: 2019-03-11T09:19:29+00:00
url: /2019/03/przelaczanie-sesji-uzytkownika-z-konta-administratora-w-windows-8/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/03/windows.png
tags:
  - windows

---
Czasem w domowym Windowsie trzeba przełączyć sesję na innego użytkownika, np. żeby upewnić się że ściąganie czy instalacja uruchomiona nie u nas poszła gładko, albo żeby podmienić komuś ustawienia np. usypiania komputera. Albo wykonać całą masę innych operacji bez wiedzy tego drugiego użytkownika, a przynajmniej bez resetowania mu hasła. Oczywiście zakładamy że posiadamy uprawnienia lokalnego administratora.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="350" height="350" src="https://blog.dsinf.net/wp-content/uploads/2019/03/windows.png" alt="" class="wp-image-1410" srcset="https://blog.dsinf.net/wp-content/uploads/2019/03/windows.png 350w, https://blog.dsinf.net/wp-content/uploads/2019/03/windows-150x150.png 150w, https://blog.dsinf.net/wp-content/uploads/2019/03/windows-300x300.png 300w" sizes="(max-width: 350px) 100vw, 350px" /> </figure> 

Windows Server z usługami terminalowymi problem rozwiązuje dosyć prosto:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">C:\Users\Daniel>query user
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>daniel                console             1  Active         16  10.03.2019 12:53
 otheruser                                 2  Disc           16  10.03.2019 21:44

C:\Users\Daniel>Mstsc.exe /shadow:2

C:\Users\Daniel></pre>

Na desktopowej wersji dostaniemy komunikat o tym że sasja numer 2 jest niepodłączona. Ale jest na to sposób wymagający jedynie [narzędzi SysInternals][1] od Microsoftu (można wypakować pobranego zipa do c:\windows\system32). Z prompta administratora uruchamiamy:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">PsExec.exe -i -s taskmgr</pre>

i w nowo odpalonym Menedżerze Zadań przechodzimy do karty _Użytkownicy_, prawoklik na docelowym użytkowniku i _Połącz_.

Bez uruchomienia z flagą -s Windows zażądałby od nas hasła docelowego użytkownika.

Powrót wymaga klasycznego windowsowego "przełącz konto" z menu start lub... odpalenia kolejnego taskmgr jako system (z PsExec), ale tak czy inaczej będziemy musieli podać nasze hasło.

 [1]: https://docs.microsoft.com/en-us/sysinternals/downloads/psexec