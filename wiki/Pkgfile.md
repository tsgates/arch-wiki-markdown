pkgfile
=======

pkgfile is a tool that tells you which package owns a specified file or
which files a given package provides.

You can install pkgfile from the official repositories, or pkgfile-git
from the AUR.

Then update the file database:

    # pkgfile --update

Example:

Example to search for a package that contains a file named "makepkg":

    $ pkgfile makepkg

    core/pacman

So your searched file is in the pacman package from the [core]
repository.

Another example to list all files provided by the archlinux-keyring
package from the [core] repository:

    $ pkgfile --list core/archlinux-keyring

    core/archlinux-keyring usr/
    core/archlinux-keyring usr/share/
    core/archlinux-keyring usr/share/pacman/
    core/archlinux-keyring usr/share/pacman/keyrings/
    core/archlinux-keyring usr/share/pacman/keyrings/archlinux-revoked
    core/archlinux-keyring usr/share/pacman/keyrings/archlinux-trusted
    core/archlinux-keyring usr/share/pacman/keyrings/archlinux.gpg

> "Command not found" hook

pkgfile includes a "command not found" hook that will automatically
search the official repositories, if you enter an unrecognized command.
Then it will display something like this:

    $ abiword

    abiword may be found in the following packages:
      extra/abiword 2.8.6-7	usr/bin/abiword

To enable it in all children shells, you need to source the hook from
one of your shell initialization files.

-   Example for Bash:

    ~/.bashrc

    source /usr/share/doc/pkgfile/command-not-found.bash

-   Example for Zsh:

    ~/.zshrc

    source /usr/share/doc/pkgfile/command-not-found.zsh

An alternative "command not found" hook is also provided by the AUR
package command-not-found, which will generate an output like the
following:

    $ abiword

    The command 'abiword' is been provided by the following packages:
    abiword (2.8.6-7) from extra
    	[ abiword ]
    abiword (2.8.6-7) from staging
    	[ abiword ]
    abiword (2.8.6-7) from testing
    	[ abiword ]

for it to work, add the following to a zshrc:

    [ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

Written in C++, the command-not-found package is also much faster than
pkgfile's Bash scripts.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pkgfile&oldid=303345"

Categories:

-   Package development
-   Package management

-   This page was last modified on 6 March 2014, at 14:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
