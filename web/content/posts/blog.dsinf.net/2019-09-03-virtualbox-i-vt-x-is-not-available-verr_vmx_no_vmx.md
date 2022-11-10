---
title: VirtualBox i „VT-x is not available (VERR_VMX_NO_VMX)”
author: Daniel Skowroński
type: post
date: 2019-09-03T07:12:11+00:00
excerpt: 'Używanie VirtualBoxa na Windowsie obok HyperV jest niemożliwe - tylko jeden hypervisor może na raz używać VT-x, czyli sprzętowego wsparcia wirtualizacji od Intela. Jednak poza brakiem włączenia wirtualizacji w BIOSie/UEFI czy aktywnym HyperV jest kilka innych czynników blokujących VirtualBoxa przed działaniem.'
url: /2019/09/virtualbox-i-vt-x-is-not-available-verr_vmx_no_vmx/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/09/Untitled.png
tags:
  - virtualbox
  - windows

---
Używanie VirtualBoxa na Windowsie obok HyperV jest niemożliwe &#8211; tylko jeden hypervisor może na raz używać VT-x, czyli sprzętowego wsparcia wirtualizacji od Intela. Jednak poza brakiem włączenia wirtualizacji w BIOSie/UEFI czy aktywnym HyperV jest kilka innych czynników blokujących VirtualBoxa przed działaniem.<figure class="wp-block-image size-large">

<img decoding="async" loading="lazy" width="1024" height="577" src="https://blog.dsinf.net/wp-content/uploads/2019/09/image-1-1024x577.png" alt="" class="wp-image-1576" srcset="https://blog.dsinf.net/wp-content/uploads/2019/09/image-1-1024x577.png 1024w, https://blog.dsinf.net/wp-content/uploads/2019/09/image-1-300x169.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/09/image-1-768x433.png 768w, https://blog.dsinf.net/wp-content/uploads/2019/09/image-1.png 1124w" sizes="(max-width: 1024px) 100vw, 1024px" /> <figcaption>Lokalizacja ustawień funkcji systemu Windows</figcaption></figure> 

Aby wyłączyć wszystko co związane z HyperV w ustawieniach funkcji systemu Windows (w &#8222;klasycznym&#8221; panelu sterowania) należy odznaczyć poniższe i zatwierdzić reboot:

  * Guarded Host
  * **HyperV**
  * **Virtual Machine Platform**
  * Windows Defender Application Guard
  * **Windows Hypervisor Platform**
  * Windows Sandbox

Jeśli jednak po reboocie nadal VirtualBox wyrzuca komunikat **VERR\_VMX\_NO_VMX __**należy pozbyć się _Device Guarda_.

Aby to uczynić należy pobrać od Microsoftu [**Device Guard and Credential Guard hardware readiness tool**][1], a następnie w Powershellu z uprawnieniami administratora uruchomić skrypt z rozpakowanego zipa:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">Set-ExecutionPolicy AllSigned
.\DG_Readiness_Tool_v3.6.ps1 -Disable -AutoReboot</pre>

Po automatycznym rebopocie system zada nam dwa pytania &#8211; czy na pewno chcemy wyłączyć Device Guard oraz Credentials Guard. Pytania będą miały styl starego bootloadera Windowsowego (z ery siódemki &#8211; biały tekst na czarnym tle, zatwierdzanie klawiszem F3). <figure class="wp-block-image size-large">

<img decoding="async" loading="lazy" width="401" height="374" src="https://blog.dsinf.net/wp-content/uploads/2019/09/image-2.png" alt="" class="wp-image-1579" srcset="https://blog.dsinf.net/wp-content/uploads/2019/09/image-2.png 401w, https://blog.dsinf.net/wp-content/uploads/2019/09/image-2-300x280.png 300w" sizes="(max-width: 401px) 100vw, 401px" /> </figure> 

Po automatycznym rebopocie system zada nam dwa pytania &#8211; czy na pewno chcemy wyłączyć Device Guard oraz Credentials Guard. Pytania będą miały styl starego bootloadera Windowsowego (z ery siódemki &#8211; biały tekst na czarnym tle, zatwierdzanie klawiszem F3). 

Po tych operacjach VirtualBox powinien mieć uwolnione VT-x i działać poprawnie.

 [1]: https://www.microsoft.com/en-us/download/details.aspx?id=53337