---
title: SpamAssasin i HTTPS_HTTP_MISMATCH
author: Daniel Skowroński
type: post
date: 2016-12-04T20:54:19+00:00
excerpt: Ostatnio przeglądając folder w skrzynce Outlookowej z której moja organizacja robi brutalne forwardy do kilku osób natknąłem się na to że pewien normalny, zdrowy wątek w którym uczestniczyli ludzie na co dzień udzielający się w korespondencji, który trafił do spamu. Postanowiłem więc sprawdzić nagłówki...
url: /2016/12/spamassasin-i-https_http_mismatch/
tags:
  - https
  - mail
  - outlook
  - spam
  - spamassasin

---
Ostatnio przeglądając folder w skrzynce Outlookowej z której moja organizacja robi brutalne forwardy do kilku osób natknąłem się na to że pewien normalny, zdrowy wątek w którym uczestniczyli ludzie na co dzień udzielający się w korespondencji, który trafił do spamu. Postanowiłem więc sprawdzić nagłówki:

```
X-Spam-Status: Yes, score=5.82 tagged_above=-2 required=4.7
	tests=[BAYES_99=3.5, BAYES_999=0.2, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, FREEMAIL_ENVFROM_END_DIGIT=0.25,	FREEMAIL_FROM=0.001,
 HTML_MESSAGE=0.001, HTTPS_HTTP_MISMATCH=1.989,	RCVD_IN_DNSWL_NONE=-0.0001,
 RCVD_IN_MSPIKE_H3=-0.01,	RCVD_IN_MSPIKE_WL=-0.01,
 SPF_PASS=-0.001] autolearn=disabled
```


Czyli winny był filtr oparty o naiwnym klasyfikatorze Bayesa 99% plus HTTPS\_HTTP\_MISMATCH. Przejrzałem całą wiadomość - ani śladu linka który by robił "downgrade protokołu" czyli miał w tekście https a kierował do strony ze zwykłym http lub też był linkiem https, który po redirectach prowadzi do http. Potwierdziłem też że ten score jest łapany naprawdę za to głupim skryptem w PHP na systemie z caddym:

```php
<?php
header("Location: $_GET[target]");
die();
```


Posłałem maila z linkiem i moim standardowym podpisem żeby filtr antyspamowy nie zgłupiał 😉 i mail został ten sam score za https.

Tu drobna uwaga: warto testować "na produkcji" (nie trzeba się babrać w odtwarzanie konfigu), ale żeby nie śmiecić warto dodać sobie testową regułkę w outlooku, która zatrzyma procesowanie dalszych reguł tak żeby użytkownicy nie dostawali śmiecia. Kiedyś podczas testów wrzuciłem nieopatrznie malware do transferu dla kumpla na produkcyjnego site'a pod URLem na który nikt nie mógł ze świata wejść (i logi to potwierdzają), ale że kilka razy weszliśmy na ten link z kompów z Windowsem to nasze antywirusy uznały produkcyjną domenę za zawirusowaną - także dla innych użytkowników (sic!). Na szczęście dosyć szybko wypadliśmy z listy witryn blokowanych, ale jak się okazuje przypadkiem można sobie kłopotów narobić.

Wracając do problemu. Odkryłem za to że wszystkie linki w tym wątku prowadziły do podobnego redirectera co mój - od ProofPointa (https://urldefense.proofpoint.com/v2/url?u=...). Okazało się że istniał jeden jedyny link do strony nie-httpsowej który także leciał przez httpsowego proofpointa. Dodałem więc na szybko domenę bez httpsa do caddyego i użyłem tego samego skryptu do wygenerowania linku, który "upgradeuje" protokół, czyli pokazuje http (tam link był URLem) a kieruje (przynajmniej na chwilę) do https. Bingo - znowu ten sam score!

&nbsp;

Okazuje się zatem że **HTTPS\_HTTP\_MISMATCH** jest tępy i nie odróżnia kierunku http<->https - niby zmiana protokołu względem wyświetlanego a faktycznego może być wykorzystana w niecnych celach, ale akurat "upgrade" jest wręcz pożądany i nieszkodliwy. Przykładowo niezmieniana stopka w korpo-mailu prowadząca do strony której admini w końcu zainwestowali w cert SSL i robią auto-redirect z :80 na :443