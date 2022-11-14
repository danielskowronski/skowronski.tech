---
title: Ręczne delegowanie maili – skrypt w Pythonie, v2
author: Daniel Skowroński
type: post
date: 2013-03-06T22:24:07+00:00
url: /2013/03/reczne-delegowanie-maili-skrypt-w-pythonie-v2/
tags:
  - pop3
  - python
  - smtp

---
Są jeszcze na tym świecie systemy teleinformatyczne, w których ktoś systemu poczty nie oparł na Gmailu, czy na czymkolwiek co ma jakiekolwiek możliwości importowania maili. Są sytuacje, gdy konto, z którego chcemy odbierać pocztę to WP i musimy im zapłacić(!) za delegowanie maili. Trzeba działać szybko, ale i na ograniczonym polu (shell bez roota). Jedyne, co przychodzi na myśl (poza rzecz jasna słowami "nie da się") to skrypt w Pyhtonie.  
<!--break-->

Zadanie: pobrać maile ze skrzynki na WP i wysłać je na konto na innym serwerze, posiadając serwer SMTP u mnie lokalny. Trzeba to robić okresowo i nie może wymagać dużego nakładu zasobów.

Ten skrypt wykorzystuje kilka ciekawych funkcji Pythona. Ale po kolei. Na początek kilka zmiennych - _verbose_ określa, czy mają wyświetlać się komunikaty o każdym mailu (ważne przy pierwszym uruchomieniu lub robieniu logów), kolejne to dane logowania do POP3, a ostatnia linia opisuje do kogo przekazujemy maila.

Obsługa dat jest nieco pokrętna w Pythonie, toteż wolałem zrobić funkcję tworzącą timestamp, bo jest to dosyć unikalna wartość, prosta do obliczania i przechowywania:

```python
import email.utils

def ts(x):
  """zwraca czas od rozpoczęcia epoki"""
  return time.mktime(email.utils.parsedate(x))

```


Dleczego funkcja do konwersji daty jest w bibliotece email? Nie mam pojęcia. 

Więcej kodu znajdziemy w funkcji:

```python
def starsze(co, odczego):
  co = ts(co)
  odczego = ts(odczego)
  if co <= odczego :
    return True
  else:
    return False

```


Pozwala ona prosto spradzić, czy data jest starsza (a właściwie nie nowsza) od wskazanej.

Teraz ładujemy datę ostatnio przekazanego maila - naprostsza metoda decydowania, które maile są naprawde nowe. Wykorzystywany jest jeden plik (którego kasacja zaleje odbiorcę falą duplikatów maili), ale już sprytnie zapobiegamy brakowi pliku. Jeszcze tylko zabezpieczenie przed zbłąkanym CR/LF w pliku i możemy wydrukować na ekran datę startu.

```python
try:
  f = open('last_mail.NIE_KASUJ', 'r')
  ostatni = f.readline()
  f.close()
except:
  ostatni = "Wed, 01 Nov 1969 00:00:00 +0000"
ostatni.replace('\n', '')
ostatni.replace('\r', '')
print "Laduje ostatnia date jako:   "+ostatni

```


Łączymy się z serwerem POP3 i pobieramy liczbę maili

```python
pop_conn = poplib.POP3_SSL(pop3_server)
pop_conn.user(pop3_login)
pop_conn.pass_(pop3_pass)

ilosc = len(pop_conn.list()[1])

```


Po przygotowaniu pętli i zmiennych można przestąpić do wywołania while'a:

```python
while (i < ilosc):
	wiad = [pop_conn.retr(i)]
	wiad = ["\n".join(a[1]) for a in wiad]
	wiad = [parser.Parser().parsestr(a) for a in wiad]
	wiad = wiad[0]
	if i==1:
		pierwsza = wiad #jak to pierwszy mail to zachowaj kopie w pamieci podrecznej
	data = wiad['date']
	if starsze(data, ostatni):
		print 'Starszy mail => koniec:      '+wiad['date']+''
		break
	else:
		list(wiad)
	i+=1

```


Dziwne operacje na zmiennej wiad służą po kolei pobraniu jej, zklejeniu oktetów w krotkę i przeparsowaniu w zmienną typu email. Pierwszy if w tym kodzie służy do zapisania daty pierwszej wiadomości - to ona stanie się datą graniczną (skrzynka pocztowa to kolejka LIFO). Funkcja list(wiad) przesyła wiadomość dalej. Wykorzystuje tę właściwość, że email jest jednego typu i nie trzeba ściąć wszystkich nagłówków, załączników, bawić się w MIME i kodowanie (jak początkow myślałem), tylko wskazać zmienną. Ciało funkcji:

```python
def list(w):
	"""obrabia konkretny list i wysyła go"""
	if verbose:
	  print "Nowy mail (przekazuje dalej): "+w['date']+" od <"+w['from']+">"

	msg = w
	s = smtplib.SMTP('localhost')
	s.sendmail(smtp_fromWho, smtp_toWho, msg.as_string())
	s.quit()

```


Na koniec tylko zapisać plik z datą:

```python
ostatni = pierwsza['date']
print "Zapisuje ostatnia date jako: "+ostatni
f = open('last_mail.NIE_KASUJ', 'w')
ostatni = f.write(ostatni)
f.close()

```


i tyle. 

Podsumowując:  
skrypt pobiera wiadomości analizując datę ich nadejścia i w niezmienionej formie po prostu wysyłą je przez SMTP. Znaczy to ni mniej ni więcej, że spryciarze korzystający z emkei.cz, a profesjonaliści "emacsem przez sendmaila" wysyłając list z cofniętą datą mogą zostać zignorowani przez system.  
Skrypt fajnie umieścić w cronie na co 5 minut, żeby admin nie założył nam ograniczeń co do czasu CPU i opłat za przekroczenie 😉 Swoją drogą nazwa programu wzięła się od samochodu admina systemu dla którego ten skrypt powstał.  
<a href="http://blog.dsinf.net/?attachment_id=175" rel="attachment wp-att-175">corsa_mail_transport.py</a>