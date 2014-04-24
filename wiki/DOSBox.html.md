DOSBox
======

DOSBox is an x86 PC DOS-emulator for running old DOS games or programs.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
-   4 Tips
-   5 See also

Installation
------------

Install dosbox from the official repositories.

Configuration
-------------

No initial configuration is needed, however the official DOSBox manual
refers to a configuration file named dosbox.conf. By default that file
exists in your ~/.dosbox folder.

You can also make a new configuration file on a per-application basis by
copying dosbox.conf from ~/.dosbox to the directory where your DOS app
resides and modifying the settings accordingly. You can also create a a
config file automatically: simply run dosbox without any parameters
inside your desired application's folder:

    $ dosbox

Then at the DOS prompt, type:

    Z:\> config -wc dosbox.conf

The configuration file dosbox.conf will then be saved in the current
directory. Go in a change whatever settings you need.

The configuration options are described in the official DosBox wiki:
http://www.dosbox.com/wiki/Dosbox.conf.

Usage
-----

A simple way to run DOSBox is to place your DOS game (or its setup
files) into a directory and then run dosbox with the directory path
appended. For example:

    $ dosbox ./game-folder/

You should now have a DOS prompt whose working directory is the one
specified above. From there, you can execute the desired programs:

    C:\> SETUP.EXE

Tips
----

If DOSBox traps your focus, use Ctrl+F10 to free it.

See also
--------

-   http://www.dosbox.com/ - The official DOSBox site.
-   http://www.abandonia.com/ - Abandonia: large repository of old and
    abandoned DOS games.
-   http://www.dosgames.com/ - DosGames.com: large repository of DOS
    games.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DOSBox&oldid=280992"

Categories:

-   Emulators
-   Gaming

-   This page was last modified on 2 November 2013, at 19:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
