getty
=====

A getty is the generic name for a program which manages a terminal line
and its connected terminal. Its purpose is to protect the system from
unauthorized access. Generally, each getty process is started by init
and manages a single terminal line. Within the context of a typical Arch
Linux installation, the terminals managed by the getty processes are
implemented as virtual consoles. Six of these virtual consoles are
provided by default and they are usually accessible by pressing
Ctrl+Alt+F1 through Ctrl+Alt+F6.

Contents
--------

-   1 agetty
-   2 fgetty
-   3 Others
-   4 See also

agetty
------

The agetty program is the default getty in Arch Linux and is part of the
util-linux package which is included in the base Arch Linux
installation. It modifies the TTY settings while waiting for a login so
that newlines are not translated to CR–LFs. This tends to cause a
"staircase effect" for messages printed to the console (printed by
programs started by Init for instance).

fgetty
------

The fgetty unofficial package is available in the Arch User Repository
and is derived from mingetty. It does not cause the "staircase effect".
The patched fgetty-pam is currently required for Pluggable
Authentication Module (including SHA-2) support.

Others
------

-   mingetty AUR mingetty
-   qingy official package: qingy
-   fbgetty official package: fbgetty
-   ngetty AUR: ngetty
-   rungetty AUR: rungetty
-   mgetty AUR: mgetty

See also
--------

-   Display manager
-   Disable clearing of boot messages
-   Automatic login to virtual console

Retrieved from
"https://wiki.archlinux.org/index.php?title=Getty&oldid=273646"

Category:

-   Boot process

-   This page was last modified on 1 September 2013, at 10:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
