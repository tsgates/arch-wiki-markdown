StarCraft 2
===========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Environment
    -   1.1 Packages
    -   1.2 Configure Wine
-   2 Installing StarCraft II
    -   2.1 Installing from DVD
    -   2.2 Blizzard downloader
    -   2.3 Starcraft 2 demo
-   3 Playing StarCraft II
-   4 Hints for Performance Tuning
-   5 x86_64
    -   5.1 Alternative method: updating while keeping your 64bit
        ~/.wine directory
-   6 Patch 1.5.0
-   7 Troubleshooting
-   8 See also

Environment
-----------

Packages

You need to install:

-   wine
-   lib32-libjpeg-turbo, lib32-libpng and lib32-libldap

Configure Wine

The sound in Starcraft 2 in Wine versions 1.3.25 and later works out of
the box.

-   Edit the registry

    $ regedit
    Go to HKEY_CURRENT_USER/Software/Wine/Direct3D
    To create new entries: Right-click on Direct3D, select New -> String Value
    DirectDrawRenderer      opengl
    Multisampling           disabled
    OffscreenRenderingMode  pbuffer
    PixelShaderMode         enabled
    RenderTargetLockMode    readtex
    StrictDrawOrdering      disabled
    UseGLSL                 disabled
    VertexShaderMode        hardware
    VideoMemorySize         1536 (Change this to however much memory your card has)

-   For Map-Editor:
    -   The latest winetricks can be found at
        http://winetricks.org/winetricks, download and start:

    $ sh winetricks vcrun2005 vcrun2008

-   To get rid of some warnings that may or may not matter on x86_64,
    you may want to install lib32-mpg123 and lib32-jack available in
    multilib.

Also install lib32-audiofile and lib32-esound from AUR. If you are using
Pulseaudio then install lib32-libpulse and lib32-alsa-plugins available
in multilib.

-   Don't emulate a virtual desktop for the installer.
-   If the installer doesn't work, backup and remove your .wine
    directory.
-   If you are asked to install Gecko, then click install to do so.
-   If the installer hangs while downloading patch 1.03, install ie6,
    and set the wine version to windows XP:

    $ sh winetricks ie6
    $ winecfg

or on x64

    $ WINEPREFIX=~/win32 sh winetricks ie6
    $ winecfg

Go to Applications, set Windows Version to "Windows XP"

Installing StarCraft II
-----------------------

Installing from DVD

-   Mount DVD/DVD Image, (unhide invisible data), for example:

    $ mount -o ro,unhide,uid=1000 /dev/dvd /media/dvd (for the DVD)
    $ mount -o loop,ro,unhide,uid=your_id starcraft.iso /media/dvd (for an image) 

-   Start the installer:

    $ wine start /unix /media/dvd/Installer.exe

Blizzard downloader

-   Get the downloader from your battle.net account (you need to log
    in).
-   You may want to go to View > Preferences and check "Don't throttle
    background download".
-   During the install, you will need about twice the space of the
    installed game, since it downloads to a temporary directory (of your
    choice) before installing. This directory can be deleted after
    install.

Starcraft 2 demo

https://us.battle.net/account/sc2-demo.html The download is 1.56 GB. You
need to have a battle.net account.

The demo got replaced by StarCraft II: Starter Edition.

Playing StarCraft II
--------------------

    $ cd .wine/drive_c/Program\ Files/StarCraft\ II/
    $ wine start StarCraft\ II.exe 

Or use the Starcraft II icon, but that'll make it more difficult to
troubleshoot in case you have problems.

Hints for Performance Tuning
----------------------------

-   Ctrl+Alt+f shows FPS
-   Launching the game with the -opengl flag has been reported to
    increase performance. (This may be specific to the mac version.)
-   Disabling Shader in wine could help, if FPS is too low. (It may also
    cause the game to not work at all. Again, possibly only mac.)
-   Make sure that you are not using old graphics drivers. Nvidia
    drivers should be 256.35 or later (extra/nvidia is up to date).
-   Edit the variables.txt in your My Documents/Starcraft II/ following
    the guide here

x86_64
------

If you are running a 64bit version of Arch Linux, you may have trouble
getting the updating done. Since StarCraft 2 uses Internet Explorer to
render all the HTML pages, you need to have Internet Explorer installed.
However, by the installer of IE6 will warn you that 64bit is not
supported. By default, if you have created your wine configuration
directory (~/.wine), it will be set to 64 bit. To overcome this problem,
you can either recreate your ~/.wine configuration, or if you wish to
keep your current ~/.wine configuration see the alternative method
below. If you wish to recreate your ~/.wine configuration simply remove
the ~/.wine directory, add export WINEARCH="win32" to your ~/.bashrc,
logout of X, login once again and launch wine. It should create a
~/.wine folder. Next install ie6 with

    $ winetricks ie6

More information can be found here.

> Alternative method: updating while keeping your 64bit ~/.wine directory

This method uses a separate wine directory installed as 32bit. So the
first step is to setup this alternate wine configuratoin. The easiest
way to do this is to install a wine configuration for a separate user.
You do not need to logout for this, just open up your terminal of choice
and:

    $ login alternateuser

or if you're going to use root:

    $ su

Enter password, remove any already existing wine configuration supposing
you do not use wine from this user, then set wine to use 32bit
architecture and generate the configuration:

    $ export WINEARCH="win32"
    $ winecfg

Install/update the wine configuration. No other settings need to be set
after updating so you can just close the wine configuration window. Then
use winetricks to install ie6:

    $ winetricks ie6

When that's done, use the new configuration to run Starcraft II.exe from
your user's 64bit /home/user/.wine directory where Starcraft 2 is
installed:

    $ wine /home/user/.wine/drive_c/Program\ Files\ \(x86\)/Starcraft\ II/Starcraft\ II.exe

This will run the updater/patcher installing all the patch files to your
64bit ~/.wine directory using the alternate user's 32bit .wine directory
containing ie6. Close the updater when it's finished and you can then
remove the new 32bit .wine configuration or keep it for later updates.
Now you can go back to playing from your regular user using 64bit wine.

Patch 1.5.0
-----------

-   Intel HD Graphics 3000 have increased stability and gained around
    10FPS, however you have to set

    $ wine regedit
    Go to HKEY_CURRENT_USER/Software/Wine/Direct3D
    VideoMemorySize         128

Otherwise it won't run and will exit with errors about too low video
VRAM.

-   Problems with updating

Start game and wait for updating to start.

    $ wine "StarCraft II.exe"

When agent fails with:

    Agent started on port #6882
    Executing operation: disable_firewall applicationPath="C:\users\Public\Application Data\Battle.net\Agent\Agent.1199\Agent.exe" applicationName="Battle.net Update Agent"
    AgentAsAdmin failed to add a firewall exception for 'C:\users\Public\Application Data\Battle.net\Agent\Agent.1199\Agent.exe'.
    Registered Event: "shutdown event"
    Registered Event: "database flush event"
    PostTo succeeded status: 0 for url: http://enGB.patch.battle.net:1119/patch
    Post Data:
    <version program="Agnt"><record program="Bnet" component="Win" version="1" /><record program="Agnt" component="cdn" version="1" /><record program="Agnt" component="cfg" version="1" /><record program="Agnt" component="Win" version="1199" /></version>
    DownloadTo failed error: 0 of article:  from:

    DownloadTo failed error: 0 of article:  from:

    DownloadTo failed error: 0 of article:  from:

Launch Agent.exe --nohttpauth

    $ wine ~/.wine/drive_c/users/Public/AppData/Battle.net/Agent/Agent.exe --nohttpauth

Start StarCraft II again to re-launch updater:

    $ wine "StarCraft II.exe"

Troubleshooting
---------------

-   Game crashes when completing bonus objectives

If the game consistently crashes when completing bonus objectives, the
reason might be that wine is missing the Arial font (source:
http://eu.battle.net/sc2/en/forum/topic/6892929829).

    $ pacman -S winetricks
    $ winetricks corefonts

Alternatively, copy Arial.TTF into ~/.wine/drive_c/windows/Fonts.

-   For some, the game crashes upon exit. (There seems to be more issues
    with ati cards than nvidia.)
-   For some, in-gamechange of resolution does not work. Editing
    'width=x' and 'height=y' in Variables.txt in My Documents/Starcraft
    II solves this issue. Replace x and y with the prefered resolution.
-   Graphics problems (No 3D background in menu, blue non-texturized
    units and other glitches) launch with the command below. You can
    also add this option to the .desktop entry in
    ~/.local/share/applications/wine/Programs/StarCraft II

    force_s3tc_enable=true wine StarCraft II.exe

-   If updates don't seem to work at all try to apply them manually. You
    can download European version patches here:
    http://eu.battle.net/support/en/article/starcraft-ii-patch-information.
    Check the bottom of that page for other regions. Then you execute
    the patch with wine.
-   Be sure to have libjpeg6 installed. Otherwise, the updater won't
    work.

-   Flickering lights emitted from SCV's thrusters and other light
    sources (see: http://www.youtube.com/watch?v=tsaEd-dTAlQ) may be
    because of missing registry entries:

    [HKEY_CURRENT_USER\Software\Wine\Direct3D]
    "DirectDrawRenderer"="opengl"
    "Multisampling"="disabled"
    "OffscreenRenderingMode"="fbo"
    "PixelShaderMode"="enabled"
    "RenderTargetLockMode"="readtex"
    "StrictDrawOrdering"="disabled"
    "UseGLSL"="disabled"
    "VideoMemorySize"="128"

As told here with explanation for variables:
http://wiki.winehq.org/UsefulRegistryKeys

It seems to fix the problem.

See also
--------

-   StarCraft II: Wings of Liberty (Retail) (WineHQ AppDB)
-   StarCraft II crashes because of ACCESS_VIOLATION before the loading
    screen (WineHQ bug tracking database)
-   World of Warcraft crashes upon login after 3.3.5 patch. (WineHQ bug
    tracking database)
-   starcraft2 crashing on loading (Arch Linux forums)
-   starcraft2 fails to update to patch 1.03 (Arch Linux forums)
-   Patch News (battle.net EU forums)
-   There used to be a link here about hotkey customization. Instead,
    here is a link telling us that's not allowed. (battle.net EU forums)

Retrieved from
"https://wiki.archlinux.org/index.php?title=StarCraft_2&oldid=282845"

Categories:

-   Gaming
-   Wine

-   This page was last modified on 14 November 2013, at 16:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
