---
title: Android a wieloużytkownikowość
author: Daniel Skowroński
type: post
date: 2012-10-28T16:46:04+00:00
url: /2012/10/android-a-wielouzytkownikowosc/
tags:
  - android

---
Coś, czego stockowo mi brakowało na Androidowym tablecie (zresztą tablet od apple też go fabrycznie nie ma) - obsługa kont użytkowników. Na telefonie też byłaby to fajna opcja, kiedy zostawiamy nasze cudnie skonfigurowane cacko na wierzchu lub też chcemy dać komuś do zabawy. 

Jest na to kilka rozwiązań. Pierwszym i najłatwiej znajdowywalnym jest zewnętrzna aplikacja (oczywiście wymagająca uprawnień roota), taka jak _[SwitchMe Root Multi Users Key][1]_. Ale poza tym, że jest płatna dla więcej niż dwóch profili (a my nie piracimy, czyż nie?) to do przełączania wymaga restartu, co w użytkowaniu przez kilku ludzi (a nie jako sandbox, czy tryb dla gości) może być irytujące. 

**Komenda pm**  
Z pomocą przyjdzie nam jednak sam system Android - w wersji conajmniej JellyBean 4.1.1 (tak, jest już 4.1.2 i nie jest to funkcjonalność dla niej nowa). Aby uzyskać dostęp do wbudowanego zarządzania profilami wystarczy wydać komendę su, a potem **pm** (zapewne skrót od _profile menagement_).  
Najbardziej ekscytujące zapewne będzie od razu doanie nowego użytkownika poleceniem: `pm create-user nazwa_użytkownika`

Aby przełączyć profil wystarczy przytrzymać przycisk zasilania i z menu wybrać nazwę użytkownika. Warto zwrócić uwagę, że użytkownik _Primary_ to podstawowe konto, któremu nazwy zmienić nie możemy. Aby uwolnić pełen potencjał tej zmiany należy zresetować telefon. Ale tylko raz. Spowoduje to, utworzenie profilu dla drugiego użytkownika - wówczas nie będzie miał dostępu do naszego Facebooka, czy poczty.

Nasuwa się tu pytanie o zabezpieczenia. Otóż drugi użytkownik nie może skorzystać z naszych kont, ma zupełnie oddzielne ustawienia i dane aplikacji. Co do specyficznych aplikacji telefonu - rejestr połączeń jako powiązany z kontaktami będzie niedostępny (a konkretniej trzeba połączyć się z kontem Google), natomiast jedyne, co jest dostępne to SMSy. Tu nic poza dowolnym AppLockerem nie poradzimy. Ważna uwaga - ten AppLocker możemy uaktywnić <iu>tylko</u> dla tego konta, więc my nie będziemy musieli się bawić w żadne hasła.  
Ale gość może także wcisnąć przycisk zasilania i się przełączyć (co nie jest takie oczywiste, ale jednak). Wystarczy ustawić blokadę wzorem, hasłem, czy PINem. Face Unlocka nie polecam - ostatnio kolega testował i nie dał rady oblokować, natomiast moja twarz podołała ;).

Dodatkowo możemy prosto skasować użytkownika (pamiętając od numeracji od 0): `pm remove-user 1`

lub z mniejszymi skutkami wylistować użytkowników wraz z ich identyfikatorami: `pm list-users`

Zmiana nazwy istniejącego profilu wymaga pogrzebania w plikach XML z katalogu `/data/system/users`

**Podsumowywując**

  * Komenda pm świetnie nadaje się do zabezpieczania telefonu przed zostawieniem go na widoku dowcipnisiów lub dania go do ręki - użytkownikowi iphone'a, małemu dziecku lub pomysłowym kolegom, którzy są zdolni zmienić język systemu i pozamieniać nazwy kontaktów
  * Znajdzie też swoje zastosowanie w uczynieniu z tabletu pod kotrolą zielonego robota urządzenia rodzinnego bez obawy, że ktoś będzie grzebał w poczcie, czy Facebooku
  * Na kancie testera/gościa, które warto mieć należy zablokować jakimkolwiek programem przede wsyztskim aplikacje root'a, ustawienia warto, ale nie trzeba i koniecznie SMSy - to jedyna aplikacja współdzielona do odczytu. No oczywiście telefon i wspomniane SMSy należy zablokować jeśli nie chcemy mieć kłopotu na koniec okresu rozliczeniowego
  * Metoda podobno jest eksperymentalna, ale do tej pory nie zdarzyło mi się odczuć problemów. Więc czujcie się ostrzeżeni
  * Raz jeszcze - aby nowy profil był oddzielny trzeba telefon/tablet zresetować. Ale tylko raz.</br /> </ul>

 [1]: https://play.google.com/store/apps/details?id=fahrbot.apps.switchme.key&hl=pl