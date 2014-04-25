XvMC
====

Related articles

-   VA-API
-   VDPAU

X-Video Motion Compensation (XvMC) is an extension for the X.Org Server.
The XvMC API allows video programs to offload portions of the video
decoding process to the GPU video-hardware. Particularly, features that
have the tendency of heavily depending on the processor. Since XvMC
acceleration takes the load off the CPU, thereby reducing processor
requirements for video playback, it is an ideal solution for HDTV video
playback scenarios.

Note:XvMC is obsoleted by VA-API and VDPAU nowadays, which have better
support for recent GPUs.

Contents
--------

-   1 Supported hardware
    -   1.1 Configuration
-   2 Supported software
    -   2.1 MPlayer
    -   2.2 xine
-   3 References

Supported hardware
------------------

Only MPEG-1 and MPEG-2 videos are supported by all driver.

-   NVIDIA GeForce 6 and GeForce 7 series cards are supported by the
    proprietary nvidia-304xx-utils package, available in the official
    repositories.
-   NVIDIA GeForce 5 FX series cards are supported by the proprietary
    nvidia-173xx-utils package, available in the Arch User Repository.
-   NVIDIA GeForce4 series cards are supported by the proprietary
    nvidia-96xx-utils package, available in the Arch User Repository.
-   Intel 810, GMA 950, GMA 3100, GMA 3000, GMA 4500 series and Ironlake
    GPUs are supported by the open source xf86-video-intel package,
    available in the official repositories.
-   AMD Radeon HD 5000 series and newer GPUs are supported by the
    proprietary catalyst-utils package, available in the Arch User
    Repository.
-   AMD Radeon HD 4000 series GPUs are supported by the proprietary
    catalyst-legacy-utils package, available in the Arch User
    Repository.
-   S3 Graphics UniChrome GPUs are supported by the open source
    xf86-video-openchrome package, available in the official
    repositories.

> Configuration

The open source drivers should work without any configuration. For the
proprietary drivers create a new file /etc/X11/XvMCConfig and add:

-   For NVIDIA GPUs:

    libXvMCNVIDIA_dynamic.so.1

-   For AMD GPUs:

    libAMDXvBA.so.1

Supported software
------------------

Tip:Using full screen mode and disabling GUI elements may prevent
flickering while playing the video.

> MPlayer

Install mplayer package, available in the official repositories.

    $ mplayer -vo xvmc -fs foobar.mpeg

-   -vo - Select xvmc video output driver
-   -fs - Fullscreen playback (optional)

MPlayer based players:

-   gnome-mplayer: open preferences and set the video output to "xvmc",
    and select "Enable Video Hardware Support".
-   smplayer: open preferences and set the video driver to "xvmc", and
    deselect "Enable screenshots".

> xine

Install xine-ui package, available in the official repositories.

    $ xine -V xvmc -f -g --no-splash foobar.mpeg

or

    $ xine -V xxmc -f -g --no-splash foobar.mpeg

-   -V - Select the xvmc or xxmc video driver
-   -f - Start in fullscreen mode (optional)
-   -g - Hide GUI (optional)
-   --no-splash - Don't display the splash screen (optional)

References
----------

-   XvMC (from MythTV wiki)
-   MPlayer 1.0rc1 + XvMC Nov 2006
-   Using older machines for HDTV video playback
-   Xine's xxmc plugin

Retrieved from
"https://wiki.archlinux.org/index.php?title=XvMC&oldid=294620"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 27 January 2014, at 12:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
