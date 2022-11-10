---
title: Zmiana lokalizacji profilu użytkownika w Windows
author: Daniel Skowroński
type: post
date: 2015-01-14T07:43:11+00:00
excerpt: Coś co jest "oczywiste" w Linuksie, czyli zmiana lokalizacji katalogu domowego użytkownika w Windowsie nie jest takie trudne, a już na pewno nie jest niewykonalne dla kogoś, kto dał radę zainstalować Linuksa.
url: /2015/01/zmiana-lokalizacji-profilu-uzytkownika-w-windows/
tags:
  - windows

---
Coś co jest &#8222;oczywiste&#8221; w Linuksie, czyli zmiana lokalizacji katalogu domowego użytkownika w Windowsie nie jest takie trudne, a już na pewno nie jest niewykonalne dla kogoś, kto dał radę zainstalować Linuksa.

Po cóż przenosić c:\users gdzieś indziej? Mi było to potrzebne, żeby prosto dostać się do pulpitu windowsowego z zainstalowanego obok Linuksa &#8211; system NTFS może jest i fajny, ale sprawia problemy z montowaniem poza Windowsem (zwłaszcza w trybie &#8222;Fast startup&#8221; gdzie system nie sprząta po sobie dysku, czy hibernacji &#8211; typowy schemat: potrzebujemy pliku z pulpitu Linuksa więc hibernujemy Windowsa, kopiujemy pod Linuksem plik na c:\users\user\pulpit, gasimy Linuksa, startujemy Windowsa, a pliku&#8230; nie ma bo journal NTFSa uznał, że tam nic być nie powinno).

Ponadto na małych dyskach (netbooki itp.) przy typowym podziale partycji dekstopów (u mnie: 30-50GB Windows, 20GB Linuks, reszta na dużą partycję na dane) te 50GB windowsa szybko zajmie system, Visual Studio, hiberfil.sys albo pagefile.sys (zależnie od ilości RAMu &#8211; mając 16GB swapa nie potrzeba, ale plik hibernacji jest sporawy ;)) i brak miejsca dla plików z OneDrive&#8217;a, czy po prostu katalogu Pobrane\.

Operacja nie jest typu &#8222;jedno kliknięcie&#8221;, ale ujawnia wiele ciekawych opcji Windowsa.

  1. Najpierw odpalamy (z uprawnieniami administratora) w wierszu poleceń  
    <span class="lang:default EnlighterJSRAW  crayon-inline ">C:\Windows\System32\Sysprep\Sysprep.exe /audit /reboot</span>  
    &#8211; zlecając start w trybie audytu, gdzie można między innymi przystosować system do kopiowania na różne maszyny (nieocenione przy deploymencie dziesiątek maszyn). Uwaga: wchodzenie w ten tryb może chwilę zająć. Więcej informacji na technecie: [http://technet.microsoft.com/en-us/library/cc722413(WS.10).aspx][1]
  2. W zrestartowanym systemie nowootwarte okno _System Preparation Tool_ zamykamy
  3. Przygotowywujemy skrypt modyfikacji: <pre class="lang:xhtml EnlighterJSRAW ">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;unattend xmlns="urn:schemas-microsoft-com:unattend"&gt;
&lt;settings pass="oobeSystem"&gt;
&lt;!-- processorArchitecture to amd64 (wszystkie 64-bitowe&lt; [1]) albo x86 --&gt;
&lt;component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64"
 publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
 xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;FolderLocations&gt;
&lt;!-- ProfilesDirectory to oczywiście ścieżka docelowa [2] --&gt;
&lt;ProfilesDirectory&gt;d:\Users&lt;/ProfilesDirectory&gt;
&lt;/FolderLocations&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;!-- cpi:source to ścieżka do install.wim na nośniku instalacyjnym [3] --&gt;
&lt;!-- w cpi:source wartość po # to nazwa systemu: "Windows 8", "Windows 8.1", 
"Windows 8.1 Pro"; [4]--&gt;
&lt;cpi:offlineImage cpi:source="wim:F:/sources/install.wim#Windows 8" 
xmlns:cpi="urn:schemas-microsoft-com:cpi" /&gt;
&lt;/unattend&gt;</pre>
    
    [1]: amd64 to w uproszczeniu wszystkie 64-bitowe procesory w desktopach/laptopach (ia64 to bardzo stare Intel Xeon serwerowe)  
    [2]: warto w diskmgmt.msc przestawić literę dysku jeśli jakimś sposobem w czasie instalacji d: to cd-rom albo pendrive z którego była uruchamiana instalacja, a e: to pierwsza partycja na dane  
    [3]: pełna ścieżka  
    [4]: prawdopodobnie &#8222;Windows 7&#8221; też zadziała, ale jeszcze nie testowałem; ważne jest rozróżnienie na wersję Pro</li> 
    
      * Plik zapisać najlepiej na katalogu głównym jakiegoś dysku (polecam c:\ albo pendrive instalacyjny) jako .xml
      * W wierszu poleceń administratora: 
        <pre>net stop WMPNetworkSvc
cd c:\Windows\System32\Sysprep
Sysprep.exe /audit /reboot /unattend:c:\ścieżka_do_pliku.xml</pre>
        
        nic nie ruszamy i czekamy do restartu</li> 
        
          * Po restarcie (znowu do trybu audytu) w oknie _System Cleanup Action_ dajemy _Enter System Out-of-Box Experience (OOBE)_ i _Reboot_
          * System restartuje się do normalnego trybu i działa 😉</ol> 
        
        Proces mimo pozornej reinstalacji systemu można bez strat przeprowadzić na istniejącym systemie chociaż (tak jak nawet na Linuksach) zalecam kopię zapasową plików ;).

 [1]: http://technet.microsoft.com/en-us/library/cc722413(WS.10).aspx "http://technet.microsoft.com/en-us/library/cc722413(WS.10).aspx"