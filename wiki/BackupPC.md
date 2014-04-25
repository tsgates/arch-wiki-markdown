BackupPC
========

BackupPC is a high-performance, enterprise-grade system for backing up
Unix, Linux, WinXX, and MacOSX PCs, desktops and laptops to a server's
disk. BackupPC is highly configurable and easy to install and maintain.

Given the ever decreasing cost of disks and raid systems, it is now
practical and cost effective to backup a large number of machines onto a
server's local disk or network storage. For some sites this might be the
complete backup solution. For other sites additional permanent archives
could be created by periodically backing up the server to tape.

Contents
--------

-   1 Installation
-   2 Apache configuration
    -   2.1 Edit Apache configuration
-   3 Alternative lighttpd configuration
-   4 Accessing the admin page
-   5 The webserver user and the suid problem
-   6 See also

Installation
------------

Install backuppc from the official repositories. Install rsync and
perl-file-rsyncp if you want to use rsync as a transport.

Start backuppc systemd daemon and, if you wish to have running at boot
time enable it.

Apache configuration
--------------------

BackupPC has a web interface that allows you to easily control it. You
can access it using Apache and mod_perl but other webservers like
lighttpd works too. Install apache and mod_perl from the official
repositories.

> Edit Apache configuration

Edit the Apache configuration file to load mod_perl, tell Apache to run
as user backuppc and to include /etc/httpd/conf/extra/backuppc.conf:

    /etc/httpd/conf/httpd.conf

     LoadModule perl_module modules/mod_perl.so
     User backuppc
     Group backuppc
     Include conf/extra/backuppc.conf

Edit /etc/backuppc/config.pl. Set administrator name:

    $Conf{CgiAdminUsers} = 'admin'; 

Next, we need to add a users file and set the admin password:

    # htpasswd -c /etc/backuppc/backuppc.users admin

The BackupPC-Webfrontend is initially configured, that you can only
access it from the localhost. If you want to access it from all machines
in your network, you have to edit /etc/httpd/conf/extra/backuppc.conf.
Edit the line:

    allow from 127.0.0.1

to:

    allow from 127.0.0.1 192.168.0

where you have to replace 192.168.0 to your corresponding IP-Adresses
you want to gain access from. Then just start Apache service.

Alternative lighttpd configuration
----------------------------------

    /etc/lighttpd/lighttpd.conf

     server.port             = 81
     server.username         = "backuppc"
     server.groupname        = "backuppc"
     server.document-root    = "/srv/http"
     server.errorlog         = "/var/log/lighttpd/error.log"
     dir-listing.activate    = "enable"
     index-file.names        = ( "index.html", "index.php", "index.cgi" )
     mimetype.assign         = ( ".html" => "text/html", ".txt" => "text/plain", ".jpg" => "image/jpeg", ".png" => "image/png", "" => "application/octet-stream" )
     
     server.modules = ("mod_alias", "mod_cgi", "mod_auth", "mod_access" )
     
     alias.url               = ( "/BackupPC_Admin" => "/usr/share/backuppc/cgi-bin/BackupPC_Admin" )
     alias.url               += ( "/backuppc" => "/usr/share/backuppc/html" )
     
     cgi.assign              += ( ".cgi" => "/usr/bin/perl" )
     cgi.assign              += ( "BackupPC_Admin" => "/usr/bin/perl" )
     
     auth.backend = "plain"
     auth.backend.plain.userfile = "/etc/lighttpd/passwd"
     auth.require = ( "/BackupPC_Admin" => ( "method" => "basic", "realm" => "BackupPC", "require" => "user=admin" ) )

    /etc/lighttpd/passwd

     admin:yourpassword

Accessing the admin page
------------------------

Browse to http://localhost/BackupPC_Admin respectively
http://your_backuppc_server_ip/BackupPC_Admin.

The webserver user and the suid problem
---------------------------------------

The current setup of backuppc, the webserver needs to run as backuppc
user and this can be a problem on many setups where the webserver is
used for other sites. In the past one could suid a perl script, but it
was blocked globally due security problems several years ago. To
workaround that, perl-suid was used, but again blocked due the same
problem more recently, scripts can't be run securely with suid bit.
Still there is another way, this time using a simple binary program that
is suid as a launcher, that will run the backuppc perl scripts already
with the correct user. This isolates the perl script from the enviorment
and its considered safe.

To setup the backuppc to run on this mode you need to replace the
original backuppc cgi with the below C code compiled program and move
the backuppc cgi to another place.

Save the C code to a file named wrapper.c (please update the cgi path if
needed) and compile it with:

    $ gcc -o BackupPC_Admin wrapper.c

The wrapper C code:

    #include <unistd.h>
    #define REAL_PATH "/usr/share/backuppc/lib/real-BackupPC_Admin.cgi"
    int main(ac, av)
    char **av;
    {
       execv(REAL_PATH, av);
       return 0;
    }

move the real cgi /usr/share/backuppc/cgi-bin/BackupPC_Admin to the lib
directory /usr/share/backuppc/lib/real-BackupPC_Admin.cgi , place the
new binary BackupPC_Admin in the cgi-bin directory and chown the binary
cgi to backuppc:http and set the suid bit:

    # chown backuppc:http /usr/share/backuppc/cgi-bin/BackupPC_Admin
    # chmod 4750 /usr/share/backuppc/cgi-bin/BackupPC_Admin.

keep your web server with its usual user and backup should now be able
to run correctly.

See also
--------

-   BackupPC Home page
-   BackupPC documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=BackupPC&oldid=275285"

Category:

-   System recovery

-   This page was last modified on 13 September 2013, at 11:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
