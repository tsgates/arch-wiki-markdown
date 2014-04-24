VA-API
======

Related articles

-   VDPAU
-   XvMC

Video Acceleration API is a specification and open source library to
provide hardware accelerated video decode/encode.

Contents
--------

-   1 Supported hardware
    -   1.1 Supported formats
    -   1.2 Configuration
-   2 Supported software

Supported hardware
------------------

Open source drivers:

-   AMD Radeon 9500 and newer GPUs are supported by the
    libva-vdpau-driver package (available in the official repositories)
    together with the ati-dri driver.

-   Intel GMA 4500 series and newer GPUs are supported by the
    libva-intel-driver package, available in the official repositories.

-   NVIDIA GeForce 8 series and newer GPUs are supported by the
    libva-vdpau-driver package (available in the official repositories)
    together with the nouveau-dri driver. It uses the nouveau-fw
    package, which contains the required firmware to operate that is
    presently extracted from the NVIDIA binary driver.

Proprietary drivers:

-   AMD Radeon HD 4000 series and newer GPUs are supported by the
    libva-xvba-driver package, available in the AUR. It uses the
    catalyst-utils driver for Radeon HD 5000 series and newer, and
    catalyst-legacy-utils for Radeon HD 4000 series.

-   NVIDIA GeForce 8 series and newer GPUs are supported by the
    libva-vdpau-driver package (available in the official repositories)
    together with the nvidia-utils driver.

> Supported formats

                   libva-vdpau-driver with ati-dri   libva-intel-driver                             libva-vdpau-driver with nouveau-dri                    libva-xvba-driver              libva-vdpau-driver with nvidia-utils
  ---------------- --------------------------------- ---------------------------------------------- ------------------------------------------------------ ------------------------------ --------------------------------------
  MPEG2 decoding   AMD Radeon 9500 and newer         Intel GMA 4500 and newer                       Nvidia GeForce 8 and newer                             AMD Radeon HD 4000 and newer   Nvidia GeForce 8 and newer
  MPEG4 decoding   AMD Radeon HD 6000 and newer      --                                             Nvidia GeForce 200 and newer                           AMD Radeon HD 6000 and newer   Nvidia GeForce 200 and newer
  H264 decoding    AMD Radeon HD 4000 and newer      Intel GMA 45001, Ironlake Graphics and newer   Nvidia GeForce 8 and newer                             AMD Radeon HD 4000 and newer   Nvidia GeForce 8 and newer
  VC1 decoding     AMD Radeon HD 4000 and newer      Intel Sandy Bridge Graphics and newer          Nvidia GeForce 8200, 8300, 8400, 9300, 200 and newer   AMD Radeon HD 4000 and newer   Nvidia GeForce 8 and newer
  MPEG2 encoding   --                                Intel Ivy Bridge Graphics and newer            --                                                     --                             --
  H264 encoding    --                                Intel Sandy Bridge Graphics and newer          --                                                     --                             --

1Supported by the libva-driver-intel-g45-h264 package. See H.264
decoding on GMA 4500 for instructions and caveats.

In order to check what profiles (features) are supported by your GPU,
run the following command, which provided by the libva package:

    $ vainfo

VAEntrypointVLD means that your card is capable to decode this format,
VAEntrypointEncSlice means that you can encode to this format.

> Configuration

libva-vdpau-driver has to be enabled manually with an environment
variable globally or locally per user.

    export LIBVA_DRIVER_NAME=vdpau

Supported software
------------------

-   GStreamer based players - VA-API is used automatically, if supported
    format found.

See more at
http://docs.gstreamer.com/display/GstSDK/Playback+tutorial+8%3A+Hardware-accelerated+video+decoding.

-   VLC media player: see VLC media player#Harware acceleration support.
-   Mpv: see Mpv#Hardware Decoding.
-   MPlayer: see MPlayer#Enabling VA-API.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VA-API&oldid=304838"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 16 March 2014, at 07:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
