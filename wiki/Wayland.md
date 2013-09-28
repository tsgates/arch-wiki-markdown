Wayland
=======

Summary

A guide to installing and running the Wayland display server.

Related

KMS

Xorg

Wayland is a new windowing protocol for Linux. Utilization of Wayland
requires changes to and re-installation of parts of your system's
software. For more information on Wayland see its homepage.

Warning:Wayland is under heavy development. Support can not be
guaranteed and it may not function as you expect.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Installation                                                       |
| -   3 Usage                                                              |
| -   4 Weston                                                             |
|     -   4.1 Installation                                                 |
|     -   4.2 Usage                                                        |
|                                                                          |
| -   5 GUI libraries                                                      |
|     -   5.1 GTK+                                                         |
|     -   5.2 Qt5                                                          |
|     -   5.3 Clutter                                                      |
|     -   5.4 SDL                                                          |
|     -   5.5 EFL                                                          |
|                                                                          |
| -   6 Window managers and desktop shells                                 |
|     -   6.1 KDE                                                          |
|     -   6.2 GNOME                                                        |
|     -   6.3 Pure Wayland                                                 |
|         -   6.3.1 Wayland                                                |
|         -   6.3.2 DRM and Mesa                                           |
|         -   6.3.3 xorg-macros                                            |
|         -   6.3.4 libxkbcommon                                           |
|         -   6.3.5 pixman                                                 |
|         -   6.3.6 cairo                                                  |
|         -   6.3.7 xkb files                                              |
|         -   6.3.8 weston                                                 |
|                                                                          |
| -   7 See also                                                           |
| -   8 External links                                                     |
+--------------------------------------------------------------------------+

Requirements
------------

Currently Wayland will only work with on a system that is utilizing KMS.

Installation
------------

Wayland is most probably installed on your system already as it is an
indirect dependency of gtk2 and gtk3. If it is not installed, you will
find the wayland package in extra.

Usage
-----

As Wayland is only a library, it is useless on its own. To use it, you
need a compositor (like Weston), Weston demo applications, Qt5 with
Wayland plugin, and/or GTK+ with Wayland support.

Weston
------

> Installation

You need to install weston from community.

> Usage

Now that Wayland and its requirements are installed you should be ready
to test it out. Try switching to a terminal and running:

    $ weston-launch

Note:You need to be in the video group for Weston to start; this command
is not supposed to be run as root and doing that may freeze your VT.

Note:If you get an LLVM assertion failure, you need to rebuild mesa
without Gallium LLVM until this problem is fixed. This may imply
disabling some drivers which require LLVM.

You may also try exporting the following, if having problems with
hardware drivers:

    $ export EGL_DRIVER=/usr/lib/egl/egl_gallium.so

It is possible to run Weston inside a running X session:

    $ weston

Then at a TTY you can run the demos. To launch a terminal emulator:

    $ weston-terminal

To move flowers around the screen:

    $ weston-flower 

To test the frame protocol (runs glxgears):

    $ weston-gears

To display images:

    $ weston-image image1.jpg image2.jpg...

To display PDF Files:

    $ weston-view doc1.pdf doc2.pdf...

GUI libraries
-------------

(page from official website)

> GTK+

You need to install gtk3 from extra, which now has the Wayland backend
enabled.

With GTK+ 3.0, GTK+ gained support for multiple backends at runtime and
can switch between backends in the same way Qt can with lighthouse.

When both Wayland and X backends are enabled, GTK+ will default to the
X11 backend, but this can be overridden by setting the GDK_BACKEND
environment variable to wayland.

Remove libcanberra if you get segmentation faults when running gtk
applications. A fix for these segfaults has been committed as of 9 Nov
2012, so presumably as soon as 0.31.0 comes out, this should not be
necessary anymore. The AUR contains a working git based libcanberra-git
if you want to keep the functionality.

> Qt5

You need to install qt5-base and the wayland plugin - qt5-qtwayland-git.

To run a Qt5 app with the Wayland plugin, set
QT_QPA_PLATFORM=wayland-egl.

> Clutter

The Clutter toolkit has a Wayland backend that allows it to run as a
Wayland client. The backend is in the master branch of the main repo and
can be activated by passing --with-flavour=wayland to the configure
script.

> SDL

Benjamin Franzke is working on a port of SDL to Wayland, it's available
in his sdl-wayland repo on freedesktop.org. Further development upon
Benjamins work was done by Andre Heider in his wayland branch of libsdl.

> EFL

EFL has complete Wayland support. Please see here for details.

Window managers and desktop shells
----------------------------------

> KDE

There is early work to make it possible to run KWin (KDE's window
manager) on Wayland.

> GNOME

GNOME is currently ported to Wayland and will be available in a future
version. For details look into the GNOME Wiki.

> Pure Wayland

Warning:Some really quick notes on installing a pure (no X11) wayland
system on Arch Linux. This is from source and installed into /usr/local.
May break your system. You have been warned. (by elethiomel@gmail.com)

First install a base Arch Linux install with base and base-devel. Do not
install xorg or any of its libraries

  

Wayland

    $ pacman -S libffi
    $ git clone git://anongit.freedesktop.org/wayland/wayland
    $ cd wayland
    $ ./autogen.sh --prefix=/usr/local
    $ make
    $ make install

DRM and Mesa

    $ git clone git://anongit.freedesktop.org/git/mesa/drm
    $ cd drm
    $ ./autogen.sh --prefix=/usr/local
    $ make
    $ make install

    $ git clone git://anongit.freedesktop.org/mesa/mesa
    $ cd mesa
    $ CFLAGS=-DMESA_EGL_NO_X11_HEADERS ./autogen.sh --prefix=/usr/local --enable-gles2 --disable-gallium-egl --with-egl-platforms=wayland,drm --enable-gbm --enable-shared-glapi --with-gallium-drivers=r300,r600,swrast,nouveau --disable-glx --disable-xlib
    $ make
    $ make install

xorg-macros

    $ git clone http://anongit.freedesktop.org/git/xorg/util/macros.git
    $ cd macros/
    $ ./autogen.sh --prefix=/usr/local/
    $ make
    $ make install

libxkbcommon

    $ git clone git://people.freedesktop.org/xorg/lib/libxkbcommon.git
    $ cd libxkbcommon/
    $ export ACLOCAL_PATH=/usr/local/share/aclocal/
    $ ./autogen.sh --prefix=/usr/local/ --with-xkb-config-root=/usr/local/share/X11/xkb
    $ make
    $ make install

pixman

    $ git clone git://anongit.freedesktop.org/pixman
    $ cd pixman/
    $ ./autogen.sh --prefix=/usr/local/
    $ make
    $ make install
     

cairo

Note - no glx/gl or xcb - EGL only.

    $ pacman -S libpng
    $ git clone git://anongit.freedesktop.org/cairo
    $ cd cairo
    $ CFLAGS=-DMESA_EGL_NO_X11_HEADERS ./autogen.sh --prefix=/usr/local/  --disable-xcb  --enable-glesv2 
    $ make
    $ make install

xkb files

Either

a) Copy from an existing system a set of xkb layouts

    $ scp -r /usr/share/X11/xkb to /usr/local/share/X11/

or

b) build xkeyboard-config from git with --prefix=/usr/local and
--disable-runtime-deps

weston

    $ git clone git://anongit.freedesktop.org/wayland/weston
    $ cd weston/
    $ CFLAGS="-I/usr/local/include/libdrm/ -DMESA_EGL_NO_X11_HEADERS" ./autogen.sh --prefix=/usr/local/ --with-cairo-glesv2 --disable-xwayland --disable-x11-compositor --disable- xwayland-test
    $ make
    $ make install

See also
--------

-   Cursor Themes

External links
--------------

-   Arch Linux forum discussion
-   Wayland documentation online

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wayland&oldid=254535"

Category:

-   X Server
