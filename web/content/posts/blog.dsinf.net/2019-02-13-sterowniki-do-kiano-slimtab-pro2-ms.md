---
title: Sterowniki do Kiano Slimtab Pro2 MS
author: Daniel Skowroński
type: post
date: 2019-02-13T08:29:50+00:00
excerpt: 'Artykuł z małą dozą treści pisanej, za to chyba największym załącznikiem na blogu do tej pory - paczką sterowników do tabletu Kiano Slimtab Pro2 MS. Tabletu, który niby jest klonem Chuwi Hi8, ale nie do końca (zwłaszcza kiedy weźmiemy pod uwagę wersję dual boot).'
url: /2019/02/sterowniki-do-kiano-slimtab-pro2-ms/
featured_image: /wp-content/uploads/2019/02/kiano.png
tags:
  - drivers
  - hardware
  - windows 10

---
 

Artykuł z małą dozą treści pisanej, za to chyba największym załącznikiem na blogu do tej pory - paczką sterowników do tabletu Kiano Slimtab Pro2 MS. Tabletu, który niby jest klonem Chuwi Hi8, ale nie do końca (zwłaszcza kiedy weźmiemy pod uwagę wersję dual boot).

Historia początek bierze w probie przywrócenia Windowsa 10 do ustawień fabrycznych. Przywraca się niestety do przedfabrycznych czyli brakuje mu sterowników do rzeczy w tablecie krytycznych, a więc chociażby ekranu dotykowego czy WiFi.

Trochę szperaniny w internecie i udało mi się skompletować sterowniki, które zbackupowałem programem [DoubleDriver][1]. 

Zanim wrzucę sam listing zawartości warto wspomnieć że aby zrobić cokolwiek bez ekranu dotykowego niezbędna jest przelotka USB-C OTG bowiem USB-C ma dedykowane wyprowadzenia dla OTG i ręcznie kabla OTG z 2 kabli USB (kawałka z chłopcem USB-C i dziewczynką USB-A) nie zrobimy. Dodatkowy problem z okablowaniem to brak osobnego zasilania - niestety żaden znany mi standardowy hub USB 3.0 nie umie zasilać hosta. Zatem trzeba pilnować instalacji Windowsa i raczej zacząć od doładowania do 100% baterii.

Sterowniki w formie ZIPa (którego DoubleDriver ładnie sam importuje) dostępne są w paczce [**kiano\_slimtab\_pro2\_ms\__doubledriver.zip**][2] **[135MB]**. A w niej:

<pre crayon="false">*** Start of Report ***
--------------------------------------------------------------------------------

&lt;&lt;&lt; General >>>
--------------------------------------------------------------------------------

    Name:			Double Driver
    Version:			4.1.0 
    License:			Freeware
    Done on:			13.02.2019 08:59:11


&lt;&lt;&lt; Driver Details >>>
--------------------------------------------------------------------------------

  &lt; Intel(R) HD Graphics >

    Version:			20.19.15.4331
    Date:			11-18-2015
    Provider:			Intel Corporation
    Class:			Display
    Setup Information:		oem35.inf
    Setup Section:		iCHVM_w10
    Hardware ID:		pci\ven_8086&dev_22b0

  &lt; Realtek I2S Audio Codec >

    Version:			6.2.9600.4376
    Date:			1-19-2016
    Provider:			REALTEK
    Class:			MEDIA
    Setup Information:		oem13.inf
    Setup Section:		Codec_Device.NT
    Hardware ID:		acpi\10ec5651

  &lt; Intel SST Audio Device (WDM) >

    Version:			604.10135.2747.5232
    Date:			8-9-2015
    Provider:			Intel
    Class:			MEDIA
    Setup Information:		oem14.inf
    Setup Section:		IntelSSTAudio.NT
    Hardware ID:		acpi\808622a8

  &lt; Intel WiDi Audio Device >

    Version:			4.5.61.0
    Date:			6-8-2015
    Provider:			Intel Corporation
    Class:			MEDIA
    Setup Information:		oem25.inf
    Setup Section:		INTAUD_WEX.NT
    Hardware ID:		{4d36e96c-e325-11ce-bfc1-08002be10318}\*intaudwaveex

  &lt; Broadcom 802.11n Wireless SDIO Adapter >

    Version:			1.278.1.0
    Date:			10-31-2014
    Provider:			Broadcom
    Class:			Net
    Setup Information:		oem40.inf
    Setup Section:		BCM4343XNGSD_NT62.NTx86
    Hardware ID:		sd\vid_02d0&pid_a9a6&fn_1

  &lt; Intel Serial IO GPIO Controller >

    Version:			20.100.1830.1
    Date:			7-23-2018
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		iagpio.inf
    Setup Section:		iagpio_Device.NT
    Hardware ID:		ACPI\INT33FF

  &lt; Intel(R) Serial IO I2C ES Controller >

    Version:			20.100.1830.1
    Date:			7-23-2018
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		iai2c.inf
    Setup Section:		iai2c_Device0.NT
    Hardware ID:		ACPI\808622C1

  &lt; Intel(R) Serial IO UART Controller >

    Version:			604.10146.2653.391
    Date:			5-21-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem8.inf
    Setup Section:		iauarte_Inst.NT
    Hardware ID:		ACPI\8086228A

  &lt; Intel(R) Imaging Signal Processor 2401 >

    Version:			21.10154.6023.441
    Date:			9-9-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem9.inf
    Setup Section:		Driver.NT
    Hardware ID:		PCI\VEN_8086&DEV_22B8

  &lt; Intel(R) Trusted Execution Engine Interface >

    Version:			2.0.0.1067
    Date:			6-16-2015
    Provider:			Intel
    Class:			System
    Setup Information:		oem10.inf
    Setup Section:		TEE_DDI_WIN10
    Hardware ID:		PCI\VEN_8086&DEV_2298

  &lt; Intel(R) Serial IO SPI Controller >

    Version:			604.10146.2657.947
    Date:			6-1-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem12.inf
    Setup Section:		spi_Device_0500.NT
    Hardware ID:		ACPI\VEN_8086&DEV_228E

  &lt; Intel(R) Sideband Fabric Device >

    Version:			604.10146.2655.573
    Date:			5-26-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem16.inf
    Setup Section:		MBI_Device.NT
    Hardware ID:		ACPI\VEN_INT&DEV_33BD&REV_0002

  &lt; Intel(R) Power Management IC Device >

    Version:			604.10146.2656.541
    Date:			5-25-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem18.inf
    Setup Section:		Driver.NT
    Hardware ID:		ACPI\VEN_INT&DEV_33F4&REV_0003

  &lt; Camera Sensor OV2680 >

    Version:			604.10146.2443.5176
    Date:			8-7-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem19.inf
    Setup Section:		ov2680_Device.NTx86
    Hardware ID:		ACPI\OVTI2680

  &lt; IWD Bus Enumerator >

    Version:			4.5.61.0
    Date:			6-8-2015
    Provider:			Intel Corporation
    Class:			System
    Setup Information:		oem26.inf
    Setup Section:		IWDBus_Device.NT
    Hardware ID:		root\iwdbus

  &lt; bcmfn2 Device >

    Version:			5.93.103.20
    Date:			7-23-2015
    Provider:			Broadcom
    Class:			System
    Setup Information:		oem39.inf
    Setup Section:		bcmfn2_Device.NT
    Hardware ID:		SD\VID_02d0&PID_a9a6&FN_2

  &lt; Broadcom Serial Bus Driver over UART Bus Enumerator >

    Version:			12.0.1.960
    Date:			4-22-2016
    Provider:			Broadcom
    Class:			System
    Setup Information:		oem42.inf
    Setup Section:		Pinole2EAA.NT
    Hardware ID:		ACPI\BCM2EAA

  &lt; Bosch Accelerometer >

    Version:			1.2.0.0
    Date:			8-26-2015
    Provider:			Bosch Sensortec
    Class:			Sensor
    Setup Information:		oem4.inf
    Setup Section:		BoschAccelerometer_Inst.NT
    Hardware ID:		ACPI\BOSC0200

  &lt; Intel(R) AVStream Camera >

    Version:			21.10154.6023.441
    Date:			9-9-2015
    Provider:			Intel
    Class:			Image
    Setup Information:		oem28.inf
    Setup Section:		iacamera.NT
    Hardware ID:		video\int22b8

  &lt; Intel(R) Battery Management Device >

    Version:			604.10146.2444.9650
    Date:			12-2-2015
    Provider:			Intel Corporation
    Class:			Battery
    Setup Information:		oem20.inf
    Setup Section:		IntelBatteryManagement_Device.NT
    Hardware ID:		ACPI\INT33FE

  &lt; Logitech USB Input Device >

    Version:			1.10.78.0
    Date:			9-9-2016
    Provider:			Logitech
    Class:			HIDClass
    Setup Information:		oem33.inf
    Setup Section:		LogiLDA.NT
    Hardware ID:		usb\vid_046d&pid_c52b&mi_00

  &lt; HID Vendor-defined Collection for Goodix Touch >

    Version:			1.2.1.17
    Date:			9-30-2015
    Provider:			Shenzhen Huiding Technology Co.,Ltd.
    Class:			HIDClass
    Setup Information:		oem6.inf
    Setup Section:		customCollection.Inst.NT
    Hardware ID:		HID_DEVICE_UP:FF00_U:0001

  &lt; Chipone Touch Screen >

    Version:			18.3.40.201
    Date:			11-25-2015
    Provider:			Chipone
    Class:			HIDClass
    Setup Information:		oem2.inf
    Setup Section:		Chpntsc_Device.NT
    Hardware ID:		ACPI\CHPN0001

  &lt; Intel(R) Dynamic Platform and Thermal Framework Manager >

    Version:			8.1.10900.175
    Date:			7-24-2015
    Provider:			Intel
    Class:			DPTF
    Setup Information:		oem11.inf
    Setup Section:		EsifManager6.3.NTx86
    Hardware ID:		ACPI\INT3400

  &lt; Intel(R) Dynamic Platform and Thermal Framework Generic Participant >

    Version:			8.1.10900.175
    Date:			7-24-2015
    Provider:			Intel
    Class:			DPTF
    Setup Information:		oem15.inf
    Setup Section:		DptfAcpi.NTx86
    Hardware ID:		ACPI\INT3403

  &lt; Intel(R) Dynamic Platform and Thermal Framework Processor Participant >

    Version:			8.1.10900.175
    Date:			7-24-2015
    Provider:			Intel
    Class:			DPTF
    Setup Information:		oem17.inf
    Setup Section:		DptfCpu.NTx86
    Hardware ID:		PCI\VEN_8086&DEV_22DC

  &lt; Intel(R) Dynamic Platform and Thermal Framework Display Participant >

    Version:			8.1.10900.175
    Date:			7-24-2015
    Provider:			Intel
    Class:			DPTF
    Setup Information:		oem15.inf
    Setup Section:		DptfAcpi.NTx86
    Hardware ID:		ACPI\INT3406

--------------------------------------------------------------------------------
*** End of Report ***
</pre>

Listing jest też dostępny jako plik [kiano\_slimtab\_pro2\_ms\_\_driver\_list.txt][3]

 [1]: https://double-driver.en.softonic.com/
 [2]: /wp-content/uploads/kiano/kiano_slimtab_pro2_ms__doubledriver.zip
 [3]: /wp-content/uploads/kiano/kiano_slimtab_pro2_ms__driver_list.txt