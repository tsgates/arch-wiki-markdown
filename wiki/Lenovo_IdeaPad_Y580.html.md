Lenovo IdeaPad Y580
===================

The Lenovo IdeaPad Y580 is for the most part compatible with Arch Linux.
The wireless and wired chip, Bluetooth, and graphics are all supported.
The only troublesome step is enabling graphics; see the sections below
for further info.

> Intel graphics

This machine has two video cards, an Intel HD 4000 integrated chip and a
discrete Nvidia GTX 660M.

If you only wish to use the Intel chip, for improved battery life, lower
temperatures, or less complexity, you can simply install
xf86-video-intel and use the Intel driver. This will leave the NVIDIA
card disabled, but it will still use power. To completely disable the
NVIDIA card, enter the Y580's BIOS and on the "Configuration" tab,
change "Graphic Device" from "Switchable Graphic" to "UMA Graphic". If
these options are not there, you may need to update the BIOS.

> NVIDIA graphics

The Intel card cannot be disabled in BIOS, so Optimus must be configured
in order to access the NVIDIA graphics. See the wiki page on Optimus for
an in-depth description of the process.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_IdeaPad_Y580&oldid=279231"

Category:

-   Lenovo

-   This page was last modified on 21 October 2013, at 02:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
