Aion
====

Aion The Tower of Eternity (Korean: 아이온: 영원의 탑) is a massively
multiplayer online role-playing game (MMORPG) released in Korea, China,
North America, Australia and Europe.

Aion was (up until May 20, 2009) known as "Aion: The Tower of Eternity"
but it was released in North America under the one-word title of Aion.
The game developer is NCsoft's Aion Team Development Dept, a major
Korean game developer. Aion combines PvP and PvE (a concept the
developers call PvPvE) in a fantasy game environment.

A feature of the game is flight, which is mainly used as a means for
combat. Other games in this genre typically offer flight only as a means
of travel, while combat stays on the ground. It currently has 7 million
subscribers.

This article will describe how install and run it using Wine &
Virtualbox.

Contents
--------

-   1 Installation and setup
    -   1.1 Temporary solution for installing/patching
    -   1.2 Wine
-   2 Running Aion

Installation and setup
----------------------

Aion doesn't work "out of the box" on Linux system, you need to copy the
updated directory from a Windows system to your Linux system.

> Temporary solution for installing/patching

If you have a Windows system on a separate machine, install and update
the game from there before copying it to your Wine directory.

If you don't, you need to install Virtualbox, and Virtualbox-additions.

     pacman -S virtualbox-ose virtualbox-additions

Add your user to the vboxusers group

     # gpasswd -a USERNAME vboxusers

Then edit /etc/rc.conf as root and add vboxdrv to the MODULES array in
order to load the VirtualBox drivers at startup. For example:

     MODULES=(loop vboxdrv fuse ...)

Create a new virtual machine and install Windows.Once installed, do not
forget to share the /home/username/.wine (replace username with your
user) with your virtual machine to minimize virtual machine disk
consumption.

Install & update the game in your virtual or separate Windows.

> Wine

Install wine using pacman:

     pacman -S wine

To make the game run in wine you have to install winetricks:

     pacman -S winetricks

Using winetricks you must install: d3dx9, vcrun2005 (sp1) and dotnet20

     sh winetricks d3dx9 vcrun2005 dotnet20

The game opens large amount of file descriptors, therefore you must
raise the security limit for your user:

As root add the following lines to /etc/security/limits.conf:

     yourusername soft nofile 8192
     yourusername hard nofile 8192

Replace yourusername with your user

Save files and reboot to make changes go in effects. Confirm if it works
by writing into terminal­:

     ulimit -n

Running Aion
------------

Source :
http://appdb.winehq.org/objectManager.php?sClass=version&iId=17877

You can finally run the game using this command in the Aion directory:

For EU users:

     wine b­in32\aion.bin -ip:206.127.147.28 -port:2106 -cc:2 -noauthgg -lang:enu -noweb

For US users:

     wine  bin32\aion.bin -ip:206.127.153.247 -port:2106 -cc:1 -noauthgg -lang:enu -noweb­

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aion&oldid=198118"

Categories:

-   Gaming
-   Wine

-   This page was last modified on 23 April 2012, at 17:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
