---
title: Skrypt do zmiany domyślnego interpetera Pythona
author: Daniel Skowroński
type: post
date: 2013-08-02T12:50:02+00:00
url: /2013/08/skrypt-do-zmiany-domyslnego-interpetera-pythona/
tags:
  - bash
  - linux
  - python

---
Python w 2008 roku doczekał się kamienia milowego - wersji 3.0 (Py3K), która jest kompletnie wstecznie-niezgodna z 2.x. Obecnie w użyciu stabilnym jest 3.3. Warty przeczytania dokument znajduje się na oficjlalnej Wiki - http://wiki.python.org/moin/Python2orPython3. Najprościej wskazać różnicę w echo - w 2.7 była to niemal dyrektywa, teraz echo stał się funkcją<!--break--> - stąd:

<pre class="EnlighterJSRAW python">echo "witaj świecie w Pythonie 2.7 - działam bez nawiasów";
echo("witaj świecie w Pythonie 3.0 - potrzebuję nawiasów");
</pre>

Dwa lata temu deweloperzy Arch Linuxa postanowilicalowicie przejść na v3 (https://www.archlinux.org/news/python-is-now-python-3/). Skutkuje to pewnymi problemami z niekatualizowanymi skryptami. Ponieważ trzymane są obie binarki (python3.3 i python2.7) wszystko można ładnie zorganizować symlinkami.

Kiedy pojawia się poblem najlepiej byłoby wykonać jakieś polecenie, które samo zmieni symlinka. I oto jest skrypt, nawet nieźle zabezpieczony:

<pre class="EnlighterJSRAW bash">#!/bin/bash
help(){
  echo "**Toggle Python version by DS**"
  echo "  Switches used interpreter by changing links in /usr/bin - needs root"
  echo "  Usage: $0 [2,3]"
}

check_symlink(){
  if [ ! -h /usr/bin/python ]
  then
    echo "ERROR: in your environment /usr/bin/python is not symlink!"
    echo "ERROR: to prevent serious damage program aborted"
    exit
  fi
}
check_error(){
#checks if last command returned error end stops script on it
  if [ $? -ne 0 ]
  then
    echo "ERROR";
    exit
  fi
}

toggle2(){
  check_symlink
  sudo rm /usr/bin/python
  check_error
  sudo ln -s /usr/bin/python2.7 /usr/bin/python
  check_error
  echo "OK, now default Python is ver 2";
}
toggle3(){
  check_symlink
  sudo rm /usr/bin/python
  check_error
  sudo ln -s /usr/bin/python3 /usr/bin/python
  check_error
  echo "OK, now default Python is ver 3";
}

if [ -z $1 ]
then
  help
elif [ $1 == "2" ]
then
  toggle2
elif [ $1 == "3" ]
then
  toggle3
else
  help
fi
</pre>