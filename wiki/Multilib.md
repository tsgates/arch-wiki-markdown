Multilib
========

Enabling the [multilib] repository allows the user to run and build
32-bit applications on 64-bit installations of Arch Linux. [multilib]
creates a directory containing 32-bit instruction set libraries inside
/usr/lib32/, which 32-bit binary applications may need when executed.

To use the [multilib] repository, uncomment the following from
/etc/pacman.conf:

    [multilib]
    Include = /etc/pacman.d/mirrorlist

You will then need to update the package list by running pacman with the
-Syy switch.

Directory structure
-------------------

A 64-bit installation of Arch Linux with [multilib] enabled follows a
directory structure similar to Debian. The 32-bit compatible libraries
are located under /usr/lib32/, and the native 64-bit libraries under
/usr/lib/.

See also
--------

-   Arch64 FAQ#Multilib Repository - Multilib Project
-   arch-multilib mailing list

Retrieved from
"https://wiki.archlinux.org/index.php?title=Multilib&oldid=253068"

Categories:

-   Arch64
-   Package management
