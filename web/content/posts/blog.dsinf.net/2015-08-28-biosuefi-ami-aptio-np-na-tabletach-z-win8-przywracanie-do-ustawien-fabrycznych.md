---
title: BIOS/UEFI AMI APTIO (np. na tabletach z Win8) – przywracanie do ustawień fabrycznych
author: Daniel Skowroński
type: post
date: 2015-08-28T09:44:26+00:00
excerpt: 'BIOS, czy właściwie UEFI wydany przez AMI - APTIO 4 jest zdradziecki nawet dla osób mających już trochę doświadczenia w grzebaniu po tego typu systemach - ma się w pamięci, że w razie czego da się otworzyć klapę i przestawić zworkę, która zresetuje ustawienia do fabrycznych. Tabletu się nie otworzy tak łatwo. A o omyłkowe wyłączenie USB OTG, które wyłącza też klawiaturę w BIOSie nietrudno. Jest jednak na to sposób.'
url: /2015/08/biosuefi-ami-aptio-np-na-tabletach-z-win8-przywracanie-do-ustawien-fabrycznych/
tags:
  - afuwin
  - ami
  - bios
  - colorovo
  - hardware
  - tablet
  - uefi
  - windows 8

---
BIOS, czy wł[<img decoding="async" loading="lazy" class="wp-image-764 alignleft" src="http://blog.dsinf.net/wp-content/uploads/2015/08/0-649x1024.png" alt="Aptio Setup Utility" width="243" height="384" srcset="https://blog.dsinf.net/wp-content/uploads/2015/08/0-649x1024.png 649w, https://blog.dsinf.net/wp-content/uploads/2015/08/0-190x300.png 190w, https://blog.dsinf.net/wp-content/uploads/2015/08/0-660x1041.png 660w, https://blog.dsinf.net/wp-content/uploads/2015/08/0-900x1420.png 900w, https://blog.dsinf.net/wp-content/uploads/2015/08/0.png 1592w" sizes="(max-width: 243px) 100vw, 243px" />][1]aściwie UEFI wydany przez AMI &#8211; APTIO 4 jest zdradziecki nawet dla osób mających już trochę doświadczenia w grzebaniu po tego typu systemach &#8211; ma się w pamięci, że w razie czego da się otworzyć klapę i przestawić zworkę, która zresetuje ustawienia do fabrycznych. Tabletu się nie otworzy tak łatwo. A o omyłkowe wyłączenie USB OTG, które wyłącza też klawiaturę w BIOSie nietrudno. Jest jednak na to sposób. 

Na zdjęciu obok przykładowy widok na Aptio Setup Utility. Widoczne także ekstremalne lenistwo producenta &#8211; nie podmienił &#8222;To be filled by O.E.M.&#8221; &#8211; i takiego producenta widzą Linuksy&#8230;  
<br clear="all" /> 

Minimum, które jest nam potrzebne to działający Windows (albo Linux, chociaż na takim tablecie prędzej Windows będzie).

Zacznijmy od próby identyfikacji scalaka BIOSu &#8211; tablety z Win8 robione są w większości jak tanie chińskie smartfony z androidem &#8211; gotowe scalaki, tylko różni producenci i wyposażenie końcowe (to zresztą widać w ustawieniach Aptio &#8211; można wybrać kilka dostępnych adapterów bluetooth, kamer, sensorów etc.). Dokładniej jest to Intel SoC.

Posłuży nam do tego narzędzie, którym na końcu przywrócimy ustawienia fabryczne &#8211; AFUWIN (Ami Flash Utility WINdows) &#8211; [udostępnia][2] je samo AMI, ale ponieważ już raz zawęzili dostępne oprogramowanie dlatego jest dostępny [mirror][3] i [pewna strona][4] agregująca podobne narzędzia.

[<img decoding="async" loading="lazy" class="alignnone size-full wp-image-759" src="http://blog.dsinf.net/wp-content/uploads/2015/08/1.png" alt="1" width="609" height="471" srcset="https://blog.dsinf.net/wp-content/uploads/2015/08/1.png 609w, https://blog.dsinf.net/wp-content/uploads/2015/08/1-300x232.png 300w" sizes="(max-width: 609px) 100vw, 609px" />][5]

Kiedy odczytamy firmware ID możemy wpisać go w google i liczyć na to, że ktoś go wrzucił. I często faktycznie daje się znaleźć obraz na XDA albo polskojęzycznych forach. Jeśli po długim szukaniu nic nie znajdziemy warto pomęczyć producenta (o ile nie jest to ekstremalnie chińska firma bez polskiego dystrybutora) &#8211; może udostępni (Colorovo udostępnił kiedyś oryginalne sterowniki do CityTab Supreme 8 krążące teraz po elektrodzie także warto próbować; skoro już tyle wtrąciłem to wspomnę, że pod Win10 działa na nich wszystko poza sensorem orientacji Kionix, ale nad tym obecnie pracuję). W zakładce setup zaznaczamy &#8222;tylko nvram&#8221;, żeby nie zfalshować za dużo (urządzenia w ostateczności mogą się nieco różnić i lepiej zminimalizować zakres flashowania, ponadto by default ustawienia nie są zmieniane).

Efektem flashowania ROMu nie od naszego urządzenia może być dziwne zachowanie sensorów, ale z mojego doświadczenia ekran będzie działał, a USB OTG obsługiwane przez BIOS, a nie Windows (co ciekawe ten sprytny system nawet kiedy fizycznie nie ma OTG umie przesterować sygnały i emulować USB hosta), jest zawsze domyślnie włączone. Teraz można już wejść do biosu i poprzestawiać co trzeba żeby sensory odpowiadały naszym zainstalowanym fizycznie (czasem trzeba się pomęczyć i poiterować po kolejnych kamerach tylnych, czy czujnikach dotyku, ale w końcu się uda).

**UWAGA**: wgrywanie obrazu, który pobraliśmy nie od producenta jest bardzo ryzykowne &#8211; zwłaszcza kiedy okaże się, że odetniemy sobie drogę do bootowania systemu &#8211; naszej jedynej drogi do flashowania lub co gorsza &#8211; możemy sobie usmażyć sprzęt. To już na pewno łamie gwarancję! W ogóle flashowanie BIOSu jest ryzykowne a robienie tego spod systemu operacyjnego jeszcze bardziej!

W przypadku Colorovo CityTab Supreme 8H Firmware ID to 3BAGR003 (ale dla pewności najpierw należy zweryfikować to przez AFUWIN), a plik z BIOSem od tabletu MIPI jest dostępny tutaj &#8211; [3BAGR003.bin][6]. Warto szukać głęboko, z mojego doświadczenia ROMy znajduję na forach i/lub hostingach z europy w nietypowych językach (czeski, bułgarski itp.)

Ale co jeszcze można zrobić?

AFUWIN pozwala zgrać obraz ROMu. Możemy na ślepo edytować plik binarny albo skorzystać z AMIBCP (AMI Bios Configuration Program). Najnowsza wersja dostępna mało oficjalnie to 4.55 dostępna jest [tutaj][7]. Niestety umie tylko czytać obrazy z Aptio4. Docelowo powinna pozwolić zmienić defaultowe wartości w menu (możemy się nawigować jakbysmy byli w Aptio Setup Utility) oraz inne parametry obrazu. Potem wystarczyłoby zapisać obraz i go zflashować. Jednak obrazy z Aptio4 w trakcie zapisu powodują błąd i obraz się nie zapisuje (nawet jeśli nie wprowadziliśmy zmian). Kod błędu &#8211; Error occurred in BIOS rebuild (#80000015).

[<img decoding="async" loading="lazy" class="alignnone size-large wp-image-760" src="http://blog.dsinf.net/wp-content/uploads/2015/08/2-1024x690.png" alt="2" width="665" height="448" srcset="https://blog.dsinf.net/wp-content/uploads/2015/08/2-1024x690.png 1024w, https://blog.dsinf.net/wp-content/uploads/2015/08/2-300x202.png 300w, https://blog.dsinf.net/wp-content/uploads/2015/08/2-660x444.png 660w, https://blog.dsinf.net/wp-content/uploads/2015/08/2-900x606.png 900w, https://blog.dsinf.net/wp-content/uploads/2015/08/2.png 1188w" sizes="(max-width: 665px) 100vw, 665px" />][8]  
[<img decoding="async" loading="lazy" class="alignnone size-full wp-image-761" src="http://blog.dsinf.net/wp-content/uploads/2015/08/3.png" alt="3" width="470" height="372" srcset="https://blog.dsinf.net/wp-content/uploads/2015/08/3.png 470w, https://blog.dsinf.net/wp-content/uploads/2015/08/3-300x237.png 300w" sizes="(max-width: 470px) 100vw, 470px" />][9]

Jeśli to zawiedzie można spróbować użyć AMISCE/SCEWIN (AMI Setup Control Environment, różnież mało oficjalnie [dostępny][10]). Pozwala on edytować ustawienia, jednak z moim Aptio4 nie współpracował narzekając na problem z odczytem bazy HII. Może komuś jednak pomoże.

Warto wspomnieć, że wymienione wyżej narzędzia działają nie tylko na Aptio od AMI w tabletach ale także na innych BIOSach AMI, np. moja płyta główna ASUS B75M-PLUS w stacjonarce świetnie wpółpracuje z tymi narzędziami. Niezgodność zdaje się występować tylko w przypadku Aptio4 i AptioV (Aptio 5).

 [1]: http://blog.dsinf.net/wp-content/uploads/2015/08/0.png
 [2]: http://www.ami.com/download-license-agreement/?DownloadFile=AMIBIOS_and_Aptio_AMI_Firmware_Update_Utility.zip
 [3]: https://mega.nz/#!Hg1zFQiC!MQ-lNnpIZ482OpGdCmKVqofuPItxRgYPFASFya9NyRc
 [4]: https://www.wimsbios.com/amiflasher.jsp
 [5]: http://blog.dsinf.net/wp-content/uploads/2015/08/1.png
 [6]: http://blog.dsinf.net/wp-content/uploads/2015/08/3BAGR003.bin_.zip
 [7]: https://mega.nz/#!rtEDBKyL!Q4ozoG4lPy66icTfLPpUCAw2Re5K3DtWWcHcyOt5Il8
 [8]: http://blog.dsinf.net/wp-content/uploads/2015/08/2.png
 [9]: http://blog.dsinf.net/wp-content/uploads/2015/08/3.png
 [10]: https://mega.nz/#!ahFS1RRR!f-azf5XmHduHLfuz0DpCnv34AQRTpqZmOehQZPygHJY