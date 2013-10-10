MS Fonts
========

> Summary

Installing TrueType Microsoft fonts and emulating Windows' font
rendering

> Related

Fonts: Information on adding fonts and font recommendations

Font Configuration: Font setup and beautification

Java Runtime Environment Fonts: Fonts specific to Sun's Java virtual
machine

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Current Packages                                             |
|     -   1.2 Legacy Packages                                              |
|                                                                          |
| -   2 Sharp fonts resembling Windows XP                                  |
| -   3 Smooth fonts resembling Windows 7                                  |
+--------------------------------------------------------------------------+

Installation
------------

> Current Packages

Note:These packages do require access to a Windows 7/8 and/or a Office
2007 setup or installation media, consult corresponding PKGBUILD for
details.

Available in the AUR:

-   ttf-win7-fonts — Windows 7 fonts
-   ttf-office-2007-fonts — Microsoft Office 2007 fonts
-   ttf-ms-win8 — Windows 8 fonts

> Legacy Packages

Note:The fonts provided by these packages are out-of-date and are
missing modern hinting instructions and the full character sets. It is
recommended to use the above packages.

ttf-ms-fonts is available in the AUR.

According to original Microsoft's End User License Agreement, there are
some legal limitations when using the fonts.

The package includes:

-   Andalé Mono
-   Arial
-   Arial Black
-   Comic Sans
-   Courier New
-   Georgia
-   Impact
-   Lucida Sans
-   Lucida Console
-   Microsoft Sans Serif
-   Symbol
-   Times New Roman
-   Trebuchet
-   Verdana
-   Webdings
-   Wingdings

You can also obtain ttf-tahoma or ttf-microsoft-tahoma from the AUR,
which as you might expect contains Tahoma.

ttf-vista-fonts is also available in the AUR and include:

-   Calibri
-   Cambria
-   Candara
-   Consolas
-   Constantia
-   Corbel

Sharp fonts resembling Windows XP
---------------------------------

A complete guide on how to make the MS Fonts look as in Windows XP is
found at http://www.sharpfonts.co.cc/ (site down, try sharpfonts in the
AUR). In short, install the fonts as described above and use the
author's modified XML files.

Smooth fonts resembling Windows 7
---------------------------------

Use Infinality's patched freetype2 package, and use the Windows 7
profile in the provided local.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MS_Fonts&oldid=247664"

Categories:

-   Fonts
-   Graphics and desktop publishing
