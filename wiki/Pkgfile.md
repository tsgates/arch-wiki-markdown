pkgfile
=======

pkgfile is a tool that tells you which package owns a specified file or
which files a given package provides.

You can install pkgfile from the Official Repositories, or pkgfile-git
from the AUR.

Then update the file database, as root:

    # pkgfile --update

Example:

    $ pkgfile makepkg     #Search for a package that contains a file named "makepkg".

    core/pacman           #Your searched file is in the pacman package from the [core] repository.

Another example:

    $ pkgfile --list core/archlinux-keyring     #List all files provided by the archlinux-keyring package from the [core] repository.

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

To enable it in all children shells, you need to source the hook from
one of your shell initialization files.

-   Example for Bash:

    ~/.bashrc

    source /usr/share/doc/pkgfile/command-not-found.bash

-   Example for Zsh:

    ~/.zshrc

    source /usr/share/doc/pkgfile/command-not-found.zsh

See also
--------

-   Bash#The_"command_not_found"_hook - A section comparing pkgfile and
    command-not-found

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pkgfile&oldid=255437"

Categories:

-   Package development
-   Package management
