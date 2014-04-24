Gcin
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 About
-   2 Installation
    -   2.1 Installing other input tables
-   3 Configuration
    -   3.1 Autostart
-   4 Usage
    -   4.1 With GNOME/GTK+ 2 applications
    -   4.2 With other applications
    -   4.3 Additional notes for Wine/Crossover Office

About
-----

Gcin is a new generation of Chinese input method server developed by
Edward Liu. Gcin supports various input methods and works under most
Unix-like operating systems. It's one of the most popular Chinese input
engines in Taiwan.

Installation
------------

Install gcin from the official repositories.

> Installing other input tables

MISSING

Configuration
-------------

> Autostart

Use xprofile to execute these commands automatically:

     export XMODIFIERS=@im=gcin
     export LC_CTYPE=zh_TW.UTF-8
     gcin &

Usage
-----

> With GNOME/GTK+ 2 applications

gcin provides a gtk input module, thus all gtk2-based applications are
directly supported, there is no need to configure anything after
installation (it's not XIM, and gcin is automatically started when
needed).

> With other applications

1. Set environment locale to use UTF-8, for example:

    export LC_CTYPE=en_US.UTF-8

Note:You must set the LC_CTYPE locale even if it's the same as LANG,
otherwise gcin may not be activated in non-gtk2 programs that use x
input.

  
 2. Set XMODIFIERS:

    export XMODIFIERS=@im=gcin

gcin uses the name "gcin" by default and you can change this with the
environment variable GCIN_XIM in order to run multiple gcin instances,
for example:

    export GCIN_XIM=gcin_zh
    export XMODIFIERS=@im=gcin_zh

Remember that gtk2 applications start one instance of gcin automatically
if it doesn't exist.

3. Start gcin:

    gcin &

4. Run your applications! If gcin is killed when your applications are
running, it's likely to cause crash or other problems.

> Additional notes for Wine/Crossover Office

1.  If you run wine or Crossover Office, it's better to use Windows 2000
    emulation instead of Windows 98, and you have to start gcin and
    wine/cxoffice with at least LC_CTYPE=zh_TW.utf8, otherwise wine
    won't be able to show Chinese correctly.

1.  In wine+IE6 with Windows 98 emulation, LC_CTYPE isn't enough if you
    want to input Chinese on the web-pages - you have to set either LANG
    or LC_ALL to zh_TW.utf8, which slows down wine a lot. However, you
    can always type Chinese in the location bar or other places and
    paste it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gcin&oldid=265244"

Category:

-   Internationalization

-   This page was last modified on 6 July 2013, at 08:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
