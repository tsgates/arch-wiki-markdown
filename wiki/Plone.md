Plone
=====

Plone is a free and open source content management system built on top
of the Zope application server written in Python. Plone can be used for
all kinds of websites, including blogs, internet sites, webshops and
intranets. The strengths of Plone are its flexible and adaptable
workflow, very good security, extensibility, high usability and
flexibility.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Manual Installation                                          |
|                                                                          |
| -   2 Starting Plone                                                     |
|     -   2.1 Using Systemd                                                |
|     -   2.2 Using SysVinit                                               |
|                                                                          |
| -   3 Customizing                                                        |
| -   4 Upgrades                                                           |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install package plone-zeo from the AUR. Please be aware, that the AUR
package installs the Plone Unified Installer in /usr/src, which is then
run by Pacman upon initial install. The Unified Installer compiles and
installs the package in /opt/Plone. The package is mainly intended to
provide a convenient way to quickly install and get up and running with
Plone, as it handles the dependencies and bundles the init script and a
systemd unit file.

Note, that Plone site version upgrades are not handled by Pacman using
the AUR package, because the files in /opt/Plone are not managed by
Pacman directly. (see below for instructions on how to upgrade a Plone
site)

Manual Installation

The official way to install Plone is by using the Unified Installer,
which is also used by the plone-zeo package. Doing a manual install will
give you additional options.

The following prerequisites need to be installed:

-   Required: base-devel
-   Recommended:libxml2 libxslt libjpeg-turbo openssl sudo
-   Optional: wv poppler for Word and PDF document indexing

Download the latest installer from here and follow the Plone Install
Guide

For example to install Plone for production use, using a ZEO server
configuration do the following as root:

    pacman -S base-devel libxml2 libxslt libjpeg-turbo openssl sudo
    pver=4.2.1 # replace this with the latest version
    wget http://launchpad.net/plone/${pver:0:3}/$pver/+download/Plone-$pver-UnifiedInstaller.tgz
    tar -xzf *UnifiedInstaller.tgz
    ./Plone-$pver-UnifiedInstaller/install.sh --target=/opt/Plone zeo

The installer provides informative messages as well as saving an
install.log to help analyse potential problems.

Starting Plone
--------------

Manually start the service with:

    sudo -u plone /opt/Plone/zeocluster/bin/plonectl start

Then try the site on http://yoursite:8080

Use the displayed login password, which can also be found in
/opt/Plone/zeocluster/adminPassword.txt The start page allows you to
create an initial site, by filling in the name of the new site and
choosing optional add-ons.

Stop the service with:

    sudo -u plone /opt/Plone/zeocluster/bin/plonectl stop

Using Systemd

To enable the Plone service by default at start-up, run:

    systemctl enable plone

Using SysVinit

To enable the Plone service by default at start-up just add plone to the
DAEMONS array in /etc/rc.conf:

    DAEMONS=(... plone)

Customizing
-----------

To change ports, or to install add-ons and themes edit the file
buildout.cfg at /opt/Plone/zeocluster.

Apply the new settings by running:

    cd /opt/Plone/zeocluster
    sudo -u plone bin/buildout 

Upgrades
--------

Upgrades are done in a similar way using buildout. This should be fairly
straightforward, from one minor version to another. For example to
upgrade to Plone 4.2.x do the following: In your buildout.cfg, comment
out versions.cfg and uncomment the line pointing to dist.plone.org, so
it looks like this:

    extends = 
    base.cfg
    # versions.cfg
    http://dist.plone.org/release/4.2-latest/versions.cfg 

Then stop Plone and re-run buildout:

    cd /opt/Plone/zeocluster
    sudo -u plone bin/buildout  

Restart Plone and visit the Management Interface at
(http://yoursite:8080). You will likely see a message prompting you to
run Plone's migration script. Click the Upgrade button next to the site
and the upgrade script will run.

For more information on upgrades, especially between major versions of
Plone read the Upgrade Guide

See Also
--------

-   Plone Official Site
-   Official Documentation
-   Plone Wikipedia Article

Retrieved from
"https://wiki.archlinux.org/index.php?title=Plone&oldid=246913"

Category:

-   Web Server
