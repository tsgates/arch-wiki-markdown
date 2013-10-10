Intel Graphics
==============

> Summary

Information on Intel graphics cards/chipsets and the intel video driver.

> Related

Intel GMA3600

Poulsbo

Xorg

Since Intel provides and supports open source drivers, Intel graphics
are now essentially plug-and-play.

For a comprehensive list of Intel GPU models and corresponding chipsets
and CPUs, see this comparison on wikipedia.

Note:PowerVR-based graphics (GMA 500 and GMA 3600 series) are not
supported by open source drivers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 KMS (Kernel Mode Setting)                                          |
| -   4 Module-based Powersaving Options                                   |
| -   5 Tips and tricks                                                    |
|     -   5.1 Choose acceleration method                                   |
|     -   5.2 Setting scaling mode                                         |
|     -   5.3 KMS Issue: console is limited to small area                  |
|     -   5.4 H.264 decoding on GMA 4500                                   |
|     -   5.5 Setting gamma and brightness                                 |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Blank screen during boot, when "Loading modules"             |
|     -   6.2 Tear-free video                                              |
|     -   6.3 X freeze/crash with intel driver                             |
|     -   6.4 Adding undetected resolutions                                |
|     -   6.5 Slowness after an upgrade to libGL 9 and Intel-DRI 9         |
|     -   6.6 Black textures in video games                                |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Prerequisite: Xorg

Install the xf86-video-intel package which is available in the official
repositories. It provides the DDX driver for 2D acceleration and an XvMC
driver for video decoding on older GPUs. It pulls in intel-dri as a
dependency, providing the DRI driver for 3D acceleration.

Hardware accelerated video decoding/encoding on newer GPUs is possible
through the VA-API driver provided by libva-intel-driver package also,
available in the official repositories.

Note:User may need to install lib32-intel-dri in 64-bit systems to use
3D acceleration in 32-bit programs.

Configuration
-------------

There is no need for any kind of configuration to get the X.Org running
(an xorg.conf is unneeded, but needs to be configured correctly if
present).

For the list of options, type man intel.

KMS (Kernel Mode Setting)
-------------------------

Tip:If you have problems with the resolution, check this page.

KMS is required in order to run X and a desktop environment such as
GNOME, KDE, Xfce, LXDE, etc. KMS is supported by Intel chipsets that use
the i915 DRM driver and is enabled by default as of kernel v2.6.32.
Versions 2.10 and newer of the xf86-video-intel driver no longer support
UMS (except for the very old 810 chipset family), making the use of KMS
mandatory[1]. KMS is typically initialized after the kernel is
bootstrapped. It is possible, however, to enable KMS during bootstrap
itself, allowing the entire boot process to run at the native
resolution.

Note:Users must remove any deprecated references to vga or nomodeset
from boot configuration.

To proceed, add the i915 module to the MODULES line in
/etc/mkinitcpio.conf:

    MODULES="i915"

If you are using a custom EDID file, you should embed it into initramfs
as well:

    /etc/mkinitcpio.conf

    FILES="/lib/firmware/edid/your_edid.bin"

Now, regenerate the initramfs:

    # mkinitcpio -p linux

and reboot the system. Everything should work now.

Module-based Powersaving Options
--------------------------------

The i915 kernel module allows for configuration via
/etc/modprobe.d/i915.conf wherein users can define powersavings options.
A listing of options is available via the following command:

    $ modinfo i915 | grep power

An example /etc/modprobe.d/i915.conf:

    options i915 i915_enable_rc6=7 i915_enable_fbc=1 lvds_downclock=1

Tips and tricks
---------------

> Choose acceleration method

-   UXA - (Unified Acceleration Architecture) is the mature backend that
    was introduced to support the GEM driver model.
-   SNA - (Sandybridge's New Acceleration) is the faster successor for
    hardware supporting it.

The default method is UXA, which is more stable but slower than SNA. SNA
has improved performance, but still considered experimental. Check
benchmarks done by Phoronix [2]. These can be found here for Sandy
Bridge and here for Ivy Bridge. UXA is still a solid option, if
experiencing trouble with SNA. If you are having trouble with UXA though
you might have better luck with SNA.

To use the new SNA method, create /etc/X11/xorg.conf.d/20-intel.conf
with the following content:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier  "Intel Graphics"
       Driver      "intel"
       Option      "AccelMethod"  "sna"
    EndSection

> Setting scaling mode

This can be useful for some full screen applications:

    $ xrandr --output LVDS1 --set PANEL_FITTING param

where param can be:

-   center: resolution will be kept exactly as defined, no scaling will
    be made,
-   full: scale the resolution so it uses the entire screen or
-   full_aspect: scale the resolution to the maximum possible but keep
    the aspect ratio.

If it does not work, try:

    $ xrandr --output LVDS1 --set "scaling mode" param

where param is one of "Full", "Center" or "Full aspect".

> KMS Issue: console is limited to small area

One of the low-resolution video ports may be enabled on boot which is
causing the terminal to utilize a small area of the screen. To fix,
explicitly disable the port with an i915 module setting with
video=SVIDEO-1:d in the kernel command line parameter in the bootloader.
See Kernel parameters for more info.

If that does not work, try disabling TV1 or VGA1 instead of SVIDEO-1.

> H.264 decoding on GMA 4500

The libva-intel-driver package provides MPEG-2 decoding only for GMA
4500 series GPUs. The H.264 decoding support is maintained in a
separated g45-h264 branch, which can be used by installing
libva-driver-intel-g45-h264 package, available in the Arch User
Repository. Note however that this support is experimental and not
currently in active development. Using the VA-API with this driver on a
GMA 4500 series GPU will offload the CPU but may not result in as smooth
a playback as non-accelerated playback. Tests using mplayer showed that
using vaapi to play back an H.264 encoded 1080p video halved the CPU
load (compared to the XV overlay) but resulted in very choppy playback,
while 720p worked reasonably well [3]. This is echoed by other
experiences [4].

> Setting gamma and brightness

Intel offers no way to adjust these at the driver level. Luckily these
can be set with xgamma and xrandr.

Gamma can be set with:

    $ xgamma -gamma 1.0

or:

    $ xrandr --output VGA1 --gamma 1.0:1.0:1.0

Brightness can be set with:

    $ xrandr --output VGA1 --brightness 1.0

Troubleshooting
---------------

> Blank screen during boot, when "Loading modules"

If using "late start" KMS and the screen goes blank when "Loading
modules", it may help to add i915 and intel_agp to the initramfs. See
the above KMS section.

Alternatively, appending the following kernel parameter seems to work as
well:

    video=SVIDEO-1:d

> Tear-free video

If using the SNA acceleration method, ablate video tearing by adding the
following to the Device section of /etc/X11/xorg.conf.d/20-intel.conf:

    Option "TearFree" "true"

Note:This option may not work when SwapbuffersWait is false.

> X freeze/crash with intel driver

Some issues with X crashing, GPU hanging, or problems with X freezing,
can be fixed by disabling the GPU usage with the NoAccel option:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier "Intel Graphics"
       Driver "intel"
       Option "NoAccel" "True"
    EndSection

Alternatively, try to disable the 3D acceleration only with the DRI
option:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier "Intel Graphics"
       Driver "intel"
       Option "DRI" "False"
    EndSection

If you experience crashes and have

    Option "TearFree" "true"
    Option "AccelMethod" "sna"

in your config file, in most cases these can be fixed by adding

    i915.semaphores=1

to your boot parameters.

> Adding undetected resolutions

This issue is covered on the Xrandr page.

> Slowness after an upgrade to libGL 9 and Intel-DRI 9

Downgrade to Intel-DRI 8 and libGL 8.

> Black textures in video games

Users experiencing black textures in video games may find a solution by
enabling S3TC texture compression support. It can be enabled through
driconf or by installing libtxc_dxtn.

This "issue" will be fixed very soon in the newer drivers

Read more about S3TC at: http://dri.freedesktop.org/wiki/S3TC
http://en.wikipedia.org/wiki/S3_Texture_Compression

One of the games that is affected by this issue is Oil Rush and World of
Warcraft using Wine.

See also
--------

-   https://01.org/linuxgraphics/documentation (includes a list of
    supported hardware)
-   KMS — Arch wiki article on kernel mode setting
-   Xrandr — Problems setting the resolution
-   Arch Linux forums: Intel 945GM, Xorg, Kernel - performance

Retrieved from
"https://wiki.archlinux.org/index.php?title=Intel_Graphics&oldid=256006"

Categories:

-   Graphics
-   X Server
