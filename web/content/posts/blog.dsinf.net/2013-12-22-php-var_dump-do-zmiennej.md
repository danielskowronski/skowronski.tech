---
title: 'PHP: var_dump do zmiennej'
author: Daniel Skowroński
type: post
date: 2013-12-22T00:01:33+00:00
excerpt: Tego łatwo się nie znajdzie, a potrafi krwi napsuć. W PHP var_dump() wyrzuca zmienną wraz z jej typem, o jest szczególnie użyteczne przy rzucaniu całych tablic (np. $_GET, czy $_SERVER). Ale jak ściągnąć wynik do zmiennej, żeby np. wrzucić go do pliku?
url: /2013/12/php-var_dump-do-zmiennej/
tags:
  - php

---
Tego łatwo się nie znajdzie, a potrafi krwi napsuć. W PHP var\_dump() wyrzuca zmienną wraz z jej typem, o jest szczególnie użyteczne przy rzucaniu całych tablic (np. $\_GET, czy $_SERVER). Ale jak ściągnąć wynik do zmiennej, żeby np. wrzucić go do pliku?  
W tym celu powstała funkcja **var_export()**, która jednak jest pokrętna. Je sli użyjemy intuicyjnej składni zrobi to samo co var_dump - wypluje na ekran i już. Dopero drugi parametr typu boolean określa, czy wydrukować na ekran, czy też nie. Domyślnie robi to, co nie trzeba, więc trzeba dać true.

```php
mixed var_export ( mixed $expression [, bool $return = false ] )
```


Można by się pokusić o dodanie do naszego dodawanego wszędzie zestawu funkcji czegoś w rodzaju 

```php
function var_save ( $zmienna ){
  return var_export( $zmienna, true );
}
```

by nie pisać zbyt wiele i zachować przejrzystość kodu.