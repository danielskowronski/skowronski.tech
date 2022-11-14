---
title: RVM na procesorach niestandardowych (AMD Geode)
author: Daniel Skowroński
type: post
date: 2014-05-24T19:25:15+00:00
summary: 'Problem <i>Illegal intruction</i> przy instalacji RoR orzaz RVM na nietypowych procesorach (m.in. bez SSE2) można obejść wymuszając wersję 2.1.0. We wpisie podłoże problemu dla AMD Geode i szczegóły błędów kompilacji.'
url: /2014/05/rvm-na-procesorach-niestandardowych-amd-geode/
tags:
  - embedded
  - linux
  - ror

---
Jeden z moich systemów pracuje na zgrabnym nettopie wyposażonym w AMD Geode LX - Fujitsu Siemens Futro A250. Procesor ten przysparza w dzisiejszych czasach kilku problemów, gdyż nie jest zgodny z najnowszymi zestawami instrukcji. Większość systemów zakłada x86 => i686. A Geode jest zgodny z i586, a jakby tego było mało wielu developerów założyło, że niektóre instrukcje są obowiązkowe dla i586. Przez to Geode potrafi zostać zdegradowany do i486. Dlatego też prawie żadna nowoczesna dystrybucja sama z siebie nie zadziała. Ja wykorzystałem bazującą na Debianie 7 - Voyage Linux.

W większości przypadków problem z kompilacją będzie polegał na braku zestawu instrukcji SSE2. W przypadku RoR 2.1.2 stawianego za pomocą RVM nie pomogą żadne zmiany we flagach GCC, nawet `-march=geode` , czy `-march=i386`. Błędy są przeróżne, na przykład:

```
Error running '__rvm_make -j1',
showing last 15 lines of /usr/local/rvm/log/1400956522_ruby-2.1.1/make.log
compiling thread.c
compiling cont.c
compiling ./enc/ascii.c
compiling ./enc/us_ascii.c
compiling ./enc/unicode.c
compiling ./enc/utf_8.c
compiling newline.c
compiling ./missing/strlcpy.c
compiling ./missing/strlcat.c
compiling ./missing/setproctitle.c
compiling addr2line.c
compiling dmyext.c
linking miniruby
make: *** [.rbconfig.time] Illegal instruction
++ return 2
There has been an error while running make. Halting the installation.
```


**Illegal instruction** to najpoważniejszy problem. Jedyne dostępne obejście to instalacja wersji **2.1.<span style="text-decoration: underline;">`**. Nic innego nie działa 🙁

Błąd już zgłoszony: [https://github.com/wayneeseguin/rvm/issues/2850][1]

&nbsp;

 [1]: https://github.com/wayneeseguin/rvm/issues/2850 "https://github.com/wayneeseguin/rvm/issues/2850"