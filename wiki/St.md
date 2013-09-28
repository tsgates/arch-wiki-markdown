st
==

st is a simple terminal implementation for X by suckless. It is intended
to serve as a lightweight replacement xterm and urxvt. It currently
supports 256 colors, most VT10X escape sequences, UTF8, X11 copy/paste,
antialiased fonts (using fontconfig), fallback fonts, resize, shortcuts
via config.h, and line drawing.

Installation
------------

Download the st or st-git package from the AUR. Then, as a non-root
user, run:

    $ makepkg -i

while in the directory of the saved PKGBUILD. All the files will be
retrieved, and the package will be built and installed.

Configuration
-------------

st is configured through its config.h file. A sample config.def.h file
is included with the source.

Consider maintaining your own PKGBUILD with sources and md5sums for your
own configuration file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=St&oldid=252582"

Category:

-   Terminal emulators
