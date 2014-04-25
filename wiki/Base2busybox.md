Base2busybox
============

  
 The base2busybox project aims to offer drop-in replacements for various
central parts of the Arch linux base system.

IMPORTANT: Do not expect 100% drop-in replacement and compatibility.
Certain utilities may not exist and for those that do, there may be
missing options. One purpose of this Wiki is to document missing
features and the problems they cause (in order to device work-arounds).
Make sure that the replacement(s) that you install fill your needs
before proceeding.

Busybox commands are simply symlinks to the busybox binary and are thus
extremely light weight. For a low footprint system, this could be quite
valuable.

  

* * * * *

Contents
--------

-   1 gnu2busybox-coreutils
-   2 base2busybox-util-linux
-   3 gnu2busybox-findutils
-   4 gnu2busybox-diffutils
-   5 FUTURE PLANS

gnu2busybox-coreutils
---------------------

Package busybox-coreutils offers a nearly pain-free drop-in replacement
of the GNU coreutils. Some commands lack options present in the
corresponding coreutils binaries.

Gain from replacing coreutils with busybox: GNU coreutils: 13.1 MB
installed, symlinks to busybox: approximately 0.

Missing utilities:

/bin

        dircolors

/usr/bin

        chcon csplit factor fmt join nl nproc paste pinky pr ptx runcon shuf
        stdbuf timeout truncate tsort users

Missing utilities that are mapped to corresponding Busybox functions or
ash script files

/bin

       dir --> ls
       shred --> rm
       vdir --> ls

/usr/bin

       link --> ln
       unlink --> rm
       sha224sum --> script: perl-digest-sha
       sha256sum --> script: perl-digest-sha
       sha384sum --> script: perl-digest-sha
       sha512sum --> script: perl-digest-sha

Missing features that cause problems:

         readlink: missing option [-e, -m, -q or -s] causes problems for Yaourt
        

* * * * *

base2busybox-util-linux
-----------------------

Package busybox-util-linux offers an alternative to util-linux.

Gain from replacing util-linux with busybox: util-linux: 7.5 MB
installed, symlinks to busybox: approximately 0.

Missing utilities:

/bin

        arch findmnt lsblk

/sbin

       agetty blkid cfdisk ctrlaltdel findfs fsck.cramfs fsfreeze fstrim mkfs
       mkfs.bfs mkfs.cramfs raw sfdisk swaplabel wipefs

/usr/bin

      chkdupexe col colcrt colrm column cytune ddate fallocate i386 ionice ipcmk
      isosize line look lscpu mcookie namei pg rename scriptreplay setterm tailf
      taskset ul unshare uuidgen whereis write x86_64

/usr/sbin

        addpart delpart ldattach partx tunelp uuidd

Missing features that cause problems:

gnu2busybox-findutils
---------------------

Package busybox-findutils offers functionality corresponding to the
binaries found in GNU findutils.

Gain from replacing findutils with busybox: GNU findutils: 1.7 MB
installed, symlinks to busybox: approximately 0.

Missing utilities:

/usr/bin

        oldfind

Missing features that cause problems:

* * * * *

gnu2busybox-diffutils
---------------------

Package busybox-diffutils offers functionality corresponding to the
binaries found in GNU diffutils.

Gain from replacing diffutils with busybox: GNU diffutils: 1.4 MB
installed, symlinks to busybox: approximately 0.

Missing utilities:

/usr/bin

        diff3 sdiff

Missing features that cause problems:

FUTURE PLANS
------------

-   Busybox-init: a very simple (only 1 runlevel) init system, ash init
    scripts
-   Meta-package and/or group to easily convert an Arch base system to a
    busybox base system.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Base2busybox&oldid=258536"

Category:

-   System administration

-   This page was last modified on 24 May 2013, at 07:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
