---
title: Ostateczne ominięcie Program Compatibility Assistant w Windows 8.1
author: Daniel Skowroński
type: post
date: 2013-08-01T15:35:05+00:00
url: /2013/08/ostateczne-ominiecie-program-compatibility-assistant-w-windows-8-1/
tags:
  - program compatibility assistant
  - windows
  - windows 8.1

---
W najnowszej wersji beta Windowsa &#8211; 8.1 i 2012 R2 Program Compatibility Assistant stał się jeszcze bardziej denerwujący, uniemożliwiając uruchomienie niezgodnych aplikacji. Ponadto nie da się go wyłączyć przez rejestr ani edytor zasad grupy.  
<!--break-->

Wszystko za sprawą przyjęcia nowego modelu obsługi zgodności (http://msdn.microsoft.com/en-us/library/dn302074%28v=vs.85%29.aspx). Można na siłę zmieniać ustawienia w <u>gpedit.msc</u> &#8211; _Computer configuration_ -> _Administrative Templates_ -> _Windows Components_ -> _Application Compatibility_ &#8211; tam _Turn off App Compatibility Engine_ i _Turn off Program Compatibility Assistant_ w siódemce wystarczyło przestawić na _Enabled_. Ale programiści tej wersji zostawili opcję bez połączenia z jądrem. No cóż.

Po długim śledztwie w systemie znalazłem kilka usług, które są odpowiedzialne za zgodność aplikacji, ale ich dezaktywacja nic nie zmienia (a czasem unieruchamia system). W końcu jednak doszukałem się plików, które mają coś wspólnego tymi usługami &#8211; 

<pre class="EnlighterJSRAWbash">c:\Windows\AppPatch\sysmain.sdb
c:\Windows\AppPatch\apppatch64\sysmain.sdb</pre>

Pliki te trzeba usunąć, przesunąć lub zmienić ich nazwy. Ponieważ Windows jakkolwiek jest zabezpieczony to należy zalogować się na konto SYSTEM &#8211; coś jak root na Linuksie, jednak na ten profil nie można się normalnie zalogować. Można natomiast wykorzystać sztuczki by uruchomić proces z jego uprawnieniami. Rzecz jasna my musimy mieć konto administratorskie. Po starem można wywołać

<pre class="EnlighterJSRAWbash">at 17:24 /interactive cmd.exe</pre>

gdzie 17:24 to godzina, kiedy chcemy odpalić zadanie (zazwyczaj następna minuta). Jeśli chcemy być zgodni z nowymi trendami i zdobyć praktyczne narzędzie Sysinternals to warto pobrać ze strony http://technet.microsoft.com/en-us/sysinternals/bb545027 PSexec i wywołać

<pre class="EnlighterJSRAWbash">psexec -s cmed.exe</pre>

Alternatywą do rozwiązań &#8222;systemowych&#8221; są wszelkie aplikacje nazwane **runassystem**. Teraz pozostaje przejąć uprawnienia do samych plików &#8211; nie zawsze tak po prostu można modyfikować plik będąc superużytkownikiem. Ja użyłem FAR Manager&#8217;a, który sam przejmuje uprawnienia kiedy trzeba, ale wystarczy <u>icacls</u> oraz <u>takeown</u>. 

Przypomnę to, co oczywiste na moim blogu &#8211; to rozwiązanie jest dość niebezpieczne, ponadto wiersz poleceń tak wyglądający jest furtką do zagrożenia stabilności i integralności okienek 

<pre>Microsoft Windows [Version 6.3.9431]
(c) 2013 Microsoft Corporation. All rights reserved.

C:\Windows>whoami
<b>nt authority\system</b></pre>