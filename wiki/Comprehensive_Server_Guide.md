Comprehensive Server Guide
==========================

This guide will give you an overview for the most common server options
in existence and will outline some administration and security
guidelines.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preface                                                            |
|     -   1.1 What is a server?                                            |
|     -   1.2 Arch Linux as a server OS                                    |
|                                                                          |
| -   2 Requirements                                                       |
| -   3 Basic set-up                                                       |
|     -   3.1 SSH                                                          |
|     -   3.2 LAMP                                                         |
|                                                                          |
| -   4 Additional web-services                                            |
|     -   4.1 E-Mail                                                       |
|     -   4.2 FTP                                                          |
|                                                                          |
| -   5 Local Network Services                                             |
|     -   5.1 CUPS (printing)                                              |
|     -   5.2 DHCP                                                         |
|     -   5.3 Samba (windows compatible file- and printer sharing)         |
|                                                                          |
| -   6 Security                                                           |
|     -   6.1 Firewall                                                     |
|         -   6.1.1 Iptables                                               |
|         -   6.1.2 UFW                                                    |
|             -   6.1.2.1 GUFW                                             |
|                                                                          |
|     -   6.2 Protecting SSH                                               |
|         -   6.2.1 Protecting against brute force attacks                 |
|         -   6.2.2 Deny root login                                        |
|                                                                          |
|     -   6.3 SE Linux                                                     |
|                                                                          |
| -   7 Administration and maintenance                                     |
|     -   7.1 Accessibility                                                |
|                                                                          |
| -   8 Extras                                                             |
|     -   8.1 phpMyAdmin                                                   |
|                                                                          |
| -   9 More Resources                                                     |
+--------------------------------------------------------------------------+

Preface
-------

What is a server?

In essence, a server is a computer that runs services that involve
clients working on remote locations. All computers run services of some
kind, for example: when using Arch as a desktop you will have a network
service running to connect to a network. A server will, however, run
services that involve external clients, for example: a webserver will
run a website to be viewed via the internet or elsewhere on a local
network.

Arch Linux as a server OS

You may have seen the comments or claims: Arch Linux was never intended
as a server operating system! This is correct: there is no server
installation disc available, per se, such as those you may find for
other distributions. This is because Archlinux comes as a minimal (but
solid) base system, with very few desktop or server features
pre-installed. This does not mean you should not use Archlinux as a
server; quite the contrary. Arch's core installation is a secure and
capable foundation. Since only a small number of features come
pre-installed, this core installation can easily be used as a basis for
a Linux Server. All the most popular server software (Apache, MySQL,
PHP, Samba, and plenty more) is available in the official repository,
and even more is available on the AUR. The wiki also contains much
detailed documentation regarding how to get set up with this software.

Note: Add note about users using Arch as server.

Requirements
------------

For using Arch Linux on a server you will need to have an Arch Linux
installation ready.

In most Linux server Operating Systems you have two options:

-   A 'text' version of the OS (where everything is done from the
    command line)
-   A GUI version of the OS (where you get a desktop interface such as
    GNOME/KDE etc).

Note: If you have services on your server that need to be administered
using a GUI and cannot be done remotely you must choose the second
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
-   A http server (Apache), required for serving webpages.
-   A database server (MySql), often required for storing data of
    address book-, forum- or blog scripts.
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
interface.Users available on the system can be given access to log on
remotely though SSH, thereby enabeling remote administration of your
server.

The Arch wiki SSH page covers Installation and Configuration nicely.

LAMP

A LAMP server is a reasonably standard webserver.   
 There are often disputes as to what the 'P' stands for, some people say
it is PHP some people say it is Perl while others say it's Python. For
the purposes of this guide I am going to make it PHP, although there are
some nice Perl and Python modules for Linux so you may wish to install
Perl or Python as well.   
 Having said that, LAMP is a reasonably standard webserver, it is by no
means simple so there may be a lot to take in here.

  
 Please refer to the LAMP wiki page for instructions on installation and
configuration.

Additional web-services
-----------------------

> E-Mail

Please refer to pages in Category:Mail Server for instructions on mail
server installation and configuration.

> FTP

FTP stands for File Transfer Protocol. FTP is a service that can provide
access to the filesystem from a remote location through an FTP client
(FileZilla, gftp etc.) or FTP-capable browser. Through FTP, you are able
to add or remove files from a remote location, as well as apply some
chmod commands to these files to set certain permissions.

FTP access will be related to user accounts available on the system,
allowing simple rights management. FTP is a much used tool for adding
files to a webserver from a remote locations.

There are several FTP daemons available, here follows a list of Arch
Linux Wiki pages on a few:

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
You can either add all these printers to every user's pc, or add all
printers to a server running CUPS, and then simply adding the server to
all clients. This allows for a central printing system that can be
online 24/7, especially nice for printers that do not have networking
capabilities.

Please refer to the CUPS wiki page for instructions on installation and
configuration.

> DHCP

Note: dhcp v4 does not currently work due to ipv6 issues, this part of
the guide will be written when that issue is resolved.

> Samba (windows compatible file- and printer sharing)

Samba is an open source implementation of SBM/CIFS networking protocols,
effectively allowing you to share files and printers between Linux and
Windows systems. Samba can provide public shares or require several
forms of authentication.

Please refer to the Samba wiki page for instructions on installation and
configuration.

Security
--------

> Firewall

Refer to Firewalls for details regarding available firewall software.

Iptables

The Linux kernel includes iptables as a built-in firewall solution.
Configuration may be managed directly through the userspace utilities or
by installing one of several GUI configuration tools.

UFW

The Uncomplicated FireWall is a simple frontend to iptables for the
command line. It is available in the community repository. One way to
allow SSH and HTTP access after installation would be:

    # ufw allow SSH/tcp
    # ufw allow WWW/tcp
    # ufw enable

You can also allow only specific ip addresses and ranges. Should you
have a static ip address, this can be a convenient way to limit ssh
access. To only allow SSH access from 66.211.214.131:

    # ufw allow 66.211.214.131 to any app SSH

To view other preconfigured services and apps run

    # ufw app list

GUFW

A GUI frontend to UFW is available providing simple management of your
iptables rules and settings. It is available in the community
repository. To install and run use the following commands:

    # pacman -S gufw
    # gufw

> Protecting SSH

Allowing remote log-on through SSH is good for administrative purposes,
but can pose a threat to your server's security. Often the target of
brute force attacks, SSH access needs to be limited properly to prevent
third parties gaining access to your server.

-   Use non-standard account names and passwords
-   Only allow incoming SSH connections from trusted locations
-   Use fail2ban or sshguard to monitor for brute force attacks, and ban
    brute forcing IPs accordingly

Protecting against brute force attacks

Brute forcing is a simple concept: One continuously tries to log in to a
webpage or server log-in prompt like SSH with a high number of random
username and password combinations. You can protect yourself from brute
force attacks by using an automated script that blocks anybody trying to
brute force their way in, for example fail2ban or sshguard.

Deny root login

It is generally considered bad practice to allow the user root to log in
over SSH: The root account will exist on nearly any Linux system and
grants full access to the system, once login has been achieved. Sudo
provides root rights for actions requiring these and is the more secure
solution, third parties would have to find a username present on the
system, the matching password and the matching password for sudo to get
root rights on your system. More barriers to be breached before full
access to the system is reached.

Configure SSH to deny remote logins with the root user by editing (as
root) /etc/ssh/sshd_config and look for this section:

    # Authentication:

    #LoginGraceTime 2m
    #PermitRootLogin yes
    #StrictModes yes
    #MaxAuthTries 6
    #MaxSessions 10

Now simply change #PermitRootLogin yes to no, and uncomment the line:

    PermitRootLogin no

Next, restart the SSH daemon:

    # systemctl restart sshd

You will now be unable to log in through SSH under root, but will still
be able to log in with your normal user and use su - or sudo to do
system administration.

> SE Linux

Note: SELinux is extremely intensive and can cause big problems, it is
not suggested to use unless you absolutely require it.

Please refer to the SELinux wiki page for instructions on installation
and configuration, the page is only a stub, if you use SELinux you are
on your own.

Administration and maintenance
------------------------------

Accessibility

SSH is the Secure SHell, it allows you to remotely connect to your
server and administer commands as if you were physically at the
computer. Combined with Screen, SSH can become an invaluable tool for
remote maintenance and administration while on-the-move. Please note
that a standard SSH install is not very secure and some configuration is
needed before the server can be considered locked-down. This
configuration includes disabling root login, disabling password based
login and setting up firewall rules. In addition, you may supplement the
security of your SSH daemon by utilizing daemons such as sshguard or
fail2ban which constantly monitor the log files for any suspicious
activity and ban IP addresses with too many failed logins.

  
 X Forwarding is forwarding your X session via SSH so you can login to
the desktop GUI remotely. Use of this feature will require SSH and an X
server to be installed on the server. You will also need to have a
working X server installed on the client system you will be using to
connect to the server with. More information can be found in the X
Forwarding section of the SSH guide.

Extras
------

> phpMyAdmin

phpMyAdmin is a free software tool written in PHP intended to handle the
administration of MySQL over the World Wide Web. phpMyAdmin supports a
wide range of operations with MySQL. The most frequently used operations
are supported by the user interface (managing databases, tables, fields,
relations, indexes, users, permissions, etc), while you still have the
ability to directly execute any SQL statement."
http://www.phpmyadmin.net/home_page/index.php

More Resources
--------------

-   LAMP
-   MySQL - Arch wiki article for MySQL
-   Virtual Private Server - A list of VPS providers offering Arch
-   http://www.mysql.com/
-   http://www.apache.org/
-   http://www.php.net/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Comprehensive_Server_Guide&oldid=247553"

Category:

-   Web Server
