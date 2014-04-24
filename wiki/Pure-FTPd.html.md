Pure-FTPd
=========

Pure-FTPd is a ftp server designed with security in mind.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Set up Virtual Users
    -   2.2 Backends
-   3 See Also

Installation
------------

pure-ftpd can be installed from the Arch User Repository.

The Server can be started using # systemctl start pure-ftpd.

To start the Server automaticly use # systemctl enable pure-ftpd.

For more informations how to manage the Service read using units.

Configuration
-------------

Pure-FTPd configuration is completly done with its startup arguments.
There is a wrapper script, which is used to read /etc/pure-ftpd.conf. It
then calls Pure-FTPd with the corresponding arguments.

> Set up Virtual Users

With Pure-FTPd its possible to use virtual users instead of real system
users.

The avaliable users needs to be provided by one ore more backends like.
See backends.

We are going to use the PureDB backend since it is simple and requires
no further dependencies. Uncomment the following two lines:

    # We disable the anonymous account.
    NoAnonymous yes
    # We use PureDB as backend and specify its path.
    PureDB /etc/pureftpd.pdb

Now only authenticated users can connect. To add users to the PureDB we
need to create a /etc/passwd like file which is then used to create the
PureDB.

To create, view or modify the /etc/pureftpd.passwd file we use the
pure-pw command.

    # pure-pw useradd someuser -u ftp -d /srv/ftp

This creates the user someuser which runs as the ftp systemuser. He is
chrooted to /srv/ftp. If you dont want to chroot him use -D instead of
-d.

> Note:

The virtual users running as the ftp systemusers can not log in by
default. To change that behaviour set the option MinUID in
/etc/pure-ftpd.conf to 14(UID of the ftp user).

We need also to list the shell of the ftp systemuser in /etc/shells.

# echo "/bin/false" >> /etc/shells

The virtual user someuser can now access everything in /srv/ftp.

Note:Symlinks outsite of the chrooted directory do not work since the
package is not compiled with --with-virtualchroot. You can use
mount --bind source target as a workaround.

> Backends

You need to specify one or more Backends. If you specify more than one,
Pure-FTPd will respect the order in which they are specified. It will
use the first backend which contains the requested user.

Available backends are:

-   /etc/passwd
-   MySQL
-   LDAP
-   PostgreSQL
-   PAM
-   PureDB
-   you can write your own

See Also
--------

-   official homepage
-   virtual users

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pure-FTPd&oldid=296020"

Category:

-   File Transfer Protocol

-   This page was last modified on 3 February 2014, at 09:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
