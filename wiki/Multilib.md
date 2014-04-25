Multilib
========

Enabling the multilib repository allows the user to run and build 32-bit
applications on 64-bit installations of Arch Linux. multilib creates a
directory containing 32-bit instruction set libraries inside
/usr/lib32/, which 32-bit binary applications may need when executed.

Contents
--------

-   1 Directory structure
-   2 Enabling
-   3 Disabling
-   4 See also

Directory structure
-------------------

A 64-bit installation of Arch Linux with multilib enabled follows a
directory structure similar to Debian. The 32-bit compatible libraries
are located under /usr/lib32/, and the native 64-bit libraries under
/usr/lib/.

Enabling
--------

To use the multilib repository, uncomment the [multilib] section in
/etc/pacman.conf:

    [multilib]
    Include = /etc/pacman.d/mirrorlist

You will then need to update the package list by running pacman with the
-Sy switch.

Disabling
---------

To revert to a pure 64-bit system, uninstalling multilib:

Execute the following command to remove all packages that were installed
from multilib:

    # pacman -R `LANG=C pacman -Sl multilib | grep installed | cut -d ' ' -f 2`

If you have conflicts with gcc-libs reinstall the 64-bit versions and
try the previous command again:

    # pacman -S gcc-libs base-devel

Comment out the [multilib] section in /etc/pacman.conf:

    #[multilib]
    #Include = /etc/pacman.d/mirrorlist

Update your package list by running pacman with the -Syy switch.

See also
--------

-   Arch64 FAQ#Multilib Repository - Multilib Project
-   arch-multilib mailing list

Retrieved from
"https://wiki.archlinux.org/index.php?title=Multilib&oldid=302097"

Categories:

-   Arch64
-   Package management

-   This page was last modified on 25 February 2014, at 19:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
