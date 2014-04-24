Reflector
=========

Related articles

-   Pacman

Reflector is a script which can retrieve the latest mirror list from the
MirrorStatus page, filter the most up-to-date mirrors, sort them by
speed and overwrite the file /etc/pacman.d/mirrorlist.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 Examples
        -   2.1.1 Example 1
        -   2.1.2 Example 2
        -   2.1.3 Example 3

Installation
------------

Install reflector from the official repositories.

Usage
-----

> Warning:

-   Back up the /etc/pacman.d/mirrorlist file first:
    -   # cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

-   Make sure /etc/pacman.d/mirrorlist does not contain entries that you
    consider untrustworthy before syncing or updating with Pacman.

To see all of the available commands, run the following command:

    # reflector --help

> Examples

Example 1

The following command will filter the first five mirrors, sort them by
speed and overwrite the file /etc/pacman.d/mirrorlist:

    # reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist

Example 2

The following command will verbosely rate the 200 most recently
synchronized HTTP servers, sort them by download rate, and overwrite the
file /etc/pacman.d/mirrorlist:

    # reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

Example 3

This command will verbosely rate the 200 most recently synchronized HTTP
servers located in the US, sort them by download rate speed, and
overwrite the file /etc/pacman.d/mirrorlist:

    # reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

Retrieved from
"https://wiki.archlinux.org/index.php?title=Reflector&oldid=293065"

Category:

-   Package management

-   This page was last modified on 16 January 2014, at 03:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
