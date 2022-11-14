---
title: DYMO Tape Labels na Linuksie
author: Daniel Skowroński
type: post
date: 2020-05-19T21:49:22+00:00
excerpt: 'Od jakieś czasu jestem szczęśliwym posiadaczem drukarki etykiet Dymo - LabelWriter 450 Duo. A od niedawna w końcu wróciłem do Linuksa jako głównego systemu na stacji roboczej. Mój sukces z tym podwójnym urządzeniem - potrafi ono bowiem drukować zarówno etykiety prostokątne jak i na taśmie - był połowiczny: etykiety o stałych wymiarach nie stanowią problemu dla programu gLabels. Natomiast te drukowane na taśmie typu D1 (a więc o stałej wysokości, ale zmiennej długości) nijak nie chcą współpracować z żadnym znanym mi programem. '
url: /2020/05/dymo-tape-labels-na-linuksie/
featured_image: /wp-content/uploads/2020/05/dymo450.jpeg
tags:
  - drukarka
  - dymo
  - linux

---
Od jakieś czasu jestem szczęśliwym posiadaczem drukarki etykiet Dymo - LabelWriter 450 Duo. A od niedawna w końcu wróciłem do Linuksa jako głównego systemu na stacji roboczej. Mój sukces z tym podwójnym urządzeniem - potrafi ono bowiem drukować zarówno etykiety prostokątne, jak i na taśmie - był połowiczny: etykiety o stałych wymiarach nie stanowią problemu dla programu gLabels. Natomiast te drukowane na taśmie typu D1 (a więc o stałej wysokości, ale zmiennej długości) nijak nie chcą współpracować z żadnym znanym mi programem. 

![](/wp-content/uploads/2020/05/dymo450.jpeg)

Na Windowsie i macOS sprawa wygląda prosto - dostarczone narzędzie _**DYMO** **Label**_, które niedawno zostało przebrandowane na _**DYMO Connect**_, bardzo sprawnie daje sobie radę. Ba, wystawia nawet webowe API dostępne na localhoście które pozwala na generowanie etykiet na przykład w przeglądarce. Ten ostatni fakt wykorzystuję w moim generatorze etykiet do puszek herbaty - _**DymoTeaLabel**_, który jest dostępny [na githubie][1].

![Tak prezentuje się DYMO Connect](/wp-content/uploads/2020/05/dymo_connect.jpg)

Oczywiście artykułu by nie było, gdyby któreś z oficjalnych narzędzi odpalało się na Wine. Odpala się za to w VirtualBoxie, no ale bez przesady - na pewno da się pominąć Windowsa.

Okazuje się że się da, gdyż etykieciarki przedstawiają się jako drukarki USB - jedna _tape_ i druga _label_. Żeby zacząć drukowanie na Linuksie potrzeba zainstalować sterowniki w formacie PPD do CUPSa. W ubuntu wystarczy pakiet **printer-driver-dymo**.

Także można by pomyśleć o użyciu klasycznych unixowych narzędzi typu _lpr_, prawda? Otóż niestety nie udało mi się zmusić ich do współpracy - winny jest tu układ papieru, gdyż taśma to nie kartka A4 czy etykieta adresowa o stałym rozmiarze typu 54x101mm. Jedyne co mamy to wysokość - na przykład pół cala, a szerokość powinna być kalkulowana dynamicznie. Wysiłki związane z generowaniem odpowiedniego PostScripa za pomocą narzędzia [enscript][2] zajęły mi cały dzień i niestety nie zabrnąłem za daleko. 

Zastanawiając się jak przekonać na przykład LibreOffice Writera do drukowania, zajrzałem do zawartości sterowników - okazuje się, że istnieje w nich tryb drukowania o adaptacyjnej długości taśmy - _Continuous_. Ale nie działa 🙁

Poniżej plik PPD dostarczany przez Dymo z wyciętymi tłumaczeniami i ograniczony do półcalowych formatów. Spostrzegawczy zauważą, że firma korzysta z Perforce do kontroli wersji.

```ppd
*PPD-Adobe: "4.3"

*% $Id: lwduot.ppd 16401 2011-10-31 18:51:16Z pineichen $

*% DYMO LabelWriter Drivers
*% Copyright (C) 2008 Sanford L.P.

*% This program is free software; you can redistribute it and/or
*% modify it under the terms of the GNU General Public License
*% as published by the Free Software Foundation; either version 2
*% of the License, or (at your option) any later version.

*% This program is distributed in the hope that it will be useful,
*% but WITHOUT ANY WARRANTY; without even the implied warranty of
*% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*% GNU General Public License for more details.

*% ...

*FormatVersion: "4.3"
*FileVersion:   "3.0"
*LanguageVersion: English 
*LanguageEncoding: ISOLatin1
*PCFileName:    "LWDUOT.PPD"
*Manufacturer:  "DYMO"
*Product:   "(DYMO LabelWriter DUO Tape)"
*cupsVersion:   1.2
*cupsManualCopies: False
*cupsFilter:    "application/vnd.cups-raster 0 raster2dymolm"
*cupsModelNumber: 0
*PSVersion: "(3010.000) 550"
*LanguageLevel: "3"
*ColorDevice:   False
*DefaultColorSpace: Gray
*FileSystem:    False
*Throughput:    "8"
*LandscapeOrientation: Minus90
*VariablePaperSize: True
*TTRasterizer:  Type42

*ModelName: "DYMO LabelWriter DUO Tape"
*NickName: "DYMO LabelWriter DUO Tape"
*ShortNickName: "DYMO LabelWriter DUO Tape"
*APPrinterIconPath: "/Library/Printers/DYMO/CUPS/Resources/LWDuo.icns"

*cupsIPPReason com.dymo.out-of-paper-error/Out of labels. : ""
*cupsIPPReason com.dymo.read-error/Cannot read data from printer. : ""
*cupsIPPReason com.dymo.ready/Printer is ready. : ""
*cupsIPPReason com.dymo.general-error/General print error. : ""
*cupsIPPReason com.dymo.head-overheat-error/Print head is overheated. : ""
*cupsIPPReason com.dymo.slot-status-error/Label path is blocked. : ""
*cupsIPPReason com.dymo.busy-error/The printer is currently in use. : ""
*cupsIPPReason com.dymo.paper-size-error/Label being printed does not match label width currently in printer. : ""
*cupsIPPReason com.dymo.paper-size-undefine-error/Insert a label cassette in the printer. : ""

*% ...

*% ...
*% *UIConstraints: *PageSize w35h252           *MediaType 2
*% *UIConstraints: *PageSize w35h144           *MediaType 2
*% *UIConstraints: *PageSize w35h252.2    *MediaType 2
*% *UIConstraints: *PageSize w35h144.1    *MediaType 2
*% ...

*OpenUI *MediaType/Label Width: PickOne
*OrderDependency: 9 AnySetup *MediaType
*DefaultMediaType: 24mm
*% ...
*MediaType 12mm/12 mm (1/2"): "<</cupsMediaType 2>>setpagedevice"
*% ...

*% ...

*CloseUI: *MediaType

*OpenUI *PageSize/Media Size: PickOne
*OrderDependency: 10 AnySetup *PageSize
*DefaultPageSize: w68h252.2
*% ...
*PageSize w35h252/1/3 File: "<</PageSize[35 252]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageSize w35h144/1/5 File: "<</PageSize[35 144]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageSize w35h252.1/12 mm (1/2") Label: "<</PageSize[35 252]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageSize w35h4000/12 mm (1/2") Continuous: "<</PageSize[35 4000]/ImagingBBox null/cupsMediaType 258/cupsInteger0 0>>setpagedevice"
*% ...

*CloseUI: *PageSize

*OpenUI *PageRegion: PickOne
*OrderDependency: 10 AnySetup *PageRegion
*DefaultPageRegion: w68h252.2
*% ...
*PageRegion w35h252/1/3 File: "<</PageSize[35 252]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageRegion w35h144/1/5 File: "<</PageSize[35 144]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageRegion w35h252.1/12 mm (1/2") Label: "<</PageSize[35 252]/ImagingBBox null/cupsMediaType 2/cupsInteger0 0>>setpagedevice"
*PageRegion w35h4000/12 mm (1/2") Continuous: "<</PageSize[35 4000]/ImagingBBox null/cupsMediaType 258/cupsInteger0 0>>setpagedevice"
*% ...

*DefaultImageableArea: w68h252.2
*% ...
*ImageableArea w35h252/1/3 File: "9.20 30.00 25.20 222.00"
*ImageableArea w35h144/1/5 File: "9.20 30.00 25.20 114.00"
*ImageableArea w35h252.1/12 mm (1/2") Label: "9.20 30.00 25.20 222.00"
*ImageableArea w35h4000/12 mm (1/2") Continuous: "9.20 30.00 25.20 3970.00"
*% ...

*DefaultPaperDimension: w68h252.2
*% ...
*PaperDimension w35h252/1/3 File: "34.40 252.00"
*PaperDimension w35h144/1/5 File: "34.40 144.00"
*PaperDimension w35h252.1/12 mm (1/2") Label: "34.40 252.00"
*PaperDimension w35h4000/12 mm (1/2") Continuous: "34.40 4000.00"
*% ...

*MaxMediaWidth:  "38.4"
*MaxMediaHeight: "4000"
*HWMargins:      0 0 0 0
*CustomPageSize True: "pop pop pop <</PageSize[5 -2 roll]/ImagingBBox null/cupsInteger0 0>>setpagedevice"
*ParamCustomPageSize Width:        1 points 4 38.4
*ParamCustomPageSize Height:       2 points 16 4000
*ParamCustomPageSize WidthOffset:  3 points 0 0
*ParamCustomPageSize HeightOffset: 4 points 0 0
*ParamCustomPageSize Orientation:  5 int 0 3

*OpenUI *Resolution/Output Resolution: PickOne
*OrderDependency: 20 AnySetup *Resolution
*DefaultResolution: 180dpi
*Resolution 180dpi/180 DPI: "<</HWResolution[180 180]>>setpagedevice"
*CloseUI: *Resolution

*OpenUI *DymoHalftoning/Halftoning: PickOne
*OrderDependency: 20 AnySetup *DymoHalftoning
*DefaultDymoHalftoning: ErrorDiffusion
*DymoHalftoning Default/Default: "<</cupsColorOrder 0/cupsColorSpace 3/cupsBitsPerColor 1/cupsBitsPerPixel 1>>setpagedevice"
*DymoHalftoning ErrorDiffusion/Error Diffusion: "<</cupsColorOrder 0/cupsColorSpace 1/cupsBitsPerColor 8>>setpagedevice"
*DymoHalftoning NLL/Nonlinear Dithering: "<</cupsColorOrder 0/cupsColorSpace 1/cupsBitsPerColor 8>>setpagedevice"

*% ...

*CloseUI: *DymoHalftoning

*OpenUI *DymoCutOptions/Cut Options: PickOne
*OrderDependency: 20 AnySetup *DymoCutOptions
*DefaultDymoCutOptions: Cut
*DymoCutOptions Cut/Cut: ""
*DymoCutOptions ChainMarks/Chain Marks: ""

*% ...

*CloseUI: *DymoCutOptions

*OpenUI *DymoLabelAlignment/Label Alignment: PickOne
*OrderDependency: 20 AnySetup *DymoLabelAlignment
*DefaultDymoLabelAlignment: Center
*DymoLabelAlignment Center/Centered: ""
*DymoLabelAlignment Left/Left Aligned: ""
*DymoLabelAlignment Right/Right Aligned: ""

*% ...

*CloseUI: *DymoLabelAlignment

*OpenUI *DymoContinuousPaper/Continuous Paper: PickOne
*OrderDependency: 20 AnySetup *DymoContinuousPaper
*DefaultDymoContinuousPaper: 0
*DymoContinuousPaper 0/Disabled: ""
*DymoContinuousPaper 1/Enabled: ""

*% ...

*CloseUI: *DymoContinuousPaper

*OpenUI *DymoPrintChainMarksAtDocEnd/Print Chain Marks at Doc End: PickOne
*OrderDependency: 20 AnySetup *DymoPrintChainMarksAtDocEnd
*DefaultDymoPrintChainMarksAtDocEnd: 0
*DymoPrintChainMarksAtDocEnd 0/Disabled: ""
*DymoPrintChainMarksAtDocEnd 1/Enabled: ""

*% ...

*CloseUI: *DymoPrintChainMarksAtDocEnd

*OpenUI *DymoTapeColor/Label Cassette Color: PickOne
*OrderDependency: 20 AnySetup *DymoTapeColor
*DefaultDymoTapeColor: 0
*DymoTapeColor 0/Black on White or Clear: ""
*DymoTapeColor 1/Black on Blue: ""
*% ...

*CloseUI: *DymoTapeColor

*DefaultFont: Courier
*Font AvantGarde-Book: Standard "(001.006S)" Standard ROM

*% ...

*%
*%  End of "$Id: lwduot.ppd 16401 2011-10-31 18:51:16Z pineichen $"
*%

```


To na co warto zwrócić uwagę to dwa formaty medium - **w35h252.1/12 mm** i **w35h4000/12 mm**. Wygląda, jakby wartość 4000 była jakimś sygnałem do drukarki by wykryć pustą przestrzeń (zakładając, że zawartość wyrównana jest do lewej krawędzi), aby w odpowiednim miejscu uciąć etykietę i zakończyć drukowanie. Niestety moje eksperymenty z oboma formatami kończyły się wydrukiem etykiety o długości 2.5cm lub... 40cm - niezbyt to ekologiczne ani ekonomiczne testować obsługę drukowania z ryzykiem wyplucia wspaniałych zabawek dla kota. Także po dwóch popołudniach się poddałem.

Aż któregoś dnia przypomniałem sobie, że kiedyś przypadkiem puściłem wydruk normalnego dokumentu w formacie A4 na drukarkę etykiet. Nie wyszło za dobrze, ale zdadywałem, iż LibreOffice Writer też powinien potrafić drukować. No i potrafi 🙂 

Kwestia ustawienia customowego rozmiaru strony - z interfejsu wybrałem cokolwiek, puściłem wydruk i ujrzałem dokładnie to, co we Writerze - co było niebywałym sukcesem po pustych wydrukach z _lpr_. Wziąłem więc linijkę i okazało się, że rozmiar jest dokładnie taki, jak ustawiłem a nie 25.2mm. Teraz kwestia automatyzacji.

Po chwili wahania uznałem, że skoro w życiu napisałem trochę kodu w PHP to sklecenie makra w Visual Basicu nie będzie jakimś strasznym upadkiem 😉

Pierwsze makro ustawia wysokość etykiety jako input od użytkownika:

```vbs
sub SetHeight

Dim oViewCursor as object
Dim s as string
Dim oStyle as object

oViewCursor = ThisComponent.CurrentController.getViewCursor()
s = oViewCursor.PageStyleName
oStyle = ThisComponent.StyleFamilies.getByName("PageStyles").getByName(s)

Dim InputVal
InputVal = InputBox("Please set label height in mm:", "SetHeight", "12")
oStyle.Height = CByte(InputVal)*100+150

end sub
```


I drugie, które ustawia szerokość dokumentu tak by zmieścił się na jednej stronie. Myślenie o stronach w kontekście etykiet na taśmie nieco pokrętne, ale cóż zrobić drukując na tak nietypowym medium.

```vbs
sub SetWidth

Dim Doc As Object
x = ThisComponent.CurrentController.PageCount

Dim oViewCursor as object
Dim s as string
Dim oStyle as object

oViewCursor = ThisComponent.CurrentController.getViewCursor()
s = oViewCursor.PageStyleName
oStyle = ThisComponent.StyleFamilies.getByName("PageStyles").getByName(s)

oStyle.IsLandscape = True

Dim I
For I=1 To 20000 Step 20
  oStyle.Width = I*10
  If ThisComponent.CurrentController.PageCount = 1 Then
    Exit For
  End If
Next

end sub
```


Żeby móc łatwo wywołać świeżo stworzone makra można je dodać jako przyciski do interfejsu Writera. Jak się okazuje sam dokument ODT może zawierać customowe menu. <figure class="wp-block-image size-large is-resized">

![Aby dodać przycisk menu dostępny w konkretnym dokumencie (zapisany w pliku) wystarczy wybrać _Tools/Customize_, a następnie zmienić _Scope_ na dokument.](/wp-content/uploads/2020/05/libreoffice-customize.jpg) 

Pozostaje jedynie podpisać cyfrowo dokument tak, żeby LibreOffice nie krzyczał na nas, że w dokumencie są makra, a makra to jak wiadomo w 99% wirusy.

  
Aby to osiągnąć, skorzystałem z cert stora z Firefoxa gdzie mam załadowany certyfikat osobisty do podpisywania emaili.<

![Aby wybrać skąd LibreOffice będzie brał certyfikaty, należy wybrać _Tools/Options_ a następnie otworzyć widok _Security_ a w nim _Certificate..._](/wp-content/uploads/2020/05/libreoffice-certpath.jpg)

Ważna uwaga szczególnie dla ubuntowców - LibreOffice musi być zainstalowany z pakietu deb, a nie ze snapa - w przeciwnym wypadku wystąpi spory problem z uprawnieniami.

Teraz w menu _File/Digital Signatures_ należy już tylko podpisać dokument certyfikatem mającym flagę _sign_ i gotowe! Przy pierwszym uruchomieniu dokumentu zostaniemy zapytani czy zaufać podpisowi i włączyć makra.

Jeśli należysz do osób leniwych, ale ufających ludziom z internetu, którzy sugerują pobranie dokumentu worda z makrami to zapraszam - [**DymoTape.odt**][3]. Żeby nie było - jest podpisany - jak pewnie wiele wirusów. Ale dla ludzi leniwych, ale trochę udających bezpiecznych lub bezgranicznie ufających właścicielom domen dsinf.net i skowron.ski zamieszczam ścieżkę do mojego certyfikuatu do podpisywania maila - https://skowron.ski/cert.pem

Ludziom przejmującym się bezpieczeństwem pozostaje zbudowanie własnego dokumentu ODT w oparciu o wskazówki 😉

 [1]: https://github.com/danielskowronski/DymoTeaLabel
 [2]: https://www.gnu.org/software/enscript/
 [3]: /wp-content/uploads/2020/05/DymoTape.odt