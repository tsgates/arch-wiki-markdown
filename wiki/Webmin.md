Webmin
======

  Summary
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Webmin is a web-based interface for system administration for Unix. Using any modern web browser, you can setup user accounts, Apache, DNS, file sharing and much more. Webmin removes the need to manually edit Unix configuration files like /etc/passwd, and lets you manage a system from the console or remotely.

Webmin runs as a service. Using webmin, you can administer other
services and server configuration using a web browser, either from the
server or remotely.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Starting                                                           |
| -   4 Using                                                              |
| -   5 Errors                                                             |
+--------------------------------------------------------------------------+

Installation
------------

You can install webmin from the Official Repositories. Webmin requires
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

Start webmin using systemd:

    # systemctl enable webmin.service
    # systemctl start webmin.service

Using
-----

In a web browser, enter the https address of the server with the port
number 10000 to access Webmin - for example:

https://192.168.1.1:10000 -or- https://myserver.example.net:10000

You will need to enter the root password of the server running Webmin to
use the Webmin interface and administer the server.

Errors
------

If you get a an error similar to
Can't locate timelocal.pl in @INC (@INC contains: /opt/webmin /usr/lib/perl5/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/core_perl /usr/share/perl5/core_perl . /opt/webmin/ ..) at /opt/webmin/useradmin/edit_user.cgi line 6.,
for example, when adding a new system user through Webmin, you need to
install perl-perl4-corelibs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Webmin&oldid=252692"

Category:

-   Web Server
