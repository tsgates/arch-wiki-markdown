League of Legends
=================

There is currently only a Mac OS and a Windows version of LoL even if
there is a petition for a GNU/Linux port. This page outlines working
methods to get the Windows League of Legends version working on your
arch system through Wine.

Warning:Since last patch (3.11) starting a game (of any type) will cause
the program to crash after the champion selection countdown. For further
information check the page on WineHQ for version 4.1: [[1]]

Contents
--------

-   1 PlayonLinux Method
-   2 Chroot Method
    -   2.1 Setup
        -   2.1.1 Set up a chroot
            -   2.1.1.1 Install your graphics drivers
            -   2.1.1.2 Install wine in your chroot
            -   2.1.1.3 Create a wine PREFIX
            -   2.1.1.4 Install the following in chroot
        -   2.1.2 Set up your base system
            -   2.1.2.1 Install the following in your base system
    -   2.2 Install
        -   2.2.1 Download the LoL installer
        -   2.2.2 Download the Game
        -   2.2.3 Install the Game
        -   2.2.4 Patch the game
        -   2.2.5 Running the Game
-   3 Troubleshooting

PlayonLinux Method
------------------

Note: This method did not work previously and it was advised to set up a
chroot; which is outlined in the next section. However, it works now,
regardless of architecture.

This is the easiest method. Just install playonlinux.

After installation run from the command line

    $ playonlinux

When you first run it, playonlinux will install some necessary fonts.
Afterwards, click Install, check the "testing box" and then search for
"League of Legends". The rest is self-explanatory. Enjoy!

Chroot Method
-------------

> Setup

Note: If your architecture is i686, you can skip setting up the chroot.
But, make sure that Windows XP is set in your winecfg.

Set up a chroot

The way to do this is outlined in Install bundled 32-bit system in
Arch64. An even easier method is to install arch32-light from the AUR
[which automates the steps outlined in the wiki article cited].

Install your graphics drivers

You will need to install your graphics drivers inside the chroot. You
will need hardware acceleration drivers as well.

Install wine in your chroot

Create a wine PREFIX

Run:

    # schroot -p winecfg 

to create a default 32-bit prefix at $HOME/.wine and take the chance to
verify that it is set on Windows XP

Note: If you do not have schroot installed, follow the following guide
to set it up: Install bundled 32-bit system in Arch64#Install and
Configure Schroot

Install the following in chroot

Note: The following list is compiled from different users on different
systems. Other users might need more or less than what is listed here.
If you need something not listed here, please add it to the list.

-   gnutls
-   lcms
-   samba

Set up your base system

Install wine and winetricks in your base system.

Install the following windows components using winetricks from your base
system:

    # winetricks d3dx9 vcrun2005 wininet corefonts

Install the following in your base system

Note: The following list is compiled from different users on different
systems. Other users might need more or less than what is listed here.
If you need something not listed here, please add it to the list.

-   lib32-libldap: This is required for running the installer

> Install

Download the LoL installer

You can download the installer from the league of legends website:

League of Legends

Download the Game

Run the following command from your base system:

    # GC_DONT_GC=1 wine $directory/LeagueofLegends.exe

where $directory is the directory where the installer is located.

Install the Game

Install the game from your base system. Find the setup.exe file and go

    # wine setup.exe

Note: This may happen automatically when the download finishes

Patch the game

Download

LoL-Linux-Tools

Follow the included instructions and apply the texture patch. This will
prevent the game from crashing when you open the in-game store.

Running the Game

Create a bash script with the following commands:

    #!/bin/sh
    cd "$HOME/.wine/drive_c/Riot Games/League of Legends/RADS/system/"
    schroot -p -- wine "rads_user_kernel.exe" run lol_launcher $(ls ../projects/lol_launcher/releases/) LoLLauncher.exe

Run the bash script and you should be good to go!

Enjoy playing LoL on your Arch System!!!!

Troubleshooting
---------------

-   In case of flashing minimap or exceedingly low FPS try disabling HUD
    animations in the in-game options for notable boost in performance.

-   On certain intel cards, enabling vertical sync can lead to a big
    boost in performance.

-   If the game crashes after champion select make sure to replace
    'localhost' with your real hostname in /etc/hosts.

-   If you have no sound make sure alsa-lib is installed inside your
    chroot.

-   If the launcher is all black, maybe you forgot to install your
    graphics drivers inside your chroot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=League_of_Legends&oldid=296386"

Category:

-   Gaming

-   This page was last modified on 6 February 2014, at 13:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
