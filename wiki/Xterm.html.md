Xterm
=====

xterm is the standard terminal emulator for the X Window System. It is
highly configurable and has many useful and some unusual features.

Contents
--------

-   1 Basics
    -   1.1 Resource file settings
        -   1.1.1 TERM Environmental Variable
        -   1.1.2 UTF-8
        -   1.1.3 Fix the 'Alt' key
    -   1.2 Scrolling
        -   1.2.1 The Scrollbar
    -   1.3 Menus
        -   1.3.1 Main Options menu
        -   1.3.2 VT Options menu
        -   1.3.3 VT Fonts menu
        -   1.3.4 Tek Options menu
    -   1.4 Copy and paste
        -   1.4.1 PRIMARY or CLIPBOARD
        -   1.4.2 PRIMARY and CLIPBOARD
        -   1.4.3 Selecting text
-   2 Colors
-   3 Fonts
    -   3.1 Default fonts
    -   3.2 Bold and underlined fonts
    -   3.3 CJK Fonts
-   4 Tips and tricks
    -   4.1 Automatic transparency
    -   4.2 Enable bell urgency
    -   4.3 Font tips
        -   4.3.1 Use color in place of bold and italics
        -   4.3.2 Adjust line spacing
    -   4.4 Remove black border
    -   4.5 Tek 4014 demonstration

Basics
------

> Resource file settings

There are several options you can set in your X resources files that may
make this terminal emulator much easier to use.

TERM Environmental Variable

Allow xterm to report the TERMvariable correctly. Do notset the TERM
variable from your ~/.bashrc or ~/.bash_profile or similar file. The
terminal itself should report the correct TERM to the system so that the
proper terminfo file will be used. Two usable terminfo files are
xterm,and xterm-256color.

-   Without setting TERM explicitly, xterm should report $TERM as xterm.
    You can check this from within xterm using either of these commands:

    $ echo $TERM
    $ tset -q

-   When TERM is not set explicitly, color schemes for some programs,
    such as vim,may not appear until a key is pressed or some other
    input occurs. This can be remedied with this resource setting :

    xterm*termName: xterm-256color

UTF-8

Make certain your locale settings are correct for UTF-8. Adding the
following line to your resource file will then make xterm interpret all
incoming data as UTF-8 encoded:

    XTerm*locale: true

Fix the 'Alt' key

If you use the Alt key for keyboard shortcuts, you will need this in
your resource file:

    XTerm*metaSendsEscape: true

> Scrolling

As new lines are written to the bottom of the xterm window, older lines
disappear from the top. To scroll up and down through the off-screen
lines one can use the mouse wheel, the key combinations Shift+PageUp and
Shift+PageDown, or the scrollbar.

By default, 1024 lines are saved. You can change the number of saved
lines with the saveLines resource,

    Xterm*saveLines: 4096

Other X resources that affect scrolling are jumpScroll, set to true by
default, and multiScroll and fastScroll, both of which default to false.

The Scrollbar

The scrollbar is not shown by default. It can be made visible by a menu
selection, by command line options, or by setting resource values. It
can be made to appear to the left or right of the window and its visual
appearance can be modified through resource settings.

The scrollbar operates differently from what you may be accustomed to
using.

-   To scroll down:

– Click on the scrollbar with the left mouse button.

– Click on the scrollbar below the thumb with the middle mouse button.

-   To scroll up:

– Click on the scrollbar with the right mouse button.

– Click on the scrollbar above the thumb with the middle mouse button.

-   To position text, moving in either direction:

– Grab the thumb and use "click-and-drag" with the middle mouse button.

> Menus

The Archlinux version of xterm is compiled with the toolbar,or
menubar,disabled. The menus are still available as popupswhen you press
Ctrl+MouseButton within the xterm window. The actions invoked by the
menu items can often be accomplished using command line options or by
setting resource values.

Tip:If the popup menu windows show only as small boxes, it is probably
because you have a line similar to this, xterm*geometry: 80x32, in your
resources file. This doesstart xterm in an 80 column by 32 row main
window, but it also forces the menu windows to be 80 pixels by 32
pixels! Replace the incorrect line with this:

    xterm*VT100.geometry: 80x32

Some of the menu options are discussed below.

Main Options menu

Ctrl + LeftMouse

-   Secure Keyboard attempts to ensure only the xterm window, and no
    other application, receives your keystrokes. The display changes to
    reverse video when it is invoked. If the display is not in reverse
    video, the Secure Keyboardmode is not in effect. Please read the
    "SECURITY" section of the xterm man page for this option's
    limitations.

-   Allow SendEvents allows other processes to send keypress and mouse
    events to the xterm window. Because of the security risk, do not
    enable this unless you are very sure you know what you are doing.

-   Log to File – The log file will be named
    Xterm.log.hostname.yyyy.mm.dd.hh.mm.ss.XXXXXX. This file will
    contain all the printed output and all cursor movements.Logging may
    be a security risk.

-   The six Send *** Signal menu items are not often useful, except when
    your keyboard fails. HUP, TERM and KILL will close the xterm window.
    KILL should be avoided, as it does not allow any cleanup code to
    run.

-   The Quit menu item will also close the xterm window – it is the same
    as sending a HUP signal. Most users will use the keyboard
    combination Ctrl+d or will type exit to close an xterm instance.

VT Options menu

Ctrl + MiddleMouse

-   Select to Clipboard – Normally, selected text is stored in PRIMARY,
    to be pasted with Shift+Insert or by using the middle mouse button.
    By toggling this option to on,selected text will use CLIPBOARD,
    allowing you to paste the text selected in an xterm window into a
    GUI application using Ctrl+v. The corresponding XTerm resource is
    selectToClipboard.

-   Show Alternate Screen – When you use an a terminal application such
    as vim,or less,the alternate screen is opened. The main VT window,
    now hidden, remains in memory. You can view this main window, but
    not issue any commands in it, by toggling this menu option. You are
    able to select and copy text from this main window.

Tip:Suspending the process running in the Alternate Screen and then
resuming it provides more functionality than using
Show Alternate Screen. With a bash shell, pressing Ctrl+z suspends the
process; issuing the command fg then resumes it.

-   Show Tek Window and Switch to Tek Mode – The Tektronix 4014 was a
    graphics terminal from the 1970s used for CAD and plotting
    applications. The command line program graph, from plotutils, and
    the application gnuplot can be made to use xterm's Tek emulation;
    most people will prefer more modern display options for charting
    data. See the #Tek 4014 demonstration, below.

VT Fonts menu

Ctrl + RightMouse

-   When using XLFD fonts, the first seven menu items will change the
    font face and the font size used in the current xterm window. If you
    are using an Xft font, only the font size will change, the font face
    will not change with the different selections, .

Tip:Unreadable and Tiny are useful if you wish to keep an eye on a
process but do not want to devote a large amount of screen space to the
terminal window. An example use might be a lengthy compilation process
when you only want to see that the operation completes.

-   Selection, when using XLFD font names, allows you to switch to the
    font name stored in the PRIMARY selection (or CLIPBOARD).

Tek Options menu

From the Tek Window, Ctrl + MiddleMouse

The first section's options allow you to change the Tek window font
size. The second set of options are used to move the focus between the
Tek emulation window and the main, or VT,window and to close or hide the
Tek window.

> Copy and paste

First, highlighting text using the mouse in an xterm (or alternatively
another application) will select the text to copy, then clicking the
mouse middle-button with paste that highlighted text. Also the key
combination Shift+Insert will paste highlighted text, but only within an
xterm.

PRIMARY or CLIPBOARD

By default, xterm, and many other applications running under X, copy
highlighted text into a buffer called the PRIMARY selection. The PRIMARY
slection is short-lived; the text is immediately replaced by a new
PRIMARY selection as soon as another piece of text is highlighted. Some
applications will allow you to paste PRIMARY selections by using the
middle-mouse, but not Shift+Insert, and some other applications may not
allow pasting from PRIMARY entirely.

There is another buffer used for copied text called the CLIPBOARD
selection. The text in the CLIPBOARD is long-lived, remaining available
until a user actively overwrites it. Applications that use Ctrl+c and
Ctrl+x for text copying and cutting operations, and Ctrl+v for pasting,
are using the CLIPBOARD.

The fleeting nature of the PRIMARY selection, where copied text is lost
as soon as another selection is highlighted, annoys some users. Xterm
allows the user to switch between the use of PRIMARY and CLIPBOARD using
Select to Clipboard on the #VT Options menu or with the
selectToClipboard resource.

PRIMARY and CLIPBOARD

With the above setting you can select if want using PRIMARY or
CLIPBOARD, but for use both you need a 'hack' for example put this in
you .Xresources:

    XTerm*VT100.translations: #override <Btn1Up>: select-end(PRIMARY, CLIPBOARD, CUT_BUFFER0)

Selecting text

The new user usually discovers that text may be selected using a
"click-and-drag" with the left mouse button. Double-clicking will select
a word, where a word is defined as consecutive alphabetic characters
plus the underscore, or the Basic Regular Expression (BRE) [A-Za-z_].
Triple-clicking selects a line, with a "tab" character usually copied as
multiple "space" characters.

Another way of selecting text, especially useful when copying more than
one full screen, is:

1.  Left-click at the start of the intended selection.
2.  Scroll to where the end of the selection is visible.
3.  Right-click at the end of the selection.

You do not have to be precise immediately with the right-click – any
highlighted selection may be extended or shortened by using a
right-click.

You can clear any selected text by left-clicking once, anywhere within
the xterm window.

Colors
------

Xterm defaults to black text, the foreground color, on a white
background. The foreground and background colors can be reversed using
the VT Options menu or with the -rv command line option.

    $ xterm -rv

Alternatively, the same thing can be accomplished with the following X
resources parameter (don't forget to reread the new resource
afterwards!):

    XTerm*reverseVideo: on

Xterm's foreground color (the text color) and the background color may
be set from the command line, using the options -fg and -bg
respectively.

    xterm -fg PapayaWhip -bg "rgb:00/00/80"

The first sixteen terminal colors, as well as the foreground and
background colors, may be set from an X resources file:

    XTerm*foreground: rgb:b2/b2/b2
    XTerm*background: rgb:08/08/08
    XTerm*color0: rgb:28/28/28

    ! ...Lines omitted...

    XTerm*color15: rgb:e4/e4/e4

Note:Colors for applications that use the X libraries may be specified
in many different ways.

Some colors can be specified by assigned names. If emacs or vim has been
installed, you can examine /usr/share/emacs/*/etc/rgb.txt or
/usr/share/vim/*/rgb.txt to view the list of color names with their
decimal RGB values. Colors may also be specified using hexadecimal RGB
values with the format rgb:RR/GG/BB, or the older and not encouraged
syntax #RRGGBB.

The color PapayaWhip is the same as rgb:ff/ef/d5, which is the same as
#ffefd5.

See man(7) X,from xorg-docs, for a more complete description of color
syntax.

Many suggestions for color schemes can be viewed in the forum thread,
Terminal Colour Scheme Screenshots.

Tip:Many people specify colors in their X resources files without
specifying an application class or application instance:

    *foreground: rgb:b2/b2/b2
    *background: rgb:08/08/08

The above example sets the foreground and background color values for
all Xlib applications (xclock, xfontsel, and others) that use these
resources. This is a nice, easy way to achieve a unified color scheme.

Fonts
-----

> Default fonts

Xterm's default font is the bitmap font named by the XLFD alias fixed,
often resolving to

    -misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-?

This font, also aliased to the name 6x13, has remakably wide coverage
for unicode glyphs. The default "TrueType" font is the 14‑point font
matched by the name mono. The FreeTypefont that will be used can be
found with this command:

    $ fc-match mono

Fonts can be specified from the command line, with the options -fn for
bitmap font names and -fa for Xft names. The example below allows you to
alternate between the two fonts by toggling TrueType Fonts from the #VT
Fonts menu.

    $ xterm -fn 7x13 -fa "Liberation Mono:size=10:antialias=false"

For a more permanent change, the default fonts may be set in an X
resources file:

    xterm*faceName: Liberation Mono:size=10:antialias=false
    xterm*font: 7x13

Note:There is a long-standing bug in xterm that prevents the command
line option -fn working correctly when faceName has been set in a
resource file. One solution is to set the resource renderFont to false
on the command line.

    $ xterm -fn 8x13                             # If this command does not set the font,
    $ xterm -fn 8x13 -xrm "*renderFont:false"    # set the 'renderFont' resource to 'false'.

Perhaps easier, you can just toggle TrueType Fonts from the #VT Fonts
menu in the terminal window.

> Bold and underlined fonts

Italic fonts are shown as underlined characters when using XLFD names in
xterm. TrueType fonts should use an oblique typeface.

If you do not specify a bold font at the command line, -fb, or through
the boldFont resource, xterm will attempt to find a bold font matching
the normal font. If a matching font is not found, the bold font will be
created by "overstriking" the normal font.

> CJK Fonts

Many fonts do not contain glyphs for the double width Chinese, Japanese
and Korean languages. Other terminal emulators such as urxvt may be
better suited if you frequently work with these languages.

Using bitmapped XLFD fonts with CJK has many pitfalls in xterm. It is
much easier to use TrueType fonts for CJK display, using the
faceNameDoublesize resource. This example uses DejaVu Sans Mono as the
normal font and WenQuanYi Bitmap Song as the double width font:

    xterm*faceName: DejaVu Sans Mono:style=Book:antialias=false
    xterm*faceNameDoublesize: WenQuanYi Bitmap Song
    xterm*faceSize: 8

Tips and tricks
---------------

> Automatic transparency

Install the package transset-df and a composite manager such as
Xcompmgr. Then add the following line to your ~/.bashrc:

    [ -n "$XTERM_VERSION" ] && transset-df -a >/dev/null

Now, each time you launch a shell in an xterm and a composite manager is
running, the xterm window will be transparent. The test in front of
transset-df keeps transet from executing if XTERM_VERSION is not
defined. Note that your terminal will not be transparent if you launch a
program other than a shell this way. It is probably possible to work
around this if you want the functionality.

Also see Per Application Transparency.

> Enable bell urgency

Add the following line to your ~/.Xresources file:

    xterm*bellIsUrgent: true

> Font tips

Use color in place of bold and italics

When using small font sizes, bold or italic characters may be difficult
to read. One solution is to turn off bolding and underlining or italics
and use color instead. This example does just that:

    ! Forbid bold font faces; bold type is light blue.
    XTerm*colorBDMode: true
    XTerm*colorBD: rgb:82/a4/d3
    ! Do not underscore text, underlined text is white.
    XTerm*colorULMode: true
    XTerm*colorUL: rgb:e4/e4/e4

Adjust line spacing

Lines of text can sometimes be too close together, or they may appear to
be too widely spaced. For one example, using DejaVu Sans Mono,the low
underscore glyph may butt against CJK glyphs or the cursor block in the
line below. Line spacing, called leadingby typographers, can be adjusted
using the scaleHeight resource. Here, the line spacing is widened:

    XTerm*scaleHeight: 1.01

Valid values for scaleHeight range from 0.9 to 1.5, with 1.0 being the
default.

> Remove black border

Xterm has a black border in some cases, you can disable this by adding
the following line to your ~/.Xresources file.

    xterm*borderWidth: 0

> Tek 4014 demonstration

If you have plotutils installed, you can use xterm's Tektronix 4014
emulation to view some of the plotutils package's test files. Open the
Tek window from the #VT Options menu item Switch to Tek Mode or start a
new xterm instance using this command:

    $ xterm -t -tn tek4014

Your PS1 prompt will not render correctly, if it appears at all. In the
new window, enter the command,

    cat /usr/share/tek2plot/dmerc.tek

A world map will appear in the Tek window. You can also view other *.tek
files from that same directory. To close the Tek window, one can use the
xterm menus.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xterm&oldid=296589"

Category:

-   Terminal emulators

-   This page was last modified on 8 February 2014, at 14:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
