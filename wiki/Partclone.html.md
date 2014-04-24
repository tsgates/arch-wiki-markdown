Partclone
=========

Partclone, like the well-known Partimage, can be used to back up and
restore a partition while considering only used blocks.

Contents
--------

-   1 Installation
-   2 Using Partclone with an ext4-formatted partition
    -   2.1 Without compression
    -   2.2 With compression

Installation
------------

Partclone is available in the community repository.

    # pacman -S partclone

Using Partclone with an ext4-formatted partition
------------------------------------------------

> Without compression

To backup without compression:

    $ partclone.ext4 -c -s /dev/sda1 -o ~/image_sda1.pcl

To restore it:

    $ partclone.ext4 -r -s ~/image_sda1.pcl -o /dev/sda1

> With compression

To backup with compression:

    $ partclone.ext4 -c -s /dev/sda1 | gzip -c > ~/image_sda1.pcl.gz

Note:For maximum compression use "gzip -c9"

To restore it:

    zcat ~/image_sda1.pcl.gz | partclone.ext4 -r -o /dev/sda1

Retrieved from
"https://wiki.archlinux.org/index.php?title=Partclone&oldid=223278"

Category:

-   File systems

-   This page was last modified on 15 September 2012, at 23:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
