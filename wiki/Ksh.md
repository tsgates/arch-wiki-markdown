Ksh
===

Korn Shell (ksh) is a standard/restricted command and programming
language developed by AT&T.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Making Ksh your default login shell                                |
| -   3 Uninstallation                                                     |
| -   4 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

The version from AT&T can be found on AUR.

The MirBSD™ Korn Shell is another free implementation of the Korn Shell.
It can be found in the community repo. Install with pacman:

    # pacman -S mksh

The Public Domain Korn Shell is in the AUR.

Making Ksh your default login shell
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

Change the default shell for the current user to bash:

    $ chsh -s /bin/bash

Alternative as root, using usermod

Change the default shell using usermod:

    # usermod -s /bin/bash username

Now you can safely remove the Ksh package:

    # pacman -R pdksh

Warning: Failure to follow the above will result in all kinds of
problems.

If you did not follow the above, you can still change the default shell
back to Bash by editing /etc/passwd as root.

For example:

from:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/ksh

to:

    username:x:1000:1000:Full Name,,,:/home/username:/bin/bash

External Resources
------------------

pdksh official page

Korn Shell at Wikipedia

pdksh man page at die.net

Home Page For The KornShell Command And Programming Language

pdksh man page at OpenBSD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ksh&oldid=251528"

Category:

-   Command shells
