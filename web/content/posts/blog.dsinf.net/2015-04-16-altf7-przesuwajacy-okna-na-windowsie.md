---
title: Alt+F7 przesuwający okna na Windowsie?
author: Daniel Skowroński
type: post
date: 2015-04-16T07:51:23+00:00
excerpt: 'A czemu nie? Podirytowany kiedy kolejny raz okno pozostało na drugim monitorze, który wyłączyłem napisałem na szybko program na to. Dostępny na <a href="https://github.com/danielskowronski/altf7">github</a>ie.'
url: /2015/04/altf7-przesuwajacy-okna-na-windowsie/
tags:
  - 'win c#'
  - windows

---
A czemu nie? Podirytowany kiedy kolejny raz okno pozostało na drugim monitorze, który wyłączyłem napisałem na szybko program na to.

Działanie proste - naciskasz Alt+F7 i okno na wierzchu (np. to, na które przełączyłeś się alt+tab'em) i wędruje ono za kursorem aż nie klikniesz myszką. W chwili obecje działa, ale jak tylko znajdę czas dopiszę lepszą obsługę klawiatury - sterowanie strzałkami i wychodzenie z trybu przesuwania nie tylko myszką. No i pojawi się jakikolwiek instalator 😉

Technologia - C# wykorzystujący funkcje Win32 (bo się nie da zrobić na Formsach globalnych hooków i przesuwania nie swoich okienek). Co ciekawe - wygodniej się pisze tam takie niskopoziomowe rzeczy niż w C++.

[Program na githubie][1].

 [1]: https://github.com/danielskowronski/altf7