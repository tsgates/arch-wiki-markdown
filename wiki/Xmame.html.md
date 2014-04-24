Xmame
=====

Xmame is an arcade machine emulator in Linux. With proper ROMs, Xmame
stars out with a series of emulators and over 5000 games. Unfortunately,
arcade ROM images for individual games are a legal gray area for PC
users. You are warned, if you are to download such ROMs.

Installation & Configuration
----------------------------

Install xmame-sdl from the AUR.

su to local user and generate the configuration file:

    $ xmame -showconfig > ~/.xmame/xmamerc

The generated configuration file should have contained the basic entries
to start the emulation. Xmame uses a ":" seperated rompath to find out
which dirs to search for ROMs. To put different kinds of roms in
specified directory, just add a directory to the rompath line

Download ROMs
-------------

-   ROMs are protected by copyright, so it's illegal to download them
    most of the time in most parts of the world. If you understand this,
    and willing to take the risk, follow the following instructions to
    prepare them for xmame:

1.  For emulator ROMs, Put the zip files in /usr/share/xmame/roms.
2.  For game ROMs, store them to your specified directory, or just put
    them in /usr/share/xmame/roms.

Start emulating
---------------

To play game, issue the following command form the command prompt.

    $ xmame game.zip 

Press TAB to customize the input keys after the game starts. Happy
emulating!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xmame&oldid=305917"

Categories:

-   Emulators
-   Gaming

-   This page was last modified on 20 March 2014, at 17:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
