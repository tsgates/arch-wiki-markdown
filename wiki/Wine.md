Wine
====

Summary

Wine is a compatibility layer capable of running Microsoft Windows
applications on Unix-like operating systems. Programs running in Wine
act as native programs would, without the performance/memory penalties
of an emulator.

Related

Steam

CrossOver

See the official project home and wiki pages for longer introduction.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Using WINEARCH                                               |
|     -   2.2 Graphics Drivers                                             |
|     -   2.3 Sound                                                        |
|     -   2.4 Other libraries                                              |
|     -   2.5 Fonts                                                        |
|     -   2.6 Desktop Launcher Menus                                       |
|         -   2.6.1 Creating Menu Entries                                  |
|         -   2.6.2 Remove Wine Launcher Menus in Gnome3                   |
|         -   2.6.3 KDE 4 Menu Fix[1]                                      |
|                                                                          |
| -   3 Running Windows Applications                                       |
| -   4 Tips and Tricks                                                    |
|     -   4.1 Installing Microsoft Office                                  |
|     -   4.2 OpenGL Modes                                                 |
|     -   4.3 Using Wine as an interpreter for Win16/Win32 binaries        |
|         -   4.3.1 Systemd                                                |
|         -   4.3.2 Initscripts                                            |
|         -   4.3.3 Test the Setup                                         |
|                                                                          |
|     -   4.4 Wineconsole                                                  |
|     -   4.5 Winetricks                                                   |
|                                                                          |
| -   5 Third-party interfaces                                             |
|     -   5.1 CrossOver                                                    |
|     -   5.2 PlayOnLinux/PlayOnMac                                        |
|     -   5.3 PyWinery                                                     |
|     -   5.4 Q4wine                                                       |
|                                                                          |
| -   6 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Warning: If you can access a file or resource with your user account,
programs running in Wine can too. Wine prefixes are not sandboxes.
Consider using virtualization if security is important.

Wine is constantly updated and available in the OfficialRepositories
repository for i686 and in multilib for x86_64.

You may also require wine_gecko, if your applications make use of
Internet Explorer or Mono for .NET applications: you can download the
installer (.msi) from the Wine Sourceforge project and save it in
/usr/share/wine/mono. Alternatively you can use the package wine-mono
from the AUR, which should build it from the sources.

Architectural differences

The default Wine is 32-bit, as is the i686 Arch package. As such, it is
unable to execute any 64-bit Windows applications (which are still
fairly rare at this point anyway).

The Wine package for x86_64, however, is currently built with
 --enable-win64. This activates the Wine version of WoW64.

-   In Windows, this complicated subsystem allows the user to use 32-bit
    and 64-bit Windows programs concurrently and even in the same
    directory.
-   In Wine, the user will have to make separate directories/prefixes.
    The support for this feature in Wine is currently experimental and
    users are recommended to use a win32 WINEPREFIX. See Wine64 for
    specific information on this.

To summarize, using the Arch 64-bit Wine package with WINEARCH=win32
should have the same behaviour as using the i686 Wine package.

Note: If you run into problems with winetricks or programs with a 64-bit
environment, try creating a new 32-bit WINEPREFIX. See below:
#Using_WINEARCH

Configuration
-------------

By default, Wine stores its configuration files and installed Windows
programs in ~/.wine. This directory is commonly called a "Wine prefix"
or "Wine bottle" It is created/updated automatically whenever you run a
Windows program or one of Wine's bundled programs such as winecfg. The
prefix directory also contains a tree which your Windows programs will
see as  C:\ (C-drive)

You can override the location Wine uses for a prefix with the WINEPREFIX
environment variable. This is useful if you want to use separate
configurations for different Windows programs.

For example, if you run one program with:
$ env WINEPREFIX=~/.win-a wine program-a.exe, and another with
$ env WINEPREFIX=~/.win-b wine program-b.exe, the two programs will each
have separate "C:\" and registries.

To create a default prefix without running a Windows program or other
GUI tool you can use:

    $ env WINEPREFIX=~/.customprefix wineboot -u

Configuring Wine is typically accomplished using:

-   winecfg is a GUI configuration tool for Wine. You can run it from a
    console window with: $ winecfg, or
    $ WINEPREFIX=~/.some_prefix winecfg.

-   control.exe is Wine's implementation of Windows' Control Panel which
    can be accessed with: $ wine control

-   regedit is Wine's registry editing tool. If winecfg and the Control
    Panel were not enough, see WineHQ's article on Useful Registry Keys

> Using WINEARCH

If you are using wine from [multilib], you will notice that winecfg will
get you a 64-bit wine environment by default. You can change this
behavior using the WINEARCH environment variable. Rename your ~/.wine
directory and create a new wine environment by running:
$ WINEARCH=win32 winecfg This will get you a 32-bit wine environment.
Not setting WINEARCH will get you a 64-bit one.

You can combine this with WINEPREFIX to make a separate win32 and win64
environment:

    $ WINEARCH=win32 WINEPREFIX=~/win32 winecfg 
    $ WINEPREFIX=~/win64 winecfg

Note:During prefix creation, the 64-bit version of wine treats all
folders as 64-bit prefixes and will not create a 32-bit in any existing
folder. To create a 32-bit prefix you have to let wine create the folder
specified in WINEPREFIX.

You can also use winetricks and WINEARCH in one command for installing
something from winetricks like this (using Steam as an example):

    env WINEARCH=win32 WINEPREFIX=~/.local/share/wineprefixes/steam winetricks steam

Tip: You can make variables like WINEPREFIX or WINEARCH constant by
using ~/.bashrc.

Note:You do not have create the steam subdirectory in the wineprefixes
directory, it will create for you. See the Bottles section below for
more information.

> Graphics Drivers

For most games, Wine requires high performance accelerated graphics
drivers. This likely means using proprietary binary drivers from Nvidia
or Amd/ATI. Intel drivers should mostly work as well as they are going
to out of the box.

A good sign that your drivers are inadequate or not properly configured
is when Wine reports the following in your terminal window:

    Direct rendering is disabled, most likely your OpenGL drivers have not been installed correctly

For x86-64 systems, additional 32-bit [multilib] or AUR packages are
required:

-   NVIDIA: # pacman -S lib32-nvidia-libgl For older cards search the
    AUR for lib32-nvidia-utils (e.g. -173xx).

-   NVIDIA (using nouveau-dri): # pacman -S lib32-nouveau-dri

-   Intel: # pacman -S lib32-intel-dri Run Wine with:
    LIBGL_DRIVERS_PATH=/usr/lib32/xorg/modules/dri

-   AMD/ATI: # pacman -S lib32-ati-dri For ATI's proprietary drivers:
    # pacman -S lib32-catalyst-utils. install lib32-catalyst-utils from
    the AUR

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

> Other libraries

Some applications (e.g. Office 2003) require ability to parse HTML or
XML (they use MSXML library), in such case you need to install
lib32-libxml2.

Applications that play music may require lib32-mpg123.

For application that use native image manipulation libraries
installation of lib32-giflib and lib32-libpng may be required.

For encryption support on x86_64 you need to install lib32-gnutls.

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

> Desktop Launcher Menus

By default, installation of Wine does not create desktop menus/icons for
the software which comes with Wine (e.g. for winecfg, winebrowser, etc).
However, installing Windows programs with Wine, in most cases, should
result in the appropriate menu/desktop icons being created. For example,
if the installation program (e.g. setup.exe) would normally add an icon
to your Desktop or "Start Menu" on Windows, then Wine should create
corresponding freedesktop.org style .desktop files for launching your
programs with Wine.

Tip:If menu items were not created while installing software or have
been lost, winemenubuilder may be of some use.

If you wish to add on to the menu to create an Ubuntu-like Wine
sub-menu, then follow these instructions:

Creating Menu Entries

First, install a Windows program using Wine to create the base menu.
After the base menu is created, you can start to add the menu entries.
In GNOME, right-click on the desktop and select "Create Launcher...".
The steps might be different for KDE/Xfce. Make three launchers using
these settings:

    Type: Application
    Name: Configuration
    Command: winecfg
    Comment: Configure the general settings for Wine

    Type: Application
    Name: Uninstall Programs
    Command: wine uninstaller
    Comment: Uninstall Windows programs under Wine properly

    Type: Application
    Name: Browse C:\
    Command: wine winebrowser c:\\
    Comment: Browse the files in the virtual Wine C:\ drive

Now that you have these three launchers on your desktop, it is time to
put them into the menu. But, first you should change the launchers to
dynamically change icons when a new icon set is installed. To do this,
open the launchers that you just made in your favorite text editor.
Change the following settings to these new values:

Configuration launcher:

    Icon[en_US]=wine-winecfg
    Icon=wine-winecfg

Uninstall Programs launcher:

    Icon[en_US]=wine-uninstaller
    Icon=wine-uninstaller

Browse C:\ launcher:

    Icon[en_US]=wine-winefile
    Icon=wine-winefile

If these settings produce a ugly/non-existent icon, it means that there
are no icons for these launchers in the icon set that you have enabled.
You should replace the icon settings with the explicit location of the
icon that you want. Clicking the icon in the launcher's properties menu
will have the same effect. A great icon set that supports these
shortcuts is GNOME-colors.

Now that you have the launchers fully configured, now it is time to put
them in the menu. Copy them into ~/.local/share/applications/wine/.

Wait a second, they are not in the menu yet! There is one last step.
Create the following text file:

    ~/.config/menus/applications-merged/wine-utilities.menu

     <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
     "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
     <Menu>
       <Name>Applications</Name>
       <Menu>
         <Name>wine-wine</Name>
         <Directory>wine-wine.directory</Directory>
         <Include>
     	<Filename>wine-Configuration.desktop</Filename>
         </Include>
         <Include>
     	<Filename>wine-Browse C:\.desktop</Filename>
         </Include>
         <Include>
     	<Filename>wine-Uninstall Programs.desktop</Filename>
         </Include>
       </Menu>
     </Menu>

Go check in the menu and there should be the minty fresh options waiting
to be used!

Remove Wine Launcher Menus in Gnome3

System wide launcher menus are located in /usr/share/applications/.
Remove the program's ".desktop" entry to remove the launcher system
wide.

If this does not solve the problem, it is likely the wine launchers are
located in ~/.local/share/applications/wine/Programs/. In the
directories corresponding to the program files are the ".desktop"
launcher files. Remove these files to remove the launchers. Remove the
entire program's directory to easily remove the launcher files.

KDE 4 Menu Fix[1]

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

    ln -s ~/.config/menus/applications-merged ~/.config/menus/kde-applications-merged

This has the added bonus that an update to KDE won't change it, but is
per user instead of system wide.

Running Windows Applications
----------------------------

Warning:Do not run or install Wine applications as root! See Running
Wine as root for the official statement.

To run a windows application:

    $ wine <path to exe>

To install using an MSI installer, use the included msiexec utility:

    $ msiexec installername.msi

Tips and Tricks
---------------

Tip:In addition to the links provided in the beginning of the article
the following may be of interest:

-   The Wine Application Database (AppDB) - Information about running
    specific Windows applications (Known issues, ratings, guides, etc
    tailored to specific applications)
-   The WineHQ Forums - A great place to ask questions after you have
    looked through the FAQ and AppDB

These tools will assist in the installation of typical Windows
components. In most cases they should be used as a last effort, as it
may severely alter your wine configuration.

> Installing Microsoft Office

UPDATE: 09-Apr, 2013: With Wine 1.5.27, none of the below "tweaks" are
necessary. Ensure winbind is installed (the samba package has it). Then

    $ export WINEPREFIX="<path to a writable folder on your home directory>"
    $ export WINEARCH="win32"
    $ wine /path/to/office_cd/setup.exe

You could also put the above exports into your bashrc. Once installation
completes, open Word or Excel to activate over the internet. Once done,
close the application. Then run winecfg, and set riched20 (under
libraries) to Native (Windows). This will enable Powerpoint to work.
(tested with Office Home/Student 2010 and wine 1.5.27. Activation over
internet also works)

A small tweak is needed to install the office suite. Follow these steps
to accomplish it:

    $ WINEARCH=win32 WINEPREFIX=/path/to/wineprefix winecfg
    # pacman -S winetricks
    $ winetricks msxml3 # For MS Office 2007
    $ winetricks msxml3 msxml6 # For MS Office 2010
    $ wine /path/to/office_cd/setup.exe

For additional info, see the WineHQ article.

> OpenGL Modes

Many games have an OpenGL mode which may perform better than their
default DirectX mode. While the steps to enable OpenGL rendering is
application specific, many games accept the -opengl parameter.

    $ wine /path/to/3d_game.exe -opengl

You should of course refer to your application's documentation and
Wine's AppDB for such application specific information.

> Using Wine as an interpreter for Win16/Win32 binaries

It is also possible to tell the kernel to use wine as an interpreter for
all Win16/Win32 binaries. The process for setting this up depends on
whether you boot using systemd or initscripts.

Systemd

Tell the kernel how to interpret Win16 and Win32 binaries:

    echo ':DOSWin:M::MZ::/usr/bin/wine:' > /proc/sys/fs/binfmt_misc/register

To make the setting permanent, create a configuration file in
/etc/tmpfiles.d with the following contents:

    /etc/tmpfiles.d/enable-doswin-exe.conf

    w /proc/sys/fs/binfmt_misc/register - - - - :DOSWin:M::MZ::/usr/bin/wine:

Note that, in contrast to initscripts, systemd will automatically mount
/proc/sys/fs/binfmt_misc on use by default. Thus adding the tmpfiles
rule should be sufficient for most users.

For more info on tmpfiles, see Systemd#Temporary_files.

Initscripts

First mount the binfmt_misc filesystem:

    # mount -t binfmt_misc none /proc/sys/fs/binfmt_misc

Or you can add this line to your /etc/fstab:

    none /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0

Then, tell the kernel how to interpret Win16 and Win32 binaries:

    echo ':DOSWin:M::MZ::/usr/bin/wine:' > /proc/sys/fs/binfmt_misc/register

You can add this line to /etc/rc.local to make this setting permanent.
In this case you may want to ignore stderr to avoid error messages when
changing runlevels:

    { echo ':DOSWin:M::MZ::/usr/bin/wine:' > /proc/sys/fs/binfmt_misc/register; } 2>/dev/null

Test the Setup

Now try to run a Windows program:

    chmod 755 exefile.exe
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

Third-party interfaces
----------------------

These have their own sites, and are not supported in the Wine forums.

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

External Resources
------------------

-   Official Wine Website
-   Wine Application Database
-   Advanced configuring your gfx card and OpenGL settings on wine;
    Speed up wine
-   FileInfo - Find Win32 PE/COFF headers in EXE/DLL/OCX files under
    linux/unix environment.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wine&oldid=256097"

Category:

-   Wine
