PRIME
=====

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The list of      
                           drivers that support     
                           PRIME is incomplete.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

PRIME is a technology used to manage hybrid graphics found on recent
laptops (Optimus for NVIDIA, AMD Dynamic Switchable Graphics for ATI).

The following drivers support it:

-   xf86-video-nouveau
-   xf86-video-ati
-   xf86-video-intel

Contents
--------

-   1 Installation
-   2 Troubleshooting
    -   2.1 XRandR specifies only 1 output provider
    -   2.2 When an application is rendered with the discrete card, it
        only renders a black screen
        -   2.2.1 Black screen with GL-based compositors

Installation
------------

First, check the list of video cards attached to your display:

    $ xrandr --listproviders

    Providers: number : 2
    Provider 0: id: 0x7d cap: 0xb, Source Output, Sink Output, Sink Offload crtcs: 3 outputs: 4 associated providers: 1 name:Intel
    Provider 1: id: 0x56 cap: 0xf, Source Output, Sink Output, Source Offload, Sink Offload crtcs: 6 outputs: 1 associated providers: 1 name:radeon

We can see that there are two graphic cards: Intel, the integrated card
(id 0x7d), and Radeon, the discrete card (id 0x56), which should be used
for GPU-intensive applications. We can see that, by default, Intel is
always used:

    $ glxinfo | grep "OpenGL renderer"

    OpenGL renderer string: Mesa DRI Intel(R) Ivybridge Mobile

To use your discrete card (in this case, radeon), you must first define
it as an offload provider for the integrated one, since it’s the
integrated one that is connected to your display.

    $ xrandr --setprovideroffloadsink 0x56 0x7d

Now, you can use your discrete card for the applications who need it the
most (for example games, 3D modellers...):

    $ DRI_PRIME=1 glxinfo | grep "OpenGL renderer"

    OpenGL renderer string: Gallium 0.4 on AMD TURKS

Other applications will still use the less power-hungry integrated card.
The xrandr --setprovideroffloadsink 0x56 0x7d must be run at each X
server restart; you may want to make a script and auto-run it at the
startup of desktop environment (or you may put it in
/etc/X11/xinit/xinitrc.d/).

Troubleshooting
---------------

> XRandR specifies only 1 output provider

Delete/move /etc/X11/xorg.conf file and any other files relating to GPUs
in /etc/X11/xorg.conf.d/

> When an application is rendered with the discrete card, it only renders a black screen

In some cases PRIME needs a composition manager to properly work. If
your window manager doesn’t do compositing, you can use xcompmgr on top
of it.

Black screen with GL-based compositors

Currently there are issues with GL-based compositors and PRIME
offloading. While Xrender-based compositors (xcompmgr, xfwm, compton's
default backend, cairo-compmgr, and a few others) will work without
issue, GL-based compositors (Mutter/muffin, Compiz, compton with GLX
backend, Kwin's OpenGL backend, etc) will initially show a black screen,
as if there was no compositor running. While you can force an image to
appear by resizing the offloaded window, this is not a practical
solution as it will not work for things such as full screen Wine
applications. This means that desktop environments such as GNOME3 and
Cinnamon have issues with using PRIME offloading.

Additionally if you are using an Intel IGP you might be able to fix the
GL Compositing issue by running the IGP as UXA instead of SNA, however
this may cause issues with the offloading process (ie, xrandr
--listproviders may not list the discrete GPU).

Retrieved from
"https://wiki.archlinux.org/index.php?title=PRIME&oldid=295417"

Category:

-   Graphics

-   This page was last modified on 2 February 2014, at 01:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
