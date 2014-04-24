Steam
=====

Related articles

-   Wine
-   Steam/Game-specific troubleshooting

From Wikipedia:

Steam is a digital distribution, digital rights management, multiplayer
and communications platform developed by Valve Corporation. It is used
to distribute games and related media online, from small independent
developers to larger software houses.

Steam is best known as the platform needed to play Source Engine games
(e.g. Half-Life 2, Counter-Strike). Today it offers many games from many
other developers.

Contents
--------

-   1 Native Steam on Linux
    -   1.1 Troubleshooting
        -   1.1.1 The close button only minimizes the window
        -   1.1.2 Flash not working on 64-bit systems
        -   1.1.3 Text is corrupt or missing
        -   1.1.4 SetLocale('en_US.UTF-8') fails at game startup
        -   1.1.5 The game crashes immediately after start
        -   1.1.6 OpenGL not using direct rendering
        -   1.1.7 libGL error when running certain games
    -   1.2 Launching games with custom commands, such as
        Bumblebee/Primus
        -   1.2.1 Killing standalone compositors when launching games
    -   1.3 Using native runtime
    -   1.4 Skins for Steam
        -   1.4.1 Steam skin manager
-   2 Steam on Wine
    -   2.1 Installation
    -   2.2 Starting Steam
    -   2.3 Tips
        -   2.3.1 Performance
        -   2.3.2 Source engine launch options
        -   2.3.3 Using a pre-existing Steam installation
        -   2.3.4 Steam links in Firefox, Chrome, etc
        -   2.3.5 No text rendered problem
        -   2.3.6 Proxy settings
-   3 See also

Native Steam on Linux
---------------------

> Note:

-   Arch Linux is not officially supported.
-   Because the Steam client is a 32-bit application, you will need to
    enable the multilib repository if you have a 64-bit system. It may
    also make sense to install multilib-devel to provide some important
    multilib libraries.

Steam can be installed with the package steam, available in the official
repositories. If you have a 64-bit system, enable the multilib
repository first.

Steam is not supported on this distribution. As such some fixes are
needed on the users part to get things functioning properly:

-   Steam makes heavy usage of the Arial font. A decent Arial font to
    use is ttf-liberation or the fonts provided by Steam. Asian
    languages require wqy-zenhei to display properly.

-   If you have a 64-bit system, you will need to install the 32-bit
    version of your graphics driver (the package in the Multilib Package
    column) to run 32-bit games.

-   If you have a 64-bit system, you will need to install
    lib32-alsa-plugins to enable sound in 32-bit games.

-   Several games have dependencies which may be missing from your
    system. If a game fails to launch (often without error messages)
    then make sure all of the libraries listed in Steam/Game-specific
    troubleshooting are installed.

> Troubleshooting

Note:In addition to being documented here, any bug/fix/error should be,
if not already, reported on Valve's bug tracker on their GitHub page.

The close button only minimizes the window

Valve GitHub issue 1025

To close the Steam window (and remove it from the taskbar) when you
press x, but keep Steam running in the tray, set the environment
variable STEAM_FRAME_FORCE_CLOSE to 1. You can do this by launching
Steam using the following command.

    $ STEAM_FRAME_FORCE_CLOSE=1 steam

If you start steam with the .desktop file, you need to replace the Exec
with following line:

     Exec=sh -c 'STEAM_FRAME_FORCE_CLOSE=1 steam' %U

Flash not working on 64-bit systems

Steam Support article

First ensure lib32-flashplugin is installed. It should be working at
this point, if not create a local Steam Flash plugin folder:

    $ mkdir ~/.steam/bin32/plugins/

and set a symbolic link to the global lib32 flash plugin file in your
upper new folder

    $ ln -s /usr/lib32/mozilla/plugins/libflashplayer.so ~/.steam/bin32/plugins/

Text is corrupt or missing

The Steam Support instructions for Windows seem to work on Linux also:
Simply download SteamFonts.zip and install them (copying to
/usr/share/fonts/ or ~/.fonts/ works at least).

SetLocale('en_US.UTF-8') fails at game startup

Uncomment en_US.UTF-8 UTF-8 in /etc/locale.gen and then run locale-gen
as root.

The game crashes immediately after start

If your game crashes immediately, try disabling: "Enable the Steam
Overlay while in-game" in game Properties.

OpenGL not using direct rendering

Steam Support article

You have probably not installed your 32-bit graphics driver correctly.
See Xorg#Driver installation for which packages to install.

You can check/test if it is installed correctly by installing
lib32-mesa-demos and running the following command:

    $ glxinfo32 | grep OpenGL.

libGL error when running certain games

If you receive an error like the following
Failed to load libGL: undefined symbol: xcb_send_fd, it could be due to
an outdated steam runtime library. Deleting
~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libxcb.so.1
will force Steam to load the library version installed by pacman.

> Launching games with custom commands, such as Bumblebee/Primus

Steam has fortunately added support for launching games using your own
custom command. To do so, navigate to the Library page, right click on
the selected game, click Properties, and Set Launch Options. Steam
replaces the tag %command% with the command it actually wishes to run.
For example, to launch Team Fortress 2 with primusrun and at resolution
1920x1080, you would enter:

    primusrun %command% -w 1920 -h 1080

If you are running the Linux-ck kernel, you may have some success in
reducing overall latencies and improving performance by launching the
game in SCHED_ISO (low latency, avoid choking CPU) via schedtool

    # schedtool -I -e %command% other arguments

Killing standalone compositors when launching games

Further to this, utilising the %command% switch, you can kill standalone
compositors (such as Xcompmgr or Compton) - which can cause lag and
tearing in some games on some systems - and relaunch them after the game
ends by adding the following to your game's launch options.

     killall compton && %command%; nohup compton &

Replace compton in the above command with whatever your compositor is.
You can also add -options to %command% or compton, of course.

Steam will latch on to any processes launched after %command% and your
Steam status will show as in game. So in this example, we run the
compositor through nohup so it is not attached to Steam (it will keep
running if you close Steam) and follow it with an ampersand so that the
line of commands ends, clearing your Steam status.

> Using native runtime

Steam, by default, ships with a copy of every library it uses, packaged
within itself, so that games can launch without issue. This can be a
resource hog, and the slightly out-of-date libraries they package may be
missing important features (Notably, the OpenAL version they ship lacks
HRTF and surround71 support). To use your own system libraries, you can
run Steam with:

    $ STEAM_RUNTIME=0 steam

However, if you're missing any libraries Steam makes use of, this will
fail to launch properly. An easy way to find the missing libraries is to
run the following commands:

    $ cd ~/.local/share/Steam/ubuntu12_32
    $ LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH}" ldd $(file *|sed '/ELF/!d;s/:.*//g')|grep 'not found'|sort|uniq

Note:The libraries will have to be 32-bit, which means you may have to
download some from the AUR if on x86_64, such as NetworkManager.

Once you've done this, run steam again with STEAM_RUNTIME=0 steam and
verify it's not loading anything outside of the handful of steam support
libraries:

    $ cat /proc/$(pidof steam)/maps|sed '/\.local/!d;s/.*  //g'|sort|uniq

> Skins for Steam

The Steam interface can be fully customized by copying its various
interface files in its skins directory and modifying them.

Steam skin manager

The process of applying a skin to Steam can be greatly simplified using
steam-skin-manager from the AUR. The package also comes with a hacked
version of the Steam launcher which allows the window manager to draw
its borders on the Steam window.

As a result, skins for Steam will come in two flavors, one with and one
without window buttons. The skin manager will prompt you whether you use
the hacked version or not, and will automatically apply the theme
corresponding to your GTK+ theme if it is found. You can of course still
apply another skin if you want.

The package ships with two themes for the default Ubuntu themes,
Ambiance and Radiance.

Steam on Wine
-------------

Install Wine as described in Wine.

Install the required Microsoft fonts: ttf-microsoft-tahoma and
ttf-ms-fonts from the AUR. You can also install these fonts through
Winetricks: winetricks corefonts.

Note:If you have access to Windows discs, you may want to install
ttf-ms-win8 or ttf-win7-fonts instead.

> Installation

Download and run the Steam installer from steampowered.com. It is a .msi
file so you have to start it with msiexec:

    $ msiexec /i SteamInstall.msi

> Starting Steam

On x86:

    $ wine ~/.wine/drive_c/Program\ Files/Steam/Steam.exe

On x86_64:

    $ wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe

> Note:

-   If text is not rendered (properly), append -no-dwrite to this
    command. See #No text rendered problem for more information.
-   If you are using an Nvidia card through Bumblebee, you should prefix
    this command with optirun.

You should consider making an alias to easily start Steam (and put it in
your shell's rc file), example:

    alias steam-wine='wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'

> Tips

Performance

Consider disabling wine debugging output by adding this to your shell rc
file:

    export WINEDEBUG=-all

or, just add it to your steam-wine alias to only disable it for Steam:

    alias steam-wine='WINEDEBUG=-all wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'

Additionally, Source games rely on a paged pool memory size
specification for audio, and WINE by default does not have this set. To
set it:

    $ wine reg add "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Memory Management\\" /v PagedPoolSize /t REG_DWORD /d 402653184 /f

Source engine launch options

Go to Properties > Set Launch Options, e.g.:

    -console -dxlevel 90 -width 1280 -height 1024

-   console

Activate the console in the application to change detailed applications
settings.

-   dxlevel

Set the application's DirectX level, e.g. 90 for DirectX Version 9.0. It
is recommended to use the video card's DirectX version to prevent
crashes. See the official Valve Software wiki
https://developer.valvesoftware.com/wiki/DirectX_Versions for details.

-   width and height

Set the screen resolution. In some cases the graphic settings are not
saved in the application and the applications always starts in the
default resolution.

Please refer to
https://developer.valvesoftware.com/wiki/Command_Line_Options for a
complete list of launch options.

Using a pre-existing Steam installation

If you have a shared drive with Windows, or already have a Steam
installation somewhere else, you can simply symlink the Steam directory
to ~/.wine/drive_c/Program Files/Steam/ . However, be sure to do all the
previous steps in this wiki. Confirm Steam launches and logs into your
account, then do this:

    $ cd ~/.wine/drive_c/Program\ Files/ 
    $ mv Steam/ Steam.backup/   (or you can just delete the directory)
    $ ln -s /mnt/windows_partition/Program\ Files/Steam/

> Note:

-   If you have trouble starting Steam after symlinking the entire Steam
    folder, try linking only the steamapps subdirectory in your existing
    wine steam folder instead.
-   If you still have trouble starting games, use
    # mount --bind /path/to/SteamApps ~/.local/share/Steam/SteamApps -ouser=your-user-name ,
    this is the only thing that worked with TF2 for one Arch user.

Steam links in Firefox, Chrome, etc

To make steam:// urls in your browser connect with Steam in Wine, there
are several things you can do. One involves making steam url-handler
keys in gconf, another involves making protocol files for KDE, others
involve tinkering with desktop files or the Local State file for
Chromium. These seem to only work in Firefox or under certain desktop
configurations. One way to do it that works more globally is using
mimeo, a tool made by Xyne (an Arch TU) which follows. For another
working and less invasive (but Firefox-only) way, see the first post
here .

-   Make /usr/bin/steam with your favorite editor and paste:

    #!/bin/sh
    #
    # Steam wrapper script
    #
    exec wine "c:\\program files\\steam\\steam.exe" "$@"

-   Make it executable:

    # chmod +x /usr/bin/steam

-   Install mimeo and xdg-utils-mimeo from AUR. You will need to replace
    the existing xdg-utils if installed. In XFCE, you will also need
    xorg-utils.

-   Create ~/.config/mimeo.conf with your favorite editor and paste:

    /usr/bin/steam %u
      ^steam://

-   Lastly, open /usr/bin/xdg-open in your favorite editor. Go to the
    detectDE() section and change it to look as follows:

    detectDE()
    {
        #if [ x"$KDE_FULL_SESSION" = x"true" ]; then DE=kde;
        #elif [ x"$GNOME_DESKTOP_SESSION_ID" != x"" ]; then DE=gnome;
        #elif $(dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager > /dev/null 2>&1) ; then DE=gnome;
        #elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep ' = \"xfce4\"$' >/dev/null 2>&1; then DE=xfce;
        #elif [ x"$DESKTOP_SESSION" == x"LXDE" ]; then DE=lxde;
        #else DE=""
        #fi
        DE=""
    }

-   Restart the browser and you should be good to go. In Chromium, you
    cannot enter a steam:// link in the url box like you can with
    Firefox. The forum link above has a steam://open/friends link to try
    if needed.

> Note:

-   If you have any problems with file associations after doing this,
    simply revert to regular xdg-utils and undo your changes to
    /usr/bin/xdg-open.
-   Those on other distributions that stumble upon this page, see the
    link above for firefox specific instructions. No easy way to get it
    working on Chromium on other distros exists.

No text rendered problem

If there is no text/font rendered when starting steam you should try to
start steam with the parameter -no-dwrite. Read more in the forum thread
about it.

    wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite

Note:Although this method does currently work, It is not persistent if
Steam relaunches automatically (i.e. update), or if you follow a URL
link.

-   This can be achieved by going through winecfg > Libraries and
    setting the "dwrite" override to "disable"

> Or

-   $ wine reg add 'HKCU\Software\Valve\Steam' /v DWriteEnable /t REG_DWORD /d 00000000

Proxy settings

Steam may use environment variables of the form [protocol]_proxy to
determine the proxy for HTTP/HTTPS.

    $ export http_proxy=http://your.proxy.here:port
    $ export https_proxy=$http_proxy

See also
--------

-   https://wiki.gentoo.org/wiki/Steam
-   Wine Application Database

Retrieved from
"https://wiki.archlinux.org/index.php?title=Steam&oldid=304609"

Categories:

-   Gaming
-   Wine

-   This page was last modified on 15 March 2014, at 12:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
