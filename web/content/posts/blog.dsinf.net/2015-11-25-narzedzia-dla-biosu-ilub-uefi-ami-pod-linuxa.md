---
title: Narzędzia dla BIOSu i/lub UEFI AMI pod Linuxa
author: Daniel Skowroński
type: post
date: 2015-11-25T08:56:53+00:00
url: /2015/11/narzedzia-dla-biosu-ilub-uefi-ami-pod-linuxa/
tags:
  - ami
  - amisce
  - bios
  - hardware
  - klaster
  - linux

---
Mając nieco doświadczenia przy grzebaniu w BIOSie i/lub UEFI od AMI z poziomu systemu operacyjnego, [a konkretniej Windowsa][1], i mając problem masowej rekonfiguracji ustawień BIOSu w [klastrze-prowizorce][2] postanowiłem poszukać odpowiedników narzędzi AMI &#8211; w szczególności AMISCE dla Linuksa. Nie ma ich w miejscach z wersjami pod Windowsa. Poszukiwany plik binarny nazywa się **SCELNX_64**. Trochę szukania i znalazłem wspaniałe źródło &#8211; strony producentów serwerów takich jak Lenovo ThinkServer oprócz driverów zawierają także narzędzia do flashowania BIOSu a te wymagają narzędzi do jego rekonfiguracji. I to są nawet bardzo aktualne wersje (sprzed kilku dni)! Żeby było zabawniej udostępniane z całą dokumentacją skopiowaną od AMI.

Linki:

  * [32-bit na stronie Lenovo][3]
  * [32-bit mirror][4]
  * [64-bit na stronie Lenovo][3]
  * [64-bit mirror][5]

Jako ciekawostkę mogę podać fakt, że po przejechaniu pliku komendą strings odnajdziemy sprytny sposób budowania modułu jądra do rozmawiania bezpośrednio z hardwarem &#8211; zahardkodowany kod źródłowy :O

 [1]: http://blog.dsinf.net/2015/08/biosuefi-ami-aptio-np-na-tabletach-z-win8-przywracanie-do-ustawien-fabrycznych/
 [2]: http://blog.dsinf.net/2015/11/klaster-prowizorka-w-kole-studentow-informatyki-uj-czesc-1/
 [3]: http://support.lenovo.com/pl/pl/downloads/ds030953
 [4]: https://mega.nz/#!SkdGSR6S!lwAWW2d3Q3JrYpePFeOv1jOKSWLRXsJSJ-Zqj9EyYxM
 [5]: https://mega.nz/#!r1dHFBSa!YyBZqUhWqawiuvzuhZIWgXtf8EDV2cCcf8T6NlAx4as