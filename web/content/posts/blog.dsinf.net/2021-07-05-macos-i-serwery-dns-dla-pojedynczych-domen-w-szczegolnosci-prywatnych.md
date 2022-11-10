---
title: macOS i serwery DNS dla pojedynczych domen, w szczególności prywatnych
author: Daniel Skowroński
type: post
date: 2021-07-05T19:59:05+00:00
url: /2021/07/macos-i-serwery-dns-dla-pojedynczych-domen-w-szczegolnosci-prywatnych/
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1
tags:
  - dns
  - intranet
  - macos

---
Problem dość częsty w intranetach dostępnych jedynie po VPN &#8211; jak wstrzyknąć resolver DNS działający na pojedynczym połączeniu sieciowym, tak aby klient rozwiązywał nazwy domenowe z niepublicznymi/prywatnymi TLD (czyli poza root DNSami). 

Na macOS jest to dość nietrywialne, jeśli używamy systemowego klienta VPN, niekoniecznie bowiem system będzie przestrzegał podanych po IPsec-u DNSów. Można jednak ustawić specyficzne serwery dla konkretnych domen w sposób następujący: w folderze `/private/etc/resolver/` należy stworzyć plik (nazwa z grubsza dowolna) dla każdej domeny, która ma być rozwiązywana inaczej niż używając systemowych resolverów, takiej treści:

<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">domain SOME_DOMAIN
nameserver SERVER_1
nameserver SERVER_2
search_order 1
timeout 5</pre>

`SOME_DOMAIN` to może być `private` aby zająć się dowolnymi domenami `*.private`, lub `abcd.example.com` by zająć się wszystkim z puli `*.abcd.example.com`. Rzecz jasna `*` może zawierać dowolną ilość subdomen. Linii `nameserver SERVER_1` może być dowolna ilość.

Domeny będą rozwiązywane z użyciem zadanych serwerów od razu.