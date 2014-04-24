Infinality-bundle+fonts
=======================

Related articles

-   Fonts
-   Font Configuration
-   MS Fonts

Infinality-bundle is a collection of software providing an easy,
"install-and-forget" method of improving text rendering in Arch Linux.
The packages are fully compatible with system libraries available in the
extra repository and are meant to be used as drop-in replacements for
them.

Currently, the bundle comprises:

-   freetype2-infinality-ultimate - freetype2 built with Infinality and
    additional patches.
-   fontconfig-infinality-ultimate - fontconfig optimized for use with
    freetype2-infinality-ultimate, including separate configuration
    presets for free (default), MS and custom font collections.
-   cairo-infinality-ultimate - cairo built with Ubuntu and additional
    patches.

All libraries are built in a clean chroot environment and are available
for both i686 and x86_64 architectures, including multilib support.

For best results and users' convenience, a complementary repository
infinality-bundle-fonts is available, offering a wide selection of all
necessary typefaces needed to create and reproduce hypertext documents.
All fonts were manually selected, ensuring high quality text rendering
as well as compatibility with proprietary equivalents used for the Web
and the office. All fonts are 100% freely available and are licensed
under GPL, OFL, Apache or compatible, non-restrictive licenses.

By default, no post installation configuration is required. However, for
maximum flexibility users can easily customize the bundle depending on
their needs.

Contents
--------

-   1 Installation
-   2 Recommended fonts with restricted licenses
-   3 Customization and troubleshooting
-   4 See also

Installation
------------

A typical and recommended setup consists of both libraries for a
selected architecture and the basic collection of fonts:

1.  Add the infinality-bundle, infinality-bundle-multilib (if on x86_64)
    and infinality-bundle-fonts repositories to your /etc/pacman.conf.
    Follow the instructions given in the Unofficial user repositories
    article.
2.  Install the following groups/meta packages, containing libraries and
    minimal font collection: infinality-bundle,
    infinality-bundle-multilib, ibfonts-meta-base
3.  Restart the X server

When pacman resolves dependencies and encounters a conflicting package,
e.g.:

    resolving dependencies...
    looking for inter-conflicts...
    :: freetype2-infinality-ultimate and freetype2 are in conflict. Remove freetype2? [y/N]

answer yes.

If you want to install the extended font collection, which is a free
equivalent of the proprietary Microsoft's fonts supplied with MS Windows
and MS Office, use ibfonts-meta-extended meta package instead. Of
course, infinality-bundle-multilib is an option, too.

In case of occasional server down times, there is always a backup copy
of the repositories available via Dropbox.

Recommended fonts with restricted licenses
------------------------------------------

Below you will find a list of fonts that cannot be freely redistributed
and thus could not be included in the infinality-bundle-fonts collection
as binary packages. However, they can still be installed and used free
of charge under specified conditions. Source packages can be found in
the AUR. Please, read the EULAs for details before you use the fonts!

-   otf-brill
-   otf-neris
-   ttf-aller
-   ttf-envy-code-r

Customization and troubleshooting
---------------------------------

-   If you want to install even more fonts, there is an additional
    infinality-bundle-fonts-extra collection. Run

    # pacman -Ss infinality-bundle-fonts-extra

to list available packages.

> Note:

-   Before you install any third party font from either official
    repositories or the AUR, always check if it is available in the
    infinality-bundle-fonts collection.
-   Do not attempt to install the entire infinality-bundle-fonts-extra
    group. Unless you know for sure you need any of the fonts available
    there, you will only unnecessarily clutter your hard drive and
    decrease performance of the font cache. ibfonts-meta-extended should
    suffice in most, even very complex, use scenarios.

-   If you want to override default font substitutions set in
    /etc/fonts/conf.d/37-repl-global-preset.conf or add new ones, use
    /etc/fonts/conf.d/36-repl-custom.conf to do so. You will need to
    duplicate the template (16 lines of code) for each font family to be
    replaced and provide appropriate font names.

-   One frequent issue users may face with this repositories is that the
    package database or signatures do not correspond. Often a simple
    force refresh of the package lists (pacman -Syy) will fix the issue.
    If that fails, try removing the infinality-bundle files from
    /var/lib/pacman/sync and then resyncing again.

-   It is possible to skip installation of infinality-bundle-fonts if
    you want to use Microsoft proprietary font collection instead. If
    this is the case, you have to activate fontconfig MS preset to
    ensure the correct set of fonts is selected. To do so, issue

    # fc-presets set

    1) custom
    2) ms
    3) free
    4) reset
    5) quit
    Enter your choice...

and select 2.

Run fc-presets help for more information.

-   If you would rather use a custom font collection, there is a custom
    preset available that should let you adjust fontconfig parameters
    accordingly. When you activate the custom preset, the content of
    'custom' configuration files
    (/etc/fonts/conf.avail.infinality/custom) can be freely modified.
    When you are done, do not forget to create a backup copy of the
    'custom' directory.

-   To solve rendering issues in Google Chrome browser described in this
    post, edit /etc/fonts/fonts.conf file and uncomment the following
    entry:

    <!--match target="pattern">
    <edit name="dpi" mode="assign">
    <double>72</double>
    </edit>
    </match-->

-   Emacs users have reported issues with the default variable pitch
    typeface after installation of infinality-bundle-fonts. To make
    Emacs behave correctly with free fonts, you have to specify a
    variable pitch family in $HOME/.emacs, which can be any but Noto
    Sans (a.k.a. 'sans' or 'system font'), e.g.:

    (custom-set-faces
     '(default ((t (:family "Liberation Mono" :slant normal :weight regular :height 98))))
     '(variable-pitch ((t (:family "Liberation Sans" :slant normal :weight regular :height 98 )))))

-   GIMP users have reported issues with the subpixel rendering of text
    in images. The best course of action is to disable subpixel
    rendering completely for GIMP. Add a file /etc/gimp/2.0/fonts.conf
    (or ~/gimp-2.8/fonts.conf for a single user) with the following
    content:

    /etc/gimp/2.0/fonts.conf

    <fontconfig>
      <match target="font">
        <edit name="rgba" mode="assign">
          <const>none</const>
        </edit>
      </match>
    </fontconfig>

-   Users of popular Desktop Environments (Gnome, KDE, Xfce4, Cinnamon,
    LXDE) should adjust font settings via their DE's control panel.
    Basically, the settings should duplicate those found in the
    freetype2 configuration file
    (/etc/profile.d/infinality-settings.sh):

    Xft.antialias: 1
    Xft.autohint: 0
    Xft.dpi: 96
    Xft.hinting: 1
    Xft.hintstyle: hintfull
    Xft.lcdfilter: lcddefault
    Xft.rgba: rgb

If your DE's control panel does not let you set any of the above, adjust
only those available.

-   Some language specifics diacritics / glyphs are displayed
    inconsistently using default font.

This is usually the case with websites (notably blogs) utilizing
predefined CSS templates that make use of web fonts missing support for
extended Latin scripts (most often A and B). Even though this is not a
problem with any of the infinality-bundle components and thus should be
fixed by the author / maintainer of the problematic site, it can still
be got round by creating a relevant font replacement rule in fontconfig.
If you want to use this option, activate 36-repl-missing-glyphs.conf
first:

    $ cd /etc/fonts/conf.d
    $ ln -s ../conf.avail.infinality/36-repl-missing-glyphs.conf .

and then edit the file accordingly following the provided example.

Note:Default fonts for non-Latin scripts are set in
65-non-latin-preset.conf (default settings) and
93-final-lang-spec-preset.conf (to override default rules).

-   Overriding default replacement rules and adding custom ones is
    possible with 35-repl-custom.conf. The file is activated by default,
    so all you need to do is edit if you want to use it.

-   If you experience general problems with fonts (e.g. certain glyphs
    are not loaded in PDF documents, while a font family providing them
    has been correctly installed), start troubleshooting by issuing

    # fc-cache -fr

This will remove the entire font cache and recreate it from scratch.

See also
--------

-   fontconfig-ultimate - git repository providing all patches,
    configuration files and build scripts for the entire
    infinality-bundle+fonts collection in separate branches (master -
    the most recent release, infinality-bundle - archive, pkgbuild -
    Arch Linux build scripts)
-   infinality-bundle user notes (to be updated soon)
-   infinality-bundle: good looking fonts made (even) easier -
    infinality-bundle support thread in the Arch Linux Forums
-   infinality-bundle-fonts: a free multilingual font collection for
    Arch - infinality-bundle-fonts support thread in the Arch Linux
    Forums

Retrieved from
"https://wiki.archlinux.org/index.php?title=Infinality-bundle%2Bfonts&oldid=304222"

Category:

-   Fonts

-   This page was last modified on 12 March 2014, at 22:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
