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

<img decoding="async" loading="lazy" class="alignleft  wp-image-590" src="http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_logo-150x150.png" alt="Logo PDF Scissors" width="69" height="69" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_logo-150x150.png 150w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_logo-144x144.png 144w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_logo.png 200w" sizes="(max-width: 69px) 100vw, 69px" /> Pierwsza kwestia to wycięcie marginesów - na czytniku są zbędne głównie dlatego, że zmiejszają rozmiar tekstu. A czytanie nawet kilkunastu stron w trybie lupy do przyjemnych nie należy. Po przetestowaniu kilkunastu narzędzi bezkonkurencyjnie najlepszym okazał się **PDF Scissors** - o dziwo to aplet Javy; dostępny do pobrania z <https://sites.google.com/site/pdfscissors/>.

Jego niepodważalną zaletą jest _stacked view_, który nakłada na siebie wszystkie strony co pozwala zminimalizować liczbę ręcznych ustawień linii cięcia - przecież nie musim być równo co do piksela.

[<img decoding="async" loading="lazy" class="alignnone wp-image-591" src="http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view.png" alt="Stacked view" width="600" height="430" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view.png 784w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view-300x215.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view-660x473.png 660w" sizes="(max-width: 600px) 100vw, 600px" />][1]

[<img decoding="async" loading="lazy" class="alignnone wp-image-593" src="http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21.png" alt="Stacked view w akcji" width="600" height="510" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21.png 996w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21-300x255.png 300w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21-660x561.png 660w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21-900x765.png 900w" sizes="(max-width: 600px) 100vw, 600px" />][2]  
Poza ręcznym rysowanie obszarów można też ustawić linie pionowe i poziome także "równo" w połowie. Dostępne są też różne opcje importu.  
[<img decoding="async" loading="lazy" class="alignnone wp-image-594 size-full" src="http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_import_options.png" alt="Opcje importu" width="495" height="292" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_import_options.png 495w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_import_options-300x176.png 300w" sizes="(max-width: 495px) 100vw, 495px" />][3]  
Dużym zaskoczeniem jest fakt, że pliki PDF o rozmiarze rzędu 20-30MB cięte są błyskawicznie, tym bardziej, że w końcu to aplet Javy.

Następna sprawa to ustawienie metadanych w PDFach - Kindle będzie wyświetlał tytuł i autora. W tych polach dość często pozostaje nazwa programu skanującego lub tworzącego PDFa. Można to zmienić. Co ciekawe - znowu aplet Javy. Mały i szybki, ale z dość banalną nazwą **PDF Metadata Editor** dostępny na <http://zaro.github.io/pdf-metadata-editor/>.  
[<img decoding="async" loading="lazy" class="alignnone wp-image-597" src="http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_metadata_editor.png" alt="PDF Metadata Editor" width="500" height="378" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_metadata_editor.png 626w, https://blog.dsinf.net/wp-content/uploads/2014/11/pdf_metadata_editor-300x226.png 300w" sizes="(max-width: 500px) 100vw, 500px" />][4]

<div id="JavaWylaczanieBezpieczenstwa">
</div>

Ważna uwaga - te aplety Javy są podpisane cyfrowo jedynie przez autorów - nowa Java będzie się drzeć, że uruchamianie ich może być niebezpieczne. Owszem - może, jak każdego innego pliku binarnego. W razie paranoi kod źródłowy jest dostępny 😉  
W pewnych wypadkach aplety w ogóle się nie uruchomią. Wówczas szukamy "Java settings" - w Windowsie ścieżka do exe to `c:\Program Files (x86)\Java\jre7\bin\javacpl.exe` (ale jest też w menu Start) i w zakładce _Security_ obniżamy poziom do _Medium_.  
[<img decoding="async" loading="lazy" class="alignnone wp-image-596 size-large" src="http://blog.dsinf.net/wp-content/uploads/2014/11/java_security0-953x1024.png" alt="" width="665" height="714" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/java_security0-953x1024.png 953w, https://blog.dsinf.net/wp-content/uploads/2014/11/java_security0-279x300.png 279w, https://blog.dsinf.net/wp-content/uploads/2014/11/java_security0-660x708.png 660w, https://blog.dsinf.net/wp-content/uploads/2014/11/java_security0-900x966.png 900w, https://blog.dsinf.net/wp-content/uploads/2014/11/java_security0.png 959w" sizes="(max-width: 665px) 100vw, 665px" />][5]

Teraz za każdym razem będziemy pytani czy uruchomić dany aplet.

[<img decoding="async" loading="lazy" class="alignnone wp-image-595 size-full" src="http://blog.dsinf.net/wp-content/uploads/2014/11/java_security1.png" alt="" width="595" height="390" srcset="https://blog.dsinf.net/wp-content/uploads/2014/11/java_security1.png 595w, https://blog.dsinf.net/wp-content/uploads/2014/11/java_security1-300x196.png 300w" sizes="(max-width: 595px) 100vw, 595px" />][6]

&nbsp;

Na koniec warto wspomnieć, że Kindle przy pracy z dokumentami PDF oferuje opcję 5-stopniowej zmiany kontrastu co w przypadku słabej jakości dokumentów lub też wersji kolorowej znacznie polepsza jakość czytania. Ustawienia są dostępne po kliknięciu standardowego klawisza ustawień czcionki [Aa].

[pdfscissors.jnlp][7]

 [1]: http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view.png
 [2]: http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_stacked_view21.png
 [3]: http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_scissors_import_options.png
 [4]: http://blog.dsinf.net/wp-content/uploads/2014/11/pdf_metadata_editor.png
 [5]: http://blog.dsinf.net/wp-content/uploads/2014/11/java_security0.png
 [6]: http://blog.dsinf.net/wp-content/uploads/2014/11/java_security1.png
 [7]: http://blog.dsinf.net/wp-content/uploads/2014/11/pdfscissors.jnlp_.zip