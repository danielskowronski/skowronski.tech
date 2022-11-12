---
title: VPN na telewizorze z webOS
author: Daniel Skowroński
type: post
date: 2019-05-02T14:30:09+00:00
excerpt: 'Problem każdego ze smart TV na którym nie ma natywnej obsługi VPNa - jak oglądać seriale, filmy albo "hińskie bajki" które są tylko na amerykańskim Netflixie czy Amazon Prime. Można oczywiście podłączyć laptopa czy peceta po HDMI, ale nie po to mamy telewizor żeby zastanawiać się czy starczy nam złączy HDMI w komputerze czy kombinować z hubami HDMI.'
url: /2019/05/vpn-na-telewizorze-z-webos/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/05/hw-demo.jpg
tags:
  - hacking
  - hardware
  - lg
  - linux
  - netflix
  - tv
  - vpn

---
 

Problem każdego ze smart TV na którym nie ma natywnej obsługi VPNa - jak oglądać seriale, filmy albo "hińskie bajki" które są tylko na amerykańskim Netflixie czy Amazon Prime. 

Można oczywiście podłączyć laptopa czy peceta po HDMI i zainstalować na nim jakiś program do sterowania z telefonu (typu [Unified Remote][1]), ale nie po to mamy telewizor żeby zastanawiać się czy starczy nam złączy HDMI w komputerze czy kombinować z hubami HDMI.

Rozwiązanie pierwsze (bo mam jeszcze jeden pomysł w zanadrzu) wykorzystuje fakt że od jakiegoś czasu po skończeniu starego projektu kurzył mi się w szufladzie **mały komputerek typu Raspberry PI - NanoPI M1** konkretnie.

Plan jest prosty: podłączyć do niego drugą kartę sieciową (taka na USB to rzecz wybitnie tania, a i tak te 80-90mbps osiągniemy), wpiąć go pomiędzy router a telewizor, włączyć najprościej jak się da routing i dodać VPNa. <figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="779" src="http://blog.dsinf.net/wp-content/uploads/2019/05/hw-demo-1024x779.jpg" alt="" class="wp-image-1508" srcset="https://blog.dsinf.net/wp-content/uploads/2019/05/hw-demo.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/05/hw-demo-300x228.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/05/hw-demo-768x584.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

W moim wypadku dostawcą jest [NordVPN][2] (kupiłem go zanim Niebezpiecznik zaczął go strasznie promować.) A jest tani przy 3 letnim planie i ma sporo serwerów które dość rzadko mają problemy z netflixem. Przynajmniej amerykańskim. Ale to już zaciekłość Netflixa - kiedyś odkryłem że wszystkie dostępne lokalizacje w korpo-VPNie zrzucają na netflixie na USA. 

Dodatkową zaletą NordVPNa jest to że na Linuksie mamy gotową binarkę - szczerze powiedziawszy umarłem przy próbie postawienia IPseca

Jeszcze tylko WebUI i gotowe.<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1024" height="454" src="https://blog.dsinf.net/wp-content/uploads/2019/05/webui-demo-1024x454.jpg" alt="" class="wp-image-1511" srcset="https://blog.dsinf.net/wp-content/uploads/2019/05/webui-demo-1024x454.jpg 1024w, https://blog.dsinf.net/wp-content/uploads/2019/05/webui-demo-300x133.jpg 300w, https://blog.dsinf.net/wp-content/uploads/2019/05/webui-demo-768x340.jpg 768w, https://blog.dsinf.net/wp-content/uploads/2019/05/webui-demo.jpg 1352w" sizes="(max-width: 1024px) 100vw, 1024px" /> </figure> 

#### Całość konfiguracji opisałem na Githubie -  
<https://github.com/danielskowronski/nordvpn-on-webos-via-linux-box>

 [1]: https://www.unifiedremote.com/
 [2]: https://nordvpn.com/