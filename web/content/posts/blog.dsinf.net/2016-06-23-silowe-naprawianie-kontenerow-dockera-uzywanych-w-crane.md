---
title: Siłowe naprawianie kontenerów dockera używanych w crane
author: Daniel Skowroński
type: post
date: 2016-06-23T07:51:14+00:00
url: /2016/06/silowe-naprawianie-kontenerow-dockera-uzywanych-w-crane/
tags:
  - crane
  - docker

---
Czasem zdarza się że przy przełączaniu się miedzy projektami które używają tych samych obrazów dockera którymi zarządzamy przy pomocy crane kontenery wariują. Siłowe rozwiązanie problemu które mi wiele razy pomogło sprowadza się do ubicia wszystkich kontenerów a potem ich usunięcia (kontenerów, nie obrazów) - jest to jednak opcja dobra tylko na deweloperskich stacjiach roboczych!

<pre class="lang:sh EnlighterJSRAW " >docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)</pre>

Jeśli chcemy dodatkowo jeszcze zniszczyć wszystkie obrazy (żeby potem je stworzyć na nowo ze źródeł) można wywołać 

<pre class="lang:sh EnlighterJSRAW " >docker rmi $(docker ps -a -q)</pre>

Ale z tym ostatnim warto uważać!