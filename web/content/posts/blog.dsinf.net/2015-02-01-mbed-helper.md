---
title: Mbed.org helper
author: Daniel Skowroński
type: post
date: 2015-02-01T12:37:39+00:00
excerpt: 'Mbed.org to webowe (a nawte cloudowe) IDE do tworzenia oprogramowania na sporą gamę mikrokontrolerów takich jak STM32 Nucleo F401RE. Na Linux.com jest ciekawy artykuł o tym środowisku. Proces wgrywania oprogramowania jest prosty lecz można go zautomatyzować - i to robi <a href="https://github.com/danielskowronski/mbed-helper">mbed-helper</a>.'
url: /2015/02/mbed-helper/
featured_image: https://blog.dsinf.net/wp-content/uploads/2015/02/logo256.png
tags:
  - c++
  - embedded
  - mbed.org
  - nucleo

---
Mbed.org to webowe (a nawte cloudowe) IDE do tworzenia oprogramowania na [sporą gamę][1] mikrokontrolerów takich jak [STM32 Nucleo F401RE][2]. [Na Linux.com][3] jest ciekawy artykuł o tym środowisku.

<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2015/02/nucleo-F4-300x220.jpg" alt="nucleo-F4" width="300" height="220" class="alignnone size-medium wp-image-669" srcset="https://blog.dsinf.net/wp-content/uploads/2015/02/nucleo-F4-300x220.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2015/02/nucleo-F4.jpg 500w" sizes="(max-width: 300px) 100vw, 300px" /> 

Proces wgrywania oprogramowania jest prosty - po kompilacji kodu w C++ dostajemy plik bin, ktory tzrba wgrać na urządzenie po kablu USB - przedstawia się ono jako masowe urządzenie magazynujące (pendrive). Flashowanie jest bardzo proste i przenośne zważywszy na brak wymaganych sterowników (pójdzie nawet na Gogole Chromebook'u). Wszystko zaczyna się komplikować kiedy masowo testujemy nasz soft zmieniając kod i co chwilę go flashujemy - ciągły drag&drop nie jest zbyt ciekawy. Stąd pomysł na aplikację [mbed-helper][4]. Dodatkowo często używany z tego typu mikrokontrolerami PuTTY wariuje przy restartowaniu portu szeregowego - to też zostało uwzględnione.

<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-01.png" alt="mbed-helper-01" width="486" height="184" class="alignnone size-full wp-image-673" srcset="https://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-01.png 486w, https://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-01-300x114.png 300w" sizes="(max-width: 486px) 100vw, 486px" /> 

<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-02.png" alt="mbed-helper-02" width="486" height="184" class="alignnone size-full wp-image-674" srcset="https://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-02.png 486w, https://blog.dsinf.net/wp-content/uploads/2015/02/mbed-helper-02-300x114.png 300w" sizes="(max-width: 486px) 100vw, 486px" /> 

Obecnie program działa i na dniach po testach wypuszczę paczkę instalacyjną (na razie najlepiej zrobić to samemu przez VisuaStudio lub z mbedHelper/mbedHelper/bin/Debug wyciągnąć mbedHelper.exe i mbed_putty.exe i umieścić je w jednym katalogu).

mbed_putty.exe to zwykłe putty ale utrzymanie go w jednym katalogu zapewnia stałą dostępność i jednoznaczne ubijanie programu (bez zakłócania innych instancji np. sesji SSH).

Schemat użycia jest następujący: łączymy pliki .bin z mbed-helperem (domyślnie podpina jest sobie VLC), pobrany plik otwieramy, wszystko się wgrywa, PuTTY restartuje i już nowy soft działa [albo i nie ;)] na naszym mikrokontrolerze. Wszystko konfigurowalne z GUI, tryb manualny także działa

**<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2015/02/logo256-150x150.png" alt="mbed-helper" width="32" height="32" class="alignnone size-thumbnail wp-image-659" align="left" srcset="https://blog.dsinf.net/wp-content/uploads/2015/02/logo256-150x150.png 150w, https://blog.dsinf.net/wp-content/uploads/2015/02/logo256-144x144.png 144w, https://blog.dsinf.net/wp-content/uploads/2015/02/logo256.png 256w" sizes="(max-width: 32px) 100vw, 32px" /><https://github.com/danielskowronski/mbed-helper>**

 [1]: http://developer.mbed.org/platforms/
 [2]: http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/LN1847/PF260000
 [3]: http://www.linux.com/learn/tutorials/805748-embedded-development-with-arm-mbed-on-linux/
 [4]: https://github.com/danielskowronski/mbed-helper