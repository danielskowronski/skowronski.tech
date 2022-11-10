---
title: 22 lata jądra Linuksa – wypowiedzi Linusa z początku historii systemu, który zmienił świat
author: Daniel Skowroński
type: post
date: 2013-09-17T14:33:46+00:00
excerpt: '17 września 1991 Linus wypuścił pierwszą wersję systemu, który zmienił świat - Linux 0.01'
url: /2013/09/22-lata-jadra-linuksa-wypowiedzi-linusa-z-poczatku-historii-systemu-ktory-zmienil-swiat/
tags:
  - historia
  - linux

---
22 lata temu Linus wypuścił pierwszą wersję systemu, który zmienił świat &#8211; Linux 0.01

Wszystko zaczęło się od słynnego wpisu na grupie comp.os.minix z 26 sierpnia 1991:

> Hello everybody out there using minix &#8211;
> 
> **I&#8217;m doing a (free) operating system (just a hobby, won&#8217;t be big and  
> professional like gnu)** for 386(486) AT clones. This has been brewing  
> since april, and is starting to get ready. I&#8217;d like any feedback on  
> things people like/dislike in minix, as my OS resembles it somewhat  
> (same physical layout of the file-system (due to practical reasons)  
> among other things).
> 
> I&#8217;ve currently ported bash(1.08) and gcc(1.40), and things seem to work.  
> This implies that I&#8217;ll get something practical within a few months, and  
> I&#8217;d like to know what features most people would want. Any suggestions  
> are welcome, but I won&#8217;t promise I&#8217;ll implement them 🙂
> 
> Linus (torv&#8230;@kruuna.helsinki.fi)
> 
> PS. Yes &#8211; it&#8217;s free of any minix code, and it has a multi-threaded fs.  
> It is NOT protable (uses 386 task switching etc), and it probably never  
> will support anything other than AT-harddisks, as that&#8217;s all I have :-(.

Potem &#8211; 17 września na FUNET (sieć łączącą kraje skandynawskie) została wrzucona wersja 0.01. Można ją wciąż pobrać z tąd &#8211; [http://ftp.funet.fi/pub/Linux/PEOPLE/Linus/Historic/linux-0.01.tar.gz][1]

Dopiero 5 października Linus uznał, że wersja 0.02 się do czegoś nadaje. I napisał tak:

> Do you pine for the nice days of minix-1.1, **when men were men and wrote  
> their own device drivers?** Are you without a nice project and just dying  
> to cut your teeth on a OS you can try to modify for your needs? Are you  
> finding it frustrating when everything works on minix? No more all-  
> nighters to get a nifty program working? Then this post might be just  
> for you 🙂
> 
> As I mentioned a month(?) ago, I&#8217;m working on a free version of a  
> minix-lookalike for AT-386 computers. It has finally reached the stage  
> where it&#8217;s even usable (though may not be depending on what you want),  
> and I am willing to put out the sources for wider distribution. It is  
> just version 0.02 (+1 (very small) patch already), but I&#8217;ve successfully  
> run bash/gcc/gnu-make/gnu-sed/compress etc under it.
> 
> Sources for this pet project of mine can be found at nic.funet.fi  
> (128.214.6.100) in the directory /pub/OS/Linux. The directory also  
> contains some README-file and a couple of binaries to work under linux  
> (bash, update and gcc, what more can you ask for :-). Full kernel  
> source is provided, as no minix code has been used. Library sources are  
> only partially free, so that cannot be distributed currently. The  
> system is able to compile &#8222;as-is&#8221; and has been known to work. Heh.  
> Sources to the binaries (bash and gcc) can be found at the same place in  
> /pub/gnu.
> 
> ALERT! WARNING! NOTE! These sources still need minix-386 to be compiled  
> (and gcc-1.40, possibly 1.37.1, haven&#8217;t tested), and you need minix to  
> set it up if you want to run it, so it is not yet a standalone system  
> for those of you without minix. I&#8217;m working on it. You also need to be  
> something of a hacker to set it up (?), so for those hoping for an  
> alternative to minix-386, please ignore me. It is currently meant for  
> hackers interested in operating systems and 386&#8217;s with access to minix.
> 
> The system needs an AT-compatible harddisk (IDE is fine) and EGA/VGA. If  
> you are still interested, please ftp the README/RELNOTES, and/or mail me  
> for additional info.
> 
> **I can (well, almost) hear you asking yourselves &#8222;why?&#8221;. Hurd will be  
> out in a year (or two, or next month, who knows), and I&#8217;ve already got  
> minix. <u>This is a program for hackers by a hacker.</u> I&#8217;ve enjouyed doing  
> it, and somebody might enjoy looking at it and even modifying it for  
> their own needs.** It is still small enough to understand, use and  
> modify, and I&#8217;m looking forward to any comments you might have.
> 
> I&#8217;m also interested in hearing from anybody who has written any of the  
> utilities/library functions for minix. If your efforts are freely  
> distributable (under copyright or even public domain), I&#8217;d like to hear  
> from you, so I can add them to the system. I&#8217;m using Earl Chews estdio  
> right now (thanks for a nice and working system Earl), and similar works  
> will be very wellcome. Your (C)&#8217;s will of course be left intact. Drop me  
> a line if you are willing to let me use your code.
> 
> Linus
> 
> PS. to PHIL NELSON! I&#8217;m unable to get through to you, and keep getting  
> &#8222;forward error &#8211; strawberry unknown domain&#8221; or something.

FUNET działa dalej i ma większość starych źródeł &#8211; http://ftp.funet.fi/pub/Linux/PEOPLE/Linus/  
A Tobie do czgo jest potrzebny Linuks? http://joemonster.org/filmy/13267 😉

 [1]: http://ftp.funet.fi/pub/Linux/PEOPLE/Linus/Historic/linux-0.01.tar.gz "http://ftp.funet.fi/pub/Linux/PEOPLE/Linus/Historic/linux-0.01.tar.gz"