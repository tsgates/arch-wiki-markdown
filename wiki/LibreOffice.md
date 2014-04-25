LibreOffice
===========

Related articles

-   Apache OpenOffice

From Home - LibreOffice:

LibreOffice is the free power-packed Open Source personal productivity
suite for Windows, Macintosh and Linux, that gives you six feature-rich
applications for all your document production and data processing needs:
Writer, Calc, Impress, Draw, Math and Base. Support and documentation is
free from our large, dedicated community of users, contributors and
developers. You, too, can also get involved!

Contents
--------

-   1 LibreOffice in Arch Linux
-   2 Installation
-   3 Theme
    -   3.1 Firefox themes
    -   3.2 Disable startup logo
-   4 Extension management
-   5 Language aids
    -   5.1 Spell checking
    -   5.2 Hyphenation rules
    -   5.3 Thesaurus
    -   5.4 Grammar checking
    -   5.5 Finnish spell checking
-   6 Installing macros
-   7 Speed up LibreOffice
-   8 Troubleshooting
    -   8.1 Font substitution
    -   8.2 Anti-aliasing
    -   8.3 Hanging when using NFSv3 shares
    -   8.4 Fixing Java framework error
    -   8.5 LibreOffice does not detect my certificates
    -   8.6 Run .pps files in edit mode (without slideshow)
    -   8.7 Bibliography problems
    -   8.8 Media support
    -   8.9 Content not resizing with windows on Xfwm4
    -   8.10 gvfs mounts

LibreOffice in Arch Linux
-------------------------

Official support for OpenOffice.org was dropped in favor of LibreOffice,
the "Document Foundation" fork of the project, which also includes
enhancements and additional features. See Dropping Oracle OpenOffice
(arch-general).

Installation
------------

LibreOffice is split into several packages, which can be installed with
the libreoffice group from the official repositories: pacman will
display a menu prompting for which components and language packs to
install.

> Note:

-   You will need to install at least 1 language pack. The default
    language is Afrikaans (because it is alphabetically the first
    provider of libreoffice-langpack). If you want the UK-English
    language pack, install libreoffice-en-GB, not libreoffice-uk
    (Ukrainian) or libreoffice-br (Breton)!
-   You need libreoffice-kde4 or libreoffice-gnome only if you care
    about Qt or GTK+ visual integration. See the Theme section.

Check the recommended optional dependencies pacman suggests. A Java
Runtime Environment is not required unless you want to use Libreoffice
Base: see Java. You may need hsqldb2-java to use some modules in
LibreOffice Base.

Theme
-----

For Qt integration, install the package libreoffice-kde4. For GTK+
integration, install the package libreoffice-gnome.

> Note:

-   Qt integration is able to mimic GTK+ theme. The command qtconfig-qt4
    opens a window which let you choose.
-   Even if you are not running one of these desktop environments and
    thus do not need to "integrate" with them, you may still wish to
    install these packages so that LibreOffice will use non-default GTK+
    or Qt themes. For example, LibreOffice on e17 uses the default
    "ugly" (aka "win95"/"win98") theme; installing libreoffice-gnome
    will allow you to select a more pleasant GTK+ theme.

As of LibreOffice version 3.5.x it tries to magically autodetect your
desktop UI using the following magic if proper libs will be found:

    gtk > kde4 > generic

To force the use of a certain VCL UI interface use one of this:

    SAL_USE_VCLPLUGIN=gen lowriter
    SAL_USE_VCLPLUGIN=kde4 lowriter
    SAL_USE_VCLPLUGIN=gtk lowriter
    SAL_USE_VCLPLUGIN=gtk3 lowriter

It is convenient to save SAL_USE_VCLPLUGIN variable in your shell
configuration file, e.g./etc/bash.bashrc or ~/.bashrc if using Bash.

Note:The new GTK3 UI is still marked upstream as experimental and will
only be available if you enable "experimental features" in LibreOffice
main configuration dialog.

However, if it looks like it's using Windows 95/98 icons, go to Tools >
Options... in the menus (which presents the Options Dialog), then select
LibreOffice > Accessibility and uncheck "Automatically detect
high-contrast mode of operating system".

If that doesn't work immediately, you may need to change the icon set
that's in use; this is also in the Options Dialog, under LibreOffice >
View with two pop-up boxes for "Icon size and style" (the latter pop-up
box should be changed to something other than "High-contrast").

> Firefox themes

LibreOffice 4.x series is able to use Firefox themes. Enter LibreOffice
options and choose Personalization > Select Theme, then paste the URL of
your favourite one. A convenient button in the dialog box lets you open
the browser.

> Disable startup logo

If you prefer to disable the startup logo, open
/etc/libreoffice/sofficerc, find the Logo= line and set Logo=0.

Note:This variable is unrelated with the Logo scripting support.

Extension management
--------------------

Arch is shipping some additional extensions from the official
repositories:

-   libreoffice-extension-nlpsolver
-   libreoffice-extension-presentation-minimizer
-   libreoffice-extension-wiki-publisher

Check the AUR or the built-in LibreOffice Extension manager or get
extensions online if you want to install more extensions.

Language aids
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

Note:Languagetool uses Java and may slow down or briefly hang
LibreOffice, particularly while opening documents. Fortunately this is
usually only when initially opening a document and is usually not
apparent otherwise.

> Finnish spell checking

For Finnish users, there are four packages to be installed. Install them
in this order: malaga, suomi-malaga-voikko, libvoikko and
voikko-libreoffice.

Installing macros
-----------------

If you intend to use macros, you must have a Java Runtime Environment
enabled. A Java Runtime Environment is enabled by default, but disabling
it speeds up the program.

The default path for macros in Arch Linux is different from most Linux
distributions. Its location is:

    ~/.config/libreoffice/4/user/Scripts/

Speed up LibreOffice
--------------------

Some settings may improve LibreOffice's loading time and responsiveness.
However, some also increase RAM usage, so use them carefully. They can
all be accessed under Tools > Options.

-   Under Memory:
    -   Reduce the number of Undo steps to a figure lower than 100, to
        something like 20 or 30 steps
    -   Under Graphics cache, set Use for LibreOffice to 128 MB (up from
        the original 20 MB)
    -   Set Memory per object to 20 MB (up from the default 5 MB).
    -   If you use LibreOffice often, check Enable systray Quickstarter

Note:You need to have the package libreoffice-gnome installed for the
quickstarter option to be available.

-   Under Advanced, uncheck Use a Java runtime environment

Note:For a list of functionality written in Java only, see:
https://wiki.documentfoundation.org/Development/Java.

Troubleshooting
---------------

> Font substitution

These settings can be changed in the LibreOffice options. From the
drop-down menu, select Tools > Options > LibreOffice > Fonts. Check the
box that says Apply Replacement Table. Type Andale Sans UI in the font
box and choose your desired font for the Replace with option. When done,
click the checkmark. Then choose the Always and Screen only options in
the box below. Click OK. You will then need to go to Tools > Options >
LibreOffice > View, and uncheck "Use system font for user interface". If
you use a non-antialised font, such as Arial, you will also need to
uncheck "Screen font antialiasing" before menu fonts render correctly.

> Anti-aliasing

Execute:

    $ echo "Xft.lcdfilter: lcddefault" | xrdb -merge

To make the change persistent, add Xft.lcdfilter: lcddefault to your
~/.Xresources file, and make sure to run $ xrdb -merge ~/.Xresources
(source. See X resources for more details.

If this does not work, you can also try adding Xft.lcdfilter: lcddefault
to your ~/.Xdefaults. If you do not have this file, you will have to
create it.

> Hanging when using NFSv3 shares

If LibreOffice hangs when trying to open or save a document located on a
NFSv3 share, try prepending the following lines with a # in
/usr/lib/libreoffice/program/soffice:

    # file locking now enabled by default
    SAL_ENABLE_FILE_LOCKING=1
    export SAL_ENABLE_FILE_LOCKING

To avoid overwriting on update you can copy
/usr/lib/libreoffice/program/soffice in /usr/local/bin. Original post
here.

> Fixing Java framework error

You may get the following error when you try to run LibreOffice.

    [Java framework] Error in function createSettingsDocument (elements.cxx).
    javaldx failed!

If so, give yourself ownership of ~/.config/ like so:

    # chown -vR username:users ~/.config

Post on Arch Linux forums.

> LibreOffice does not detect my certificates

If you cannot see the certificates when trying to sign a document, you
will need to have the certificates configured in Mozilla Firefox (or
Thunderbird). If after that LibreOffice still does not show them, set
the MOZILLA_CERTIFICATE_FOLDER environment variable to point to your
Mozilla Firefox (or Thunderbird) folder:

    export MOZILLA_CERTIFICATE_FOLDER=$HOME/.mozilla/firefox/XXXXXX.default/

Certificate detection.

> Run .pps files in edit mode (without slideshow)

The only solution is to rename the .pps file to .ppt.

Add the following script to your home directory and use it to open every
.pps file. Very useful to open .pps files received by email without the
need to save them.

    #!/bin/bash

    f=$(mktemp)
    cp "$1" "${f}.ppt" && libreoffice "${f}.ppt" && rm -f "${f}.ppt"

> Bibliography problems

If Writer crashes on attempting to access Tools > Bibliography Database,
with the following error:

    com::sun::star::loader::CannotActivateFactoryException

Install libreoffice-base as this is a workaround to a known bug,
purportedly fixed.

> Media support

If embedded videos are just gray boxes, make sure to have installed the
GStreamer plugins required.

> Content not resizing with windows on Xfwm4

If you do not get the content of the LibreOffice window resize along
with it under Xfce (or just using Xfwm4), like in this post: [1].
Install libreoffice-gnome to solve the issue.

> gvfs mounts

If you need to open/save documents on gvfs mounts, you will need to
install libreoffice-gnome package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=LibreOffice&oldid=303110"

Category:

-   Office

-   This page was last modified on 4 March 2014, at 00:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
