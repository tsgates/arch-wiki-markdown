Yaourt
======

Related articles

-   AUR Helpers
-   AUR
-   Pacman

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

Note:Please report bugs at the archlinux.fr bugtracker.

Contents
--------

-   1 Installation
-   2 Proxy settings
-   3 Using yaourt
-   4 Examples
-   5 Persistent local source repositories
-   6 Troubleshooting
    -   6.1 Yaourt asking for password twice
    -   6.2 Yaourt freezing / system heavy slowdown
    -   6.3 Yaourt freezing during PKBUILD download

Installation
------------

First you need to install package-query as a dependency, and then the
yaourt package itself. Since both those packages are available from the
AUR, you will have to install them with the official method for
installing unsupported packages, which is exhaustively described in the
AUR article. It is important that you understand what "unsupported
package" really means, and you can take this as an opportunity to learn
what are the operations that AUR helpers like yaourt make automatic. You
might want to have the base-devel group installed as well, since some
packages require the GNU autotools.

Alternatively you can add the archlinuxfr repository as described on the
yaourt homepage.

Proxy settings
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

or

    $ yaourt -Sa packagename

You can update your system including AUR packages with:

    $ yaourt -Syua

See the yaourt manual page for more information.

Examples
--------

Search and install:

    $ yaourt search pattern

Sync database, upgrade packages, search the AUR and devel (all packages
based on cvs, svn, git, bzr(...)-version) upgrades:

    $ yaourt -Syua --devel 

Build package from source:

    $ yaourt -Sb package

Check, edit, merge or remove *.pac* files:

    $ yaourt -C

Get a PKGBUILD (support split package):

    $ yaourt -G package

Build and export package, its sources to a directory:

    $ yaourt -Sb --export dir package

Backup database:

    $ yaourt -B

Query backup file:

    $ yaourt -Q --backupfile file

See also: Pacman and Pacman Tips.

Persistent local source repositories
------------------------------------

By default, yaourt will pull remote repositories for building to /tmp.
To avoid having to refetch whole repositories whenever AUR packages
update, you can change this directoy by uncommenting and setting
DEVELBUILDDIR in yaourtrc to wherever you want source repositories
pulled to. Note this will only apply to devel packages, usually suffixed
by -git or -svn.

    /etc/yaourtrc

    DEVELBUILDDIR="/var/abs/local/yaourtbuild"

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
as it's a tmpfs. Change the location in /etc/yaourtrc (uncomment
TMPDIR = line) to somewhere else to avoid clogging up your system.

> Yaourt freezing during PKBUILD download

If you are using IPv6 connectivity there may be some problems with
connecting to IPv4 AUR address. To solve this, add to /etc/hosts
following line:

    78.46.78.247 aur.archlinux.org aur

(as for 2013-10-14)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Yaourt&oldid=305950"

Categories:

-   Package management
-   Arch User Repository

-   This page was last modified on 20 March 2014, at 17:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
