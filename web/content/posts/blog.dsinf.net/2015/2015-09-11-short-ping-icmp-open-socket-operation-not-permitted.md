---
title: 'short; ping: icmp open socket: Operation not permitted'
author: Daniel Skowroński
type: post
date: 2015-09-11T15:59:17+00:00
summary: 'Obecne wersje Linuksów wykazują tendencję do zgłaszania  `ping: icmp open socket: Operation not permitted` kiedy próbujemy pingować z konta nie-roota. Fixem jest użycie suid czyli wykonywanie z prawami właściciela pliku (jest nim root) -  `chmod +s /bin/ping`.'
url: /2015/09/short-ping-icmp-open-socket-operation-not-permitted/

---
Obecne wersje Linuksów wykazują tendencję do zgłaszania `ping: icmp open socket: Operation not permitted` kiedy próbujemy pingować z konta nie-roota. Fixem jest użycie suid czyli wykonywanie z prawami właściciela pliku (jest nim root) - `chmod +s /bin/ping`.