---
title: Tryb wścibskiego administratora – podłączenie do cudzej sesji terminalowej bez zgody i hasła
author: Daniel Skowroński
type: post
date: 2016-04-21T19:24:45+00:00
excerpt: Są takie sytuacje kiedy trzeba zweryfikować co robi użytkownik, albo sprawdzić co się dzieje na koncie na którym coś nie działa (dziwne, przecież u nas działa!) na Windows Server.
url: /2016/04/tryb-wscibskiego-administratora-podlaczenie-do-cudzej-sesji-terminalowej-bez-zgody-i-hasla/
tags:
  - windows server

---
Są takie sytuacje kiedy trzeba zweryfikować co robi użytkownik, albo sprawdzić co się dzieje na koncie na którym coś nie działa (dziwne, przecież u nas działa!) na Windows Server.

Pierwsze podejście to użycie menadżera zadań, zakłądki użytkownicy i kliknięcie "podłącz" - ale to działa jak zwykłe podpięcie zdalnym pulpitem i prosi nas o hasło. Co więcej wyrzuca oryginalną sesję.

Potrzebujemy wpiąć się w trybie shadow. Jak to zrobić? Najpierw trzeba nadać sobie uprawnienia w edytorze zasad grupy (gpedit.msc): konfiguracja komputera -> szablony administracyjne -> składniki systemu windows -> usługi pulpitu zdalnego -> host sesji -> połączenie -> ustaw reguły zdalnego setrowania... -> włączone, pełna kontrola bez zgody użytkownika.

Teraz trzeba sprawdzić jakie sesje są aktywne poprzez

```cmd
query session
```


Aby się podpiąć używamy polecenia

```cmd
mstsc /shadow:<ID> /control /noConsentPrompt
```


Ostatnia flaga jest wbrew pozorom ważna - choć jesteśmy administratorem to trzeba jawnie zadeklarować chęć grzebania użytkownikowi po sesji bez jego zgody. Flaga /control pozwala włączyć/wyłączyć kontrolę - bez niej możemy bezpiecznie podglądać.

Ważna uwaga: jeśli użytkownik zakończy sesję zdalnego pulpitu (nawet bez wylogowania się) stracimy możliwość podglądu. Aha, działa rzecz jasna tylko z uprawnieniami administratora.