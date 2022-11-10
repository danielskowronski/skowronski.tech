---
title: 'short; ping: icmp open socket: Operation not permitted'
author: Daniel Skowroński
type: post
date: 2015-09-11T15:59:17+00:00
excerpt: 'Obecne wersje Linuksów wykazują tendencję do zgłaszania  <span class="lang:default EnlighterJSRAW  crayon-inline " >ping: icmp open socket: Operation not permitted</span> kiedy próbujemy pingować z konta nie-roota. Fixem jest użycie suid czyli wykonywanie z prawami właściciela pliku (jest nim root) -  <span class="lang:default EnlighterJSRAW  crayon-inline " >chmod +s /bin/ping</span>.'
url: /2015/09/short-ping-icmp-open-socket-operation-not-permitted/

---
Obecne wersje Linuksów wykazują tendencję do zgłaszania <span class="lang:default EnlighterJSRAW  crayon-inline " >ping: icmp open socket: Operation not permitted</span> kiedy próbujemy pingować z konta nie-roota. Fixem jest użycie suid czyli wykonywanie z prawami właściciela pliku (jest nim root) &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline " >chmod +s /bin/ping</span>.