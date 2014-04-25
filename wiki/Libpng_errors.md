Libpng errors
=============

Contents
--------

-   1 Problem
-   2 Solution
    -   2.1 GIMP
    -   2.2 ImageMagick

Problem
-------

Some changes in libpng 1.6+ cause it issue warning or even not work
correctly with the original HP/MS sRGB profile. You'll notice this in
stderr:

    libpng warning: iCCP: known incorrect sRGB profile

The old profile uses a D50 whitepoint, where D65 is standard. This
profile is not uncommon, being used by Adobe Photoshop, although it was
not embedded into images by default.

Solution
--------

The simplest solution is simply to remove the embedded profile from your
image. This can cause a slight shift in color *IF* have have a properly
calibrated system, monitor, and software. If you really need it (say for
a print shop), you can alternatively embed a different color profile. If
this applies to you, you probably have the profiles you need already.

> GIMP

To remove the embedded profile, go to
Image > Mode > Assign Color Profile and set it to
RGB workspace(sRGB built-in)

To change the embedded profile, go to
Image > Mode > Convert to Color Profile where you can choose a profile
you already have loaded or load a new one from disk.

> ImageMagick

To remove the embedded profile, just run
% convert -strip <input filename> <output filename>

Retrieved from
"https://wiki.archlinux.org/index.php?title=Libpng_errors&oldid=279761"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 26 October 2013, at 01:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
