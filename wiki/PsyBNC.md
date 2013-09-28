PsyBNC
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Installing psyBNC
-----------------

psyBNC is available from the AUR.

It can be installed two ways:

1 ) With your favorite AUR Download and Management script
AUR_User_Guidelines#AUR-DMS_.28downloading_and_management_scripts.29

2 ) Manually by downloading the PKGBUILD from AUR and running

    makepkg -c && pacman -U psybnc

Note: You should probably read AUR and familiarize yourself with the AUR
system beforehand.

Post-Install
------------

After you have installed psybnc you must run make menuconfig.

    cd /usr/bin/psybnc
    make menuconfig

This will spawn the psybnc configure program which requires ncurses. If
you do not have ncurses use make menuconfig-curses. This will create a
valid psybnc.conf. To use the default settings just hit exit as soon as
it opens.

It is also suggested that you chown everything in /usr/bin/psybnc/ to
the user that you will use to run psybnc.

If you would like to create psybnc.conf manually (or for more
information about configuring psybnc), you may find the official psybnc
help and LunarShells.com psybnc Tutorial helpful.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PsyBNC&oldid=241353"

Category:

-   Internet Relay Chat
