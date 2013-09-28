Font Configuration
==================

Summary

An overview of font configuration options and various techniques for
improving the readability of fonts

Related

Fonts: Information on adding fonts and font recommendations

Font Configuration/fontconfig Examples

Java Runtime Environment Fonts: Fonts specific to Sun's Java machine

MS Fonts: Adding Microsoft fonts and mimicking Windows' font settings

X Logical Font Description: The older core font system for X

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
packages below. The #Infinality package allows both auto-hinting and
subpixel rendering, allows the LCD filter to be tweaked without
recompiling, and allows the auto-hinter to work well with bold fonts.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Font paths                                                         |
| -   2 Fontconfig configuration                                           |
|     -   2.1 Presets                                                      |
|     -   2.2 Anti-aliasing                                                |
|     -   2.3 Hinting                                                      |
|         -   2.3.1 Byte-Code Interpreter (BCI)                            |
|         -   2.3.2 Autohinter                                             |
|         -   2.3.3 Hint style                                             |
|                                                                          |
|     -   2.4 Subpixel rendering                                           |
|         -   2.4.1 LCD filter                                             |
|         -   2.4.2 Advanced LCD filter specification                      |
|                                                                          |
|     -   2.5 Disable auto-hinter for bold fonts                           |
|     -   2.6 Enable anti-aliasing only for bigger fonts                   |
|     -   2.7 Replace fonts                                                |
|     -   2.8 Disable bitmap fonts                                         |
|     -   2.9 Disable scaling of bitmap fonts                              |
|     -   2.10 Create bold and italic styles for incomplete fonts          |
|     -   2.11 Change rule overriding                                      |
|     -   2.12 Example fontconfig configurations                           |
|                                                                          |
| -   3 Patched packages                                                   |
|     -   3.1 Infinality: the generic way                                  |
|     -   3.2 Infinality: the easy way                                     |
|     -   3.3 Ubuntu                                                       |
|     -   3.4 Reverting to unpatched packages                              |
|                                                                          |
| -   4 Applications without fontconfig support                            |
| -   5 Troubleshooting                                                    |
|     -   5.1 Distorted fonts                                              |
|     -   5.2 Older GTK and QT applications                                |
|     -   5.3 Applications overriding hinting                              |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

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

See man fc-list for more out put format.

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

Fontconfig is documented in the fonts.conf man page.

Configuration can be done per-user through
$XDG_CONFIG_HOME/fontconfig/fonts.conf, and globally with
/etc/fonts/local.conf. The settings in the per-user configuration have
precedence over the global configuration. Both these files use the same
syntax.

Note:Configuration files and directories: ~/.fonts.conf, ~/.fonts.conf.d
and ~/.fontconfig/*.cache-* are deprecated since fontconfig 2.10.1
(upstream commit) and will not be read by default in the future versions
of package. Use instead $XDG_CONFIG_HOME/fontconfig/fonts.conf,
$XDG_CONFIG_HOME/fontconfig/conf.d and
$XDG_CACHE_HOME/fontconfig/*.cache-* respectively. If you use the second
directory, the file must follow the naming convention NN-name.conf
(where NN it's a two digit number like 00, 10, or 99).

Fontconfig gathers all its configurations in a central file
(/etc/fonts/fonts.conf). This file is replaced during fontconfig updates
and shouldn't be edited. Fontconfig-aware applications source this file
to know available fonts and how they get rendered. This file is a
conglomeration of rules from the global configuration
(/etc/fonts/local.conf), the configured presets in /etc/fonts/conf.d/,
and the user configuration file
($XDG_CONFIG_HOME/fontconfig/fonts.conf).

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

Note: some applications, like Gnome 3 may override default anti-alias
settings.

> Hinting

Font hinting (also known as instructing) is the use of mathematical
instructions to adjust the display of an outline font so that it lines
up with a rasterized grid, such as the pixel grid in a display. Fonts
will not line up correctly without hinting until displays have 300 DPI
or greater. Two types of hinting are available.

Byte-Code Interpreter (BCI)

Using normal hinting, TrueType hinting instructions in the font are
interpreted by freetype's Byte-Code Interpreter. This works best for
fonts with good hinting instructions.

To enable normal hinting:

      <match target="font">
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

Autohinter

Auto-discovery for hinting. This looks worse than normal hinting for
fonts with good instructions, but better for those with poor or no
instructions. The autohinter and subpixel rendering are not designed to
work together and should not be used in combination.

To enable auto-hinting:

      <match target="font">
        <edit name="autohint" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

Hint style

Hint style is the amount of influence the hinting mode has. Hinting can
be set to: hintfull, hintmedium, hintslight and hintnone. With BCI
hinting, hintfull should work best for most fonts. With the autohinter,
hintslight is recommended.

      <match target="font">
        <edit name="hintstyle" mode="assign">
          <const>hintfull</const>
        </edit>
      </match>

Note: some applications, like Gnome 3 may override default hinting
settings.

> Subpixel rendering

Subpixel rendering effectively triples the horizontal (or vertical)
resolution for fonts by making use of subpixels. The autohinter and
subpixel rendering are not designed to work together and should not be
used in combination without the #Infinality patch set.

Most monitors manufactured today use the Red, Green, Blue (RGB)
specification. Fontconfig will need to know your monitor type to be able
to display your fonts correctly.

RGB (most common), BGR, V-RGB (vertical), or V-BGR

To enable subpixel rendering:

      <match target="font">
        <edit name="rgba" mode="assign">
          <const>rgb</const>
        </edit>
      </match>

If you notice unusual colors around font's borders, the wrong subpixel
arrangement might be configured. The Lagom subpixel layout test web page
can help identify it.

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
    $ sudo pacman -Rd freetype2
    $ sudo pacman -U freetype2-VERSION-ARCH.pkg.tar.xz

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

See also sharpfonts.co.cc for related information.

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

You may not need to remove 70-yes-bitmaps.conf if it does not exist. You
can choose which fonts to replace bitmaps fonts with (Helvetica, Courier
and Times bitmap mapts to TTF fonts) by:

    # cd /etc/fonts/conf.d
    # ln -s ../conf.avail/29-replace-bitmap-fonts.conf

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

    /etc/fonts/local.conf

    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
     <match target="font">
      
      <edit mode="assign" name="rgba">
       <const>rgb</const>
      </edit>

      <edit mode="assign" name="hinting">
       <bool>true</bool>
      </edit>

      <edit mode="assign" name="hintstyle">
       <const>hintfull</const>
      </edit>

      <edit mode="assign" name="antialias">
       <bool>true</bool>
      </edit>

      <edit mode="assign" name="lcdfilter">
        <const>lcddefault</const>
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

> Infinality: the generic way

The infinality patchset aims to greatly improve freetype2 font
rendering. It adds multiple new capabilities.

-   Home page.
-   Forum.

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

Note:The user bohoomil maintains a very good configuration in his github
repo which is available as a package in the AUR.

Note:Install grip-git from AUR to have a realtime preview.

freetype2-infinality can be installed from the AUR. Additionally, if you
are using lib32-freetype2 from [multilib], replace it with
lib32-freetype2-infinality from the AUR. The AUR also contains a Git
version of freetype2 that builds the latest development snapshot of
freetype2 with the Infinality patchset: freetype2-git-infinality,
lib32-freetype2-git-infinality.

It is recommended to also install fontconfig-infinality to enable
selection of predefined font substitution styles and antialiasing
settings, apart from the rendering settings of the engine itself. After
doing so, you can select the font style (win7, winxp, osx, linux, ...)
with:

    # infctl setstyle

If you set e.g. win7 or osx you need the corresponding fonts installed.

Note:Default infinality settings can cause some programs to display
fonts at 72 DPI instead of 96. If you notice a problem open
/etc/fonts/infinality/infinality.conf search for the section on DPI and
change 72 to 96. This problem can specifically affect conky causing the
fonts to appear smaller than they should. Thus not aligning properly
with images.

Note:The README for fontconfig-infinality says that
/etc/fonts/local.conf should either not exist, or have no
infinality-related configurations in it. The local.conf is now obsolete
and completely replaced by this configuration.

for more information see this article:
http://www.infinality.net/forum/viewtopic.php?f=2&t=77

-   Home page.

> Infinality: the easy way

bohoomil also maintains infinality-bundle repository, offering three
basic libraries (freetype2-infinality-ultimate,
fontconfig-infinality-ultimate & cairo-infinality-ultimate) as
pre-patched, pre-configured and pre-built binaries for all architectures
(i686, x86_64, multilib). Using infinality-bundle makes the whole
installation & configuration process dramatically simplified: all one
has to do is install the three packages with

    # pacman -S foo-infinality-ultimate

which will replace the corresponding, generic Arch libraries (i.e.
freetype2-infinality-ultimate will be used instead of freetype2,
fontconfig-infinality-ultimate instead of fontconfig and
fontconfig-infinality-ultimate from the AUR, and
cairo-infinality-ultimate instead of the regular cairo). The libraries
are fully compatible with the Arch packages and are meant to be used as
drop-in replacements for them. No post installation/upgrade steps are
required for most use scenarios: everything should work out of the box.

To use the repository, add

    [infinality-bundle]
    SigLevel = Never
    Server = http://bohoomil.cu.cc/infinality-bundle/$arch

to your /etc/pacman.conf and issue

    # pacman -Syy

If you want to have access to multilib versions, add the following, too:

    [infinality-bundle-multilib]
    SigLevel = Never
    Server = http://bohoomil.cu.cc/infinality-bundle-multilib/$arch

In case of server down times, there is always a backup copy of the
repository available via Dropbox.

When installing some packages (like libgdiplus), you may encounter an
error:

    :: cairo and cairo-infinality-ultimate are in conflict. Remove cairo-infinality-ultimate? [y/N] n
    error: unresolvable package conflicts detected
    error: failed to prepare transaction (conflicting dependencies)

If this happens, install the new package with

    # pacman -Sd foo

instead.

For more information, see infinality-bundle user notes.

A support thread in the Forums is available here.

> Ubuntu

Ubuntu adds extra configurations, and occasionally patches to the font
rendering libraries.

Install the patched packages from the AUR, the package names are:
freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu.

The global configuration will need to be added. See #Example fontconfig
configurations for a starting point.

> Reverting to unpatched packages

To restore the unpatched packages, reinstall the originals:

    # pacman -S --asdeps freetype2 cairo fontconfig

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
Xorg#Display Size and DPI. This is the recommended solution, but it may
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

> Older GTK and QT applications

Modern GTK apps enable Xft by default but this was not the case before
version 2.2. If it is not possible to update these applications, force
Xft for old GNOME applications by adding to ~/.bashrc:

    export GDK_USE_XFT=1

For older QT applications:

    export QT_XFT=true

> Applications overriding hinting

Some applications may override default fontconfig hinting and
anti-aliasing settings. This may happen with Gnome 3, for example. Use
the specific configuration program for the application in such cases.
For gnome, try gnome-tweak-tool.

See also
--------

-   Fonts in X11R6.8.2 - Official Xorg font information
-   FreeType 2 Overview
-   Gentoo font-rendering thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Font_Configuration&oldid=256079"

Category:

-   Fonts
