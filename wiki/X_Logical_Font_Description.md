X Logical Font Description
==========================

Summary

A guide to the core X server font system

Related

Fonts

Font Configuration

Two different font systems are used by X11: the older or core X Logical
Font Description, XLFD,and the newer X FreeType, Xft,systems. XLFD was
originally designed for bitmap fonts and support for scalable fonts
(Type1, TrueType and OpenType) was added later. XLFD does not support
anti‑aliasing and sub‑pixel rasterization. Xft uses the FreeType and
Fontconfig libraries and is more suitable when the smooth appearance of
fonts is desired. A guide for using Fontconfig and Xft may be found at
Font Configuration.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Font Names                                                         |
|     -   1.1 Font name elements                                           |
|                                                                          |
| -   2 Font Sizes                                                         |
| -   3 The Font Search Path                                               |
|     -   3.1 mkfontscale and mkfontdir                                    |
|                                                                          |
| -   4 Aliases                                                            |
+--------------------------------------------------------------------------+

Font Names
----------

Font names are complex when using XLFD:

    -misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1

The name contains fourteen elements, with each element field preceded by
a hyphen, -. Not all elements are required to be present in a font name
and a field may be empty. Names can be simplified for the user by the
wildcards * and ?. On the command line, surround the font name with
quotes to prevent the shell from interpreting the wildcards and to avoid
backslashing whitespace.

    $ xterm -fn "-*-fixed-medium-r-s*--12-87-*-*-*-*-iso10???-1"
    $ xterm -fn "-*-dejavu sans mono-medium-r-normal--*-80-*-*-*-*-iso10646-1"

Names can be simplified even more by using aliases:

    $ xterm -fn 12x24

Two nearly indispensible utilities for working with XLFD names are
xfontsel, xorg-xfontsel, and xlsfonts, xorg-xlsfonts. Xfontsel uses
dropdown menus for selecting parts of a font name and previews the font
selected. Xlsfonts can list fonts by name, with selectable degrees of
detail, and can show how wildcards and aliases will be interpreted by
the XLFD system. If a fontname is not working, check for a match with
xlsfonts.

    $ xlsfonts -fn "*-fixed-medium-r-n*--13-120-75-*-iso1*-1"
    $ xlsfonts -ll -fn fixed

> Font name elements

The following table provides a description of the font name fields. The
elements are listed in the same order as they appear in a font name. The
names used by xfontsel are listed below the longer uppercase names.

+--------------------------------------+--------------------------------------+
| FOUNDRY                              | The supplier of the font.            |
| fndry                                | Specify this field when two          |
|                                      | different fonts share the same       |
|                                      | FAMILY_NAME, for example, courier.   |
|                                      | Otherwise the wildcard, *, may be    |
|                                      | substituted.                         |
+--------------------------------------+--------------------------------------+
| FAMILY_NAME                          | The typeface name, defined by the    |
| fmly                                 | foundry. Usually, fonts with the     |
|                                      | same family name are visually        |
|                                      | similar.                             |
+--------------------------------------+--------------------------------------+
| WEIGHT_NAME                          | The degree of blackness of the       |
| wght                                 | glyphs, defined by the foundry.      |
|                                      | Common values are bold and medium.   |
+--------------------------------------+--------------------------------------+
| SLANT                                | Common values are r for Roman or     |
| slant                                | upright, and i and o for the slanted |
|                                      | italic and oblique typefaces.        |
|                                      | Usually this needs to be specified.  |
+--------------------------------------+--------------------------------------+
| SETWIDTH_NAME                        | Values are set by the designer,      |
| sWdth                                | examples are normal, narrow or       |
|                                      | condensed identifying the width.     |
|                                      | A value should be set, not           |
|                                      | wildcarded, when there are two or    |
|                                      | more possible values.                |
+--------------------------------------+--------------------------------------+
| ADD_STYLE                            | Often an empty field, but values may |
| adstyl                               | be supplied by the foundry.          |
|                                      | In xfontsel, an empty field is       |
|                                      | chosen by selecting (nil) from the   |
|                                      | dropdown box. It's often safe to     |
|                                      | wildcard this field with *.          |
+--------------------------------------+--------------------------------------+
| PIXEL_SIZE                           | The body size of a font for a        |
| pxlsz                                | particular POINT_SIZE and            |
|                                      | RESOLUTION_Y. Changes the height of  |
|                                      | a font independent of the point size |
|                                      | for which the font was designed.     |
|                                      | A zero, 0, or a * may be used for    |
|                                      | scalable fonts if you specify        |
|                                      | POINT_SIZE.                          |
+--------------------------------------+--------------------------------------+
| POINT_SIZE                           | The body heighth for which the font  |
| ptSz                                 | was designed. Values are expressed   |
|                                      | as tenths of a point (one point is   |
|                                      | nominally one seventy-secondth of an |
|                                      | inch).                               |
|                                      | See Font sizes.                      |
+--------------------------------------+--------------------------------------+
| RESOLUTION_X                         | The horizontal resolution as an      |
| resx                                 | integer-string for which the font    |
|                                      | was designed. The values are         |
|                                      | expressed as pixels or dpi.          |
|                                      | For scalable fonts this may safely   |
|                                      | be set to zero or *, bitmap fonts    |
|                                      | usually use 75 or 100.               |
+--------------------------------------+--------------------------------------+
| RESOLUTION_Y                         | The vertical dpi for which the font  |
| resy                                 | was designed.                        |
|                                      | Similar to RESOLUTION_X, scalable    |
|                                      | fonts can have this value set to     |
|                                      | zero or *. For bitmaps, only one of  |
|                                      | RESOLUTION_X or RESOLUTION_Y needs   |
|                                      | to be identified. The other may be   |
|                                      | wildcarded.                          |
+--------------------------------------+--------------------------------------+
| SPACING                              | p– For proportional fonts            |
| spc                                  | m – Monospace; all the glyphs have   |
|                                      | the same logical width.              |
|                                      |                                      |
|                                      | c – Character cell; each glyph       |
|                                      | occupies a "frame" and the frames    |
|                                      | all have equal width. This is        |
|                                      | typewriter spacing. Some older       |
|                                      | applications may leave glyph         |
|                                      | fragments when the display is        |
|                                      | refreshed if fonts with the m        |
|                                      | spacing are used. For these          |
|                                      | applications, try using a font with  |
|                                      | c spacing.                           |
+--------------------------------------+--------------------------------------+
| AVERAGE_WIDTH                        | Arithmetic mean of the widths of all |
| avgWdth                              | glyphs. Zero is used for             |
|                                      | proportional fonts.                  |
|                                      | It is safe to wildcard this value    |
|                                      | with *.                              |
+--------------------------------------+--------------------------------------+
| CHARSET_REGISTRY                     | Always paired with the next field,   |
| rgstry                               | this names the registration          |
|                                      | authority for the character encoding |
|                                      | used. Examples are iso10646 and      |
|                                      | koi8.                                |
|                                      | It's always safe to choose an        |
|                                      | available registry that is           |
|                                      | compatible with the user's locale    |
|                                      | settings.                            |
+--------------------------------------+--------------------------------------+
| CHARSET_ENCODING                     | An identifier for the character set  |
| encdng                               | encoding.                            |
+--------------------------------------+--------------------------------------+

Font Sizes
----------

Font names are stored in the fonts.dir file in each font directory. For
more information about these files, see The Font Search Path below. In a
font name, the pixel and point sizes, and the x and y resolution values,
may be changed and the changes will affect a font's displayed size and
also the spacing between characters and between lines.

As a general rule, bitmap fonts have their best appearance at the sizes
the designers specified. For these fonts, changing the size-related
values from those stored in the font names may give unexpected or ugly
distortions or an unmatchable font pattern.

Scalable fonts were designed to be resized. A scalable font name, as
shown in the example below, has zeroes in the pixel and point size
fields, the two resolution fields, and the average width field.

    -misc-liberation serif-medium-r-normal--0-0-0-0-p-0-iso10646-1

To specify a scalable font at a particular size you only need to provide
a value for the POINT_SIZE field, the other size related values can
remain at zero. The POINT_SIZE value is in tenths of a point, so the
entered value must be the desired point size multiplied by ten. As an
example, the following line specifies Liberation Serif at 9 points.

    -misc-liberation serif-medium-r-normal--0-90-0-0-p-0-iso8859-1

The Font Search Path
--------------------

Please see Fonts for a guide to installing font files and modifying the
font path. For a font to be available to the X server, the directory
containing the font file must be on the user's font path. You can check
your current font path with:

    $ xset q

When a font is requested, the X server searches the font directories in
the order given in the font path. Each font directory will contain a
file named fonts.dir that serves as an index connecting a font's XLFD
name to the file containing the font. The search ends when the first
matching font is found.

The first line in a fonts.dir file is the number of fonts listed in the
file. The following lines then list the fonts in that directory:
filename first, followed by a single space, and finally the font name.
Below are the first four lines of an example fonts.dir:

    1894
    UTBI__10-ISO8859-1.pcf.gz -adobe-utopia-bold-i-normal--14-100-100-100-p-78-iso8859-1
    UTBI__10-ISO8859-10.pcf.gz -adobe-utopia-bold-i-normal--14-100-100-100-p-78-iso8859-10
    UTBI__10-ISO8859-13.pcf.gz -adobe-utopia-bold-i-normal--14-100-100-100-p-78-iso8859-13

> mkfontscale and mkfontdir

To create a fonts.dir file, two programs are required, mkfontscale and
mkfontdir. These programs were probably installed when you installed
Xorg. Mkfontdir reads all the bitmap font files in a directory for the
font names, and creates the fonts.dir file using the font and file names
it has found. It also adds the entries from a file named fonts.scale.

Because mkfontdir cannot read scalable font files, the program
mkfontscale is used to create the names for TrueType, OpenType and Type1
fonts. The font names and font filenames are stored in the file named
fonts.scale.The structure of a fonts.scale file is identical to a
fonts.dir file. The first line is the number of font names listed; the
following lines contain the filename first, followed by a single space,
and finally the font name.

Both fonts.scale and fonts.dir can be hand edited. However, every time
mkfontscale or mkfontdir is run, any existing fonts.scale or fonts.dir
is overwritten. Your edits are easily lost.

Any time mkfontdir is run, the font database should be updated, using
the command:

    $ xset fp rehash

Note:Filenames that include spaces cannot be parsed correctly from the
fonts.dir and fonts.scale files. Quoting or escaping these spaces will
not work. The only solutions are to rename the files using filenames
that do not contain spaces or to delete the font listings in the
fonts.dir and fonts.scale files.

Aliases
-------

Using aliases can greatly simplify the use of XLFD names. Aliases are
stored in files named fonts.alias in the directories along the font
path.

The package xorg-fonts-alias provides some common aliases that have
become standard on X servers. This package provides fonts.alias files
for fonts in the directories 100dpi, 75dpi, cyrillic, and misc. Some
applications depend on these standard aliases: the default font for
xterm is coded to use the font matched by the alias "fixed". Changing
these standardized aliases is not recommended, particularly for
multi-user machines.

You can add aliases to your system by writing your own fonts.alias file
or by adding to an existing one. The format is simple. Comments are
restricted to lines beginning with an exclamation point, !. Blank lines
are ignored. Each alias is defined on a single line. First is the alias
name, followed by any amount of whitespace, and finally the font name or
the alias name to be matched (an alias may refer to another alias). If
an alias name or a font name includes spaces, that name must be enclosed
within quotes. Here is a constructed example:

    ! This is a comment.

    djvsm9  "-misc-dejavu sans mono-medium-r-normal--0-90-0-0-m-0-iso10646-1"
    djvsm8    "-misc-dejavu sans mono-medium-r-normal--0-80-0-0-m-0-iso10646-1"
    "djvsm 8"        djvsm8

The location of a fonts.alias file may be in any directory on the font
path. The font referred to by an alias may also be in any directory
along the font path; the font file does not have to be in the same
directory as the fonts.alias file.

For new font aliases to be available to the user, the font database must
be updated, again with

    $ xset fp rehash

Retrieved from
"https://wiki.archlinux.org/index.php?title=X_Logical_Font_Description&oldid=244987"

Category:

-   Fonts
