Flash DRM content
=================

DRM content on Flash still requires HAL to play. This is apparent for
example with Google Play Movies or Amazon Instant Video. If you attempt
to play a DRM-protected content without HAL, you may see the following
error: an error occurred and your player could not be updated.

To deliver DRM-protected content, Flash calls several functions provided
by the HAL daemon and its libraries. While Flash-based players remain
popular, HAL has been deprecated and is not commonly installed on newer
systems. To provide the necessary HAL functionality on such systems, you
can either install the full HAL package and run the HAL daemon or
install a modified HAL library "stub" that uses the modern UDisks daemon
instead.

Contents
--------

-   1 Using the HAL package
    -   1.1 Running the HAL daemon
-   2 Using the modified libhal stub
    -   2.1 Installing UDisks and hal-flash
    -   2.2 Running UDisks
-   3 Remove Flash Player cached files
-   4 See also

Using the HAL package
---------------------

Install the hal package from the AUR. You will need to install hal-info
first as it is a dependency for hal.

> Running the HAL daemon

The HAL daemon is managed by hal.service, which can be controlled by
systemctl.

Alternatively, one can use the following script, which also takes care
of cleaning the cache.

    #!/bin/bash

    ## written by Mark Lee <bluerider>
    ## using information from <https://wiki.archlinux.org/index.php/Chromium#Google_Play_.26_Flash>

    ## Start and stop Hal service on command for Google Play Movie service

    function main () {  ## run the main insertion function
         clear-cache;  ## remove adobe cache
         start-hal;  ## start the hal daemon
         read -p "Press 'enter' to stop hal";  ## pause the command line with a read line
         stop-hal;  ## stop the hal daemon
    }

    function clear-cache () {  ## remove adobe cache
         cd ~/.adobe/Flash_Player;  ## go to Flash player user directory
         rm -rf NativeCache AssetCache APSPrivateData2;  ## remove cache
    }

    function start-hal () {  ## start the hal daemon
         sudo systemctl start hal.service && ( ## systemd : start hal daemon
              echo "Started hal service..."
    ) || (
              echo "Failed to start hal service!") 
    }

    function stop-hal () {  ## stop the hal daemon
    sudo systemctl stop hal.service && (  ## systemd : stop hal daemon
              echo "Stopped hal service..."
         ) || (
              echo "Failed to stop hal service!"
         )
    }

    main;  ## run the main insertion function

Using the modified libhal stub
------------------------------

As an alternative to installing all of HAL, you can install a modified
version of the libhal library from the AUR that uses the modern UDisks
daemon instead of the deprecated HAL. Note that this libhal provides
just enough of the HAL functionality to meet Flash's needs for
copy-protected delivery: if you have other programs that require HAL,
this stub probably won't satisfy them and you should use the full hal
package instead.

> Installing UDisks and hal-flash

You will need to install hal-flash from the AUR, which relies on UDisks.

> Running UDisks

Since the libhal stub passes its calls to UDisks, UDisks should be
running before you attempt to play DRM-protected Flash videos.

Make sure that udisks.service is started, see systemd#Using units for
details.

Remove Flash Player cached files
--------------------------------

To get a fresh start after installing the package(s), remove some Flash
Player cached files:

    $ cd ~/.adobe/Flash_Player
    $ rm -rf NativeCache AssetCache APSPrivateData2

See also
--------

-   Watching movies from Google Play on Arch Linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Flash_DRM_content&oldid=290764"

Category:

-   Player

-   This page was last modified on 29 December 2013, at 11:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
