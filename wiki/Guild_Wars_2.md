Guild Wars 2
============

Guild Wars 2 is a game developed by NC Soft. Currently a native client
is only available for Windows and Mac systems. It is runnable through
wine though.

Installation
------------

1. Install wine:

    pacman -Syu wine

2. Install libmpg123:

    pacman -Syu mpg123

3. Download the GW2 client from their website (you have to be logged
in), and run it like this:

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

3. Ingame Bazaar (trade) don't work ("Awesomium patch")

Need Download Wine sources (from GIT or tarball) and build with apply
this patch. for more info see Wine bug #27168

4. "Garbage" when take screenshots in JPEG mode

By default, when take ingame screenshot (Impr Pant key), save screenshot
in JPEG format. but this screenshot save like this, to fix , have 2
ways:

1) Launch game with -bmp prefix to take screenshot in BMP format:

    wine ./Gw2.exe -bmp

Good screenshot example

2) Or apply this patch in Wine Sources (GIT or tarball). for more info
see Wine bug #31557

Retrieved from
"https://wiki.archlinux.org/index.php?title=Guild_Wars_2&oldid=254064"

Category:

-   Gaming
