DeveloperWiki:Ncurses Todo List
===============================

Contents
--------

-   1 Introduction
-   2 Ncurses Rebuild List
    -   2.1 Stage 1
    -   2.2 Stage 2
    -   2.3 Stage 3
    -   2.4 Stage 4

Introduction
============

This article is part of the DeveloperWiki.

Ncurses Rebuild List
====================

This is a list of packages which link to the ncurses libraries (as of
2008-08) and a recommended build order

Stage 1

Packages required for bash to continue working. Note: this probably
requires some bootstraping

    ncurses
    readline
    bash

Stage 2

The rest of base and base-devel:

    dialog
    gettext
    grub
    less
    nano
    procinfo
    procps
    psmisc
    texinfo
    util-linux-ng
    vi  (Requires gettext)

Stage 3

Rebuild rest of [core]:

    gpm
    heimdal
    isdn4k-utils
    links
    netkit-telnet

Stage 4

Packages in [extra]:

    aalib
    abiword-plugins  (Requires aspell, gnutls, smbclient, postgresql-libs, unixodbc, sqlite3, libgda)
    abook
    achessclock  (Source location unknown - remove on next update)
    afterstep  (Requires gnutls, libxml2)
    alpine
    alsa-utils
    aspell
    bc
    blassic
    bs
    bzflag
    cdargs
    cdcd
    centerim
    clisp
    cmake
    cmatrix
    cmus  (Requires lame)
    cscope
    darcs
    ddd
    dopewars
    duhdraw
    elinks
    emacs  (Requires gnutls)
    enigma
    erlang
    ethstatus
    ettercap
    ettercap-gtk  (Requires ettercap)
    evms
    fortunelock
    freeciv  (Requires gnutls)
    fvwm
    fvwm-devel
    gdb
    gftp
    ghc  (Requires bootstraping)
    gnuchess
    giftcurs
    gnome-terminal
    gnugo
    gnuplot  (Requires gnutls)
    gnutls
    gphoto2
    gstreamer-good-plugins  (Requires aalib, gnutls, libxml2)
    guile
    gutenprint  (Requires gnutls)
    gvim  (Requires vim, gnutls)
    hexcurse
    hexedit
    htop
    hugs98 
    iptraf
    irssi
    ispell
    jack-audio-connection-kit
    joe
    kismet  (Requires gnutls)
    lame
    lexter
    lftp
    libcaca
    libcdio
    libgda  (Requires sqlite3, postgresql-libs, unixodbc, libxml2)
    libnjb
    libqalculate  (Requires libxml2)
    librep
    libxml2
    lua
    lynx
    maxima  (Requires clisp)
    mc
    minicom
    moc (Requores jack-audio-connection-kit, lame)
    mplayer  (Requires aalib, gnutls, jack-audio-connection-kit, lame, smbclient)
    mp3blaster
    moon-buggy
    mtr  (Requires gnutls)
    multitail
    mysql-clients
    naim
    ncftp
    ncmpc
    ne
    nethack
    netkit-ftp
    netris
    nph  (Requires termcap-compat)
    nppangband
    ntp
    ocaml
    octave
    openupsmart
    pal
    parted
    pente
    php  (Requires sqlite3)
    pilot-link
    pinentry
    proftpd
    postgresql-libs
    python
    r
    ratpoison
    ruby  (Requires termcap-compat)
    screen
    socat
    sqlite2
    sqlite3
    smbclient
    swi-prolog
    tcsh
    termcap-compat
    terminal  (Requires vte)
    timidity++  (Requires jack-audio-connection-kit, gnutls)
    tin
    uml_utilities
    unixodbc
    vice
    vim  (Requires ruby)
    vte  (Requires gnutls, libxml2)
    w3m
    wvstreams
    xaos  (Requires aalib)
    xawtv (Requires aalib)
    xemacs
    xfsdump
    xine-ui  (Requires lame)
    xorg-server
    xterm
    yabasic
    zile
    zsh
    zsnes

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Ncurses_Todo_List&oldid=161301"

Category:

-   DeveloperWiki

-   This page was last modified on 21 September 2011, at 18:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
