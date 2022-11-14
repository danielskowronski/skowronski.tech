---
title: Usługa SBCore i co z nią zrobić
author: Daniel Skowroński
type: post
date: 2013-04-21T21:23:40+00:00
url: /2013/04/usluga-sbcore-i-co-z-nia-zrobic/
tags:
  - windows
  - windows 2003

---
Zebrało mi się na instalację Windowsa Server 2003 SBS, czyli Small Business Server w celu próby odratowania IPATa (_Intel Platform Administration Technology_) w pewnej sieci - twórcy tego systemu chcieli chyba, ażeby system chodził jedynie w MEN-owskich pracowniach z serii 2008. Wszystko pięknie, aż tu system się sam **wyłącza**...  
<!--break-->

Pomysł na zmuszenie użytkownika systemu do uczynienia go koniecznie kontrolerem domeny AD i to podstawowym i jedynym w sieci jest lekkim przegięciem. Twórcy chyba nie przewidzieli, że _Small Business_ może być tak _small_, że domena jest zbędna, ale trudno. Przegięciem po całości jest wyłączanie systemu bez najmniejszego ostrzeżenia! No, chyba, że za ostrzeżenie uznać wpis do dziennika "_This computer must be configured as a domain controller. It will be shut down in 30 minutes. To prevent this computer from shutting down, run Setup on the disk that you used to install the operating system to configure the computer as a domain controller._"...  
Początkowo system trafiał akurat kiedy był zahibernowany - po wybudzeniu i zalogowaniu ni z tego ni z owego się wyłączał - pomyślałem, że coś siadło przy hibernacji, nie zwróciłem uwagi. Aż w końcu zajrzałem do dziennika systemowego, a tam "**_The server was shut down because it did not comply with the EULA. For more information, contact Microsoft._**".  
Zamurowało mnie.

Pierwszy odruch - co to, SBS jest wredniejszy bez aktywacji niż Enterprise? Okazuje się, że nie. Jak to z Microsoftem bywa niespełnienie EULA to akurat nie dokończenie instalacji (czyli przerwanie po pierwszej płycie) - "_must be a domain controller and hold all FSMO roles for the domain_". Niech im będzie, ale "**_If the integrated setup is not completed, the SBCore service will initiate a shut down of the server._**" to szczyt dziwnego podejścia do użytkownika.

Po co komu kontroler AD na systemie, który ma przeżyć maks tydzień (jak się potem okazało trochę dłużej bo na Zwierciadła nie wróciłem do edycji 2008 R2)? Istotą problemu jest fakt, że usługi **SBCore Service** nie można zatrzymać. Bo nie.  
Prostym podejściem znalezionym gdzieś w internecie jest exe'k, który co 1 sekundę wywołuje 

```bash
taskkill /f /im sbscrexe.exe
```


a bardziej w moim destruktywnym stylu zamienienie binarki na cokolwiek - padło na xcopy. Skutki mojego podejścia były opłakane - system się resetował bo nie mógł się dogadać z usługą (liczne wpisy do dziennika "_The SBCore Service service failed to start due to the following error: The service did not respond to the start or control request in a timely fashion._"). I tu nadeszła pomoc z opcji rozruchu o której do tej pory myślałem, że jest, żeby tylko ładnie wyglądała **_Last known good configuration_**. pozwala uruchomić system i działa.

Czas na rozwiązanie bardziej przyjazne 😉  
Mijak w stylu MS, czyli zmieniamy rejestr i zabraniamy systemowi go zmienić (co dosyć dziwne, że system słucha się uprawnień, które może zmienić w dowolnym momencie, ale cieszmy się, że jest dziura pozwalająca doprowadzić system do ładu). Interesuje nas gałąź 

```bash
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SBCore
```


Wchodzimy we właściwości, uprawnienia, zaznaczamy pozycję SYSTEM i na _Full control_ stawiamy ticka przy Deny. Trzeba jeszcze dodać grupę _Administrators_ (jedyny przycisk _Add_) i zrobic na odwrót - przecież mamy móc zobaczyć wpisy i je zmieniać. Po zatwierdzeniu być może trzeba będzie wcisnąć F5 aby przeładować podgląd gałęzi. Właściwą zmianą jest ustawienie wartości 0x04 (z 0x02) dla klucza Start (typ: DWORD), czyli disabled.  
Teraz trzeba w zmienić uprawnienia pliku 

```bash
%systemroot%\system32\sbscrexe.exe
```


tak, żeby nikt nie miał do niego dostępu: Właściwości->Uparwnienia->grupa po grupie full control na Deny. I gotowe!  
Teraz można uruchomić wspomnainego 

```bash
taskkill /f /im sbscrexe.exe
```


i cieszyć się, że exe'k już się nie uruchomi.


źródło: http://social.microsoft.com/Forums/en-US/whssoftware/thread/2ba72993-ef23-437a-858e-761b5f906191