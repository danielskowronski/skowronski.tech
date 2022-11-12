---
title: Cięcie skanów pod Kindle
author: Daniel Skowroński
type: post
date: 2014-11-13T17:04:06+00:00
excerpt: 'Typowy problem - mamy sporawy plik PDF ze skanem książki i chcemy wrzucić go na Kindla albo inny czytnik <i>tak, żeby dało się wygodnie czytać</i>. Dwa aplety Javy załatwią sprawę zaskakująco dobrze i szybko.'
url: /2014/11/ciecie-skanow-pod-kindle/
tags:
  - kindle
  - pdf

---
Typowy problem - mamy sporawy plik PDF ze skanem książki i chcemy wrzucić go na Kindla albo inny czytnik _tak, żeby dało się wygodnie czytać_. Dwa aplety Javy załatwią sprawę zaskakująco dobrze i szybko.

![Logo PDF Scissors](/wp-content/uploads/2014/11/pdf_scissors_logo.png) Pierwsza kwestia to wycięcie marginesów - na czytniku są zbędne głównie dlatego, że zmiejszają rozmiar tekstu. A czytanie nawet kilkunastu stron w trybie lupy do przyjemnych nie należy. Po przetestowaniu kilkunastu narzędzi bezkonkurencyjnie najlepszym okazał się **PDF Scissors** - o dziwo to aplet Javy; dostępny do pobrania z <https://sites.google.com/site/pdfscissors/>.

Jego niepodważalną zaletą jest _stacked view_, który nakłada na siebie wszystkie strony co pozwala zminimalizować liczbę ręcznych ustawień linii cięcia - przecież nie musim być równo co do piksela.

![Stacked view](/wp-content/uploads/2014/11/pdf_scissors_stacked_view.png)

![Stacked view w akcji](/wp-content/uploads/2014/11/pdf_scissors_stacked_view21.png)  
Poza ręcznym rysowanie obszarów można też ustawić linie pionowe i poziome także "równo" w połowie. Dostępne są też różne opcje importu.  
![Opcje importu](/wp-content/uploads/2014/11/pdf_scissors_import_options.png)  
Dużym zaskoczeniem jest fakt, że pliki PDF o rozmiarze rzędu 20-30MB cięte są błyskawicznie, tym bardziej, że w końcu to aplet Javy.

Następna sprawa to ustawienie metadanych w PDFach - Kindle będzie wyświetlał tytuł i autora. W tych polach dość często pozostaje nazwa programu skanującego lub tworzącego PDFa. Można to zmienić. Co ciekawe - znowu aplet Javy. Mały i szybki, ale z dość banalną nazwą **PDF Metadata Editor** dostępny na <http://zaro.github.io/pdf-metadata-editor/>.  
![PDF Metadata Editor](/wp-content/uploads/2014/11/pdf_metadata_editor.png)

<div id="JavaWylaczanieBezpieczenstwa">
</div>

Ważna uwaga - te aplety Javy są podpisane cyfrowo jedynie przez autorów - nowa Java będzie się drzeć, że uruchamianie ich może być niebezpieczne. Owszem - może, jak każdego innego pliku binarnego. W razie paranoi kod źródłowy jest dostępny 😉  
W pewnych wypadkach aplety w ogóle się nie uruchomią. Wówczas szukamy "Java settings" - w Windowsie ścieżka do exe to `c:\Program Files (x86)\Java\jre7\bin\javacpl.exe` (ale jest też w menu Start) i w zakładce _Security_ obniżamy poziom do _Medium_.  
![](/wp-content/uploads/2014/11/java_security0.png)

Teraz za każdym razem będziemy pytani czy uruchomić dany aplet.

![](/wp-content/uploads/2014/11/java_security1.png)

&nbsp;

Na koniec warto wspomnieć, że Kindle przy pracy z dokumentami PDF oferuje opcję 5-stopniowej zmiany kontrastu co w przypadku słabej jakości dokumentów lub też wersji kolorowej znacznie polepsza jakość czytania. Ustawienia są dostępne po kliknięciu standardowego klawisza ustawień czcionki [Aa].

[pdfscissors.jnlp][7]

 [1]: /wp-content/uploads/2014/11/pdf_scissors_stacked_view.png
 [2]: /wp-content/uploads/2014/11/pdf_scissors_stacked_view21.png
 [3]: /wp-content/uploads/2014/11/pdf_scissors_import_options.png
 [4]: /wp-content/uploads/2014/11/pdf_metadata_editor.png
 [5]: /wp-content/uploads/2014/11/java_security0.png
 [6]: /wp-content/uploads/2014/11/java_security1.png
 [7]: /wp-content/uploads/2014/11/pdfscissors.jnlp_.zip