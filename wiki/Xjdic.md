Xjdic
=====

This page describes how to set up Jim Breen's Japanese-English
dictionary program, xjdic. While the procedure itself isn't difficult,
it may be confusing for first-time users.

xjdic should be run on a terminal with JIS, Shift-JIS or EUC-JP
encoding.

There are different ways to get one. I'll describe only three, using
rxvt-unicode, kterm or xterm. If neither of them suits you, try to set
one of those encodings in your favorite terminal, it may work too.

Note: due too it's design, xjdic will work on almost any terminal with
any encoding, you'll just get garbage in place of japanese characters.
Due to design of most terminals, you'll get something right after you
set the correct encoding. That "something" may look good (if you're
lucky), awful or be just empty spaces — the latter two meaning you lack
some required fonts.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Terminal setup                                                     |
|     -   1.1 rxvt-unicode                                                 |
|     -   1.2 kterm                                                        |
|     -   1.3 xterm                                                        |
|                                                                          |
| -   2 Misc notes                                                         |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

Terminal setup
--------------

> rxvt-unicode

Rxvt-unicode has shown the best perfomance for me so far. I recomend
sticking with it unless you have something against rxvt-family
terminals. Unlike kterm, it's all-purpose unicode terminal and you can
use it for other things beside xjdic.

Encoding is controlled by LC_CTYPE environment variable. The command to
start xjdic should look like this:

           LC_CTYPE=ja_JP.EUC-JP urxvt -T 'xjdic' -e xjdic_sa -j e

The value of LC_CTYPE must be a valid locale, see Configuring Locales.

To get nice-looking characters, you must list apropriate wide font in
*font resource. Sample configuration using Markus Kuhn's usc-fonts:

    urxvt*font:            -misc-fixed-bold-r-normal--18-120-100-100-c-90-iso10646-1,\
                           -misc-fixed-medium-r-normal--18-120-100-100-c-90-iso10646-1,\
                           -misc-fixed-medium-r-normal-ja-18-120-100-100-c-180-iso10646-1
    urxvt*boldFont:                
    urxvt*italicFont:      
    urxvt*boldItalicFont:

I prefer having bold font for European alphabets; if you like medium
instead, use something like this:

    urxvt*font:            -misc-fixed-medium-r-normal--18-120-100-100-c-90-iso10646-1,\
                           -misc-fixed-medium-r-normal-ja-18-120-100-100-c-180-iso10646-1
    urxvt*boldFont:        -misc-fixed-bold-r-normal--18-120-100-100-c-90-iso10646-1

Put these lines to your .Xresources (or .Xdefaults, depending on your
setup). Alternatively, you can use apropriate command-line switches, see
urxvt(1).

> kterm

Kterm is rather limited terminal emulator designed specifically to
handle Japanese. xjdic probably will be the only reason you'll keep it
in your system. On the other hand, it's "home terminal" for xjdic, and
usually there's no need to set up anything for kterm if you have
apropriate fonts installed:

    kterm -rv -e xjdic_sa

Default Arch installation contains necessary fonts (misc/jis* from
xorg-fonts-misc). If you experience font-related problems, try using -fr
and -fk options with some availables **-jisx0208.*-* font.

> xterm

Xterm uses external program, luit, to handle different encodings. It
should be as good as urxvt, but unfortunately luit is awfully buggy,
especially when it comes to fancy Japanese encodings — segfaults with
Shift-JIS are common and mouse paste sometimes works incorrectly in
EUC-JP. Try it if xterm is your primary terminal, but be prepared to
switch to something else.

Sample font configuration using ucs-fonts:

    xterm*utf8:            1
    xterm*font:            -misc-fixed-bold-r-normal--18-120-100-100-c-90-iso10646-1
    xterm*boldfont:        -misc-fixed-bold-r-normal--18-120-100-100-c-90-iso10646-1
    xterm*widefont:        -misc-fixed-medium-r-normal-ja-18-120-100-100-c-180-iso10646-1
    xterm*locale:          true

Command to run xjdic:

    xterm -en euc-jp xjdic_sa -j e

  

Misc notes
----------

Read xjdic24.inf (located in /usr/share/doc/xjdic if you used PKGBUILD
from AUR) before running xjdic — it's not the kind of program you can
use without reading documentation.

You must install at least edict and kanjidic to get xjdic working.

And you'll probably need to make your own ~/.xjdicrc file. Start by
copying system-wide configuration file, /usr/share/xjdic/xjdicrc or
/usr/share/xjdic/.xjdicrc .

External links
--------------

-   Xjdic home page
-   Monash university FTP archive
-   xjdic packages in AUR

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xjdic&oldid=198184"

Category:

-   Internationalization
