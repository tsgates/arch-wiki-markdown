Monitorix
=========

Related articles

-   Anything-sync-daemon
-   lm_sensors
-   hddtemp

Monitorix is an open source, lightweight system monitoring tool designed
to monitor as many services and system resources as possible. It has
been created to be used under production UNIX/Linux servers, but due to
its simplicity and small size many use it on embedded devices as well.

Contents
--------

-   1 Installation of Monitorix
-   2 Configuration of Monitorix
-   3 Start Monitorix
-   4 Viewing Monitorix Data
-   5 Configure an External Webserver
    -   5.1 Lighttpd
    -   5.2 Apache
-   6 Using tmpfs to Store RRD Databases

Installation of Monitorix
-------------------------

A package for monitorix can be found in the AUR.

Note: Depending on which font packages are installed, it might been
necessary to install the terminus-font package. For now, proceed without
it, once monitorix is configured and running, users will know very
quickly if they are missing the correct font as the graphs will not
contain any text at which point, go ahead and install the terminus-font
package via pacman.

Configuration of Monitorix
--------------------------

Edit /etc/monitorix.conf to match graphing options and system-specific
variables. For a complete list of options and features, see the
[official website] or the included man page for monitor.conf.

Most if not all of the user settings are self explanatory based on the
commented text within the conf file itself.

Start Monitorix
---------------

Start Monitorix with the included service file like any other systemd
service:

    # systemctl start monitorix

Viewing Monitorix Data
----------------------

With the release of version 3.0.0, Monitorix now comes with a light,
built in webserver thanks to the dependency on perl-http-server-simple.
This is a configuration option in /etc/monitorix.conf which users may
elect to either use or not.

Note:This the perl-http-server is defaulted to disabled in
/etc/monitorix.conf.

To view system stats, using the perl-http-server, simply point a browser
to [http://localhost:8080/monitorix] to see the data.

Note:It will take several minutes before data are displayed graphically
so be patient.

Configure an External Webserver
-------------------------------

> Lighttpd

Lighttpd is another option.

By default, cgi support is not enabled in lighttpd. To enable it and to
assign perl to process .cgi files, add the following two lines to
/etc/lighttpd/lighttpd.conf:

    server.modules		= ( "mod_cgi" )
    cgi.assign		= ( ".cgi" => "/usr/bin/perl" )

> Apache

Apache is yet another option.

Using tmpfs to Store RRD Databases
----------------------------------

Anything-sync-daemon is a package which provides a pseudo-daemon that
makes use of tmpfs to store RRD Databases for Monitorix. Doing so will
greatly reduce hdd reads/writes.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Monitorix&oldid=293675"

Category:

-   Status monitoring and notification

-   This page was last modified on 20 January 2014, at 06:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
