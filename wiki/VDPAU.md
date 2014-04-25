VDPAU
=====

Related articles

-   VA-API
-   XvMC

Video Decode and Presentation API for Unix is an open source library and
API to offload portions of the video decoding process and video
post-processing to the GPU video-hardware.

Contents
--------

-   1 Supported hardware
    -   1.1 Supported formats
    -   1.2 Configuration
-   2 Supported software

Supported hardware
------------------

Open source drivers:

-   AMD Radeon 9500 and newer GPUs are supported by the ati-dri package,
    available in the official repositories.

-   Intel GMA 4500 series and newer GPUs are supported by the
    libvdpau-va-gl package together with the libva-intel-driver.

-   NVIDIA GeForce 8 series and newer GPUs are supported by the
    nouveau-dri package, available in the official repositories. It uses
    the nouveau-fw package, which contains the required firmware to
    operate that is presently extracted from the NVIDIA binary driver.

Proprietary drivers:

-   AMD Radeon HD 4000 series and newer GPUs are supported by the
    libvdpau-va-gl package (available in the official repositories)
    together with the libva-xvba-driver package. It uses the
    catalyst-utils driver for Radeon HD 5000 series and newer, and
    catalyst-legacy-utils for Radeon HD 4000 series.

-   NVIDIA GeForce 8 series and newer GPUs are supported by the
    nvidia-utils package, available in the official repositories.

> Supported formats

                   ati-dri                        libvdpau-va-gl with libva-intel-driver         nouveau-dri                                            libvdpau-va-gl with libva-xvba-driver   nvidia-utils
  ---------------- ------------------------------ ---------------------------------------------- ------------------------------------------------------ --------------------------------------- ------------------------------
  MPEG2 decoding   AMD Radeon 9500 and newer      Intel GMA 4500 and newer                       Nvidia GeForce 8 and newer                             AMD Radeon HD 4000 and newer            Nvidia GeForce 8 and newer
  MPEG4 decoding   AMD Radeon HD 6000 and newer   --                                             Nvidia GeForce 200 and newer                           AMD Radeon HD 6000 and newer            Nvidia GeForce 200 and newer
  H264 decoding    AMD Radeon HD 4000 and newer   Intel GMA 45001, Ironlake Graphics and newer   Nvidia GeForce 8 and newer                             AMD Radeon HD 4000 and newer            Nvidia GeForce 8 and newer
  VC1 decoding     AMD Radeon HD 4000 and newer   Intel Sandy Bridge Graphics and newer          Nvidia GeForce 8200, 8300, 8400, 9300, 200 and newer   AMD Radeon HD 4000 and newer            Nvidia GeForce 8 and newer

1Supported by the libva-driver-intel-g45-h264 package, which is
available in the AUR. See H.264 decoding on GMA 4500 for instructions
and caveats.

> Configuration

The libvdpau-va-gl driver (for Intel Graphics or AMD Catalyst) needs to
be enabled manually. To enable it, create the following file:

    /etc/profile.d/vdpau_vaapi.sh

    #!/bin/sh
    export VDPAU_DRIVER=va_gl

make it executable:

    # chmod +x /etc/profile.d/vdpau_vaapi.sh

and reboot or relogin.

In order to check what features are supported by your GPU, run the
following command, which provided by the vdpauinfo package:

    $ vdpauinfo

Supported software
------------------

-   Adobe Flash Player: see Browser plugins#Adobe Flash Player.

-   MPlayer/mplayer2:

    $ mplayer -vo vdpau, -vc ffmpeg12vdpau,ffwmv3vdpau,ffvc1vdpau,ffh264vdpau,ffodivxvdpau, foobar.mpeg

Note:The ffodivxvdpau codec is only supported by the most recent series
of NVIDIA hardware. Consider omitting it based on your specific
hardware.

-vo option selects VDPAU video output driver, -vc option selects VDPAU
video codecs.

-   gnome-mplayer - To enable hardware acceleration: Edit > Preferences
    > Player, then set Video Output to vdpau.
-   smplayer - To enable hardware acceleration: Options > Preferences >
    General > Video, then set Output driver to vdpau.

-   mpv: see Mpv#Hardware_Decoding.

-   VLC media player: see VLC media player#Harware acceleration support.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VDPAU&oldid=304840"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 16 March 2014, at 07:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
