---
title: Wykres ciepłoty komputera
author: Daniel Skowroński
type: post
date: 2012-08-05T11:49:30+00:00
url: /2012/08/wykres-cieploty-komputera/
tags:
  - acpi
  - linux
  - perl

---
Skrypt dość prosty - odczytuje aktualną temperaturę komputera, zapisuje do rotacyjnego loga i tworzy estetyczny wykres przy pomocy biblioteki GD. Oczywiście działa tylko pod Linuksem 😉 Językiem tworzenia został wybrany Perl - głównie ze względu na początki mojej przygody z tym językiem, ale także ze względu na łatwość parsowania plików. Jest to następca skryptu PHP o tej samej nazwie - ciepło, który jednak nie tworzył żadnego loga, a jedynie odczytywał wynik `acpi -V`i odpwoiednio kolorował wynik. Źródła protoplasty cieplo.pl zaginęły.  
Poniżej źródło z sierpnia 2011:

```perl
#!/usr/bin/perl
use warnings;
use CGI ':standard';
use GD::Graph::bars;
 
$ile_wpisow = 120;
 
print "\n"x30;

#odczyt aktualnej temperatury 
#open(PLIK, '/proc/acpi/thermal_zone/THRM/temperature') or die "Nie można otworzyć pliku: $!";#wersja dla starych kerneli, teraz trzeba tak:
open(PLIK, '/sys/class/hwmon/hwmon0/temp1_input') or die "Nie można otworzyć pliku: $!";
while ($record = &lt;PLIK>) 
{
 $wartosc = $record;
}
close PLIK;

#parsowanie danych
#$temperatura = int(substr($wartosc, -5, -3));#inny plik => trzeba tak:
$temperatura = int(substr($wartosc, 0, 2));

#przygotowanie aktualnej daty
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
$year += 1900;
$mon += 1;
my $datetime = sprintf "%02d:%02d:%02d", $hour, $min, $sec;

#dopisanie ostatniej wartoscido pliku
open(LOG, '>>', 'log.txt') or die "Nie można otworzyć pliku: $!";
print LOG $datetime.": ".$temperatura."\n"; # zapisywanie
close LOG;

#wczytanie calego loga do tablic
open (LOG,'log.txt');
$licznik=0;
@tablica_dat;
@tablica_wartosci;
while ($record = &lt;LOG>) 
{  
 $data[0][$licznik] = substr($record, 0, 8);
 $data[1][$licznik] = substr($record, -3, 2);
 $licznik=$licznik+1;#bo do zera!
}
close LOG;

#otworzenie pliku do nadpisania(w celu utzrymania stalej ilosci rekordow)
open (LOG, ">", "log.txt");
if($licznik&lt;=($ile_wpisow+2))
{
 for ($i = 0; $i&lt;$licznik; $i++)
 {
  print LOG "".$data[0][$i].": ".$data[1][$i]."\n";
 }
}
if ($licznik>($ile_wpisow+2))
{
 for ($i = ($licznik-$ile_wpisow); $i&lt;$licznik; $i++)
 {
  print LOG "".$data[0][$i].": ".$data[1][$i]."\n";
 }
}
close(LOG);

#przygotowanie wykresu
use GD::Graph::area;

if (20*$licznik&lt;100) {$licznik = 10;}

my $mygraph = GD::Graph::area->new(20*$licznik, 500);
$mygraph->set(
 x_label     => 'Data',
 y_label     => 'Wartosc temperatury',
 y_max_value       => 80,
 y_min_value => 40,
 y_tick_number => 2,
 y_label_skip  => 1,
 x_label_skip => 15,
) or warn $mygraph->error;

my $myimage = $mygraph->plot(\@data) or die $mygraph->error; 

#generowanie obrazka
open(IMG, '>', 'IMG.PNG') or die "Nie można otworzyć pliku: $!";
print IMG $myimage->png;
close IMG;

#koniec programu
print "\n"; 
```

Sam plik perla można pobrać [tutaj][1], natomiast niezbędna biblioteka GD jest dostępna [tutaj][2]. Kilka słów co do wymogów pod Linuksem. Oczywistością jest pakiet acpi, który wszędzie nazywa się tak samo (nawet w ubuntu).

 [1]: /wp-content/uploads/2012/08/cieplo.pl_.txt
 [2]: http://search.cpan.org/~lds/GD-2.11/GD.pm