Blackberry
==========

BlackBerry is a line of mobile e-mail and smartphone devices developed
by Canadian company Research In Motion (RIM). While including typical
smartphone applications (address book, calendar, to-do lists, etc., and
telephone capabilities), the BlackBerry is primarily known for its
ability to send and receive Internet e-mail wherever it can access a
mobile network of certain cellular phone carriers. It commands a 20.8%
share of worldwide smartphone sales, making it the second most popular
platform after Nokia's Symbian OS. The service is available in North
America and in most European countries.

Contents
--------

-   1 Synchronization Using barry
    -   1.1 Installing packages
    -   1.2 Creating a Sync Pair
    -   1.3 Sync and smile

> Synchronization Using barry

This example syncronizes your blackberrys contacts and calender with
your evolution contacts and calender. In theory the same princible
should be able to be applied to other mail and calander clients.
Including kmail and Google calender.

Installing packages

evolution - from the extra repository  
 msynctool-stable - from the AUR -
https://aur.archlinux.org/packages.php?ID=32917  
 libopensync-plugin-evolution2-stable - from the AUR -
https://aur.archlinux.org/packages.php?ID=39025  
 barry - from the AUR https://aur.archlinux.org/packages.php?ID=20874

When building barry, the PKGBUILD must be edited to enable the barry
opensync plugin to be built. This must be added to the configure line in
the PKGBUILD as shown below.

    ./configure --prefix=/usr --enable-gui --enable-opensync-plugin

Currently the barry opensync plugin will only build against
opensync-stable and msynctool-stable

Creating a Sync Pair

Setup evolution to use your liking if you have not done so already.

Create a sync group called evoberry

    msynctool --addgroup evoberry

  
 Add evolution and the blackberry to the sync group.

    msynctool --addmember evoberry evo2-sync
    msynctool --addmember evoberry barry-sync

  
 Configure the evolution member

    msynctool --configure evoberry 1

  
 Change the defaults to the location of your evolution files as shown in
the example

    <config>
    <address_path>file:///home/user/.evolution/addressbook/local/system</address_path>
    <calender_path>file:///home/user/.evolution/calendar/local/system</calender_path>
    <tasks_path>file:///home/user/.evolution/tasks/local/system</tasks_path>
    </config>

  
 Configure the blackberry member

    msynctool --configure evoberry 2

  
 Change the device number to your blackberry pin number as shown in the
example.

    #
    # This is the default configuration file for the barry-sync opensync plugin.
    # Comments are preceded by a '#' mark at the beginning of a line.
    # The config format is a set of lines of <keyword> <values>.
    #
    # Keywords available:
    #
    # DebugMode        - If present, verbose USB debug output will be enabled
    #
    # Device           - If present, it is followed by the following values:
    #      PIN number    - PIN number of the device to sync with (in hex)
    #      sync calendar - 1 to sync calendar, 0 to skip
    #      sync contacts - 1 to sync contacts, 0 to skip
    #
    # Password secret  - If present, specifies the device's password in plaintext
    #

    #DebugMode

    Device 00000000 1 1

    #Password secret

Sync and smile

Make sure evolution is closed and your blackberry is connected then
issue the sync command.

    msynctool --sync evoberry

Retrieved from
"https://wiki.archlinux.org/index.php?title=Blackberry&oldid=206830"

Category:

-   Mobile devices

-   This page was last modified on 13 June 2012, at 14:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
