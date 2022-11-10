---
title: „Przyspieszanie” procesorożernych procesów na Windowsie
author: Daniel Skowroński
type: post
date: 2013-02-05T23:06:01+00:00
url: /2013/02/przyspieszanie-procesorozernych-procesow-na-windowsie/
tags:
  - optymalizacja
  - windows

---
Kompresja za pomocą 7zip na poziomie ultra? Szyfrowanie dużej ilości danych? Instalacja systemu gościa w maszynie wirtualnej? To niby można zrobić na Linuksie. Ale już renderowanie filmu w Adobe Premiere pójdzie tylko na okienkach.

<!--break-->

  
**Jak &#8222;przyspieszyć&#8221; procesy?**  
Po pierwsze warto przegrzebać ustawienia samej aplikacji pod kątem pewnych optymalizacji &#8211; często programy do montażu mają po prostu możliwość zmiany priorytetu. Ale to jeszcze nie jest kres możliwości! Kolejną krytyczną operacją będzie zamknięcie przeglądarki Google Chrome jako najbardziej zasobożernej, a już zwłaszcza 2 okienka po 15 kart z nie daj Boże Adobe Flash&#8217;em&#8230; Oczywiście inne aplikacje zbędne też wypada ubić. 

Ostatni krok jest najbardziej brutalny, ale zarazem skuteczny. **Modyfikacja priorytetów**.  
&#8222;Task-magister&#8221; (_taskmgr.exe_) nie jest zbyt pewny, dlatego polecam PROCess EXPlorera (http://technet.microsoft.com/pl-pl/sysinternals/bb896653.aspx).  
Priorytety można zmieniać od _idle_, przez _background_, _below normal_, domyślny _normal_, _above normal_, aż po _high_ oraz &#8222;_realtime_&#8222;. Z tym, że ten ostatni ma niewiele wspólnego z prawdziwym czasem rzeczywistym. 

O ile zmiana naszego procesu, który łatwo znaleźć, bo będzie na szczycie listy posortowanej po CPU%, do wysokiego nie powinna destabilizować systemu, to zmiana priorytetu dziwnych zadań, w rodzaju explorer.exe na Idle może całkiem rozregulować działanie okienek. Należy pamiętać o tym, że po zabiciu proces nie pamięta swojego poprzedniego priorytetu.  
(Służą do tego jakieś mody głównego menadżera zadań, ale są słabe).  
Istnieje pewne niebezpieczeństwo na systemach rodziny Server, głównie 2012. Otóż priorytet _realtime_ w połączeniu z konsumpcją przez proces normalnie koło 60-80% procesora może się skończyć zajętością przez ten tylko jeden 95% czasu zegara CPU. A to oznacza, że dyspozytor systemowy da nam możliwość poruszania myszką z prędkością około 0,5 ekranu/sekundę. Ale efekty są znakomite &#8211; widać odczuwalne przyspieszenie. Jedyną oznaką życia jest chyba diodka HDD, albo w ogóle jego szum 😉

Coś jeszcze? Ano tak &#8211; **koligacja procesora**, czyli _Process affinity_ &#8211; dość użyteczne, kiedy chcemy przerzucić Flaha na jeden rdzeń, a na pozostałych trzech renderować wspomniany filmik. Albo rozdzielić zadania równoległe.