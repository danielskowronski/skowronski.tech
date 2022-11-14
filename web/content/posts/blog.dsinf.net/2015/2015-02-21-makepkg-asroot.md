---
title: "makepkg: invalid option '--asroot’"
author: Daniel Skowroński
type: post
date: 2015-02-21T18:11:55+00:00
summary: 'Pewien nieodpowiedzialny maintainer Arch Linuxa popenił commit `61ba5c961e4a3536c4bbf41edb348987a9993fdb` do pacmana (menadżera pakietów) usuwający parametr asroot, który zezwalał <em>na ryzyko użytkownika</em> kompilować pakiety jako root. '
url: /2015/02/makepkg-asroot/
tags:
  - arch
  - linux

---
Pewien nieodpowiedzialny maintainer Arch Linuxa popenił commit [61ba5c961e4a3536c4bbf41edb348987a9993fdb][1] do pacmana (menadżera pakietów) usuwający parametr asroot, który zezwalał _na ryzyko użytkownika_ kompilować pakiety jako root. Tłumaczenie się było następujące:

> The days of fakeroot being error ridden are long gone, so there is no valid reason to run makepkg as root.  
> Signed-off-by: Allan McRae <allan@archlinux.org>

Efekt? 

```
makepkg: invalid option ‘--asroot’
```


Administratorzy mogli to zauważyć przy aktualizacji pakietów z AURa, że nagle nie mogą dokończyć operacji. Zwykłym użytkownikom niektóre programy przestały działać (dyskusja [tutaj][2]). 

Kwestia używania Linuksa z konta superużytkownika to osobna sprawa, ale powinna pozostać jako w pełni osobista decyzja. Wprowadzanie "dobrych" praktyk na siłę to styl ubuntu, ale na pewno nie Archa - zawiodłem się 🙁 Tym bardziej, że akurat zarządzanie pakietami to typowo administracyjny task. Nadmienię jeszcze, że nie było do tej pory cienia ostrzeżenia od możliwości skasowania tej opcji, a nadto ostrzeżenia o niebezpieczeństwie były wszędzie (razem z czerwonym komunikatem na starcie).

A więc czas na poprawkę - na szczęście istnieje pakiet AUR [makepkg-asroot][3], ale tu problem bo rzecz jasna aktualnie nie możemy kompiliwać pakietów z AURa. Coby zautomatyzować to zadanie można użyć takiego oto skryptu:

```bash
pacman --noconfirm -S fakeroot &&
sudo -u nobody yaourt --noconfirm -S makepkg-asroot
```


zważając na potrzebę wpisania hasła roota (yaourt użyje sudo) i możliwość zignotowania błędu yaourta na koniec (tego o problemie z /root).

Jeśli jak ja uważacie za niepoważny pomysł psucie dystrybucji ucinając możliwość kompilacji pakietów jako root to kontakt do autora tej zmiany znajdziecie [na jego stronie][4].

 [1]: https://projects.archlinux.org/pacman.git/commit/scripts/makepkg.sh.in?id=61ba5c961e4a3536c4bbf41edb348987a9993fdb
 [2]: https://github.com/archlinuxfr/yaourt/issues/67
 [3]: https://aur.archlinux.org/packages/makepkg-asroot
 [4]: http://allanmcrae.com/about/