---
title: Web hosting na OVH a zmiana hasła do skrzynki mailowej
author: Daniel Skowroński
type: post
date: 2015-11-28T03:26:27+00:00
url: /2015/11/web-hosting-na-ovh-a-zmiana-hasla-do-skrzynki-mailowej/
tags:
  - email
  - hosting
  - ovh

---
Ufając w niezawodność OVH po pozytywnych doświadczeniach z VPSami, domenami i zwykłym hostingiem postanowiłem wdrożyć klientowi kompleksowy webhosting właśnie na OVH. Jedną z pod-usług był hosting skrzynek mailowych - najprostszy jak się da. Wszystko pięknie, nawet narzędzie do migracji ze starej infrastruktury (imapCopy) dostępne przez API (http://api.ovh.com) - zatem wszystko fajnie. Aż jeden z użytkowników klienta zgłasza się z trudnym pytaniem "a gdzie mogę zmienić hasło?".  
Szukam i faktycznie - nie da się po stronie użytkownika końcowego. Koleżanka zadzwoniła nawet udając blondynkę do pomocy technicznej OVH i usłyszała, że ich hosting jest przeznaczony "dla klientów biznesowych, a oni stosują własne polityki haseł". No cóż. W panelu admina oczywiście taka opcja jest. Jest też opcja wydelegowania zewnętrznego admina maili - nadaje się innemu kontu uprawnienia do zarządzania wszystkimi mailami (ale to odpada), w starym panelu (nieśmiertelnym managerv3) można lepiej - bo per konto - czyli enduser zakładałby sobie konto w OVH żeby móc zmienić sobie hasło do skrzynki mailowej - nadal słabo.  
Aż naszedł mnie pomysł na sprawdzenie czy to API nie wystawia opcji zmiany hasła - wystawia. Zatem trzeba naklepać skrypt który sprawdza stare hasło po IMAPie i zmienia nowe przez API logując się kontem OVH które ma dostęp tylko do maili. Przy obiadku ze współpracownikami naszło mnie, że przecież nie ja pierwszy mam taki problem - no i rzecz jasna na githubie jest rozwiązanie mojego problemu https://github.com/theclimber/ovhmail-password Jest to skrypt PHP. Początkowo wgrałem go do starej infrastruktury (hosting www jeszcze nie zmigrowany) i tam się załamałem - otóż były jakieś timeouty i mądry skrypt wysypał informacje do debugowania w których rozwinął zmienne w wywołaniach funkcji wyświetlając nie na ekran nie tylko to co user wysłał POSTem, ale także dane jakimi próbował łączyć się przez SOAP z API OVH - hasło plaintextem - trochę słabo. Polecam wyłączyć wyświetlanie błędów.  
A tak poza tym - to działa super.