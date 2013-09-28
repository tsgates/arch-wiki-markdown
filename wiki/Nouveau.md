Nouveau
=======

Summary

This article details the installation of the Nouveau Open Source 3D
acceleration graphics driver for NVIDIA cards. The name of the project
refers to the fact that "nouveau" means "new" in French.

Related

NVIDIA

Xorg

This article covers installing and configuring the Nouveau open source
driver for NVIDIA graphic cards. For information about the official
proprietary driver, see NVIDIA.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Coming from the proprietary NVIDIA driver                          |
| -   2 Installation                                                       |
| -   3 Loading                                                            |
|     -   3.1 KMS                                                          |
|         -   3.1.1 Late start                                             |
|         -   3.1.2 Early start                                            |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Keep NVIDIA driver installed                                 |
|     -   4.2 Installing the latest development packages                   |
|     -   4.3 Tear-free compositing                                        |
|     -   4.4 Dual Head                                                    |
|     -   4.5 Setting console resolution                                   |
|     -   4.6 Power Management                                             |
|     -   4.7 Enable MSI (Message Signaled Interrupts)                     |
|                                                                          |
| -   5 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Coming from the proprietary NVIDIA driver
-----------------------------------------

Note:This section is only for people who have the proprietary NVIDIA
driver installed. It can be skipped by all other users.

Tip:If you want to keep Nvidia driver installed, it requires some
configuration to load the Nouveau driver instead of Nvidia.

If you already installed the proprietary Nvidia driver, then remove it
first:

    # pacman -Rdds nvidia nvidia-utils
    # pacman -S --asdeps libgl

Be sure to also delete the /etc/X11/xorg.conf file that the Nvidia
driver created (or undo the changes), or else X will fail to properly
load the Nouveau driver.

Installation
------------

Before proceeding, have a look at the HardwareStatus to see what
features are supported for a given architecture, and the list of
codenames to determine the card's category. You could also consult
Wikipedia for an even more detailed list. Also make sure you have Xorg
properly installed.

Install the DDX driver with the xf86-video-nouveau package, which is
available in the official repositories. It pulls in nouveau-dri as a
dependency, providing the DRI driver for 3D acceleration.

For 32-bit 3D support on x86_64, install lib32-nouveau-dri from the
multilib repository.

Note:See the Nouveau MesaDrivers page before reporting bugs with the 3D
drivers.

Loading
-------

The Nouveau kernel module should load fine automatically on system boot.

If it does not happen, then:

-   Make sure you do not have nomodeset or vga= as a kernel parameter,
    since Nouveau needs kernel mode-setting in order to run successfully
    (see below).
-   Also, check that you have not disabled Nouveau by using any modprobe
    blacklisting within /etc/modprobe.d/.

> KMS

Tip:If you have problems with the resolution, check this page.

Kernel Mode Setting (KMS) is required by the Nouveau driver. As the
system boots, the resolution will likely change when KMS initializes the
display driver. Simply installing the Nouveau driver should be enough to
get the system to recognize and initialize it in "Late start" mode (see
below). See the Nouveau KernelModeSetting page for more details.

Note:Users may prefer the early start method as it does not cause the
annoying resolution change part way through the boot process.

Late start

This method will start the KMS after the other kernel modules are
loaded. You will see the text "Loading modules" and the size of the text
may change, possibly with an undesirable flicker.

Early start

This method will start the KMS as early as possible in the boot process,
when the initramfs is loaded.

To do this, add nouveau to the MODULES array in /etc/mkinitcpio.conf:

    MODULES="... nouveau ..."

If you are using a custom EDID file, you should embed it into initramfs
as well:

    /etc/mkinitcpio.conf

    FILES="/lib/firmware/edid/your_edid.bin"

Re-generate the initial ramdisk image:

    # mkinitcpio -p <kernel preset; e.g. linux>

If you're experiencing troubles with Nouveau leading to rebuild
nouveau-drm several times for testing purposes, do not add nouveau to
the initramfs. It is too easy to forget to rebuild the initramfs and it
will just make any testing harder. Just use "Late start" until you are
confident the system is stable. There might be additional problems with
initramfs if you need a custom firmware (generally not advised).

Tips and tricks
---------------

> Keep NVIDIA driver installed

If you want to keep the proprietary NVIDIA driver installed, but want to
use the Nouveau driver, comment out nouveau blacklisting in
/etc/modprobe.d/nouveau_blacklist.conf modifying it as follows:

    #blacklist nouveau

And tell Xorg to load nouveau instead of nvidia by creating the file
/etc/X11/xorg.conf.d/20-nouveau.conf with the following content:

    Section "Device"
        Identifier "Nvidia card"
        Driver "nouveau"
    EndSection

Tip:You can use these scripts if you are switching between open and
closed drivers often.

If you already used the NVIDIA driver, and want to test Nouveau without
reboot, make sure the 'nvidia' module is no longer loaded:

    # rmmod nvidia

Then load the 'nouveau' module:

    # modprobe nouveau

And check that it loaded fine by looking at kernel messages:

    $ dmesg

> Installing the latest development packages

You may install the latest -git packages, through AUR:

-   You can use mesa-git which will allow the installation of the latest
    Mesa (including the latest DRI driver).
-   You can use xf86-video-nouveau-git which will allow the installation
    of the latest DDX driver.
-   You can also try installing a newer kernel version, through packages
    like linux-mainline in which the Nouveau DRM code would allow better
    performance.
-   To get the latest Nouveau improvements, you should use the linux-git
    package from the AUR, edit the PKGBUILD and use Nouveau's own kernel
    repository, which is currently located at:
    git://anongit.freedesktop.org/nouveau/linux-2.6.

Upsteam driver sources can be found at the Nouveau Source page.

> Tear-free compositing

Edit your /etc/X11/xorg.conf.d/20-nouveau.conf, and add the following to
the Device section:

    Section "Device"
        Identifier "nvidia card"
        Driver "nouveau"
        Option "GLXVBlank" "true"
    EndSection

> Dual Head

Nouveau supports the xrandr extension for modesetting and multiple
monitors. See the RandR12 page for tutorials.

Here is a full sample /etc/X11/xorg.conf.d/20-nouveau.conf above for
running 2 monitors in dual head mode. You may prefer to use a graphical
tool to configure monitors like GNOME Control Center's Display panel
(gnome-control-center display).

    # the right one
    Section "Monitor"
              Identifier   "NEC"
              Option "PreferredMode" "1280x1024_60.00"
    EndSection

    # the left one
    Section "Monitor"
              Identifier   "FUS"
              Option "PreferredMode" "1280x1024_60.00"
              Option "LeftOf" "NEC"
    EndSection

    Section "Device"
        Identifier "nvidia card"
        Driver "nouveau"
        Option  "Monitor-DVI-I-1" "NEC"
        Option  "Monitor-DVI-I-2" "FUS"
    EndSection

    Section "Screen"
        Identifier "screen1"
       Monitor "NEC"
        DefaultDepth 24
          SubSection "Display"
           Depth      24
           Virtual 2560 2048
          EndSubSection
        Device "nvidia card"
    EndSection

    Section "ServerLayout"
        Identifier "layout1"
        Screen "screen1"
    EndSection

> Setting console resolution

Use the fbset tool to adjust console resolution.

You can also pass the resolution to nouveau with the video= kernel line
option (see KMS).

> Power Management

GPU Scaling is in various stages of readiness depending on the GPU. See
the Nouveau PowerManagement page for more details.

> Enable MSI (Message Signaled Interrupts)

This may provide a slight performance advantage. It is only supported on
NV50+ and is disabled by default.

Warning:This may cause instability with some motherboard / GPU
combinations.

Place the following in /etc/modprobe.d/nouveau.conf:

    options nouveau msi=1

If using early start, add the line FILES="/etc/modprobe.d/nouveau.conf"
to /etc/mkinitcpio.conf, then re-generate kernel image:

    # mkinitcpio -p <kernel preset; e.g. linux>

Reboot the system for the changes to take effect.

Troubleshooting
---------------

Add the following to your kernel command line (if using grub hit e at
the boot menu to edit) to turn on video debugging:

    drm.debug=14 log_buf_len=16M

Create verbose Xorg log:

    startx -- -logverbose 9 -verbose 9

View loaded video module parameters and values:

    modinfo -p video

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nouveau&oldid=252291"

Categories:

-   Graphics
-   X Server
