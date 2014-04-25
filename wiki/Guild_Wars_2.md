Guild Wars 2
============

Guild Wars 2 is a game developed by NC Soft. Currently a native client
is only available for Windows and Mac systems. It is runnable through
wine though.

Installation
------------

Install wine and mpg123. Download the GW2 client from their website (you
have to be logged in), and run it like this:

    wine ./Gw2.exe

Known issues
------------

1. Patcher/launcher window is invisible/flickering.

Run it with -dx9single like so:

    wine ./Gw2.exe -dx9single

2. Patcher/launcher crashes with assertion failed on "m_ioCount"

The best known "fix" for this is to just let it crash and restart it, it
should continue on where it left off. It usually crashes after around
1GB worth of download, which makes this a not-at-all dealbreaker for
most. Please edit this if you find that it crashes instantly/after just
a few MB.

The percent of the download resets every time the launcher is started,
but the amount that has already downloaded is not accounted into this
number; just what remains is. The best number correlates with the total
download progress is the Files Remaining.

If you have only one file remaining, switch to a language other than
english or spanish, let it download that information, and then switch
back to english.

3. Ingame Bazaar (Black Lion trade) don't work ("Awesomium patch")

Fixed in Wine 1.7.5.

For more info see: wine bug #27168

4. "Garbage" when take screenshots in JPEG mode

Fixed in wine 1.7.4.

To take screenshot in BMP, add flag -bmp in command line, like so:

    wine ./Gw2.exe -bmp

For more info see: Wine bug #31557

5. Camera rotation stop the movement when the mouse reach the edge of
window

When click MOUSE1 and move to rotate the camera , this stop when the
mouse reach the edge of window, this fixed in 1.5.14, but broken again
as of 1.5.29.

Need Download wine sources from GIT and revert a certain commit with:

    git revert --no-edit 76bbf106a28c4caa82873e8450bde7d4adc765bf

or download sources and apply (revert) with this patch

    http://source.winehq.org/git/wine.git/patch/76bbf106a28c4caa82873e8450bde7d4adc765bf

For more info see: Wine bug #33479

Retrieved from
"https://wiki.archlinux.org/index.php?title=Guild_Wars_2&oldid=286070"

Category:

-   Gaming

-   This page was last modified on 3 December 2013, at 21:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
