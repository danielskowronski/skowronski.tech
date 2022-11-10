---
title: 'C# – cross thread operation invalid. Rozwiązanie proste.'
author: Daniel Skowroński
type: post
date: 2013-06-05T16:45:29+00:00
url: /2013/06/c-cross-thread-operation-invalid-rozwiazanie-proste/
tags:
  - 'c# unsafe'
  - c++

---
Microsoft idąc w &#8222;bezpieczeństwo&#8221; w C# .NET zabronił wątkom dostawać się do obiektów z innych wątków &#8211; głównie sprowadza się to do nieudanej próby zaktualizowania textBoxa, czy label&#8217;ki w wielowątkowej aplikacji (wątek pracujący mógłby zgłosić stan pracy do użytkownika).  
<!--break-->

  
Rozwiązać problem można na dwa sposoby. 

Pierwszy z nich jest dość brutalny i &#8222;niebezpieczny&#8221;, ale za to skuteczny i szybki. Wystarczy przestawić jedno pole: 

<pre class="EnlighterJSRAW csharp">Control.CheckForIllegalCrossThreadCalls = false;</pre>

Jeśli jesteśmy paranoikami bezpieczeństwa można zezwolić na wywołania międzywątkowe tylko na czas naszych operacji &#8211; żeby zły człowiek nie zepsuł interfejsu, albo w przypadku bardziej złożonych aplikacji &#8211; czegoś więcej.

Druga opcja to delegaty i Invoke. Całkiem sensowny opis znajduje się tutaj &#8211; http://msdn.microsoft.com/pl-pl/library/zyzhdc6b.aspx.