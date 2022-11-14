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
Microsoft idąc w "bezpieczeństwo" w C# .NET zabronił wątkom dostawać się do obiektów z innych wątków - głównie sprowadza się to do nieudanej próby zaktualizowania textBoxa, czy label'ki w wielowątkowej aplikacji (wątek pracujący mógłby zgłosić stan pracy do użytkownika).  
<!--break-->

  
Rozwiązać problem można na dwa sposoby. 

Pierwszy z nich jest dość brutalny i "niebezpieczny", ale za to skuteczny i szybki. Wystarczy przestawić jedno pole: 

```c#
Control.CheckForIllegalCrossThreadCalls = false;
```


Jeśli jesteśmy paranoikami bezpieczeństwa można zezwolić na wywołania międzywątkowe tylko na czas naszych operacji - żeby zły człowiek nie zepsuł interfejsu, albo w przypadku bardziej złożonych aplikacji - czegoś więcej.

Druga opcja to delegaty i Invoke. Całkiem sensowny opis znajduje się tutaj - http://msdn.microsoft.com/pl-pl/library/zyzhdc6b.aspx.