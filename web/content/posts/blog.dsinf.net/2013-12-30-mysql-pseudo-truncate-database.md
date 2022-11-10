---
title: 'MySQL: pseudo TRUNCATE DATABASE'
author: Daniel Skowroński
type: post
date: 2013-12-29T23:04:08+00:00
excerpt: 'MySQL oferuje DROPa (kasującego obiekt) na bazę danych i tabelę, natomiast TRUNCATEa (zerującego rekordy w obiekcie) tylko na tabelę. Czasem jednak chcemy wyczyścić bazę danych, żeby załadować dane z kopii zapasowej, jednak nie możemy (bo na naszym hostingu się nie da) lub nie chcemy (bo mamy przypisane procedury tudzież uprawnienia specjalne) skasować obiektu bazy danych. Jak zwykle - jest na to skrypt :)'
url: /2013/12/mysql-pseudo-truncate-database/
tags:
  - mysql

---
MySQL oferuje DROPa (kasującego obiekt) na bazę danych i tabelę, natomiast TRUNCATEa (zerującego rekordy w obiekcie) tylko na tabelę. Czasem jednak chcemy wyczyścić bazę danych, żeby załadować dane z kopii zapasowej, jednak nie możemy (bo na naszym hostingu się nie da) lub nie chcemy (bo mamy przypisane procedury tudzież uprawnienia specjalne) skasować obiektu bazy danych. Jak zwykle &#8211; jest na to skrypt 🙂

<pre class="lang:mysql EnlighterJSRAW " title="truncate database" >SET @BAZA = 'TU WPISZ NAZWĘ BAZY DANYCH'

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

SET FOREIGN_KEY_CHECKS = 1; </pre>

Kilka słów wyjaśnienia.  
Zmienna <span class="lang:default EnlighterJSRAW  crayon-inline " >FOREIGN_KEY_CHECKS</span> odpowiada za zezwolenie na selecty międzybazodanowe. Druga zmienna, a raczej początkowy brak jej definiowania sprawił mi najwięcej kłopotu. <span class="lang:default EnlighterJSRAW  crayon-inline " >GROUP_CONCAT_MAX_LEN</span> definiuje jak długi może być wynik GROUP_CONCATa &#8211; u mnie wynik przekroczył domyślną wartość (w tym wypadku było to około 1000 znaków) i był ucinany.  
Tu drobna uwaga: jeśli gdzieś pojawia się błąd składni przy używaniu zmiennej warto dać <span class="lang:default EnlighterJSRAW  crayon-inline " >SELECT @zmienna;</span> i sprawdzić czy wynik kończy się lub zaczyna tak jak powinien.  
<span class="lang:default EnlighterJSRAW  crayon-inline " >SELECT GROUP_CONCAT</span> produkuje wyniki skonkatenowane rozdzielone przecinkami &#8211; w sam raz do załadowania do procedury. Coś czego nie uczą zazwyczaj przy bazach danych &#8211; procedury w locie ze stringów &#8211; <span class="lang:default EnlighterJSRAW  crayon-inline " >PREPARE nazwa_procedury FROM 'string_zrodlowy&#8217;</span>. W ramach porządków po <span class="lang:default EnlighterJSRAW  crayon-inline " >EXECUTE nazwa_procedury</span> powinno się zdealokować zasób przez <span class="lang:default EnlighterJSRAW  crayon-inline " >DEALLOCATE PREPARE nazwa_procedury</span>. Na koniec przywracamy pierwszą zmienną.