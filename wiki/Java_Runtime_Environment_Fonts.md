Java Runtime Environment Fonts
==============================

Summary

Instructions are given to improve the display of fonts in Java
applications when using Oracle's Java Runtime Environment

Related

Fonts: Information on adding fonts and font recommendations

Font Configuration: Font setup and beautification

MS Fonts: Adding Microsoft fonts and mimicking Windows' font settings

X Logical Font Description: The core X server font system

Some users may find the default Java fonts or the display mode of fonts
in Java applications to be unpleasant. Several methods to improve the
font display in the Oracle Java Runtime Environment (JRE) are available.
These methods may be used separately, but many users will find they
achieve better results by combining them.

TrueType fonts appear to be the best supported format for use with Java.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Anti-aliasing                                                      |
| -   2 Font selection                                                     |
|     -   2.1 TrueType fonts                                               |
|     -   2.2 Default fonts                                                |
+--------------------------------------------------------------------------+

Anti-aliasing
-------------

Anti-aliasing of fonts is available with Oracle Java 1.6 on Linux. To do
this on a per user basis, add the following line to the user's
~/.bashrc.

    export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'

TrueType fonts contain a grid-fitting and scan-conversion procedure
(GASP) table with the designer's recommendations for the font's display
at different point sizes. Some sizes are recommended to be fully
anti-aliased, others are to be hinted, and some are to be displayed as
bitmaps. Combinations are sometimes used for certain point sizes.

Replace setting with one of the following seven values:

-   off or false or default – No anti-aliasing
-   on – Full anti-aliasing
-   gasp – Use the font's built-in hinting instructions
-   lcd or lcd_hrgb – Anti-aliasing tuned for many popular LCD monitors
-   lcd_hbgr – Alternative LCD monitor setting
-   lcd_vrgb – Alternative LCD monitor setting
-   lcd_vbgr – Alternative LCD monitor setting

The gasp and lcd settings work well in many instances.

Optionally to use GTK look and feel, add the following line to .bashrc
instead. Note that the Java options described above and this one only
work for applications that draw their GUI in Java, like Jdownloader, and
not for applications which utilize Java as backend only, like
Openoffice.org and Matlab.

    export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' 

For the above change to take effect, ~/.bashrc must be sourced as the
normal user.

    $ source ~/.bashrc

Open a new instance of a Java application to test the changes made.

Font selection
--------------

> TrueType fonts

Some Java applications may specify use of a particular TrueType font;
these applications must be made aware of the directory path to the
desired font. TrueType fonts are installed in the directory
/usr/share/fonts/TTF. Add the following line to ~/.bashrc to enable
these fonts.

    export JAVA_FONTS=/usr/share/fonts/TTF

Source ~/.bashrc as the normal user for the change to take effect.

    $ source ~/.bashrc

> Default fonts

The Lucida fonts distributed with the Sun JRE are the default for Java
applications that do not specify a different font's use. The Lucida
fonts were designed for low resolution displays and printers; many users
will wish to use other fonts. The default Java fonts can be changed on a
system-wide basis by the creation or editing of a file named
fontconfig.properties.

As root, change directory to /opt/java/jre/lib. Copy
fontconfig.properties.src to fontconfig.properties. Then, as root, open
the new fontconfig.properties in an editor.

    # cd /opt/java/jre/lib
    # cp fontconfig.properties.src fontconfig.properties
    # nano fontconfig.properties

Note:Encodings other than Latin-1, or ISO-8859-1, are shown in other
fontconfig.properties.*.src files in /opt/java/jre/lib. Some users will
find these files to be better sources to use for editing. In all cases
the edited file should be saved as fontconfig.properties.

  
 The Java font names in the configuration file are in the form of
genericFontName.style.subset, for example, serif.plain.latin-1. These
generic fonts are mapped to the installed fonts using X logical font
description (XLFD) names. The %d, in the example below, is used as a
placeholder in the XLFD name for the point size. The Java application
replaces %d at runtime.

    serif.plain.latin-1=-b&h-lucidabright-medium-r-normal--*-%d-*-*-p-*-iso8859-1

Tip:The utility, xfontsel, may be used to display fonts and to discover
their XLFD names. Xfontsel is part of the xorg-xfontsel package.

Change the Lucida fonts named in the fontconfig.properties file to your
selected fonts using the XLFD names. Below is an excerpt of a
fontconfig.properties file after modifications have been made. The
Lucida fonts have been replaced by DejaVu fonts.

    # Version -- a version number is required.
    # IMPORTANT -- Do not delete the next line. Ever.
    version=1

    # Component Font Mappings
    # gen_name.style.subset=
    #       -fndry-fmly-wght-slant-sWdth-adstyle-pxlsz-ptSz-resx-resy-spc-avgWdth-rgstry-encdng

    serif.plain.latin-1=-misc-dejavu serif-medium-r-normal-*-*-%d-*-*-p-*-iso8859-1
    serif.bold.latin-1=-misc-dejavu serif-bold-r-normal-*-*-%d-*-*-p-*-iso8859-1
    serif.italic.latin-1=-misc-dejavu serif-medium-o-normal-*-*-%d-*-*-p-*-iso8859-1

After the changes have been saved to fontconfig.properties, the editor
may be closed and the user should drop root privileges. Open a new
instance of a Java application to test the changes.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Java_Runtime_Environment_Fonts&oldid=244937"

Category:

-   Fonts
