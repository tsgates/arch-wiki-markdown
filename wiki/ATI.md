ATI
===

Summary

An overview of the open source ATI/AMD video card driver.

Related

AMD Catalyst

Xorg

Owners of ATI/AMD video cards have a choice between AMD's proprietary
driver (catalyst) and the open source driver (xf86-video-ati). This
article covers the open source driver.

The open source driver is currently not on par with the proprietary
driver in terms of 3D performance on newer cards or reliable TV-out
support. It does, however, offer better dual-head support, excellent 2D
acceleration, and provide sufficient 3D acceleration for
OpenGL-accelerated window managers, such as Compiz or KWin.

If unsure, try the open source driver first, it will suit most needs and
is generally less problematic (see the feature matrix for details).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Naming conventions                                                 |
| -   2 Overview                                                           |
| -   3 Installation                                                       |
|     -   3.1 Installing xf86-video-ati                                    |
|                                                                          |
| -   4 Configuration                                                      |
| -   5 Kernel mode-setting (KMS)                                          |
|     -   5.1 Enabling KMS                                                 |
|         -   5.1.1 Early KMS start                                        |
|         -   5.1.2 Late start                                             |
|                                                                          |
|     -   5.2 Troubleshooting KMS                                          |
|         -   5.2.1 Disable KMS                                            |
|         -   5.2.2 Renaming xorg.conf                                     |
|                                                                          |
| -   6 Performance tuning                                                 |
|     -   6.1 Activate PCI-E 2.0                                           |
|     -   6.2 Glamor                                                       |
|                                                                          |
| -   7 Powersaving                                                        |
|     -   7.1 With KMS enabled                                             |
|     -   7.2 Without KMS                                                  |
|                                                                          |
| -   8 TV out                                                             |
|     -   8.1 Force TV-out in KMS                                          |
|                                                                          |
| -   9 HDMI Audio                                                         |
|     -   9.1 Testing HDMI Audio                                           |
|                                                                          |
| -   10 Dual Head Setup                                                   |
|     -   10.1 Independent X Screens                                       |
|                                                                          |
| -   11 Enabling video acceleration                                       |
| -   12 Troubleshooting                                                   |
|     -   12.1 Artifacts upon logging in                                   |
|     -   12.2 Adding undetected resolutions                               |
|     -   12.3 Slow performance with open-source drivers                   |
|     -   12.4 AGP is disabled (with KMS)                                  |
|     -   12.5 TV showing a black border around the screen                 |
|     -   12.6 Black screen with mouse cursor on resume from suspend in X  |
|     -   12.7 No Desktop Effects in KDE4 with X1300 and Radeon Driver     |
|     -   12.8 Black screen and no console, but X works in KMS             |
|     -   12.9 Some 3D applications show textures as all black or crash    |
|     -   12.10 2D performance (e.g. scrolling) is slow                    |
|     -   12.11 ATI X1600 (RV530 series) 3D application show black windows |
|     -   12.12 Vertical colored stripes on chipset RS482 (Xpress 200M     |
|         Series) with/out KMS                                             |
+--------------------------------------------------------------------------+

Naming conventions
------------------

ATI's Radeon brand follows a naming scheme that relates each product to
a market segment. Within this article, readers will see both product
names (e.g. HD 4850, X1900) and code or core names (e.g. RV770, R580).
Traditionally, a product series will correspond to a core series (e.g.
the "X1000" product series includes the X1300, X1600, X1800, and X1900
products which utilize the "R500" core series – including the RV515,
RV530, R520, and R580 cores).

For a table of core and product series, see Wikipedia:Comparison of AMD
graphics processing units.

Overview
--------

The xf86-video-ati (radeon) driver:

-   Works with Radeon chipsets up to HD 6xxx and 7xxxM (latest Northern
    Islands chipsets).
    -   Radeons in the HD 77xx (Southern Islands) series are partially
        supported. Check the feature matrix for unsupported features.
    -   Radeons up to the X1xxx series are fully supported, stable, and
        full 2D and 3D acceleration are provided.
    -   Radeons from HD 2xxx to HD 6xxx have full 2D acceleration and
        functional 3D acceleration, but are not supported by all the
        features that the proprietary driver provides.

-   Supports DRI1, RandR 1.2/1.3, EXA acceleration and kernel
    mode-setting/DRI2 (with the latest Linux kernel, libdrm and Mesa
    versions).

Generally, xf86-video-ati should be your first choice, no matter which
ATI card you own. In case you need to use a driver for newer ATI cards,
you should consider the proprietary catalyst driver.

Note:xf86-video-ati is specified as radeon for the kernel and in
xorg.conf.

Installation
------------

If Catalyst/fglrx has been previously installed, see here.

  

> Installing xf86-video-ati

Install xf86-video-ati, available in the Official Repositories.

The -git version of the driver and other needed packages (linux-git,
etc) can be found in the radeon repository or the AUR.

Configuration
-------------

Xorg will automatically load the driver and it will use your monitor's
EDID to set the native resolution. Configuration is only required for
tuning the driver.

If you want manual configuration, create
/etc/X11/xorg.conf.d/20-radeon.conf, and add the following:

    Section "Device"
        Identifier "Radeon"
        Driver "radeon"
    EndSection

Using this section, you can enable features and tweak the driver
settings.

Kernel mode-setting (KMS)
-------------------------

Tip:If you have problems with the resolution, check this page.

KMS enables native resolution in the framebuffer and allows for instant
console (tty) switching. KMS also enables newer technologies (such as
DRI2) which will help reduce artifacts and increase 3D performance, even
kernel space power-saving.

KMS for ATI video cards requires the Xorg free video user space driver
xf86-video-ati version 6.12.4 or later.

> Enabling KMS

Note: Since Linux kernel v.2.6.33, KMS is enabled by default for
autodetected ATI/AMD cards. This section remains for configurations
outside stock.

Early KMS start

These two methods will start KMS as early as possible in the boot
process.

1. The earliest point is to append the kernel line in your bootloader
with radeon.modeset=1. See your bootloader's page for info on how to do
this.

-   Remove all vga= options from the kernel line in the bootloader
    configuration file. Using other framebuffer drivers (such as uvesafb
    or radeonfb) will conflict with KMS.
-   AGP speed can be set with radeon.agpmode=x kernel option, where x is
    1, 2, 4, 8 (AGP speed) or -1 (PCI mode).

2. Otherwise, when the initramfs is loaded:

-   If you have a special kernel outside of stock -ARCH (e.g.
    linux-zen), remember to use a separate mkinitcpio configuration file
    (e.g. /etc/mkinitcpio-zen.conf) and not /etc/mkinitcpio.conf.
-   Remove any framebuffer related modules from your mkinitcpio file.
-   Add radeon to MODULES array in your mkinitcpio file. For AGP
    support, it is necessary to add intel_agp (or ali_agp, ati_agp,
    amd_agp, amd64_agp etc.) before the radeon module.
-   Re-generate your initramfs.

Finally, Reboot the system.

Late start

With this choice, KMS will be enabled when modules are loaded during the
boot process.

If you have a special kernel (e.g. linux-zen), remember to use
appropriate mkinitcpio configuration file, e.g.
/etc/mkinitcpio-zen.conf. These instructions are written for the default
kernel (linux).

Note: For AGP support, it may be necessary to add intel_agp, ali_agp,
ati_agp, amd_agp, or amd64_agp) to appropriate .conf files in
/etc/modules-load.d.

1.  Remove all vga= options from the kernel line in the bootloader
    configuration file. Using other framebuffer drivers (such as uvesafb
    or radeonfb) will conflict with KMS. Remove any framebuffer related
    modules from /etc/mkinitcpio.conf. video= can now be used in
    conjunction with KMS.
2.  Add options radeon modeset=1 to /etc/modprobe.d/modprobe.conf.
3.  Reboot the system.

> Troubleshooting KMS

Disable KMS

Users should consider disabling kernel mode-setting if encountering
kernel panics, distorted framebuffer on boot, no GPU signal, Xorg
refusing to start, Xorg falling back to Mesa software rasterizer (no 3D
acceleration) or 'POWER OFF' problem (kernel 2.6.33-2)at shutdown.

1.  Add radeon.modeset=0 (or nomodeset, if this does not work) to the
    kernel options line in the bootloader configuration file. That
    should work.
    Note: Adding nomodeset to the kernel boot line might prevent GNOME
    3's gnome-shell or KDE's desktop effects from running.
    If you want to remove KMS support from the initramfs, follow the
    next two steps.
2.  If radeon was added to the MODULES array in mkinitcpio.conf to
    enable early start, remove it.
3.  Rebuild the initramfs with

        # mkinitcpio -p linux

Alternatively, module options can be specified in a file within the
/etc/modprobe.d directory. If using the radeon module
(lsmod | grep radeon) disable KMS by creating a file containing the
above code:

    /etc/modprobe.d/radeon.conf

    options radeon modeset=0

Renaming xorg.conf

Renaming /etc/X11/xorg.conf, which may include options that conflict
with KMS, will force Xorg to autodetect hardware with sane defaults.
After renaming, restart Xorg.

Performance tuning
------------------

The following options apply to /etc/X11/xorg.conf.d/20-radeon.conf.

By design, xf86-video-ati runs at AGP 4x speed. It is generally safe to
modify this. If you notice hangs, try reducing the value or removing the
line entirely (you can use values 1, 2, 4, 8). If KMS is enabled, this
option is not used and it is superseded by radeon.agpmode kernel option.

    Option "AGPMode" "8"

ColorTiling is completely safe to enable and supposedly is enabled by
default. Most users will notice increased performance but it is not yet
supported on R200 and earlier cards. Can be enabled on earlier cards,
but the workload is transferred to the CPU

    Option "ColorTiling" "on"

Acceleration architecture; this will work only on newer cards. If you
enable this and then cannot get back into X, remove it.

    Option "AccelMethod" "EXA"

Page Flip is generally safe to enable. This would mostly be used on
older cards, as enabling this would disable EXA. With recent drivers can
be used together with EXA.

    Option "EnablePageFlip" "on"

AGPFastWrite will enable fast writes for AGP cards. This one can cause
instabilities, so be prepared to remove it if you cannot get into X.
This option is not used when KMS is on.

    Option "AGPFastWrite" "yes"

EXAVSync option attempts to avoid tearing by stalling the engine until
the display controller has passed the destination region. It reduces
tearing at the cost of performance and has been know to cause
instability on some chips. Really useful when enabling Xv overlay on
videos on a 3D accelerated desktop. It is not necessary when KMS (thus
DRI2 acceleration) is enabled.

    Option "EXAVSync" "yes"

Bellow is a sample config file /etc/X11/xorg.conf.d/20-radeon.conf:

    Section "Device"
           Identifier  "My Graphics Card"
            Option	"AGPMode"               "8"   #not used when KMS is on
    	Option	"AGPFastWrite"          "off" #could cause instabilities enable it at your own risk
    	Option	"SWcursor"              "off" #software cursor might be necessary on some rare occasions, hence set off by default
    	Option	"EnablePageFlip"        "on"  #supported on all R/RV/RS4xx and older hardware and set off by default
    	Option	"AccelMethod"           "EXA" #valid options are XAA, EXA and Glamor. EXA is the default.
    	Option	"RenderAccel"           "on"  #enabled by default on all radeon hardware
    	Option	"ColorTiling"           "on"  #enabled by default on RV300 and later radeon cards.
    	Option	"EXAVSync"              "off" #default is off, otherwise on. Only works if EXA activated
    	Option	"EXAPixmaps"            "on"  #when on icreases 2D performance, but may also cause artifacts on some old cards. Only works if EXA activated
    	Option	"AccelDFS"              "on"  #default is off, read the radeon manpage for more information
    EndSection

Defining the gartsize, if not autodetected, can be done by adding
radeon.gartsize=32 into kernel parameters. Size is in megabytes and 32
is for RV280 cards.

Alternatively, do it with a modprobe option in
/etc/modprobe.d/radeon.conf:

    options radeon gartsize=32

For further information and other options, read the radeon manpage and
the module's info page:

    man radeon

    modinfo radeon

A fine tool to try is driconf. It will allow you to modify several
settings, like vsync, anisotropic filtering, texture compression, etc.
Using this tool it is also possible to "disable Low Impact fallback"
needed by some programs (e.g. Google Earth).

> Activate PCI-E 2.0

Can be unstable with some motherboards or not produce any performarce,
test yourself adding "radeon.pcie_gen2=1" on the kernel command line.

Note:As of kernel 3.6, PCI-E v2.0 in radeon appears to be turned on by
default.

More info on Phoronix article

> Glamor

With the newest version of the free ATI drivers, you can now use a novel
AccelMethod called "glamor": it is a 2D acceleration method implemented
through OpenGL, and it should work with graphic cards whose driver are
newer or equal to R300.

     Option	"AccelMethod"           "glamor"

However, you need to add the following section before:

    Section "Module"
    	Load "dri2"
    	Load "glamoregl" 
    EndSection

Powersaving
-----------

The powersaving part is totally different with and without KMS.

> With KMS enabled

With the radeon driver, power saving is disabled by default but the
stock kernel (2.6.35 as of this writing) provides a "sysfs" utility to
enable it.

Power saving through KMS is still a work in progress for the most part.
It should work, but some chips do have problems with it. A common issue
for all is screen blinking when the kernel switches between power
states, and in some configurations it even causes system freezes. But
KMS is awesome, so it is your choice. The UMS method is generally more
stable, however its power savings might not be as good as those provided
by KMS options.

There are two ways to enable power management:

1.  Try adding radeon.dynpm=1 to the Kernel parameters (if using the
    stock kernel < 2.6.35). If you are using Linux kernel >= 2.6.35 this
    option is no longer needed and the sysfs interface will be present
    by default. If this option is passed to a kernel >= 2.6.35, the
    driver will fail and fall back to software rendering.
2.  Use the (unsupported) [radeon] repo:

This repository will grant you up-to-date packages of the radeon driver
and its dependencies, from (mostly) git snapshots.

    [mesa-git]
    Server = http://pkgbuild.com/~lcarlier/$repo/$arch/

  
 You can select the methods via sysfs.

With root access, you have two choices:

1. Dynamic frequency switching (depending on GPU load)

    # echo dynpm > /sys/class/drm/card0/device/power_method

The "dynpm" method dynamically changes the clocks based on the number of
pending fences, so performance is ramped up when running GPU intensive
apps, and ramped down when the GPU is idle. The re-clocking is attempted
during vertical blanking periods, but due to the timing of the
re-clocking functions, does not always complete in the blanking period,
which can lead to flicker in the display. Due to this, dynpm only works
when a single head is active.

Note:The "profile" method mentioned below is not as aggressive as
"dynpm," but is currently much more stable and flicker free and works
with multiple heads active.

2. Profile-based frequency switching

    # echo profile > /sys/class/drm/card0/device/power_method

The "profile" mode will allow you to select one of the five profiles
below. Different profiles, for the most part, end up changing the
frequency/voltage of the card.

-   "default" uses the default clocks and does not change the power
    state. This is the default behavior.
-   "auto" selects between "mid" and "high" power states based on the
    whether the system is on battery power or not. The "low" power state
    are selected when the monitors are in the dpms off state.
-   "low" forces the gpu to be in the low power state all the time. Note
    that "low" can cause display problems on some laptops; this is why
    auto only uses "low" when displays are off.
-   "mid" forces the gpu to be in the "mid" power state all the time.
    The "low" power state is selected when the monitors are in the dpms
    off state.
-   "high" forces the gpu to be in the "high" power state all the time.
    The "low" power state is selected when the monitors are in the dpms
    off state.

So lets say we want the "low" option...for this, run the following
command:

    # echo low > /sys/class/drm/card0/device/power_profile

Replace "low" with any of the aforementioned profiles as necessary.

Tip:Echoing a profile value to this file is not permanent, so when you
find something that fits your needs, you can use tmpfiles.d or following
udev rule:

dynpm-method example:

    $ cat /etc/udev/rules.d/30-local.rules

    KERNEL=="dri/card0", SUBSYSTEM=="drm", DRIVERS=="radeon", ATTR{device/power_method}="dynpm"

auto-profile example:

    $ cat /etc/udev/rules.d/30-local.rules

    KERNEL=="dri/card0", SUBSYSTEM=="drm", DRIVERS=="radeon", ATTR{device/power_method}="profile", ATTR{device/power_profile}="auto"

Note:Gnome-shell users may be interested in the following extension:
Radeon Power Profile Manager for manually controlling the GPU profiles.
The extension is now available in the AUR and will default to the mid
profile at startup.

Note:Another option from the same author for non Gnome-shell users (with
a few more features) written in PyQt4 is Radeon-tray [1].

  
 Power management is supported on all asics (r1xx-evergreen) that
include the appropriate power state tables in the vbios; not all boards
do (especially older desktop cards).

To view the speed that the GPU is running at, perform the following
command and you will get something like this output:

    $ cat /sys/kernel/debug/dri/0/radeon_pm_info

      state: PM_STATE_ENABLED
      default engine clock: 300000 kHz
      current engine clock: 300720 kHz
      default memory clock: 200000 kHz

If /sys/kernel/debug is empty, run this command:

    # mount -t debugfs none /sys/kernel/debug

To permanently mount, add the following line to /etc/fstab:

    debugfs   /sys/kernel/debug   debugfs   defaults   0   0

It depends on which GPU line yours is, however. Along with the radeon
driver versions, kernel versions, etc. So it may not have much/any
voltage regulation at all.

Thermal sensors are implemented via external i2c chips or via the
internal thermal sensor (rv6xx-evergreen only). To get the temperature
on asics that use i2c chips, you need to load the appropriate hwmon
driver for the sensor used on your board (lm63, lm64, etc.). The drm
will attempt to load the appropriate hwmon driver. On boards that use
the internal thermal sensor, the drm will set up the hwmon interface
automatically. When the appropriate driver is loaded, the temperatures
can be accessed via lm_sensors tools or via sysfs in /sys/class/hwmon .

There is a GUI for switching profiles here (available in AUR).

> Without KMS

In your xorg.conf file, add 2 lines to "Device" Section:

           Option      "DynamicPM"          "on"
           Option      "ClockGating"        "on"

If the two options are enabled successfully, you will see following
lines in /var/log/Xorg.0.log:

           (**) RADEON(0): Option "ClockGating" "on"
           (**) RADEON(0): Option "DynamicPM" "on"

           Static power management enable success
           (II) RADEON(0): Dynamic Clock Gating Enabled
           (II) RADEON(0): Dynamic Power Management Enabled

If you desire low power cost, you can add an extra line to "Device"
Section of xorg.conf:

           Option      "ForceLowPowerMode"   "on"

TV out
------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Since August 2007, there is TV-out support for all Radeons with
integrated TV-out.

It is somewhat limited for now, it does not always autodetect the output
correctly and only NTSC mode works.

First, check that you have an S-video output: xrandr should give you
something like

    Screen 0: minimum 320x200, current 1024x768, maximum 1280x1200
    ...
    S-video disconnected (normal left inverted right x axis y axis)

Setting tv standard to use:

    xrandr --output S-video --set "tv standard" ntsc

Adding a mode for it (currently it supports only 800x600):

    xrandr --addmode S-video 800x600

I will go for a clone mode:

    xrandr --output S-video --same-as VGA-0

So far so good. Now let us try to see what we have:

    xrandr --output S-video --mode 800x600

At this point you should see a 800x600 version of your desktop on your
TV.

To disable the output, do

    xrandr --output S-video --off

Also you may notice that the video is being played on monitor only and
not on the TV. Where the Xv overlay is sent is controlled by XV_CRTC
attribute.

To send the output to the TV, I do

    xvattr -a XV_CRTC -v 1

Note: you need to install xvattr from AUR to execute this command.

To switch back to my monitor, I change this to 0. -1 is used for
automatic switching in dualhead setups.

Please see Enabling TV-Out Statically for how to enable TV-out in your
xorg configuration file.

> Force TV-out in KMS

Kernel can recognize video= parameter in following form:

     video=<conn>:<xres>x<yres>[M][R][-<bpp>][@<refresh>][i][m][eDd]

(see KMS)

For example:

     video=DVI-I-1:1280x1024-24@60e

or

     "video=9-pin DIN-1:1024x768-24@60e"

Parameters with whitespaces must be quoted. Current mkinitcpio
implementation also requires # before. For example:

     root=/dev/disk/by-uuid/d950a14f-fc0c-451d-b0d4-f95c2adefee3 ro quiet radeon.modeset=1 security=none # video=DVI-I-1:1280x1024-24@60e "video=9-pin DIN-1:1024x768-24@60e"

-   Grub can pass such command line as is.
-   Lilo needs backslashes for doublequotes (append="...... # ....
    \"video=9-pin DIN-1:1024x768-24@60e\"")
-   Grub2: TODO

You can get list of your video outputs with following command:

    ls -1 /sys/class/drm/ | grep -E '^card[[:digit:]]+-' | cut -d- -f2-

HDMI Audio
----------

xf86-video-ati can enable HDMI audio output for all supported chipsets
up to r7xx when using KMS. Just use xrandr to enable the output and Test
as described below.

> Testing HDMI Audio

1.  Connect your PC to the Display via HDMI cable.
2.  Use xrandr to get picture to the Display, e.g.:
    xrandr --output DVI-D_1 --mode 1280x768 --right-of PANEL. Simply
    typing xrandr will give you a list of valid outputs.
3.  Run aplay -l to get the list of sound devices. Find HDMI and note
    the card number and corresponding device number. Example of what you
    want to see:
    card 1: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
4.  Try sending sound to this device:
    aplay -D plughw:1,3 /usr/share/sounds/alsa/Front_Center.wav. Be sure
    to change plughw:z,y to match the hardware number found with last
    command. You should be able to hear the test sound from the display.

-   The audio module is disabled by default in kernel >=3.0. Add
    radeon.audio=1 to the Kernel parameters.
-   If the sound is distorted try setting tsched=0 and make sure rtkit
    daemon is running.

Dual Head Setup
---------------

> Independent X Screens

Independent dual-headed setups can be configured the usual way. However
you might want to know that the radeon driver has a "ZaphodHeads" option
which allows you to bind a specific device section to an output of your
choice, for instance using:

           Section "Device"
           Identifier     "Device0"
           Driver         "radeon"
           Option         "ZaphodHeads"   "VGA-0"
           VendorName     "ATI"
           BusID          "PCI:1:0:0"
           Screen          0
           EndSection

This can be a life-saver, because some cards which have more than two
outputs (for instance one HDMI out, one DVI, one VGA), will only select
and use HDMI+DVI outputs for the dual-head setup, unless you explicitely
specify "ZaphodHeads"   "VGA-0".

Moreover, this option allows you to easily select the screen you want to
mark as primary.

Enabling video acceleration
---------------------------

Latest mesa package added support for MPEG1/2 decoding to free drivers,
exported via libvdpau. After installing it assign environment variable
LIBVA_DRIVER_NAME to vdpau and VDPAU_DRIVER to the name of driver core,
e.g.:

    ~/.bashrc

    export LIBVA_DRIVER_NAME=vdpau
    export VDPAU_DRIVER=r600

for r600-based cards (all available VDPAU drivers are in
/usr/lib/vdpau/).

Troubleshooting
---------------

> Artifacts upon logging in

If encountering artifacts, first try starting X without
/etc/X11/xorg.conf. Recent versions of Xorg are capable of reliable
auto-detection and auto-configuration for most use cases. Outdated or
improperly configured xorg.conf files are known to cause trouble.

In order to run without a configuration tile, it is recommended that the
xorg-input-drivers package group be installed.

Artifacts may also be related to kernel mode setting. Consider disabling
KMS.

You may as well try disabling EXAPixmaps in
/etc/X11/xorg.conf.d/20-radeon.conf:

    Section "Device"
        Identifier "Radeon"
        Driver "radeon"
        Option "EXAPixmaps" "off"
    EndSection

Further tweaking could be done by disabling AccelDFS:

    Option "AccelDFS" "off"

> Adding undetected resolutions

e.g. When EDID fails on a DisplayPort connection.

This issue is covered on the Xrandr page.

> Slow performance with open-source drivers

Note:Make sure you are member of video group.

Some cards can be installed by default trying to use KMS. You can check
whether this is your case running:

    dmesg | egrep "drm|radeon"

This command might show something like this, meaning it is trying to
default to KMS:

    [drm] radeon default to kernel modesetting.
    ...
    [drm:radeon_driver_load_kms] *ERROR* Failed to initialize radeon, disabling IOCTL

If your card is not supported by KMS (anything older than r100), then
you can disable KMS. This should fix the problem.

> AGP is disabled (with KMS)

If you experience poor performance and dmesg shows something like this

    [drm:radeon_agp_init] *ERROR* Unable to acquire AGP: -19

then check if the agp driver for your motherboard (e.g., via_agp,
intel_agp etc.) is loaded before the radeon module, see Enabling KMS.

> TV showing a black border around the screen

When I connected my TV to my Radeon HD 5770 using the HDMI port, the TV
showed a blurry picture with a 2-3cm border around it. This is not the
case when using the proprietary driver. However, this protection against
overscanning (see Wikipedia:Overscan) can be turned off using xrandr:

    xrandr --output HDMI-0 --set underscan off

> Black screen with mouse cursor on resume from suspend in X

Waking from suspend on cards with 32MB or less can result in a black
screen with a mouse pointer in X. Some parts of the screen may be
redrawn when under the mouse cursor. Forcing EXAPixmaps to "enabled" in
/etc/X11/xorg.conf.d/20-radeon.conf may fix the problem. See performance
tuning for more information.

> No Desktop Effects in KDE4 with X1300 and Radeon Driver

A bug in KDE4 may prevent an accurate video hardware check, thereby
deactivating desktop effects despite the X1300 having more than
sufficient GPU power. A workaround may be to manually override such
checks in KDE4 configuration files
/usr/share/kde-settings/kde-profile/default/share/config/kwinrc and/or
.kde/share/config/kwinrc.

Add:

    DisableChecks=true

To the [Compositing] section. Ensure that compositing is enabled with:

    Enabled=true

> Black screen and no console, but X works in KMS

This is a solution to no-console problem that might come up, when using
two or more ATI cards on the same PC. Fujitsu Siemens Amilo PA 3553
laptop for example has this problem. This is due to fbcon console driver
mapping itself to wrong framebuffer device that exist on the wrong card.
This can be fixed by adding a this to the kernel boot line:

    fbcon=map:1

This will tell the fbcon to map itself to the /dev/fb1 framebuffer dev
and not the /dev/fb0, that in our case exist on the wrong graphics card.

> Some 3D applications show textures as all black or crash

You might need texture compression support, which is not included with
the open source driver. Install libtxc_dxtn (and lib32-libtxc_dxtn for
multilib systems).

> 2D performance (e.g. scrolling) is slow

If you have problem with 2D performance, like scrolling in terminal or
browser, you might need to add Option  "MigrationHeuristic"  "greedy"
into the "Device" section of your xorg.conf file.

Bellow is a sample config file /etc/X11/xorg.conf.d/20-radeon.conf:

    Section "Device"
            Identifier  "My Graphics Card"
            Driver  "radeon"
            Option  "MigrationHeuristic"  "greedy"
    EndSection

> ATI X1600 (RV530 series) 3D application show black windows

There are three possible solutions:

-   Try add pci=nomsi to your boot loader Kernel parameters.
-   If this doesn't work, you can try adding noapic instead of
    pci=nomsi.
-   If none of the above work, then you can try running
    vblank_mode=0 glxgears or vblank_mode=1 glxgears to see which one
    works for you, then install driconf via pacman and set that option
    in ~/.drirc.

  

> Vertical colored stripes on chipset RS482 (Xpress 200M Series) with/out KMS

The bug :With the graphical chipset Xpress 200M Series (Radeon Xpress
1150), booting with KMS gives you sometimes, as soon as Xorg boots, a
screen with many vertical colored stripes. You cannot Alt+Sys+K or do
anything. Take a look [2] for more information, How to fixed ? : disable
dri (needn't to disable kms) Side effert: if i disable "dri" and use no
kernel options (no "nomodeset") i see the vertical stripes at boot, only
for 5 seconds, before having kdm displayed. Then, i have the same
results.

    If I start for example KDE Desktop Effects, i will see again the vertical stripes for 5 seconds...and return to kdm ! :)

Retrieved from
"https://wiki.archlinux.org/index.php?title=ATI&oldid=253505"

Categories:

-   Graphics
-   X Server
