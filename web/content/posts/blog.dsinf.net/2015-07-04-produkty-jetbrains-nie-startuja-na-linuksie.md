---
title: Produkty JetBrains nie startują na Linuksie
author: Daniel Skowroński
type: post
date: 2015-07-04T21:29:31+00:00
excerpt: |
  Produkty JetBrains nie na każdym Linuksie startują od razu.<br />
  Rozwiązania problemów "libgcj: Error opening agent library. libgcj: couldn't create virtual machine" na Linuksach i "/usr/sbin/alternatives is needed by jdk1.8.0" na openSuse.
url: /2015/07/produkty-jetbrains-nie-startuja-na-linuksie/
tags:
  - jetbrains
  - linux
  - opensuse

---
Produkty JetBrains (PHPstorm, WebStorms, InielliJ Idea, CLIon, PyCharm, RubyMine...) wymagają Javy od Oracle i nie współpracują z OpenJDK - dlatego najpierw trzeba ją pobrać z oracle.com. Jeśli dalej nie startuje i wyjście konsoli przypomina:

```
java version "1.5.0"
gij (GNU libgcj) version 4.8.3 20141208 [gcc-4_8-branch revision 218481]
Copyright (C) 2007 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
libgcj: Error opening agent library.
libgcj: couldn't create virtual machine
```


To winne jest niewykrywanie realnej wersji Javy. Najprościej dopisać linijkę:

```bash
JDK_HOME=/usr/java/latest
```


do pliku sh odpalającego każdy produkt (np. `/opt/jetbrains/0xdbe/bin/0xdbe.sh`).

&nbsp;

Dodatkowo na openSuse 13.2 JKD/JRE od Oracle z paczki RPM nie instaluje się od razu  narzekając na (teoretycznie spełnione) zależności

```bash
/usr/sbin/alternatives is needed by jdk1.8.0
```


Trzeba nam dwóch paczek - [alternatives][1] i [update-alternatives][2].

 [1]: http://software.opensuse.org/package/alternatives
 [2]: http://software.opensuse.org/package/update-alternatives