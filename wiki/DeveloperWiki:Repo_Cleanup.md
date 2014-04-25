DeveloperWiki:Repo Cleanup
==========================

  

Contents
--------

-   1 Extra package cleanup
    -   1.1 Goals and ideas
    -   1.2 Packages list
    -   1.3 Candidate to [community]
-   2 Issues

Extra package cleanup
=====================

Goals and ideas
---------------

-   A cleanup of the extra repository
-   Currently we have 441 orphans packages in [extra] (any, i686,
    x86_64)
-   Reduce the packaging work load of the developers
-   Minimise the number of apps per task
-   TUs are easier to appoint and find, it makes sense to move some of
    the workload to the community repo
-   Games should all go to community (except those that come with KDE
    and Gnome)

Packages list
-------------

This packages will be moved to Unsupported, if you want to keep it in
[extra] simply cross it out. Adoption is not required (but would be
nice). If you are a TU and you want to maintain a package in [community]
DO NOT cross it out, but add it to
DeveloperWiki:Repo_Cleanup#Candidate_to_.5Bcommunity.5D

-   abcde
-   archlinux-artwork - artwork
-   archlinux-themes-slim - artwork
-   archlinux-wallpaper - artwork
-   aria2
-   artwiz-fonts
-   aspell-* - languages support
-   atkmm-docs - part of the atkmm package
-   aufs2 - needed by aufs2-util
-   banshee
-   bladeenc
-   bs
-   chkrootkit
-   chromium - adopted by me (foutrelis)
-   clang-analyzer - part of the llvm package
-   cscope - keep this, Dan
-   dosbox
-   eog-plugins - recently updated, ioni/heftig should adopt it
-   eric4-plugins - should be adopted by the eric4 maintainer.
-   ettercap-gtk
-   festival-english - voices for festival
-   festival-us - voices for festival
-   gcdmaster- part of the cdrdao package
-   gnome-alsamixer
-   gnupod
-   gperf - makedependence of various packages
-   gptfdisk - keep this, Ionut
-   gqmpeg
-   gtk-theme-switch2
-   gtkmm3-docs - parf ot the gtkmm3 package
-   haskell-platform - up to Vesa
-   haskell-tar - up to Vesa
-   hunspell-hu - languages support
-   hunspell-ln - languages support
-   hyphen-hu - languages support
-   hyphen-nl - languages support
-   icecast
-   imap - needed by php
-   ipod-sharp
-   iptraf-ng
-   ispell - needed by hunspell-de
-   kernel26-manpages - part of the kernel26 package
-   kmldonkey
-   kmplayer
-   krusader - keep this, Andrea
-   laptop-mode-tools - keep this, Andrea
-   libbtctl
-   llvm-ocaml - part of the llvm package
-   ltrace - adopted by me (foutrelis)
-   mailman - keep this, Andrea
-   mc
-   meld
-   mm-common - needed by gtkmm3
-   monotone
-   mythes-hu - languages support
-   mythes-nl - languages support
-   nbsmtp
-   nickle
-   nppangband
-   numlockx
-   obconf - keep this for OpenBox users, Andrea
-   perl-text-csv
-   perl-text-patch - needed by perl-alien-sdl
-   proftpd - keep this, Andrea
-   python-gtkglext
-   qt3-doc - part of the qt3 package
-   ruby-docs - part of the ruby package
-   slim-themes - themes for slim
-   speedcrunch
-   tango-icon-theme-extras
-   texi2html - needed by qemu
-   ttf-cheapskate
-   ttf-fireflysung - keep this for i18n support, Eric
-   ttf-tibetan-machine - keep this for i18n support, Eric
-   ttf-ubraille - keep this for blind users, Andrea
-   vbetool
-   vim-a
-   vim-bufexplorer
-   vim-colorsamplerpack
-   vim-doxygentoolkit
-   vim-guicolorscheme
-   vim-minibufexpl
-   vim-omnicppcomplete
-   vim-project
-   vim-taglist
-   vim-vcscommand
-   vim-workspace
-   xchat-gnome
-   xf86-input-wacom - up to Jan
-   xorg-xfontsel - up to Jan
-   xorg-xlsfonts - up to Jan
-   xorg-xvidtune - up to Jan

Candidate to [community]
------------------------

-   abcde - (schuay)
-   aria2 - I have used this occasionally in the past for torrents, so I
    would be willing to maintain this fine utility (td123)
-   dosbox - Good stuff (svenstaro)
-   gtk-theme-switch2 - (cryptocrack)
-   icecast - (cryptocrack)
-   mc - (schuay)
-   nickle - (cryptocrack)
-   numlockx - (cryptocrack)
-   tango-icon-theme-extras - (cryptocrack)
-   vbetool - (cryptocrack)
-   vim-a - (svenstaro)
-   vim-bufexplorer - (svenstaro)
-   vim-colorsamplerpack - (svenstaro)
-   vim-doxygentoolkit - (svenstaro)
-   vim-guicolorscheme - (svenstaro)
-   vim-minibufexpl - (svenstaro)
-   vim-omnicppcomplete - (svenstaro)
-   vim-project - (svenstaro)
-   vim-taglist - (svenstaro)
-   vim-vcscommand - (svenstaro)
-   vim-workspace - (svenstaro)

Issues
======

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Repo_Cleanup&oldid=196105"

Category:

-   Package development

-   This page was last modified on 23 April 2012, at 11:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
