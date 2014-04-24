Abiword
=======

Abiword is a word processor that provides a lighter alternative for
LibreOffice Writer and OpenOffice Writer, while at the same time
providing great functionality. Abiword supports many standard document
types, such as ODF documents, Microsoft Word documents, WordPerfect
documents, Rich Text Format documents and HTML web pages.

Contents
--------

-   1 Installation
-   2 Templates
-   3 Grammar Checking
-   4 Change keybindings
-   5 LaTeX fonts
-   6 Troubleshooting
    -   6.1 Build fails with GCC 4.6
    -   6.2 Fix for print dialog crash

Installation
------------

Install the abiword package from the official repositories. You may want
to install dictionaries if you want spell check, which can be provided
by the aspell-en package for English.

For additional plugins, install the abiword-plugins package.

To fix tiny cursor and misaligned text issues, install either
ttf-liberation from the official repositories or ttf-ms-fonts from the
AUR and ttf-freefont from the official repositories.

Templates
---------

If you want to change the default styles in Abiword, you should open a
new document, change it to your own needs, and save it as the template
name normal.awt in the $HOME/.AbiSuite/templates directory. After that,
your new documents will follow the template.

Grammar Checking
----------------

Install the abiword-plugins package and enable grammar checking from
Edit>Preferences>Spell Checking>Automatic grammar checking.

Change keybindings
------------------

See this wiki post on how to change the default key bindings in Abiword.

If such method does not work, add Keybindings="viEdit" to
/usr/share/abiword-3.0/system.profile inside of the SystemDefaults tag.

LaTeX fonts
-----------

The package abiword-plugins comes with a function which allows user to
insert LaTeX codes in a document. To display mathematics symbols
properly, one needs to download latex-xft-fonts and save it to the
directory /usr/share/fonts. To install the font, extract the tarball and
then run the following:

    # fc-cache -fv

Troubleshooting
---------------

> Build fails with GCC 4.6

The bug has been reported and fixed upstream in a patch that is not yet
(as of Abiword 2.8.6-4) available in Arch. If you experience this
problem, you have to apply the patch to the PKGBUILD yourself.

> Fix for print dialog crash

Note:This bug has been reported as non-existent for version 2.8.1 or
higher. However, this section will remain for legacy versions or if it
crops up again,

For some reason, the current versions of Abiword and libgnomeprint are
not playing nice together. The .abw default template causes the program
to crash when the user attempts to print. The solution is to force
abiword to work with the .rtf format instead. By following the steps
below, you will set the default save format to .rtf and trick Abiword
into using a .rtf file as its default template.

Open ~/.AbiSuite/AbiWord.Profile and insert the following line into the
second <scheme> section.

    DefaultSaveFormat=".rtf"

It should look similar to the following:

    <Scheme
       name="_custom_"
       ZoomPercentage="64"
       DefaultSaveFormat=".rtf"
    />

It is then neccessary to change the default template. You must follow
these steps exactly.

1.  Open Abiword and save a blank document titled normal.rtf in
    ~/.AbiSuite/templates/. If the directory does not exist, create it.
2.  Rename the file to normal.awt.

Do not just save a blank .awt file! You must trick Abiword into using a
.rtf template in order for this to work.

As soon as the conflict between Abiword and libgnomeprint is resovled,
these instructions will no longer be neccessary and should be removed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Abiword&oldid=304252"

Category:

-   Office

-   This page was last modified on 13 March 2014, at 10:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
