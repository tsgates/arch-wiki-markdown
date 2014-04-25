Trinity
=======

Summary help replacing me

Trinity is a fork of KDE3 that has been updated to work with current
software and libraries. The stable release is 3.5.13. The development
release is 14.0.0.

Trinity unofficial repositories

Binaries http://trinity.ceux.org/r14/

> Related

Creating Packages

Custom local repository

pacman Tips

The Trinity Desktop Environment (TDE) project is a feature rich desktop
environment for Unix-like operating systems with a primary goal of
retaining the overall KDE 3.5 computing style. The project was founded
by and is still led by Timothy Pearson. After 5 years of work, TDE is a
fast, stable and mature desktop for Linux.

TDE is the successor desktop to KDE 3.5. Continued development by the
Trinity Project has polished off many rough edges that were present in
the final release of KDE 3.5.10. Many new and useful features have been
added to keep the environment up-to-date. Prior to this project, the
last release of KDE 3.5 for Arch was TDE 3.5.12 packaged by Chakra as
kdemod3.

The current stable release of TDE (3.5.13-2) was released July 21st
2013. Tarballs are available for download. Current development is on
14.0.0 (R14). R14 entered soft-freeze on March 4, 2014, RC releases for
R14 are scheduled for release shortly. Development binaries are
available for Archlinux now. TDE 3.5.13(sru) and R14 build on Archlinux
with current libraries.

The initial build of R14 without hal is complete. This signifies the
first build of TDE R14 for Archlinux systemd environment without the
holdover hal requirement. While a few systemd integration issues remain,
TDE R14 development builds on Archlinux work beautifully. See the list
of completed packages and location of repositories below.

Note:Backwards compatibility with 3.5.X was dropped in R14 to remove HAL
dependency and to allow install of TDE/TQt without conflict with
KDE4/Qt4. The 3.5.13-sru branch provides backwards compatibility with
3.5.X

Contents
--------

-   1 The difference between 3.5.13 and R14
-   2 Installation
-   3 Upgrading 3.5.13→R14 (conflicts)
-   4 Start and configuration
    -   4.1 Enable tdm.service in systemd to start tdm at boot
    -   4.2 Configure to work with startx
-   5 Known issues
    -   5.1 Issues for 14.0.0
    -   5.2 Issues for 3.5.13-sru
-   6 Reporting Bugs
-   7 Build from source
    -   7.1 PKGBUILDs - current git code
    -   7.2 Build order
-   8 Development 14.0.0 status
    -   8.1 3rd Party Build Dependencies
    -   8.2 Complete packages (current)
    -   8.3 TDE GIT application in need of packaging/updating
-   9 Contributors
    -   9.1 Archlinux
    -   9.2 Developers
    -   9.3 Content Distribution
    -   9.4 Web Team
-   10 See also

The difference between 3.5.13 and R14
-------------------------------------

The versioning change between 3.5.13 and R14 signifies that backwards
compatibility with 3.5.X has been dropped eliminating dependency on HAL
and to allow TDE/TQt to install along side KDE4/Qt4 without conflict.
While backwards compatibility with HAL is dropped, all addons, themes
and desktop utilities continue to build and work with R14. R14 will may
be built with, or without, HAL but is intended to remove HAL completely.
3.5.13 continues true backwards compatibility with KDE 3.5.10 codebase
and provides an alternative for those willing to install hal. The 3.5 13
branch will be maintained for the forseeable future.

R14 will be a true TDE release with all branding, artwork, and graphics
changed and updated for this project rather than using holdover KDE3
stock images. The significant improvements and changes to the R14
codebase have been backported to 3.5.13-sru. All in all, the desktop
functions beautifully on current graphics libs, systemd, libusbx, udisk2
and other newly implemented hardware paradigms.

Installation
------------

Warning:package naming convention change. To be accurate in package
naming for TDE, package names were changed from pkg-14.0.0-1.arch.tar.xz
to pkg-R14preRC1-1.arch.tar.xz. If you installed initial packages, you
will need to 'downgrade' to the new packages.

Current Release: R14preRC1-3 (built 3/5/14)

Note:Calvin Morrison has graciously provided server space for R14 binary
packages for testing. These packages are pre-RC1 packages, but should
work well. There are no binary packages for 3.5.13 at present. 3.5.13
packages will be built after R14 is released.

To add the repository, edit /etc/pacman.conf [as root] changing 'x86_64'
to 'i686' as necessary and add the following lines at the end:

     [trinity]
     SigLevel = Never
     Server = http://trinity.ceux.org/r14/x86_64

Note:‘SigLevel = Never’ - is required because the packages are not yet
built and signed with a signing key.

In order to use the trinity repository, it is recommended that you first
perform a system upgraded to update all repository indexes. This will
prevent a partial upgrade that could occur if 'pacman -Sy' is run and
all repository indexes are updated without updated system packages being
installed -- Pacman#Partial_upgrades_are_unsupported.

     pacman -Syu

Meta package installation for tde is provided under the name tde-base,
tde-core, tde-dev, tde-extra, tde-multimedia or tde-complete. For
descriptions, see below. Choose the desired metapackage. Then to install
simply invoke 'pacman -S meta-name'. For example:

     pacman -S tde-complete

-   tde-core is recommended for a minimum test install (tde-base is
    absolute bare-bones)

The meta-package arrangement has been fully implemented and roughly
corresponds to:

     tde-base       : minimum possible install (up to tdebase)
     tde-core       : 'tde-base' + all core TDE application (without koffice or many external applications)
     tde-dev        : 'tde-core' + development bindings and packages
     tde-extra      : 'tde-core' + common external applications + koffice
     tde-multimedia : 'tde-core' + all AV and CD/DVD apps (amarok, kaffeine, etc.)
     tde-complete   : 'tde-extra' + all building packages

You can view the contents of each meta-package easily by using ‘pacman
-Sg group’. Example:

     pacman -Sg tde-extra

Note:On install, you should expect conflicts with tde-sip and
tde-sip4-tqt. The TDE packages tde-sip and tde-sip4-tqt are direct
replacements for the sip and python2-sip packages. They simply contain
additional extensions for TDE. The TDE package are being re-written to
eliminate this conflict. If you encounter these conflicts, simply remove
sip and python2-sip and install with your chosen meta-package:

    pacman -Rdd sip python2-sip
    pacman -S tde-complete

Warning:If attempting to install 3.5.13 along side KDE4 you will
experience conflicts with libart-lgpl and kdebase-workspace. The
libart-lgpl packages are equivalent. The kdebase-workspace conflict is
with /etc/ksysguarddrc. Both are in the process of being eliminated.

Upgrading 3.5.13→R14 (conflicts)
--------------------------------

The 3.5.13 packages were last built over one year ago. In the time since
3.5.13, there have been a number of changes to the individual packages
that make up TDE. This includes moving and removing duplicate icons and
files and rearranging packages that were in ‘questionable’ shape at the
time kde 3.5.10 was released. This cleanup has resulted in conflicting
icons between R14 and old 3.5.13 packages that makes a direct update
difficult. These conflicts primarly show up in tdelibs and tdepim and
tdeiolocate. The best solution is simply to remove 3.5.13 before
installing R14.

However, if you would like to do a direct upgrade, it will take a bit of
manual intervention, but it is possible to manually upgrade R14 from
3.5.13 by installing tdepim and tdeiolocate last. For example, if
installing the metapackage tde-core (with all its files), get the list
of files to be install and remove the files causing conflict:

    $ ( IFS=$'\n'; for i in $(pacman -Sg tde-core); do echo -n "${i##*\ } "; done; echo ""; )

Remove tde-tdepim and/or tde-tdeiolocate from the list of files created
above and then use:

    # pacman -U long-list-of-tde-packages
    # pacman -U tde-tdepim tde-tdeiolocate

Adjust as necessary to eliminate conflicting files.

Start and configuration
-----------------------

After a successful install of TDE, the tdm desktop manager can be used
to start TDE (and all other desktops) in the same manner kdm is used to
start KDE4. The init script for the display manager has been renamed
from kdm to tdm to avoid conflicts. TDE includes a tdm.service file
allowing systemd to start tdm at boot. TDE can also be started from the
command line by including the path to starttde in your ~/.xinitrc.
Either way launching tdm or TDE is straightforward.

> Enable tdm.service in systemd to start tdm at boot

If systemd is configured to boot the default multi-user.target
(default), all that is required to configure tdm to start at boot is to
enable the tdm.service file in systemd

     systemctl enable tdm

That's it. If you encounter any problem, the default.target may have
manually configured. See: Display manager#Loading the display manager
for resolution.

> Configure to work with startx

Trinity provides a normal starttde in /opt/trinity/bin (symlink provided
in 3.5.13). The easiest way to start Trinity is to simply add
/opt/trinity/starttde entry at the end of ~/.xinitrc. If you do not
presently have ~/.xinitrc, then simply copy it from /etc/skel or create
it with the following entry:

    ~/.xinitrc

    exec /opt/trinity/bin/starttde

Then from the command line, just type startx.

Known issues
------------

> Issues for 14.0.0

The following are issues specific to the R14 development release:

pure systemd code changes - Changes to TDE/tdm will be needed to fully
support user and session tracking in a pure systemd environment.
Currently, without consolekit, user access to system devices such as
sound, print driver generation and others is blocked. Sound and print
work-arounds in the interim are to add users to the audio and lp groups.
Additionally, tdeio sessions opened are not automatically closed, such
as sftp connections. TDE continues to work fine, just be aware of these
issues until the fix is complete.

kasablanca - connects to remote server, but file list is not displayed.

kftpgrabber - connects to remote server, but file list is not displayed.

kmymoney - sqlite3 backend disabled.

tdebase - login loops back to itself (fixed - Xsession ck- removal)
basket notepads - settings empty (fixed - staticlibs) twin-style-crystal
- unable to configure (fixed - staticlibs) tdenetworkmanager - crash on
startup (fixed - staticlibs) kaffeine - x-mplayer2.desktop conflicts
with tdelibs (fixed)

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

Reporting Bugs
--------------

All bugs with TDE code both R14 and 3.5.13-sru should be filed with the
Trinity Bug Tracker. The URL for direct bug entry is:

     http://bugs.pearsoncomputing.net/enter_bug.cgi?product=TDE

Both bug reports and feature requests are welcome. If you find a package
that you really like that is a KDE package that you would like to see
ported to TDE, then list it as a feature request. There are some really
good tools that allow an almost automatic conversion for Qt/KDE3 apps to
the TQt/TDE environment.

Build from source
-----------------

> PKGBUILDs - current git code

For a snapshot of PKGBUILD sources for building against the current GIT
tree, see R14 and 3.5.13-sru. Be sure to read the README-building.txt.

Note:The PKGBUILD files above are undergoing update. The 3.5.13-sru
files have NOT yet been updated. R14 files should be OK by 2/1. NOTE:
The PKBUILD src files build from tarballs created from the TDE git tree.
If you are building from source, you will need to clone the git tree and
then use the scripts provided to create tarballs to build from. After
R14 is released, the PKGBUILD files will be reworked to build from
published tarballs and final PKGBUILD source files will be moved to the
tdepackaging GIT tree after 14.0.0 is released.

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

> 3rd Party Build Dependencies

These are non-Arch provided dependency/optdepends packages needed to
build and run TDE with all features fully supported (down to reading MRI
and CT scan images)

     hal (AUR hal) **
     hal-info (AUR hal-info) **
     libkarma (AUR libkarma)
     mt-daapd (AUR mt-daapd)
     wv2 (AUR wv2)
     xmedcon
     ** no longer required in R14

> Complete packages (current)

The TDE codebase is in extremely good shape. The following packages were
built on both i686 and x86_64, including tdelibs (without hal). Current
repository size is 432M for i686 and 412M for x86_64.

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
     tde-gtk3-tqt-engine
     tde-gwenview
     tde-k3b
     tde-k9copy
     tde-kaffeine
     tde-kasablanca
     tde-katapult
     tde-kbarcode
     tde-kbfx
     tde-kbookreader
     tde-kchmviewer
     tde-kcmautostart
     tde-kcmldap
     tde-kcmldapcontroller
     tde-kcmldapmanager
     tde-kcpuload
     tde-kdbg
     tde-kdbusnotification
     tde-kdiff3
     tde-kdirstat
     tde-kftpgrabber
     tde-kgtk-qt3
     tde-kile
     tde-kima
     tde-kiosktool
     tde-kipi-plugins
     tde-kmplayer
     tde-kmyfirewall
     tde-kmymoney
     tde-knemo
     tde-knetload
     tde-knetstats
     tde-knights
     tde-knmap
     tde-knowit
     tde-knutclient
     tde-koffice
     tde-konversation
     tde-krecipes
     tde-krename
     tde-krusader
     tde-kscope
     tde-ksensors
     tde-ksplash-engine-moodin
     tde-kvkbd
     tde-kvpnc
     tde-kxmleditor
     tde-libart-lgpl
     tde-libcaldav
     tde-libcarddav
     tde-libkdcraw
     tde-libkexiv2
     tde-libkipi
     tde-libksquirrel
     tde-libtdeldap
     tde-mlt++ *
     tde-mlt *
     tde-potracegui
     tde-pytdeextensions
     tde-python-tqt
     tde-python-trinity
     tde-rosegarden
     tde-sip
     tde-sip4-tqt
     tde-smb4k
     tde-soundkonverter
     tde-tde-style-qtcurve
     tde-tdeaccessibility
     tde-tdeaddons
     tde-tdeadmin
     tde-tdeartwork
     tde-tdebase
     tde-tdebindings
     tde-tdeedu
     tde-tdegames
     tde-tdegraphics
     tde-tdeio-ftps
     tde-tdeio-locate
     tde-tdeio-umountwrapper
     tde-tdelibs
     tde-tdemultimedia
     tde-tdenetwork
     tde-tdenetworkmanager
     tde-tdepim
     tde-tdepowersave
     tde-tderadio
     tde-tdesdk
     tde-tdesvn
     tde-tdetoys
     tde-tdeutils
     tde-tdevelop
     tde-tdewebdev
     tde-tdmtheme
     tde-tellico
     tde-tork
     tde-tqca-tls
     tde-tqscintilla
     tde-tqt3
     tde-tqt3-docs
     tde-tqtinterface
     tde-twin-style-crystal
     tde-wlassistant
     tde-yakuake
     * i686 only

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
     keep
     kerry
     kio-apt
     kopete-otr
     kpicosim
     kpilot
     kstreamripper
     ksystemlog
     ktechlab
     ktorrent
     kvirc
     piklab
     qt4-tqt-theme-engine (requires qt4)
     smartcardauth
     tde-guidance
     tde-style-lipstik
     tde-systemsettings
     tdesudo

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
-   Albert Vaca: kdemod3 updated based on Trinity Stable codebase
    (3.5.12).
-   David C. Rankin: R14.0.0 & (3.5.13-sru) Development and Archlinux
    Packaging

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
"https://wiki.archlinux.org/index.php?title=Trinity&oldid=303372"

Category:

-   Desktop environments

-   This page was last modified on 6 March 2014, at 16:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
