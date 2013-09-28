Urban Terror
============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

"Urban Terror™ is a free multiplayer first person shooter, it can be
described as a Hollywood tactical shooter; somewhat realism based, but
the motto is "fun over realism". This results in a very unique,
enjoyable and addictive game." [1]

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Client                                                       |
|         -   1.1.1 Running Urban Terror in a second X server              |
|         -   1.1.2 Running Urban Terror in a single X server              |
|                                                                          |
| -   2 Mapping                                                            |
|     -   2.1 Prepare the game files                                       |
|         -   2.1.1 Extract your pk3s (recommended, ~1GB free disk space   |
|             required)                                                    |
|         -   2.1.2 Or: Give GTKRadiant write access to the game folder    |
|             (for single user machines)                                   |
|                                                                          |
|     -   2.2 Install a level editor                                       |
|         -   2.2.1 ZeroRadiant (gtkradiant-svn)                           |
|                                                                          |
|     -   2.3 Test your map                                                |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 cg_draw2D                                                    |
|     -   3.2 Fix urbanterror_ui.shader                                    |
|     -   3.3 Problems with libcurl                                        |
|     -   3.4 no sound ??                                                  |
|                                                                          |
| -   4 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Client

Urban Terror is now supported in the official repositories. Two packages
should be installed: urbanterror and urbanterror-data.

Running Urban Terror in a second X server

You might want to run this game in an extra X server. To do that, create
a new Bash script with that content and mark it as executable:

    ~/xstart/urbanterror.sh

    #!/bin/bash 
    DISPLAY=:1.0
    xinit /usr/bin/urbanterror $* -- :1

Now you can use Ctrl+Alt+F7 to get to your first X server with your
normal desktop, and Ctrl+Alt+F8 to go back to your game.

Because the second X server is only running the game and the first X
server with all your programs is backgrounded, performance should
increase. In addition, it is much more convenient to switch X servers
while in game to access other resources, rather than having to exit the
game completely or Alt+Tab out. Finally, it is useful if Urban Terror
crashes. Simply Ctrl+Alt+Backspace on the second X server to kill that X
and all processes on that desktop will terminate as well.

Running Urban Terror in a single X server

If you logout from any X Sessions if already started up and execute the
file from e.g. tty1 (Ctrl+Alt+F1) urbanterror is run on the first X
Server (Ctrl+Alt+F7). All terminal output is printed to tty1. This works
for mostly every game not depending on a window manager.

Mapping
-------

How to create your own maps.

> Prepare the game files

There are two ways, use the second one if you are low on disk space.

Extract your pk3s (recommended, ~1GB free disk space required)

To get something to work with, you need to extract Urban Terror's pk3
files to a new folder:

    install -d ~/urtmapping/q3ut4
    cd ~/urtmapping/q3ut4

    bsdtar -x -f /opt/urbanterror/q3ut4/zpak000_assets.pk3 --exclude maps
    bsdtar -x -f /opt/urbanterror/q3ut4/zpak000.pk3

Or: Give GTKRadiant write access to the game folder (for single user machines)

GTKradiant creates a few own files inside game directory on creating a
game profile. This means that you can own to the Urban Terror folder
temporarily until these are created:

    chown yourusername -R /opt/urbanterror

Then start GTKRadiant and configure the game profile (see below, just
use /opt/urbanterror as path). Close it afterwards and restrict access
again with:

    chown root -R /opt/urbanterror

Please note, that your user will own the newly created files until they
get deleted (which is just what we want in this case).

> Install a level editor

It might be possible to create Urban Terror maps with other level
editors, such as netradiant for example. If you know how to do just
that, please add it to the wiki.

ZeroRadiant (gtkradiant-svn)

Build and install both gtkradiant-svn and gtkradiant-gamepack-urt-svn
from the AUR.

Start gtkradiant by either typing its name in a terminal or clicking the
new menu entry. You will see a dialog, choose Urban Terror (standalone)
in the drop-down list and /home/you/urtmapping as engine directory (not
q3ut4). Click OK in the next window and the editor should pop up.

Here is a nice guide that explains how to create your first map as well
as some Urban Terror specific things you need to watch out for.

> Test your map

Copy your compiled .bsp mapfile to ~/.urbanterror/q3ut4/maps and run:

    urbanterror +set fs_game iourtmap +set sv_pure 0 +map ut4_yourmap

Troubleshooting
---------------

> cg_draw2D

Since version 4.2* the 2D User Interface (Cursor, Health, etc) is turned
off by default in the configuration line seta cg_draw2D "0". Change it
to

    ~/.q3a/q3ut4/q3config.cfg

    seta cg_draw2D "1"

and enjoy only the other 4.2 bugs from now on.

> Fix urbanterror_ui.shader

Open up ~/urtmapping/q3ut4/scripts/urbanterror_ui.shader in your
favorite editor and delete lines 29-55 (from /* to */), because
gtkradiant will not recognize this part as a comment and would try to
parse it.

> Problems with libcurl

UrbanTerror may complain that it cannot autodownload missing files
because the cURL library could not be loaded, even though the cURL
package is installed. UrbanTerror expects the shared library file to be
called libcurl.so.3, but Arch Linux currently uses libcurl.so.4 .

To remedy this, start UrbanTerror, and from the main menu bring down the
console with the grave key, tilda, or Shift-Esc. In the UrbanTerror
console, type:

    cl_curllib libcurl.so.4

Note that this is the UT console and not a terminal emulator. The
changes should now be persistent and you should be able to download maps
if the game server has their end configured correctly.

> no sound ??

maybe you are using alsa

    export SDL_AUDIODRIVER=alsa 

or maybe you are using the wrong device

    emacs .asoundrc   

maybe this will help..

    cat /proc/asound/card*/id

External links
--------------

Urban Terror homepage

ZeroRadiant homepage

UT-Forums: Level Design Linklist

Debian + GTKRadiant + Urban Terror HOW-TO

UT-Forums: Urban Terror GTKRadiant Tutorial Please note that the example
from this guide has no light and Urban Terror will just display black
walls.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Urban_Terror&oldid=233688"

Category:

-   Gaming
