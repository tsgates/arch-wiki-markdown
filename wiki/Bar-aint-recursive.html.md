Bar-aint-recursive
==================

b(ar) a(in't) r(ecursive) is a lightweight bar based on XCB. It provides
foreground/background color switching along with text alignment and
colored under/overlining of text, full utf8 support and reduced memory
footprint. Nothing less and nothing more.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Use an overline instead of an underline
    -   2.2 Change location of the bar
    -   2.3 Change the font
    -   2.4 Colors
-   3 Usage
    -   3.1 Colors
    -   3.2 Text alignment
    -   3.3 Examples

Installation
------------

bar-aint-recursive is available in the AUR and can be installed manually
or through the use of a AUR helper of your choice.

Configuration
-------------

Configuration of bar is done at compile time in the file config.h. An
example config.h looks like this:

    config.h

    /* The height of the bar (in pixels) */
    #define BAR_HEIGHT  16
    /* The width of the bar. Set to -1 to fit screen */
    #define BAR_WIDTH   -1
    /* Offset from the left. Set to 0 to have no effect */
    #define BAR_OFFSET 0
    /* Choose between an underline or an overline */
    #define BAR_UNDERLINE 1
    /* The thickness of the underline (in pixels). Set to 0 to disable. */
    #define BAR_UNDERLINE_HEIGHT 2
    /* Default bar position, overwritten by '-b' switch */
    #define BAR_BOTTOM 0
    /* The fonts used for the bar, comma separated. Only the first 2 will be used. */
    #define BAR_FONT       "-*-terminus-medium-r-normal-*-14-*-*-*-c-*-*-1","fixed"
    /* Some fonts don't set the right width for some chars, pheex it */
    #define BAR_FONT_FALLBACK_WIDTH 6
    /* Define the opacity of the bar (requires a compositor such as compton) */
    #define BAR_OPACITY 1.0 /* 0 is invisible, 1 is opaque */
    /* Color palette */
    #define BACKGROUND 0x151515
    #define FOREGROUND 0xd0d0d0

    #define COLOR0 0x151515
    #define COLOR1 0xac4142
    #define COLOR2 0x90a959
    #define COLOR3 0xf4bf75
    #define COLOR4 0x6a9fb5
    #define COLOR5 0xaa759f
    #define COLOR6 0x75b5aa
    #define COLOR7 0xd0d0d0
    #define COLOR8 0x505050
    #define COLOR9 0xd28445
    #define COLOR10 0x202020
    #define COLOR11 0x303030
    #define COLOR12 0xb0b0b0
    #define COLOR13 0xe0e0e0
    #define COLOR14 0x8f5536
    #define COLOR15 0xf5f5f5

To change the config file, clone the git repository and write the
config.h. You can run make in the directory to make a config.h
automatically from the config.def.h text file. After you're done
configuring recompile.

Use an overline instead of an underline

bar by default supports underlining text with a certain color, but it
also supports overlining text instead. To make bar overline the text
replace the 1 with a 0 in the following line

    config.h

    /* Choose between an underline or an overline */
    #define BAR_UNDERLINE 0

Change location of the bar

bar can be placed at the top or the bottom of the screen. It defaults to
be on the top. To get bar on the bottom, edit the following lines in
config.h or use the option -b at runtime.

    config.h

    /* Default bar position, overwritten by '-b' switch */
    #define BAR_BOTTOM 1

Change the font

bar does not support image files per se, but it does support bitmap
fonts that allows you to use a font with icons such as stlarch_font. To
use such a font, install the font and edit config.h accordingly. The
below example shows how to change the bar font to use stlarch.

    config.h

    /* The fonts used for the bar, comma separated. Only the first 2 will be used. */
    #define BAR_FONT "-misc-stlarch-medium-*-normal-*-10-*-*-*-c-*-*-1","fixed"

Colors

Lastly bar supports the use of up to ten colors. These are defined at
the bottom config.h. The colors are defined in a hexadecimal format. The
last six characters in each of the color lines define the color. For
example would the following code change the 6th color(COLOR6 to
black(000000).

    config.h

    #define COLOR6 0x000000

Usage
-----

bar prints no information on its own. To get any text into bar you need
to pipe text into it. The following example would write the text "Hello
World" into your bar.

    #!/bin/bash

    # Echo the text
    echo "Hello World"

If you want the text in bar to update through a script, you need to add
the -p option.

Colors

bar uses the following commands to color the text, background or the
under/overline.

  Command   Meaning
  --------- ------------------------------------------------
  \f#       Uses the # color as the font's color
  \b#       Uses the # color as the background
  \u#       Uses the # color for under/overlining the text

Text alignment

bar also supports alignment of text. It uses the following commands to
align the text

  Command   Meaning
  --------- -------------------------------
  \l        Aligns the text to the left
  \c        Aligns the text to the center
  \r        Aligns the text to the right

Examples

The following example prints the date and time in the middle of the bar
underlined by COLOR6, the font's color being COLOR1 and the background
COLOR0 and changes the underline back to the backgrounds color
afterwards. Run it with /path/to/script/example.sh | bar -p

    example.sh

    #!/usr/bin/bash

    # Define the clock
    Clock() {
            DATE=$(date "+%a %b %d, %T")

            echo -n "$DATE"
    }

    # Print the clock

    while true; do
            echo "\c\f1\b0\u6 $(Clock)\ur"
            sleep 1;
    done

Another example showing the battery percentage. To use this script you
need to install acpi.

    example.sh

    #!/usr/bin/bash

    #Define the battery
    Battery() {
            BATPERC=$(acpi --battery | awk -F, '{print $2}')
            echo "$BATPERC"
    }

    # Print the percentage
    while true; do
            echo "\r$(Battery)"
            sleep 1;
    done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bar-aint-recursive&oldid=292479"

Category:

-   Eye candy

-   This page was last modified on 11 January 2014, at 23:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
