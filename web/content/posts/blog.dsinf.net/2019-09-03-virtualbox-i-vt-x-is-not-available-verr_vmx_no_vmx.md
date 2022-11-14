---
title: VirtualBox i "VT-x is not available (VERR_VMX_NO_VMX)"
author: Daniel Skowroński
type: post
date: 2019-09-03T07:12:11+00:00
excerpt: 'Używanie VirtualBoxa na Windowsie obok HyperV jest niemożliwe - tylko jeden hypervisor może na raz używać VT-x, czyli sprzętowego wsparcia wirtualizacji od Intela. Jednak poza brakiem włączenia wirtualizacji w BIOSie/UEFI czy aktywnym HyperV jest kilka innych czynników blokujących VirtualBoxa przed działaniem.'
url: /2019/09/virtualbox-i-vt-x-is-not-available-verr_vmx_no_vmx/
featured_image: /wp-content/uploads/2019/09/Untitled.png
tags:
  - virtualbox
  - windows

---
Używanie VirtualBoxa na Windowsie obok HyperV jest niemożliwe - tylko jeden hypervisor może na raz używać VT-x, czyli sprzętowego wsparcia wirtualizacji od Intela. Jednak poza brakiem włączenia wirtualizacji w BIOSie/UEFI czy aktywnym HyperV jest kilka innych czynników blokujących VirtualBoxa przed działaniem.<figure class="wp-block-image size-large">

![Lokalizacja ustawień funkcji systemu Windows](/wp-content/uploads/2019/09/image-1.png)

Aby wyłączyć wszystko co związane z HyperV w ustawieniach funkcji systemu Windows (w "klasycznym" panelu sterowania) należy odznaczyć poniższe i zatwierdzić reboot:

  * Guarded Host
  * **HyperV**
  * **Virtual Machine Platform**
  * Windows Defender Application Guard
  * **Windows Hypervisor Platform**
  * Windows Sandbox

Jeśli jednak po reboocie nadal VirtualBox wyrzuca komunikat **VERR\_VMX\_NO_VMX** należy pozbyć się _Device Guarda_.

Aby to uczynić należy pobrać od Microsoftu [**Device Guard and Credential Guard hardware readiness tool**][1], a następnie w Powershellu z uprawnieniami administratora uruchomić skrypt z rozpakowanego zipa:

```ps1
Set-ExecutionPolicy AllSigned
.\DG_Readiness_Tool_v3.6.ps1 -Disable -AutoReboot
```


Po automatycznym rebopocie system zada nam dwa pytania - czy na pewno chcemy wyłączyć Device Guard oraz Credentials Guard. Pytania będą miały styl starego bootloadera Windowsowego (z ery siódemki - biały tekst na czarnym tle, zatwierdzanie klawiszem F3).

![](/wp-content/uploads/2019/09/image-2.png)

Po automatycznym rebopocie system zada nam dwa pytania - czy na pewno chcemy wyłączyć Device Guard oraz Credentials Guard. Pytania będą miały styl starego bootloadera Windowsowego (z ery siódemki - biały tekst na czarnym tle, zatwierdzanie klawiszem F3). 

Po tych operacjach VirtualBox powinien mieć uwolnione VT-x i działać poprawnie.

 [1]: https://www.microsoft.com/en-us/download/details.aspx?id=53337