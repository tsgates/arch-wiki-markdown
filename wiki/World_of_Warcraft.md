World of Warcraft
=================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

World of Warcraft (WoW) is a Massively Multiplayer Online Role-Playing
Game (MMORPG) by Blizzard Entertainment taking place in the fictional
world of Azeroth, the world that previous Blizzard titles in the
Realtime Stategy (RTS) Warcraft series. For more information about the
game itself, visit the Official World of Warcraft website.

This article will describe how install and run in on Arch Linux using
Wine.

Some of this information was provided by
http://www.wowwiki.com/Linux/Wine which is the best general source of
information on WoW on Wine.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Wine                                                    |
| -   2 Installing the Game                                                |
|     -   2.1 Downloading and installing via Blizzard's client             |
|         -   2.1.1 Downloading the Client                                 |
|         -   2.1.2 Installing the Game                                    |
|         -   2.1.3 Troubleshooting                                        |
|             -   2.1.3.1 Not able to agree to terms                       |
|             -   2.1.3.2 Wine crashes while reading terms                 |
|                                                                          |
|     -   2.2 Copying the CDs to a folder                                  |
|     -   2.3 Copying an Existing Installation                             |
|     -   2.4 New Installation from CD                                     |
|     -   2.5 New Installation from DVD                                    |
|                                                                          |
| -   3 Installing Patches                                                 |
| -   4 Configuration                                                      |
|     -   4.1 Using OpenGL                                                 |
|     -   4.2 Resolution and Colour depth                                  |
|     -   4.3 Windowing                                                    |
|     -   4.4 Black textures issue                                         |
|     -   4.5 Sound Issues                                                 |
|         -   4.5.1 Configuring the Buffer                                 |
|         -   4.5.2 Stuttering or Static Sound                             |
|                                                                          |
| -   5 Performance Tweaks                                                 |
|     -   5.1 For NVIDIA users                                             |
|         -   5.1.1 NVIDIA users and Direct3D mode                         |
|                                                                          |
| -   6 Links                                                              |
+--------------------------------------------------------------------------+

Installing Wine
---------------

See Wine.

Installing the Game
-------------------

There are five options for installing World of Warcraft.

> Downloading and installing via Blizzard's client

The most straightforward way of installing World of Warcraft on Linux is
usually this method, while it may not be the fastest. On slower
connections, however, you may not wish to use this method due to the
fact that you will have to download the entire game, including patches.

It is known to work with Wine 1.1.39 which can be downloaded off Wine's
website and compiled. However, you may wish to try with the newest
version from the extra section, installed via Pacman like so:

    # pacman -S wine

Downloading the Client

First step is to download the client. European users can download it off
the european World of Warcraft website here, while people from the
United States would probably want to download the US client.

Installing the Game

Once the client is downloaded run the file with Wine:

    wine InstallWoW.exe

A window will pop up asking you which product to install. If you choose
the latest expansion, it will install the base game and any previous
expansions as well.

Troubleshooting

Not able to agree to terms

In case you can not see the license text, you probably have to install
gecko, since the license is rendered as HTML.

To install it (on 64 bit enable [multilib])

    pacman -S wine_gecko

In some versions of Wine, you can not agree to the terms even though you
scrolled down. Try to compile the latest Wine from source. Or use a
version of Wine it is known to work with, i.e. 1.1.39 (please add more
here).

Wine crashes while reading terms

Wine crashes as soon as the terms which must be agreed to install the
game opens. This is because the installer fetches the terms from a
website somewhere, and therefore uses a browser implementation to show
them. Wine's implementation of this is named [Gecko
http://wiki.winehq.org/Gecko], and this must be installed in order for
the installation to work!

> Copying the CDs to a folder

This method's goal is to copy the 5 install CDs to a folder. This seems
to solve problems with deciding whether a CD is mounted and needs
changing or not ; I think this is a fundamental problem because Windows
does not have the basic concept of mounting and unmounting drives.

    mkdir /mnt/temp
    cd /mnt/temp

    mount /mnt/cdrom
    cp -R /mnt/cdrom/* /mnt/temp
    umount /mnt/cdrom
    (repeat above for each of the 5 CDs)

Then run the World of Warcraft Installer with :

     wine Installer.exe

> Copying an Existing Installation

The third is to simply copy an exisiting WoW installation from a Windows
drive to Linux.

NOTE: If you do not alreay have Wine installed, or have not run World of
Warcraft with Wine before, you should skip down to #Installing Wine,
then come back to this section. Please DO NOT SKIP this section unless
you are absolutely sure you know what you are doing.

Copy the C:\Program Files\World of Warcraft directory from Windows to
~/.wine/drive_c/Program Files/World of Warcraft.

Example (assuming your windows partition is mounted at /mnt/windows and
you are in your home directory) (Quotes are needed because of the spaces
in the file names):

     cp -R "/mnt/windows/Program Files/World of Warcraft" ".wine/drive_c/Program Files/World of Warcraft"

This will ensure that Wine knows about your WoW and will be able to
configure it properly, and also ensures that WoW will not notice it has
even been moved at all.

Now that you have WoW installed, skip down to #Post-Installation.

> New Installation from CD

NOTE: We will assume that your Wine CD-ROM drive is "D:\" for this
guide. Please use the correct letter as set up in the #Installing Wine
section.

Insert the first CD, mount it, and start the installation with:

     wine "D:\Installer.exe"

When it asks for the next cd, simply unmount your CD drive and mount the
next CD. Make absolutely sure that you mount the CD before telling the
installer to load the CD, or it may make the installation fail. If you
have any issues installing using the CDs, please read the next section.

The WoW installation uses all 5 CDs, so it will take a while. Go outside
and get some fresh air while the CD loads, because soon you will not
have any "free time". :P

> New Installation from DVD

NOTE: Note that on some WoW DVD's the installer executable is hidden and
you need to mount the disc with the 'unhide' option. To do this type in
a terminal:

    mount -t iso9660 -o ro,unhide /dev/cdrom /media/cdrom/

Insert first the DVD. If it will be mounted automatically - just
unmount.

     # umount /media/dvd

Now mount manually

     # mount -t iso9660 /dev/dvd0 /mnt/dvd

Now you will find the Install.exe on the DVD

     ~ wine /mnt/dvd/Installer.exe

Installing Patches
------------------

Now we will need to update WoW. As of Noevember 30th 2010, the latest
version of World of Warcraft is 4.0.3.13329. This will change over time,
of course. The best place I have found to access the latest patches is
http://www.wowwiki.com/Patch_mirrors

I think the simplest way of updating World of Warcraft is to download
the patches (links are at the Patch Wiki) and copy them into the working
directory for World of Warcraft. I have had problems with the Blizzard
Downloaders either not working at all, or working very slowly. If you
download them, you can reuse them if you reinstall or have an accident.

When you have downloaded the files into their own folder for neatness,
copy these patches into the World of Warcraft working directory.

    cp * ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/

The 1.12.x patch needs to be unzipped into the working directory

     cd ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/
     unzip wow-1.12.x-to-2.0.1-engb-patch-3.zip

The simplest way to install the patches seems to be to run World of
Warcraft. It detects that you have downloaded the patches and does not
do it again.

     cd ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/
     wine WoW.exe

You have to keep going round 5 times, it does get a bit dull, but it is
fairly reliable. Accept the offer to Install the Gecko renderer when it
comes up on your first patch install.

The original Wiki says you can install patches with Wine as follows:

    wine wow-VERSION-LANG-patch.exe

This method is currently still working.

If the Launcher (it displays a little box with News and Play) seems to
stop when downloading, close its window and re-run WoW.exe

UPDATED for 4.3

If the Launcher crashes when downloading patches start
backgrounddownloader and deactivate peer to peer and restart the
launcher. Now everything will download and install.

Configuration
-------------

The World of Warcraft configuration file is kept in the WTF directory
(do Blizzard have a sense of humour ?)

Edit it with

    gedit WTF/Config.wtf

> Using OpenGL

Add the following line which makes WoW run in OpenGL (hurrah !) instead
of grotty old DirectX Mode (boo).

    SET gxApi "opengl"

> Resolution and Colour depth

You can change the following two lines to set the default WoW
resolution. I have a 19" Monitor so I can use the following.

    SET gxColorBits "24"
    SET gxResolution "1440x900"

> Windowing

You can run in a Window by setting this, which is confirmed to work in
Wine.

    SET gxWindow "1" 

> Black textures issue

If you're using an Intel graphics card and you can see black textures in
the game (or the game crashes in OpenGL mode), you should eable S3TC
texture compression support. It can be enabled through driconf or by
installing libtxc_dxtn.

> Sound Issues

Configuring the Buffer

If the sound makes a horrendous racket with squeaks and white noise
try :

    SET SoundOutputSystem "1" 
    SET SoundBufferSize "100"

Stuttering or Static Sound

Run winecfg, and in the "Audio" tab, selected "OSS" as the sound driver,
using "Standard" hardware acceleration and driver emulation enabled.

You can also set WoW to run at a higher "nice level", which will usually
improve sound performance (renice must be run as root):

    sudo renice -15 `pidof WoW.exe`

Performance Tweaks
------------------

1. Here is a performance tweak that can boost your FPS significantly
(everything without quotes):

     - Open Wine's version of the registry editor by running "regedit"
     - Navigate to HKEY_CURRENT_USER\Software\Wine\ 
     - Select the "Wine" folder, right-click onto the folder symbol and select  New-> Key and rename it to "OpenGL"
     - Select the OpenGL-Key, then right-click into the right-hand pane, chose New-> String Value and hit enter
     - Rename "New Value #1" to "DisabledExtensions"
     - Double-Click on the renamed Key and enter "GL_ARB_vertex_buffer_object" into the "value" field

That was it, close the registry editor again, your changes will be saved
automatically.

2. If you are finding it annoying that turning your character by let us
say 90 degree takes n seconds normally, but n+m seconds in pupolated
areas (in other words: that the polygon count of your surroundings
affects the camera turning speed), apply something to
"GL_ARB_vertex_buffer_object", like let us say a "2", so it looks like
this: "GL_ARB_vertex_buffer_object2". You will still have the
performance boost of the above tweak, but with a smoother feeling.

You can also find this comment on WineHQ very useful. It can double your
FPS.

> For NVIDIA users

As of version 310.14 of the nvidia driver, an option exists for threaded
OpenGL performance optimization. WoW benefits greatly from utilizing
this.

(Sidenote: this makes the 'RGL' patch/library/hack redundant for nVidia
users)

Exporting __GL_THREADED_OPTIMIZATIONS=1 enables the optimizations.
Example of launching WoW with these optimizations:

    __GL_THREADED_OPTIMIZATIONS=1 wine Wow.exe -opengl

Once you've confirmed the game works well for you (applies to any game,
not just WoW) you can turn off debugging output to potentially improve
performance further:

    WINEDEBUG=-all __GL_THREADED_OPTIMIZATIONS=1 wine Wow.exe -opengl $> /dev/null

NVIDIA users and Direct3D mode

If running the game in Direct3D mode, in conjunction with the above
optimization, compiling Wine with the "Use glBufferSubDataARB for
dynamic buffer uploads" patch should yield a further performance
increase. This patch does not appear to increase performance in OpenGL
mode, though OpenGL mode generally results in higher framerates
anyway... albeit at the cost of the game's more advanced Direct3D eye
candy.

NOTE: You MUST turn off Wine's debugging to benefit from this

    WINEDEBUG=-all __GL_THREADED_OPTIMIZATIONS=1 wine Wow.exe

Links
-----

-   World of Warcraft in the wine APPDB
-   WoWWiki
-   Patch Mirrors

Retrieved from
"https://wiki.archlinux.org/index.php?title=World_of_Warcraft&oldid=248874"

Categories:

-   Gaming
-   Wine
