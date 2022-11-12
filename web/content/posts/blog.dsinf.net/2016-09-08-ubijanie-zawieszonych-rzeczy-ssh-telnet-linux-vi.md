---
title: 'Ubijanie zawieszonych rzeczy: SSH, Telnet, Linux, vi, …'
author: Daniel Skowroński
type: post
date: 2016-09-08T19:54:04+00:00
excerpt: 'Niezbyt znane są komendy do ubijania zawieszonych połączeń SSH i Telnet a podpinanie się z innego terminala żeby wywołać killall -9 ssh jest mało profesjonalne.  Podobnie z innym oprogramowaniem. Dlatego wrzucam małe podsumowanie.'
url: /2016/09/ubijanie-zawieszonych-rzeczy-ssh-telnet-linux-vi/
tags:
  - linux
  - ssh
  - telnet
  - vi

---
Niezbyt znane są komendy do ubijania zawieszonych połączeń SSH i Telnet a podpinanie się z innego terminala żeby wywołać `killall -9 ssh` jest mało profesjonalne.  Podobnie z innym oprogramowaniem. Dlatego wrzucam małe podsumowanie:

  * **SSH: <Enter>, <Tylda ~>, <Kropka .>**  
    (warto zapoznać się w ogóle z [dokumentacją kontroli SSH][1])
  * **Telnet: <Ctrl>+<]>, "quit"**
  * **Linux: <SysRq>+REISUB**  
    (wciśnięty SysRq lub <Alt>+<PrtScr> i kolejno R (przełącza klawiaturę do trybu raw), E (SIGTERM do wszystkich procesów poza initem), I (SIGKILL do wszystkich procesów poza initem), S (synchronizuje dyski), U (przemontowuje dyski jako ro), B (wysyła rozkaz do CPU żeby zresetować komputer - wywołanie tylko tego może doprowadzić do utraty danych) - wszystkim zajmuje się debugger jądra więc _zawsze powinno_ działać; jeśli nie mamy dostępy do fizycznego terminala można wysłać rozkazy pisząc je po kolei (jako pojedyncze znaki) do pliku  `/proc/sysrq-trigger`)
  * **vi****: <Esc> :wq! _  
    lub bez zapisu: **<Esc> :q!  
**_ _lub siłowo:_ <Ctrl>+<Z>_, _ _a potem kill -9 $pid_  
**

 [1]: https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/