CMYK support in The GIMP
========================

> Summary

This article will show how to enable rudimentary CMYK support in Gimp
using the Separate and Separate+ plug-ins, and explain how to use color
proof filter to soft-proof your images. It will also cover more general
topics on CMYK colors and DTP.

Required software

Gimp (v2.0 and above)

lcms (v1.15)

Separate plugin (v0.10 and above)

Separate+ plugin (v0.5.5)

Related articles

Using lprof to profile monitors

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before you read                                                    |
| -   2 Limitations                                                        |
|     -   2.1 What you will need                                           |
|                                                                          |
| -   3 About CMYK color model                                             |
| -   4 About ICC color profiles                                           |
| -   5 About CMYK color and Gimp                                          |
| -   6 Getting the software                                               |
|     -   6.1 Separate plug-in for Gimp                                    |
|         -   6.1.1 Installing using AUR                                   |
|         -   6.1.2 Installing Separate manually                           |
|                                                                          |
|     -   6.2 Separate+ plug-in                                            |
|         -   6.2.1 Installing binary version from Painters Studio         |
|             repository                                                   |
|         -   6.2.2 Installing using AUR                                   |
|         -   6.2.3 Installing manually                                    |
|                                                                          |
|     -   6.3 Install ICC profiles                                         |
|         -   6.3.1 Installing from AUR                                    |
|         -   6.3.2 Install manually                                       |
|                                                                          |
| -   7 Separating a RGB image                                             |
| -   8 Working on a separated image                                       |
| -   9 Soft-proofing with Display Filters                                 |
|     -   9.1 Intent                                                       |
|     -   9.2 Profile                                                      |
|                                                                          |
| -   10 Soft-proofing with Separate's proof function                      |
| -   11 Soft-proofing with Separate+'s proof function                     |
| -   12 What RGB profile to use for images?                               |
| -   13 Resources                                                         |
+--------------------------------------------------------------------------+

Before you read
---------------

Before you install the Separate or Separate+ plug-in for Gimp, you need
to know if you really need it.

There has been much debate about the merits of using Gimp. Most of the
heated discussions revolve around the fact that Gimp does not support
CMYK mode. However, you have to understand that the topic is more
important to DTP professionals than other users (photographers, web
artists, home users).

CMYK color model (or CMYK mode) is used mostly by DTP professionals that
need to output images intended for commercial printing. For an average
home user or even professional photographers, support for separating
images using CMYK color is not necessary.

Even when you see Cyan, Magenta, Yellow, and Black cartridges in your
ink-jet or color laser printer, it doesn't mean that you need to feed it
a CMYK file. In fact, most of them actually accept only RGB images or
convert CMYK images to RGB internally.

Limitations
-----------

Using the methods below has some limitations in comparison to commercial
tools. Namely, Separate+ and its predecessors have no support for GCR
(Grey Component Replacement) and UCR (Undercolor Removal). Also,
Separate plugin (not Separate+) has no support for clipping path, and
there is no support for opening CMYK files in either Separate or
Separate+.

While undercolor removal is supported by Scribus, grey component
replacement is not supported by any graphical tool on Linux as of this
writing.

> What you will need

You will need Gimp (of course), either Separate or Separate+ plugins,
and ICC profiles. All of this can be installed from AUR.

About CMYK color model
----------------------

If you are not interested in the theory, you may skip straight to the
heading on CMYK color support in GIMP.

First off, the proper name for CMYK mode, as it is commonly known, is
CMYK color model. It is called a color model, because it represents a
standard way of describing colors.

The color model is also called a subtractive color model, as opposed to
additive (that is RGB) color model. Words additive and subtractive
suggest that light, which is essential for perception of color, is
either added or subtracted before it reaches the eye. The choice of
primary colors is based on belief that the combination of Red, Green,
and Blue (for RGB) or Cyan, Magenta, Yellow (for CMYK) produce the
greatest range visible colors.

Subtraction of light occurs when an ink absorbs part of the light that
falls on it. The rest is reflected and reaches our eyes. Different inks
absorb different parts of the light's spectrum, and the combination of
C-M-Y inks yields the greatest range of different colors.

Ideally, subtraction of all light, that is when Cyan, Magenta, and
Yellow are mixed together at their full density, we should get black
(i.e., no light reflected, fully absorbed by ink). However, this is
usually not true in the real world because the inks are semi-transparent
and the white paper below reflects some of the light. The use of
additional Black ink in printing (K in CMYK stands for Key, or blacK) is
due to this fact. It adds the necessary density to the image and makes
black a black.

When printing an image on a commercial press, it needs to be printed one
primary (or Black) at a time. Therefore the original (usually a digital
RGB image, or a printed photograph) needs to be separated into Cyan,
Magenta, Yellow, and Black components.

The lack of support for this kind of separation made Gimp unattractive
to DTP professionals.

About ICC color profiles
------------------------

Since reproduction of both RGB and CMYK colors are specific to the
device (or inks) used to produce images, a concept of color-spaces was
invented. Color-spaces formulate the relationship of physical color and
the color model that we use to describe them. Those relationships
(functions) can be packaged as a file in the form of ICC profiles.

The ICC profiles are used to describe the way colors are reproduced in a
system, be it a monitor, a scanner, or a printing press. When separating
images for press, we use the source profile (the color-space of the
image to be separated) and the target profile (the color-space of the
printing press the image is intended for).

About CMYK color and Gimp
-------------------------

Gimp still lacks full CMYK color model support. The ability to separate
and then edit an image in CMYK mode is still a long way down the list of
features to be added. However, there is a plug-in called Separate that
offers a partial solution to the problem.

Separate plugin has following abilities:

-   separate a RGB image
-   color management (using ICC profiles and lcms)
-   soft-proofing colors
-   attach ICC profiles to separated image files

Separate+ plug-in has the same features as Separate, but it also has:

-   ability to convert from one RGB profile to another
-   duotone support

Gimp itself offers a smaller set of CMYK-related functions:

-   display of CMYK values when using color picker
-   soft-proofing colors via Display Filters (not recommended)
-   soft-proofing colors via color management settings

Getting the software
--------------------

> Separate plug-in for Gimp

Installing using AUR

Get the gimp-plugin-separate package from AUR and install it using
makepkg.

Installing Separate manually

Once you have obtained the source tarball, you can unpack it using the
usual tar command:

    tar xvf separate-VERSION.tar.gz

where VERSION would be the version of Separate plug-in (0.1 at the time
of this writing).

Copy a file called separate (located inside the extracted separate
directory) into Gimp's plug-in directory:

    cp separate/separate /usr/lib/gimp/GIMPVERSION/plug-ins/

where GIMPVERSION would be the major version number of Gimp (2.0 at the
time of this writing).

When you start Gimp the Separate will be recognized and reachable
through Image > Separate menu.

> Separate+ plug-in

Installing binary version from Painters Studio repository

Painters Studio repository hosts binary packages for Separate+ plugin.
To obtain the plugin, add one of the following two repositories to your
pacman.conf:

    [pst]
    Server = http://pst.brankovukelic.com/$arch

Then install the package using pacman:

    pacman -S gimp-plugin-separate+

Installing using AUR

Grab the gimp-plugin-separate+ package and install it using makepkg.

Installing manually

To install manually, get the zip file from Sourceforge.jp download page,
unpack it and issue the following commands:

    make
    sudo make install

If you do not have sudo on your system, you can build like this:

    make
    su
    # Enter root password
    make install

When you start Gimp the Separate+ will be reachable through Image >
Separate menu.

> Install ICC profiles

If you are using the Separate plug-in package from AUR, you already have
the profiles installed. However, if you built Separate yourself, or you
are using Separate+, you will need to install ICC profiles.

Installing from AUR

To install ICC profiles from AUR, you need to get eci-icc and/or
adobe-icc packages (and optionally srgb-icc package) and install them
with makepkg.

Install manually

Before you download and install profiles manually, you need to know that
the standard location for ICC profiles is /usr/share/color/icc. You have
to create this directory and copy any profiles there. Another standard
location is ~/.color/icc.

You can obtain ICC profiles from Adobe and ECI.

Extract the downloaded zip file(s) and copy the contents of CMYK and RGB
directories into one of the directories we have mentioned above.

Separating a RGB image
----------------------

Open an image in Gimp. From the Image menu, open the Separate sub-menu
and pick Separate (to Colour).

Choose a source (RGB) and destination (target, CMYK) profile and click
OK.

This will open another window with the CMYK color version. You can see
that there are 5 layers total.

Pick Save... (or Export... in Separate+) from the Separate sub-menu and
save the file in TIFF format with an attached (embedded) ICC profile.

You can only separate flattened images, so it is recommended that you
save a new copy of the image before you create the CMYK TIFF.

Working on a separated image
----------------------------

If you want to work on a separated image you need to be intimately
familiar with the way CMYK images work. If you look at Gimp's Layers
window after separating an image, you will witness the ingenious way in
which the separation is done. However, editing the image is not as
simple as with commercial software like Adobe's Photoshop.

Basically, you need to work with grayscale values of each primary color
(plus Black). All the tools are available, but you only get apply them
layer by layer and in grayscale.

Soft-proofing with Display Filters
----------------------------------

Given the circumstances, the best way to create a solid CMYK image would
be to work in RGB mode, but enable soft-proofing. Soft-proofing is the
method of adjusting the on-screen display of colors to match the final
print. In the newer versions of The GIMP, soft-proofing is made possible
via Display Filters.

Go to the View menu and pick Display Filters... option. From the list of
available filters, pick Color Proof (at the bottom in The GIMP version
2.2.13). Click on the right arrow button between the two lists and the
Color Proof filter will be placed into the list of active filters. Click
on it (the one in the active filters list) and you will get a few
options below.

Although this seems very convenient, experience has proven that this is
not a reliable method of soft-proofing. Instead of soft-proofing using
the display filter, you are advised to properly configure Gimp's color
management system and enable the Print simulation mode.

> Intent

The color proof (rendering) intent can be one of the following:

-   perceptual
-   relative colorimetric
-   saturation
-   absolute colorimetric

Perceptual and relative colorimetric are most common.

Perceptual compresses or expands the full color range of source
color-space into the full color range of target color-space.

Relative colorimetric intent adjusts the white (white point) of source
space and then adjusts the rest of the source colors accordingly. Source
colors outside the target space are mapped to closest reproducible
colors. In some software, this is also called proof intent.

Saturation intent keeps the saturation of the source colors even if the
colors get distorted in the target space. This intent is still
considered experimental and you may get unexpected (if not undesirable)
results.

Absolute colorimetric leaves overlap of source and target space intact
and maps source colors outside the target space are mapped to closest
reproducible colors.

> Profile

For color proofing, we usually use the profile of the device that image
is to be printed on. For testing purposes, you may use any of the Adobe
profiles mentioned above.

Soft-proofing with Separate's proof function
--------------------------------------------

Separate itself offers a way of soft-proofing color. This method of
soft-proofing is not dynamic: it does not update as you edit the image,
but acts more like a one-time preview. However, it is far more accurate
than The GIMP's soft-proofing using Color Proof display filter.
Basically, the proof function converts the image to RGB space using
absolute colorimetric intent. It is supposed to offer a side-by-side
match to the printed copy.

To soft-proof with Separate's proof function, you first separate an
image and then pick Proof from Separate sub-menu. Source profile is your
minitor's RGB profile (you can use lprof to profile your monitor and
create an ICC profile). The destination profile is the ICC profile of a
your image will be output to.

Click OK and you will be presented with an RGB image of how the printed
image would look like.

Soft-proofing with Separate+'s proof function
---------------------------------------------

Separate+ acts the same way as Separate.

What RGB profile to use for images?
-----------------------------------

Although Adobe RGB is a common profile, sRGB profiles (especially the
new v4 version also available in the AUR) is also used often.

Resources
---------

Here are some links that you may find interesting:

-   About CMYK color model (Wikipedia)
-   About color in general (Wikipedia)
-   International Color Consortium (ICC home page)
-   About color management (Wikipedia)
-   Introduction to ICC color profile format (ICC home page)
-   Gimp Color Management for DTP (Foxbunny's Journal)
-   Color Management: Color Space Conversion (Cambridge in Color)
-   Grey Component Removal (Color Rendering Intent)
-   Undercolor Removal (Color Rendering Intent)

Retrieved from
"https://wiki.archlinux.org/index.php?title=CMYK_support_in_The_GIMP&oldid=251625"

Category:

-   Graphics and desktop publishing
