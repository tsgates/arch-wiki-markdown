Ramdisk
=======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Mentions         
                           /etc/rc.local and Arch   
                           Linux does not use       
                           initscripts anymore.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

A ramdisk is a portion of RAM utilised as a disk. Many distributions use
/dev/ram for this, however Arch does not have a /dev/ram so we must use
/etc/fstab to create ramdisks. The most important thing to remember
about a ramdisk is that it is stored in RAM and thus volatile. Anything
stored on a ramdisk will be lost if the computer completely seizes up,
or loses power. Therefore, it is necessary to save the contents of your
ramdisk to the harddrive if you want to save them.

Contents
--------

-   1 Why use one?
-   2 How to create a ramdisk
-   3 Example usage
-   4 Useful links

Why use one?
------------

As a ramdisk is stored in RAM, it is much faster than a conventional
filesystem. So, if you need to manipulate files at high speed, a ramdisk
could be the best solution. Popular choices include /tmp, Firefox
profile, although I'm sure you could think of many others.

How to create a ramdisk
-----------------------

To create a ramdisk, you treat it like any other filesystem, using any
arbitrary word for the device file (here "none"):

    mount -t ramfs none /path/to/location

For a more permanent solution, you may first pick and create a location
for it to reside on, and then add it to your /etc/fstab file as follows:

    none     /path/to/location     ramfs  defaults   0     0

If you do not have a lot of spare ram, it is recommended to use 'tmpfs'
instead of 'ramfs', as tmpfs uses Swap when the available RAM starts to
run out, whereas ramfs does not. Of course, dipping into swap loses the
performance benefits of RAM, so it's a little pointless unless you have
a lot of spare RAM.

Example usage
-------------

The files that have been edited are /etc/fstab, /etc/rc.local, and
/etc/rc.local.shutdown to store /tmp, /var/cache/pacman, and
/var/lib/pacman in RAM, and sync them to disk before shutting down.
Portions of the files not relevant to the topic at hand have been
removed to save space

> /etc/fstab:

    none        /tmp         ramfs   defaults              0 0
    none        /mnt/ramdisk ramfs   defaults              0 0

/etc/rc.local:

    chmod 777 /tmp
    touch /etc/ramdisk.sh

    /bin/cat - >> /etc/ramdisk.sh << EOT
    #!/bin/sh

    cd /var/ && /bin/tar cf abs.tar abs/
    cd /var/cache/ && /bin/tar cf pacman.tar pacman/
    cd /var/lib/ && /bin/tar cf pacman.tar pacman/

    /bin/mkdir /mnt/ramdisk/var/
    /bin/mkdir /mnt/ramdisk/var/cache/
    /bin/mkdir /mnt/ramdisk/var/lib/

    /bin/mv /var/abs /mnt/ramdisk/var && /bin/ln -s /mnt/ramdisk/var/abs /var/abs
    /bin/mv /var/cache/pacman /mnt/ramdisk/var/cache &&  /bin/ln -s /mnt/ramdisk/var/lib/pacman /var/lib/pacman
    /bin/mv /var/lib/pacman /mnt/ramdisk/var/lib && /bin/ln -s /mnt/ramdisk/var/cache/pacman /var/cache/pacman

    /bin/ln -s /tmp /mnt/ramdisk/tmp
    /bin/chmod 777 /mnt/ramdisk/tmp
    EOT

    /etc/ramdisk.sh &

/etc/rc.local.shutdown:

    echo "Saving contents of ramdisk to harddrive"
    rm /var/abs
    rm /var/cache/pacman
    rm /var/lib/pacman
    mv /mnt/ramdisk/var/abs /var
    mv /mnt/ramdisk/var/cache/pacman /var/cache
    mv /mnt/ramdisk/var/lib/pacman /var/lib

Useful links
------------

-   How to mount Ramdisk
-   Ramdrive setup
-   Official tmpfs documentation
-   Official ramfs documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ramdisk&oldid=274384"

Category:

-   File systems

-   This page was last modified on 5 September 2013, at 00:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
