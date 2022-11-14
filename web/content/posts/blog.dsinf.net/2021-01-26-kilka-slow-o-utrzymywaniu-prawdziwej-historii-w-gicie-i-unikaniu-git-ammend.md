---
title: Kilka słów o utrzymywaniu prawdziwej historii w gicie i unikaniu git ammend
author: Daniel Skowroński
type: post
date: 2021-01-26T19:10:44+00:00
url: /2021/01/kilka-slow-o-utrzymywaniu-prawdziwej-historii-w-gicie-i-unikaniu-git-ammend/

---
 

Tematem tego wpisu jest praktyka, którą zauważyłem zwłaszcza u młodszych programistów podczas pracy na feature branchach - poprawianie literówek, czy drobnych błędów w systemach kontroli wersji typu git za pomocą `git ammend`. Moim zdaniem nie jest to zbyt uczciwe głównie wobec siebie.

Pokusa, by poprawić literówkę w komentarzu, czy zrobić typową poprawkę w rodzaju `+1` za pomocą `git commit --ammend`, a następnie wypchnąć zmiany do centralnego repozytorium, nadpisując historię zdalnego repozytorium, jest szczególnie duża, kiedy w użyciu jest jakiś system budowania lub pipeline CI/CD, którego nie można uruchomić lokalnie. Przykładowo może to być kod Puppeta, który można przetestować jedynie z danymi na puppet-masterze, czy kickstart dla maszyny wirtualnej - taki kod musi znaleźć się w repozytorium, aby narzędzia budujące mogły go pobrać - to zaś jest niezbędne, żeby przetestować zmianę.

Najczęściej na jednym commicie poprawiającym "drobną rzecz" się nie kończy i niekiedy w całym feature branchu jest jeden commit, a praca trwała cały dzień i kilkadziesiąt buildów. 

Moim zdaniem takie nadpisywanie historii jest bardzo problematyczne - poza ukrywaniem historii pracy przed samym sobą i innymi może tworzyć niebezpieczny nawyk nadpisywanie historii poza branchem, nad którym pracuje tylko jedna osoba.

Zajmijmy się najpierw ukrywaniem historii przed samym sobą. Pierwszy problem z takim podejściem polega na tym, że udajemy jako developerzy, iż tworzymy kod idealny za jednym podejściem i nie popełniamy błędów. Dopiero wraz z prawdziwym doświadczeniem (nie zaś udawanymi tytułami _senior_, czy _principal_) w branży rośnie świadomość inżynierów, że kod doskonały to tysiące poprawek i zmian całych koncepcji, a nawet takiego tworzenia kodu, aby był w miarę zabezpieczony przed naszymi własnymi błędami. Drugi problem to utrata historii zmian - tak przydatnej, kiedy po kilku godzinach wypychania zmian zechcemy sprawdzić, dlaczego pewien fragment kodu działał. Historia Ctrl+Z w edytorze tekstowym jest ograniczona.

Następny aspekt dotyczy widoczności zmian dla innych. Jeśli w trakcie pracy każdy commit będzie zawierał uwagę, dlaczego zmieniliśmy akurat zmienną `x` o `+1` to inni developerzy skorzystają na tym podczas analizy kodu w przyszłości dalszej - podczas _postmortem_, lub bliższej - podczas _code review_. Ponadto w zespołach będących częścią większej organizacji historie commitów mogą być jednym ze zbiorów danych używanych do tworzenia metryk, a takie nadpisywanie jest ukrywaniem złożoności procesu tworzenia oprogramowania lub sposobu pracy developerów. 

Ostatni aspekt dotyczący tworzenia złego nawyku nadpisywania historii u innych może się wydawać nieco przesadzony, lecz zwłaszcza początkujący developerzy są na niego podatni, a nie jest to coś, o czym zwykle uczy się na kursach programowania czy na uniwersytetach. Repozytoria oparte o gita używane przez ponad jedną osobę bardzo nie lubią operacji _force push_ - głównie dlatego, że inny użytkownik będzie miał konflikt zmian i ucierpi na tym integralność kodu. Zwykle serwery centralne (takie jak GitLab, BitBucket czy Stash) mają jakieś mechanizmy zabezpieczające i pozwalają na kontrolę dostępu do wybranych branchy, często na tyle granularną, że samego nadpisania historii można zabronić każdemu. 

Zazwyczaj jednak kilka osób musi jednak mieć pełne uprawnienia administracyjne na projekcie - w tym inżynier automatyzacji, który nie musi być doświadczony. W najgorszym dla takiego scenariusza wypadku będzie to "inżynier DevOps", którym został developer wrobiony w zajmowanie się pipeline'ami, czy release managementem z nadzieją na rozwój zawodowy. Wtedy wystarczy jakaś drobna zmiana w kodzie, którą trzeba wprowadzić na szybko podczas okienka deploymentowego i o tragedię związaną z nadpisaniem historii tak, żeby nazwa commitu się zgadzała - gotowa. Czasem też twórcy pipeline'ów tworzą numery wersji na podstawie ilości commitów od wybranego punktu w drzewie - to jeszcze bardziej zachęca do nadpisywania historii na głównych branchach podczas deploymentów.

Drobna dygresja - w kilkuletniej pracy z systemami kontroli wersji tylko raz spotkałem się z sytuacją, gdzie trzeba było realnie uważać na możliwość nadpisania historii - miało to miejsce podczas obsługi awarii serwera Azure DevOps (dawny TFS - Microsoft Team Foundation Server) podczas której, nie mieliśmy 100% pewności, czy udało nam się odtworzyć bazę danych do ostatniego punktu w czasie, kiedy serwer przyjmował pushe od użytkowników.

Reasumując bardziej pogadankowy niż techniczny artykuł - nadpisywanie historii nawet na własnych feature branchu jest brakiem uczciwości wobec samego siebie, utrudnianiem pracy sobie i innym oraz może prowadzić do wyrobienia niebezpiecznego nawyku.