Steam
=====

> Summary

Steam is a content delivery system made by Valve Software. It is best
known as the platform needed to play Source Engine games (e.g. Half-Life
2, Counter-Strike). Today it offers many games from many other
developers.

> Related

Wine

Steam/Game-specific troubleshooting

See the Steam Wikipedia page and the page in the Wine Application
Database for more info.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Native Steam on Linux                                              |
|     -   1.1 Troubleshooting                                              |
|         -   1.1.1 GUI problems with KDE                                  |
|         -   1.1.2 The close button only minimizes the window             |
|         -   1.1.3 Flash not working on 64-bit systems                    |
|         -   1.1.4 Text is corrupt or missing                             |
|         -   1.1.5 Error on some games: S3TC support is missing           |
|         -   1.1.6 Black screen on (Valve?) games (but audio works)       |
|         -   1.1.7 SetLocale('en_US.UTF-8') fails at game startup         |
|                                                                          |
|     -   1.2 Tips                                                         |
|         -   1.2.1 Launching games with custom commands, such as          |
|             Bumblebee/Primus                                             |
|                                                                          |
|     -   1.3 Skins for Steam                                              |
|         -   1.3.1 Steam Skin Manager                                     |
|                                                                          |
| -   2 Steam on Wine                                                      |
|     -   2.1 Installation                                                 |
|     -   2.2 Starting Steam                                               |
|     -   2.3 Tips                                                         |
|         -   2.3.1 Performance                                            |
|         -   2.3.2 Application Launch Options                             |
|         -   2.3.3 Using a Pre-Existing Steam Install                     |
|         -   2.3.4 Running Steam in a second X Server                     |
|         -   2.3.5 Steam Links in Firefox, Chrome, Etc                    |
|         -   2.3.6 No text rendered problem                               |
|                                                                          |
| -   3 See Also                                                           |
+--------------------------------------------------------------------------+

Native Steam on Linux
---------------------

Note:Arch Linux is not officially supported.

Note:If you have a pure 64-bit installation, you will need to enable the
multilib repository in pacman. This is because the Steam client is a
32-bit application. It may also make sense to install multilib-devel to
provide some important multilib libraries. You also most likely need to
install the 32-bit version of your graphics driver to run Steam.

Install steam from the multilib repository.

Steam makes heavy usage of the Arial font. A decent Arial font to use is
ttf-liberation or the official Microsoft Arial fonts:
ttf-microsoft-arial or ttf-ms-fonts packages from the AUR. Asian
languages require wqy-zenhei to display properly.

Steam is not supported on this distribution. As such some fixes are
needed on the users part to get things functioning properly. Several
games have dependencies which may be missing from your system. If a game
fails to launch (often without error messages) then make sure all of the
libraries listed below that game are installed. Please install
libtxc_dxtn and lib32-libtxc_dxtn with mesa drivers as almost all games
require it.

> Troubleshooting

Note:In addition to being documented here, any bug/fix/error should be,
if not already, reported on Valve's bug tracker on their GitHub page.

Note:Connection problems may occur when using DD-WRT with peer-to-peer
traffic filtering.

GUI problems with KDE

Valve GitHub issue 594

If you are using KDE and you have problems with the GUI (such as lag or
random crashes), in KDE system settings, go to "Desktop Effects" in the
"Workspace Appearance and Behaviour" section. Open the "Advanced" tab.
Change "Compositing type" from XRender to OpenGL.

The close button only minimizes the window

Valve GitHub issue 1025

To close the Steam window (and remove it from the taskbar) when you
press x, but keep Steam running in the tray, set the environment
variable STEAM_FRAME_FORCE_CLOSE to 1. You can do this by launching
Steam using the following command.

    $ STEAM_FRAME_FORCE_CLOSE=1 steam

Flash not working on 64-bit systems

Steam Support article

First ensure lib32-flashplugin is installed. It should be working at
this point, if not create a local Steam flash plugin folder

    mkdir ~/.steam/bin32/plugins/

and set a symbolic link to the global lib32 flash plugin file in your
upper new folder

    ln -s /usr/lib32/mozilla/plugins/libflashplayer.so ~/.steam/bin32/plugins/

Text is corrupt or missing

The Steam Support instructions for Windows seem to work on Linux also:
Simply download SteamFonts.zip and install them (copying to ~/.fonts/
works at least).

Error on some games: S3TC support is missing

Install the following dependencies:

-   libtxc_dxtn
-   lib32-libtxc_dxtn

Black screen on (Valve?) games (but audio works)

Check the Steam stdout/stderr for Error lines, some quick dependencies
for reference:

-   lib32-intel-dri (not confirmed as absolutely necessary)

run steam from console via primusrun steam

If using KDE, disable all desktop effects (Alt + Shift + F12) before
starting Steam.

SetLocale('en_US.UTF-8') fails at game startup

Edit /etc/locale.gen in your favourite editor and uncomment the line
en_US.UTF-8 UTF-8. Then run locale-gen as root.

> Tips

Launching games with custom commands, such as Bumblebee/Primus

Steam has fortunately added support for launching games using your own
custom command. To do so, navigate to the Library page, right click on
the selected game, click Properties, and Set Launch Options. Steam
replaces the tag %command% with the command it actually wishes to run.
For example, to launch Team Fortress 2 with primusrun and at resolution
1920x1080, you would enter:

    primusrun %command% -w 1920 -h 1080

If you are running the Linux-ck kernel, you make have some success in
reducing overall latencies and improving performance by launching the
game in SCHED_ISO (low latency, avoid choking CPU) via schedtool

    schedtool -I -e %command% <other arguments>

> Skins for Steam

The Steam interface can be fully customized by copying its various
interface files in its skins directory and modifying them.

Steam Skin Manager

The process of applying a skin to Steam can be greatly simplified using
steam-skin-manager from the AUR. The package also comes with a hacked
version of the Steam launcher which allows the window manager to draw
its borders on the Steam window.

As a result, skins for Steam will come in two flavors, one with and one
without window buttons. The skin manager will prompt you whether you use
the hacked version or not, and will automatically apply the theme
corresponding to your GTK theme if it is found. You can of course still
apply another skin if you want.

The package ships with two themes for the default Ubuntu themes,
Ambiance and Radiance. A Faience theme is under development and already
has its own package on the AUR steam-skin-faience-git.

Steam on Wine
-------------

Install wine from the official repositories and follow the instructions
provided in the article.

Install the required Microsoft fonts ttf-microsoft-tahoma and
ttf-ms-fonts from the AUR or through winetricks-svn.

Note:If you have access to Windows discs, you may want to install
ttf-win7-fonts instead.

If you have an old Wine prefix (~/.wine), you should remove it and let
Wine create a new one to avoid problems (you can transfer over anything
you want to keep to the new Wine prefix).

> Installation

Download and run the Steam installer from steampowered.com. It is no
longer an .exe file so you have to start it with msiexec:

    $ msiexec /i SteamInstall.msi

> Starting Steam

On x86:

    $ wine ~/.wine/drive_c/Program\ Files/Steam/Steam.exe

On x86_64 (with steam installed to a clean wine prefix):

    $ wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe

Alternatively, you may use this method:

    $ wine "C:\\Program Files\\Steam\\steam.exe" 

You should consider making an alias to easily start steam (and put it in
your shell's rc file), example:

    alias steam='wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'

Note:If you are using an nvidia card through bumblebee, you should
prefix those commands with optirun.

> Tips

Performance

Consider disabling wine debugging output by adding this to your shell rc
file:

    export WINEDEBUG=-all

or, just add it to your steam alias to only disable it for steam:

    alias steam='WINEDEBUG=-all wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null 2>&1 &'

Additionally, Source games rely on a paged pool memory size
specification for audio, and WINE by default does not have this set. To
set it:

    wine reg add "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Memory Management\\" /v PagedPoolSize /t REG_DWORD /d 402653184 /f

Application Launch Options

Go to "Properties" -> "Set Launch Options", e.g.:

    -console -dxlevel 90 -width 1280 -height 1024

-   console

Activate the console in the application to change detailed applications
settings.

-   dxlevel

Set the application's DirectX level, e.g. 90 for DirectX Version 9.0. It
is recommended to use the video card's DirectX version to prevent
crashes. See the official Valve Software Wiki
http://developer.valvesoftware.com/wiki/DirectX_Versions for details.

-   width and height

Set the screen resolution. In some cases the graphic settings are not
saved in the application and the applications always starts in the
default resolution. Please refer to
http://developer.valvesoftware.com/wiki/Launch_options for a complete
list of launch options.

Using a Pre-Existing Steam Install

If you have a shared drive with Windows, or already have a Steam
installation somewhere else, you can simply symlink the Steam directory
to ~/.wine/drive_c/Program Files/Steam/ . However, be sure to do all the
previous steps in this wiki. Confirm Steam launches and logs into your
account, then do this:

    cd ~/.wine/drive_c/Program\ Files/ 
    mv Steam/ Steam.backup/   (or you can just delete the directory)
    ln -s /mnt/windows_partition/Program\ Files/Steam/

Note:If you have trouble starting Steam after symlinking the entire
Steam folder, try linking only the steamapps subdirectory in your
existing wine steam folder instead.

Note:If you still have trouble starting games, use
sudo mount --bind /path/to/SteamApps ~/.local/share/Steam/SteamApps -ouser=your-user-name ,
this is the only thing that worked for me with TF2

Running Steam in a second X Server

Assuming you are using the script above to start Steam, make a new
script, called x.steam.sh. You should run this when you want to start
Steam in a new X server, and steam.sh if you want Steam to start in the
current X server.

If due to misconfiguration a black screen is shown, you could always
close down the second X server by pressing Ctrl + Alt + Backspace.

    #!/bin/bash 

    DISPLAY=:1.0

    xinit $HOME/steam.sh $* -- :1

Now you can use Ctrl + Alt + F7 to get to your first X server with your
normal desktop, and Ctrl + Alt + F8 to go back to your game.

Because the second X server is only running the game and the first X
server with all your programs is backgrounded, performance should
increase. In addition, it is much more convenient to switch X servers
while in game to access other resources, rather than having to exit the
game completely or Alt-Tab out. Finally, it is useful for when Steam or
WINE goes haywire and leaves a bunch of processes in memory after Steam
crashes. Simply Ctrl + Alt + Backspace on the second X server to kill
that X and all processes on that desktop will terminate as well.

If you get errors that look like "Xlib: connection to ":1.0" refused by
server" when starting the second X: You will need to adjust your X
permissions.

If you lose the ability to use the keyboard while using Steam: This is
an odd bug that does not happen with other games. A solution is to use a
WM in the second X as well. Thankfully, you do not need to run a large
WM. Openbox and icewm have been confirmed to fix this bug (evilwm,
pekwm, lwm do not work), but the icewm taskbar shows up on the bottom of
the game, thus it's recommended to use Openbox. Install openbox from the
official repositories, then add openbox & to the top of your steam.sh
file. Note you can run other programs (ex. Teamspeak &) or set X
settings (ex. xset, xmodmap) before the WINE call as well.

Steam Links in Firefox, Chrome, Etc

To make steam:// urls in your browser connect with steam in wine, there
are several things you can do. One involves making steam url-handler
keys in gconf, another involves making protocol files for kde, others
involve tinkering with desktop files or the Local State file for
chromium. These seem to only work in firefox or under certain desktop
configurations. One way to do it that works more globally is using
mimeo, a tool made by Xyne (an Arch TU) which follows. For another
working and less invasive (but firefox-only) way, see the first post
here .

-   Make  /usr/bin/steam with your favorite editor and paste:

    #!/bin/sh
    #
    # Steam wrapper script
    #
    exec wine "c:\\program files\\steam\\steam.exe" "$@"

-   Make it executable.

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
        #elif `dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager > /dev/null 2>&1` ; then DE=gnome;
        #elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep ' = \"xfce4\"$' >/dev/null 2>&1; then DE=xfce;
        #elif [ x"$DESKTOP_SESSION" == x"LXDE" ]; then DE=lxde;
        #else DE=""
        #fi
        DE=""
    }

-   Restart the browser and you should be good to go. In chromium, you
    cannot enter a steam:// link in the url box like you can with
    firefox. The forum link above has a steam://open/friends link to try
    if needed.

Note:If you have any problems with file associations after doing this,
simply revert to regular xdg-utils and undo your changes to
/usr/bin/xdg-open.

Note:Those on other distributions that stumble upon this page, see the
link above for firefox specific instructions. No easy way to get it
working on Chromium on other distros exists.

No text rendered problem

If there is no text/font rendered when starting steam you should try to
start steam with the parameter -no-dwrite. Read more in the forum thread
about it.

    wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite

See Also
--------

-   https://wiki.gentoo.org/wiki/Steam

Retrieved from
"https://wiki.archlinux.org/index.php?title=Steam&oldid=255168"

Categories:

-   Gaming
-   Wine
