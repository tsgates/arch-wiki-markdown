Redshift
========

The website states:

"Redshift adjusts the color temperature of your screen according to your
surroundings. This may help your eyes hurt less if you are working in
front of the screen at night. This program is inspired by f.lux [...]."

The project is developed on launchpad.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Quick start
    -   2.2 Automatic location based on GPS
    -   2.3 Manual setup
-   3 Troubleshooting
    -   3.1 Missing dependency
-   4 See also

Installation
------------

The redshift package is available in the Official repositories.

Note:If Redshift will not start, see section #Troubleshooting.

Configuration
-------------

Redshift will at least need your location to start, meaning the latitude
and longitude of your location. Redshift employs several routines for
obtaining your location. If none of them works (e.g. none of the used
helper programs is installed), you need to enter your location manually:
For most places/cities an easy way is to look up the wikipedia page of
that place and get the location from there (search the page for
"coordinates").

> Quick start

To just get it up and running with a basic setup, issue:

     $ redshift -l LAT:LON

where LAT is the latitude and LON is the longitude of your location.

> Automatic location based on GPS

You can also use gpsd to automatically determine your GPS location and
use it as an input for Redshift. Create the following script and pass
$lat and $lon to redshift -l $lat;$lon:

    #!/bin/bash
    date
    #gpsdata=$( gpspipe -w -n 10 |   grep -m 1 lon )
    gpsdata=$( gpspipe -w | grep -m 1 TPV )
    lat=$( echo "$gpsdata"  | jsawk 'return this.lat' )
    lon=$( echo "$gpsdata"  | jsawk 'return this.lon' )
    alt=$( echo "$gpsdata"  | jsawk 'return this.alt' )
    dt=$( echo "$gpsdata" | jsawk 'return this.time' )
    echo "$dt"
    echo "You are here: $lat, $lon at $alt"

For more information, see this forums thread.

> Manual setup

Redshift reads the configuration file ~/.config/redshift.conf, if it
exists. However, Redshift does not create that configuration file, so
you have to create it manually. Example for Hamburg/Germany:

    ~/.config/redshift.conf

    ; Global settings
    [redshift]
    temp-day=5700
    temp-night=3500
    transition=1
    gamma=0.8:0.7:0.8
    location-provider=manual
    adjustment-method=vidmode

    ; The location provider and adjustment method settings
    ; are in their own sections.
    [manual]
    ; Hamburg
    lat=53.3
    lon=10.0

    ; In this example screen 1 is adjusted by vidmode. Note
    ; that the numbering starts from 0, so this is actually
    ; the second screen.
    [vidmode]
    screen=0
    screen=1

After you created that file, start redshift from the menu of your DE
(called "redshift-gtk") or type the following in your terminal:

     $ redshift-gtk &

Using "redshift-gtk" instead of "redshift" launches Redshift with a
system tray icon for easier handling of the application. Finally, if you
want to start Redshift automatically on system startup, rightclick the
system tray icon an check "Autostart".

Troubleshooting
---------------

> Missing dependency

python2-xdg, librsvg and pygtk are needed for redshift-gtk. They are the
optional dependencies for the redshift package. If you run into problems
when trying to run redshift-gtk, check if they are installed. If they
are not installed, install them as a dependency:

     # pacman --asdeps -S python2-xdg librsvg pygtk

See also
--------

-   Redshift website
-   Redshift on launchpad

Retrieved from
"https://wiki.archlinux.org/index.php?title=Redshift&oldid=303578"

Categories:

-   X Server
-   Graphics
-   Eye candy
-   Audio/Video

-   This page was last modified on 8 March 2014, at 08:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
