Minecraft
=========

Contents
--------

-   1 Installation
-   2 Running Minecraft
-   3 Extras
    -   3.1 AMIDST
    -   3.2 mapcrafter
    -   3.3 Minutor
-   4 Minecraft Server
    -   4.1 Extras
-   5 Useful links

Installation
------------

minecraft is available in the AUR. This package includes the official
game launcher plus a script to launch it.

Otherwise, just get the launcher on the official download site.

Running Minecraft
-----------------

If you installed Minecraft from the AUR, you can use the included
script:

    $ minecraft

Otherwise, you will need to manually launch Minecraft:

    $ java -jar Minecraft.jar

Extras
------

There are several programs and editors which can make your Minecraft
experience a little easier to navigate. The most common of these
programs are map generators. Using one of these programs will allow you
to load up a Minecraft world file and render it as a 2D image, providing
you with a top-down map of the world.

> AMIDST

AMIDST (Advanced Minecraft Interface and Data/Structure Tracking) is a
program that aids in the process of finding structures, biomes, and
players in Minecraft worlds. It can draw the biomes of a world out and
show where points of interest are likely to be by either giving it a
seed, telling it to make a random seed, or having it read the seed from
an existing world (in which case it can also show where players in that
world are). amidst is available in the AUR.

> mapcrafter

mapcrafter is a fast Minecraft Map Renderer which renders worlds to maps
with an 3D-isometric perspective. You can view these maps in any
webbrowser and you can host them with a webserver for example for the
players of your server. mapcrafter has a simple configuration file
format to specify worlds to render, different rendermodes such as
day/night/cave and can also render worlds from different rotations.
mapcrafter-git is available in the AUR.

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

Useful links
------------

-   Main site : http://www.minecraft.net/
-   Community links: http://www.minecraft.net/community
-   Crafting recipies : http://www.minecraftwiki.net/wiki/Crafting
-   Data values (useful in multiplayer mode) :
    http://www.minecraftwiki.net/wiki/Data_values
-   Reddit community : http://www.reddit.com/r/minecraft

Retrieved from
"https://wiki.archlinux.org/index.php?title=Minecraft&oldid=306010"

Category:

-   Gaming

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
