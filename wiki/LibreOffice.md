LibreOffice
===========

From Home - LibreOffice:

LibreOffice is the free power-packed Open Source personal productivity
suite for Windows, Macintosh and Linux, that gives you six feature-rich
applications for all your document production and data processing needs:
Writer, Calc, Impress, Draw, Math and Base. Support and documentation is
free from our large, dedicated community of users, contributors and
developers. You, too, can also get involved!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 LibreOffice in Arch Linux                                          |
| -   2 Installation                                                       |
| -   3 Theme                                                              |
|     -   3.1 Personas themes                                              |
|                                                                          |
| -   4 Extension management                                               |
| -   5 Language Aids                                                      |
|     -   5.1 Spell checking                                               |
|     -   5.2 Hyphenation rules                                            |
|     -   5.3 Thesaurus                                                    |
|     -   5.4 Grammar checking                                             |
|                                                                          |
| -   6 Installing Macros                                                  |
| -   7 Speed up LibreOffice                                               |
| -   8 Troubleshooting                                                    |
|     -   8.1 Font substitution                                            |
|     -   8.2 Microsoft Fonts                                              |
|     -   8.3 Anti-aliasing                                                |
|     -   8.4 Hanging when using NFS shares                                |
|     -   8.5 Fixing Java Framework Error                                  |
|     -   8.6 LibreOffice does not detect my certificates                  |
|     -   8.7 Run .pps files in edit mode (without slideshow)              |
|     -   8.8 Bibliography problems                                        |
+--------------------------------------------------------------------------+

LibreOffice in Arch Linux
-------------------------

Official support for OpenOffice.org was dropped in favor of LibreOffice,
the "Document Foundation" fork of the project, which also includes
enhancements and additional features. See Dropping Oracle OpenOffice
(arch-general).

Installation
------------

Since version 3.4.2rc1, LibreOffice has been split into several
packages, which can be installed with the libreoffice group from the
official repositories: pacman will display a menu prompting for which
components to install.

> Note:

-   Ensure that the fonts ttf-dejavu and artwiz-fonts are installed
    before continuing, otherwise LibreOffice will display rectangles
    instead of text.
-   As the language pack for en-US is no longer included by default, you
    will need to install at least 1 language pack. The default language
    is Afrikaans (because it is alphabetically the first provider of
    libreoffice-langpack), while the previous default (en-US) is at
    number 24. A common mistake is to install libreoffice-uk, which is
    the Ukrainian language pack, instead of libreoffice-en-GB.
-   You need libreoffice-kde4 or libreoffice-gnome only if you care
    about qt or gtk visual integration - see the #Theme section below.

Check the recommended optional dependencies pacman suggests. E.g.
install a Java Runtime Environment (optional, highly recommended). See:
Java. You will need hsqldb-java to use Libreoffice Base.

Theme
-----

For Qt integration, install the package libreoffice-kde4. For GTK
integration, install the package libreoffice-gnome.

Note:Qt integration is able to mimic gtk theme. The command qtconfig-qt4
opens a window which let you choose.

Note:Even if you are not running one of these desktop environments and
thus do not need to "integrate" with them, you may still wish to install
these packages so that libreoffice will use non-default gtk or qt
themes. For example, libreoffice on e17 uses the default "ugly" (aka
"win95") theme; installing libreoffice-gnome will allow you to select a
more pleasant gtk theme.

As of LibreOffice version 3.5.x it tries to magically autodetect your
desktop UI using the following magic if proper libs will be found:

     gtk3 -> gtk2 -> kde4 -> generic

To force the use of a certain VCL UI interface use one of this:

    SAL_USE_VCLPLUGIN=gen lowriter
    SAL_USE_VCLPLUGIN=kde4 lowriter 
    SAL_USE_VCLPLUGIN=gtk lowriter 
    SAL_USE_VCLPLUGIN=gtk3 lowriter

It is convenient to save SAL_USE_VCLPLUGIN variable in your shell
configuration file, e.g./etc/bash.bashrc or ~/.bashrc if using bash.

Note:The new gtk3 UI is still marked upstream as experimental and will
only be available if you enable "experimental features" in LibO main
configuration dialog.

However, if it looks like it's using Windows 98 icons, go to Tools ->
Options -> Accessibility and uncheck "Automatically detect high contrast
mode of the system".

> Personas themes

Libreoffice 4.x series is able to use Firefox personas. Enter
Libreoffice options and choose "Personalization", "Select Personas",
then paste the URL of your favourite one. A convenient button in the
dialog box lets you open the browser.

Extension management
--------------------

Arch is shipping some additional extensions. We currently ship these
extensions: nlpsolver, presentation-minimizer, report-builder,
wiki-publisher. You can install them with pacman:

    # pacman -S libreoffice-extension-nlpsolver libreoffice-extension-foo ...

Check AUR or the built-in LibreOffice Extension manager or get
extensions online if you want to install more extensions.

Language Aids
-------------

> Spell checking

For spell checking, you will need hunspell and a language dictionary for
hunspell (like hunspell-en for English, hunspell-de for German, etc).

> Hyphenation rules

For hyphenation rules, you will need hyphen and a language hyphen rule
set (hyphen-en for English, hyphen-de for German, etc).

> Thesaurus

For the thesaurus option, you will need libmythes and a mythes language
thesaurus (like mythes-en for English, mythes-de for German, etc).

> Grammar checking

For grammar checking, you will need to install an extension such as
LanguageTool, which can be found in the AUR:
libreoffice-extension-languagetool or the LanguageTool Website.

Other grammar tools can also be found on the LibreOffice Extension Page
or OpenOffice's Website. Not all OpenOffice extensions are guaranteed to
work with LibreOffice.

Note:Languagetool uses java and may slow down or briefly hang
LibreOffice, particularly while opening documents. Fortunately this is
usually only when initially opening a document and is usually not
apparent otherwise. Openjdk6 seems to get the better results than
openjdk7 with LanguageTool, although this is unconfirmed.

Installing Macros
-----------------

If you intend to use macros, you must have a JRE enabled, use of a JRE
is default behaviour. But disabling it speeds up the program.

The default path for macros in Arch Linux is different from most Linux
distributions. Its location is

    ~/.config/libreoffice/4/user/Scripts/

Speed up LibreOffice
--------------------

Some settings may improve LibreOffice's loading time and responsiveness.
However, some also increase RAM usage, so use them carefully. They can
all be accessed under Tools -> Options.

-   Under Memory:
    -   Reduce the number of Undo steps to a figure lower than 100, to
        something like 20 or 30 steps.
    -   Under Graphics cache, set Use for LibreOffice to 128 MB (up from
        the original 20MB).
    -   Set Memory per object to 20MB (up from the default 5MB).
    -   If you use LibreOffice often, check LibreOffice Quickstarter.

Note:you need to have the package libreoffice-gnome installed for the
quickstarter option to be available

-   Under Advanced, uncheck Use a Java runtime environment.

Note:For a list of functionality written in Java only, see:
https://wiki.documentfoundation.org/Development/Java

Troubleshooting
---------------

> Font substitution

These settings can be changed in the LibreOffice options. From the
drop-down menu, select Tools -> Options -> LibreOffice -> Fonts. Check
the box that says Apply Replacement Table. Type Andale Sans UI in the
font box and choose your desired font for the Replace with option. When
done, click the checkmark. Then choose the Always and Screen only
options in the box below. Click OK. You will then need to go to Tools ->
Options -> LibreOffice -> View, and uncheck "Use system font for user
interface". If you use a non-antialised font, such as Arial, you will
also need to uncheck "Screen font antialiasing" before menu fonts render
correctly.

> Microsoft Fonts

Official Microsoft fonts are useful to prevent pagination problems.
Check the MS_Fonts wiki page.

> Anti-aliasing

Execute

    $ echo "Xft.lcdfilter: lcddefault" | xrdb -merge

To make the change persistent, add Xft.lcdfilter: lcddefault to your
~/.Xresources file, and make sure to run xrdb -merge ~/.Xresources. [1].
See X resources for more details.

If this does not work, you can also try adding Xft.lcdfilter: lcddefault
to your ~/.Xdefaults. If you do not have this file, you will have to
create it.

> Hanging when using NFS shares

If LibreOffice hangs when trying to open or save a document located on a
NFS share, try prepending the following lines with a # in
/usr/lib/libreoffice/program/soffice:

    # file locking now enabled by default
    SAL_ENABLE_FILE_LOCKING=1
    export SAL_ENABLE_FILE_LOCKING

To avoid overwriting on update you can copy
/usr/lib/libreoffice/program/soffice in /usr/local/bin. Original post
here.

Note:Only NFSv3 is affected. NFSv4 works well with LibreOffice.

> Fixing Java Framework Error

You may get the following error when you try to run LibreOffice.

    [Java framework] Error in function createSettingsDocument (elements.cxx).
    javaldx failed!

If so, give yourself ownership of ~/.config/ like so:

    # chown -vR username:users ~/.config

Post on Arch Linux Forums

> LibreOffice does not detect my certificates

If you cannot see the certificates when trying to sign a document, you
will need to have the certificates configured in Mozilla Firefox (or
Thunderbird). If after that LibreOffice still does not show them, set
the MOZILLA_CERTIFICATE_FOLDER environment variable to point to your
Mozilla Firefox (or Thunderbird) folder.

    export MOZILLA_CERTIFICATE_FOLDER=$HOME/.mozilla/firefox/XXXXXX.default/

Certificate Detection

> Run .pps files in edit mode (without slideshow)

The only solution is to rename .pps file in .ppt

Add the following script to your home directory and use it to open every
.pps file. Very useful to open .pps files received by email without the
need to save them.

    #!/bin/bash

    f=$(mktemp)

    cp "$1" "${f}.ppt" && libreoffice "${f}.ppt" && rm -f "${f}.ppt"

> Bibliography problems

If Writer crashes on attempting to access Tools -> Bibliography
Database, with the following error:

    com::sun::star::loader::CannotActivateFactoryException

Install libreoffice-base as this is a workaround to a known bug,
purportedly fixed

Retrieved from
"https://wiki.archlinux.org/index.php?title=LibreOffice&oldid=256137"

Category:

-   Office
