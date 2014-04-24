Intel Graphics
==============

Related articles

-   Intel GMA3600
-   Poulsbo
-   Xorg

Since Intel provides and supports open source drivers, Intel graphics
are now essentially plug-and-play.

For a comprehensive list of Intel GPU models and corresponding chipsets
and CPUs, see this comparison on Wikipedia.

Note:PowerVR-based graphics (GMA 500 and GMA 3600 series) are not
supported by open source drivers.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 KMS (Kernel Mode Setting)
-   4 Module-based Powersaving Options
-   5 Tips and tricks
    -   5.1 Choose acceleration method
    -   5.2 Disable Vertical Synchronization (VSYNC)
    -   5.3 Setting scaling mode
    -   5.4 KMS Issue: console is limited to small area
    -   5.5 H.264 decoding on GMA 4500
    -   5.6 Setting gamma and brightness
-   6 Troubleshooting
    -   6.1 Blank screen during boot, when "Loading modules"
    -   6.2 Tear-free video
    -   6.3 X freeze/crash with intel driver
    -   6.4 Adding undetected resolutions
    -   6.5 Weathered colors (colorspace problem)
    -   6.6 Backlight not fully adjusting, or adjusting at all, after
        resume.
    -   6.7 Disabling frame buffer compression
    -   6.8 Corruption/Unresponsiveness in Chromium and Firefox
-   7 See also

Installation
------------

Prerequisite: Xorg.

Install the xf86-video-intel package from the official repositories. It
provides the DDX driver for 2D acceleration and it pulls in intel-dri as
a dependency, providing the DRI driver for 3D acceleration.

For 32-bit 3D support on x86_64, install lib32-intel-dri from the
multilib repository.

Hardware accelerated video decoding/encoding on older GPUs is provided
by the XvMC driver which is included with the DDX driver. For newer GPUs
install the VA-API driver provided by the libva-intel-driver package.

Configuration
-------------

There is no need for any kind of configuration to get X.Org running (an
xorg.conf is not needed, but needs to be configured correctly if
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

The i915 kernel module allows for configuration via module options. Some
of the module options impact power saving.

To check which options are currently enabled, run

    # for i in /sys/module/i915/parameters/*; do echo $i=$(cat $i); done

A list of all options along with short descriptions and default values
can be generated with the following command:

    $ modinfo i915 | grep parm

The following set of options should be generally safe to enable:

    /etc/modprobe.d/i915.conf

    options i915 i915_enable_rc6=7 i915_enable_fbc=1 lvds_downclock=1

Framebuffer compression may be unreliable on old intel generations of
intel GPUs (which exactly?). Check you system journal for messages like:

    kernel: drm: not enough stolen space for compressed buffer, disabling.

Tips and tricks
---------------

> Choose acceleration method

-   UXA - (Unified Acceleration Architecture) is the mature backend that
    was introduced to support the GEM driver model.
-   SNA - (Sandybridge's New Acceleration) is the faster successor for
    hardware supporting it.

The default method is SNA(as of 2013-08-05[2]), which is less stable but
faster than UXA. Check benchmarks done by Phoronix [3]. These can be
found here for Sandy Bridge and here for Ivy Bridge. UXA is still a
solid option, if experiencing trouble with SNA. SNA can for example
cause a black screen on leaving fullscreen of a Flash video.

To use the old UXA method, create /etc/X11/xorg.conf.d/20-intel.conf
with the following content:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier  "Intel Graphics"
       Driver      "intel"
       Option      "AccelMethod"  "uxa"
    EndSection

One can also want to test the new Glamor mode which accelerates 2D
graphics with OpenGL. To use it, create
/etc/X11/xorg.conf.d/20-intel.conf with the following content:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier  "Intel Graphics"
       Driver      "intel"
       Option      "AccelMethod"  "glamor"
    EndSection

> Disable Vertical Synchronization (VSYNC)

The intel-driver uses Triple Buffering for vertical synchronization,
this allows for full performance and avoids tearing. To turn vertical
synchronization off (e.g. for benchmarking) use this .drirc in your home
directory:

    ~/.drirc

    <device screen="0" driver="dri2">
    	<application name="Default">
    		<option name="vblank_mode" value="0"/>
    	</application>
    </device>

Don't use driconf to create this file, it's buggy and will set the wrong
driver.

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
while 720p worked reasonably well [4]. This is echoed by other
experiences [5].

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

If you need to output to VGA then try this:

    video=VGA-1:1280x800

> Tear-free video

Tip:If using the GNOME desktop environment, a simpler and less
performance-impacting fix can be found at
GNOME#Tear-free_video_with_Intel_HD_Graphics.

The SNA acceleration method causes tearing for some people. To fix this,
enable the "Tearfree" option in the driver:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
       Identifier  "Intel Graphics"
       Driver      "intel"
       Option      "TearFree"    "true"
    EndSection

See the original bug report for more info.

> Note:

-   This option may not work when SwapbuffersWait is false.
-   This option is problematic for applications that are very picky
    about vsync timing, like Super Meat Boy.
-   This option does not work with UXA acceleration method, only with
    SNA.

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

> Weathered colors (colorspace problem)

Note:This problem is related to the changes in the kernel 3.9. This
problem still remains in kernel 3.10

Kernel 3.9 contains the Intel driver changes allowing easy RGB Limited
range settings which can cause weathered colors in some cases. It is
related to the new "Automatic" mode for the "Broadcast RGB" property.
One can force mode e.g.
xrandr --output <HDMI> --set "Broadcast RGB" "Full" (replace <HDMI> with
the appropriate output device, verify by running xrandr). You can add it
into your .xprofile, make it executable to run the command before it
will start the graphical mode.

Note:Some TVs can only display colors from 16-255 so setting to Full
will cause color clipping in the 0-15 range so it's best to leave it at
Automatic which will automatically detect whether it needs to compress
the colorspace for your TV.

Also there are other related problems which can be fixed editing GPU
registers. More information can be found [6] and [7].

> Backlight not fully adjusting, or adjusting at all, after resume.

If you are using Intel graphics and have no control over your
manufacturer suplied hotkeys for changing screen brightness, try booting
the kernel parameter:

    acpi_backlight=vendor

If that doesnt solve the problem, many folks have gotten mileage from
either:

    acpi_osi=Linux

or

    acpi_osi="!Windows 2012"

either in addition to the earlier mentioned parameter, or on its own.

As of kernel version 3.13, there is also this kernel command line
parameter which has been proved useful for some users:

    video.use_native_backlight=1

If neither of those solve your problem, you should edit/create
/etc/X11/xorg.conf.d/20-intel.conf with the following content:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
            Identifier  "card0"
            Driver      "intel"
            Option      "Backlight"  "intel_backlight"
            BusID       "PCI:0:2:0"

    EndSection

If you are using the SNA acceleration as mentioned above, create the
file as follows:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device"
            Identifier  "card0"
            Driver      "intel"
            Option      "AccelMethod"  "sna"
            Option      "Backlight"    "intel_backlight"
            BusID       "PCI:0:2:0"

    EndSection

> Disabling frame buffer compression

On some cards such as Intel Corporation Mobile 4 Series Chipsets,
enabled and forced frame buffer compression results in endless error
messages:

    $ dmesg |tail 
    [ 2360.475430] [drm] not enough stolen space for compressed buffer (need 4325376 bytes), disabling
    [ 2360.475437] [drm] hint: you may be able to increase stolen memory size in the BIOS to avoid this

The solution is to disable frame buffer compression which will slightly
increase power consumption. In order to disable it add
i915.i915_enable_fbc=0 to the kernel line parameters. More information
on the results of disabled compression can be found here.

> Corruption/Unresponsiveness in Chromium and Firefox

If you experience corruption or unresponsiveness in Chromium and/or
Firefox set the AccelMethod to "uxa"

See also
--------

-   https://01.org/linuxgraphics/documentation (includes a list of
    supported hardware)
-   KMS - Arch wiki article on kernel mode setting
-   Xrandr - Problems setting the resolution
-   Arch Linux forums: Intel 945GM, Xorg, Kernel - performance

Retrieved from
"https://wiki.archlinux.org/index.php?title=Intel_Graphics&oldid=303572"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 8 March 2014, at 07:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
