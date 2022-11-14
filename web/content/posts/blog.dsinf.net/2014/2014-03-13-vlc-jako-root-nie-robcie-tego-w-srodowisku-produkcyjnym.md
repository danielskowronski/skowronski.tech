---
title: VLC jako root – nie róbcie tego w środowisku produkcyjnym
author: Daniel Skowroński
type: post
date: 2014-03-13T17:48:55+00:00
summary: |
  Tak, są ludzie tak leniwi, że pracują na koncie roota.
  Ale są też tak wredni deweloperzy, że zmuszają użytkownikó do rekompilacji całego ogromnego pakietu jakim jest m.in. VLC ze specjalną flagą by dało się wystartować jako root...
url: /2014/03/vlc-jako-root-nie-robcie-tego-w-srodowisku-produkcyjnym/
tags:
  - linux
  - root
  - vlc

---
Tak, są ludzie tak leniwi, że pracują na koncie roota.  
Ale są też tak wredni deweloperzy, że zmuszają użytkownikó do rekompilacji całego ogromnego pakietu jakim jest m.in. VLC ze specjalną flagą by dało się wystartować jako root...

Aby rozwiązać kretyński problem z tym komunikatem:

```
VLC is not supposed to be run as root. Sorry.
If you need to use real-time priorities and/or privileged TCP ports
you can use vlc-wrapper (make sure it is Set-UID root and
cannot be run by non-trusted users first).
```


należy wykonać:

```bash
sed -i 's/geteuid//g' /usr/bin/vlc
```


Rozwiązanie obrzydliwe, ale działa. A nie warto rezygnować z fajnego VLC na rzecz innych odtwarzaczy pozbawionych takich zabezpieczeń.  
Tak, tak, tak... startowanie jako root nie jest do końca mądre, ale czasem wygodne. Ale serio, nie róbcie tego w śroodowisku produkcyjnym.