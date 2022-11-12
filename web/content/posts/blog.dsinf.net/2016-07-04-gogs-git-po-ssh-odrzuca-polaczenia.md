---
title: Gogs – git po SSH odrzuca połączenia
author: Daniel Skowroński
type: post
date: 2016-07-04T18:28:03+00:00
excerpt: 'Wspaniały i lekki zamiennik Gitlaba na pozycji lokalnego serwera Gita - <a href="https://gogs.io/">Gogs</a> umożliwia klonowanie repozytoriów i wypychanie zmian także po SSH wykorzystując w tym celu systemowego daemona SSHD. Jednak typowa ręczna instalacja zakładająca utworzenie po prostu konta git (lub gogs lub jakiegokolwiek innego dedykowanego pod tą usługę) odetnie nas od możliwości klonowania i wypychania zmian po SSH.'
url: /2016/07/gogs-git-po-ssh-odrzuca-polaczenia/
tags:
  - git
  - gogs
  - linux
  - ssh

---
Wspaniały i lekki zamiennik Gitlaba na pozycji lokalnego serwera Gita - [Gogs][1] umożliwia klonowanie repozytoriów i wypychanie zmian także po SSH wykorzystując w tym celu systemowego daemona SSHD. Jednak typowa ręczna instalacja zakładająca utworzenie po prostu konta git (lub gogs lub jakiegokolwiek innego dedykowanego pod tą usługę) spowoduje że celowo nie nadamy temu kontu hasła. A bez hasła konto jest nieaktywne - można zrobić na nie su, ale nie więcej - w szczególności połączyć się po SSH, nawet (tak jak byśmy chcieli) po kluczu SSH dodanym w interfejsie (jest to ważne żeby tak dodać klucz bo wtedy gogs sam się zajmie dodaniem niestandardowego wpisu do .ssh/authorized_keys - poprzedzi go binarką która uniemożliwi dostęp do shella i będzie udostępniać funkcjonalność zdalnego punktu dla gita).

<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2016/07/1.png" alt="1" width="1318" height="794" class="alignnone size-full wp-image-955" srcset="https://blog.dsinf.net/wp-content/uploads/2016/07/1.png 1318w, https://blog.dsinf.net/wp-content/uploads/2016/07/1-300x181.png 300w, https://blog.dsinf.net/wp-content/uploads/2016/07/1-768x463.png 768w, https://blog.dsinf.net/wp-content/uploads/2016/07/1-1024x617.png 1024w, https://blog.dsinf.net/wp-content/uploads/2016/07/1-660x398.png 660w" sizes="(max-width: 1318px) 100vw, 1318px" />  
<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2016/07/2.png" alt="2" width="1318" height="794" class="alignnone size-full wp-image-954" srcset="https://blog.dsinf.net/wp-content/uploads/2016/07/2.png 1318w, https://blog.dsinf.net/wp-content/uploads/2016/07/2-300x181.png 300w, https://blog.dsinf.net/wp-content/uploads/2016/07/2-768x463.png 768w, https://blog.dsinf.net/wp-content/uploads/2016/07/2-1024x617.png 1024w, https://blog.dsinf.net/wp-content/uploads/2016/07/2-660x398.png 660w" sizes="(max-width: 1318px) 100vw, 1318px" /> 

Rozwiązaniem tego problemu jest nadanie losowego hasła (najlepiej metodą walenia w klawiaturę) i długiego hasła, które możemy zapomnieć a następnie odblokowanie konta. Gdyby nie nadać hasła dałoby się logować bez hasła! Program passwd zapobiega temu ale warto i tak uważać. Komenda do odblokowania konta to: <span class="lang:default EnlighterJSRAW  crayon-inline " >passwd -u gogs</span>

 [1]: https://gogs.io/