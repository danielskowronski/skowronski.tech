---
title: Przekierowanie portów i inne ukryte rzeczy na Ubee EVW3226 od UCP
author: Daniel Skowroński
type: post
date: 2016-05-04T15:24:49+00:00
summary: 'UPC wciska klientom modemo-routery różnych firm. Jednym z nich jest Ubee EVW3226 - czarny z małymi diodkami na froncie. Z pewnych powodów operator <del>wyciął</del> ukrył niektóre funkcjonalności takie jak przekierowanie portów, tryb DMZ czy zmiana trybu z router na bridge. Aby się do nich dostać wystarczy wejść na ścieżki tych ustawień - linki zostały wycięte z menu i tyle.'
url: /2016/05/przekierowanie-portow-i-inne-ukryte-rzeczy-na-ubee-evw3226-od-ucp/
tags:
  - hacking
  - hardware
  - routery
  - upc

---
UPC wciska klientom modemo-routery różnych firm. Jednym z nich jest Ubee EVW3226 - czarny z małymi diodkami na froncie. Wygląda on tak:  
![](/wp-content/uploads/2016/05/evw3226_front_0-1954167893.jpeg) 

&nbsp;

Z pewnych powodów operator <del>wyciął</del> ukrył niektóre funkcjonalności takie jak przekierowanie portów, tryb DMZ czy zmiana trybu z router na bridge. Aby się do nich dostać wystarczy wejść na ścieżki tych ustawień - linki zostały wycięte z menu i tyle. Odpowiednie adresy to:

[http://192.168.0.1/cgi-bin/setup.cgi?gonext=**RgAdvancedForwarding**][1]

[http://192.168.0.1/cgi-bin/setup.cgi?gonext=**RgAdvancedDmzHost**][2]

[http://192.168.0.1/cgi-bin/setup.cgi?gonext=**RgSystemSwitchMode**][3]

 [1]: http://192.168.0.1/cgi-bin/setup.cgi?gonext=RgAdvancedForwarding
 [2]: http://192.168.0.1/cgi-bin/setup.cgi?gonext=RgAdvancedDmzHost
 [3]: http://192.168.0.1/cgi-bin/setup.cgi?gonext=RgSystemSwitchMode