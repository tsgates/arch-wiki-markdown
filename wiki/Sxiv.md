sxiv
====

Summary help replacing me

This article discusses the installation and basic configuration of sxiv.

> Related

feh

External Links

sxiv on github

sxiv, Simple X Image Viewer is a lightweight and scriptable image viewer
written in C.

Contents
--------

-   1 Installation
-   2 Assigning keyboard shortcuts to sxiv
-   3 Tips and tricks
    -   3.1 Browse through images in directory after opening a single
        file
    -   3.2 Showing the image size in the status bar
-   4 See also

Installation
------------

Install sxiv, which is available in the official repositories.

Assigning keyboard shortcuts to sxiv
------------------------------------

Note:Currently you need to use sxiv-git from AUR for this feature to
work.

sxiv supports external key events. First you have to press Ctrl-x to
send the next key to the external key-handler. The external key-handler
requires an executable file ~/.config/sxiv/exec/key-handler and passes
the key combination pressed as well the name of the current image as
arguments.

In this example, we will add the bindings Ctrl+d to execute
mv filename ~/.trash, Ctrl+c to copy the current image's name to the
clipboard with xclip, and Ctrl+w to set the current wallpaper with
nitrogen.

    ~/.config/sxiv/exec/key-handler

    #!/bin/sh

    case "$1" in
    "C-d")
            mv "$2" ~/.trash ;;
    "C-c")
            echo -n "$2" | xclip -selection clipboard ;;
    "C-w")
            nitrogen --save --set-zoom-fill "$2" ;;
    esac

Be sure to mark the script as executable

    $ chmod +x ~/.config/sxiv/exec/key-handler

Create .trash folder if it does not exist:

    $ mkdir ~/.trash

Tip:You may want to use a standards-compliant trashcan (like trash-cli
or bashtrash) rather than mv "$2" ~/.trash.

Tips and tricks
---------------

> Browse through images in directory after opening a single file

Place this script in /usr/local/bin and call it like this:

    $ scriptname a_single_image.jpg

Alternatively you can also install the script as a package from the AUR:
sxiv-rifle.

As indicated in the comments of the script, it may be used to have this
behavior when opening images from within ranger.

> Showing the image size in the status bar

Place the following executable script in ~/.config/sxiv/exec/image-info
and make sure that you have the exiv2 package installed:

    ~/.config/sxiv/exec/image-info

    #!/bin/sh

    # Example for ~/.config/sxiv/exec/image-info
    # Called by sxiv(1) whenever an image gets loaded,
    # with the name of the image file as its first argument.
    # The output is displayed in sxiv's status bar.

    s=" | " # field separator

    filename=$(basename "$1")
    filesize=$(du -Hh "$1" | cut -f 1)

    geometry=$(identify -format '%wx%h' "$1[0]")

    tags=$(exiv2 -q pr -pi "$1" | awk '$1~"Keywords" { printf("%s,", $4); }')
    tags=${tags%,}

    echo "${filesize}${s}${geometry}${tags:+$s}${tags}${s}${filename}"

See also
--------

-   Arch Linux forum thread.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sxiv&oldid=306018"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
