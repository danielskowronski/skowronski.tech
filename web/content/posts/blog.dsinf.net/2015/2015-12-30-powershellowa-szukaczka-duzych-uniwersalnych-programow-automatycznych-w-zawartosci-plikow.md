---
title: Powershellowa szukaczka Dużych Uniwersalnych Programów Automatycznych w zawartości plików
author: Daniel Skowroński
type: post
date: 2015-12-30T20:55:35+00:00
url: /2015/12/powershellowa-szukaczka-duzych-uniwersalnych-programow-automatycznych-w-zawartosci-plikow/
tags:
  - deployment
  - powershell

---
Czasem programiści umieszczają w kodzie źródłowym akronim od Dużych Uniwersalnych Programów Automatycznych, który kłopotliwie wygląda jeśli wyskoczy klientowi w przeglądarce. Korzystając z serwerów Continuous Integration / Continuous Delivery możemy dodać jako krok budowania aplikacji skrypt, który wyszuka wspomniany akronim w kodzie, wyświetli wszystkie jego wystąpienia wraz z nazwami plików i wyrzuci kod błędu odpowiadający liczbie incydentów. Zero = program bez błędów.

Skrypt w wersji na Windowsa na Githubie: <https://gist.github.com/danielskowronski/df953e0be1bac5f1d295>