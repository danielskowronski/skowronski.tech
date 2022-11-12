---
title: Jak pomyślał tak zrobił, czyli historia DS progress’a
author: Daniel Skowroński
type: post
date: 2012-08-20T16:47:13+00:00
url: /2012/08/jak-pomyslal-tak-zrobil-czyli-historia-ds-progressa/
tags:
  - c++
  - szybkie aplikacje

---
Przetwarzając manualnie stertę katalogów doszedłem do potrzeby zwizualizowania postępu mojej pracy - głównie by się nie poddawać, ale przemyślenia nad tym problemem dawały mi chwile wytchnienia. I tak zrodził się **DS progress**, czyli jak go opisałem, **ulatwiacz kontroli postępu pracy**.  
![DS Progress v0.2 main window](/wp-content/uploads/2012/08/dsprogressv0-02_screen.png)  
Aplikacyjka trywailan i naturalnie napisana w C# w jakieś 20 minut razem z (mam nadzieję) ladnym designem i dpracowaniem fukcjonalności. Generalnie sprowadza się ona do progress bara i przycisków plus/minus. Istnieje jednak możliwość definiowania postępu "z palucha" oraz zmiany celu (domyślnie 100) i naturalnie zresetowania licznika. Tym co zajęło mi w kodzie najwięcej bo aż 3 linijki było ustrzymywanie label'ki z informacją tekstową o progresie w centrum paska postępu.  
Nie wiem, czy kod jest godny męczyć SyntaxHighlightera, ale skoro ładnie to wygląda to wstawię:

<pre class="EnlighterJSRAW csharp">using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ds_progress
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        private void refresh()
        {
            progressBar1.Refresh();
            button_minus.Refresh();//z niewiadomych przyczyn ten button się czasem kasuje

            label_progress.Text = progressBar1.Value + "/" + progressBar1.Maximum;
            //utrzymywanie labelki dokładnie w środku progress bar'a
            Point punkt = label_progress.Location;
            punkt.X=progressBar1.Location.X + progressBar1.Width / 2 - label_progress.Width / 2;
            label_progress.Location = punkt;
        }
        private void button_reset_Click(object sender, EventArgs e)
        {
            progressBar1.Value = 0;
            refresh();
        }

        private void button_changeValue_Click(object sender, EventArgs e)
        {
            try
            {
                progressBar1.Value = int.Parse(textBox_changeVal.Text);
                refresh();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Coś jest nie tak z wartością powyżej. \nSpróbuj jeszcze raz");
            }
        }

        private void button_changeMax_Click(object sender, EventArgs e)
        {
            try
            {
                progressBar1.Maximum = int.Parse(textBox_changeMax.Text);
                refresh();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Coś jest nie tak z wartością powyżej. \nSpróbuj jeszcze raz");
            }
        }

        private void button_minus_Click(object sender, EventArgs e)
        {
            if (progressBar1.Value &gt; 0)
            {
                progressBar1.Value--;
                refresh();
            }
        }

        private void button_plus_Click(object sender, EventArgs e)
        {
            if (progressBar1.Value &lt; progressBar1.Maximum)
            {
                progressBar1.Value++;
                refresh();
            }
            if (progressBar1.Value == progressBar1.Maximum) 
            {
                MessageBox.Show("SUKCES!\nOsiągnięto zadany postęp");
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            MessageBox.Show(
                "DS progress.  Podręcznik użytkownika\n\n" +
                "Przycisk \"zmień obecną wartość\" i pole powyżej niego umżliwiają wprowadzenie wartości początkowej\n" +
                "Przycisk \"reser\" umożliwia wyzerowania paska postępu\n" +
                "Przycisk \"zmień wartość zadaną\" i pole powyżej niego umżliwiają zmianę maksimu paska postępu (n.p.) ilość stron do przeczytania\n" +
                "Przyciski \"-\" po lewej i \"+\" po prawej umożliwiają kontrolę wartości\n"
                );
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            MessageBox.Show(
                "DS progress by Daniel Skowroński &lt;d.skowronski@ds.lublin.pl&gt;\n" +
                "This software is released under \"róbta co chceta\" (\"do what you want\") so it's free and open source, I am not responsible for any destruction it may provide and you can do with it anything you want (even you as MS programmer can implement to Windows Server and sell as your software), but I appreciate adding info that I'm the original author. Thank you."
                );
        }
    }
}</pre>

Klasycznie w przypadku tak małego programiku licencja "róbta co chceta", [DS Progress VS 2012 Solution][2]. Ale uwaga: _solution_ powstał pod VisualStudio 2012 (RC), więc być może nie zadziała z wersją 2010.

 [1]: /wp-content/uploads/2012/08/dsprogressv0-02_screen.png
 [2]: /wp-content/uploads/2012/08/ds_progress.zip