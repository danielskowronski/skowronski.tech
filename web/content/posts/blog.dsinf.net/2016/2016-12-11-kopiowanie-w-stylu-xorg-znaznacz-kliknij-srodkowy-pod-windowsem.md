---
title: Kopiowanie w stylu Xorg (znaznacz-kliknij środkowy) pod Windowsem
author: Daniel Skowroński
type: post
date: 2016-12-11T01:03:13+00:00
summary: 'Xorg posiada dwa schowki - jeden znany wszystkim - Ctrl+C/Ctrl+V, a także ten dla niego specyficzny - zaznacz/kliknij środkowy klawisz myszy. Ten drugi jest znacznie szybszy bo nie odrywamy ręki od myszy przy manipulowaniu tekstem. No i wszystko fajnie aż człowiek przesiada się na Windowsa bo tu ta metoda nie działa.'
url: /2016/12/kopiowanie-w-stylu-xorg-znaznacz-kliknij-srodkowy-pod-windowsem/
tags:
  - windows
  - xorg

---
Xorg posiada dwa schowki - jeden znany wszystkim - Ctrl+C/Ctrl+V, a także ten dla niego specyficzny - zaznacz/kliknij środkowy klawisz myszy. Ten drugi jest znacznie szybszy bo nie odrywamy ręki od myszy przy manipulowaniu tekstem. No i wszystko fajnie aż człowiek przesiada się na Windowsa bo tu ta metoda nie działa.

Uznałem że czemu by nie napisać takiej aplikacji samemu przy użyciu WinApi w C# - miło i przyjemnie. Teoretycznie wysłanie komunikatu `WM_GETTEXT` i odebranie stringa (tak jak jest to opisane na https://social.msdn.microsoft.com/Forums/windows/en-US/1dc356e6-9441-44de-9eda-247003fa6ef5/copy-selected-text-from-any-window?forum=winformsapplications) powinno dać radę. Ale Windows to Windows - okazuje się że ta metoda działa tylko przy polach tekstowych korzystających z API windowsowego - czyli wszystko co nie-natywnie-windowsowe (chociażby gtk czy własny silnik renderowania w przeglądarkach) nie zadziała bo to nie jest "tekst". Ciekawostka - czasem zostanie zwrócony tytuł okna. Podobnie `WM_COPY` - jeśli aplikacja nie obsługuje komunikatu kopiowania to nie stanie się nic. Można by na ślepo wysyłać `Ctrl+C`  cały czas, ale no... gdzie tu wydajność albo bezpieczeństwo w przypadku okien terminalowych reagujących na Ctrl+C?

Szukając obejść i metod jak przypiąć się do złożonego eventu zaznaczania tekstu trafiłem na gotowe rozwiązanie - co prawda sprzed 10 lat, ale działające pod Windows 7 i Windows 10 - "_True X-Mouse Gizmo" -_ dostępne tutaj: http://fy.chalmers.se/~appro/nt/TXMouse/

Jest to jeden exek, który po prostu działa 🙂