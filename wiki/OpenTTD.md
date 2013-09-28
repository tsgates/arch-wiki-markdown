OpenTTD
=======

OpenTTD is a tile-based transportation management game based on
Transport Tycoon Deluxe. The game is in the community repository.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Original Transport Tycoon Deluxe data (optional)             |
|         -   1.1.1 Where to get the data                                  |
|         -   1.1.2 Graphics and sound effects                             |
|         -   1.1.3 Music                                                  |
|                                                                          |
| -   2 Tutorial                                                           |
| -   3 Configuration                                                      |
|     -   3.1 Game Options                                                 |
|     -   3.2 Difficulty                                                   |
|     -   3.3 Advanced Settings                                            |
|     -   3.4 AI/Game Script Settings                                      |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Cheats                                                       |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install openttd, available in the Official Repositories.

A free replacement of the base graphics can be installed with the
package openttd-opengfx, available in the Official Repositories.

A free replacement of the base sound can be installed with the package
openttd-opensfx, available in the Official Repositories.

> Original Transport Tycoon Deluxe data (optional)

OpenTTD can utilize the non-free graphics and sound data of the original
Windows/DOS version of Transport Tycoon Deluxe.

Where to get the data

If you wish to play OpenTTD with the non-free TTD base graphics and
sounds, you will need several files from either the Windows/DOS version
of Transport Tycoon Deluxe.

You can get these files from the game CD-ROM, from an existing install
or you get them from the freely available game installation archive
available at Abandonia.

Graphics and sound effects

Copy the following files to /usr/share/openttd/data/

-   trg1r.grf or TRG1.GRF
-   trgcr.grf or TRGC.GRF
-   trghr.grf or TRGH.GRF
-   trgir.grf or TRGI.GRF
-   trgtr.grf or TRGT.GRF
-   sample.cat

Music

The free music set OpenMSX can be installed directly from the in-game
download manager.

If you wish to listen to the original music (Windows version only), Copy
the files from the gm folder of the original TTD game directory to:
/usr/share/openttd/gm/

Note:If your sound driver does not support MIDI natively, you will need
to install timidity (configuring a sound sample is enough).

Tutorial
--------

The game can be quite confusing at first. A good tutorial is available
on the wiki here.

For an in-game tutorial, a game script has been implemented. Just
download 'Beginner Tutorial' with the in-game download manager and load
the 'Beginner Tutorial' scenario.

Configuration
-------------

The OpenTTD main configuration file is located at ~/.openttd/openttd.cfg
and is automatically created upon first startup.

Various settings in the configuration file can be edited with buttons on
the main menu. Each button is explained below.

> Game Options

This window allows you to set options which will be used by default at
the start of a new game.

Note:Settings will not be updated for games which have already been
started. The options can still be changed in-game.

You can also set the default graphics, sound, and music here.

> Difficulty

This window allows you to change the difficulty of the game, and
specific options about them. You can either use the difficulty presets
by selecting the difficulty buttons at the top of the window, or set
custom options.

More information can be found here.

> Advanced Settings

In this window, nearly all the other settings in the configuration file
can be modified. All the options are grouped in expandable sections. You
can also search for the setting to be changed using the search utility.

Details about these settings can be found here.

> AI/Game Script Settings

This window allows you to customize various options relating to
artificial intelligence (bots or CPU players) and Game Scripts.

Game Scripts are a goal-based scripts which can perform many in-game
actions to enhance or extend the game.

Detailed information about this window can be found here.

Tips and tricks
---------------

> Cheats

A cheat menu can be shown in a local game by pressing Ctrl-Alt-C.

Detailed information about cheats are available here.

See also
--------

-   OpenTTD
-   OpenTTD Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenTTD&oldid=252836"

Category:

-   Gaming
