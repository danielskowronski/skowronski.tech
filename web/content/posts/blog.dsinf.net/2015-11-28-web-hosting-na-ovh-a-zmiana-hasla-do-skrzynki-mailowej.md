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
Ufając w niezawodność OVH po pozytywnych doświadczeniach z VPSami, domenami i zwykłym hostingiem postanowiłem wdrożyć klientowi kompleksowy webhosting właśnie na OVH. Jedną z pod-usług był hosting skrzynek mailowych &#8211; najprostszy jak się da. Wszystko pięknie, nawet narzędzie do migracji ze starej infrastruktury (imapCopy) dostępne przez API (http://api.ovh.com) &#8211; zatem wszystko fajnie. Aż jeden z użytkowników klienta zgłasza się z trudnym pytaniem &#8222;a gdzie mogę zmienić hasło?&#8221;.  
Szukam i faktycznie &#8211; nie da się po stronie użytkownika końcowego. Koleżanka zadzwoniła nawet udając blondynkę do pomocy technicznej OVH i usłyszała, że ich hosting jest przeznaczony &#8222;dla klientów biznesowych, a oni stosują własne polityki haseł&#8221;. No cóż. W panelu admina oczywiście taka opcja jest. Jest też opcja wydelegowania zewnętrznego admina maili &#8211; nadaje się innemu kontu uprawnienia do zarządzania wszystkimi mailami (ale to odpada), w starym panelu (nieśmiertelnym managerv3) można lepiej &#8211; bo per konto &#8211; czyli enduser zakładałby sobie konto w OVH żeby móc zmienić sobie hasło do skrzynki mailowej &#8211; nadal słabo.  
Aż naszedł mnie pomysł na sprawdzenie czy to API nie wystawia opcji zmiany hasła &#8211; wystawia. Zatem trzeba naklepać skrypt który sprawdza stare hasło po IMAPie i zmienia nowe przez API logując się kontem OVH które ma dostęp tylko do maili. Przy obiadku ze współpracownikami naszło mnie, że przecież nie ja pierwszy mam taki problem &#8211; no i rzecz jasna na githubie jest rozwiązanie mojego problemu https://github.com/theclimber/ovhmail-password Jest to skrypt PHP. Początkowo wgrałem go do starej infrastruktury (hosting www jeszcze nie zmigrowany) i tam się załamałem &#8211; otóż były jakieś timeouty i mądry skrypt wysypał informacje do debugowania w których rozwinął zmienne w wywołaniach funkcji wyświetlając nie na ekran nie tylko to co user wysłał POSTem, ale także dane jakimi próbował łączyć się przez SOAP z API OVH &#8211; hasło plaintextem &#8211; trochę słabo. Polecam wyłączyć wyświetlanie błędów.  
A tak poza tym &#8211; to działa super.