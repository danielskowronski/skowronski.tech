---
title: 'Okienko zawsze na wierzchu w C#'
author: Daniel Skowroński
type: post
date: 2013-01-25T18:28:37+00:00
url: /2013/01/okienko-zawsze-na-wierzchu-w-c/
tags:
  - c++
  - 'win c#'

---
Microsoft zawsze raczył nas dziwnymi rozwiązaniami prostych spraw. Problem częsty przy małych aplikacjach w C#, które mają być zawsze na wierzchu &#8211; stoperach, minutnikach, czy monitorach wydajności &#8211; jak uczynić okno pozostającym zawsze na wierzchu. <!--break-->Na MSDNie zaproponowano rozwiązanie, które znaleźć możemy jako 

_Property_ kontrolki _WindowsForm_:

<pre class="EnlighterJSRAW csharp">this.TopForm = true;
</pre>

Jednak jak można doczytać od Windowsa 2000 ta zmiana dotyczy zakresu danej aplikacji &#8211; znaczy to, że jeśli pracujemy z wielookienkowym narzędziem to możemy podpiąć jakiś toolbar, żeby nie zniknął. Ale utrata przez proces focusa na okno przerzuci je w tło.  
Rozwiązanie skuteczne wymaga załadowania biblioteki <k>user32.dll<k> odpowiedzialnej za obsługę UI i przejęcie funkcji zmieniającej pozycję okna. Brzmi skomplikowanie. Ale implementacja jest prosta, bezbolesna i nie wymaga SafeMode:  
W nagłówku dopisujemy

<pre class="EnlighterJSRAW csharp">using System.Runtime.InteropServices;</pre>

W klasie naszego projektu

<pre class="EnlighterJSRAW csharp">private IntPtr HWND_TOPMOST = new IntPtr(-1);
private const uint SWP_NOSIZE = 0x0001;
private const uint SWP_NOMOVE = 0x0002;
private const uint TOPMOST_FLAGS = SWP_NOMOVE | SWP_NOSIZE;
[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd,
    IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
</pre>

I samo wywołanie w dowolnym miejscu, np. podczas ładowania w konstruktorze (np. public form1(){} ):

<pre class="EnlighterJSRAW csharp">SetWindowPos(this.Handle, HWND_TOPMOST, 0, 0, 0, 0, TOPMOST_FLAGS);
</pre>