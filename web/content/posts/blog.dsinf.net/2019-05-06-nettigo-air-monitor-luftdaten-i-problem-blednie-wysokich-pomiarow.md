---
title: Nettigo Air Monitor (Luftdaten) i problem błędnie wysokich pomiarów + kondensatorowa aktualizacja
author: Daniel Skowroński
type: post
date: 2019-05-06T03:34:19+00:00
url: /2019/05/nettigo-air-monitor-luftdaten-i-problem-blednie-wysokich-pomiarow/
featured_image: https://blog.dsinf.net/wp-content/uploads/2019/05/29l193-1.png
tags:
  - hardware
  - luftdaten
  - smog

---
 

Mieszkając w Krakowie nagłe pojawienie się 350μg/m³ PM10 i więcej na domowym czujniku smogu nie powinno mnie dziwić. Ale niemal pionowy skok z kilku mikrogramów i brak potwierdzeń pomiarów na innych stacjach był mocno podejrzany.

Diagnostykę Nettigo Air Monitora (opartego na projekcie Luftdaten.info) zacząłem od przestudiowania dokumentacji sensora NovaFitnes SDS011. Nic o konserwacji czy nagłych błędnych odczytach. Postanowiłem więc przeczyścić rurkę prowadzącą do komory z laserem za pomocą sprężonego powietrza i zabezpieczeniu lekko zbyt mocnego jej wygięcia w kolanku hydraulicznym robiącym za obudowę. Po kilku godzinach dalej pomiary bez zmian.

Kolejną teorią było sprawdzenie czy winne nie jest oprogramowanie bo w okolicach skoku wartości czujnik wymagał zresetowania. Przy okazji dane wyglądały trochę jakby wartości były przemnożone przez 100. Jednak od miesięcy pracuje on na NRZ-2018-123B. Znowu pudło.

Kolejnym krokiem który podjąłem było podłączenie się pod port szeregowy po USB żeby przeanalizować komunikaty diagnostyczne. Nic nadzwyczajnego nie było widać. Poza tym że nagle wartości spadły do poprawnych. 

Tym co okazało się winne była zmiana źródła zasilania. 

Oryginalnie Nettigo Air Monitor był zasilany z 1A ładowarki USB od Apple po 2 kablach USB. Ale mniej więcej godzinę przed zdarzeniem reorganizowałem zasilanie i po drodze pojawił się dodatkowo mały hub USB 3.0. Tymczasowe usunięcie go pomogło, ale że tak czy inaczej potrzebowałem zasilić jeszcze jedno urządzenie to wymieniłem hub na aktywny z własnym zasilaczem. I o dziwo bez zmian. Problemem numer dwa okazał się przedłużacz USB z którym nagle ESP8266 będący procesorem w Lufdatenie przestał się dogadywać. A napięcie i prąd pobierany przez układ nie ulegały zmianie.

Reasumując: tak jak w większości takich urządzeń czym krótszy kabel i czym lepsze zasilanie tym lepiej.

#### Kondensatorowa aktualizacja

W komentarzu odezwał się twórca projektu z Nettigo i okazuje się że faktycznie SDS011 jest niestety czuły na jakość zasilania. Rozwiązanie w postaci kondensatora 470uF wpiętego w gniazdo zasilania rozwiązało problem w wypadku huba USB, który zidentyfikowałem jako głównego winowajcę. 

Przedłużacz USB który oryginalnie działał, a podczas pierwszych testów też okazał się podejrzany i wypadł ostatecznie z całości dalej ubija jakość pomiarów. Ale wpięcie wolto- i amperomierza USB przy pewnym wygięciu kabla pokazało 3.5V&#8230;<figure class="wp-block-image">

<img decoding="async" loading="lazy" width="1000" height="500" src="https://blog.dsinf.net/wp-content/uploads/2019/05/29l193-1.png" alt="" class="wp-image-1527" srcset="https://blog.dsinf.net/wp-content/uploads/2019/05/29l193-1.png 1000w, https://blog.dsinf.net/wp-content/uploads/2019/05/29l193-1-300x150.png 300w, https://blog.dsinf.net/wp-content/uploads/2019/05/29l193-1-768x384.png 768w" sizes="(max-width: 1000px) 100vw, 1000px" /> </figure>