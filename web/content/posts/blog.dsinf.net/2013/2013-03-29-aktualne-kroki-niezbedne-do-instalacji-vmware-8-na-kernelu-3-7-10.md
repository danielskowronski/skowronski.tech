---
title: Aktualne kroki niezbędne do instalacji VMware 8 na Kernelu 3.7.10
author: Daniel Skowroński
type: post
date: 2013-03-29T13:02:25+00:00
url: /2013/03/aktualne-kroki-niezbedne-do-instalacji-vmware-8-na-kernelu-3-7-10/
tags:
  - linux
  - vmware

---
<!--break-->Jak zawsze niezbędna jest instalacje kernel-devel i/lub kernel-source oraz aktualizacja bieżącego jądra (bowiem często oże sie zdarzyć, że mamy źródła nowsze niż jądro). Potem reset, żeby kompilować ze źródeł do odpalonego kernela. Meritum, czyli przesunięcie version.h:

```bash
cp /usr/src/linux-3.7.10-1.1-obj/x86_64/desktop/include/generated/uapi/linux/version.h /lib/modules/$(uname -r)/build/include/linux

```


Komenda powinna działać po zmodyfikowaniu źródła dla wszystkich kerneli rodziny 3.7.

Jeszcze tylko instalacja modułów:

```bash
cd /usr/lib/vmware/modules
wget http:// pavlinux.ru/vmware/8.0.3/source.tar.lzma #md5 =  e37e41a818a47ec868bdb493197aaf63
tar -xf source.tar.lzma
vmware-modconfig --console --install-all

```




źródło: [http://pavlinux.ru/vmware/8.0.3/](http://pavlinux.ru/vmware/8.0.3/)

źródło: [http://communities.vmware.com/message/2188131](http://communities.vmware.com/message/2188131)
