Using 32-bit applications on Arch64
===================================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Multilib.   
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

64-Bit-Processors like Athlon 64 are able to execute 32- and 64-bit
programs at the same time.

Contents
--------

-   1 Packages
-   2 Installation
    -   2.1 OpenGL-Applications
    -   2.2 QT-Applications
    -   2.3 Alsa & OpenAL
-   3 Environment Variables

Packages
--------

32bit packages can now be found in the [multilib]-repository. You will
need to add this repository before downloading any 32bit lib.

Installation
------------

You will always need to install lib32-glibc in order to execute
32-bit-programs. It might be necessary to fake the output of uname. Use
the package linux32 for this.

Some legacy C++ programs also need lib32-libstdc++5.

> OpenGL-Applications

Programs using OpenGL need one of the following libraries:

-   Open source drivers:
    lib32-{ati,intel,mach64,mga,nouveau,r128,savage,sis,tdfx,unichrome}-dri
-   Closed source drivers: lib32-{catalyst,nvidia}-utils
-   Software rendering: lib32-libgl

> QT-Applications

Programs using QT should run at once after installing lib32-qt.

> Alsa & OpenAL

For Alsa and OpenAL-Support you have to install lib32-alsa-lib and
lib32-openal.

Environment Variables
---------------------

Some useful Env Variables when running 32bit-applications without
chroot:

For gtk2 input modules and such

    GTK_PATH=/opt/lib32/usr/lib/gtk-2.0/

For pango (lib32-pango includes these config files)

    PANGO_RC_FILE="/opt/lib32/config/pango/pangorc"

Iconv (conversion from 'XXXXXXX' is not supported or cannot convert from
X to Y -errors)

    GCONV_PATH=/opt/lib32/usr/lib/gconv

Library paths without having them in /etc/ld.so.conf

    LD_LIBRARY_PATH="/opt/lib32/usr/lib/:/opt/lib32/lib/:$LD_LIBRARY_PATH"

GDK stuff (GdkPixbuf warnings errors criticals, lib32-gtk2 includes the
file)

    GDK_PIXBUF_MODULE_FILE="/opt/lib32/config/gdk/gdk-pixbuf.loaders"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Using_32-bit_applications_on_Arch64&oldid=299830"

Category:

-   Arch64

-   This page was last modified on 22 February 2014, at 15:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
