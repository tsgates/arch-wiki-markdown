Ksh
===

Korn Shell (ksh) is a standard/restricted command and programming
language developed by AT&T.

Contents
--------

-   1 Installation
-   2 Making ksh your default login shell
-   3 Uninstallation
-   4 See also

Installation
------------

First, install an implementation:

-   MirBSD™ Korn Shell — Enhanced version of the public domain ksh.

https://www.mirbsd.org/mksh.htm || mksh

-   AT&T Korn shell — Official AT&T version.

http://www.kornshell.com/ || ksh

-   OpenBSDs Korn Shell — Porting of the OpenBSD version of ksh to
    GNU/Linux.

http://www.connochaetos.org/oksh/ || oksh

-   Public Domain Korn Shell — Clone of the AT&T Korn shell. At the
    moment, it has most of the ksh88 features, not much of the ksh93
    features, and a number of its own features.

http://www.cs.mun.ca/~michael/pdksh/ || pdksh

More implementations are provided by:

-   obase — OpenBSD userland ported to Linux, statically linked.

https://github.com/chneukirchen/obase || obase-git

-   obase musl — OpenBSD userland ported to Linux, statically linked to
    musl libc.

https://github.com/chneukirchen/obase || obase-musl-git

Making ksh your default login shell
-----------------------------------

systemd does not implicitly make use of a shell (previously, Arch Linux
init scripts were using Bash). After the boot process is complete, the
default login shell is user-specified. The chsh command can be used to
change a user's default login shell without root access if the shell is
listed in /etc/shells. (If Ksh was installed using pacman, it should
already have an entry in /etc/shells).

Grab the full path for Ksh using /usr/bin/which:

    $ which ksh

Which will probably output:

    /bin/ksh

Change the default shell for the current user:

    $ chsh -s /bin/ksh

Alternative as root, using usermod

Change the default shell using usermod:

    # usermod -s /bin/ksh username

Note: The user needs to logout and log back in, to start using Ksh as
their default shell.

After logging back in, verify that Ksh is the default shell with:

    $ echo $SHELL

Uninstallation
--------------

You must first change your default shell back to Bash before removing
the Ksh package.

Change the default shell for the current user to Bash:

    $ chsh -s /bin/bash

Alternative as root, using usermod

Change the default shell using usermod:

    # usermod -s /bin/bash username

Now you can safely remove the Ksh package.

Warning:Failure to follow the above will result in all kinds of
problems.

If you did not follow the above, you can still change the default shell
back to Bash by editing /etc/passwd as root.

For example from:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/ksh

to:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/bash

See also
--------

-   pdksh man page at die.net
-   pdksh man page at OpenBSD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ksh&oldid=274814"

Category:

-   Command shells

-   This page was last modified on 8 September 2013, at 18:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
