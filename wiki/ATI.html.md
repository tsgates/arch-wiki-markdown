ATI
===

Related articles

-   AMD Catalyst
-   Xorg

Owners of AMD (previously ATI) video cards have a choice between AMD's
proprietary driver (catalyst) and the open source driver
(xf86-video-ati). This article covers the open source driver.

The open source driver is currently not on par with the proprietary
driver in terms of 3D performance on newer cards or reliable TV-out
support. It does, however, offer better dual-head support, excellent 2D
acceleration, and provide sufficient 3D acceleration for
OpenGL-accelerated window managers, such as Compiz or KWin.

If unsure, try the open source driver first, it will suit most needs and
is generally less problematic (see the feature matrix for details).

Contents
--------

-   1 Naming conventions
-   2 Overview
-   3 Installation
-   4 Configuration
-   5 Kernel mode-setting (KMS)
    -   5.1 Early start
    -   5.2 Late start
-   6 Performance tuning
    -   6.1 Deactivating PCI-E 2.0
    -   6.2 Glamor
-   7 Hybrid graphics/AMD Dynamic Switchable Graphics
-   8 Powersaving
    -   8.1 Old methods
        -   8.1.1 Dynamic frequency switching
        -   8.1.2 Profile-based frequency switching
        -   8.1.3 Persistent configuration
        -   8.1.4 Graphical tools
        -   8.1.5 Other notes
    -   8.2 Dynamic power management
        -   8.2.1 Graphical tools
-   9 TV out
    -   9.1 Force TV-out in KMS
-   10 HDMI audio
-   11 Dual Head setup
    -   11.1 Independent X screens
-   12 Enabling video acceleration
-   13 Turn vsync off
-   14 Troubleshooting
    -   14.1 Artifacts upon logging in
    -   14.2 Adding undetected resolutions
    -   14.3 AGP is disabled (with KMS)
    -   14.4 TV showing a black border around the screen
    -   14.5 Black screen with mouse cursor on resume from suspend in X
    -   14.6 No desktop effects in KDE4 with X1300 and Radeon driver
    -   14.7 Black screen and no console, but X works in KMS
    -   14.8 2D performance (e.g. scrolling) is slow
    -   14.9 ATI X1600 (RV530 series) 3D application show black windows

Naming conventions
------------------

The Radeon brand follows a naming scheme that relates each product to a
market segment. Within this article, readers will see both product names
(e.g. HD 4850, X1900) and code or core names (e.g. RV770, R580).
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
-   Supports DRI1, RandR 1.2/1.3/1.4, EXA acceleration and kernel
    mode-setting/DRI2.

Generally, xf86-video-ati should be your first choice, no matter which
AMD/ATI card you own. In case you need to use a driver for newer AMD
cards, you should consider the proprietary catalyst driver.

Note:xf86-video-ati is specified as radeon for the kernel and in
xorg.conf.

Installation
------------

Note:If coming from the proprietary Catalyst driver, see AMD
Catalyst#Uninstallation first.

Install the xf86-video-ati package from the official repositories. It
provides the DDX driver for 2D acceleration and it pulls in ati-dri as a
dependency, providing the DRI driver for 3D acceleration.

For 32-bit 3D support on x86_64, install lib32-ati-dri from the multilib
repository.

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

> Note:

-   KMS is enabled by default for autodetected AMD/ATI cards. This
    section remains for configurations outside stock.
-   As of Linux 3.9, the radeon driver requires kernel mode-setting (the
    old user mode-setting can still be enabled as a kernel compile
    option, however, some features like HDMI audio depend on KMS). If
    you have radeon.modeset=0 or nomodeset among kernel parameters,
    remove it. If you have options radeon modeset=0 anywhere in
    /etc/modprobe.d/, remove it.

> Early start

These two methods will start KMS as early as possible in the boot
process.

1. Remove all conflicting UMS drivers from kernel command line:

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
-   Add radeon to MODULES array in your mkinitcpio file. For AGP support
    it is necessary to add the AGP driver for your chipset (e.g.
    intel_agp, ali_agp, ati_agp, amd_agp, amd64_agp, etc.) before the
    radeon module.
-   Re-generate your initramfs.

Finally, Reboot the system.

> Late start

With this choice, KMS will be enabled when modules are loaded during the
boot process.

If you have a special kernel (e.g. linux-zen), remember to use
appropriate mkinitcpio configuration file, e.g.
/etc/mkinitcpio-zen.conf. These instructions are written for the default
kernel (linux).

Note:For AGP support, it may be necessary to add intel_agp, ali_agp,
ati_agp, amd_agp, or amd64_agp to appropriate .conf files in
/etc/modules-load.d.

1.  Remove all vga= options from the kernel line in the bootloader
    configuration file. Using other framebuffer drivers (such as uvesafb
    or radeonfb) will conflict with KMS. Remove any framebuffer related
    modules from /etc/mkinitcpio.conf. video= can now be used in
    conjunction with KMS.
2.  Reboot the system.

Performance tuning
------------------

The following options apply to /etc/X11/xorg.conf.d/20-radeon.conf.

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

EXAVSync option attempts to avoid tearing by stalling the engine until
the display controller has passed the destination region. It reduces
tearing at the cost of performance and has been know to cause
instability on some chips. Really useful when enabling Xv overlay on
videos on a 3D accelerated desktop. It is not necessary when KMS (thus
DRI2 acceleration) is enabled.

    Option "EXAVSync" "yes"

Below is a sample config file /etc/X11/xorg.conf.d/20-radeon.conf:

    Section "Device"
    	Identifier  "My Graphics Card"
    	Driver	"radeon"
    	Option	"SWcursor"              "off" #software cursor might be necessary on some rare occasions, hence set off by default
    	Option	"EnablePageFlip"        "on"  #supported on all R/RV/RS4xx and older hardware, and set on by default
    	Option	"AccelMethod"           "EXA" #valid options are XAA, EXA and Glamor. Default value varies per-GPU.
    	Option	"RenderAccel"           "on"  #enabled by default on all radeon hardware
    	Option	"ColorTiling"           "on"  #enabled by default on RV300 and later radeon cards
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
the module's info page: man radeon, modinfo radeon.

A fine tool to try is driconf. It will allow you to modify several
settings, like vsync, anisotropic filtering, texture compression, etc.
Using this tool it is also possible to "disable Low Impact fallback"
needed by some programs (e.g. Google Earth).

> Deactivating PCI-E 2.0

Since kernel 3.6, PCI-E v2.0 in radeon is turned on by default.

It can be unstable with some motherboards, so it can be deactivated by
adding radeon.pcie_gen2=0 on the kernel command line.

See Phoronix article for more information.

> Glamor

Glamor is a 2D acceleration method implemented through OpenGL, and it
should work with graphic cards whose drivers are newer or equal to R300.

Since xf86-video-ati driver-1:7.2.0-1, glamor is automaticaly enabled
with radeonsi drivers (Southern Island and superior GFX cards); with
other graphic cards you can use it by adding the AccelMethod glamor to
your xorg.conf config file in the Device section:

     Option	"AccelMethod"           "glamor"

However, you need to add the following section before:

    Section "Module"
    	Load "dri2"
    	Load "glamoregl" 
    EndSection

Warning:Until Xorg Bug 68524 is fixed, glamor will be extremely slow to
use with the radeonsi driver.

Hybrid graphics/AMD Dynamic Switchable Graphics
-----------------------------------------------

It is the technology used on recent laptops equiped with two GPUs, one
power-efficent (generally Intel integrated card) and one more powerful
and more power-hungry (generally Radeon or Nvidia). There are three ways
to get it work:

-   If you do not need to run any GPU-hungry application, you can
    plainly disable the discrete card:
    echo OFF > /sys/kernel/debug/vgaswitcheroo/switch. You can do more
    things with vgaswitcheroo (see Ubuntu wiki for more information) but
    ultimately at best one card is bound to one graphic session, you
    cannot use both on one graphic session.
-   You can use PRIME. It is the proper way to use hybrid graphics on
    Linux but still requires a bit of manual intervention from the user.
-   You can also use bumblebee with radeon, there is a bumblebee-amd-git
    package on AUR.

Powersaving
-----------

With the radeon driver, power saving is disabled by default and has to
be enabled manually if desired.

You can choose between three different methods:

1.  dynpm
2.  profile
3.  dpm (available since kernel 3.11)

It is hard to say which is the best for you, so you have to try it
yourself!

Power management is supported on all chips that include the appropriate
power state tables in the vbios (R1xx and newer). "dpm" is only
supported on R6xx and newer chips.

See http://www.x.org/wiki/RadeonFeature/#index3h2 for details.

> Old methods

Dynamic frequency switching

This method dynamically changes the frequency depending on GPU load, so
performance is ramped up when running GPU intensive apps, and ramped
down when the GPU is idle. The re-clocking is attempted during vertical
blanking periods, but due to the timing of the re-clocking functions,
does not always complete in the blanking period, which can lead to
flicker in the display. Due to this, dynpm only works when a single head
is active.

It can be activated by simply running the following command:

    # echo dynpm > /sys/class/drm/card0/device/power_method

Profile-based frequency switching

This method will allow you to select one of the five profiles (described
below). Different profiles, for the most part, end up changing the
frequency/voltage of the GPU. This method is not as aggressive, but is
more stable and flicker free and works with multiple heads active.

To activate the method, run the following command:

    # echo profile > /sys/class/drm/card0/device/power_method

Select one of the available profiles:

-   default uses the default clocks and does not change the power state.
    This is the default behaviour.
-   auto selects between mid and high power states based on the whether
    the system is on battery power or not. The low power state is
    selected when the monitors are in the DPMS-off state.
-   low forces the gpu to be in the low power state all the time. Note
    that low can cause display problems on some laptops, which is why
    auto only uses low when monitors are off.
-   mid forces the gpu to be in the mid power state all the time. The
    low power state is selected when the monitors are in the DPMS-off
    state.
-   high forces the gpu to be in the high power state all the time. The
    low power state is selected when the monitors are in the DPMS-off
    state.

As an example, we will activate the low profile (replace low with any of
the aforementioned profiles as necessary):

    # echo low > /sys/class/drm/card0/device/power_profile

Persistent configuration

The activation described above is not persistent, it will not last when
the computer is rebooted. To make it persistent, you can use
systemd-tmpfiles (example for #Dynamic frequency switching):

    /etc/tmpfiles.d/radeon-pm.conf

    w /sys/class/drm/card0/device/power_method - - - - dynpm

Alternatively, you may use this udev rule instead (example for
#Profile-based frequency switching):

    /etc/udev/rules.d/30-radeon-pm.rules

    KERNEL=="dri/card0", SUBSYSTEM=="drm", DRIVERS=="radeon", ATTR{device/power_method}="profile", ATTR{device/power_profile}="low"

Note:If the above rule is failing, try removing the dri/ prefix.

Graphical tools

-   Radeon-tray — A small program to control the power profiles of your
    Radeon card via systray icon. It is written in PyQt4 and is suitable
    for non-Gnome users.

https://github.com/StuntsPT/Radeon-tray || radeon-tray

-   power-play-switcher — A gui for changing powerplay setting of the
    open source driver for ati radeon video cards.

https://code.google.com/p/power-play-switcher/ || power-play-switcher

-   Gnome-shell-extension-Radeon-Power-Profile-Manager — A small
    extension for Gnome-shell that will allow you to change the power
    profile of your radeon card when using the open source drivers.

https://github.com/StuntsPT/shell-extension-radeon-power-profile-manager
|| gnome-shell-extension-radeon-ppm
gnome-shell-extension-radeon-power-profile-manager-git

Other notes

To view the speed that the GPU is running at, perform the following
command and you will get something like this output:

    $ cat /sys/kernel/debug/dri/0/radeon_pm_info

      state: PM_STATE_ENABLED
      default engine clock: 300000 kHz
      current engine clock: 300720 kHz
      default memory clock: 200000 kHz

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
can be accessed via lm_sensors tools or via sysfs in /sys/class/hwmon.

> Dynamic power management

With kernel 3.11, ASPM is activated by default but DPM is not. To
activate it, add the parameter radeon.dpm=1 to the kernel parameters.

Unlike dynpm, the "dpm" method uses hardware on the GPU to dynamically
change the clocks and voltage based on GPU load. It also enables clock
and power gating.

There are 3 operation modes to choose from:

-   battery lowest power consumption
-   balanced sane default
-   performance highest performance

They can be changed via sysfs

    # echo battery > /sys/class/drm/card0/device/power_dpm_state

For testing or debugging purposes, you can force the card to run in a
set performance mode:

-   auto default; uses all levels in the power state
-   low enforces the lowest performance level
-   high enforces the highest performance level

    # echo low > /sys/class/drm/card0/device/power_dpm_force_performance_level

Graphical tools

-   Gnome-shell-extension-Radeon-Power-Profile-Manager by lalmeras —
    This GNOME Shell extension (forked from StuntsPT's one) allows to
    switch easily between battery, balanced and performance dpm
    settings. This extension supports setups with multiple cards.

https://github.com/lalmeras/shell-extension-radeon-power-profile-manager
|| not packaged

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

Note: you need to install xvattr to execute this command.

To switch back to my monitor, I change this to 0. -1 is used for
automatic switching in dualhead setups.

Please see Enabling TV-Out Statically for how to enable TV-out in your
xorg configuration file.

> Force TV-out in KMS

Kernel can recognize video= parameter in following form (see KMS for
more details):

    video=<conn>:<xres>x<yres>[M][R][-<bpp>][@<refresh>][i][m][eDd]

For example:

    video=DVI-I-1:1280x1024-24@60e

Parameters with whitespaces must be quoted:

    "video=9-pin DIN-1:1024x768-24@60e"

Current mkinitcpio implementation also requires # in front. For example:

    root=/dev/disk/by-uuid/d950a14f-fc0c-451d-b0d4-f95c2adefee3 ro quiet radeon.modeset=1 security=none # video=DVI-I-1:1280x1024-24@60e "video=9-pin DIN-1:1024x768-24@60e"

-   Grub can pass such command line as is.
-   Lilo needs backslashes for doublequotes (append
    # \"video=9-pin DIN-1:1024x768-24@60e\")
-   Grub2: TODO

You can get list of your video outputs with following command:

    $ ls -1 /sys/class/drm/ | grep -E '^card[[:digit:]]+-' | cut -d- -f2-

HDMI audio
----------

HDMI audio is supported in the xf86-video-ati video driver. By default
HDMI audio is disabled in the driver kernel versions >=3.0 because it
can be problematic. However, if your Radeon card is listed in the Radeon
Feature Matrix it may work. To enable HDMI audio add radeon.audio=1 to
your kernel parameters.

If there is no video after bootup, the driver option will have to be
disabled.

> Note:

-   If HDMI audio does not simply work after installing the driver, test
    your setup with the procedure at Advanced Linux Sound
    Architecture#HDMI output does not work.
-   If the sound is distorted in PulseAudio try setting tsched=0 and
    make sure rtkit daemon is running.

Dual Head setup
---------------

> Independent X screens

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

Enabling video acceleration
---------------------------

Latest mesa package added support for MPEG1/2 decoding to free drivers,
exported via libvdpau and are automaticaly detected.

You can force used driver by assigning environment variable
LIBVA_DRIVER_NAME to vdpau and VDPAU_DRIVER to the name of driver core,
e.g.:

    ~/.bashrc

    export LIBVA_DRIVER_NAME=vdpau
    export VDPAU_DRIVER=r600

for r600-based cards (all available VDPAU drivers are in
/usr/lib/vdpau/).

Turn vsync off
--------------

The radeon driver will enable vsync by default, which is perfectly fine
except for benchmarking. To turn it off, create ~/.drirc (or edit it if
it already exists) and add the following section:

    ~/.drirc

    <driconf>
        <device screen="0" driver="dri2">
            <application name="Default">
                <option name="vblank_mode" value="0" />
            </application>
        </device>
        <!-- Other devices ... -->
    </driconf>

It is effectively dri2, not your video card code (like r600).

Troubleshooting
---------------

> Artifacts upon logging in

If encountering artifacts, first try starting X without
/etc/X11/xorg.conf. Recent versions of Xorg are capable of reliable
auto-detection and auto-configuration for most use cases. Outdated or
improperly configured xorg.conf files are known to cause trouble.

In order to run without a configuration tile, it is recommended that the
xorg-input-drivers package group be installed.

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

> No desktop effects in KDE4 with X1300 and Radeon driver

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
-   If this does not work, you can try adding noapic instead of
    pci=nomsi.
-   If none of the above work, then you can try running
    vblank_mode=0 glxgears or vblank_mode=1 glxgears to see which one
    works for you, then install driconf and set that option in ~/.drirc.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ATI&oldid=296218"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 4 February 2014, at 18:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
