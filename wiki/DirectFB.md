DirectFB
========

Contents
--------

-   1 Overview
-   2 Build Requirements
-   3 Installation Step by Step
-   4 Using
-   5 Directfb with shared application enabled
-   6 SawMan
-   7 Lite
-   8 Disko

Overview
--------

DirectFB stands for Direct Frame Buffer. It is a software library for
GNU/Linux/Unix-based operating systems with a small memory footprint
that provides graphics acceleration, input device handling and
abstraction layer, and integrated windowing system with support for
translucent windows and multiple display layers on top of the Linux
framebuffer without requiring any kernel modifications.[2] DirectFB is
free software licensed under the terms of the GNU Lesser General Public
License (LGPL).

With the default build of the DirectFB library, only one DirectFB
application may be running. However you have the option to use the multi
application core of DirectFB along with linux-fusion which allows
multiple DirectFB applications to run at the same time within a session.

DirectFB's frameworks for building apps on top of it is somewhat weak
and needs work. It lacks of a real Window Manager (WM). The recently
released WM SaWMan and its "testman" could be a good starting point,
although it is not fully functional. see
http://directfb.org/wiki/index.php/The_DirectFB_Desktop. Disko however,
that can use DirectFB or even fbdev directly, may help rectify this
situation.

DirectFB 2.0: Universal Framework Support. The main goal of the new
universal framework is to make the core of DirectFB an api agnostic
library. Sort of a OS kernel for the gpu. To reach this goal some code
will be moved out of the core into modules and the internal core api
will be exposed as a system programming api for library writers. see
http://directfb.org/wiki/index.php/DirectFB_2.0:_Universal_Framework_Support

Build Requirements
------------------

* * * * *

      Mandatory are
        - libc
        - libpthread
        - libm
        - libdl

      For regenerating autofoo (./autogen.sh or autoreconf)
        - autoconf
        - automake
        - libtool
        - pkg-config

      Optionally, depending on the configuration you want:

      FBDev (when using the kernel frame buffer backend (somewhat the goal of at least the initial directfb) the fbdev install/setup needs explaining, eg: /dev/fb0 .. )
        - Linux kernel 2.2.x or newer with working frame buffer device
          (check /proc/fb) for the fbdev system.

      SDL 
        - libSDL (Simple Direct Media Layer) for the sdl system.

      X11
        - libX11 (X11 client library) for the X11 system (libx11-dev and libxext-dev packages).

      The following libraries are optional, but important (Debian package names):

      Fonts
        - libfreetype6-dev for TrueType and other fonts

      Images
        - libjpeg-dev for Joint Picture Expert Group images
        - libpng-dev for Portable Network Graphics

      Extra
        - zlib1g-dev for compressed screenshot support (also needed by libpng)

If you are planning to run multiple DirectFB applications
simultaneously, you need to build the linux-fusion kernel module.

You can now also build and install DirectFB-examples which contain some
example applications and some benchmarks.

SawMan was the original WM and has been stated to prove itself
sufficient to get things going. Lite is a qui toolkit targeted to
applicatoin developers. Disko however would seem to provide a much
better higher level platform with which a general and rather flexible
(user space definable) WM, as an application, and (actual) applications
can be defined. In any case all three are suggested if you want to futz
around with DirectFB.

Installation Step by Step
-------------------------

DirectFB is included in the official community repository. Install it
with pacman:

    # pacman -S directfb

Using
-----

Directfb with shared application enabled
----------------------------------------

The directfb package does not enable running multiply applications on
the same display. This is of cause necessary for running different
windows on this display. For testing install aur/directfb-multi and
aur/linux-fusion.

Directfb includes an internal Window-Manager so you will not need
SawMan. For moving a window around press the SUPER key on the keyboard.

SawMan
------

SawMan is a Window-Manager for DirectFB. There is only an outdated
package in the AUR; check this page:
https://aur.archlinux.org/packages/sawman/

Lite
----

    (better a link to a Lite page)

Disko
-----

(better a link to a disko page)

1.  kernel frame buffer help/tips

http://www.tldp.org/HOWTO/Framebuffer-HOWTO/x168.html#AEN170

Retrieved from
"https://wiki.archlinux.org/index.php?title=DirectFB&oldid=290506"

Category:

-   Graphics

-   This page was last modified on 26 December 2013, at 22:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
