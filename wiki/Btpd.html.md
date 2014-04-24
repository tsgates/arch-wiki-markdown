Btpd
====

btpd is a BitTorrent client daemon.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Interaction
-   4 External Links

Installation
------------

You can install btpd from the AUR.

Configuration
-------------

Btpd does not have a configuration file. Options can be applied using
flags (see man btpd).

Interaction
-----------

To interact with btpd use the command-line interface btcli.

Note:Don't forget to configure a working directory with -d if you do not
want to use the default.

Add foo.torrent, with content dir /home/user/foo.torrent.d/, and start
it:

    $ btcli add -d /home/user/foo.torrent.d foo.torrent

Same as above without starting it:

    $ btcli add -N -d /home/user/foo.torrent.d foo.torrent

Display a list btpd’s torrents and their number, size, status, etc:

    $ btcli list

Same as above, but only for torrent 12 and my.little.torrent:

    $ btcli list 12 my.little.torrent

Same as above but only for active torrents:

    $ btcli list -a

Use a custom list format:

    $btcli list -f "btcli list -f "%n\t%#\t%p%s\t%r\n"

Start bar.torrent and torrent number 7:

    $ btcli start bar.torrent 7

Stop torrent number 7:

    $ btcli stop 7

Stop all active torrents:

    $ btcli stop -a

Remove bar.torrent and it’s associated information from btpd:

    $ btcli del bar.torrent

Display a summary of up/download stats for the active torrents:

    $ btcli stat

Display the summary once every five seconds:

    $ btcli stat -w 5

Same as above, but also display individual stats for each active
torrent:

    $ btcli stat -w 5 -i

Shut down btpd:

    $ btcli kill

External Links
--------------

-   GitHub Project Page
-   GitHub Wiki
-   Btpd Webui in AUR
-   GTK+ Btpd frontend in AUR

Retrieved from
"https://wiki.archlinux.org/index.php?title=Btpd&oldid=302629"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
