Comprehensive Server Guide
==========================

This guide will give you an overview for the most common server options
in existence and will outline some administration and security
guidelines.

Contents
--------

-   1 Preface
    -   1.1 What is a server?
    -   1.2 Arch Linux as a server OS
-   2 Requirements
-   3 Basic set-up
    -   3.1 SSH
    -   3.2 LAMP
-   4 Additional web-services
    -   4.1 E-Mail
    -   4.2 FTP
-   5 Local Network Services
    -   5.1 CUPS (printing)
    -   5.2 DHCP
    -   5.3 Samba (Windows-compatible file and printer sharing)
-   6 Security
    -   6.1 Firewall
    -   6.2 Protecting SSH
    -   6.3 SELinux
-   7 Administration and maintenance
    -   7.1 Accessibility
-   8 Extras
    -   8.1 phpMyAdmin
-   9 More Resources

Preface
-------

What is a server?

In essence, a server is a computer that runs services that involve
clients working on remote locations. All computers run services of some
kind, for example: when using Arch as a desktop you will have a network
service running to connect to a network. A server will, however, run
services that involve external clients, for example: a web server will
run a web site to be viewed via the Internet or elsewhere on a local
network.

Arch Linux as a server OS

You may have seen the comments or claims: Arch Linux was never intended
as a server operating system! This is correct: there is no server
installation disc available, per se, such as those you may find for
other distributions. This is because Arch Linux comes as a minimal (but
solid) base system, with very few desktop or server features
pre-installed. This does not mean you should not use Arch Linux as a
server; quite the contrary. Arch's core installation is a secure and
capable foundation. Since only a small number of features come
pre-installed, this core installation can easily be used as a basis for
a Linux Server. All the most popular server software (Apache,
MySQL/MariaDB, PHP, Samba, and plenty more) is available in the official
repository, and even more is available on the AUR. The wiki also
contains much detailed documentation regarding how to get set up with
this software.

Note: Add note about users using Arch as server.

Requirements
------------

For using Arch Linux on a server, you will need to have an Arch Linux
installation ready.

In most Linux server operating systems, you have two options:

-   A 'text' version of the OS (where everything is done from the
    command line)
-   A GUI version of the OS (where you get a desktop interface, such as
    GNOME/KDE, etc).

Note: If you have services on your server that need to be administered
using a GUI and cannot be done remotely, you must choose the second
option.

For the installation of Arch Linux, please refer to the Beginner's
Guide, but do not go any further than this section unless you require a
GUI.

Basic set-up
------------

So what is a "basic" set-up:

-   Remote access to the server.

We want to be able to remotely log-on to our server to perform several
administrative tasks. When your server is located elsewhere or does not
have a monitor attached: removing or adding files, changing
configuration options and server rebooting are all tasks which are
impossible to do without a way to log on to your server remotely. SSH
nicely provides this functionality.

-   Your Linux server.
-   A http server (Apache), required for serving web pages.
-   A database server (MySql/MariaDB), often required for storing data
    of address book-, forum- or blog scripts.
-   The PHP scripting language, a highly popular internet scripting
    language used in blogs, forums, content management systems and many
    other web-scripts.

As the bold letters suggest, there is a name for this combination of
applications: LAMP.

The following sections will guide you through the installation and
configuration of the above mentioned basic set-up features.

SSH

SSH stands for Secure Shell. SSH enables you to log on to your server
through an SSH client, presenting you with a recognizable terminal-like
interface. Users available on the system can be given access to log on
remotely though SSH, thereby enabling remote administration of your
server.

The Arch wiki SSH page covers Installation and Configuration nicely.

LAMP

A LAMP server is a reasonably standard web server.

There are often disputes as to what the 'P' stands for, some people say
it is PHP some people say it is Perl while others say it is Python. For
the purposes of this guide I am going to make it PHP, although there are
some nice Perl and Python modules for Linux so you may wish to install
Perl or Python as well.

Having said that, it is by no means simple so there may be a lot to take
in here.

Please refer to the LAMP wiki page for instructions on installation and
configuration.

Additional web-services
-----------------------

> E-Mail

Please refer to pages in Category:Mail Server for instructions on mail
server installation and configuration.

> FTP

FTP stands for File Transfer Protocol. FTP is a service that can provide
access to the file system from a remote location through an FTP client
(FileZilla, gftp, etc.) or FTP-capable browser. Through FTP, you are
able to add or remove files from a remote location, as well as apply
some chmod commands to these files to set certain permissions.

FTP access will be related to user accounts available on the system,
allowing simple rights management. FTP is a much used tool for adding
files to a web server from a remote locations.

There are several FTP daemons available. Here follows a list of ArchWiki
pages on a few:

-   vsFTPd: Very Secure FTP Daemon (often the standard)
-   glFTPd: GreyLine FTP daemon (highly configurable, no system accounts
    required)
-   proFTPd: Article is incomplete.

There is also the option of FTP over SSH, or SFTP

Local Network Services
----------------------

> CUPS (printing)

CUPS, or Common UNIX Printing System, can provide a central point via
which a number of users can print. For instance, you have several (say
3) printers and several people on a local network that wish to print.
You can either add all these printers to every user's computer, or add
all printers to a server running CUPS, and then simply adding the server
to all clients. This allows for a central printing system that can be
online 24/7, which is especially nice for printers that do not have
networking capabilities.

Please refer to the CUPS wiki page for instructions on installation and
configuration.

> DHCP

Note: dhcp v4 does not currently work due to IPv6 issues, this part of
the guide will be written when that issue is resolved.

> Samba (Windows-compatible file and printer sharing)

Samba is an open-source implementation of the SMB/CIFS networking
protocols, effectively allowing you to share files and printers between
Linux and Windows systems. Samba can provide public shares or require
several forms of authentication.

Please refer to the Samba wiki page for instructions on installation and
configuration.

Security
--------

> Firewall

Refer to Firewalls for details regarding available firewall software.

> Protecting SSH

Allowing remote log-on through SSH is good for administrative purposes,
but can pose a threat to your server's security. Often the target of
brute force attacks, SSH access needs to be limited properly to prevent
third parties gaining access to your server. See
Secure_Shell#Connecting_to_the_server for how to configure it.

> SELinux

Please refer to the SELinux wiki page for instructions on installation
and configuration.

Administration and maintenance
------------------------------

Accessibility

SSH is the Secure SHell, it allows you to remotely connect to your
server and administer commands as if you were physically at the
computer. Combined with Screen, SSH can become an invaluable tool for
remote maintenance and administration while on-the-move. Please note
that a standard SSH install is not very secure and some configuration is
needed before the server can be considered locked-down. This
configuration includes disabling root log-in, disabling password-based
log-in and setting up firewall rules. In addition, you may supplement
the security of your SSH daemon by utilizing daemons, such as sshguard
or fail2ban, which constantly monitor the log files for any suspicious
activity and ban IP addresses with too many failed log-in attempts.

  
 X Forwarding is forwarding your X session via SSH so you can log in to
the desktop GUI remotely. Use of this feature will require SSH and an X
server to be installed on the server. You will also need to have a
working X server installed on the client system you will be using to
connect to the server with. More information can be found in the X
Forwarding section of the SSH guide.

Extras
------

> phpMyAdmin

phpMyAdmin is a free software tool written in PHP intended to handle the
administration of MySQL over the Internet. phpMyAdmin supports a wide
range of operations with MySQL. The most frequently used operations are
supported by the user interface (managing databases, tables, fields,
relations, indexes, users, permissions, etc), while you still have the
ability to directly execute any SQL statement."
http://www.phpmyadmin.net/home_page/index.php

More Resources
--------------

-   LAMP
-   MySQL - ArchWiki article for MySQL
-   Virtual Private Server - A list of VPS providers offering Arch
-   https://mariadb.org/
-   https://www.apache.org/
-   https://www.php.net/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Comprehensive_Server_Guide&oldid=298152"

Category:

-   Web Server

-   This page was last modified on 16 February 2014, at 07:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
