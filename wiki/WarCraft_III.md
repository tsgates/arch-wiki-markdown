WarCraft III
============

  Summary
  ----------------------------------
  Warcraft III installation guide.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installing Wine                                                    |
| -   3 Configuring Wine                                                   |
|     -   3.1 Windows version                                              |
|     -   3.2 Audio                                                        |
|     -   3.3 Devices                                                      |
|                                                                          |
| -   4 Installation                                                       |
|     -   4.1 Installing WarCraft III: The Reign of Chaos                  |
|     -   4.2 Installing WarCraft III: The Frozen Throne                   |
|     -   4.3 Upgrading to the current version                             |
|                                                                          |
| -   5 Post installation tricks                                           |
|     -   5.1 Disabling intro movies                                       |
|     -   5.2 Widescreen resolution                                        |
|     -   5.3 Alt key combo                                                |
|         -   5.3.1 GNOME                                                  |
|         -   5.3.2 KDE                                                    |
|                                                                          |
| -   6 Running WarCraft III                                               |
|     -   6.1 WarCraft III: The Reign of Chaos                             |
|     -   6.2 WarCraft III: The Frozen Throne                              |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Patch 1.23                                                   |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Introduction
------------

WarCraft III is a real-time strategy game created by Blizzard
Entertainment. This article will describe how to install and run it and
its addon The Frozen Throne on Arch Linux using Wine. WarCraft III can
be run with full OpenGL support, meaning you do not need the non-free
Cedega.

Installing Wine
---------------

Wine is available in the [extra] repository:

    pacman -S wine

If you need any further help check out the Wine article. You will also
want to run 'winecfg' and change a few settings to your liking before
running the install CD. A WarCraft III specific Wine version exists in
AUR, both in stable and development version. See here and here for more
information.

Configuring Wine
----------------

This shows you how to configure Wine before installing WarCraft III and
The Frozen Throne.

> Windows version

In order to make copy protection work under Wine you must switch your
Windows version to 2000 or XP.

> Audio

Both OSS and ALSA work. If you expierence difficulties with ALSA you may
want to switch to OSS. Please note that aoss can make your sound glitch
every three seconds so it is not recommend to use it.

> Devices

In order for the copy protection to work you must add a CD-ROM device:
Add a device, set path to /media/cdrom (or whatever you use when you
mount CDs) and change the device type to "CD-ROM".

Installation
------------

The following process will detail how to install WarCraft III and the
expansion The Frozen Throne and finally update to the current version.

> Installing WarCraft III: The Reign of Chaos

This is rather simple. DO NOT use cracked versions of this game.

-   Place the CD in your drive and mount it (or let it automount if
    that's how your machine is setup).
-   Open a terminal and change in the directory of the CD.
-   Run

    wine install.exe

-   Follow the dialog boxes of the setup and enter your key when it asks
    for it.
-   Do not forget to leave the directory or you may have problems
    getting your CD back from your computer.

> Installing WarCraft III: The Frozen Throne

Please follow the same procedure as above, using the CD of The Frozen
Throne instead.

> Upgrading to the current version

You can try updating via Battle.net or use an offline patch. For the
first solution just hit the Battle.net button in the main menu after you
have started the game. Be sure you have read the post installation tipps
before running WarCraft III the first time. If you want to patch
offline, follow these steps:

-   Look here for the patch.
-   Download the current patch and save it in the directory you
    installed WarCraft III.
-   Open a terminal, change into that directory and run the patch via

    wine <patchname>.exe

If you have patched to version 1.22 or higher you do not need your CD
anymore for starting the game.

Post installation tricks
------------------------

There are some things you might want to fix before running WarCraft III
the first time because they still can cause you trouble. If one of the
following registry keys or values does not exist, simply create it.

> Disabling intro movies

The movies are not displayed correctly and cannot be aborted. So we set
them to be already seen.

-   Open a terminal, run

    regedit

-   Go to

    HKEY_CURRENT_USER\Software\Blizzard Entertainment\Warcraft III\Misc

-   Set "seenintromovie" to "1".

> Widescreen resolution

The option menu of WarCraft III does not support high widescreen
resolutions. If you want to use one you have to put it in the registry
by hand. Please note that you will loose this setting if you enter the
options menu inside WarCraft III because it will overwrite your setting
with the highest value it is capable of.

-   Open a terminal, run

    regedit

-   Go to

    HKEY_CURRENT_USER\Software\Blizzard Entertainment\Warcraft III\Video

-   Set "resheigth" and "reswidth" to whatever you prefer. Pay attention
    that you can enter either hexadecimal or decimal values.

> Alt key combo

If you like to use [Alt] + left click for minimap signal and you are
using KDE or GNOME you will find that this feature does not work due to
keyboard shortcuts with [Alt] that your desktop environment uses.

GNOME

The option to change the key binding is in System -> Preferences ->
Windows.

KDE

Go into KDE Control Center, expand Desktop, click window behavior, then
click window actions tab. You can turn off the alt combos. If you want
to make window specific settings, click on window specific settings
under window behavior on the side.

Running WarCraft III
--------------------

You can now run WarCraft III. You can check if the installer has made
you a starter in your applications menu. If so, you can use it. If you
have any problems you may want to check the command to start WarCraft
III. The path to your WarCraft III folder can be different depending on
the location of your wine folder and the installation path of WarCraft
III.

WarCraft III: The Reign of Chaos

    wine ~/.wine/drive_c/Program\ Files/Warcraft\ III/war3.exe -opengl

WarCraft III: The Frozen Throne

    wine ~/.wine/drive_c/Program\ Files/Warcraft\ III/Frozen\ Throne.exe -opengl

You do not need the -opengl parameter if your Direct3D rendering is fast
enough. Please test this for yourself.

Troubleshooting
---------------

> Patch 1.23

To login to battle.net with the latest version of wine make sure you
have lib32-gnutls or gnutls installed.

See also
--------

-   Wine
-   WineHQ's AppDB entry
-   Snoopy

Retrieved from
"https://wiki.archlinux.org/index.php?title=WarCraft_III&oldid=240475"

Categories:

-   Gaming
-   Wine
