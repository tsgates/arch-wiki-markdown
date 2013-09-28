Hellanzb
========

Hellanzb is a console based usenet binary downloader written in python.
It can be run in daemon mode and several GUI or PHP frontends are
available.

Note:hellanzb is no longer under active development, although the last
release (0.13) is considered stable by the developers and testing team.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Main Features                                                      |
| -   2 Installing                                                         |
| -   3 Configuration                                                      |
|     -   3.1 hellanzb.conf                                                |
|     -   3.2 /etc/conf.d/hellanzb                                         |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Main Features
-------------

-   Automatically downloads nzb files placed in a user-specified watch
    directory.
-   Par1/2 verification and repair of damaged files.
-   Unrars completed downloads.
-   Deletes unneeded files after a download has been completed.

Installing
----------

Hellanzb is available in the AUR package hellanzb.

Configuration
-------------

Hellanzb can be run in two modes:

-   From CLI
-   As daemon

hellanzb.conf

A configuration file named hellanzb.conf must be present in the users
.config directory for hellanzb to function properly. A sample
configuration file is available.

    mkdir -p ~/.config
    cp /etc/hellanzb.conf.sample ~/.config/hellanzb.conf

/etc/conf.d/hellanzb

When run in daemon mode, the /etc/conf.d/hellanzb file needs to be
modified to configure the user that will be running hellanzb

    HELLANZB_USER="username"
    HELLANZB_CONF="/home/${HELLANZB_USER}/.config/hellanzb.conf"

See also
--------

-   Screen Tips

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hellanzb&oldid=239180"

Categories:

-   Internet Applications
-   Networking
