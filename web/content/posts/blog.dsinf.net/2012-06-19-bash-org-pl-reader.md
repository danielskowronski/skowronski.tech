---
title: bash.org.pl reader
author: Daniel Skowroński
type: post
date: 2012-06-19T17:40:34+00:00
url: /2012/06/bash-org-pl-reader/

---
Pierwszy z cyklu odgrzebany program &#8211; czytnik losowych cytatów z bash.org.pl. Zrodził się z potrzeby &#8211; przy przeglądaniu losowych tekstów na samej stronie polskiego bash&#8217;a to co mnie denerwowało to przede wszystkim reklamy oraz zmieniający pozycję w trakcie ładowania witryny przycisk _losowy_. Rozwiązanie? Prosta aplikacja w niechlujnym C#. Jak pomyślał, tak zrobił.  
Jedyne, co warte uwagi w samym algorytmie to metoda ściągająca zawartość strony i wyświetlająca ją tak jak przeglądarka: znaczniki `<br />`, `&lt` i inne na graficzne odpowiedniki.

Główny kod to kilka metod:

<pre class="EnlighterJSRAW csharp">using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text;
using System.Net;
using System.IO;

namespace Bash.org.pl_Reader
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private string http_req(string s)
        {
            // used to build entire input
            StringBuilder sb = new StringBuilder();
            // used on each read operation
            byte[] buf = new byte[2048];
            // prepare the web page we will be asking for
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(@s);
            // execute the request
            HttpWebResponse response = null;
            try { response = (HttpWebResponse)request.GetResponse(); }
            catch { MessageBox.Show("Błąd połączenia sieciowego!!!"); return "-----"; }
            // we will read data via the response stream
            Stream resStream = response.GetResponseStream();
            string tempString = null;
            int count = 0;
            do
            {
                // fill the buffer with data
                count = resStream.Read(buf, 0, buf.Length);
                // make sure we read some data
                if (count != 0)
                {
                    // translate from bytes to ASCII text
                    tempString = Encoding.UTF8.GetString(buf, 0, count);
                    // continue building the string
                    sb.Append(tempString);
                }
            }
            while (count > 0); // any more data to read?

            // print out page source
            return sb.ToString();
        }
        public string wyciagnijTekstOdID(string ID)
        {
            string zawartosc = http_req("http://bash.org.pl/" + ID + "");
            if (zawartosc == "-----") zawartosc = "----- error !!! -----";
            else if (zawartosc.IndexOf("

<title>
  Nie znaleziono
</title>") != -1) zawartosc = "----- error 404 -----";
            else
            {
                string numer = zawartosc;
                numer = numer.Substring(zawartosc.IndexOf("

<title>
  bash.org.pl: cytat "));
                  numer = numer.Substring(27);
                  numer=numer.Substring(0, numer.IndexOf("
</title>"));
                lista.Items.Add(numer);
                numertext.Text = numer;         
                zawartosc = zawartosc.Substring(zawartosc.IndexOf("&lt;div class=\"quote post-content post-body\">") + 45);
                zawartosc = zawartosc.Substring(0, (zawartosc.IndexOf("&lt;/div>")));
                //podmianki
                zawartosc = zawartosc.Replace("\n", "");
                zawartosc = zawartosc.Replace("\r", "");
                zawartosc = zawartosc.Replace("

<br />", "\r\n");
                zawartosc = zawartosc.Replace("<br />", "\r\n");
                zawartosc = zawartosc.Replace("&lt;", "&lt;");
                zawartosc = zawartosc.Replace("&gt;", ">");
                zawartosc = zawartosc.Replace(""", "\"");
                zawartosc = zawartosc.Replace("&nbsp;", " ");
                zawartosc = zawartosc.Replace("&", "&");
                zawartosc = zawartosc.Replace("';", "'");
                zawartosc = zawartosc.Replace("&sect;", "§");
                zawartosc = zawartosc.Replace("&brvbar;", "|");
                zawartosc = zawartosc.Replace("&micro;", "µ");
                zawartosc = zawartosc.Replace("&permil;", "‰");
                zawartosc = zawartosc.Replace("&reg;", "®");
                zawartosc = zawartosc.Replace("&copy;", "©");
                zawartosc = zawartosc.Replace("&#39;", "'");
            } 
            return zawartosc;
        }

        string losujTekst()
        {
            string tekst = wyciagnijTekstOdID("random");
            return tekst;
        }
        public int licznikPermanentny = 0;
        private void losujButton_Click(object sender, EventArgs e)
        {
            tekst.Text = losujTekst();
            licznikPermanentny++;
            numertekst.Text = licznikPermanentny.ToString();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            tekst.Text = "___"; 
        }

        private void idzDoWybranego_Click(object sender, EventArgs e)
        {
            tekst.Text = wyciagnijTekstOdID(lista.SelectedItem.ToString());
            tabControl1.SelectTab(0);
        }

        private void doSchowka_Click(object sender, EventArgs e)
        {
            Clipboard.SetText("http://bash.org.pl/" + numertext.Text);
        }
    }
}
</pre>

[Link][1] do kompletnego projektu wraz z designerem (licencja -&#8222;róbta co chceta&#8221;).

 [1]: /uploaded/programowanie/bashorg_reader.7z