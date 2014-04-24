Mnemosyne
=========

Mnemosyne is an open-source, cross-platform flashcard program that uses
a spaced repetition algorithm for maximizing learning efficiency.

It is inspired by the proprietary SuperMemo and comparable to Anki, but
with a stronger focus on a minimalist, distraction-free UI and simple
but flexible work-flow.

Mnemosyne is written in Python 2 and uses the Qt toolkit.

Contents
--------

-   1 Installation
    -   1.1 Installing from AUR
    -   1.2 Manual Installation
    -   1.3 Configuring
        -   1.3.1 Size of mathematical formulae
-   2 Other Resources
-   3 See Also

Installation
------------

> Installing from AUR

Unofficial Mnemosyne packages are available in the Arch User Repository:

-   mnemosyne (latest stable version)
-   mnemosyne-bzr (latest development snapshot from trunk)

> Manual Installation

For manual compilation and installation, you can get a tarball from the
official download page and follow the instructions in the accompanying
README file.

> Configuring

Most of the options in Mnemosyne are available directly in the user
interface. A few infrequently-used options are accessible through a
config file located at ~/.config/mnemosyne/config.py.

Size of mathematical formulae

If you would like to decrease the rendering resolution of mathematical
formulae (default 200 dpi, which is rather large on most screens) to
better fit with normal text, open the file ~/.config/mnemosyne/config.py
and decrease the number following the -D option in the line that looks
like:

    dvipng = "dvipng -D 200 -T tight tmp.dvi"

Other Resources
---------------

The Mnemosyne website offers:

-   Official documentation
-   User-contributed plugins
-   User-contributed sets of cards

See Also
--------

-   Anki - another open-source flashcard program using spaced repetition

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mnemosyne&oldid=303794"

Category:

-   Applications

-   This page was last modified on 9 March 2014, at 14:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
