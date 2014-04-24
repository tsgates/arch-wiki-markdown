Sync laptop desktop
===================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Keeping laptop in sync
-   2 Solutions
    -   2.1 Unison
        -   2.1.1 Caveats
    -   2.2 rsync
    -   2.3 rdiff-backup

Keeping laptop in sync
----------------------

Ever since I acquired a laptop, I thought about how to keep my laptop up
to date with my home computer, and vice versa. You cannot just cp one
image to the other, for many reasons. For example, some files simply
have to differ on both machines, and sometimes there are updates on one
computer, and updates on the other computer.

Solutions
---------

> Unison

URL: Unison

http://caml.inria.fr/about/successes-images/unison.jpg

This is my favorite solution, and I absolutely love it. I have tried a
lot of tools, but this one beats them all hand down. It is easy to
configure, and yet still secure and flexible.

You need to have ssh on both machines, and unison installed on both
machines (your laptop and desktop). Then with a few simple commands you
can synchronise directories, and in a GUI you can select which things
you wish to have synchronised and which not. You can also resolve
conflicts.

I use the following scripts:

~/.unison/electra.prf (My laptop)

    root = /home/hugo
    root = ssh://pyros//home/hugo
    follow = Path school
    include common

~/.unison/pyros.prf (My desktop)

    root = /home/hugo
    root = ssh://electra//home/hugo
    follow = Path school
    include common

~/.unison/common

    ignore = Regex .*(cache|Cache|te?mp|history|thumbnails).*
    ignore = Name sylpheed.log*
    ignore = Name unison.log
    ignore = Name .ICEauthority
    ignore = Name .Xauthority
    ignore = Path {.songinfo,.radinfo}
    ignore = Path .adesklets
    ignore = Path .Azureus
    ignore = Path .forward
    ignore = Path adesklets
    ignore = Path .ethereal
    ignore = Path .sheep
    ignore = Path .xinitrc
    ignore = Path .config
    ignore = Path .xscreensaver
    ignore = Path .xawtv
    ignore = Path .radio
    ignore = Path .forward
    ignore = Path .dc++
    ignore = Path .quodlibet
    ignore = Path .tvtime
    ignore = Path .config/graveman
    ignore = Path .xmodmap
    ignore = Path .java
    ignore = Path .tvlist*
    ignore = Path .thumbnails
    ignore = Path .ssh
    ignore = Path .viminfo
    ignore = Path .vim/tmp
    ignore = Path Desktop
    ignore = Path .wine*
    ignore = Path motion
    ignore = Path src/ufobot/test_pipe
    ignore = Path tmp
    ignore = Path local
    ignore = Path books
    ignore = Path .mozilla/firefox/*/Cache*
    ignore = Path .liferea/cache
    ignore = Path .liferea/mozilla/liferea/Cache
    ignore = Path .sylpheed-*/*.bak
    ignore = Path .sylpheed-*/folderlist.xml*
    ignore = Path .liferea/new_subscription
    ignore = Path .mozilla/firefox/pluginreg.dat
    ignore = Path .mozilla/firefox/*/lock
    ignore = Path .mozilla/firefox/*/XUL.mfasl
    ignore = Path .mozilla/firefox/*/xpti.dat
    ignore = Path .mozilla/firefox/*/cookies.txt
    ignore = Path .xbindkeysrc
    ignore = Path .unison/ar*
    ignore = Path .gaim/icons
    ignore = Path .gaim/blist.xml
    ignore = Path .asoundrc
    ignore = Path .maillog
    ignore = Path .openoffice2/.lock

As you can see, I have two different profiles, one for when I run from
my laptop, and one for when I run from my desktop. I posted my files
here as example, they are nowhere essential for your configuration.

I made bash aliases for quick usage. One example is:

    alias unisync="unison-gtk2 electra -contactquietly -logfile /dev/null"

Meaning I startup unisync using profile 'electra', for when I am on my
laptop.

I also have a line in ~/Desktop/autostart to automate the process for me
when I am home and want to sync with my laptop:

    xterm -e 'ping -q -W 2 -c 2 pyros &&
    unison-gtk2 electra -contactquietly -logfile /dev/null &&
    gxmessage -buttons no:0,yes:1  Syncing done. Shutdown pyros? ||
    ssh pyros sudo halt' &

Caveats

- You can also use this tool with NFS shares, but I found that that is
slower, because using the ssh solution it asks the other side to check
for updates, and thus not requiring network traffic for that part of the
syncing process.

- In the case you are using a ssh port different from the default (22),
for example 1022, use this line in your prf file: sshargs = -p 1022

- If you are using symbolic links and want to synchronise your files on
a vfat system (usb key for example), unison will not accept them and
generate errors. You cannot just tell unison you do not want symbolic
links, you have to name them all. To find them on your system, you can
run "find ~/folder -type l"

> rsync

rsync

> rdiff-backup

I used to use this tool with the following backup script:

    #!/bin/sh

    mount /bak
    #mount /boot
    mount /mnt/win

    rdiff-backup \
       --exclude-regexp 'cache$' \
       --exclude-regexp '(?i)/te?mp$' \
       --exclude /mnt \
       --exclude /vol \
       --exclude /bak \
       --exclude /usr/media \
       --exclude /usr/media/misc \
       --exclude /usr/lib \
       --exclude /tmp \
       --exclude /var/dl \
       --exclude /var/spool \
       --exclude /var/cache \
       --exclude /proc \
       --exclude /dev \
       --exclude /sys \
    / /bak/sys

    echo "----------------------------------------"
    echo " * Listing increments of backup"
    echo "----------------------------------------"
    rdiff-backup --list-increments /bak/sys

    echo ""
    echo "----------------------------------------"
    echo " * Removing backups older than 5 Weeks"
    echo "----------------------------------------"
    rdiff-backup --force --remove-older-than 5W /bak/sys

    ##Force is necessary because:
    #Fatal Error: Found 2 relevant increments, dated:
    #Sat Apr 10 12:39:24 2004
    #Sat Apr 17 04:15:01 2004
    #If you want to delete multiple increments in this way, use the --force.

    echo ""
    echo "----------------------------------------"
    echo " * Disk usage after backup"
    echo "----------------------------------------"
    df -h

    umount /bak
    #umount /boot
    umount /mnt/win

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sync_laptop_desktop&oldid=302663"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
