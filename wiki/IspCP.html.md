IspCP
=====

ispCP is an open source project founded to build a Multi Server Control
and Administration Panel aimed to be usefull to Internel Service
Provider.The project is a fork of dying Virtual Hosting Control Panel
(VHCS) project,but it's future goal is a complete rewritten of the
original VHCS.

For more detail information,please visit ispCP Project Info.

Contents
--------

-   1 ispCP Omega Release
    -   1.1 Installation
    -   1.2 Upgradation
    -   1.3 Configuration
    -   1.4 Uninstallation
    -   1.5 Troubleshooting
-   2 ispCP Release
-   3 More resources

ispCP Omega Release
-------------------

ispCP-Omega is the current release of the ispCP project which is a
bridge between the VHCS project and the final rewritten ispCP project
the comunity is currently working on.

> Installation

ispCP-Omega is now in AUR.Download the PKGBUILD and then makepkg to
install or use any of the aur wrapper to makepkg and install
automatically.

ispCP setup script need MySQL server running.

     /etc/rc.d/mysqld start

If you just installed MySQL as dependency, see
https://wiki.archlinux.org/index.php/MySQL to see how set it up, or you
can use following command to interactive configure it.

     mysql_secure_installation

Then,

     cd /srv/http/ispcp/engine/setup/

Run,

     ./ispcp-setup

After answering several questions about your server, the ispCP Omega is
completely installed.

> Upgradation

> Configuration

Due to the Arch Linux has not been support officially,there are some
addition work to do after setup processtion complete.

1. Change vmail home directory

     usermod -d /var/mail/virtual vmail

2. Edit `/etc/httpd/conf/httpd.conf`

Add the following lines at the end of the file

     Include conf/extra/httpd-mods/*.conf
     Include conf/extra/httpd-vhosts/*.conf
     Include conf/extra/httpd-vhosts-ispcp/*.conf

Make sure the following lines commented or deleted. Apache now is in cgi
mode, package "php-apache" could be safely deleted.

     LoadModule php5_module modules/libphp5.so
     Include conf/extra/php5_module.conf

3. Edit `/etc/conf.d/apache`

Uncomment the following line

     HTTPD=/usr/sbin/httpd.worker

4. Edit `/etc/services`

Append the following lines to the end of the file.

     smtps            465/tcp 
     smtps            465/udp

5. Edit `/etc/conf.d/postgrey`

Change port from 10030 to 10023

6. Edit `/etc/logrotate.d/httpd`

Comment all lines.

7. Edit `/etc/logrotate.d/proftpd`

Comment all lines.

8. Edit `/etc/rc.conf`

Add "named mysqld proftpd saslauthd authdaemond postfix pop3d !pop3d-ssl
imapd !imapd-ssl postgrey policyd-weight ispcp_daemon ispcp_network
httpd" to DAEMONS array if you want a autostart.

9. PHP extension loading

Place any PHP extension configuration file in /etc/php/conf.d as
*.ini,they will be autoloaded.

The server has alwready been auto configured while setup
pressodure,there is no more configureation work need to be done.

> Uninstallation

> Troubleshooting

       Frequently asked questions regarding the software.

ispCP Release
-------------

The full-rewritten ispCP has not yet been released,let's be patient and
wait.

More resources
--------------

ispCP Project

Retrieved from
"https://wiki.archlinux.org/index.php?title=IspCP&oldid=268472"

Category:

-   Web Server

-   This page was last modified on 28 July 2013, at 00:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
