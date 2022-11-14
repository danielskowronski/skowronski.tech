---
title: Uruchamianie czegokolwiek poza Windowsem na tablecie typu Win8.1 z UEFI
author: Daniel Skowroński
type: post
date: 2015-06-20T20:26:57+00:00
summary: |
  |
    Sprzedawane od jakiegoś czasu tanie tablety z Windows 8.1 stojące na Intelu (tak z 90% na Atomie Z3735E + 1-2GB RAM) na przykład Colorovo CityTab Supreme 8H mają nietrywialny sposób rozruchu innego systemu operacyjnego. Pierwsza przeszkoda to ukochane przez linuksiarzy UEFI - nie ma bowiem opcji legacy BIOS. Druga kwestia to fakt, że to UEFI jest 32-bitowe. Ale wszystko da się obejść.
url: /2015/06/uruchamianie-czegokolwiek-poza-windowsem-na-tablecie-typu-win8-1-z-uefi/
tags:
  - bios
  - grub
  - linux
  - tablet
  - uefi

---
Sprzedawane od jakiegoś czasu tanie tablety z Windows 8.1 stojące na Intelu (tak z 90% na Atomie Z3735E + 1-2GB RAM) na przykład Colorovo CityTab Supreme 8H mają nietrywialny sposób rozruchu innego systemu operacyjnego. Pierwsza przeszkoda to ukochane przez linuksiarzy UEFI - nie ma bowiem opcji _legacy BIOS_. Druga kwestia to fakt, że to UEFI jest 32-bitowe. Ale wszystko da się obejść.

Po pierwsze wejdźmy do ~~BIOSu~~ UEFI. Będzie nam potrzebny kabel USB OTG (nawet w najtańszych modelach go dają), aktywny hub usb (wbudowany port może i zasili pendrive'a albo klawiaturę, ale nie obie rzeczy na raz; o zewnętrznym CD-ROMie nie wspominając) oraz klawiatura. Podłączywszy wszystko robimy to co na zwykłym PC - losujemy klawisz który otwiera setup (często bywa to jednak [Esc]). W tym momencie warto przejrzeć wszystko i zachować rozwagę - dużo ustawień nic nie zmienia, a niektóre sugerują na przykład, że posiadamy kartę ethernet obsługującą [SR-IOV][1]. Znowu na 90% wersja naszego UEFI to **Aptio Setup Utility**. Warto w zakładce _security_ odnaleźć ustawienie _secure boot_ i je wyłączyć.

Z opcji _boot override_ zobaczymy, że bootować można tylko nośniki z EFI - jak coś go nie ma to nie jest listowane. Ale podpięcie napędu CD ze zwykłym Linuchem z UEFI też nic nie da. Próba wejścia do EFI-shell'a (powinien być dostępny z menu jako opcja wbudowana) i załadowania ręcznie binarki ujawni źródło problemu - otóż UEFI na takich tabletach jest **32 bitowe**.

Drobna dygresja na temat powodu tej decyzji projektowej. Z jednej strony - "M$ strong" i utrudnianie linuksowcom życia - UEFI powstało specjalnie dla 64bitowych platform  i nikt nie kompiluje gruba z efi na i386. Z drugiej zaś - nikt nie stawia 64-bitowego windowsa na takich tabletach - ani nie wykorzysta się ich mozliwości, a nadto posiadają spory (jak na tablety za nawet $100) narzut - pamięci i przestrzeni dyskowej. Więc i UEFI się robi 32-bitowe. Jakoś na dziwniejsze decyzje projektowe twórców platform z Androidem nikt nie narzeka.

Co zatem robimy? Pobieramy standalone obraz [SuperGrubDisk2][2] (gruba z kilkoma skryptami wykrywającymi systemy operacyjne na cd/usb) dla platform EFI, ale taki, który obsłuży i386. Jakoś się nie kompiluje autorowi w nowszych wersjach więc trzeba używać nieco starszej, np. [super\_grub2\_disk\_standalone\_i386\_efi\_2.00s2.EFI][3].  Teraz się przyda dowolny pendrive (wątpię, żeby ktoś miał tak małego, żeby się nie zmieściła ta jedna binarka). Formatujemy na **FAT32 **(vfat może nie zadziałać; a ja już mamy fata, to formatować nie musimy) i wgrywamy plik do lokalizacji `/EFI/boot/bootia32.efi` . Musi być dokładnie taka, albo UEFI nie wykryje tego automatycznie i tylko EFI-shell pozwoli zabootować obraz. Teraz można podpiąć docelowy nośnik, na przykład CD-ROM i z pomocą Super GRUB Diska go zabootować. Jeśli instalujemy system grub pozwala się skompilować do trybu EFI dla i386.

&nbsp;

**Aktualizacja 2018**:

Podczas próby przywrócenia tego tabletu do ustawień fabrycznych wyszedł na jaw jeszcze jeden problem - rodem z Visty - potrzeba obrazu OEMowego. Ale że czasy true-OEM się skończyły to okazuje się że Windows 8 był sprzedawany producentom także w wersji "CoreConnect" - czyli "with Bing". Obrazu nie da się pobrać od Microsoftu, ale da się pobrać go z torrentów - albo najpopularniejszą angielską wersję językową, albo i rodzimą (głównie na polskich forach). Wersja OEM CoreConnect sama wyciąga sobie serial zaszyty w ACPI więc nie ma potrzeby ręcznego exportu. Niestety pobrane obrazy boxowe (Pro czy Home) nie zaakceptują klucza, ani nie uznają go w procesie _Windows Anytime Upgrade_ (który umie robić też downgrade z Pro do Home). Obraz którego trzeba szukać ma nazwę i sumę kontrolną:

```
X19-57134_SW_DVD9_NTRL_Win_with_Bing_8.1_32BIT_English_OEM.img
sha256: c1ba33a6087c89545447f6bf276d76871bdfd8eea488d0a2d4ab5058fd4cef3f
```


&nbsp;

 [1]: http://blog.scottlowe.org/2009/12/02/what-is-sr-iov/ "SR-IOV"
 [2]: http://www.supergrubdisk.org/
 [3]: http://forja.cenatic.es/frs/download.php/file/1764/super_grub2_disk_standalone_i386_efi_2.00s2.EFI