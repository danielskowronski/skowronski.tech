---
title: Mały artykuł o cold storage
author: Daniel Skowroński
type: post
date: 2017-12-28T17:16:52+00:00
excerpt: "Moja dziwnie rozproszona architektura storage'u rzeczy (która w samej mojej stacji roboczej ma 3 tiery!) do tej pory nie potrzebowała cold storage. Ale migracja głównego serwera storage'owego na typowym dedyku - bez płacenia za H&E czy jechania do datacenter Hetnznera wymagała zgrania gdzieś danych na moment. A w sumie teraz doszedłem do wniosku że skoro znalazłem dość tanią usługę to czemu by nie wrzucać tam backupów backupów raz na miesiąc."
url: /2017/12/maly-artykul-o-cold-storage/
tags:
  - backup
  - storage

---
Moja dziwnie rozproszona architektura storage'u rzeczy (która w samej mojej stacji roboczej ma 3 tiery!) do tej pory nie potrzebowała cold storage. Ale migracja głównego serwera storage'owego na typowym dedyku - bez płacenia za H&E czy jechania do datacenter Hetnznera wymagała zgrania gdzieś danych na moment. A w sumie teraz doszedłem do wniosku że skoro znalazłem dość tanią usługę to czemu by nie wrzucać tam backupów backupów raz na miesiąc.

Cold storage zwykle jest implementowany jako robot który wyciąga z półek dyski/taśmy i ładuje je do stacji kiedy przyjdzie request o dane. Bo taniej zrobić robota niż kontroler na bardzo dużo dysków. Przykład jak to wygląda - [https://www.youtube.com/watch?v=FYfrC2kYbDc ][1]. A wbrew pozorom usecase'ów gdzie rzadko potrzebujemy dodać/usunąć dane a zależy nam na długoterminowym i pewnym przechowywaniu jest dużo - na przykład zostawianie backupów dużych wolumenów systemowych czy danych archiwalnych. Sam mam taki dysk "prehistoria" gdzie trzymam radosną twórczość w paincie z czasów przedszkola - żal wywalać a szkoda zapychać dyski podręczne. A ludzie robiący dużo zdjęć (albo co gorsza filmują) chcą mieć gdzie trzymać terabajty rawów i wersjonowanych projektów montażowych.

Ciężko mi zrobić dokładne porównanie usług które testowałem bo dostawcę wybierałem kilka miesięcy temu. Ale przeszedłem przez Amazona, OVH i DigitalOcean. Wspomnę tylko że trzeba uważać na różne rodzaje cloud storage'u bo są i takie które wystawiają normalny filesystem że da się użyć sftp a i tak zwane "object storage" które w jakkolwiek domowym podejściu są przesadą. **Generalnie najtańszy okazał się [C14 od online.net][2]**

SLA i tak będzie lepsze od każdego dedyka z jakąś tam macierzą więc trzeba patrzeć na cenę, prędkość łącza i dostępne protokoły.

Prędkość jest istotna kiedy chcemy wytransferować 2TB danych z dedyka, przeorać go i zgrać te dane z powrotem. Większość dostawców wystawia SFTP więc z tym nie ma problemu. W przypadku c14 warto przekalkulować sobie ceny - czy bardziej opłaca się plan intensywny (droższy koszt gigabajta, ale darmowe archiwizowanie/przywracanie wolumenów) czy zwykły. Pułapka jest taka że nie można po prostu odarchiwizować wolumenu i trzymać go w stanie gotowości cały czas - dostępny jest tydzień (a przynajmniej moje tyle są dostępne). Osiągnięta przeze mnie wydajność transferu po SFTP na hetznerowym gigabicie, na zwykłe dyski talerzowe z ZFS to jakieś 600-700mbps downloadu i 100-200mbps uploadu (statystyki Hetznera twierdzą że w peaku wytransferowałem 90GB na godzinę czyli ~200mbps w dniu kiedy wysyłałem dane a nie robiłem nic innego wtedy). Mój obecny wolumen na 700GB danych odarchizowuje się jakieś 3-4 godziny więc także nie jest źle.

Oczywiście jest i API i entrprisowe usługi typu wysłanie tasiemek. O nich się nie wypowiem bo nie testowałem. Ale ogólnie warto rozważyć trzymanie gdzieś comiesięcznych backupów głównych systemów i danych historycznych, które szkoda wyrzucać.

 [1]: https://www.youtube.com/watch?v=FYfrC2kYbDc
 [2]: https://www.online.net/en/c14