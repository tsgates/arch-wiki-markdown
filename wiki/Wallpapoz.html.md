Wallpapoz
=========

Wallpapoz is a tool that provides dynamic wallpapers for GNOME and XFCE
desktops. Moreover different wallpapers can be used for different
desktops. This article will explain how to install, configure and use
wallpapoz.

Contents
--------

-   1 Installation
    -   1.1 Configuration
    -   1.2 Start daemon
-   2 Script to add all images from a folder
-   3 See also

Installation
------------

Install wallpapoz from the Arch User Repository.

> Configuration

The configuration is done using an XML file that can look like the
following:

    .wallpapoz/wallpapoz.xml

    <?xml version="1.0" encoding="utf-8"?><!DOCTYPE Wallpapoz><wallpapoz interval="60" random="1" style="1" type="desktop">
        <file>/path/to/picture1.jpg</file>
        <file>/path/to/picture2.jpg</file>
        ...
    </wallpapoz>

All the settings can be done using the wallpapoz GUI.

> Start daemon

In order to use the daemon that changes the pictures, it can simply be
started using the terminal:

    $ /usr/bin/daemon_wallpapoz

To start the daemon automatically with every boot, a GNOME desktop file
can be written that executes the daemon everytime GNOME loads.

Write the following lines to .config/autostart/wallpapoz.desktop:

    [Desktop Entry]
    Type=Application
    Exec=/usr/bin/daemon_wallpapoz
    NoDisplay=true
    X-GNOME-Autostart-enabled=true
    Name=wallpapoz daemon
    Comment=start daemon for wallpapoz in order to change wallpaper dynamically

Script to add all images from a folder
--------------------------------------

The GUI is also able to add all images of a directory to the xml file.
If the content of a directory changes from time to time the GUI handling
is a bit suffisticated. To simplify the process of adding all images of
a directory to the xml file the following script can be used:

Copy the following lines to a new file ~/update-wallpapers, whereas the
bold printed parts should be specified:

    #!/bin/bash
    # works with wallpapoz

    WPDIR=/home/user/.wallpapoz
    FOLDER=/path/to/wallpaper/folder

    WPFILE=$WPDIR/wallpapoz.xml
    WPFILENEW=$WPDIR/wallpapoz.xml.new

    head -n 1 $WPFILE > $WPFILENEW
    i=0

    for file in $FOLDER/*.{jp*g,png}
    do
      echo "    <file>$file</file>" >> $WPFILENEW
      i=$[$i + 1]
    done

    echo "</wallpapoz>" >> $WPFILENEW

    mv $WPFILENEW $WPFILE

    echo "DONE: found $i files"

Make the file executable

    $ chmod +x update-wallpapers

Move the file to the PATH. This can either be done by adding the file to
the PATH manually or simply moving it to a directory which is already
part of the PATH:

    # mv update-wallpapers /usr/bin/

Whenever a new image is added to the folder the script has to be called
in order to add it to the xml file:

    $ update-wallpapers

The script takes the first line from the old version of the xml file to
keep the parameters like duration the same.

See also
--------

-   Project website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wallpapoz&oldid=279713"

Category:

-   Eye candy

-   This page was last modified on 25 October 2013, at 16:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
