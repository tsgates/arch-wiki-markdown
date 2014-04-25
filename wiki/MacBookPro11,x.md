MacBookPro11,x
==============

Summary help replacing me

This wiki page should help you in getting your MacBook Pro(Late 2013) to
work with Arch Linux.

> Related

Installation guide

Beginners' guide

General Recommendations

MacBookPro10,x

MacBook

Contents
--------

-   1 Preparing for the Installation
    -   1.1 Preparing the hard drive
-   2 Installation
    -   2.1 Booting the live image
    -   2.2 Internet
        -   2.2.1 Wireless
    -   2.3 The installation
    -   2.4 Bootloader
        -   2.4.1 Using the MacBook's native EFI bootloader
        -   2.4.2 Direct EFI booting (rEFInd)
        -   2.4.3 GRUB (with OS X)
-   3 Post installation
    -   3.1 Console
    -   3.2 Graphics
        -   3.2.1 Getting the integrated intel card to work on 11,3
    -   3.3 Sound
    -   3.4 Touchpad
    -   3.5 Keyboard backlight
    -   3.6 Screen backlight
    -   3.7 Suspend
-   4 What does not work
    -   4.1 General
    -   4.2 Wi-Fi
    -   4.3 Web cam
-   5 Discussions
-   6 See also

Preparing for the Installation
------------------------------

> Preparing the hard drive

Assuming you want to dual boot with OS X, so you can update firmware,
you have to shrink its partition with Disk Utility. You can either
create a HFS+ partition now to override later, or leave it empty.

Installation
------------

> Booting the live image

Now, download the latest Archboot ISO, write it to USB, and boot from it
by selecting it in the Apple boot loader by holding Alt on boot (use
rEFIt if you cannot manage to select it). If you are using a kernel
before 3.13 when it comes to the syslinux boot loader, press Tab to edit
the entry and append nomodeset to fix screen corruption, do not use
nomodeset for kernel 3.13 and above, it is not needed anymore (and it
will break vaapi).

> Internet

Note:You can skip this if you use the Thunderbolt or USB-to-Ethernet
adapter for the installation.

Wireless

As mentioned below, broadcom-wl is sufficient if you are using the Linux
mainline kernel. For custom kernels, you need to use broadcom-wl-dkms.
Both are available from the AUR. The easiest way to get Wi-Fi
connectivity during install is to build the package driver on a separate
system using:

    $ curl -O https://aur.archlinux.org/packages/br/broadcom-wl-dkms/broadcom-wl-dkms.tar.gz
    $ tar -zxvf broadcom-wl-dkms.tar.gz
    $ cd broadcom-wl-dkms
    $ makepkg -s

This will give you a package (broadcom-wl-*.pkg.tar.xz) which can be
installed using pacman. Put this package on a USB drive, mount it, and
install the package using

    # pacman -U broadcom-wl-*.pkg.tar.xz
    # modprobe wl

during install. You may now use wifi-menu to connect to your network of
choice.

Note:You need to repeat this process when you have finished your
installation, for instance when booting into the system for the first
time or when you have chrooted your install.

> The installation

Note:Refer to the MacBook page if you do not want to have a separate
partition for GRUB but rather prefer to use rEFInd (or rEFIt).

Run the installation wizard.

Tip:If you want to use the native MacBook bootloader, you need an extra
partition of at least 128 MiB.

> Bootloader

Using the MacBook's native EFI bootloader

This method uses the MacBook's native EFI bootloader, i.e. the one the
can be reached when holding the alt-key during boot.

Note:For this method you need an extra partition of at least 128 MiB.
This partition will be used by the MacBook's native bootloader to launch
Arch. It also assumes that you are dual-booting OS X and Arch.

At the end of the install process we would normally install GRUB or a
variation the the drive. For this method we will place a boot.efi file
on an extra partition used by the MacBook's native bootloader.

First, install the grub package from the official repositories.

When generating a boot.efi file, GRUB looks to /etc/default/grub for its
configuration. Edit the parameter GRUB_CMDLINE_LINUX_DEFAULT to look
something like this:


    GRUB_CMDLINE_LINUX_DEFAULT="quiet rootflags=data=writeback libata.force=noncq"

The libata.force=noncq parameter will prevent SSD lockups and the
rootflags option is used for SSD-performance.

Note:Do not use the rootflags option on Btrfs. It is not supported.

Now we generate the boot.efi file:

    # grub-mkconfig -o /boot/grub/grub.cfg
    # grub-mkstandalone -o boot.efi -d /usr/lib/grub/x86_64-efi -O x86_64-efi /boot/grub/grub.cfg

Put this file on a USB (or other OS X accessible media) and reboot into
OS X.

Launch DiskUtility.app and erase the extra partition, mentioned above,
to HFS+ and mount it.

    $ mkdir -p <Path to root of extra partition>/System/Library/CoreServices
    $ mkdir <Parth to root of extra partition>/mach_kernel

Copy the boot.efi file to the
<Path to extra partition>/System/Library/CoreServices/ directory. Using
your editor of choice, create a SystemVersion.plist file in the
CoreServices directory, which is located here:

    <path to extra partition>/System/Library/CoreServices/SystemVersion.plist

Edit that file to look like this:


    <xml version="1.0" encoding="utf-8"?>
    <plist version="1.0">
    <dict>
        <key>ProductBuildVersion</key>
        <string></string>
        <key>ProductName</key>
        <string>Linux</string>
        <key>ProductVersion</key>
        <string>Arch Linux</string>
    </dict>
    </plist>

The last step is then to bless the extra partition using:

    # bless --device disk0sX --setBoot

Where disk0sX is the extra partitions id. The id can be found using
either DiskUtility.app or by issuing:

    # diskutil list

Note:In order to change grub settings both grub.cfg and boot.efi will
have to be generated. This can be done without booting OS X.

Generate grub.cfg and boot.efi from Arch Linux:

    # grub-mkconfig -o /boot/grub/grub.cfg
    # mount -t hfsplus -o force,rw /dev/sdXY /mnt # mount the HFS+ partition
    # grub-mkstandalone -o /mnt/System/Library/CoreServices/boot.efi -d /usr/lib/grub/x86_64-efi -O x86_64-efi /boot/grub/grub.cfg

Direct EFI booting (rEFInd)

See: UEFI_Bootloaders

As of August 2013, refind can automatically detect the Arch kernel,
removing the need for copying the kernel into the EFI partition. Simply
install refind without the EFI file system drivers [1] using the
--nodrivers option [2], and enable the scan_all_linux_kernels and
also_scan_dirs options in refind.conf (see link above for
instructions.).

An alternative way is to omit all the scans and put the following
bootentry at the end of your "refind.conf":

    menuentry "Arch" {
      icon EFI/refind/icons/os_arch.icns 
      volume <Volume label>
      ostype Linux
      loader /boot/vmlinuz-linux
      initrd /boot/initramfs-linux.img
      options "rw root=/dev/<arch partition> rootfstype=<filesystem type> libata.force=noncq"
    }

Don't forget to replace the angle brackets with your data.

GRUB (with OS X)

Another solution is to install GRUB. Edit
/tmp/install/boot/grub/grub.cfg and edit the boot entry to load Linux
mainline instead of the normal one.

Note:libata.force=noncq helps with hangs due to SSD speed.

Now cd into /tmp/install/ and create the GRUB image by running:

    grub-mkstandalone -o bootx64.efi -d usr/lib/grub/x86_64-efi -O x86_64-efi -C xz boot/grub/grub.cfg

This will create file called boot64.efi which contains GRUB and the
configuration file incorporated inside. It is important to cd into the
right directory to make it pick up the configuration file and put it
into the right place within the image.

Copy this file to the MacBook's EFI partition. The downside of this
method is that you need to repeat this step whenever you want to change
the GRUB config. Reboot the machine and you should be able to select
your installed Arch Linux by keeping the Alt button pressed. It should
appear as EFI boot.

To generate a nicer config use: grub-mkconfig, remove quiet if you like
the text, then to update your GRUB post-installation, do this to make
the GRUB EFI file and put it in the EFI partition:

    cd /
    grub-mkstandalone -o bootx64.efi -d usr/lib/grub/x86_64-efi -O x86_64-efi -C xz boot/grub/grub.cfg
    sudo mount /dev/sda1 /mnt
    sudo cp bootx64.efi /mnt/EFI/boot/bootx64.efi

Note:You'll need hfsprogs to run the above commands

Post installation
-----------------

> Console

Largest console font (although ugly) achieved by adding FONT=sun12x22 to
/etc/vconsole.conf It is still tiny but is at least readable.

> Graphics

MacBook Pro 11,1

-   Intel works on 3.12 with nomodeset
-   Intel works from 3.13.4-1-ARCH

MacBook Pro 11,2

-   Intel works from 3.13.4-1-ARCH

MacBook Pro 11,3

-   Nvidia works (both 319.60 and 331.17 drivers)
    -   Follow
        http://cberner.com/2013/03/01/installing-ubuntu-13-04-on-macbook-pro-retina/
-   Intel works after patching grub, see below

See HiDPI for information on how to tweak the system for a Retina
screen.

If you are using Xfce, you will probably experience tearing in Firefox,
VLC, etc. Until newer versions of xfwm support OpenGL rendering, use
another compositing window manager like compton with backend = "glx".

Getting the integrated intel card to work on 11,3

By default the integrated card is powered off. To fix this we need a
grub function called "apple_set_os". This function hasn't oficially been
merged yet, so we need to build grub ourselves. Download the grub-git
package from the AUR. Using something like:

    $ packer -G grub-git
    $ cd grub-git

Get the patch from here:
http://lists.gnu.org/archive/html/grub-devel/2013-12/msg00442.html

Put the patch contents into a file labeled something like "apple.patch"

Add this patch to your PKGBUILD and run:

    $ makepkg -si

Reboot into OS X and download gfxCardStatus v2.2.1 (newer versions do
not work properly) run the app and specify the integrated card.

Reboot and at the grub prompt typ 'c' to get into console, followed by
"apple_set_os" at the prompt.

You should now be able to install xf86-video-intel and get your card
running.

Note that the HDMI port and MiniDP are soldered to the nvidia card
meaning that to run external displays you need to use the dedicated
card.

> Sound

-   Headphones work
-   Speakers work from kernel 3.13 and 3.12.2. 3.12.1 only with patch
    -   Patch: https://bugzilla.kernel.org/attachment.cgi?id=114081.
    -   See discussion here:
        https://bugzilla.kernel.org/show_bug.cgi?id=64401
-   Optical audio can be turned off and on with above sound patch.

If you do not want to hear the annoying sound at system start-up, one
way to get rid of it is to turn sound off while under Mac OS.

Volume keys can be made to work with xfce4-volumed (if you are using
Xfce).

Also, if you are using PulseAudio, sometimes it thinks HDMI is the
default sound card; to solve this problem, install pavucontrol and set
Analog Stereo as the fallback device.

> Touchpad

One method is to install xf86-input-synaptics and configure to your
liking in /etc/X11/xorg.conf.d/50-synaptics.conf:

    Section "InputClass"
        MatchIsTouchpad "on"
        Identifier      "touchpad catchall"
        Driver          "synaptics"
        # 1 = left, 2 = right, 3 = middle
        Option          "TapButton1" "1"  
        Option          "TapButton2" "3"
        Option          "TapButton3" "2"
        # Palm detection
        Option          "PalmDetect" "1"
        # Horizontal scrolling
        Option "HorizTwoFingerScroll" "1"
        # Natural Scrolling (and speed)
        Option "VertScrollDelta" "-100"
        Option "HorizScrollDelta" "-100"
    EndSection

> Keyboard backlight

-   Works, see MacBook#Keyboard_Backlight

> Screen backlight

-   Intel, works on Linux 3.13
-   Framebuffer, works for MacBook Pro 11,1 and 11,3 via
    /sys/class/backlight/gmux_backlight/brightness.
-   Nvidia, does not work

Note:If the screen doesn't show the prompt or the login manager (i.e. a
black screen), append i915.invert_brightness=1 to the kernel.

> Suspend

-   Works on MacBook Pro 11,2 with Linux 3.13
-   No backlight after suspend with Linux 3.12
    -   Use hibernate instead

What does not work
------------------

Updated 2013-12-07

> General

> Wi-Fi

-   broadcom-wl from the AUR works
    -   Stability is an issue for some

> Web cam

-   Listed on PCI bus as: Multimedia controller: Broadcom Corporation
    Device 1570.
-   In OS X, the camera is listed as FaceTime HD camera 1570.
-   No known Linux driver.

Discussions
-----------

-   https://bbs.archlinux.org/viewtopic.php?id=171883

See also
--------

-   MacBookPro10,x
-   MacBook

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBookPro11,x&oldid=305720"

Category:

-   Apple

-   This page was last modified on 20 March 2014, at 01:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
