Wine
====

Related articles

-   Steam
-   CrossOver

Wine is a compatibility layer capable of running Microsoft Windows
applications on Unix-like operating systems. Programs running in Wine
act as native programs would, without the performance/memory penalties
of an emulator. See the official project home and wiki pages for longer
introduction.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 WINEPREFIX
    -   2.2 WINEARCH
    -   2.3 Graphics drivers
    -   2.4 Sound
        -   2.4.1 MIDI support
    -   2.5 Other libraries
    -   2.6 Fonts
    -   2.7 Desktop launcher menus
        -   2.7.1 Creating menu entries for Wine utilities
        -   2.7.2 Removing menu entries
        -   2.7.3 KDE 4 menu fix
-   3 Running Windows applications
-   4 Tips and tricks
    -   4.1 exe-thumbnailer
    -   4.2 CSMT Patched Wine for Significantly Better Performance
        -   4.2.1 Further Information
    -   4.3 Changing the language
    -   4.4 Installing Microsoft Office 2010
    -   4.5 Proper mounting of optical media images
    -   4.6 Burning optical media
    -   4.7 OpenGL modes
    -   4.8 Using Wine as an interpreter for Win16/Win32 binaries
    -   4.9 Wineconsole
    -   4.10 Winetricks
    -   4.11 Installing .NET framework 4.0
-   5 Third-party interfaces
    -   5.1 CrossOver
    -   5.2 PlayOnLinux/PlayOnMac
    -   5.3 PyWinery
    -   5.4 Q4wine
-   6 See also

Installation
------------

Warning:If you can access a file or resource with your user account,
programs running in Wine can too. Wine prefixes are not sandboxes.
Consider using virtualization if security is important.

Wine can be installed with the package wine, available in the official
repositories. If you are running a 64-bit system, you will need to
enable the Multilib repository first.

You may also want to install wine_gecko and wine-mono for applications
that need support for Internet Explorer and .NET, respectively. These
packages are not strictly required as Wine will download the relevant
files as needed. However, having the files downloaded in advance allows
you to work off-line and makes it so Wine does not download the files
for each WINEPREFIX needing them.

Architectural differences

Wine by default is 32-bit, as is the i686 Arch package. As such, it is
unable to execute any 64-bit Windows applications.

The x86_64 Arch package, however, is built with --enable-win64. This
activates the Wine version of WoW64.

-   In Windows, this complicated subsystem allows the user to use 32-bit
    and 64-bit Windows programs concurrently and even in the same
    directory.
-   In Wine, the user will have to make separate directories/prefixes.
    See Wine64 for specific information on this.

If you run into problems with winetricks or programs with a 64-bit
environment, try creating a new 32-bit WINEPREFIX. See below: #Using
WINEARCH. Using the x86_64 Wine package with WINEARCH=win32 should have
the same behaviour as using the i686 Wine package.

Configuration
-------------

Configuring Wine is typically accomplished using:

-   winecfg is a GUI configuration tool for Wine. You can run it from a
    console window with: $ winecfg, or
    $ WINEPREFIX=~/.some_prefix winecfg.
-   control.exe is Wine's implementation of Windows' Control Panel which
    can be accessed with: $ wine control
-   regedit is Wine's registry editing tool. If winecfg and the Control
    Panel were not enough, see WineHQ's article on Useful Registry Keys

> WINEPREFIX

By default, Wine stores its configuration files and installed Windows
programs in ~/.wine. This directory is commonly called a "Wine prefix"
or "Wine bottle" It is created/updated automatically whenever you run a
Windows program or one of Wine's bundled programs such as winecfg. The
prefix directory also contains a tree which your Windows programs will
see as C: (the C-drive).

You can override the location Wine uses for a prefix with the WINEPREFIX
environment variable. This is useful if you want to use separate
configurations for different Windows programs. The first time a program
is run with a new Wine prefix, Wine will automatically create a
directory with a bare C-drive and registry.

For example, if you run one program with
$ env WINEPREFIX=~/.win-a wine program-a.exe, and another with
$ env WINEPREFIX=~/.win-b wine program-b.exe, the two programs will each
have a separate C-drive and separate registries.

Note:Wine prefixes are not sandboxes! Programs running under Wine can
still access the rest of the system! (for example, Z: is mapped to /,
regardless of the Wine prefix.)

To create a default prefix without running a Windows program or other
GUI tool you can use:

    $ env WINEPREFIX=~/.customprefix wineboot -u

> WINEARCH

If you have a 64-bit system, Wine will start an 64-bit environment by
default. You can change this behavior using the WINEARCH environment
variable. Rename your ~/.wine directory and create a new wine
environment by running $ WINEARCH=win32 winecfg. This will get you a
32-bit wine environment. Not setting WINEARCH will get you a 64-bit one.

You can combine this with WINEPREFIX to make a separate win32 and win64
environment:

    $ WINEARCH=win32 WINEPREFIX=~/win32 winecfg 
    $ WINEPREFIX=~/win64 winecfg

Note:During prefix creation, the 64-bit version of wine treats all
folders as 64-bit prefixes and will not create a 32-bit in any existing
folder. To create a 32-bit prefix you have to let wine create the folder
specified in WINEPREFIX.

You can also use WINEARCH in combination with other Wine programs, such
as winetricks (using Steam as an example):

    env WINEARCH=win32 WINEPREFIX=~/.local/share/wineprefixes/steam winetricks steam

Tip:You can make variables like WINEPREFIX or WINEARCH persistent by
using ~/.bashrc.

> Graphics drivers

For most games, Wine requires high performance accelerated graphics
drivers. This likely means using proprietary NVIDIA or AMD Catalyst
drivers, although the open source ATI driver is increasingly become
proficient for use with Wine. Intel drivers should mostly work as well
as they are going to out of the box.

See Gaming On Wine: The Good & Bad Graphics Drivers for more details.

A good sign that your drivers are inadequate or not properly configured
is when Wine reports the following in your terminal window:

    Direct rendering is disabled, most likely your OpenGL drivers have not been installed correctly

For x86-64 systems, additional multilib packages are required. Please
install the one that is listed in the Multilib Package column in the
table in Xorg#Driver installation.

Note:You might need to restart X after having installed the correct
library.

> Sound

By default sound issues may arise when running Wine applications. Ensure
only one sound device is selected in winecfg. Currently, the Alsa driver
is the most supported.

If you want to use Alsa driver in Wine, and are using x86_64, you'll
need to install the lib32-alsa-lib. If you are also using PulseAudio,
you will need to install lib32-libpulse.

If you want to use OSS driver in Wine, you will need to install the
lib32-alsa-oss package. The OSS driver in the kernel will not suffice.

If winecfg still fails to detect the audio driver (Selected driver:
(none)), configure it via the registry.

Games that use advanced sound systems may require installations of
lib32-openal.

MIDI support

MIDI was a quite popular system for video games music in the 90. If you
are trying out old games, it is not uncommon that the music will not
play out of the box. Wine has excellent MIDI support. However you first
need to make it work on your host system. See the wiki page for more
details. Last but not least you need to make sure Wine will use the
correct MIDI output. See the Wine Wiki for a detailed setup.

> Other libraries

-   Some applications (e.g. Office 2003/2007) require the MSXML library
    to parse HTML or XML, in such cases you need to install
    lib32-libxml2.

-   Some applications that play music may require lib32-mpg123.

-   Some applications that use native image manipulation libraries may
    require lib32-giflib and lib32-libpng.

-   Some applications that require encryption support may require
    lib32-gnutls.

> Fonts

If Wine applications are not showing easily readable fonts, you may not
have Microsoft's Truetype fonts installed. See MS Fonts. If this does
not help, try running winetricks allfonts.

After running such programs, kill all wine servers and run winecfg.
Fonts should be legible now.

If the fonts look somehow smeared, import the following text file into
the Wine registry with regedit:

    [HKEY_CURRENT_USER\Software\Wine\X11 Driver]
    "ClientSideWithRender"="N"

> Desktop launcher menus

When installing Windows programs with Wine, should result in the
appropriate menu/desktop icons being created. For example, if the
installation program (e.g. setup.exe) would normally add an icon to your
Desktop or "Start Menu" on Windows, then Wine should create
corresponding freedesktop.org style .desktop files for launching your
programs with Wine.

Tip:If menu items were not created while installing software or have
been lost, winemenubuilder may be of some use.

Creating menu entries for Wine utilities

By default, installation of Wine does not create desktop menus/icons for
the software which comes with Wine (e.g. for winecfg, winebrowser, etc).
These instructions will add entries for these applications.

First, install a Windows program using Wine to create the base menu.
After the base menu is created, you can create the following files in
~/.local/share/applications/wine/:

    wine-browsedrive.desktop

    [Desktop Entry]
    Name=Browse C: Drive
    Comment=Browse your virtual C: drive
    Exec=wine winebrowser c:
    Terminal=false
    Type=Application
    Icon=folder-wine
    Categories=Wine;

    wine-uninstaller.desktop

    [Desktop Entry]
    Name=Uninstall Wine Software
    Comment=Uninstall Windows applications for Wine
    Exec=wine uninstaller
    Terminal=false
    Type=Application
    Icon=wine-uninstaller
    Categories=Wine;

    wine-winecfg.desktop

    [Desktop Entry]
    Name=Configure Wine
    Comment=Change application-specific and general Wine options
    Exec=winecfg
    Terminal=false
    Icon=wine-winecfg
    Type=Application
    Categories=Wine;

And create the following file in ~/.config/menus/applications-merged/:

    wine.menu

    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
    "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
    <Menu>
      <Name>Applications</Name>
      <Menu>
        <Name>wine-wine</Name>
        <Directory>wine-wine.directory</Directory>
        <Include>
          <Category>Wine</Category>
        </Include>
      </Menu>
    </Menu>

If these settings produce a ugly/non-existent icon, it means that there
are no icons for these launchers in the icon set that you have enabled.
You should replace the icon settings with the explicit location of the
icon that you want. Clicking the icon in the launcher's properties menu
will have the same effect. A great icon set that supports these
shortcuts is GNOME-colors.

Removing menu entries

Menu entries created by Wine are located in
~/.local/share/applications/wine/Programs/. Remove the program's
.desktop entry to remove the application from the menu.

KDE 4 menu fix

The Wine menu items may appear in "Lost & Found" instead of the Wine
menu in KDE 4. This is because kde-applications.menu is missing the
MergeDir option.

Edit /etc/xdg/menus/kde-applications.menu

At the end of the file add <MergeDir>applications-merged</MergeDir>
after <DefaultMergeDirs/>, it should look like this:

    <Menu>
            <Include>
                    <And>
                            <Category>KDE</Category>
                            <Category>Core</Category>
                    </And>
            </Include>
            <DefaultMergeDirs/>
            <MergeDir>applications-merged</MergeDir>
            <MergeFile>applications-kmenuedit.menu</MergeFile>
    </Menu>

Alternatively you can create a symlink to a folder that KDE does see:

    $ ln -s ~/.config/menus/applications-merged ~/.config/menus/kde-applications-merged

This has the added bonus that an update to KDE won't change it, but is
per user instead of system wide.

Running Windows applications
----------------------------

Warning:Do not run or install Wine applications as root! See Running
Wine as root for the official statement.

To run a windows application:

    $ wine <path to exe>

To install using an MSI installer, use the included msiexec utility:

    $ msiexec installername.msi

Tips and tricks
---------------

Tip:In addition to the links provided in the beginning of the article
the following may be of interest:

-   The Wine Application Database (AppDB) - Information about running
    specific Windows applications (Known issues, ratings, guides, etc
    tailored to specific applications)
-   The WineHQ Forums - A great place to ask questions after you have
    looked through the FAQ and AppDB

> exe-thumbnailer

This is a small piece of UI code meant to be installed with (or even
before) Wine. It provides thumbnails for executable files that show the
embedded icons when available, and also gives the user a hint that Wine
will be used to open it. Details can be found at wine wiki.
gnome-exe-thumbnailer is available in AUR.

  

> CSMT Patched Wine for Significantly Better Performance

Currently wine developers experiment with stream/worker thread
optimizations for Wine. You may experience an enormous performance
improvement by using this experimental patched Wine versions. Many games
may run as fast as on Windows or even faster. This Wine patch is is
known as CSMT patch and works with Nvidia and AMD graphics cards.

Note:This is still experimental code, therefore, it may not work as
expected. Please, report your experiences to the developers for helping
with development of those patches.

The easy way is to install playonlinux. Then install your game and
activate the Wine version 1.7.4-CSMT from the Tools/Manage Wine Versions
menu in PlayOnLinux. For now it is recommended to use the patched Wine
version 1.7.4-CSMT.

Open your game's configuration settings and copy the following settings
to the Miscellaneous/Command to exec before running the program section
of your game configuration settings:

    export WINEDEBUG=-all
    export LD_PRELOAD="libpthread.so.0 libGL.so.1"
    export __GL_THREADED_OPTIMIZATIONS=0
    export __GL_SYNC_TO_VBLANK=1
    export __GL_YIELD="NOTHING"
    export CSMT=enabled

Make sure you have disabled StrictDrawOrdering from Tools/General.

If you want to compile it yourself from Github or you use the AUR
package instead.

Further Information

Phoronix Forum discussion with the CSMT developer Stefan Dösinger

FOSDEM2014 CSMT presentation of CSMT with benchmarks

Here you find some game videos running with CSMT enabled

> Changing the language

Some programs may not offer a language selection, they will guess the
desired language upon the sytem locales. Wine will transfer the current
environment (including the locales) to the application, so it should
work out of the box. If you want to force a program to run in a specific
locale (which is fully generated on your system), you can call Wine with
the following setting:

    LC_ALL=xx_XX.encoding wine /my/program

For instance

    LC_ALL=it_IT.UTF-8 wine /my/program

> Installing Microsoft Office 2010

Note:Microsoft Office 2013 does not run at all.

Microsoft Office 2010 works without any problems (tested with Microsoft
Office Home and Student 2010, Wine 1.5.27 and 1.7.5). Activation over
Internet also works.

Start by installing wine-mono, wine_gecko, samba, and lib32-libxml2.

Proceed with launching the installer:

    $ export WINEPREFIX=.wine # any path to a writable folder on your home directory will do
    $ export WINEARCH="win32"
    $ wine /path/to/office_cd/setup.exe

You could also put the above exports into your .bashrc.

Once installation completes, open Word or Excel to activate over the
Internet. Once activated, close the application. Then run winecfg, and
set riched20 (under libraries) to (native,builtin). This will enable
Powerpoint to work.

For additional info, see the WineHQ article.

Note:If the activation over internet doesn't work and you want to
activate by phone, be sure riched20 is set to (native,builtin) in order
to see the drop-down list of countries.

Note:playonlinux provides custom installer scripts that make the
installation of Office 2003, 2007 and 2010 an ease. You just have to
provide the setup.exe or ISO and the installer will guide you seamlessly
through the installation procedure. You do not have to deal with the
underlying Wine at all.

> Proper mounting of optical media images

Some applications will check for the optical media to be in drive. They
may check for data only, in which case it might be enough to configure
the corresponding path as being a CD-ROM drive in winecfg. However,
other applications will look for a media name and/or a serial number, in
which case the image has to be mounted with these special properties.

Some virtual drive tools do not handle these metadata, like fuse-based
virtual drives (Acetoneiso for instance). CDEmu will handle it
correctly.

> Burning optical media

To burn CDs or DVDs, you will need to load the sg kernel module.

> OpenGL modes

Many games have an OpenGL mode which may perform better than their
default DirectX mode. While the steps to enable OpenGL rendering is
application specific, many games accept the -opengl parameter.

    $ wine /path/to/3d_game.exe -opengl

You should of course refer to your application's documentation and
Wine's AppDB for such application specific information.

> Using Wine as an interpreter for Win16/Win32 binaries

It is also possible to tell the kernel to use wine as an interpreter for
all Win16/Win32 binaries:

    echo ':DOSWin:M::MZ::/usr/bin/wine:' > /proc/sys/fs/binfmt_misc/register

To make the setting permanent, create a /etc/binfmt.d/wine.conf file
with the following content:

    # Start WINE on Windows executables
    :DOSWin:M::MZ::/usr/bin/wine:

systemd automatically mounts the /proc/sys/fs/binfmt_misc filesystem
using proc-sys-fs-binfmt_misc.mount (and automount) and runs the
systemd-binfmt.service to load your settings.

Try it out by running a Windows program:

    chmod +x exefile.exe
    ./exefile.exe

If all went well, exefile.exe should run.

> Wineconsole

Often you may need to run .exes to patch game files, for example a
widescreen mod for an old game, and running the .exe normally through
wine might yield nothing happening. In this case, you can open a
terminal and run the following command:

    $ wineconsole cmd

Then navigate to the directory and run the .exe file from there.

> Winetricks

Winetricks is a script to allow one to install base requirements needed
to run Windows programs. Installable components include DirectX 9.x,
MSXML (required by Microsoft Office 2007 and Internet Explorer), Visual
Runtime libraries and many more.

You can install winetricks via pacman or use the winetricks-svn package
available in the AUR. Then run it with:

    $ winetricks

> Installing .NET framework 4.0

First create a new 32bit wine prefix if you are on a 64bit system.

    $ WINEARCH=win32 WINEPREFIX=~/win32 winecfg

Then install the following packages using winetricks

    $ WINEARCH=win32 WINEPREFIX=~/win32 winetricks -q msxml3 dotnet40 corefonts 

  

Third-party interfaces
----------------------

These have their own sites, and are not supported in the official Wine
forums/bugzilla.

> CrossOver

CrossOver Has its own wiki page.

> PlayOnLinux/PlayOnMac

PlayOnLinux is a graphical Windows and DOS program manager. It contains
scripts to assist the configuration and running of programs, it can
manage multiple Wine versions and even use a specific version for each
executable (eg. because of regressions). If you need to know which Wine
version works best for a certain game, try the Wine Application
Database. You can find the playonlinux package in community.

> PyWinery

PyWinery is a graphical and simple wine-prefix manager which allows you
to launch apps and manage configuration of separate prefixes, also have
a button to open winetricks in the same prefix, to open prefix dir,
winecfg, application uninstaller and wineDOS. You can install PyWinery
from AUR. It is especially useful for having differents settings like
DirectX games, office, programming, etc, and choose which prefix to use
before you open an application or file.

It's recommended using winetricks by default to open .exe files, so you
can choose between any wine configuration you have.

> Q4wine

Q4Wine is a graphical wine-prefix manager which allows you to manage
configuration of prefixes. Notably it allows exporting QT themes into
the wine configuration so that they can integrate nicely. You can find
the q4wine package in multilib.

See also
--------

-   Official Wine website
-   Wine application database
-   Advanced configuring your gfx card and OpenGL settings on wine;
    Speed up wine
-   FileInfo - Find Win32 PE/COFF headers in EXE/DLL/OCX files under
    linux/unix environment.
-   Gentoo's Wine Wiki Page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wine&oldid=301985"

Category:

-   Wine

-   This page was last modified on 25 February 2014, at 07:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
