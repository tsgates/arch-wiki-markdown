Wget
====

GNU Wget is a free software package for retrieving files using HTTP,
HTTPS and FTP, the most widely-used Internet protocols. It is a
non-interactive commandline tool, so it may easily be called from
scripts, cron jobs, terminals without X-Windows support, etc. [source]

Contents
--------

-   1 Installing
-   2 Configuring
    -   2.1 FTP automation
    -   2.2 Proxy
    -   2.3 pacman integration
-   3 Usage
    -   3.1 Archive a complete website

Installing
----------

wget is normally installed as part of the base setup. If not present,
install the wget package using pacman. The git version is present in the
AUR by the name wget-git.

Configuring
-----------

Configuration is performed in /etc/wgetrc. Not only is the default
configuration file well documented; altering it is seldom necessary. See
the man page for more intricate options.

> FTP automation

Normally, SSH is used to securely transfer files among a network.
However, FTP is lighter on resources compared to scp and rsyncing over
SSH. FTP is not as secure, but when transfering large amounts of data
inside a firewall protected environment on CPU-bound systems, using FTP
can prove beneficial.

    wget ftp://root:somepassword@10.13.X.Y//ifs/home/test/big/"*.tar"

    3,562,035,200 74.4M/s   in 47s

In this case, Wget transfered a 3.3 G file at 74.4MB/second rate.

In short, this procedure is:

-   scriptable
-   faster than ssh
-   easily used by languages than can substitute string variables
-   globbing capable

> Proxy

Wget uses the standard proxy environment variables. See: Proxy settings

To use the proxy authentication feature:

    $ wget --proxy-user "DOMAIN\USER" --proxy-password "PASSWORD" URL

Proxies that use HTML authentication forms are not covered.

> pacman integration

To have pacman automatically use Wget and a proxy with authentication,
place the Wget command into /etc/pacman.conf, in the [options] section:

    XferCommand = /usr/bin/wget --proxy-user "domain\user" --proxy-password="password" --passive-ftp -c -O %o %u

Warning:be aware that storing passwords in plain text is not safe. Make
sure that only root can read this file with chmod 600 /etc/pacman.conf.

Usage
-----

This section explains some of the use case scenarios for Wget.

> Archive a complete website

Wget can archive a complete website whilst preserving the correct link
destinations by changing absolute links to relative links.

    $ wget -np -r -k 'http://your-url-here'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wget&oldid=302673"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
