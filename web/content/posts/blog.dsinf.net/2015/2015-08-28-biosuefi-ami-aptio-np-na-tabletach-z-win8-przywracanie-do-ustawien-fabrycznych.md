---
title: BIOS/UEFI AMI APTIO (np. na tabletach z Win8) – przywracanie do ustawień fabrycznych
author: Daniel Skowroński
type: post
date: 2015-08-28T09:44:26+00:00
summary: 'BIOS, czy właściwie UEFI wydany przez AMI - APTIO 4 jest zdradziecki nawet dla osób mających już trochę doświadczenia w grzebaniu po tego typu systemach - ma się w pamięci, że w razie czego da się otworzyć klapę i przestawić zworkę, która zresetuje ustawienia do fabrycznych. Tabletu się nie otworzy tak łatwo. A o omyłkowe wyłączenie USB OTG, które wyłącza też klawiaturę w BIOSie nietrudno. Jest jednak na to sposób.'
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
BIOS, czy właściwie UEFI wydany przez AMI - APTIO 4 jest zdradziecki nawet dla osób mających już trochę doświadczenia w grzebaniu po tego typu systemach - ma się w pamięci, że w razie czego da się otworzyć klapę i przestawić zworkę, która zresetuje ustawienia do fabrycznych. Tabletu się nie otworzy tak łatwo. A o omyłkowe wyłączenie USB OTG, które wyłącza też klawiaturę w BIOSie nietrudno. Jest jednak na to sposób. 

![Aptio Setup Utility](/wp-content/uploads/2015/08/0.png "Aptio Setup Utility")

Na zdjęciu obok przykładowy widok na Aptio Setup Utility. Widoczne także ekstremalne lenistwo producenta - nie podmienił "To be filled by O.E.M." - i takiego producenta widzą Linuksy...  
<br clear="all" /> 

Minimum, które jest nam potrzebne to działający Windows (albo Linux, chociaż na takim tablecie prędzej Windows będzie).

Zacznijmy od próby identyfikacji scalaka BIOSu - tablety z Win8 robione są w większości jak tanie chińskie smartfony z androidem - gotowe scalaki, tylko różni producenci i wyposażenie końcowe (to zresztą widać w ustawieniach Aptio - można wybrać kilka dostępnych adapterów bluetooth, kamer, sensorów etc.). Dokładniej jest to Intel SoC.

Posłuży nam do tego narzędzie, którym na końcu przywrócimy ustawienia fabryczne - AFUWIN (Ami Flash Utility WINdows) - [udostępnia][2] je samo AMI, ale ponieważ już raz zawęzili dostępne oprogramowanie dlatego jest dostępny [mirror][3] i [pewna strona][4] agregująca podobne narzędzia.

![1](/wp-content/uploads/2015/08/1.png)

Kiedy odczytamy firmware ID możemy wpisać go w google i liczyć na to, że ktoś go wrzucił. I często faktycznie daje się znaleźć obraz na XDA albo polskojęzycznych forach. Jeśli po długim szukaniu nic nie znajdziemy warto pomęczyć producenta (o ile nie jest to ekstremalnie chińska firma bez polskiego dystrybutora) - może udostępni (Colorovo udostępnił kiedyś oryginalne sterowniki do CityTab Supreme 8 krążące teraz po elektrodzie także warto próbować; skoro już tyle wtrąciłem to wspomnę, że pod Win10 działa na nich wszystko poza sensorem orientacji Kionix, ale nad tym obecnie pracuję). W zakładce setup zaznaczamy "tylko nvram", żeby nie zfalshować za dużo (urządzenia w ostateczności mogą się nieco różnić i lepiej zminimalizować zakres flashowania, ponadto by default ustawienia nie są zmieniane).

Efektem flashowania ROMu nie od naszego urządzenia może być dziwne zachowanie sensorów, ale z mojego doświadczenia ekran będzie działał, a USB OTG obsługiwane przez BIOS, a nie Windows (co ciekawe ten sprytny system nawet kiedy fizycznie nie ma OTG umie przesterować sygnały i emulować USB hosta), jest zawsze domyślnie włączone. Teraz można już wejść do biosu i poprzestawiać co trzeba żeby sensory odpowiadały naszym zainstalowanym fizycznie (czasem trzeba się pomęczyć i poiterować po kolejnych kamerach tylnych, czy czujnikach dotyku, ale w końcu się uda).

**UWAGA**: wgrywanie obrazu, który pobraliśmy nie od producenta jest bardzo ryzykowne - zwłaszcza kiedy okaże się, że odetniemy sobie drogę do bootowania systemu - naszej jedynej drogi do flashowania lub co gorsza - możemy sobie usmażyć sprzęt. To już na pewno łamie gwarancję! W ogóle flashowanie BIOSu jest ryzykowne a robienie tego spod systemu operacyjnego jeszcze bardziej!

W przypadku Colorovo CityTab Supreme 8H Firmware ID to 3BAGR003 (ale dla pewności najpierw należy zweryfikować to przez AFUWIN), a plik z BIOSem od tabletu MIPI jest dostępny tutaj - [3BAGR003.bin][6]. Warto szukać głęboko, z mojego doświadczenia ROMy znajduję na forach i/lub hostingach z europy w nietypowych językach (czeski, bułgarski itp.)

Ale co jeszcze można zrobić?

AFUWIN pozwala zgrać obraz ROMu. Możemy na ślepo edytować plik binarny albo skorzystać z AMIBCP (AMI Bios Configuration Program). Najnowsza wersja dostępna mało oficjalnie to 4.55 dostępna jest [tutaj][7]. Niestety umie tylko czytać obrazy z Aptio4. Docelowo powinna pozwolić zmienić defaultowe wartości w menu (możemy się nawigować jakbysmy byli w Aptio Setup Utility) oraz inne parametry obrazu. Potem wystarczyłoby zapisać obraz i go zflashować. Jednak obrazy z Aptio4 w trakcie zapisu powodują błąd i obraz się nie zapisuje (nawet jeśli nie wprowadziliśmy zmian). Kod błędu - Error occurred in BIOS rebuild (#80000015).

![2](/wp-content/uploads/2015/08/2.png)  
![3](/wp-content/uploads/2015/08/3.png)

Jeśli to zawiedzie można spróbować użyć AMISCE/SCEWIN (AMI Setup Control Environment, różnież mało oficjalnie [dostępny][10]). Pozwala on edytować ustawienia, jednak z moim Aptio4 nie współpracował narzekając na problem z odczytem bazy HII. Może komuś jednak pomoże.

Warto wspomnieć, że wymienione wyżej narzędzia działają nie tylko na Aptio od AMI w tabletach ale także na innych BIOSach AMI, np. moja płyta główna ASUS B75M-PLUS w stacjonarce świetnie wpółpracuje z tymi narzędziami. Niezgodność zdaje się występować tylko w przypadku Aptio4 i AptioV (Aptio 5).

 [1]: /wp-content/uploads/2015/08/0.png
 [2]: http://www.ami.com/download-license-agreement/?DownloadFile=AMIBIOS_and_Aptio_AMI_Firmware_Update_Utility.zip
 [3]: https://mega.nz/#!Hg1zFQiC!MQ-lNnpIZ482OpGdCmKVqofuPItxRgYPFASFya9NyRc
 [4]: https://www.wimsbios.com/amiflasher.jsp
 [5]: /wp-content/uploads/2015/08/1.png
 [6]: /wp-content/uploads/2015/08/3BAGR003.bin_.zip
 [7]: https://mega.nz/#!rtEDBKyL!Q4ozoG4lPy66icTfLPpUCAw2Re5K3DtWWcHcyOt5Il8
 [8]: /wp-content/uploads/2015/08/2.png
 [9]: /wp-content/uploads/2015/08/3.png
 [10]: https://mega.nz/#!ahFS1RRR!f-azf5XmHduHLfuz0DpCnv34AQRTpqZmOehQZPygHJY