Diablo II
=========

This page explains how to install Diablo II and play it under Archlinux.
This works as of latest patch 1.13c.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
|     -   1.1 Step 1                                                       |
|     -   1.2 Step 2                                                       |
|     -   1.3 Step 3                                                       |
|     -   1.4 Step 4                                                       |
|                                                                          |
| -   2 Additional information                                             |
| -   3 Playing                                                            |
| -   4 Troubleshooting                                                    |
|     -   4.1 Error "ACCESS_VIOLATION" on start                            |
|     -   4.2 Only starts in windowed mode                                 |
+--------------------------------------------------------------------------+

Installing
----------

> Step 1

Install the wine package.

    # pacman -S wine

> Step 2

Download Diablo II and Diablo II Lord of Destruction installation files
from battle.net. I downloaded them on Windows and them moved via USB
stick. You can also run the downloaders directly from Arch. They will
produce 2 folders: D2-1.12A-enUS and D2LOD-12.12A-enUS (locale may be
different for you).

After that, go to first folder and run

    $ wine Installer.exe

Enter your product key which can be found In your battle.net account and
install. After it is finished, go to the second folder and run the same
command. Once both are installed, download patch 1.13d from the Internet
as updater will not work. After that, run:

    $ wine LODPatch_113d.exe

> Step 3

Now you need to configure the graphics. Go to ~/.wine/drive_c/Program
Files/Diablo II (or where ever you installed) and run:

    $ wine D2VidTst.exe

Click on Run Test. Once it's finished, pick whichever you want.
Generally I prefer 2D even on Windows as very few modern cards support
Glider. You can try 3D though and see if it lags or not.

> Step 4

    $ winecfg

Then, add Game.exe and make sure it uses ALSA under the sound tab and
that it is emulated as Windows XP. I didn't have to change anything as
those were default for me.

Additional information
----------------------

While the information above will work for a fresh install from the
actual CD's themselves, if you are a dual boot user you most likely have
Diablo II installed on your windows partition. If this is the case,
you're more than capable of running the installation in ArchLinux,
without much hassle.

You can start by mounting your windows installation to a fixed-name
directory, I like to create one in /media and make sure it can be
accessed by anyone.

    $ mkdir /media/windows
    $ chmod 777 /media/windows
    $ mount /media/sdb2 /media/windows

Keep in mind that your drive letter will be different than documented,
to locate your windows partition do the following:

    $ fdisk -l

The output will tell you what drive is HPFS/NTFS, the smaller size will
be your windows recovery partition (unless you do not have one), and the
larger one will be your entire windows partition.

I also recommend using the package ntfs-3g, which will allow you to
write content to your windows partition, in addition to being able to
read it. This will make life much easier at one point or another.

    $ pacman -S ntfs-3g

Once you have your windows partition mounted you may wish to copy your
Diablo II directory to a location on the Linux partition, and choose not
to mount windows at all, this is perfectly fine and does not cause any
problems, make sure you know whether or not your installation is in a
x64 bit folder or a x86 bit folder.

    $ cp -dpR /media/windows/Program Files/Diablo II /home/username/Desktop
    $ cp -dpR /media/windows/Program files (x86)/Diablo II /home/username/Desktop

Once you have successfully decided how to gain access to your content,
you will need to have a Diablo II play disc for either classic, if you
play classic, or expansion, if you play expansion. If you do not have
the actual disc, and use a ISO I recommend mounting it using fuseiso.

    $ mkdir /media/diablo
    $ chmod 777 /media/diablo
    $ pacman -S fuseiso

Make sure you do the above commands as root, and when you mount the
actual ISO do it as a regular user, this will ensure the game is mounted
with the proper permissions.

    $ fuseiso /location/of/diablo.iso /media/diablo

Note:you will need to run winecfg as a regular user, and set up the
mounted ISO location under "Drives". I choose drive "S:" and configured
it as a CD-ROM mount to /media/diablo.

You may also have issues running the D2VidTst, noticing that you have no
available video displays, if this is the case you must take note to run
Diablo II's "Game.exe" with the window extension, other wise it will
crash. WineHQ noted this as a coding error on behalf of Blizzard.

    $ wine /media/windows/Program Files/Diablo II/Game.exe -w
    $ wine /media/windows/Program Files x(86)/Diablo II/Game.exe -w

On a additional note, use of a "NO-CD" crack will result in a ban on
Battle.net, and if you do not wish to be restricted from realm play,
should invest in finding a ISO you can mount locally.

And on a final note, this is a Windows game and you will notice that you
will generate many notifications about missing fonts, this can be
corrected by creating a symlink between the wine fonts directory, and
the windows directory.

    $ ln -s /media/windows/Windows/Fonts /usr/share/wine/fonts

If you do not want to mount the Windows parition as mentioned before,
copy the windows Fonts directory into the Diablo II folder you have on
the Linux partition, and create the symlink between wine and that
directory.

Playing
-------

If you use a desktop, you can create a shortcut. Otherwise just run:

    $ wine ~/.wine/drive_c/Program\ Files/Diablo\ II/Game.exe

Warning: Don't append the argument -opengl , because it was left
unfinished by the developers and may cause extra problems for you!

Troubleshooting
---------------

> Error "ACCESS_VIOLATION" on start

Try setting dsoundhw=Emulation. This can be done by starting winetricks
"Select the default wineprefix"and then choose "Change settings" and
check the box in front of "dsoundhw=Emulation". Another thing to try is
to add "-w" at the end of the command line. It will launch the game in
windowed mode but it should work where fullscreen doesn't.

> Only starts in windowed mode

Try running D2VidTst.exe in the game folder and then select 3dfxGlide.
If the game still doesn't start in fullscreen place the glide3x.dll into
the game folder from this website
http://www.svenswrapper.de/english/downloads.html. It is extra written
for running Diablo2 with glide.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Diablo_II&oldid=205823"

Categories:

-   Gaming
-   Wine
