Base2plan9
==========

The base2plan9 project aims to offer drop-in replacements for various
central parts of the Arch linux base system.

IMPORTANT: Do not expect 100% drop-in replacement and compatibility.
Certain utilities may not exist and for those that do, there may be
missing options. One purpose of this Wiki is to document missing
features and the problems they cause (in order to devise work-arounds).
Make sure that the replacement(s) that you install fill your needs
before proceeding.

Why change GNU (and other base components) to Plan9(port)?

In contrast to the base2busybox project, the size gain is not as much of
a compelling reason. Other reasons could be:

-   an interest and devotion to Plan9 and its post-UNIX ambitions
-   anti-GNU sentiments
-   out of curiosity

* * * * *

Supporting binary sources
-------------------------

Currently, the gnu2plan9 packages need support to offer a drop-in
replacement of GNU coreutils. This is at the moment provided by busybox
and the gnu2ucb Heirloom profile. Ideally, missing functionality should
be patched up with projects more closely aligned to Plan9, like Inferno
and Goblin. The aim is to make the different "base2foo" projects as
independent of eachother as possible since the whole point of the
projects is to increase choice and diversity. For the base2plan9
project, the first priority is to cover missing functionality and second
priority to try to reduce (or ideally remove) the busybox dependency.

* * * * *

gnu2plan9-coreutils
-------------------

Below is a list of the origin of different utilities in this package.

Plan9port

/bin

       cat date dd du echo lc ls mc mkdir rc rm sleep

rc, mc and lc are "extras" added to this package which do not exist in
GNU coreutils

/usr/bin

       basename comm factor fmt join md5sum pr seq
       sha1sum sort split sum tee test wc

Custom scripts

The following missing functionalities are implemented as rc scripts

/bin

       false true

/usr/bin

       sha224sum sha256sum sha384sum sha512sum

the sha*sum scripts point to the perl-digest-sha. Ideally as few
external dependencies possible would be nice. Can we use plan9port
sha1sum for the other sums too? Ideas welcome.

Heirloom

ucb binaries

/bin

       chown df install ln stty

posix2001 binaries

/usr/bin

       csplit expr nl 

s42 binaries

/bin

       cp mv

posix binaries

/bin

       chmod rmdir

/usr/bin

       id nohup od who

SysV binaries

/bin

       cut mkfifo mknod pwd su sync uname 

/usr/bin

       cksum dirname env expand fold head logname
       nice paste patchchk printenv printf tsort
       tty unexpand uniq users whoami yes

Busybox

Busybox is needed for the following utilities:

       readlink [ base64 hostid mktemp stat tac chroot

Missing utilities

Some utilities are not offered by neither Plan9port, custom scripts,
Heirloom nor Busybox.

/bin

       dir dircolors shred vdir 

/usr/bin

       chcon link nproc pinky ptx runcon shuf stdbuf timeout truncate unlink

Retrieved from
"https://wiki.archlinux.org/index.php?title=Base2plan9&oldid=239098"

Category:

-   System administration
