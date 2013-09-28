Minecraft
=========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setting Up Java                                                    |
|     -   2.1 OpenJDK6                                                     |
|     -   2.2 OpenJDK7                                                     |
|     -   2.3 LWJGL                                                        |
|                                                                          |
| -   3 Running Minecraft                                                  |
| -   4 Extras                                                             |
|     -   4.1 Minutor                                                      |
|                                                                          |
| -   5 Minecraft Server                                                   |
|     -   5.1 Extras                                                       |
|                                                                          |
| -   6 Mods                                                               |
| -   7 Useful links                                                       |
+--------------------------------------------------------------------------+

Installation
------------

minecraft is available in the AUR. This package includes the official
game plus a script for launching it.

Setting Up Java
---------------

Minecraft should work out-of-the-box with a couple of the various Java
JREs.

> OpenJDK6

Minecraft should 'just work' with OpenJDK6. Install it from community:

    # pacman -S openjdk6

> OpenJDK7

OpenJDK7 works with Minecraft too:

    # pacman -S jre7-openjdk

> LWJGL

If Minecraft has issues (sticky keys, stuck on pause menu, etc.), you
can force it to use the newest version of LWJGL.

Warning:The OpenGL implementation provided by at least some proprietary
NVIDIA drivers (nvidia-304xx) is incompatible with the version of LWJGL
that minecraft provides. For these systems, it may be necessary to
update LWJGL for minecraft to run, or switch to the nouveau driver.

-   Download LWJGL 2.8.5 from here
-   Replace the following files in .minecraft/bin/ with the
    corresponding versions in lwjgl-2.8.5/jar

    jinput.jar
    lwjgl.jar
    lwjgl_util.jar 

-   Replace the following files in .minecraft/bin/natives/ with
    lwjgl-2.8.5/natives/linux

    libjinput-linux.so
    libjinput-linux64.so
    liblwjgl.so
    liblwjgl64.so
    libopenal.so
    libopenal64.so

Running Minecraft
-----------------

If you installed Minecraft from the AUR, you can use the included
script:

    $ minecraft

Otherwise, you will need to manually launch Minecraft:

    $ java -jar $HOME/.minecraft/minecraft.jar

To allocate more RAM to the game, include Xms and Xmx arguments:

    $ java -jar -Xms1024M -Xmx2048M $HOME/.minecraft/minecraft.jar

You can change these depending on the amount of RAM that you have. The
Xms argument specifies the minimum amount of RAM to allocate to the
program, and the Xmx argument specifies the maximum amount.

Extras
------

There are several programs and editors which can make your Minecraft
experience a little easier to navigate. The most common of these
programs are map generators. Using one of these programs will allow you
to load up a Minecraft world file and render it as a 2D image, providing
you with a top-down map of the world.

> Minutor

Minutor is described as a minimalistic map generator for Minecraft.
Don't let this mislead you, it generates maps of existing worlds, not
the other way around. You are provided with a simple GTK based interface
for viewing your world. Several rendering modes are available, as well
as custom coloring modes and the ability to slice through z-levels.
minutor is available in the AUR.

Minecraft Server
----------------

There are two AUR packages for easy installation of a minecraft server.
For a server compatible with systemd, install aur/minecraft-server and
then enable the service:

    $ systemctl enable minecraftd
    $ systemctl start minecraftd

-   Monitor the minecraft server by running the below command as root:

    # screen -r

(Remember that one can exit screen sessions with ^A,D)

Note:This creates a user called minecraft with a home directory at
/srv/minecraft. Add your user to the minecraft group to modify minecraft
settings.

For a server that uses the legacy rc scripts, install
aur/minecraft-server

You can also run a dedicated Minecraft server:

-   Follow the steps above to install Java
-   Download the multiplayer server from the Minecraft site
-   Run the server:

    $ java -Xmx2048M -Xms2048M -jar minecraft_server.jar nogui

(You can sub the -Xmx and -Xms values for the amount of memory you want
your server to use. A good rule of thumb is one GB per ten users.)

-   To configure the server, take a look at this wiki page.

> Extras

-   Establishing a Minecraft-specific user is recommended for security.
    By running Minecraft under an unprivileged user account, anyone who
    successfully exploits your Minecraft server will only get access to
    that user account, and not yours.
-   To leave the server running unattended, look into tmux or screen.
-   You may wish to modify your server, to provide additional features:
    -   Server Wrappers are one way to add administrative capabilities.
    -   Bukkit is a powerful modding API, with a wide variety of plugins
        available.
        -   If installing the Dynmap plugin, you will need to install
            fontconfig and libcups to get it to work.

-   You might even set up a cron job with a mapper to generate periodic
    maps of your world.
-   ...or you could use rsync to perform routine backups.

Mods
----

-   Terrafirmacraft : http://www.terrafirmacraft.com
-   Technic pack / Tekkit : http://www.technicpack.net
-   Feed The Beast Mod Pack :
    https://aur.archlinux.org/packages/feedthebeast/
-   List of mods :
    http://www.minecraftforum.net/topic/1434593-list-of-mods-for-146147-and-from-132-onward/#t

  

Useful links
------------

-   Main site : http://www.minecraft.net/
-   Community links: http://www.minecraft.net/community
-   Crafting recipies : http://www.minecraftwiki.net/wiki/Crafting
-   Data values (useful in multiplayer mode) :
    http://www.minecraftwiki.net/wiki/Data_values
-   Reddit community : http://www.reddit.com/r/minecraft
-   MineTest Tutorial :
    http://gotux.net/arch-linux/minetest-game-server/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Minecraft&oldid=252222"

Category:

-   Gaming
