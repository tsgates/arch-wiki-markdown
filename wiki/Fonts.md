Fonts
=====

From Wikipedia:

A computer font (or font) is an electronic data file containing a set of
glyphs, characters, or symbols such as dingbats.

> Summary

Covers the selection and installation of fonts on Arch Linux

> Legal

Certain font licenses may impose some legal limitations

> Related

Font Configuration: Font setup and beautification

Java Runtime Environment Fonts: Fonts specific to Sun's Java machine

MS Fonts: Adding Microsoft fonts and mimicking Windows' font settings

KEYMAP: Information on keyboard layouts

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Font formats                                                       |
|     -   1.1 Common extensions                                            |
|     -   1.2 Other formats                                                |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Pacman                                                       |
|     -   2.2 Creating a package                                           |
|     -   2.3 Manual installation                                          |
|         -   2.3.1 Older applications                                     |
|                                                                          |
|     -   2.4 Pango Warnings                                               |
|     -   2.5 Fonts with X.Org                                             |
|                                                                          |
| -   3 Console fonts                                                      |
|     -   3.1 Previewing and testing                                       |
|         -   3.1.1 Examples                                               |
|                                                                          |
|     -   3.2 Changing the default font                                    |
|         -   3.2.1 Examples                                               |
|         -   3.2.2 Boot Error                                             |
|                                                                          |
| -   4 Font packages                                                      |
|     -   4.1 Braille                                                      |
|     -   4.2 International users                                          |
|         -   4.2.1 Arabic                                                 |
|         -   4.2.2 Birman                                                 |
|         -   4.2.3 Chinese, Japanese, Korean, Vietnamese                  |
|             -   4.2.3.1 (Mainly) Chinese                                 |
|             -   4.2.3.2 Japanese                                         |
|             -   4.2.3.3 Korean                                           |
|                                                                          |
|         -   4.2.4 Cyrillic                                               |
|         -   4.2.5 Greek                                                  |
|         -   4.2.6 Hebrew                                                 |
|         -   4.2.7 Indic                                                  |
|         -   4.2.8 Khmer                                                  |
|         -   4.2.9 Sinhala                                                |
|         -   4.2.10 Tamil                                                 |
|         -   4.2.11 Tibetan                                               |
|                                                                          |
|     -   4.3 Math                                                         |
|     -   4.4 Microsoft fonts                                              |
|     -   4.5 Apple Mac OS X fonts                                         |
|     -   4.6 Monospaced                                                   |
|         -   4.6.1 TrueType                                               |
|         -   4.6.2 Bitmap                                                 |
|                                                                          |
|     -   4.7 Sans-serif                                                   |
|     -   4.8 Script                                                       |
|     -   4.9 Serif                                                        |
|     -   4.10 Unsorted                                                    |
|                                                                          |
| -   5 Fallback font order with X11                                       |
| -   6 Font alias                                                         |
| -   7 Hints                                                              |
|     -   7.1 Install fonts from official repositories                     |
+--------------------------------------------------------------------------+

Font formats
------------

Most computer fonts used today are in either bitmap or outline data
formats.

Bitmap fonts
    Consist of a matrix of dots or pixels representing the image of each
    glyph in each face and size.
Outline or vector fonts
    Use Bézier curves, drawing instructions and mathematical formulae to
    describe each glyph, which make the character outlines scalable to
    any size.

> Common extensions

-   bdf and bdf.gz – bitmap fonts, bitmap distribution format and gzip
    compressed bdf
-   pcf and pcf.gz – bitmaps, portable compiled font and gzip compressed
    pcf
-   psf, psfu, psf.gz and psfu.gz – bitmaps, PC screen font, PC screen
    font Unicode and the gzipped versions (not compatible with X.Org)
-   pfa and pfb – outline fonts, PostScript font ASCII and PostScript
    font binary. PostScript fonts carry built-in printer instructions.
-   ttf – outline, TrueType font. Originally designed as a replacement
    for the PostScript fonts.
-   otf – outline, OpenType font. TrueType with PostScript typographic
    instructions.

For most purposes, the technical differences between TrueType and
OpenType can be ignored, some fonts with a ttf extension are actually
OpenType fonts.

> Other formats

The typesetting application, TeX, and its companion font software,
Metafont, render characters using their own methods. Some of the file
extensions used for fonts by these two programs are *pk, *gf, mf and vf.

FontForge, a font editing application, can store fonts in its native
text-based format, sfd, spline font database.

The SVG format also has its own font description method.

Installation
------------

There are various methods for installing fonts.

> Pacman

Fonts and font collections in the enabled repositories can be installed
using pacman. Available fonts may be found by using:

    $ pacman -Ss font

Or to search for ttf fonts only:

    $ pacman -Ss ttf

Some fonts like terminus-font are installed in /usr/share/fonts/local,
which is not added to the font path by default. By adding the following
lines to ~/.xinitrc, the fonts can be used in X11:

    xset +fp /usr/share/fonts/local
    xset fp rehash

> Creating a package

You should give pacman the ability to manage your fonts, which is done
by creating an Arch package. These can also be shared with the community
in the AUR. Here is an example of how to create a basic package. To
learn more about building packages, read PKGBUILD.

    pkgname=ttf-fontname
    pkgver=1.0
    pkgrel=1
    depends=('fontconfig' 'xorg-font-utils')
    pkgdesc="custom fonts"
    arch=('any')
    source=(http://someurl.org/$pkgname.tar.bz2)
    install=$pkgname.install

    package() {
      install -d "$pkgdir/usr/share/fonts/TTF"
      cp -dpr --no-preserve=ownership "$srcdir/$pkgname/"*.ttf "$pkgdir/usr/share/fonts/TTF/"
    }

This PKGBUILD assumes the fonts are TrueType. An install file
(ttf-fontname.install) will also need to be created to update the font
cache:

    post_install() {
      echo -n "Updating font cache... "
      fc-cache -fs >/dev/null
      mkfontscale /usr/share/fonts/TTF /usr/share/fonts/Type1
      mkfontdir /usr/share/fonts/TTF /usr/share/fonts/Type1
      echo "done"
    }

    post_upgrade() {
      post_install
    }

    post_remove() {
      post_install
    }

> Manual installation

The recommended way of adding fonts that are not in the repositories to
your system is described in #Creating a package. This gives pacman the
ability to remove or update them at a later time. Fonts can alternately
be installed manually as well.

To install fonts system-wide (available for all users), move the folder
to the /usr/share/fonts/ directory. To install fonts for only a single
user, use ~/.fonts/ instead.

Also you may need to update /etc/X11/xorg.conf or /etc/xorg.conf with
the new directory. Search for FontPath to find the correct location
within the file to add your new path. See #Fonts with X.Org for more
detail.

Then update the fontconfig font cache:

    $ fc-cache -vf

Older applications

With older applications that do not support fontconfig (e.g. GTK+ 1.x
applications, and xfontsel) the index will need to be created in the
font directory:

    $ mkfontscale
    $ mkfontdir

Or to include more than one folder with one command:

    $ for dir in /font/dir1/ /font/dir2/; do xset +fp $dir; done && xset fp rehash

At times the X server may fail to load the fonts directory and you will
need to rescan all the fonts.dir files:

    # xset +fp /usr/share/fonts/misc # Inform the X server of new directories
    # xset fp rehash                # Forces a new rescan

To check that the font(s) is included:

    $ xlsfonts | grep fontname

> Pango Warnings

When Pango is in use on your system it will read from fontconfig to sort
out where to source fonts.

    (process:5741): Pango-WARNING **: failed to choose a font, expect ugly output. engine-type='PangoRenderFc', script='common'
    (process:5741): Pango-WARNING **: failed to choose a font, expect ugly output. engine-type='PangoRenderFc', script='latin'

If you are seeing errors similar to this and/or seeing blocks instead of
characters in your application then you need to add fonts and update the
font cache. This example uses the ttf-liberation fonts to illustrate the
solution and runs as root to enable them system-wide.

    # pacman -S ttf-liberation
      -- output abbreviated, assumes installation succeeded -- 

    # fc-cache -vfs
    /usr/share/fonts: caching, new cache contents: 0 fonts, 3 dirs
    /usr/share/fonts/TTF: caching, new cache contents: 16 fonts, 0 dirs
    /usr/share/fonts/encodings: caching, new cache contents: 0 fonts, 1 dirs
    /usr/share/fonts/encodings/large: caching, new cache contents: 0 fonts, 0 dirs
    /usr/share/fonts/util: caching, new cache contents: 0 fonts, 0 dirs
    /var/cache/fontconfig: cleaning cache directory   
    fc-cache: succeeded

You can test for a default font being set like so:

    # fc-match
    LiberationMono-Regular.ttf: "Liberation Mono" "Regular"

> Fonts with X.Org

In order for Xorg to find and use your newly installed fonts, you must
add the font paths to /etc/X11/xorg.conf (another X.Org configuration
file may work too).

Here is an example of the section that must be added to
/etc/X11/xorg.conf. Add or remove paths based on your particular font
requirements.

    # Let X.Org know about the custom font directories
    Section "Files"
        FontPath    "/usr/share/fonts/100dpi"
        FontPath    "/usr/share/fonts/75dpi"
        FontPath    "/usr/share/fonts/cantarell"
        FontPath    "/usr/share/fonts/cyrillic"
        FontPath    "/usr/share/fonts/encodings"
        FontPath    "/usr/share/fonts/local"
        FontPath    "/usr/share/fonts/misc"
        FontPath    "/usr/share/fonts/truetype"
        FontPath    "/usr/share/fonts/TTF"
        FontPath    "/usr/share/fonts/util"
    EndSection

Console fonts
-------------

The console, meaning a terminal running with no X Window System, uses
the ASCII character set as the default. This font and the keymap used
are easily changed.

A console font is limited to either 256 or 512 characters. The fonts are
found in /usr/share/kbd/consolefonts/.

Keymaps, the connection between the key pressed and the character used
by the computer, are found in the subdirectories of
/usr/share/kbd/keymaps/.

> Previewing and testing

An organized library of images for previewing is available at
http://alexandre.deverteuil.net/consolefonts/consolefonts.html.

Moreover, the user can use setfont to temporarily change the font and be
able to consider its use as the default. The available glyphs, or
letters in the font can also be viewed as a table with the command
showconsolefont.

If the newly changed font is not suitable, a return to the default font
is done by issuing the command setfont without any arguments. If the
console display is totally unreadable, this command will still work—the
user just types in setfont while "working blind."

Note that setfont only works on the console currently being used. Any
other consoles, active or inactive, remain unaffected.

Examples

Change the font. This example is distinctive:

    $ setfont /usr/share/kbd/consolefonts/gr737b-9x16-medieval.psfu.gz

Or change the font to one with 512 glyphs and set the keymap to ISO
8859-5 using the -m option:

    $ setfont /usr/share/kbd/consolefonts/LatArCyrHeb-16.psfu.gz -m 8859-5

Then issue commands that send text to the display, perhaps view a
manpage and try vi or nano, and view the table of glyphs with the
command, showconsolefont.

Return to the default font with:

    $ setfont

> Changing the default font

To change the default font, the FONT= and FONT_MAP= settings in
/etc/vconsole.conf (this file may need to be created) must be altered.
Again, the fonts can be found in /usr/share/kbd/consolefonts/ directory
and keymaps can be found in the subdirectories of
/usr/share/kbd/keymaps/.

Examples

For displaying characters such as Č, ž, đ, š or Ł, ę, ą, ś using the
font lat2-16.psfu.gz:

    FONT=lat2-16

It means that second part of ISO/IEC 8859 characters are used with size
16. You can change font size using other values like lat2-08...16. For
the regions determined by 8859 specification, look at the Wikipedia. You
can use a Terminus font which is recommended if you work a lot in
console without X server. ter-216b for example is latin-2 part, size 16,
bold. ter-216n is the same but normal weight. Terminus fonts have sizes
up to 32.

Now, set the proper keymap, for lat2-16 it will be:

    FONT_MAP=8859-2

To use the specified font in early userspace, that is, early in the
bootup process, add the consolefont hook to /etc/mkinitcpio.conf:

    HOOKS="base udev autodetect modconf block filesystems keyboard fsck consolefont keymap"

Then rebuild the image:

    # mkinitcpio -p linux

Note:The above steps must be repeated for each kernel if more than one
kernel package is installed.

See Mkinitcpio#HOOKS for more information.

If the fonts seems to not change on boot, or change only temporarily, it
is most likely that they got reset when graphics driver was initialized
and console was switched to framebuffer. To avoid this, load your
graphics driver earlier. See for example KMS#Early_KMS_start or other
ways to setup your framebuffer before /etc/vconsole.conf gets applied.

Boot Error

If "Loading Console Font" fails at boot time, this is probably because
you did not choose a valid font during your Arch Linux install.

To get rid of this message, simply empty the CONSOLEFONT variable in
/etc/rc.conf. It will fallback on default font at boot.

Font packages
-------------

This is a selective list that includes many font packages from the AUR
along with those in the official repositories. Fonts are tagged
"Unicode" if they have wide Unicode support, see the project or
Wikipedia pages for detail.

Github user Ternstor has created a python script that generates PNG
images of all fonts in extra, community and the AUR so you can preview
all the fonts below.

> Braille

-   ttf-ubraille - Font containing Unicode symbols for braille

> International users

Arabic

-   ttf-qurancomplex-fonts - Fonts by King Fahd Glorious Quran Printing
    Complex in al-Madinah al-Munawwarah (AUR)
-   ttf-amiri - A classical Arabic typeface in Naskh style poineered by
    Amiria Press (AUR)
-   ttf-sil-lateef - Unicode Arabic font from SIL (AUR)
-   ttf-sil-scheherazade - Unicode Arabic font from SIL (AUR)
-   ttf-arabeyes-fonts - Collection of free Arabic fonts (AUR)

Birman

-   ttf-myanmar3 - Font for Myanmar/Burmese script (AUR)

Chinese, Japanese, Korean, Vietnamese

(Mainly) Chinese

-   ttf-tw - Kai and Song traditional Chinese font from the Ministry of
    Education of Taiwan (AUR).
-   wqy-microhei - A Sans-Serif style high quality CJKV outline font.
-   wqy-zenhei - Hei Ti Style (sans-serif) Chinese Outline font embedded
    with bitmapped Song Ti (also supporting Japanese (partial) and
    Korean characters).
-   ttf-arphic-ukai - Kaiti (brush stroke) Unicode font (enabling
    anti-aliasing is suggested)
-   ttf-arphic-uming - Mingti (printed) Unicode font
-   opendesktop-fonts - New Sung font, previously is ttf-fireflysung
    package
-   wqy-bitmapfont - Bitmapped Song Ti (serif) Chinese font
-   ttf-hannom - Chinese and Vietnamese TrueType font

Japanese

-   otf-ipafont - Formal style Japanese Gothic (sans-serif) and Mincho
    (serif) fonts set; one of the highest quality open source font.
    Default of openSUSE-ja. (AUR)
-   ttf-vlgothic - Japanese Gothic fonts. Default of Debian/Fedora/Vine
    Linux (AUR)
-   ttf-mplus - Modern Gothic style Japanese outline fonts. It includes
    all of Japanese Hiragana/Katakana, Basic Latin, Latin-1 Supplement,
    Latin Extended-A, IPA Extensions and most of Japanese Kanji, Greek,
    Cyrillic, Vietnamese with 7 weights (proportional) or 5 weights
    (monospace). (AUR)
-   ttf-ipa-mona, ttf-monapo - Japanese fonts to show 2channel Shift JIS
    art properly. (AUR)
-   ttf-sazanami - Japanese free TrueType font. This is outdated and not
    maintained any more, but may be defined as a fallback font on
    several environments.

Korean

-   ttf-baekmuk - Collection of Korean TrueType fonts
-   ttf-alee - Set of free Hangul TrueType fonts (AUR)
-   ttf-unfonts-core - Un fonts (default Baekmuk fonts may be
    unsatisfactory) (AUR)
-   ttf-nanum - Nanum series TrueType fonts (AUR)
-   ttf-nanumgothic_coding - Nanum series fixed width TrueType fonts
    (AUR)

Cyrillic

Also see #Monospace, #Sans and #Serif

-   font-arhangai - Mongolian Cyrillic (AUR)
-   ttf-pingwi-typography - PingWi Typography (PWT) fonts (AUR)

Greek

Almost all Unicode fonts contain the Greek character set (polytonic
included). Some additional font packages, which might not contain the
complete Unicode set but utilize high quality Greek (and Latin, of
course) typefaces are:

-   otf-gfs - Selection of OpenType fonts from the Greek Font Society
    (AUR)
-   ttf-mgopen - Professional TrueType fonts from Magenta (AUR)

Hebrew

-   culmus - Nice collection of free Hebrew fonts (AUR)

Indic

-   ttf-freebanglafont - Font for Bangla
-   ttf-indic-otf - Indic OpenType Fonts collection (containing
    ttf-freebanglafont)

(This one contains a "look of disapproval" that might be more to your
liking than the bdf-unifont one mentioned elsewhere in this document)

-   lohit-fonts - Indic TrueType fonts from Fedora Project (containing
    Oriya Fonts and more) (AUR)

Khmer

-   ttf-khmer - Font covering glyphs for Khmer language
-   Hanuman (ttf-google-fonts-hg or ttf-google-fonts-git)

Sinhala

-   ttf-lklug - Sinhala Unicode font (AUR)

Tamil

-   ttf-tamil - Tamil Unicode fonts (AUR)

Tibetan

-   ttf-tibetan-machine - Tibetan Machine TTFont

> Math

-   font-mathematica - Mathematica fonts by Wolfram Research, Inc.
-   ttf-mathtype - MathType fonts (AUR)
-   ttf-computer-modern-fonts - (AUR)

> Microsoft fonts

See MS Fonts.

> Apple Mac OS X fonts

-   ttf-mac-fonts - Mac OS X TrueType fonts
-   ttf-mac - Mac OS X TrueType fonts (This package does not come with
    the ttf fonts (only the otf fonts), they have to be provided on
    their own.

> Monospaced

Here are some suggestions. Every user has their own favorite, so
experiment to find yours. If you are in a hurry, you read Dan Benjamin's
blog post: Top 10 Programming Fonts.

Here is a long list of fonts by Trevor Lowing:
http://www.lowing.org/fonts/.

TrueType

-   Agave (ttf-agave)
-   Andalé Mono (ttf-ms-fonts)
-   Anka/Coder (ttf-anka-coder)
-   Anonymous Pro (ttf-anonymous-pro, included in ttf-google-fonts-hg
    and ttf-google-fonts-git)
-   Bitstream Vera Mono (ttf-bitstream-vera)
-   Consolas (ttf-vista-fonts) - Windows programming font
-   Courier New (ttf-ms-fonts)
-   Cousine (ttf-google-fonts-hg or ttf-google-fonts-git) -
    Chrome/Chromium OS replacement for Courier New (metric-compatible)
-   DejaVu Sans Mono (ttf-dejavu) - Unicode
-   Droid Sans Mono (ttf-droid, included in ttf-google-fonts-hg and
    ttf-google-fonts-git)
-   Envy Code R (ttf-envy-code-r)
-   FreeMono (ttf-freefont) - Unicode
-   Inconsolata (ttf-inconsolata) - Excellent programming font
-   Inconsolata-g (ttf-inconsolata-g) - adds some programmer-friendly
    modifications
-   Anonymous-Pro (ttf-anonymous-pro)
-   Liberation Mono (ttf-liberation) - Alternative to Courier New
    (metric-compatible)
-   Lucida Console (ttf-ms-fonts)
-   Lucida Typewriter (included in package jre)
-   Monaco (ttf-monaco) - Popular programming font on OSX/Textmate
-   Monofur (ttf-monofur)

Bitmap

-   Default 8x16
-   Dina (dina-font)
-   Gohu (gohu-font)
-   Lime (artwiz-fonts)
-   ProFont (profont)
-   Proggy Programming Fonts (proggyfonts)
-   Proggy opti cyrillic (proggyopticyr-font)
-   Tamsyn (tamsyn-font)
-   Terminus (terminus-font)
-   Unifont (glyphs like (look of disapproval)) (bdf-unifont)

> Sans-serif

-   Andika (ttf-andika, included in ttf-sil-fonts)
-   Arial (ttf-ms-fonts)
-   Arial Black (ttf-ms-fonts)
-   Arimo (ttf-google-fonts-hg or ttf-google-fonts-git) -
    Chrome/Chromium OS replacement for Arial (metric-compatible)
-   Calibri (ttf-vista-fonts)
-   Candara (ttf-vista-fonts)
-   Constantia (ttf-vista-fonts)
-   Corbel (ttf-vista-fonts)
-   DejaVu Sans (ttf-dejavu) - Unicode
-   Droid Sans (ttf-droid, included in ttf-google-fonts-hg and
    ttf-google-fonts-git)
-   FreeSans (ttf-freefont) - Unicode
-   Impact (ttf-ms-fonts)
-   Liberation Sans (ttf-liberation, improved/reworked Cyrillic:
    ttf-liberastika) - Alternative to Arial (metric-compatible)
-   Linux Biolinum (ttf-linux-libertine)
-   Lucida Sans (ttf-ms-fonts)
-   Microsoft Sans Serif (ttf-ms-fonts)
-   PT Sans (ttf-google-fonts-hg or ttf-google-fonts-git) - 3 major
    variations: normal, narrow, and caption - Unicode: Latin, Cyrillic
-   Tahoma (ttf-tahoma)
-   Trebuchet (ttf-ms-fonts)
-   Ubuntu-Title (ttf-ubuntu-title)
-   Ubuntu Font Family (ttf-ubuntu-font-family)
-   Verdana (ttf-ms-fonts)

> Script

-   Comic Sans (ttf-ms-fonts)

> Serif

-   Cambria (ttf-vista-fonts)
-   Charis (ttf-charis, included in ttf-sil-fonts) - Unicode: Latin,
    Cyrillic
-   DejaVu Serif (ttf-dejavu) - Unicode
-   Doulos (doulos-sil, included in ttf-sil-fonts) - Unicode: Latin,
    Cyrillic
-   Droid Serif (ttf-droid, included in ttf-google-fonts-hg and
    ttf-google-fonts-git)
-   FreeSerif (ttf-freefont) - Unicode
-   Gentium (ttf-gentium, included in ttf-sil-fonts) - Unicode: Latin,
    Greek, Cyrillic, Phonetic Alphabet
-   Georgia (ttf-ms-fonts)
-   Liberation Serif (ttf-liberation) - Alternative to Times New Roman
    (metric-compatible)
-   Linux Libertine (ttf-linux-libertine) - Unicode: Latin, Greek,
    Cyrillic, Hebrew
-   Times New Roman (ttf-ms-fonts)
-   Tinos (ttf-google-fonts-hg or ttf-google-fonts-git) -
    Chrome/Chromium OS replacement for Times New Roman
    (metric-compatible)

> Unsorted

-   ttf-google-fonts-git and ttf-google-fonts-hg — a huge collection of
    free fonts (including ubuntu, inconsolata, droid, etc.) - Note: Your
    font dialog might get very long as >100 fonts will be added.
    ttf-google-fonts-hg pulls down the entire Mercurial repository from
    the upstream Web Fonts project. ttf-google-fonts-git pulls from a
    much smaller and leaner unofficial repository hosted on GitHub.
    (AUR)
-   ttf-mph-2b-damase — Covers full plane 1 and several scripts
-   ttf-symbola — Provides emoji and many many other symbols. (AUR)
-   ttf-sil-fonts — Gentium, Charis, Doulos, Andika and Abyssinica from
    SIL (AUR)
-   font-bh-ttf — X.Org Luxi fonts
-   ttf-cheapskate — Font collection from dustismo.com
-   ttf-isabella — Calligraphic font based on the Isabella Breviary of
    1497
-   ttf-junicode — Junius font containing almost complete medieval latin
    script glyphs
-   arkpandorafonts ttf-arkpandora — Alternative to Arial and Times New
    Roman fonts (AUR)
-   xorg-fonts-type1 — IBM Courier and Adobe Utopia sets of PostScript
    fonts

Fallback font order with X11
----------------------------

Fontconfig automatically chooses a font that matches the current
requirement. That is to say, if one is looking at a window containing
English and Chinese for example, it will switch to another font for the
Chinese text if the default one does not support it.

Fontconfig lets every user configure the order they want via
$XDG_CONFIG_HOME/fontconfig/fonts.conf. If you want a particular Chinese
font to be selected after your favorite Serif font, your file would look
like this:

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
    <alias>
       <family>serif</family>
       <prefer>
         <family>Your favorite Latin Serif font name</family>
         <family>Your Chinese font name</family>
       </prefer>
     </alias>
    </fontconfig>

You can add a section for Sans-serif and monospaced as well. For more
informations, have a look at the fontconfig manual.

Font alias
----------

In Linux there are several font aliases which represent other fonts in
order that applications may use similar fonts. The most common aliases
are: serif for a font of the serif type (e.g. DejaVu Serif); sans-serif
for a font of the sans-serif type (e.g. DejaVu Sans); and monospace for
a monospaced font (e.g. DejaVu Sans Mono). However, the fonts which
these aliases represent may vary and the relationship is often not shown
in font management tools such as those found in KDE and other desktop
environments.

To reverse an alias and find which font it is representing, run:

    $ fc-match monospace
    DejaVuSansMono.ttf: "DejaVu Sans Mono" "Book"

In this case DejaVuSansMono.ttf is the font represented by the monospace
alias.

Hints
-----

> Install fonts from official repositories

Maybe you want to install all fonts available in official repositories.

All fonts
    

    $ pacman -S $(pacman -Ssq font)

All TrueType fonts
    

    $ pacman -S $(pacman -Ssq ttf)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fonts&oldid=256148"

Categories:

-   Fonts
-   Graphics and desktop publishing
