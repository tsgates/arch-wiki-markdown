Google Earth
============

From the project web page:

"Google Earth allows you to travel the world through a virtual globe and
view satellite imagery, maps, terrain, 3D buildings, and much more. With
Google Earth's rich, geographical content, you are able to experience a
more realistic view of the world. You can fly to your favorite place,
search for businesses and even navigate through directions."

Contents
--------

-   1 Installation
-   2 Tips and tricks
    -   2.1 Excessive memory usage
-   3 Troubleshooting
    -   3.1 Another crash happened while handling crash!
    -   3.2 Crash on startup
        -   3.2.1 1) Startup tips are enabled
        -   3.2.2 2) No new line at the end of ~/.drirc
        -   3.2.3 3) fglrx/Catalyst
    -   3.3 Panoramio photos not working
    -   3.4 Earth shows nothing but yellow borders

Installation
------------

Google Earth is not presently available in the Official repositories,
and will need to be installed from the AUR.

The latest version is called google-earth and the legacy one
google-earth6.

Tips and tricks
---------------

> Excessive memory usage

The application's memory usage can be controlled either by limiting the
maximum cache size in Tools > Options > Cache or by lowering the
graphics settings in the 3D View tab.

Troubleshooting
---------------

Tip:The project has an official support forum for anything not covered
here.

> Another crash happened while handling crash!

If you get this error you need to remove the following files:

    $ rm ~/.googleearth/instance-running-lock
    $ rm ~/.googleearth/Cache/cookies

> Crash on startup

Google Earth can crash on startup for numerous reasons. Here are some of
the most common ones.

1) Startup tips are enabled

The startup tips can be very useful but also known to cause crashes. To
disable them, use:

    ~/.config/Google/GoogleEarthPlus.conf

    [General]
    enableTips=false

2) No new line at the end of ~/.drirc

To prevent a crash with -dri drivers you may need to add a new line to
~/.drirc with:

    $ echo >> ~/.drirc

3) fglrx/Catalyst

Google Earth does not currently work for some fglrx/Catalyst users.

The solution is to either use the open source drivers or the legacy
google-earth6.

> Panoramio photos not working

There has been numerous reports on this in the Google Earth forums with
varying solutions.

A fallback to the legacy google-earth6 may be required.

> Earth shows nothing but yellow borders

Taken from the changelog of 7.0.3 this issue has improved to some extent
but overall it's still there:

    Imagery now displays for Linux users running specific families of Intel GPUs.

The solution is to use the legacy google-earth6.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Google_Earth&oldid=304639"

Category:

-   Internet applications

-   This page was last modified on 15 March 2014, at 21:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
