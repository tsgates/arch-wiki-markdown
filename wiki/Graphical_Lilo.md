Graphical Lilo
==============

This document describes how to set up a graphical boot menu using lilo.
It outlines a generic way to do it for yourself, and also provides you
some defaults that look great with Arch.

Prepare your image
------------------

-   Find a background image you would like to use. It should be simple
    because you have to set it to 16 colours.
-   Open it in the gimp.
-   Scale it to 640x480.
-   Change it to indexed mode (Image-->Mode-->indexed).
-   Select "Create optimal palette" and set it to 16 colours. Choose
    whatever dithering method suits you.
-   Open the "Indexed Palette" dialog. Make note of which colours you
    want to use for menu text entries, the clock, etc. In your
    lilo.conf, you refer to the colours by index.
-   Save the image as a bmp in your /boot directory.

Prepare your Lilo.conf
----------------------

-   pacman -S lilo
-   Read man lilo.conf.
-   Read man lilo.conf again.
-   There are a few options that can be set for your graphical menu:
    -   bitmap=<bitmap-file> Set this to the file that you saved above.
        For example:

    bitmap=/boot/arch-lilo.bmp
    bmp-colors=<fg>,<bg>,<sh>,<hfg>,<hbg>,<hsh>

These are the colours of the entries in the menu. They refer to the
foreground, background, and shadow colours respectively, followed by the
same for highlighted text. Do not use spaces. The values used are
indices into the colour palette that you discovered in the previous
step. If you choose, you can leave a value blank (but do not forget the
comma). The default background is transparent, the default shadow is to
have none.

-   bmp-table=<x>,<y>,<ncol>,<nrow>,<xsep>,<spill> This option specifies
    where the menu is placed. x and y are the character coordinates. You
    can also suffix them with a p to specify pixel coordinates. man
    lilo.conf for the other options.
-   bmp-timer=<x>,<y>,<fg>,<bg>,<sh> This option specifies the
    coordinates and colour of the timer that counts down the timeout
    before booting a default entry. It uses colour indices for the
    colours, and character (or pixel) coordinates.
-   You can use these with the arch-lilo.bmp above:

      bitmap=/boot/arch-lilo.bmp
      bmp-colors=1,0,8,3,8,1
      bmp-table=250p,150p,1,18
      bmp-timer=250p,350p,3,8,1

-   Save your lilo.conf
-   Run lilo as root
-   Reboot and see how it looks

Retrieved from
"https://wiki.archlinux.org/index.php?title=Graphical_Lilo&oldid=219127"

Categories:

-   Boot loaders
-   Eye candy
