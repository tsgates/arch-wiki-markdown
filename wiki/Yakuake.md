Yakuake
=======

Summary help replacing me

This article demonstrates the installation of Yakuake

> Related

KDE

Yakuake is a top-down terminal for KDE (in the style of Guake for Gnome,
Tilda or the terminal used in Quake).

Installation
------------

Install yakuake, available in the official repositories.

Usage
-----

Once installed, you can start Yakuake from the terminal with:

    $ yakuake

After yakuake has started you can click on configure yakuake by clicking
on the "Open Menu" button (middle button on the bottom right hand side
of the interface) and select "Configure Shortcuts" to change the hotkey
to drop/retract the terminal automatically, by default it is set to F12.

Starting Yakuake with user defined sessions
-------------------------------------------

Like Guake Yakuake allows the user to invoke a shell script for instance
to load Yakuake with user's defined sessions. In a nutshell, Yakuake can
be launched and for instance when the hotkey to drop the terminal down
will start showing all the individual tab(s) and their programs as the
user defined in their own respective tab(s). Furthermore, like Guake
Yakuake also allows one to define the name for each and every specific
name of their tab(s).

However, Yakuake relies on Qt framework and therefore the syntaxes for
invoking the spawning/renaming/executing tab(s) are not the same as
Guake. Below is a rough guide on setting up Yakuake to spawn user
defined sessions (as tested working with 2.9.9-1).

    ~/editme.sh

    # Starting yakuake based on user preferences. Information based on http://forums.gentoo.org/viewtopic-t-873915-start-0.html
    # Adding sessions from previous website is broken, use this: http://pawelkoston.pl/blog/sublime-text-3-cheatsheet-modules-web-develpment/
    # This line is needed in case yakuake does not accept fcitx inputs.
    /usr/bin/yakuake --im /usr/bin/fcitx --inputstyle onthespot
     
    # Start iotop in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 0 "iotop" 
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 0 "iotop"
     
    # Start htop in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 1 "htop"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 1 "htop"
     
    # Start atop in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 2 "atop"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 2 "atop"
     
    # Start (watching) iptables in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 3 "iptables -nvL"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 3 "~/.iptables.sh"
     
    # Start journalctl --follow --full in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 4 "journalctl"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 4 "journalctl --follow --full"
     
    # Start irssi in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 5 "irssi"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 5 "irssi"
     
    # Start root shell 1 in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 6 "rootshell0"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 6 "sudo -i"
     
    # Start root shell 2 in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 7 "rootshell1"
    qdbus-qt4 org.kde.yakuake /yakuake/sessions runCommandInTerminal 7 "sudo -i"
     
    # Start shell 1 in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 8 "shell0"
     
    # Start shell 2 in its own tab.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession
    qdbus-qt4 org.kde.yakuake /yakuake/tabs setTabTitle 9 "shell1"
     
    # Kill default (and now redundant) new shell tab. Already there are two shells each opened for both root and user.
    qdbus-qt4 org.kde.yakuake /yakuake/sessions org.kde.yakuake.removeSession 10

Retrieved from
"https://wiki.archlinux.org/index.php?title=Yakuake&oldid=303116"

Category:

-   Terminal emulators

-   This page was last modified on 4 March 2014, at 03:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
