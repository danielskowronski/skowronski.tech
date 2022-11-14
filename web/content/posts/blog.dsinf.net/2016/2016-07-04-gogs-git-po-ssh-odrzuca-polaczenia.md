---
title: Gogs – git po SSH odrzuca połączenia
author: Daniel Skowroński
type: post
date: 2016-07-04T18:28:03+00:00
summary: 'Wspaniały i lekki zamiennik Gitlaba na pozycji lokalnego serwera Gita - Gogs umożliwia klonowanie repozytoriów i wypychanie zmian także po SSH wykorzystując w tym celu systemowego daemona SSHD. Jednak typowa ręczna instalacja zakładająca utworzenie po prostu konta git (lub gogs lub jakiegokolwiek innego dedykowanego pod tą usługę) odetnie nas od możliwości klonowania i wypychania zmian po SSH.'
url: /2016/07/gogs-git-po-ssh-odrzuca-polaczenia/
tags:
  - git
  - gogs
  - linux
  - ssh

---
Wspaniały i lekki zamiennik Gitlaba na pozycji lokalnego serwera Gita - [Gogs][1] umożliwia klonowanie repozytoriów i wypychanie zmian także po SSH wykorzystując w tym celu systemowego daemona SSHD. Jednak typowa ręczna instalacja zakładająca utworzenie po prostu konta git (lub gogs lub jakiegokolwiek innego dedykowanego pod tą usługę) spowoduje że celowo nie nadamy temu kontu hasła. A bez hasła konto jest nieaktywne - można zrobić na nie su, ale nie więcej - w szczególności połączyć się po SSH, nawet (tak jak byśmy chcieli) po kluczu SSH dodanym w interfejsie (jest to ważne żeby tak dodać klucz bo wtedy gogs sam się zajmie dodaniem niestandardowego wpisu do .ssh/authorized_keys - poprzedzi go binarką która uniemożliwi dostęp do shella i będzie udostępniać funkcjonalność zdalnego punktu dla gita).

![1](/wp-content/uploads/2016/07/1.png)  
![2](/wp-content/uploads/2016/07/2.png) 

Rozwiązaniem tego problemu jest nadanie losowego hasła (najlepiej metodą walenia w klawiaturę) i długiego hasła, które możemy zapomnieć a następnie odblokowanie konta. Gdyby nie nadać hasła dałoby się logować bez hasła! Program passwd zapobiega temu ale warto i tak uważać. Komenda do odblokowania konta to: `passwd -u gogs`

 [1]: https://gogs.io/