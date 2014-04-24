Pacserve
========

Pacserve allows to easily share pacman packages between computers. This
is very useful, if you have a slow internet connection, but multiple
machines running Arch Linux.

Contents
--------

-   1 Installation
    -   1.1 From Xyne's repository
-   2 Standalone usage
-   3 Configure Pacman to use Pacserve
-   4 Troubleshooting
    -   4.1 Problems if using external downloaders in pacman.conf

Installation
------------

You can either install pacserve manually from the AUR, or with the
following method.

From Xyne's repository

Xyne is the author of pacserve, you can directly use his repository by
adding the following to your pacman.conf.

    /etc/pacman.conf

    ...
    [xyne-x86_64]
    # A repo for Xyne's own projects: http://xyne.archlinux.ca/projects/
    SigLevel = Required
    Server   = http://xyne.archlinux.ca/repos/xyne

Make sure that you have replaced x86_64 with i686 or any depending on
your architecture. Then install the package:

    # pacman -Sy pacserve

Finally enable and start the daemon:

    # systemctl enable pacserve.service
    # systemctl start pacserve.service

In case you use iptables, you will probably want to start the
pacserve-ports service, too.

Standalone usage
----------------

Instead of pacman, use the pacsrv wrapper to perform an update, install
packages and so on. It will automatically download all packages from the
LAN, if someone hosts them with pacserve there. Otherwise it will just
download them from the internet mirrors, as usually. For example:

    pacsrv -Syu
    pacsrv -S openssh

Configure Pacman to use Pacserve
--------------------------------

If you are always running the pacserve daemon and want pacman to use it
without the wrapper, add the following line below each repository in
/etc/pacman.conf:

     Include = /etc/pacman.d/pacserve

Here's an example for the Xyne repository:

    /etc/pacman.conf

    ...
    [xyne-x86_64]
    SigLevel = Required
    Include  = /etc/pacman.d/pacserve
    Server   = http://xyne.archlinux.ca/repos/xyne
    ...

Alternatively (for official mirrors only), you may insert the
Include...-line at the top of the Pacman mirrorlist file or let
pacman.conf-insert_pacserve generate a pacman.conf file for you.

Troubleshooting
---------------

> Problems if using external downloaders in pacman.conf

If you're using an external downloader such as wget, pacsrv may return
errors when downloading. To work around these errors, simply quote the
url and output formatting strings (%u resp. %o) using single quotes:

    XferCommand = /usr/bin/wget --timeout=6 --passive-ftp -c -O '%o' '%u'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacserve&oldid=295002"

Categories:

-   Package management
-   Networking

-   This page was last modified on 30 January 2014, at 10:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
