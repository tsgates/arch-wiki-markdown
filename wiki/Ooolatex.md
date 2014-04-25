Ooolatex
========

From - OOoLatex:

OOoLatex is a set of macros designed to bring the power of LaTeX into
OpenOffice. It contains two main modules: the first one, Equation,
allows to insert LaTeX equations into Writer and Impress documents as
png or emf images while the second one, Expand, can be used for simpler
equations to expand LaTeX code into appropriated symbol characters and
insert them as regular text.

The macro is especially useful for the preparation of presentations with
a lot of mathematical formula. Instead of using beamer class in LaTeX,
one can enjoy the flexibility of Impress in organizing texts and graphs
while at the same time harness the power of LaTeX in typesetting and
inserting equations.

Contents
--------

-   1 OOoLatex in Arch Linux
-   2 Installation
-   3 Fonts
-   4 EMF support
-   5 Initial setup
-   6 Usage
-   7 References

OOoLatex in Arch Linux
----------------------

This article explains how to install OOoLatex for Arch Linux, assuming
one has a working Latex system and Ghostscript package installed.

Installation
------------

The easiest way to obtain OOoLatex macro package is from the project's
website. Select the package according to the system architecture. Then,
open the "oxt" file with OpenOffice or LibreOffice, the extension
manager should take care of the rest.

Fonts
-----

To render the equations correctly, one must have the required fonts
installed in the system. The collection of fonts is available from the
project website under the name OOoLatexFonts.zip.

To install the fonts, follow the Wiki guide on fonts. For example, a
system-wide installation (available for all users) can be performed by
unzipping and moving the fonts folder to the /usr/share/fonts/
directory.

Then one needs to update the font cache: (from within the fonts folder)

    # fc-cache -vf

EMF support
-----------

EMF format allows better rendering of the equations by the use of
scalable graphics. It performs much better than a "png" rendition and
the resultant image can be re-sized without compromising visual quality.

For the EMF option to work, it is particularly important to install the
"libstdc++5" dependency:

    # pacman -S libstdc++5

For 64 bit users, in addition to the above package, one also needs

    # pacman -S lib32-libstdc++5

Initial setup
-------------

After installation, one can start the macro by choosing Tools >
Macros... > Run Macros and selects the required routine from within a
document. Also, an OOoLatex toolbar should be available which allows
easy insertion of equations. (If it is not automatically enabled, check
OOoLatex in View > Toolbars > OOoLatex.)

To successfully compile the LaTeX code, one needs to supply the paths to
LaTeX and ghostscript (gs) binaries to OOoLatex in the "Config" tab. The
usual location for both of these are in

    # /usr/bin

Usage
-----

One can invoke the Macro by selecting the "Equation" tab in the toolbar.
The module transform the relevant LaTeX code into a graphical image. For
the graphical image, one can choose between ".png" and ".emf". The
".emf" format is more preferrable in that it is scalable, instead of
pixelized image in the case of ".png".

Start by typing

    F = ma

with "display" type in the "Equation" module. Press "Latex" to run the
code. The resultant image should scale nicely if one chooses "emf" as
output format.

For more information on how to use the macro, consult the project's
website.

References
----------

-   OOoLatex for Ubuntu
-   project's website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ooolatex&oldid=217819"

Categories:

-   Mathematics and science
-   TeX

-   This page was last modified on 14 August 2012, at 11:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
