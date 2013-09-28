Floppy Disks
============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  Summary
  ---------------------------------------------------------------------
  This article discusses methods of using floppy disks on Arch Linux.

Altough rarely used nowadays, one still might need/want to use a floppy
disk (for example, I practice guitar to backing tracks played from my
Yamaha keyboard, which has only a floppy disk drive interface). Common
tasks with floppies are described bellow, with available tools to
accomplish them.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Kernel module                                                |
|     -   1.2 Packages                                                     |
|                                                                          |
| -   2 Common tasks                                                       |
|     -   2.1 Format                                                       |
|     -   2.2 Mount                                                        |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 More Resources                                                     |
| -   5 Todo                                                               |
+--------------------------------------------------------------------------+

Installation
------------

> Kernel module

Most of the floppy drives should be supported by stock kernel (mine
always were). External USB drives might be an exception - I haven't
tested that yet. Module floppy is used as a driver for floppy drives.

As you can see, it comes with the stock Arch kernel.

Module floppy is not loaded automatically by default for me. I load it
manually each time I use floppy disk"

    $ modprobe floppy

> Packages

There are two packages in the Arch package repository I know of -
dosfstools and mtools. Respective commands belong to these packages
(grepped output of pacman -Ql dosfstools mtools):

    dosfstools /sbin/dosfsck
    dosfstools /sbin/dosfslabel
    dosfstools /sbin/fsck.msdos
    dosfstools /sbin/fsck.vfat
    dosfstools /sbin/mkdosfs
    dosfstools /sbin/mkfs.msdos
    dosfstools /sbin/mkfs.vfat
    mtools /usr/bin/amuFormat.sh
    mtools /usr/bin/floppyd
    mtools /usr/bin/floppyd_installtest
    mtools /usr/bin/lz
    mtools /usr/bin/mattrib
    mtools /usr/bin/mbadblocks
    mtools /usr/bin/mcat
    mtools /usr/bin/mcd
    mtools /usr/bin/mcheck
    mtools /usr/bin/mclasserase
    mtools /usr/bin/mcomp
    mtools /usr/bin/mcopy
    mtools /usr/bin/mdel
    mtools /usr/bin/mdeltree
    mtools /usr/bin/mdir
    mtools /usr/bin/mdu
    mtools /usr/bin/mformat
    mtools /usr/bin/minfo
    mtools /usr/bin/mkmanifest
    mtools /usr/bin/mlabel
    mtools /usr/bin/mmd
    mtools /usr/bin/mmount
    mtools /usr/bin/mmove
    mtools /usr/bin/mpartition
    mtools /usr/bin/mrd
    mtools /usr/bin/mren
    mtools /usr/bin/mshowfat
    mtools /usr/bin/mtools
    mtools /usr/bin/mtoolstest
    mtools /usr/bin/mtype
    mtools /usr/bin/mxtar
    mtools /usr/bin/mzip
    mtools /usr/bin/tgz
    mtools /usr/bin/uz

Common tasks
------------

Here are the commands needed to perform the most common tasks. In all
examples, I suppose /dev/fd0 to be the linux device for the floppy
drive. By default, all these tasks need to be performed as root (unless
you use Sudo or something similar).

> Format

    $ mkfs.msdos /dev/fd0

> Mount

    $ mount -t vfat /dev/fd0 /media/floppy

Troubleshooting
---------------

Things like this can happen:

    $ mkfs.msdos /dev/fd0 
    mkfs.msdos 3.0.5 (27 Jul 2009)
    mkfs.msdos: unable to get diskette geometry for '/dev/fd0'

Which means: "Get a new floppy." Sorry (happened to my only disk
available when writing this..).

More Resources
--------------

-   http://www.daniel-baumann.ch/software/dosfstools/ - DOS filesystem
    utilities (not so verbosely documented IMHO)
-   http://www.gnu.org/software/mtools/ - a collection of utilities to
    access MS-DOS disks from Unix without mounting them

Todo
----

-   floppy(8)
-   fdformat(8)
-   recovering a "dead" floppy

Retrieved from
"https://wiki.archlinux.org/index.php?title=Floppy_Disks&oldid=239108"

Categories:

-   Storage
-   File systems
