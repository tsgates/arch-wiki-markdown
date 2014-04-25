Font Configuration
==================

Related articles

-   Fonts
-   Font Configuration/fontconfig Examples
-   Infinality-bundle+fonts
-   Java Runtime Environment Fonts
-   MS Fonts
-   X Logical Font Description

Fontconfig is a library designed to provide a list of available fonts to
applications, and also for configuration for how fonts get rendered. See
package fontconfig and Wikipedia:Fontconfig. The Free type library
(freetype2 package) renders the fonts, based on this configuration.

Though Fontconfig is the standard in today's Linux, some applications
still rely on the original method of font selection and display, the X
Logical Font Description.

The font rendering packages on Arch Linux includes support for freetype2
with the bytecode interpreter (BCI) enabled. Patched packages exist for
better font rendering, especially with an LCD monitor. See #Patched
packages below. The Infinality package allows both auto-hinting and
subpixel rendering, allows the LCD filter to be tweaked without
recompiling, and allows the auto-hinter to work well with bold fonts.

Contents
--------

-   1 Font paths
-   2 Fontconfig configuration
    -   2.1 Presets
    -   2.2 Anti-aliasing
    -   2.3 Hinting
        -   2.3.1 Byte-Code Interpreter (BCI)
        -   2.3.2 Autohinter
        -   2.3.3 Hintstyle
    -   2.4 Subpixel rendering
        -   2.4.1 LCD filter
        -   2.4.2 Advanced LCD filter specification
    -   2.5 Disable auto-hinter for bold fonts
    -   2.6 Enable anti-aliasing only for bigger fonts
    -   2.7 Replace fonts
    -   2.8 Disable bitmap fonts
    -   2.9 Disable scaling of bitmap fonts
    -   2.10 Create bold and italic styles for incomplete fonts
    -   2.11 Change rule overriding
    -   2.12 Example fontconfig configurations
-   3 Patched packages
    -   3.1 Infinality
        -   3.1.1 Installation and configuration
        -   3.1.2 Install from custom repository
    -   3.2 Ubuntu
    -   3.3 Reverting to unpatched packages
-   4 Applications without fontconfig support
-   5 Troubleshooting
    -   5.1 Distorted fonts
    -   5.2 Calibri, Cambria, Monaco, etc. not rendering properly
    -   5.3 Older GTK and QT applications
    -   5.4 Applications overriding hinting
-   6 See also

Font paths
----------

For fonts to be known to applications, they must be cataloged for easy
and quick access.

The font paths initially known to Fontconfig are: /usr/share/fonts/ and
~/.fonts/ (of which Fontconfig will scan recursively). For ease of
organization and installation, it is recommended to use these font paths
when adding fonts.

To see a list of known Fontconfig fonts:

    $ fc-list : file

See man fc-list for more output formats.

Check for Xorg's known font paths by reviewing its log:

    $ grep /fonts /var/log/Xorg.0.log

Tip:You can also check the list of Xorg's known font paths using the
command xset q.

Keep in mind that Xorg does not search recursively through the
/usr/share/fonts/ directory like Fontconfig does. To add a path, the
full path must be used:

    Section "Files"
        FontPath     "/usr/share/fonts/local/"
    EndSection

If you want font paths to be set on a per-user basis, you can add and
remove font paths from the default by adding the following line(s) to
~/.xinitrc:

    xset +fp /usr/share/fonts/local/           # Prepend a custom font path to Xorg's list of known font paths
    xset -fp /usr/share/fonts/sucky_fonts/     # Remove the specified font path from Xorg's list of known font paths

To see a list of known Xorg fonts use xlsfonts, from the xorg-xlsfonts
package.

Fontconfig configuration
------------------------

Fontconfig is documented in the fonts-conf man page.

Configuration can be done per-user through
$XDG_CONFIG_HOME/fontconfig/fonts.conf, and globally with
/etc/fonts/local.conf. The settings in the per-user configuration have
precedence over the global configuration. Both these files use the same
syntax.

Note:Configuration files and directories: ~/.fonts.conf/,
~/.fonts.conf.d/ and ~/.fontconfig/*.cache-* are deprecated since
fontconfig 2.10.1 (upstream commit) and will not be read by default in
the future versions of the package. New paths are
$XDG_CONFIG_HOME/fontconfig/fonts.conf,
$XDG_CONFIG_HOME/fontconfig/conf.d/NN-name.conf and
$XDG_CACHE_HOME/fontconfig/*.cache-* respectively. If using the second
location, make sure the naming is valid (where NN is a two digit number
like 00, 10, or 99).

Fontconfig gathers all its configurations in a central file
(/etc/fonts/fonts.conf). This file is replaced during fontconfig updates
and shouldn't be edited. Fontconfig-aware applications source this file
to know available fonts and how they get rendered. This file is a
conglomeration of rules from the global configuration
(/etc/fonts/local.conf), the configured presets in /etc/fonts/conf.d/,
and the user configuration file
($XDG_CONFIG_HOME/fontconfig/fonts.conf). fc-cache can be used to
rebuild fontconfig's configuration, although changes will only be
visible in newly launched applications.

Note:For some desktop environments (such as GNOME and KDE) using the
Font Control Panel will automatically create or overwrite the user font
configuration file. For these desktop environments, it is best to match
your already defined font configurations to get the expected behavior.

Fontconfig configuration files use XML format and need these headers:

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>

      <!-- settings go here -->

    </fontconfig>

The configuration examples in this article omit these tags.

> Presets

There are presets installed in the directory /etc/fonts/conf.avail. They
can be enabled by creating symbolic links to them, both per-user and
globally, as described in /etc/fonts/conf.d/README. These presets will
override matching settings in their respective configuration files.

For example, to enable sub-pixel RGB rendering globally:

    # cd /etc/fonts/conf.d
    # ln -s ../conf.avail/10-sub-pixel-rgb.conf

To do the same but instead for a per-user configuration:

    $ mkdir $XDG_CONFIG_HOME/fontconfig/conf.d
    $ ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf $XDG_CONFIG_HOME/fontconfig/conf.d

> Anti-aliasing

Font rasterization converts vector font data to bitmap data so that it
can be displayed. The result can appear jagged due to aliasing.
anti-aliasing is enabled by default and increases the apparent
resolution of font edges.

      <match target="font">
        <edit name="antialias" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

Note:Some applications, like Gnome 3 may override default anti-alias
settings.

> Hinting

Font hinting (also known as instructing) is the use of mathematical
instructions to adjust the display of an outline font so that it lines
up with a rasterized grid, (i.e. the pixel grid of the display). Its
intended effect is to make fonts appear more crisp so that they are more
readable. Fonts will line up correctly without hinting when displays
have around 300 DPI. Two types of hinting are available.

Byte-Code Interpreter (BCI)

Using BCI hinting, instructions in TrueType fonts fonts are rendered
according to FreeTypes's interpreter. BCI hinting works well with fonts
with good hinting instructions. To enable hinting:

      <match target="font">
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

Autohinter

The Autohinter attempts to do automatic hinting and disregards any
existing hinting information. Originally it was the default because
TrueType2 fonts were patent-protected but now that these patents have
expired there's very little reason to use it. It does work better with
fonts that have broken or no hinting information but it will be strongly
sub-optimal for fonts with good hinting information. Generally common
fonts are of the later kind so autohinter will not be useful. To enable
auto-hinting:

      <match target="font">
        <edit name="autohint" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

Hintstyle

Hintstyle is the amount of font reshaping done to line up to the grid.
Hinting values are: hintnone, hintslight, hintmedium, and hintfull.
hintslight will make the font more fuzzy to line up to the grid but will
be better in retaining font shape, while hintfull will be a crisp font
that aligns well to the pixel grid but will lose a greater amount of
font shape. Preferences vary.

      <match target="font">
        <edit name="hintstyle" mode="assign">
          <const>hintfull</const>
        </edit>
      </match>

Note:Some applications, like Gnome 3 may override default hinting
settings.

> Subpixel rendering

Most monitors manufactured today use the Red, Green, Blue (RGB)
specification. Fontconfig will need to know your monitor type to be able
to display your fonts correctly. Monitors are either: RGB (most common),
BGR, V-RGB (vertical), or V-BGR. A monitor test can be found here).

To enable subpixel rendering:

      <match target="font">
        <edit name="rgba" mode="assign">
          <const>rgb</const>
        </edit>
      </match>

Note:Subpixel rendering effectively triples the horizontal (or vertical)
resolution for fonts by making use of subpixels. The autohinter and
subpixel rendering are not designed to work together and should not be
used in combination without the Infinality patch set.

LCD filter

When using subpixel rendering, you should enable the LCD filter, which
is designed to reduce colour fringing. This is described under LCD
filtering in the FreeType 2 API reference. Different options are
described under FT_LcdFilter, and are illustrated by this LCD filter
test page.

The lcddefault filter will work for most users. Other filters are
available that can be used in special situations: lcdlight; a lighter
filter ideal for fonts that look too bold or fuzzy, lcdlegacy, the
original Cairo filter; and lcdnone to disable it entirely.

      <match target="font">
        <edit mode="assign" name="lcdfilter">
          <const>lcddefault</const>
        </edit>
      </match>

Advanced LCD filter specification

If the available, built-in LCD filters are not satisfactory, it is
possible to tweak the font rendering very specifically by building a
custom freetype2 package and modifying the hardcoded filters. The Arch
Build System can be used to build and install packages from source.

First, refresh the freetype2 PKGBUILD as root:

    # abs extra/freetype2

This example uses /var/abs/build as the build directory, substitute it
according to your personal ABS setup. Download and extract the freetype2
package as a regular user:

    $ cd /var/abs/build
    $ cp -r ../extra/freetype2 .
    $ cd freetype2
    $ makepkg -o

Edit the file src/freetype-VERSION/src/base/ftlcdfil.c and look up the
definition of the constant default_filter[5]:

    static const FT_Byte  default_filter[5] =
        { 0x10, 0x40, 0x70, 0x40, 0x10 };

This constant defines a low-pass filter applied to the rendered glyph.
Modify it as needed. Save the file, build and install the custom
package:

    $ makepkg -e
    # pacman -Rd freetype2
    # pacman -U freetype2-VERSION-ARCH.pkg.tar.xz

Reboot or restart X. The lcddefault filter should now render fonts
differently.

> Disable auto-hinter for bold fonts

The auto-hinter uses sophisticated methods for font rendering, but often
makes bold fonts too wide. Fortunately, a solution can be turning off
the autohinter for bold fonts while leaving it on for the rest:

    ...
    <match target="font">
        <test name="weight" compare="more">
            <const>medium</const>
        </test>
        <edit name="autohint" mode="assign">
            <bool>false</bool>
        </edit>
    </match>
    ...

> Enable anti-aliasing only for bigger fonts

Some users prefer the sharper rendering that anti-aliasing does not
offer:

    ...
    <match target="font">
        <edit name="antialias" mode="assign">
            <bool>false</bool>
        </edit>
    </match>

    <match target="font" >
        <test name="size" qual="any" compare="more">
            <double>12</double>
        </test>
        <edit name="antialias" mode="assign">
            <bool>true</bool>
        </edit>
    </match>

    <match target="font" >
        <test name="pixelsize" qual="any" compare="more">
            <double>16</double>
        </test>
        <edit name="antialias" mode="assign">
            <bool>true</bool>
        </edit>
    </match>
    ...

> Replace fonts

The most reliable way to do this is to add an XML fragment similar to
the one below. Using the "binding" attribute will give you better
results, for example, in Firefox where you may not want to change
properties of font being replaced. This will cause Ubuntu to be used in
place of Georgia:

    ...
     <match target="pattern">
       <test qual="any" name="family"><string>georgia</string></test>
       <edit name="family" mode="assign" binding="same"><string>Ubuntu</string></edit>
     </match>
    ...

An alternate approach is to set the "preferred" font, but this only
works if the original font is not on the system, in which case the one
specified will be substituted:

    ...
    < !-- Replace Helvetica with Bitstream Vera Sans Mono -->
    < !-- Note, an alias for Helvetica should already exist in default conf files -->
    <alias>
        <family>Helvetica</family>
        <prefer><family>Bitstream Vera Sans Mono</family></prefer>
        <default><family>fixed</family></default>
    </alias>
    ...

> Disable bitmap fonts

To disable bitmap fonts in fontconfig, use 70-no-bitmaps.conf (which is
not placed by fontconfig by default):

    # cd /etc/fonts/conf.d
    # rm 70-yes-bitmaps.conf
    # ln -s ../conf.avail/70-no-bitmaps.conf

This oneliner should also work:

    # ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

You may not need to remove 70-yes-bitmaps.conf if it does not exist. You
can choose which fonts to replace bitmaps fonts with (Helvetica, Courier
and Times bitmap mapts to TTF fonts) by:

    ~/.config/fontconfig/conf.d/29-replace-bitmap-fonts.conf

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
        <!-- Replace generic bitmap font names by generic font families -->
        <match target="pattern" name="family">
            <test name="family" qual="any">
                <string>Helvetica</string>
            </test>
            <edit mode="assign" name="family">
                <string>Arial</string>
                <string>Liberation Sans</string>
                <string>sans-serif</string>
            </edit>
        </match>
        <match target="pattern" name="family">
            <test name="family" qual="any">
                <string>Courier</string>
            </test>
            <edit mode="assign" name="family">
                <string>Courier New</string>
                <string>Liberation Mono</string>
                <string>monospace</string>
            </edit>
        </match>
        <match target="pattern" name="family">
            <test name="family" qual="any">
                <string>Times</string>
            </test>
            <edit mode="assign" name="family">
                <string>Times New Roman</string>
                <string>Liberation Serif</string>
                <string>serif</string>
            </edit>
        </match>
    </fontconfig>

To disable embedded bitmap for all fonts:

    ~/.config/fontconfig/conf.d/20-no-embedded.conf

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <match target="font">
        <edit name="embeddedbitmap" mode="assign">
          <bool>false</bool>
        </edit>
      </match>
    </fontconfig>

To disable embedded bitmap fonts for a specific font:

    <match target="font">
      <test qual="any" name="family">
        <string>Monaco</string>
      </test>
      <edit name="embeddedbitmap"><bool>false</bool></edit>
    </match>

> Disable scaling of bitmap fonts

To disable scaling of bitmap fonts (which often makes them blurry),
remove /etc/fonts/conf.d/10-scale-bitmap-fonts.conf.

> Create bold and italic styles for incomplete fonts

Freetype has the ability to automatically create italic and bold styles
for fonts that do not have them, but only if explicitly required by the
application. Given programs rarely send these requests, this section
covers manually forcing generation of missing styles.

Start by editing /usr/share/fonts/fonts.cache-1 as explained below.
Store a copy of the modifications on another file, because a font update
with fc-cache will overwrite /usr/share/fonts/fonts.cache-1.

Assuming the Dupree font is installed:

    "dupree.ttf" 0 "Dupree:style=Regular:slant=0:weight=80:width=100:foundry=unknown:index=0:outline=True:etc...

Duplicate the line, change style=Regular to style=Bold or any other
style. Also change slant=0 to slant=100 for italic, weight=80 to
weight=200 for bold, or combine them for bold italic:

    "dupree.ttf" 0 "Dupree:style=Bold Italic:slant=100:weight=200:width=100:foundry=unknown:index=0:outline=True:etc...

Now add necessary modifications to
$XDG_CONFIG_HOME/fontconfig/fonts.conf:

    ...
    <match target="font">
        <test name="family" qual="any">
            <string>Dupree</string>
             <!-- other fonts here .... -->
         </test>
         <test name="weight" compare="more_eq"><int>140</int></test>
         <edit name="embolden" mode="assign"><bool>true</bool></edit>
    </match>

    <match target="font">
        <test name="family" qual="any">
            <string>Dupree</string>
            <!-- other fonts here .... -->
        </test>
        <test name="slant" compare="more_eq"><int>80</int></test>
        <edit name="matrix" mode="assign">
            <times>
                <name>matrix</name>
                    <matrix>
                        <double>1</double><double>0.2</double>
                        <double>0</double><double>1</double>
                    </matrix>
            </times>
        </edit>
    </match>
    ...

Tip: Use the value 'embolden' for existing bold fonts in order to make
them even bolder.

> Change rule overriding

Fontconfig processes files in /etc/fonts/conf.d in numerical order. This
enables rules or files to override one another, but often confuses users
about what file gets parsed last.

To guarantee that personal settings take precedence over any other
rules, change their ordering:

    # cd /etc/fonts/conf.d
    # mv 50-user.conf 99-user.conf

This change seems however to be unnecessary for the most of the cases,
because a user is given enough control by default to set up own font
preferences, hinting and antialiasing properties, alias new fonts to
generic font families, etc.

> Example fontconfig configurations

Example fontconfig configurations can be found on this page.

A simple starting point:

    $XDG_CONFIG_HOME/fontconfig/fonts.conf

    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
    	<match target="font">
    		<edit mode="assign" name="antialias">
    			<bool>true</bool>
    		</edit>
    		<edit mode="assign" name="embeddedbitmap">
    			<bool>false</bool>
    		</edit>
    		<edit mode="assign" name="hinting">
    			<bool>true</bool>
    		</edit>
    		<edit mode="assign" name="hintstyle">
    			<const>hintslight</const>
    		</edit>
    		<edit mode="assign" name="lcdfilter">
    			<const>lcddefault</const>
    		</edit>
    		<edit mode="assign" name="rgba">
    			<const>rgb</const>
    		</edit>
    	</match>
    </fontconfig>

Patched packages
----------------

These patched packages are available in the AUR. A few considerations:

-   Configuration is usually necessary.
-   The new font rendering will not kick in until applications restart.
-   Applications which statically link to a library will not be affected
    by patches applied to the system library.

> Infinality

The infinality patchset aims to greatly improve freetype2 font
rendering. It adds multiple new capabilities.

-   Home page
-   Forum
-   Short article about infinality (contains screenshots)

Infinality's settings are all configurable at runtime via environment
variables in /etc/profile.d/infinality-settings.sh, and include the
following:

-   Emboldening Enhancement: Disables Y emboldening, producing a much
    nicer result on fonts without bold versions. Works on native TT
    hinter and autohinter.
-   Auto-Autohint: Automatically forces autohint on fonts that contain
    no TT instructions.
-   Autohint Enhancement: Makes autohint snap horizontal stems to
    pixels. Gives a result that appears like a well-hinted truetype
    font, but is 100% patent-free (as far as I know).
-   Customized FIR Filter: Select your own filter values at run-time.
    Works on native TT hinter and autohinter.
-   Stem Alignment: Aligns bitmap glyphs to optimized pixel boundaries.
    Works on native TT hinter and autohinter.
-   Pseudo Gamma Correction: Lighten and darken glyphs at a given value,
    below a given size. Works on native TT hinter and autohinter.
-   Embolden Thin Fonts: Embolden thin or light fonts so that they are
    more visible. Works on autohinter.
-   Force Slight Hinting: Force slight hinting even when programs want
    full hinting. If you use the local.conf I provide (included in
    infinality-settings fedora package) you will notice nice
    improvements on @font-face fonts.
-   ChromeOS Style Sharpening: ChromeOS uses a patch to sharpen the look
    of fonts. This is now included in the infinality patchset.

A number of presets are included and can be used by setting the
USE_STYLE variable in /etc/profile.d/infinality-settings.sh.

Installation and configuration

Tip:All AUR packages in this section can also be downloaded from
bohoomil's custom repository. See the section below for how to enable
this repository.

Note:If you have been using fontconfig-infinality-ultimate < 2.11.0-2,
you need to re-install (not upgrade!) fontconfig-infinality-ultimate
package:

     pacman -Rdd fontconfig-infinality-ultimate
     pacman -S fontconfig-infinality-ultimate

freetype2-infinality can be installed from the AUR. If you are a
multilib user, also install lib32-freetype2-infinality from the AUR. The
AUR also contains the latest development snapshot of freetype2 with the
Infinality patchset: freetype2-infinality-git and
lib32-freetype2-infinality-git.

It is recommended to also install fontconfig-infinality to enable
selection of predefined font substitution styles and antialiasing
settings, apart from the rendering settings of the engine itself. After
doing so, you can select the font style (win7, winxp, osx, linux, ...)
with:

    # infctl setstyle

If you set e.g. win7 or osx you need the corresponding fonts installed.

> Note:

-   The user bohoomil maintains a very good configuration in his github
    repo which is available as fontconfig-infinality-ultimate-git in the
    AUR.
-   Install grip-git from the AUR to have a realtime font preview.
-   Default infinality settings can cause some programs to display fonts
    at 72 DPI instead of 96. If you notice a problem open
    /etc/fonts/infinality/infinality.conf search for the section on DPI
    and change 72 to 96. This problem can specifically affect conky
    causing the fonts to appear smaller than they should. Thus not
    aligning properly with images.
-   The README for fontconfig-infinality says that /etc/fonts/local.conf
    should either not exist, or have no infinality-related
    configurations in it. The local.conf is now obsolete and completely
    replaced by this configuration.

for more information see this article:
http://www.infinality.net/forum/viewtopic.php?f=2&t=77

Install from custom repository

bohoomil also maintains infinality-bundle repository, offering three
basic libraries (freetype2-infinality-ultimate,
fontconfig-infinality-ultimate & cairo-infinality-ultimate) as
pre-patched, pre-configured and pre-built binaries for all architectures
(i686, x86_64, multilib). There is also an additional repository
avaiable, infinality-bundle-fonts, offering a collection of entirely
free, high quality typefaces, replacing common proprietary font
families. Using infinality-bundle and infinality-bundle-fonts makes the
whole installation and configuration process dramatically simplified
(i.e., it lets you skip most steps necessary to install and configure
fonts in your system).

Please, see Infinality-bundle+fonts for more information and
installation instructions.

> Ubuntu

Ubuntu adds extra configurations, and occasionally patches to the font
rendering libraries.

Install the patched packages from the AUR, the package names are:
freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu.

The global configuration will need to be added. See #Example fontconfig
configurations for a starting point. Ubuntu rendering works the best
with hintslight option.

Note that the *-ubuntu AUR packages need to be kept up-to-date by the
user, and will not be updated by pacman along with other packages. The
whole graphical system can become inoperable if the user-installed core
graphical libraries become incompatible with the official repository
applications.

> Reverting to unpatched packages

To restore the unpatched packages, reinstall the originals:

    # pacman -S --asdeps freetype2 cairo fontconfig

Append 'lib32-cairo lib32-fontconfig lib32-freetype2' if you also
installed 32 bit versions.

Applications without fontconfig support
---------------------------------------

Some applications like URxvt will ignore fontconfig settings. This is
very apparent when using the infinality patches which are heavily
reliant on proper configuration. You can work around this by using
~/.Xresources, but it is not nearly as flexible as fontconfig. Example
(see #Fontconfig configuration for explanations of the options):

    ~/.Xresources

    Xft.autohint: 0
    Xft.lcdfilter:  lcddefault
    Xft.hintstyle:  hintfull
    Xft.hinting: 1
    Xft.antialias: 1
    Xft.rgba: rgb

Make sure the settings are loaded properly when X starts with xrdb -q
(see Xresources for more information).

Troubleshooting
---------------

> Distorted fonts

Note:96 DPI is not a standard. You should use your monitor's actual DPI
to get proper font rendering, especially when using subpixel rendering.

If fonts are still unexpectedly large or small, poorly proportioned or
simply rendering poorly, fontconfig may be using the incorrect DPI.

Fontconfig should be able to detect DPI parameters as discovered by the
Xorg server. You can check the automatically discovered DPI with
xdpyinfo (provided by the xorg-xdpyinfo package):

    $ xdpyinfo | grep dots

      resolution:    102x102 dots per inch

If the DPI is detected incorrectly (usually due to an incorrect monitor
EDID), you can specify it manually in the Xorg configuration, see
Xorg#Display size and DPI. This is the recommended solution, but it may
not work with buggy drivers.

Fontconfig will default to the Xft.dpi variable if it is set. Xft.dpi is
usually set by desktop environments (usually to Xorg's DPI setting) or
manually in ~/.Xdefaults or ~/.Xresources. Use xrdb to query for the
value:

    $ xrdb -query | grep dpi

    Xft.dpi:	102

Those still having problems can fall back to manually setting the DPI
used by fontconfig:

    ...
    <match target="pattern">
       <edit name="dpi" mode="assign"><double>102</double></edit>
    </match>
    ...

> Calibri, Cambria, Monaco, etc. not rendering properly

Some scalable fonts have embedded bitmap versions which are rendered
instead, mainly at smaller sizes. Force using scalable fonts at all
sizes by #Disabling embedded bitmap.

> Older GTK and QT applications

Modern GTK apps enable Xft by default but this was not the case before
version 2.2. If it is not possible to update these applications, force
Xft for old GNOME applications by adding to ~/.bashrc:

    export GDK_USE_XFT=1

For older QT applications:

    export QT_XFT=true

> Applications overriding hinting

Some applications may override default fontconfig hinting and
anti-aliasing settings. This may happen with Gnome 3, for example while
you are using QT applications like vlc,smplayer. Use the specific
configuration program for the application in such cases. For gnome, try
gnome-tweak-tool and set the anti-aliasing to rgba instead of the
default grayscale while using infinality.

See also
--------

-   Fonts in X11R6.8.2 - Official Xorg font information
-   FreeType 2 overview
-   Gentoo font-rendering thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Font_Configuration&oldid=304196"

Category:

-   Fonts

-   This page was last modified on 12 March 2014, at 20:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
