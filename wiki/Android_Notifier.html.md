Android Notifier
================

Android Notifier is a linux application that receives notifications on
sms, mms, battery status and more from your phone to your Linux, Mac or
Windows PC. This article is about installing and running it in the
background on Arch Linux.  
 You will need the android app Remote Notifier installed on your phone
which is available for free at Google Play.

Contents
--------

-   1 Prerequisites
-   2 Installation
-   3 Configuration
-   4 Starting android-notifier

Prerequisites
-------------

-   Android app installed on your phone: Remote Notifier by Rodrigo
    Damazio, from Google Play or F-Droid.
    -   Author's site
    -   More at Appbrain
-   Port 10600 tcp/udp open in your firewall (iptables rules coming
    soon...)

Installation
------------

Get it from AUR: android-notifier-desktop

Configuration
-------------

To configure android-notifier, run
/usr/share/android-notifier-desktop/run.sh -p.

To show help run /usr/share/android-notifier-desktop/run.sh -h.

Starting android-notifier
-------------------------

Add this command to for example .xinitrc:

    /usr/share/android-notifier-desktop/run.sh &

Or just run it from terminal.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android_Notifier&oldid=302106"

Category:

-   Status monitoring and notification

-   This page was last modified on 25 February 2014, at 20:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
