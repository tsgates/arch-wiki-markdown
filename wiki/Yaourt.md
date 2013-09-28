Yaourt
======

Summary

How to install and use yaourt.

Related

AUR Helpers

Yaourt (Yet AnOther User Repository Tool; French for 'Yogurt') is a
community-contributed wrapper for pacman which adds seamless access to
the AUR, allowing and automating package compilation and installation
from your choice of the thousands of PKGBUILDs in the AUR, in addition
to the many thousands of available Arch Linux binary packages. Yaourt
uses the same exact syntax as pacman, which saves you from relearning an
entirely new method of system maintenance but also adds new options.
Yaourt expands the power and simplicity of pacman by adding even more
useful features and provides pleasing, colorized output, interactive
search mode, and much more.

Warning:Yaourt is an unofficial, third-party script that is not
supported by the Arch Linux developers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Proxy Settings                                                     |
| -   3 Using yaourt                                                       |
| -   4 Examples                                                           |
| -   5 Troubleshooting                                                    |
|     -   5.1 Yaourt asking for password twice                             |
|     -   5.2 Yaourt freezing / system heavy slowdown                      |
+--------------------------------------------------------------------------+

Installation
------------

First you need to install package-query as a dependency, and then the
yaourt package itself. Since both those packages are available from the
AUR, you will have to install them with the official method for
installing unsupported packages, which is exhaustively described in the
Arch User Repository article. Alternatively you can add the archlinuxfr
repo as described on the yaourt homepage.

It is important that you understand what "unsupported package" really
means, and you can take this as an opportunity to learn what are the
operations that AUR helpers like yaourt make automatic.

Note:Please report bugs at the archlinux.fr bugtracker.

Proxy Settings
--------------

If you access the Internet through an HTTP proxy, you may have to set
the environment variables http_proxy and https_proxy in your ~/.bashrc
(setting only http_proxy will prevent you from downloading the package
from AUR):

    $ export http_proxy='http://proxy.hostname.com:port'
    $ export https_proxy='https://proxy.hostname.com:port'

For more information, check curl's man page.

sudo does not keep environment variables like http_proxy, so if you use
sudo, you must use visudo command to edit /etc/sudoers and add:

    Defaults env_keep += "http_proxy"
    Defaults env_keep += "https_proxy"
    Defaults env_keep += "ftp_proxy"

Using yaourt
------------

You can install packages (including AUR packages) with

    $ yaourt packagename

You can update your system including AUR packages with:

    $ yaourt -Syua

Examples
--------

Search and install:

    $ yaourt <search pattern>

Sync database, upgrade packages, search the AUR and devel (all packages
based on cvs, svn, git, bzr(...)-version) upgrades:

    $ yaourt -Syua --devel 

Build package from source:

    $ yaourt -Sb <package>

Check, edit, merge or remove *.pac* files:

    $ yaourt -C

Get a PKGBUILD (support split package):

    $ yaourt -G <package>

Build and export package, its sources to a directory:

    $ yaourt -Sb --export <dir> <package>

Backup database:

    $ yaourt -B

Query backup file:

    $ yaourt -Q --backupfile <file>

See also: Pacman and Pacman Tips.

Troubleshooting
---------------

> Yaourt asking for password twice

If you disable the sudo password timeout by adding

    Defaults timestamp_timeout=0

to /etc/sudoers, then yaourt will ask for your password twice each time
you try to perform an operation that requires root. To prevent this,
add:

    SUDONOVERIF=1

to /etc/yaourtrc or to ~/.yaourtrc

> Yaourt freezing / system heavy slowdown

Mostly a problem for systems with less RAM or a smaller swap space.
Yaourt uses /tmp to compile in by default. By default this is all in RAM
as it's a tmpfs. Change the location in /etc/yaourtrc (uncomment "TMPDIR
= " line) to somewhere else to avoid clogging up your system.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Yaourt&oldid=255192"

Categories:

-   Package management
-   Arch User Repository
