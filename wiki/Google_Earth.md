Google Earth
============

From the project web page:

"Google Earth allows you to travel the world through a virtual globe and
view satellite imagery, maps, terrain, 3D buildings, and much more. With
Google Earth's rich, geographical content, you are able to experience a
more realistic view of the world. You can fly to your favorite place,
search for businesses and even navigate through directions."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Tips & Tricks                                                      |
|     -   2.1 Excessive memory usage                                       |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Google Earth crashes at startup                              |
|         -   3.1.1 1) Startup tips are enabled                            |
|         -   3.1.2 2) No new line at the end of ~/.drirc                  |
|                                                                          |
|     -   3.2 Earth shows nothing but yellow borders                       |
+--------------------------------------------------------------------------+

Installation
------------

Google Earth is not presently available in the Official Repositories,
and will need to be installed from the AUR.

The latest version is called google-earth and the legacy one (intended
for certain Intel users) google-earth6.

Tips & Tricks
-------------

> Excessive memory usage

The application's memory usage can be controlled either by limiting the
maximum cache size in Tools -> Options -> Cache or by lowering the
graphics settings in the 3D View tab.

Troubleshooting
---------------

Tip:The project has an official support forum for anything not covered
here.

Note:This section is currently useful for Intel card users only.

> Google Earth crashes at startup

1) Startup tips are enabled

The startup tips can be very useful but also known to cause crashes on
certain Intel cards. To disable them use enableTips=false in
~/.config/Google/GoogleEarthPlus.conf:

    $ sed -i "s|enableTips=.*|enableTips=false|" ~/.config/Google/GoogleEarthPlus.conf

2) No new line at the end of ~/.drirc

To prevent a crash with -dri drivers you may need to add a new line to
~/.drirc with:

    $ echo >> ~/.drirc

> Earth shows nothing but yellow borders

Taken from the changelog of 7.0.3 this issue has improved to some extent
but overall it's still there:

    Imagery now displays for Linux users running specific families of Intel GPUs.

The solution is to just stick with the legacy version called
google-earth6.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Google_Earth&oldid=254181"

Category:

-   Internet Applications
