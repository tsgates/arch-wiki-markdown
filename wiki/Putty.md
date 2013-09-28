Putty
=====

Setting Up Putty
----------------

Settings -> Connection -> Data : Terminal-type string = xterm-256color

See 256colours for more info on setting up 256 colour mode for Putty.

To test colors in a linux console, execute the following in a terminal:
reference

    for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done

Desktop Icons and menu
----------------------

install putty-freedesktop from AUR, for a freedesktop.org menu item with
icons.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Putty&oldid=251755"

Category:

-   Terminal emulators
