---
title: Dziwne błędy przy pre-commit-hook na macOS
author: Daniel Skowroński
type: post
date: 2021-12-29T19:11:18+00:00
url: /2021/12/dziwne-bledy-przy-pre-commit-hook-na-macos/
featured_image: /wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44.png
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1

---
[pre-commit][1] to świetny framework do zarządzania gitowymi hookami, które uruchamiane są jeszcze przed zacommitowaniem kodu, dzięki czemu możemy zmusić siebie i innych do wykorzystywania narzędzi walidujących jakość kodu (takich jak `yamllint` czy `gocritic`) oraz wykonujących zdefiniowane testy jednostkowe. Ostatnio na stacji roboczej z macOS natrafiłem na dość dziwny błąd, który okazał się w ogóle z pre-commit-hook'iem niepowiązany.

Problem polegał na tym, że w czasie uruchomienia testy z jednego repozytorium nie przechodziły w ogóle, a błąd wygląda jak sieczka wyrazów, wśród której czai się `No such file or directory`.<figure class="wp-block-image size-large">

![](/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-300x219.png)</figure> 

Podejrzewając, że coś wysyła niepożądane znaki sterujące terminalem, spróbowałem wyłączyć obsługę kolorów oraz użyć innego shella. Pomocne dopiero okazało się przekierowanie wyjścia do pliku i inspekcja w edytorze pokazującym znaki kontrolne (w tym wypadku - Sublime Text).<figure class="wp-block-image size-large">

![](/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-292x300.png)</figure> 

Biorąc pierwsze wystąpienie błędu, sprawdziłem pliki `/Users/daniel/.cache/pre-commit/repop0oh9nl_/go-build-mod.sh` i `/Users/daniel/.cache/pre-commit/repop0oh9nl_/lib/cmd-mod.bash` - oba istniały i miały sensowną zawartość. Pi kilkunastu minutach losowych poszukiwań, sięgnąłem po jedną z moich ulubionych komend unixowych - **file**. Jak się okazało, oba pliki mają typ `Bourne-Again shell script text executable, ASCII text, <strong>with CRLF line terminators</strong>`. `CRLF` na macOS miejsca rzecz jasna nie ma.

Permanentnym rozwiązaniem problemu (zamiast użycia `dos2unix` na każdym pliku w repozytorium z hookami) jest zmiana konfiguracji gita przy użyciu `git config --global core.autocrlf false`. Następnie należy usunąć cały katalog `~/.cache/pre-commit/` i ponownie uruchomić `pre-commit run`, który sklonuje na nowo hooki.

 [1]: https://pre-commit.com/
 [2]: /wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44.png
 [3]: /wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22.png