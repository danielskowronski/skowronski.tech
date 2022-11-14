---
title: O przywracaniu urbackupem (i samego urbackupa) słów kilka
author: Daniel Skowroński
type: post
date: 2017-12-28T16:35:16+00:00
summary: Niestety przyszła i na mnie konieczność użycia backupu. Użyty urbackup, którego opisywałem jakiś czas temu zachował dane i przyszedł czas na odtwarzanie. A to znowu nie takie trywialne...
url: /2017/12/o-przywracaniu-urbackupem-i-samego-urbackupa-slow-kilka/
tags:
  - backup
  - linux
  - urbackup
  - windows

---
Niestety przyszła i na mnie konieczność użycia backupu. Użyty urbackup, którego [opisywałem jakiś czas temu][1] zachował dane i przyszedł czas na odtwarzanie. A to znowu nie takie trywialne...

Pierwszym krokiem w moim wypadku było odtworzenie samego urbackupa bo w międzyczasie migrowałem serwer storage'owy. I gdybym nie robił paranoicznie backupów musiałbym ręcznie odtwarzać migawki VHD bowiem okazuje się że dla urbackupa folder z danymi (u mnie akurat /home/urb) to jedno, a folder z bazą danych opisującą te pliki to drugie. I same pliki nie wystarczą, nie ma opcji odtwarzania bazy danych z powietrza. Na szczęście przed migracją poza wrzuceniem tarballi folderów z głównej macierzy z danymi oraz zrzutów baz danych na cold storage wpadłem na pomysł zrobienia obrazu rootfs - jakbym jakiegoś pliki jednak się zawieruszyły. No i potrzebnym okazał się **/var/urbackup** gdzie trzymane są wspomniane bazy danych (SQLite). Proces stawiania nowej instancji ze starymi danymi na nogi jest następujący: instalujemy urbackup, konfigurujemy usera i ścieżkę do storage'u danych, zatrzymujemy usługę, nadpisujemy cały /var/urbackup, podnosimy usługę i wszystko powinno być na miejscu.

Teraz czas na przywracanie samego backupu. W moim wypadku pacjentem jest cały dysk systemowy windowsa który zakończył żywot. SSD happens. Płyta "UrBackup restore CD" jest jak cały urbackup - mało opisowa. Bootuje ona małego debiana (który umie into apt więc można sobie na drugim tty odpalić iotopa/htopa) który wita nas menu - można ustawić sieć (DHCP samo działa!), wybrać autodiscovery serwera w LANie, wpisać adres ręcznie (dla serwera "internetowego") czy też anulować odtwarzanie. No i jak mamy serwer w LANie (np. na NASie) to wszystko prosto. Ale jak za NATem? To nie działa.

Permanentnie nie da się odtwarzać za NATem. Jedyne rozwiązanie bez stawiania jakichś tuneli (np. bridgowany zerotier na innej maszynie w sieci albo na samym routerze jeśli mamy coś ambitnego) to wystawić IP maszyny odtwarzanej w DMZ - na szczęście płytka nie wystawia serwera SSH więc można odpalać bez obaw. Pamiętać także warto żeby nasz serwer na pewno miał otwarte porty na odpowiednim interfejsie (ja na przykład miałem je otwarte na zt0 żeby backup szedł jednak tunelem).

Kiedy już się uporamy z omijaniem NATa wystarczy podać hostname serwera, login i hasło, wskazać który klient jest odtwarzany, wybrać docelowy dysk (dysk, nie partycję!), cieszyć się z FTTH, wyciszyć alerty (bo wysycanie domowego łącza i generowanie dziwnego ruchu na zdalnym serwerze nie ujdzie żadnemu systemowi monitorującemu) i iść na obiad.

 [1]: https://blog.dsinf.net/2017/07/prosty-choc-nie-zawsze-trywialny-w-obsludze-system-backupowania-urbackup/