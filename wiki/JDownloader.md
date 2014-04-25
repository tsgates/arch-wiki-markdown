JDownloader
===========

  
 JDownloader is a Download Manager written in Java. JDownloader can
download normal files, but also files from online file hosting services
like Rapidshare.com.

Contents
--------

-   1 Installation
    -   1.1 Requirements
    -   1.2 Installing
    -   1.3 Running
-   2 Configuration
-   3 Tips and tricks
    -   3.1 Making JDownloader faster
-   4 Alternatives

Installation
------------

> Requirements

For running JDownloader you need Java installed. I recommend OpenJDK, it
works flawless with jDownloader.

    # pacman -S jre7-openjdk

> Installing

You can use the jdownloader package in the AUR.

> Running

Use the command jdownloader to start JDownloader. When you just
installed JDownloader from AUR, this will run the update tool to
download some required files for JDownloader, else this will start
JDownloader directly.

Configuration
-------------

When you first start JDownloader you can choose your preferred language
and also your download directory. On the next window, JDownloader asks
you if you want to install FlashGot, a Firefox extension. I recommend
clicking on Cancel. If you want this extension, you can still download
it through the official mozilla addons website.

If you enable the Light(GTK) theme and the fonts appear to lack
anti-aliasing, modify ~/.bashrc as appropriate following the directions
here.

Tips and tricks
---------------

> Making JDownloader faster

In its default configuration, JDownloader is very slow and uses a lot of
resources. You can atleast make it a bit faster by applying the
following changes in the Settings Tab.

Choose General and then turn the logging level to OFF.

Choose User Interface and then switch the style to Light(GTK). (If
you're using GNOME).

Alternatives
------------

Tucan Manager available in the official repositories through the tucan
package.

uGet available in the official repositories through the uget package
(GTK).

pyLoad available in AUR.

plowshare available in AUR (CLI).

FreeRapid Downloader available in AUR (Java).

Retrieved from
"https://wiki.archlinux.org/index.php?title=JDownloader&oldid=302644"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
