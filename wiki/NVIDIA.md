NVIDIA
======

Summary

Information on installing, configuring and troubleshooting the
proprietary NVIDIA Drivers.

Related

Nouveau

Xorg

This article covers installing and configuring NVIDIA's proprietary
graphic card driver. For information about the open-source drivers, see
Nouveau.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
|     -   1.1 Alternate install: custom kernel                             |
|     -   1.2 Automatic re-compilation of the NVIDIA module with every     |
|         update of any kernel                                             |
|                                                                          |
| -   2 Configuring                                                        |
|     -   2.1 Automatic configuration                                      |
|     -   2.2 Minimal configuration                                        |
|     -   2.3 Multiple monitors                                            |
|         -   2.3.1 TwinView                                               |
|             -   2.3.1.1 Automatic configuration                          |
|             -   2.3.1.2 Manual CLI configuration with xrandr             |
|                                                                          |
|         -   2.3.2 Using NVIDIA Settings                                  |
|         -   2.3.3 ConnectedMonitor                                       |
|         -   2.3.4 Mosaic Mode                                            |
|             -   2.3.4.1 Base Mosaic                                      |
|             -   2.3.4.2 SLI Mosaic                                       |
|                                                                          |
| -   3 Tweaking                                                           |
|     -   3.1 GUI: nvidia-settings                                         |
|     -   3.2 Enabling MSI (Message Signaled Interrupts)                   |
|     -   3.3 Advanced: 20-nvidia.conf                                     |
|         -   3.3.1 Enabling desktop composition                           |
|         -   3.3.2 Disabling the logo on startup                          |
|         -   3.3.3 Enabling hardware acceleration                         |
|         -   3.3.4 Overriding monitor detection                           |
|         -   3.3.5 Enabling triple buffering                              |
|         -   3.3.6 Using OS-level events                                  |
|         -   3.3.7 Enabling power saving                                  |
|         -   3.3.8 Enabling Brightness Control                            |
|         -   3.3.9 Enabling SLI                                           |
|         -   3.3.10 Forcing Powermizer performance level (for laptops)    |
|             -   3.3.10.1 Letting the GPU set its own performance level   |
|                 based on temperature                                     |
|                                                                          |
|         -   3.3.11 Disable vblank interrupts (for laptops)               |
|         -   3.3.12 Enabling overclocking                                 |
|             -   3.3.12.1 Setting static 2D/3D clocks                     |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Fixing Terminal Resolution                                   |
|     -   4.2 Enabling Pure Video HD (VDPAU/VAAPI)                         |
|     -   4.3 Hardware accelerated video decoding with XvMC                |
|     -   4.4 Using TV-out                                                 |
|     -   4.5 X with a TV (DFP) as the only display                        |
|     -   4.6 Check the power source                                       |
|     -   4.7 Displaying GPU temperature in the shell                      |
|         -   4.7.1 Method 1 - nvidia-settings                             |
|         -   4.7.2 Method 2 - nvidia-smi                                  |
|         -   4.7.3 Method 3 - nvclock                                     |
|                                                                          |
|     -   4.8 Set Fan Speed at Login                                       |
|     -   4.9 Order of install/deinstall for changing drivers              |
|     -   4.10 Switching between nvidia and nouveau drivers                |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Bad performance, e.g. slow repaints when switching tabs in   |
|         Chrome                                                           |
|     -   5.2 Gaming using Twinview                                        |
|     -   5.3 Vertical sync using TwinView                                 |
|     -   5.4 Old Xorg Settings                                            |
|     -   5.5 Corrupted screen: "Six screens" issue                        |
|     -   5.6 '/dev/nvidia0' Input/Output error                            |
|     -   5.7 '/dev/nvidiactl' errors                                      |
|     -   5.8 32 bit applications do not start                             |
|     -   5.9 Errors after updating the kernel                             |
|     -   5.10 Crashing in general                                         |
|     -   5.11 Bad performance after installing a new driver version       |
|     -   5.12 CPU spikes with 400 series cards                            |
|     -   5.13 Laptops: X hangs on login/out, worked around with           |
|         Ctrl+Alt+Backspace                                               |
|     -   5.14 Refresh rate not detected properly by XRandR dependant      |
|         utilities                                                        |
|     -   5.15 No screens found on a laptop / NVIDIA Optimus               |
|     -   5.16 Screen(s) found, but none have a usable configuration       |
|     -   5.17 No brightness control on laptops                            |
|     -   5.18 Black Bars while watching full screen flash videos with     |
|         twinview                                                         |
|     -   5.19 Backlight is not turning off in some occasions              |
|     -   5.20 Blue tint on videos with Flash                              |
|     -   5.21 Bleeding overlay with Flash                                 |
|     -   5.22 Full system freeze using flash                              |
|     -   5.23 XOrg fails to Load or Red Screen of Death                   |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

These instructions are for those using the stock linux package. For
custom kernel setup, skip to the next subsection.

Tip:It is usually beneficial to install the NVIDIA driver through pacman
rather than through the package provided by the NVIDIA site, this allows
the driver to be updated when upgrading the system.

1. If you do not know what graphics card your have, find out by issuing:

    # lspci -k | grep -A 2 -i "VGA"

2. Install the appropriate driver for your card:

-   For GeForce 8 series and newer [NVC0 and newer] cards, install
    nvidia package, available in the official repositories.
-   For GeForce 6/7 series cards [NV40-NVAF], install nvidia-304xx
    package, available in the official repositories.
-   For GeForce 5 FX series cards [NV30-NV38], install nvidia-173xx
    package, available in the AUR.
-   For GeForce 2/3/4 MX/Ti series cards [NV11 and NV17-NV28], install
    nvidia-96xx package, available in the AUR.

Tip:If you are not sure, visit NVIDIA's driver download site to find out
the appropriate driver for a given card. You could also check the legacy
card list and the nouveau wiki's code names page.

For the very latest GPU models, it may be required to install
nvidia-beta from the Arch User Repository, since the stable drivers may
not support the newly introduced features.

Note:The nvidia-libgl or nvidia-{304xx,173xx,96xx}-utils package is a
dependency and will be pulled in automatically. It may conflict with the
libgl package; this is normal. If pacman asks to remove libgl and fails
due to unsatisfied dependencies, remove it with pacman -Rdd libgl.

Note:The nvidia-96xx-utils package requires a legacy X.Org server
release (xorg-server1.12). It conflicts with the xorg-server from the
official repositories.

If you are on 64-bit and also need 32-bit OpenGL support, you must also
install the equivalent lib32 package from the multilib repository (e.g.
lib32-nvidia-libgl or lib32-nvidia-{304xx,173xx}-utils).

Tip:The legacy nvidia-96xx and nvidia-173xx drivers can also be
installed from the unofficial [city] repository.

3. Reboot. The nvidia package contains a file which blacklists the
nouveau module, so rebooting is necessary.

Once the driver has been installed, continue to: #Configuring.

> Alternate install: custom kernel

First of all, it's good to know how the ABS works by reading some of the
other articles about it:

-   Main article for ABS
-   Article on makepkg
-   Article on Creating Packages

Note:You can also find the nvidia-all package in AUR which makes it
easier to use with custom kernels and multiple kernels.

The following is a short tutorial for making a custom NVIDIA driver
package using ABS:

Install abs from the official repositories and generate the tree with:

    # abs

As a standard user, make a temporary directory for creating the new
package:

    $ mkdir -p ~/abs

Make a copy of the nvidia package directory:

    $ cp -r /var/abs/extra/nvidia/ ~/abs/

Go into the temporary nvidia build directory:

    $ cd ~/abs/nvidia

It is required to edit the files nvidia.install and PKGBUILD file so
that they contain the right kernel version variables.

While running the custom kernel, get the appropriate kernel and local
version names:

    $ uname -r

1.  In nvidia.install, replace the EXTRAMODULES='extramodules-3.4-ARCH'
    variable with the custom kernel version, such as
    EXTRAMODULES='extramodules-3.4.4' or
    EXTRAMODULES='extramodules-3.4.4-custom' depending on what the
    kernel's version is and the local version's text/numbers. Do this
    for all instances of the version number within this file.
2.  In PKGBUILD, change the _extramodules=extramodules-3.4-ARCH variable
    to match the appropriate version, as above.
3.  If there are more than one kernels in the system installed in
    parallel (such as a custom kernel alongside the default -ARCH
    kernel), change the pkgname=nvidia variable in the PKGBUILD to a
    unique identifier, such as nvidia-344 or nvidia-custom. This will
    allow both kernels to use the nvidia module, since the custom nvidia
    module has a different package name and will not overwrite the
    original. You will also need to comment the line in package() that
    blacklists the nvidia module in /usr/lib/modprobe.d/nvidia.conf (no
    need to do it again).

Then do:

    $ makepkg -ci

The -c operand tells makepkg to clean left over files after building the
package, whereas -i specifies that makepkg should automatically run
pacman to install the resulting package.

> Automatic re-compilation of the NVIDIA module with every update of any kernel

This is possible thanks to nvidia-hook from the AUR. You will need to
install the module sources: either nvidia-source for the stable drivers
or nvidia-source-beta for the beta drivers. In nvidia-hook, the
'automatic re-compilation' functionality is done by a nvidia hook on
mkinitcpio after forcing to update the linux-headers package. You will
need to add 'nvidia' to the HOOKS array in /etc/mkinitcpio.conf as well
as 'linux-headers' and your custom kernel(s) headers to the SyncFirst
array in /etc/pacman.conf for this to work.

The hook will call the dkms command to update the NVIDIA module for the
version of your new kernel.

Note:If you are using this functionality it's important to look at the
installation process of the linux (or any other kernel) package. nvidia
hook will tell you if anything goes wrong.

  

Note:If you would like to do this manually please see this section in
the dkms arch wiki.

Configuring
-----------

It is possible that after installing the driver it may not be needed to
create an Xorg server configuration file. You can run a test to see if
the Xorg server will function correctly without a configuration file.
However, it may be required to create a /etc/X11/xorg.conf configuration
file in order to adjust various settings. This configuration can be
generated by the NVIDIA Xorg configuration tool, or it can be created
manually. If created manually, it can be a minimal configuration (in the
sense that it will only pass the basic options to the Xorg server), or
it can include a number of settings that can bypass Xorg's
auto-discovered or pre-configured options.

Note:Since 1.8.x Xorg uses separate configuration files in
/etc/X11/xorg.conf.d/ - check out advanced configuration section.

> Automatic configuration

The NVIDIA package includes an automatic configuration tool to create an
Xorg server configuration file (xorg.conf) and can be run by:

    # nvidia-xconfig

This command will auto-detect and create (or edit, if already present)
the /etc/X11/xorg.conf configuration according to present hardware.

If there are instances of DRI, ensure they are commented out:

    #    Load        "dri"

Double check your  /etc/X11/xorg.conf to make sure your default depth,
horizontal sync, vertical refresh, and resolutions are acceptable.

Warning: That may still not work properly with Xorg-server 1.8

> Minimal configuration

A basic xorg.conf would look like this:

    /etc/X11/xorg.conf

    Section "Device"
       Identifier     "Device0"
       Driver         "nvidia"
       VendorName     "NVIDIA Corporation"
    EndSection

Tip:If upgrading from nouveau make sure to remove "nouveau" from
/etc/mkinitcpio.conf. See NVIDIA#Switching between nvidia and nouveau
drivers, if switching between the open and proprietary drivers often.

> Multiple monitors

See Multihead for more general information

To activate dual screen support, you just need to edit the
/etc/X11/xorg.conf.d/10-monitor.conf file which you made before.

Per each physical monitor, add one Monitor, Device, and Screen Section
entry, and then a ServerLayout section to manage it. Be advised that
when Xinerama is enabled, the NVIDIA proprietary driver automatically
disables compositing. If you desire compositing, you should comment out
the Xinerama line in "ServerLayout" and use TwinView (see below)
instead.

    /etc/X11/xorg.conf.d/10-monitor.conf

    Section "ServerLayout"
        Identifier     "DualSreen"
        Screen       0 "Screen0"
        Screen       1 "Screen1" RightOf "Screen0" #Screen1 at the right of Screen0
        Option         "Xinerama" "1" #To move windows between screens
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option         "Enable" "true"
    EndSection

    Section "Monitor"
        Identifier     "Monitor1"
        Option         "Enable" "true"
    EndSection

    Section "Device"
        Identifier     "Device0"
        Driver         "nvidia"
        Screen         0
    EndSection

    Section "Device"
        Identifier     "Device1"
        Driver         "nvidia"
        Screen         1
    EndSection

    Section "Screen"
        Identifier     "Screen0"
        Device         "Device0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
            Modes          "1280x800_75.00"
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen1"
        Device         "Device1"
        Monitor        "Monitor1"
        DefaultDepth   24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
        EndSubSection
    EndSection

TwinView

You want only one big screen instead of two. Set the TwinView argument
to 1. This option should be used instead of Xinerama (see above), if you
desire compositing.

    Option "TwinView" "1"

TwinView only works on a per card basis: If you have multiple cards (and
no SLI?), you'll have to use xinerama or zaphod mode (multiple X
screens). You can combine TwinView with zaphod mode, ending up, for
example, with two X screens covering two monitors each. Most window
managers fail miserably in zaphod mode. The shining exception is
Awesome. KDE almost works.

Example configuration:

    /etc/X11/xorg.conf.d/10-monitor.conf

    Section "ServerLayout"
        Identifier     "TwinLayout"
        Screen         0 "metaScreen" 0 0
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option         "Enable" "true"
    EndSection

    Section "Monitor"
        Identifier     "Monitor1"
        Option         "Enable" "true"
    EndSection

    Section "Device"
        Identifier     "Card0"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"

        #refer to the link below for more information on each of the following options.
        Option         "HorizSync"          "DFP-0: 28-33; DFP-1 28-33"
        Option         "VertRefresh"        "DFP-0: 43-73; DFP-1 43-73"
        Option         "MetaModes"          "1920x1080, 1920x1080"
        Option         "ConnectedMonitor"   "DFP-0, DFP-1"
        Option         "MetaModeOrientation" "DFP-1 LeftOf DFP-0"
    EndSection

    Section "Screen"
        Identifier     "metaScreen"
        Device         "Card0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "TwinView" "True"
        SubSection "Display"
            Modes          "1920x1080"
        EndSubSection
    EndSection

Device Option information

Automatic configuration

The NVIDIA package provides Twinview. This tool will help by
automatically configuring all the monitors connected to your video card.
This only works for multiple monitors on a single card. To configure
Xorg Server with Twinview run:

    # nvidia-xconfig --twinview

Manual CLI configuration with xrandr

If the latest solutions doesn't works for you, you can use the autostart
trick of your window manager to run a xrandr command like this one :

    xrandr --output DVI-I-0 --auto --primary --left-of DVI-I-1

or

    xrandr --output DVI-I-1 --pos 1440x0 --mode 1440x900 --rate 75.0

When:

-   --output is used to indicate to which "monitor" set the options.
-   DVI-I-1 is the name of the second monitor.
-   --pos is the position of the second monitor respect to the first.
-   --mode is the resolution of the second monitor.
-   --rate is the Hz refresh rate.

You must adapt the xrandr options with the help of the output of the
command xrandr run alone in a terminal.

Using NVIDIA Settings

You can also use the nvidia-settings tool provided by nvidia-utils. With
this method, you will use the proprietary software NVIDIA provides with
their drivers. Simply run nvidia-settings as root, then configure as you
wish, and then save the configuration to
/etc/X11/xorg.conf.d/10-monitor.conf.

ConnectedMonitor

If the driver doesn't properly detect a second monitor, you can force it
to do so with ConnectedMonitor.

    /etc/X11/xorg.conf


    Section "Monitor"
        Identifier     "Monitor1"
        VendorName     "Panasonic"
        ModelName      "Panasonic MICRON 2100Ex"
        HorizSync       30.0 - 121.0 # this monitor has incorrect EDID, hence Option "UseEDIDFreqs" "false"
        VertRefresh     50.0 - 160.0
        Option         "DPMS"
    EndSection

    Section "Monitor"
        Identifier     "Monitor2"
        VendorName     "Gateway"
        ModelName      "GatewayVX1120"
        HorizSync       30.0 - 121.0
        VertRefresh     50.0 - 160.0
        Option         "DPMS"
    EndSection

    Section "Device"
        Identifier     "Device1"
        Driver         "nvidia"
        Option         "NoLogo"
        Option         "UseEDIDFreqs" "false"
        Option         "ConnectedMonitor" "CRT,CRT"
        VendorName     "NVIDIA Corporation"
        BoardName      "GeForce 6200 LE"
        BusID          "PCI:3:0:0"
        Screen          0
    EndSection

    Section "Device"
        Identifier     "Device2"
        Driver         "nvidia"
        Option         "NoLogo"
        Option         "UseEDIDFreqs" "false"
        Option         "ConnectedMonitor" "CRT,CRT"
        VendorName     "NVIDIA Corporation"
        BoardName      "GeForce 6200 LE"
        BusID          "PCI:3:0:0"
        Screen          1
    EndSection

The duplicated device with Screen is how you get X to use two monitors
on one card without TwinView. Note that nvidia-settings will strip out
any ConnectedMonitor options you have added.

Mosaic Mode

Mosaic mode is the only way to use more than 2 monitors across multiple
graphics cards with compositing. Your window manager may or may not
recognize the distinction between each monitor.

Base Mosaic

Base mosaic mode works on any set of Geforce 8000 series or higher GPUs.
It cannot be enabled from withing the nvidia-setting GUI. You must
either use the nvidia-xconfig command line program or edit xorg.conf by
hand. Metamodes must be specified. The following is an example for four
DFPs in a 2x2 configuration, each running at 1920x1024, with two DFPs
connected to two cards:

    $ nvidia-xconfig --base-mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"

SLI Mosaic

If you have an SLI configuration and each GPU is a Quadro FX 5800,
Quadro Fermi or newer then you can use SLI Mosaic mode. It can be
enabled from within the nvidia-settings GUI or from the command line
with:

    $ nvidia-xconfig --sli=Mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"

Tweaking
--------

> GUI: nvidia-settings

The NVIDIA package includes the nvidia-settings program that allows
adjustment of several additional settings.

For the settings to be loaded on login, run this command from the
terminal:

    $ nvidia-settings --load-config-only

The desktop environment's auto-startup method 'may' not work for loading
nvidia-settings properly (KDE). To be sure that settings are really
loaded put the command in ~/.xinitrc file (create if not present).

For a dramatic 2D graphics performance increase in pixmap-intensive
applications, e.g. Firefox, set the InitialPixmapPlacement parameter to
2:

    $ nvidia-settings -a InitialPixmapPlacement=2

This is documented in nvidia-settings source code. For this setting to
persist, this command needs to be run on every startup. You can add it
to ~/.xinitrc file for auto-startup with X.

Tip: On rare occasions the ~/.nvidia-settings-rc may become corrupt. If
this happens, the Xorg server may crash and the file will have to be
deleted to fix the issue.

> Enabling MSI (Message Signaled Interrupts)

By default, the graphics card uses a shared interrupt system. To give a
small performance boost, edit /etc/modprobe.d/modprobe.conf and add:

    options nvidia NVreg_EnableMSI=1

Be warned, as this has been known to damage some systems running older
hardware!

To confirm, run:

    # cat /proc/interrupts | grep nvidia
      43:          0         49       4199      86318   PCI-MSI-edge      nvidia

> Advanced: 20-nvidia.conf

Edit /etc/X11/xorg.conf.d/20-nvidia.conf, and add the option to the
correct section. The Xorg server will need to be restarted before any
changes are applied.

-   See NVIDIA Accelerated Linux Graphics Driver README and Installation
    Guide for additional details and options.

Enabling desktop composition

As of NVIDIA driver version 180.44, support for GLX with the Damage and
Composite X extensions is enabled by default. Refer to Xorg#Composite
for detailed instructions.

Disabling the logo on startup

Add the "NoLogo" option under section Device:

    Option "NoLogo" "1"

Enabling hardware acceleration

Note:RenderAccel is enabled by default since drivers version 97.46.xx

Add the "RenderAccel" option under section Device:

    Option "RenderAccel" "1"

Overriding monitor detection

The "ConnectedMonitor" option under section Device allows to override
monitor detection when X server starts, which may save a significant
amount of time at start up. The available options are: "CRT" for analog
connections, "DFP" for digital monitors and "TV" for televisions.

The following statement forces the NVIDIA driver to bypass startup
checks and recognize the monitor as DFP:

    Option "ConnectedMonitor" "DFP"

Note: Use "CRT" for all analog 15 pin VGA connections, even if the
display is a flat panel. "DFP" is intended for DVI digital connections
only.

Enabling triple buffering

Enable the use of triple buffering by adding the "TripleBuffer" Option
under section Device:

    Option "TripleBuffer" "1"

Use this option if the graphics card has plenty of ram (equal or greater
than 128MB). The setting only takes effect when syncing to vblank is
enabled, one of the options featured in nvidia-settings.

Note:This option may introduce full-screen tearing and reduce
performance. As of the R300 drivers, vblank is enabled by default.

Using OS-level events

Taken from the NVIDIA driver's README file: "[...] Use OS-level events
to efficiently notify X when a client has performed direct rendering to
a window that needs to be composited." It may help improving
performance, but it is currently incompatible with SLI and Multi-GPU
modes.

Add under section Device:

    Option "DamageEvents" "1"

Note:This option is enabled by default in newer driver versions.

Enabling power saving

Add under section Monitor:

    Option "DPMS" "1"

Enabling Brightness Control

Add under section Device:

    Option "RegistryDwords" "EnableBrightnessControl=1"

Note:If you already have this enabled and your brightness control
doesn't work try to comment it out.

Enabling SLI

Warning:As of May 7, 2011, you may experience sluggish video performance
in GNOME 3 after enabling SLI.

Taken from the NVIDIA driver's README appendix: This option controls the
configuration of SLI rendering in supported configurations. A "supported
configuration" is a computer equipped with an SLI-Certified Motherboard
and 2 or 3 SLI-Certified GeForce GPUs. See NVIDIA's SLI Zone for more
information.

Find the first GPU's PCI Bus ID using lspci:

    $ lspci | grep VGA

This will return something similar to:

    03:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce 8800 GTS 512] (rev a2)
    05:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce 8800 GTS 512] (rev a2)

Add the BusID (3 in the previous example) under section Device:

    BusID "PCI:3:0:0"

Note:The format is important. The BusID value must be specified as
"PCI:<BusID>:0:0"

Add the desired SLI rendering mode value under section Screen:

    Option "SLI" "SLIAA"

The following table presents the available rendering modes.

  Value                       Behavior
  --------------------------- ----------------------------------------------------------------------------------------------------------------------
  0, no, off, false, Single   Use only a single GPU when rendering.
  1, yes, on, true, Auto      Enable SLI and allow the driver to automatically select the appropriate rendering mode.
  AFR                         Enable SLI and use the alternate frame rendering mode.
  SFR                         Enable SLI and use the split frame rendering mode.
  SLIAA                       Enable SLI and use SLI antialiasing. Use this in conjunction with full scene antialiasing to improve visual quality.

Alternatively, you can use the nvidia-xconfig utility to insert these
changes into xorg.conf with a single command:

    # nvidia-xconfig --busid=PCI:3:0:0 --sli=SLIAA

To verify that SLI mode is enabled from a shell:

    $ nvidia-settings -q all | grep SLIMode
     Attribute 'SLIMode' (arch:0.0): AA 
       'SLIMode' is a string attribute.
       'SLIMode' is a read-only attribute.
       'SLIMode' can use the following target types: X Screen.

Forcing Powermizer performance level (for laptops)

Add under section Device:

    # Force Powermizer to a certain level at all times
    # level 0x1=highest
    # level 0x2=med
    # level 0x3=lowest

    # AC settings:
    Option "RegistryDwords" "PowerMizerLevelAC=0x3"
    # Battery settings:
    Option	"RegistryDwords" "PowerMizerLevel=0x3"

Letting the GPU set its own performance level based on temperature

Add under section Device:

    Option "RegistryDwords" "PerfLevelSrc=0x3333"

Disable vblank interrupts (for laptops)

When running the interrupt detection utility powertop, it can be
observed that the Nvidia driver will generate an interrupt for every
vblank. To disable, place in the Device section:

    Option "OnDemandVBlankInterrupts" "1"

This will reduce interrupts to about one or two per second.

Enabling overclocking

Warning:Please note that overclocking may damage hardware and that no
responsibility may be placed on the authors of this page due to any
damage to any information technology equipment from operating products
out of specifications set by the manufacturer.

To enable GPU and memory overclocking, place the following line in the
Device section:

    Option "Coolbits" "1"

This will enable on-the-fly overclocking within an X session by running:

    $ nvidia-settings

Note:GeForce 400/500/600 series Fermi/Kepler cores cannot currently be
overclocked using the Coolbits method. The alternative is to edit and
reflash the GPU BIOS either under DOS (preferred), or within a Win32
environment by way of nvflash and NiBiTor 6.0. The advantage of BIOS
flashing is that not only can voltage limits be raised, but stability is
generally improved over software overclocking methods such as Coolbits.

Setting static 2D/3D clocks

Set the following string in the Device section to enable PowerMizer at
its maximum performance level:

    Option "RegistryDwords" "PerfLevelSrc=0x2222"

Set one of the following two strings in the Device section to enable
manual GPU fan control within nvidia-settings:

    Option "Coolbits" "4"

    Option "Coolbits" "5"

Tips and tricks
---------------

> Fixing Terminal Resolution

Transitioning from nouveau may cause your startup terminal to display at
a lower resolution. A possible solution (if you are using GRUB) is to
edit the GRUB_GFXMODE line of /etc/default/grub with desired display
resolutions. Multiple resolutions can be specified, including the
default auto, so it is recommended that you edit the line to resemble
GRUB_GFXMODE=<desired resolution>,<fallback such as 1024x768>,auto. See
http://www.gnu.org/software/grub/manual/html_node/gfxmode.html#gfxmode
for more information.

> Enabling Pure Video HD (VDPAU/VAAPI)

Hardware Required:

At least a video card with second generation PureVideo HD [1]

Software Required:

Nvidia video cards with the proprietary driver installed will provide
video decoding capabilities with the VDPAU interface at different levels
according to PureVideo generation.

You can also add support for the VA-API interface with:

    # pacman -S libva-vdpau-driver

Check VA-API support with:

    $ vainfo

To take full advantage of the hardware decoding capability of your video
card you will need a media player that supports VDPAU or VA-API.

To enable hardware acceleration in MPlayer edit ~/.mplayer/config

    vo=vdpau
    vc=ffmpeg12vdpau,ffwmv3vdpau,ffvc1vdpau,ffh264vdpau,ffodivxvdpau,

To enable hardware acceleration in VLC go:

Tools -> Preferences -> Input & Codecs -> check
Use GPU accelerated decoding

To enable hardware acceleration in smplayer go:

Options -> Preferences -> General -> Video Tab -> select vdpau as
output driver

To enable hardware acceleration in gnome-mplayer go:

Edit -> Preferences -> set video output to vdpau

Playing HD movies on cards with low memory:

If your graphic card does not have a lot of memory (>512MB?), you can
experience glitches when watching 1080p or even 720p movies. To avoid
that start simple window manager like TWM or MWM.

Additionally increasing the MPlayer's cache size in ~/.mplayer/config
can help, when your hard drive is spinning down when watching HD movies.

> Hardware accelerated video decoding with XvMC

Accelerated decoding of MPEG-1 and MPEG-2 videos via XvMC are supported
on GeForce4, GeForce 5 FX, GeForce 6 and GeForce 7 series cards. To use
it, create a new file /etc/X11/XvMCConfig with the following content:

    libXvMCNVIDIA_dynamic.so.1

See how to configure supported software.

> Using TV-out

A good article on the subject can be found here

> X with a TV (DFP) as the only display

The X server falls back to CRT-0 if no monitor is automatically
detected. This can be a problem when using a DVI connected TV as the
main display, and X is started while the TV is turned off or otherwise
disconnected.

To force nvidia to use DFP, store a copy of the EDID somewhere in the
filesystem so that X can parse the file instead of reading EDID from the
TV/DFP.

To acquire the EDID, start nvidia-settings. It will show some
information in tree format, ignore the rest of the settings for now and
select the GPU (the corresponding entry should be titled "GPU-0" or
similar), click the DFP section (again, DFP-0 or similar), click on the
Acquire Edid Button and store it somewhere, for example,
/etc/X11/dfp0.edid.

Edit xorg.conf by adding to the Device section:

    Option "ConnectedMonitor" "DFP"
    Option "CustomEDID" "DFP-0:/etc/X11/dfp0.edid"

The ConnectedMonitor option forces the driver to recognize the DFP as if
it were connected. The CustomEDID provides EDID data for the device,
meaning that it will start up just as if the TV/DFP was connected during
X the process.

This way, one can automatically start a display manager at boot time and
still have a working and properly configured X screen by the time the TV
gets powered on.

> Check the power source

The NVIDIA X.org driver can also be used to detect the GPU's current
source of power. To see the current power source, check the
'GPUPowerSource' read-only parameter (0 - AC, 1 - battery):

       $ nvidia-settings -q GPUPowerSource -t
       1

If you're seeing an error message similiar to the one below, then you
either need to install acpid or start the systemd service via
systemctl start acpid.service

    ACPI: failed to connect to the ACPI event daemon; the daemon
    may not be running or the "AcpidSocketPath" X
    configuration option may not be set correctly. When the
    ACPI event daemon is available, the NVIDIA X driver will
    try to use it to receive ACPI event notifications. For
    details, please see the "ConnectToAcpid" and
    "AcpidSocketPath" X configuration options in Appendix B: X
    Config Options in the README.

(If you are not seeing this error, it is not necessary to install/run
acpid soley for this purpose. My current power source is correctly
reported without acpid even installed.)

> Displaying GPU temperature in the shell

Method 1 - nvidia-settings

Note:This method requires that you are using X. Use Method 2 or Method 3
if you are not. Also note that Method 3 currently does not not work with
newer nvidia cards such as the G210/220 as well as embedded GPUs such as
the Zotac IONITX's 8800GS.

To display the GPU temp in the shell, use nvidia-settings as follows:

    $ nvidia-settings -q gpucoretemp

This will output something similar to the following:

    Attribute 'GPUCoreTemp' (hostname:0.0): 41.
    'GPUCoreTemp' is an integer attribute.
    'GPUCoreTemp' is a read-only attribute.
    'GPUCoreTemp' can use the following target types: X Screen, GPU.

The GPU temps of this board is 41 C.

In order to get just the temperature for use in utils such as rrdtool or
conky, among others:

    $ nvidia-settings -q gpucoretemp -t
    41

Method 2 - nvidia-smi

Use nvidia-smi which can read temps directly from the GPU without the
need to use X at all. This is important for a small group of users who
do not have X running on their boxes, perhaps because the box is
headless running server apps. To display the GPU temp in the shell, use
nvidia-smi as follows:

    $ nvidia-smi

This should output something similar to the following:

    $ nvidia-smi
    Fri Jan  6 18:53:54 2012       
    +------------------------------------------------------+                       
    | NVIDIA-SMI 2.290.10   Driver Version: 290.10         |                       
    |-------------------------------+----------------------+----------------------+
    | Nb.  Name                     | Bus Id        Disp.  | Volatile ECC SB / DB |
    | Fan   Temp   Power Usage /Cap | Memory Usage         | GPU Util. Compute M. |
    |===============================+======================+======================|
    | 0.  GeForce 8500 GT           | 0000:01:00.0  N/A    |       N/A        N/A |
    |  30%   62 C  N/A   N/A /  N/A |  17%   42MB /  255MB |  N/A      Default    |
    |-------------------------------+----------------------+----------------------|
    | Compute processes:                                               GPU Memory |
    |  GPU  PID     Process name                                       Usage      |
    |=============================================================================|
    |  0.           ERROR: Not Supported                                          |
    +-----------------------------------------------------------------------------+

Only for Temp:

    $ nvidia-smi -q -d TEMPERATURE

    ==============NVSMI LOG==============

    Timestamp                       : Fri Jan  6 18:50:57 2012

    Driver Version                  : 290.10

    Attached GPUs                   : 1

    GPU 0000:01:00.0
        Temperature
            Gpu                     : 62 C

In order to get just the temperature for use in utils such as rrdtool or
conky, among others:

    $ nvidia-smi -q -d TEMPERATURE | grep Gpu | cut -c35-36

    62

Reference:
http://www.question-defense.com/2010/03/22/gpu-linux-shell-temp-get-nvidia-gpu-temperatures-via-linux-cli

Method 3 - nvclock

Use nvclock which is available from the [extra] repo.

Note:nvclock cannot access thermal sensors on newer NVIDIA cards such as
the G210/220.

There can be significant differences between the temperatures reported
by nvclock and nvidia-settings/nv-control. According to this post by the
author (thunderbird) of nvclock, the nvclock values should be more
accurate.

> Set Fan Speed at Login

You can adjust the fan speed on your graphics card with
nvidia-settings's console interface. First ensure that your Xorg
configuration sets the Coolbits option to 4 or 5 in your Device section
to enable fan control.

    Option "Coolbits" "4"

Note:GTX 4xx/5xx series cards cannot currently set fan speeds at login
using this method. This method only allows for the setting of fan speeds
within the current X session by way of nvidia-settings.

Place the following line in your ~/.xinitrc file to adjust the fan when
you launch Xorg. Replace <n> with the fan speed percentage you want to
set.

    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUCurrentFanSpeed=<n>"

You can also configure a second GPU by incrementing the GPU and fan
number.

    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \ 
    -a "[gpu:1]/GPUFanControlState=1" \
    -a "[fan:0]/GPUCurrentFanSpeed=<n>" \
    -a  [fan:1]/GPUCurrentFanSpeed=<n>" &

If you use a login manager such as GDM or KDM, you can create a desktop
entry file to process this setting. Create
~/.config/autostart/nvidia-fan-speed.desktop and place this text inside
it. Again, change <n> to the speed percentage you want.

    [Desktop Entry]
    Type=Application
    Exec=nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUCurrentFanSpeed=<n>"
    X-GNOME-Autostart-enabled=true
    Name=nvidia-fan-speed

> Order of install/deinstall for changing drivers

Where the old driver is nvidiaO and the new driver is nvidiaN.

    remove nvidiaO
    install nvidia-libglN
    install nvidiaN
    install lib32-nvidia-libgl-N (if required)

> Switching between nvidia and nouveau drivers

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Fresh installs   
                           do not contain           
                           /etc/modprobe.d/modprobe 
                           .conf                    
                           by default. The sed      
                           lines may not be needed. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you are switching between the nvidia and nouveau driver often, you
can use these two scripts to make it easier (both need to be ran as
root):

     #!/bin/bash
     # nouveau -> nvidia
     
     set -e
     
     # check if root
     if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script. Aborting...";
        exit 1;
     fi
     
     sed -i 's/MODULES="nouveau"/#MODULES="nouveau"/' /etc/mkinitcpio.conf
     
     pacman -Rdds --noconfirm nouveau-dri xf86-video-nouveau mesa-libgl #lib32-nouveau-dri lib32-mesa-libgl
     pacman -S --noconfirm nvidia #lib32-nvidia-libgl
     
     mkinitcpio -p linux

     #!/bin/bash
     # nvidia -> nouveau
     
     set -e
     
     # check if root
     if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script. Aborting...";
        exit 1;
     fi
     
     sed -i 's/#*MODULES="nouveau"/MODULES="nouveau"/' /etc/mkinitcpio.conf
     
     pacman -Rdds --noconfirm nvidia #lib32-nvidia-libgl
     pacman -S --noconfirm nouveau-dri xf86-video-nouveau #lib32-nouveau-dri
     
     mkinitcpio -p linux

  
 A reboot is needed to complete the switch.

Adjust the scripts accordingly, if using other NVIDIA drivers (e.g.
nvidia-173xx).

Uncomment the lib32 packages if you run a 64-bit system and require the
32-bit libraries (e.g. 32-bit games/Steam).

Troubleshooting
---------------

> Bad performance, e.g. slow repaints when switching tabs in Chrome

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This bug is most 
                           likely resolved. See the 
                           this bug report          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

On some machines, recent nvidia drivers introduce a bug(?) that causes
X11 to redraw pixmaps really slow. Switching tabs in Chrome/Chromium
(while having more than 2 tabs opened) takes 1-2 seconds, instead of a
few milliseconds.

It seems that setting the variable InitialPixmapPlacement to 0 solves
that problem, although (like described some paragraphs above)
InitialPixmapPlacement=2 should actually be the faster method.

The variable can be (temporarily) set with the command

    nvidia-settings -a InitialPixmapPlacement=0

To make this permanent, this call can be placed in a startup script.

> Gaming using Twinview

In case you want to play fullscreen games when using Twinview, you will
notice that games recognize the two screens as being one big screen.
While this is technically correct (the virtual X screen really is the
size of your screens combined), you probably do not want to play on both
screens at the same time.

To correct this behavior for SDL, try:

    export SDL_VIDEO_FULLSCREEN_HEAD=1

For OpenGL, add the appropiate Metamodes to your xorg.conf in section
Device and restart X:

    Option "Metamodes" "1680x1050,1680x1050; 1280x1024,1280x1024; 1680x1050,NULL; 1280x1024,NULL;"

Another method that may either work alone or in conjunction with those
mentioned above is starting games in a separate X server.

> Vertical sync using TwinView

If you're using TwinView and vertical sync (the "Sync to VBlank" option
in nvidia-settings), you will notice that only one screen is being
properly synced, unless you have two identical monitors. Although
nvidia-settings does offer an option to change which screen is being
synced (the "Sync to this display device" option), this does not always
work. A solution is to add the following environment variables at
startup:

    nano /etc/profile

Add to the end of the file:

    export __GL_SYNC_TO_VBLANK=1
    export __GL_SYNC_DISPLAY_DEVICE=DFP-0
    export __VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DFP-0

You can change DFP-0 with your preferred screen (DFP-0 is the DVI port
and CRT-0 is the VGA port).

> Old Xorg Settings

If upgrading from an old installation, please remove old /usr/X11R6/
paths as it can cause trouble during installation.

> Corrupted screen: "Six screens" issue

For some users using Geforce GT 100M's, the screen turns out corrupted
after X starts; divided into 6 sections with a resolution limited to
640x480. The same problem has been recently reported with Quadro 2000
and hi-res displays.

To solve this problem, enable the Validation Mode NoTotalSizeCheck in
section Device:

    Section "Device"
     ...
     Option "ModeValidation" "NoTotalSizeCheck"
     ...
    EndSection

> '/dev/nvidia0' Input/Output error

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: verify that the  
                           BIOS related suggestions 
                           work and are not         
                           coincidentally set while 
                           troubleshooting.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This error can occur for several different reasons, and the most common
solution given for this error is to check for group/file permissions,
which in almost every case is not the issue. The NVIDIA documentation
does not talk in detail on what you should do to correct this problem
but there are a few things that have worked for some people. The problem
can be a IRQ conflict with another device or bad routing by either the
kernel or your BIOS.

First thing to try is to remove other video devices such as video
capture cards and see if the problem goes away. If there are too many
video processors on the same system it can lead into the kernel being
unable to start them because of memory allocation problems with the
video controller. In particular on systems with low video memory this
can occur even if there is only one video processor. In such case you
should find out the amount of your system's video memory (e.g. with
lspci -v) and pass allocation parameters to the kernel, e.g.:

    vmalloc=64M
    or
    vmalloc=256M

If running a 64bit kernel, a driver defect can cause the nvidia module
to fail initializing when IOMMU is on. Turning it off in the BIOS has
been confirmed to work for some users. [2]User:Clickthem#nvidia module

Another thing to try is to change your BIOS IRQ routing from
Operating system controlled to BIOS controlled or the other way around.
The first one can be passed as a kernel parameter:

    PCI=biosirq

The noacpi kernel parameter has also been suggested as a solution but
since it disables ACPI completely it should be used with caution. Some
hardware are easily damaged by overheating.

Note:The kernel parameters can be passed either through the kernel
command line or the bootloader configuration file. See your bootloader
Wiki page for more information.

> '/dev/nvidiactl' errors

Trying to start an opengl application might result in errors such as:

    Error: Could not open /dev/nvidiactl because the permissions are too
    restrictive. Please see the FREQUENTLY ASKED QUESTIONS 
    section of /usr/share/doc/NVIDIA_GLX-1.0/README 
    for steps to correct.

Solve by adding the appropiate user to the video group and relogin:

    # gpasswd -a username video

> 32 bit applications do not start

Under 64 bit systems, installing lib32-nvidia-libgl that corresponds to
the same version installed for the 64 bit driver fixes the issue.

> Errors after updating the kernel

If a custom build of NVIDIA's module is used instead of the package from
[extra], a recompile is required every time the kernel is updated.
Rebooting is generally recommended after updating kernel and graphic
drivers.

> Crashing in general

-   Try disabling RenderAccel in xorg.conf.
-   If Xorg outputs an error about "conflicting memory type" or "failed
    to allocate primary buffer: out of memory", add nopat at the end of
    the kernel line in /boot/grub/menu.lst.
-   If the NVIDIA compiler complains about different versions of GCC
    between the current one and the one used for compiling the kernel,
    add in /etc/profile:

    export IGNORE_CC_MISMATCH=1

-   If Xorg is crashing with a "Signal 11" while using nvidia-96xx
    drivers, try disabling PAT. Pass the argument nopat to kernel
    parameters.

More information about troubleshooting the driver can be found in the
NVIDIA forums.

> Bad performance after installing a new driver version

If FPS have dropped in comparison with older drivers, first check if
direct rendering is turned on:

    $ glxinfo | grep direct

If the command prints:

    direct rendering: No

then that could be an indication for the sudden FPS drop.

A possible solution could be to regress to the previously installed
driver version and rebooting afterwards.

> CPU spikes with 400 series cards

If you are experiencing intermittent CPU spikes with a 400 series card,
it may be caused by PowerMizer constantly changing the GPU's clock
frequency. Switching PowerMizer's setting from Adaptive to Performance,
add the following to the Device section of your Xorg configuration:

     Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322; PowerMizerDefaultAC=0x1"

> Laptops: X hangs on login/out, worked around with Ctrl+Alt+Backspace

If while using the legacy NVIDIA drivers Xorg hangs on login and logout
(particularly with an odd screen split into two black and white/gray
pieces), but logging in is still possible via Ctrl-Alt-Backspace (or
whatever the new "kill X" keybind is), try adding this in
/etc/modprobe.d/modprobe.conf:

    options nvidia NVreg_Mobile=1

One user had luck with this instead, but it makes performance drop
significantly for others:

    options nvidia NVreg_DeviceFileUID=0 NVreg_DeviceFileGID=33 NVreg_DeviceFileMode=0660 NVreg_SoftEDIDs=0 NVreg_Mobile=1

Note that NVreg_Mobile needs to be changed according to the laptop:

-   1 for Dell laptops.
-   2 for non-Compal Toshiba laptops.
-   3 for other laptops.
-   4 for Compal Toshiba laptops.
-   5 for Gateway laptops.

See NVIDIA Driver's Readme:Appendix K for more information.

> Refresh rate not detected properly by XRandR dependant utilities

The XRandR X extension is not presently aware of multiple display
devices on a single X screen; it only sees the MetaMode bounding box,
which may contain one or more actual modes. This means that if multiple
MetaModes have the same bounding box, XRandR will not be able to
distinguish between them.

In order to support DynamicTwinView, the NVIDIA driver must make each
MetaMode appear to be unique to XRandR. Presently, the NVIDIA driver
accomplishes this by using the refresh rate as a unique identifier.

Use nvidia-settings -q RefreshRate to query the actual refresh rate on
each display device.

The XRandR extension is currently being redesigned by the X.Org
community, so the refresh rate workaround may be removed at some point
in the future.

This workaround can also be disabled by setting the DynamicTwinView X
configuration option to false, which will disable NV-CONTROL support for
manipulating MetaModes, but will cause the XRandR and XF86VidMode
visible refresh rate to be accurate.

> No screens found on a laptop / NVIDIA Optimus

On a laptop, if the NVIDIA driver cannot find any screens, you may have
an NVIDIA Optimus setup : an Intel chipset connected to the screen and
the video outputs, and a NVIDIA card that does all the hard work and
writes to the chipset's video memory.

Check if

    lspci | grep VGA

outputs something similar to

    00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0df4 (rev a1)

NVIDIA has announced plans to support Optimus in their Linux drivers at
some point in the future.

You need to install the Intel driver to handle the screens, then if you
want 3D software you should run them through Bumblebee to tell them to
use the NVIDIA card.

Possible Workaround

On my Lenovo W520 with a Quadro 1000M and Nvidia Optimus, I entered the
BIOS and changed my default graphics setting from 'Optimus' to
'Discrete' and the pacman Nvidia drivers(295.20-1 at time of writing)
recognized the screens.

Steps:

    -Enter BIOS
    -Find Graphics Settings(For me it's in the Config Tab, then Display submenu)
    -Change 'Graphics Device' to 'Discrete Graphics'(Disables Intel integrated graphics)
    -Change OS Detection for Nvidia Optimus to 'Disabled'
    -Save and Exit

> Screen(s) found, but none have a usable configuration

On a laptop, sometimes NVIDIA driver cannot find the active screen. It
may be caused because you own a graphic card with vga/tv outs. You
should examine Xorg.0.log to see what is wrong.

Another thing to try is adding invalid "ConnectedMonitor" Option to
Section "Device" to force Xorg throws error and shows you how correct
it. Here more about ConnectedMonitor setting.

After re-run X see Xorg.0.log to get valid CRT-x,DFP-x,TV-x values.

nvidia-xconfig --query-gpu-info could be helpful.

> No brightness control on laptops

Try to add the following line on 20-nvidia.conf

    Option "RegistryDwords" "EnableBrightnessControl=1"

If it still not working, you can try install nvidia-bl or nvidiabl.

> Black Bars while watching full screen flash videos with twinview

Follow the instructions presented here: link

> Backlight is not turning off in some occasions

By default, DPMS should turn off backlight with the timeouts set or by
running xset. However, probably due to a bug in the proprietary Nvidia
drivers the result is a blank screen with no powersaving whatsoever. To
workaround it, until the bug has been fixed you can use the vbetool as
root.

Install the vbetool package.

Turn off your screen on demand and then by pressing a random key
backlight turns on again:

    vbetool dpms off && read -n1; vbetool dpms on

Alternatively, xrandr is able to disable and re-enable monitor outputs
without requiring root.

    xrandr --output DP-1 --off; read -n1; xrandr --output DP-1 --auto

> Blue tint on videos with Flash

An issue with flashplugin versions 11.2.202.228-1 and 11.2.202.233-1
causes it to send the U/V panes in the incorrect order resulting in a
blue tint on certain videos. There are a few potential fixes for this
bug:

-   Install the latest libvdpau.
-   Patch vdpau_trace.so with this makepkg.
-   Right click on a video, select "Settings..." and uncheck "Enable
    hardware acceleration". Reload the page for it to take affect. Note
    that this disables GPU acceleration.
-   Downgrade the flashplugin package to version 11.1.102.63-1 at most.
-   Use google-chrome with the new Pepper API.
-   Try one of the few Flash alternatives.

The merits of each are discussed in this thread. To summarize: if you
want all flash sites (YouTube, Vimeo, etc) to work properly in
non-Chrome browsers, without feature regressions (such as losing
hardware acceleration), without crashes/instability (enabling hardware
decoding), without security concerns (multiple CVEs against older flash
versions) and without breaking the vdpau tracing library from its
intended purpose, the LEAST objectionable is to install
libvdpau-git-flashpatch.

> Bleeding overlay with Flash

This bug is due to the incorrect colour key being used by the
flashplugin version 11.2.202.228-1 and causes the flash content to
"leak" into other pages or solid black backgrounds. To avoid this issue
simply install the latest libvdpau or export VDPAU_NVIDIA_NO_OVERLAY=1
within either your shell profile (E.g. ~/.bash_profile or ~/.zprofile)
or ~/.xinitrc

> Full system freeze using flash

If you experience occasional full system freezes (only the mouse is
moving) using flashplugin and get

     # /var/log/errors.log
     NVRM: Xid (0000:01:00): 31, Ch 00000007, engmask 00000120, intr 10000000

a possible workaround is to switch off Hardware Acceleration in flash,
setting

    # /etc/adobe/mms.cfg
    EnableLinuxHWVideoDecode=0

> XOrg fails to Load or Red Screen of Death

If you get a red screen and use grub2 disable the grub2 framebuffer by
editing /etc/defaults/grub and uncomment GRUB_TERMINAL_OUTPUT. For more
information see Grub#Disable_framebuffer.

See also
--------

-   NVIDIA forums
-   Official readme for NVIDIA drivers

Retrieved from
"https://wiki.archlinux.org/index.php?title=NVIDIA&oldid=255349"

Categories:

-   Graphics
-   X Server
