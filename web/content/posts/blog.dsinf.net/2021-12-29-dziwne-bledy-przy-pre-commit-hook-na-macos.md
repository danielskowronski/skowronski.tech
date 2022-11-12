---
title: Dziwne błędy przy pre-commit-hook na macOS
author: Daniel Skowroński
type: post
date: 2021-12-29T19:11:18+00:00
url: /2021/12/dziwne-bledy-przy-pre-commit-hook-na-macos/
featured_image: https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44.png
xyz_twap_future_to_publish:
  - 'a:3:{s:26:"xyz_twap_twpost_permission";s:1:"1";s:32:"xyz_twap_twpost_image_permission";s:1:"1";s:18:"xyz_twap_twmessage";s:26:"{POST_TITLE} - {PERMALINK}";}'
xyz_twap:
  - 1

---
[pre-commit][1] to świetny framework do zarządzania gitowymi hookami, które uruchamiane są jeszcze przed zacommitowaniem kodu, dzięki czemu możemy zmusić siebie i innych do wykorzystywania narzędzi walidujących jakość kodu (takich jak `yamllint` czy `gocritic`) oraz wykonujących zdefiniowane testy jednostkowe. Ostatnio na stacji roboczej z macOS natrafiłem na dość dziwny błąd, który okazał się w ogóle z pre-commit-hook'iem niepowiązany.

Problem polegał na tym, że w czasie uruchomienia testy z jednego repozytorium nie przechodziły w ogóle, a błąd wygląda jak sieczka wyrazów, wśród której czai się `No such file or directory`.<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="1024" height="746" src="https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-1024x746.png" alt="" class="wp-image-2321" srcset="https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-1024x746.png 1024w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-300x219.png 300w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-768x560.png 768w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-1536x1120.png 1536w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44-2048x1493.png 2048w" sizes="(max-width: 1024px) 100vw, 1024px" />][2]</figure> 

Podejrzewając, że coś wysyła niepożądane znaki sterujące terminalem, spróbowałem wyłączyć obsługę kolorów oraz użyć innego shella. Pomocne dopiero okazało się przekierowanie wyjścia do pliku i inspekcja w edytorze pokazującym znaki kontrolne (w tym wypadku - Sublime Text).<figure class="wp-block-image size-large">

[<img decoding="async" loading="lazy" width="997" height="1024" src="https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-997x1024.png" alt="" class="wp-image-2325" srcset="https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-997x1024.png 997w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-292x300.png 292w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-768x789.png 768w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-1495x1536.png 1495w, https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22-1994x2048.png 1994w" sizes="(max-width: 997px) 100vw, 997px" />][3]</figure> 

Biorąc pierwsze wystąpienie błędu, sprawdziłem pliki `/Users/daniel/.cache/pre-commit/repop0oh9nl_/go-build-mod.sh` i `/Users/daniel/.cache/pre-commit/repop0oh9nl_/lib/cmd-mod.bash` - oba istniały i miały sensowną zawartość. Pi kilkunastu minutach losowych poszukiwań, sięgnąłem po jedną z moich ulubionych komend unixowych - **file**. Jak się okazało, oba pliki mają typ `Bourne-Again shell script text executable, ASCII text, <strong>with CRLF line terminators</strong>`. `CRLF` na macOS miejsca rzecz jasna nie ma.

Permanentnym rozwiązaniem problemu (zamiast użycia `dos2unix` na każdym pliku w repozytorium z hookami) jest zmiana konfiguracji gita przy użyciu `git config --global core.autocrlf false`. Następnie należy usunąć cały katalog `~/.cache/pre-commit/` i ponownie uruchomić `pre-commit run`, który sklonuje na nowo hooki.

 [1]: https://pre-commit.com/
 [2]: https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.52.44.png
 [3]: https://blog.dsinf.net/wp-content/uploads/2021/12/Screenshot-2021-12-23-at-20.53.22.png