Trinity
=======

Summary

Trinity is a fork of KDE3 that has been updated to work with current
software and libraries. The stable release is 3.5.13. The development
release is 14.0.0.

Trinity unofficial repositories

Visit http://archlinux.us.to

Related

Creating Packages

Custom local repository

pacman Tips

The Trinity Desktop Environment (TDE) project is a computer desktop
environment for Unix-like operating systems with a primary goal of
retaining the overall KDE 3.5 computing style. The project was founded
by and is still led by Timothy Pearson. Timothy is an experienced and
skilled software developer and was the KDE 3.x coordinator of previous
Kubuntu releases.

The goal of this project is to keep the KDE3.5 computing style alive, as
well as polish off any rough edges that were present as of KDE 3.5.10.
Along the way, new useful features have be added to keep the environment
up-to-date.

The current stable release of TDE (3.5.13) was released Nov 1st 2011. A
software release update (SRU) for 3.5.13 is planned in late 2012.
Current development is on 14.0.0. Both 3.5.13(sru) and 14.0.0 build on
Arch with all current libraries. The old stable 3.5.12 release was
packaged as an updated kdemod3.

Note:Backwards compatibility with 3.5.X was dropped in 14.0.0 to allow
install of TDE/TQt without conflict with KDE4/Qt4.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The difference between 3.5.13 and 14.0.0                           |
| -   2 Installation                                                       |
| -   3 Start and configuration                                            |
|     -   3.1 Configure to work with startx                                |
|     -   3.2 Configure with kdm greeter                                   |
|                                                                          |
| -   4 Build from source                                                  |
|     -   4.1 PKGBUILDs - current git code                                 |
|     -   4.2 Build order                                                  |
|                                                                          |
| -   5 Development 14.0.0 status                                          |
|     -   5.1 Required AUR packages                                        |
|     -   5.2 Complete packages - 14.0.0 and 3.5.13-sru                    |
|     -   5.3 TDE GIT application in need of packaging/updating            |
|                                                                          |
| -   6 Known issues                                                       |
|     -   6.1 Issues for 3.5.13-sru                                        |
|     -   6.2 Issues for 14.0.0                                            |
|                                                                          |
| -   7 Contributors                                                       |
|     -   7.1 Archlinux                                                    |
|     -   7.2 Developers                                                   |
|     -   7.3 Content Distribution                                         |
|     -   7.4 Web Team                                                     |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

The difference between 3.5.13 and 14.0.0
----------------------------------------

The versioning change between 3.5.13 and 14.0.0 signifies that backwards
compatibility with 3.5.X has been dropped to allow TDE/TQt to install
along side KDE4/Qt4 without conflict. 14.0.0 will continue to rely on
HAL, but subsequent releases will do away with that dependency. 14.0.0
contains the first prototype of media:/ kioslave as a replacement for
HAL. 3.5.13 continues backwards compatibility with KDE 3.5.10 code and
provides an alternative choice for those that prefer. The 3.5 13 branch
will be maintained for the forseeable future.

Currently the remaining TQt name changes are being implemented after
which a tentative code 'freeze' is anticipated to allow user testing and
bug identification. 14.0.0 will be a true TDE release with all branding,
artwork, and graphics changed and updated for this project rather than
using the holdover KDE3 stock images. All in all, the desktop functions
beautifully on current graphics libs, systemd-tools, libusbx, udisk2 and
other newly implemented hardware paradigms.

Installation
------------

Currently development packages for Arch Linux are available for both
3.5.13-sru and 14.0.0. Server space has been graciously provided by
maevius.

For stable 3.5.13-sru snapshots add to your /etc/pacman.conf:

    [tde3513]
    Server = http://archlinux.us.to/3.5.13/$arch

Note:If you have installed packages before 8/18/12, tde-tdeartwork was
misssing. Please install that package to insure your selection of
screensavers are complete.

For development 14.0.0 snapshots (expected by 9/1), add to your
/etc/pacman.conf:

    [tde1400]
    Server = http://archlinux.us.to/14.0.0/$arch

Meta package installation for tde is provided under the name tde-base.
Simply install with:

    pacman -Sy tde-base

Note:On install, you should expect conflicts with tde-sip and
tde-sip4-tqt. The TDE packages tde-sip and tde-sip4-tqt are direct
replacements for the sip and python2-sip packages. They simply contain
additional extensions for TDE. If you encounter these conflicts, the
recommended install is:

    pacman -Rdd sip python2-sip
    pacman -Sy tde-base

Warning:If attempting to install 3.5.13 along side KDE4 you will
experience conflicts with libart-lgpl and kdebase-workspace. The
libart-lgpl packages are equivalent. The kdebase-workspace conflict is
with /etc/ksysguarddrc. Both are in the process of being eliminated.

Start and configuration
-----------------------

After a successful install of TDE, starting TDE from the command line or
configuring /etc/inittab to launch tdm is straightforward. The init
script for the display manager has been renamed from kdm to tdm to avoid
conflicts.

> Configure to work with startx

Trinity provides a normal starttde in /opt/trinity/bin (symlink provided
in 3.5.13). The easiest way to start Trinity is to simply add
/opt/trinity/starttde entry at the end of ~/.xinitrc. If you do not
presently have ~/.xinitrc, then simply create it with the following
entry:

    ~/.xinitrc

    exec /opt/trinity/bin/starttde

Then from the command line, just type startx.

> Configure with kdm greeter

Trinity provides a great looking tdm graphical interface. The
tde-tdebase PKGBUILD has been updated to install the trinity.desktop
file in /etc/X11/sessions. In order to automatically lauch tdm on boot,
edit /etc/inittab and change the runlevel 5 x startup to:

    x:5:respawn:/opt/trinity/bin/tdm -nodaemon

If you modified inittab in runlevel 3, you can use telinit to initialize
the runlevel 5 services from the command line.

If you experiment with other display managers (slim, etc..) please drop
a quick howto here.

Build from source
-----------------

> PKGBUILDs - current git code

For a snapshot of PKGBUILD sources for building against the current GIT
tree, see R14 and 3.5.13-sru. Be sure to read the README-building.txt.

Note:Final PKGBUILD source files will be moved to the tdepackaging GIT
tree after 14.0.0 is released.

> Build order

The required build order is specified in the Trinity-HowToBuild. After
building tdebase, you can start the desktop.

Warning:Trinity on Arch must be built in a clean environment without
KDE4 present.

Set up your chroot for building by referencing DeveloperWiki:Building in
a Clean Chroot. Make sure you configure your local repository in
$CHROOT/root/repo and add each package built to the repository as
outlined in the DeveloperWiki.

    Example

     # mkarchroot -u $CHROOT/root
     # makechrootpkg -c -r $CHROOT
     # makechrootpkg -r $CHROOT    

Which means respectively:

1.  update the chroot
2.  build first package with the -c option
3.  build remaining packages without update }}

Development 14.0.0 status
-------------------------

The following packages have been successfully built from the TDE GIT
tree for the upcoming release.

> Required AUR packages

     hal 
     hal-info 
     libutempter
     wv2

> Complete packages - 14.0.0 and 3.5.13-sru

     tde-abakus
     tde-amarok
     tde-arts
     tde-avahi-tqt
     tde-basket
     tde-dbus-1-tqt
     tde-dbus-tqt
     tde-digikam
     tde-dolphin
     tde-filelight
     tde-gtk-qt-engine
     tde-gwenview
     tde-k3b
     tde-k9copy
     tde-katapult
     tde-kaffeine
     tde-kbarcode
     tde-kbookreader
     tde-kdiff3
     tde-kdirstat
     tde-kgtk-qt3
     tde-kima
     tde-kio-locate
     tde-kipi-plugins
     tde-kmplayer
     tde-knemo
     tde-knetload
     tde-knetstats
     tde-knutclient
     tde-koffice
     tde-konversation
     tde-kpowersave
     tde-krename
     tde-krusader
     tde-ksplash-engine-moodin
     tde-libart-lgpl
     tde-libcaldav
     tde-libcarddav
     tde-libkdcraw
     tde-libkexiv2
     tde-libkipi
     tde-libksquirrel
     tde-python-tqt
     tde-rosegarden
     tde-sip
     tde-sip4-tqt
     tde-soundkonverter
     tde-tde-style-qtcurve
     tde-tdeaccessibility
     tde-tdeaddons
     tde-tdeadmin
     tde-tdeartwork
     tde-tdebase
     tde-tdeedu
     tde-tdegames
     tde-tdegraphics
     tde-tdelibs
     tde-tdemultimedia
     tde-tdenetwork
     tde-tdepim
     tde-tdesdk
     tde-tdesvn
     tde-tdetoys
     tde-tdeutils
     tde-tdevelop
     tde-tdewebdev
     tde-tqca-tls
     tde-tqt3
     tde-tqtinterface
     tde-twin-style-crystal
     tde-wlassistant
     tde-yakuake

> TDE GIT application in need of packaging/updating

The following is a list of packages that need PKGBUILDs create and/or
code fixes to build with current libraries. If you can help with the
project and code updates then please join us on the trinity-devel list
(trinity-devel@lists.pearsoncomputing.net). Visit
http://www.trinitydesktop.org/mailinglist.php for more information.

     adept
     bibletime
     compizconfig-backend-kconfig
     desktop-effects-tde
     filelight-l10n
     fusion-icon
     kaffeine-mozilla
     kbfx
     kchmviewer
     kcmautostart
     kcpuload
     kdbusnotification
     kdpkg
     keep
     kerry
     kile
     kio-apt
     kio-umountwrapper
     kiosktool
     kmyfirewall
     kmymoney
     knetworkmanager8
     knetworkmanager9
     knights
     knowit
     kopete-otr
     kpicosim
     kpilot
     kpowersave-nohal
     kradio
     kstreamripper
     ksystemlog
     ktechlab
     ktorrent
     kvirc
     kvkbd
     kvpnc
     piklab
     potracegui
     qt4-tqt-theme-engine
     smartcardauth
     smb4k
     soundkonverter
     tde-guidance
     tde-style-lipstik
     tde-systemsettings
     tdesudo
     tdesvn
     tellico
     libtqt-perl
     pytdeextensions
     python-trinity
     tdebindings
     tdesdk

Known issues
------------

> Issues for 3.5.13-sru

The following are issues that are specific to the 3.5.13-sru release:

KHelpCenter documentation from packages built with autotools are
installed in /opt/trinity/share/doc/HTML while documentation from CMake
packages are installed in /opt/trinity/share/doc/kde/HTML. This means
roughly one-half of the help files are missing from the khelpcenter
browser. This is currently being fixed in the GIT tree and the next set
of packages will have all help documentation in the chosen standard
location of /opt/trinity/share/doc/tde/HTML. This also insures a future
/usr install will not conflict with any KDE help files. As a workaround
in the mean time, after installing 3.5.13-sru:

    cd /opt/trinity/share/doc/kde/HTML/en
    for i in ../../../HTML/en/*/; do ln -s $i; done

Note:Substitute your language for en

Package tde-tdesvn for x86_64 had been built with libpath
/opt/trinity/lib64 and /opt/trinity/lib64/trinity , but there was no any
records in libpath about them. Then, starting kdesvn you get error
libkdesvnpart.la not found in paths. As a workaround you may
copy/symlink libraries from /opt/trinity/lib64 and
/opt/trinity/lib64/trinity into /opt/trinity/lib and
/opt/trinity/lib/trinity respectively or try to create libpath record
and ldconfig after it.

> Issues for 14.0.0

None known

Contributors
------------

At present, the Trinity project for Arch Linux is just beginning.
Interest in the project and the list of contributors is growing. Anyone
wanting to help can simply join in. Please email Calvin Morrison.

> Archlinux

-   Calvin Morrison: Trinity and Arch a/k/a "mutantturkey", PKGBUILD
    development and collaboration.
-   Kaiting Chen: Arch Linux - server space for testing Trinity binaries
    in the past.
-   Albert Vaca: kdemod3 updated based on Trinity Stable codebase.
-   David C. Rankin: 14.0.0 (3.5.13-sru) Development and Packaging

> Developers

-   Timothy Pearson: Project administrator, primary developer, build
    farm administrator, Debian/Ubuntu packaging maintainer.
-   Darrell Anderson: 3.5.13 -> 14.0.0 Lead coordinator for development
    and rebranding. Build system preprocessor improvements.
-   Slávek Banko: 3.5.13-sru developer, GIT maintainer, R14 backport
    selection and integration.
-   Serghei Amelian: General functionality enhancements, CMake build
    system developer/maintainer.
-   "Woodsman": Vanilla build testing, Slackware packaging maintainer.
-   Francois Andriot: Developer, Redhat/Fedora packaging maintainer.
-   David Rankin: 3.5.13-sru and R14 development, upstream library
    change implementation, graphics, Arch Packaging.

> Content Distribution

-   University of Idaho: Mirror 1 [United States]
-   Jens Dunzweiler: Mirror 2 [Germany]
-   Inga Muste: Kubuntu LiveCD mirror

> Web Team

-   Calvin Morrison: Website design.
-   Inga Muste: Website design.

See also
--------

The Trinity site has a number of good resources available. As with any
rapidly developing project, the documentation is somewhat sparse, but it
does provide a good basic road-map to follow here. The mailing list has
approximately the same volume as the arch-user list, so it will not
overwhelm your inbox. If you want to help with this project, it is
strongly recommended that you also join the trinity-devel mailing list.
All of the following links are available from the Trinity project site.
A quick list of helpful links to the project follows:

-   Main Project Site: http://trinitydesktop.org
-   TDE GIT Repository: http://git.trinitydesktop.org/cgit/
-   TDE GIT SCM Manager: http://scm.trinitydesktop.org/scm/
-   Bug Reporting: http://bugs.trinitydesktop.org
-   Mailing Lists: http://trinitydesktop.org/mailinglist.php
-   Developers Web:
    http://trinitydesktop.org/wiki/bin/view/Developers/WebHome
-   Trinity Qt4 Conversion:
    http://trinitydesktop.org/wiki/bin/view/Developers/TrinityTQtforQt4Conversion
-   How To Build:
    http://trinitydesktop.org/wiki/bin/view/Developers/HowToBuild

Retrieved from
"https://wiki.archlinux.org/index.php?title=Trinity&oldid=228098"

Category:

-   Desktop environments
