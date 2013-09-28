Base2heirloom
=============

The base2Heirloom project aims to offer drop-in replacements for various
central parts of the Arch linux base system.

Warning:Do not expect 100% drop-in replacement and compatibility.
Certain utilities may not exist and for those that do, there may be
missing options. One purpose of this Wiki is to document missing
features and the problems they cause (in order to device work-arounds).
Make sure that the replacement(s) that you install fill your needs
before proceeding.

Why change GNU (and other base components) to Heirloom? In contrast to
the base2busybox project, the size gain is not as much of a compelling
reason. Other reasons could be:

-   an interest and devotion to traditional UNIX tools (like fixing
    oldtimers)
-   anti-GNU sentiments
-   out of curiosity

Profiles
--------

The heirloom project mantains several different traditional UNIX
variants. To read more about the different profiles, follow this link.
Current base2Heirloom packages utilizes Busybox to compensate for
missing utilities. Any alternative sources to fill up with missing
utilities are however of interest, especially those that fit with the
spirit of the Heirloom project.

profile SysV

This is the most traditional variant. Binaries in base2heirloom packages
with this profile are taken from /usr/heirloom in the following order:

      bin > bin/posix > bin/ucb

profile posix2001

Binaries in base2heirloom packages with this profile are taken from
/usr/heirloom in the following order:

      bin/posix2001 > bin/posix > bin > bin/ucb

profile ucb

In contrast to the other profiles of Heirloom, ucb only represent some
added-value from the traditional BSD on another profile. The ucb profile
represents the most modern configuration.

Binaries in base2heirloom packages with this profile are taken from
/usr/heirloom in the following order:

      bin/ucb > bin/posix2001 > bin/s42 > bin/posix > bin

gnu2heirloom-coreutils
----------------------

There are 3 implementations of this replacement: SysV, Posix2001 and
UCB.

Busybox

Currently, the gnu2heirloom-coreutils packages need support to offer a
drop-in replacement of GNU coreutils. This is at the moment provided by
busybox for the following utilities:

       readlink [ base64 hostid md5sum mktemp seq sha1sum stat tac chroot

Missing utilities

Some utilities are not offered by neither Heirloom nor Busybox.

/bin

       dir dircolors shred vdir 

/usr/bin

       chcon link nproc pinky ptx runcon sha224sum sha256sum sha384sum sha512sum shuf stdbuf timeout truncate unlink

Retrieved from
"https://wiki.archlinux.org/index.php?title=Base2heirloom&oldid=233692"

Category:

-   Command shells
