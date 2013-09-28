Reflector
=========

Reflector is a script which can retrieve the latest mirror list from the
MirrorStatus page, filter the most up-to-date mirrors, sort them by
speed and overwrite the file /etc/pacman.d/mirrorlist.

Installation
------------

Install the reflector package which is available in the official
repositories.

Usage
-----

Warning:Please back up your /etc/pacman.d/mirrorlist file first

First back up your /etc/pacman.d/mirrorlist

    # cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

The following command will filter the first five mirrors, sort them by
speed and overwrite the file /etc/pacman.d/mirrorlist:

    # reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist

The following command will verbosely rate the 200 most recently
synchronized HTTP servers, sort them by download rate, and overwrite the
file /etc/pacman.d/mirrorlist:

    # reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

To see all of the available commands, run the following command:

    # reflector --help

Warning:Make sure the mirror list does not contain strange entries
before syncing or updating with pacman.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Reflector&oldid=247675"

Category:

-   Package management
