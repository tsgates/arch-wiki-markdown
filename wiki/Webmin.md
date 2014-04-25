Webmin
======

From the project home page:

Webmin is a web-based interface for system administration for Unix.
Using any modern web browser, you can setup user accounts, Apache, DNS,
file sharing and much more. Webmin removes the need to manually edit
Unix configuration files like /etc/passwd, and lets you manage a system
from the console or remotely. See the standard modules page for a list
of all the functions built into Webmin, or check out the screenshots.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Starting
-   4 Usage
-   5 Troubleshooting

Installation
------------

You can install webmin from the official repositories. Webmin requires
perl-net-ssleay to enable access via https.

Configuration
-------------

To allow access to Webmin from a remote computer, edit
/etc/webmin/miniserv.conf to include your network address. (Note -
127.0.0.1 is there by default)

    allow=127.0.0.1 192.168.1.0

The above example allows all computers on the 192.168.1.0 network to
access Webmin.

Starting
--------

Start webmin service using systemd. Enable it if you wish to load webmin
at boot.

Usage
-----

In a web browser, enter the https address of the server with the port
number 10000 to access Webmin - for example:

https://192.168.1.1:10000 -or- https://myserver.example.net:10000

You will need to enter the root password of the server running Webmin to
use the Webmin interface and administer the server.

Troubleshooting
---------------

If you get a an error similar to

    Can't locate timelocal.pl in @INC (@INC contains: /opt/webmin /usr/lib/perl5/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/core_perl /usr/share/perl5/core_perl . /opt/webmin/ ..) at /opt/webmin/useradmin/edit_user.cgi line 6.

for example, when adding a new system user through Webmin, you need to
install perl-perl4-corelibs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Webmin&oldid=265273"

Category:

-   Web Server

-   This page was last modified on 6 July 2013, at 10:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
