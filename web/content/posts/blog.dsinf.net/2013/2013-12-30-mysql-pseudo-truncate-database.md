---
title: 'MySQL: pseudo TRUNCATE DATABASE'
author: Daniel Skowroński
type: post
date: 2013-12-29T23:04:08+00:00
summary: 'MySQL oferuje DROPa (kasującego obiekt) na bazę danych i tabelę, natomiast TRUNCATEa (zerującego rekordy w obiekcie) tylko na tabelę. Czasem jednak chcemy wyczyścić bazę danych, żeby załadować dane z kopii zapasowej, jednak nie możemy (bo na naszym hostingu się nie da) lub nie chcemy (bo mamy przypisane procedury tudzież uprawnienia specjalne) skasować obiektu bazy danych. Jak zwykle - jest na to skrypt :)'
url: /2013/12/mysql-pseudo-truncate-database/
tags:
  - mysql

---
MySQL oferuje DROPa (kasującego obiekt) na bazę danych i tabelę, natomiast TRUNCATEa (zerującego rekordy w obiekcie) tylko na tabelę. Czasem jednak chcemy wyczyścić bazę danych, żeby załadować dane z kopii zapasowej, jednak nie możemy (bo na naszym hostingu się nie da) lub nie chcemy (bo mamy przypisane procedury tudzież uprawnienia specjalne) skasować obiektu bazy danych. Jak zwykle - jest na to skrypt 🙂

```mysql
SET @BAZA = 'TU WPISZ NAZWĘ BAZY DANYCH'

SET FOREIGN_KEY_CHECKS = 0; 
SET GROUP_CONCAT_MAX_LEN = 20000;

SELECT GROUP_CONCAT( table_schema, '.', table_name) 
FROM information_schema.tables 
WHERE table_schema = @BAZA
INTO @tabele;

SET @tabele2 = CONCAT('DROP TABLE ', @tabele);

PREPARE zad FROM @tabele2;
EXECUTE zad;
DEALLOCATE PREPARE zad;

SET FOREIGN_KEY_CHECKS = 1; 
```


Kilka słów wyjaśnienia.  
Zmienna `FOREIGN_KEY_CHECKS` odpowiada za zezwolenie na selecty międzybazodanowe. Druga zmienna, a raczej początkowy brak jej definiowania sprawił mi najwięcej kłopotu. `GROUP_CONCAT_MAX_LEN` definiuje jak długi może być wynik GROUP_CONCATa - u mnie wynik przekroczył domyślną wartość (w tym wypadku było to około 1000 znaków) i był ucinany.  
Tu drobna uwaga: jeśli gdzieś pojawia się błąd składni przy używaniu zmiennej warto dać `SELECT @zmienna;` i sprawdzić czy wynik kończy się lub zaczyna tak jak powinien.  
`SELECT GROUP_CONCAT` produkuje wyniki skonkatenowane rozdzielone przecinkami - w sam raz do załadowania do procedury. Coś czego nie uczą zazwyczaj przy bazach danych - procedury w locie ze stringów - `PREPARE nazwa_procedury FROM 'string_zrodlowy'`. W ramach porządków po `EXECUTE nazwa_procedury` powinno się zdealokować zasób przez `DEALLOCATE PREPARE nazwa_procedury`. Na koniec przywracamy pierwszą zmienną.