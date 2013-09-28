Installation Guide
==================

This document will guide you through the process of installing Arch
Linux using the Arch Install Scripts. Before installing, you are advised
to skim over the FAQ.

The community-maintained Arch wiki is an excellent resource and should
be consulted for issues first. The IRC channel
(irc://irc.freenode.net/#archlinux), and the forums are also available
if the answer cannot be found elsewhere. Also, be sure to check out the
man pages for any command you are unfamiliar with; this can usually be
invoked with man command.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Download                                                           |
| -   2 Installation                                                       |
|     -   2.1 Keyboard layout                                              |
|     -   2.2 Partition disks                                              |
|     -   2.3 Format the partitions                                        |
|     -   2.4 Mount the partitions                                         |
|     -   2.5 Connect to the internet                                      |
|         -   2.5.1 Wireless                                               |
|                                                                          |
|     -   2.6 Install the base system                                      |
|     -   2.7 Install a bootloader                                         |
|         -   2.7.1 GRUB                                                   |
|         -   2.7.2 Syslinux                                               |
|                                                                          |
|     -   2.8 Configure the system                                         |
|     -   2.9 Unmount and reboot                                           |
|                                                                          |
| -   3 Post-installation                                                  |
|     -   3.1 User management                                              |
|     -   3.2 Package management                                           |
|     -   3.3 Service management                                           |
|     -   3.4 Sound                                                        |
|     -   3.5 Video driver                                                 |
|     -   3.6 Display server                                               |
|     -   3.7 Fonts                                                        |
|                                                                          |
| -   4 Appendix                                                           |
+--------------------------------------------------------------------------+

Download
--------

Download the new Arch Linux ISO from the Arch Linux download page.

-   A single image is provided which can be booted into an i686 and
    x86_64 live system to install Arch Linux over the network. Media
    containing the [core] repository are no longer provided.
-   Install images are signed and it is highly recommend to verify their
    signature before use. On Arch Linux, this can be done by using

        pacman-key -v <iso-file>.sig

-   The image can be burned to a CD, mounted as an ISO file, or directly
    written to a USB stick using a utility like dd. It is intended for
    new installations only; an existing Arch Linux system can always be
    updated with pacman -Syu.

Installation
------------

> Keyboard layout

For many countries and keyboard types appropriate keymaps are available
already, and a command like loadkeys uk might do what you want. More
available keymap files can be found in /usr/share/kbd/keymaps/ (you can
omit the keymap path and file extension when using loadkeys).

> Partition disks

See partitioning for details.

Remember to create any stacked block devices like LVM, LUKS, or RAID.

> Format the partitions

See File Systems for details.

If you are using (U)EFI you will most probably need another partition to
host the UEFI System partition. Read Create an UEFI System Partition in
Linux.

> Mount the partitions

We now must mount the root partition on /mnt. You should also create
directories for and mount any other partitions (/mnt/boot, /mnt/home,
...) if you want them to be detected by genfstab.

> Connect to the internet

A DHCP service is already enabled for all available devices. If you need
to setup a static IP or use management tools such as Netcfg, you should
stop this service first: systemctl stop dhcpcd.service. For more
information read configuring network.

Wireless

Run wifi-menu to set up your wireless network. For details, see Wireless
Setup and Netcfg.

> Install the base system

Before installing, you may want to edit /etc/pacman.d/mirrorlist such
that your preferred mirror is first. This copy of the mirrorlist will be
installed on your new system by pacstrap as well, so it's worth getting
it right.

Using the pacstrap script we install the base system.

    # pacstrap /mnt base

Other packages can be installed by appending their names to the above
command (space seperated), including the bootloader if you want.

> Install a bootloader

GRUB

-   For BIOS:

    # arch-chroot /mnt pacman -S grub-bios

-   For EFI (in rare cases you will need grub-efi-i386 instead):

    # arch-chroot /mnt pacman -S grub-efi-x86_64

Syslinux

    # arch-chroot /mnt pacman -S syslinux

> Configure the system

Generate an fstab with the following command (if you prefer to use UUIDs
or labels, add the -U or -L option, respectively):

    # genfstab -p /mnt >> /mnt/etc/fstab

Next we chroot into our newly installed system:

    # arch-chroot /mnt

-   Write your hostname to /etc/hostname.
-   Symlink /etc/localtime to /usr/share/zoneinfo/Zone/SubZone. Replace
    Zone and Subzone to your liking. For example:

    # ln -s /usr/share/zoneinfo/Europe/Athens /etc/localtime

-   Set locale preferences in /etc/locale.conf.
-   Add console keymap and font preferences in /etc/vconsole.conf
-   Uncomment the selected locale in /etc/locale.gen and generate it
    with locale-gen.
-   Configure /etc/mkinitcpio.conf as needed (see mkinitcpio) and create
    an initial RAM disk with:

    # mkinitcpio -p linux

-   Configure the bootloader. For GRUB, see GRUB installation and
    Configuration; for Syslinux, see Syslinux configuration.

-   Set a root password with passwd.

> Unmount and reboot

If you are still in the chroot environment type exit or press Ctrl+D in
order to exit. Earlier we mounted the partitions under /mnt. In this
step we will unmount them:

    # umount /mnt/{boot,home,}

Now reboot and then login into the new system with the root account.

Post-installation
-----------------

> User management

Add any user accounts you require as as described in User management. It
isn't good practice to use the root account for regular use, or expose
it via SSH on a server. The root account should only be used for
administrative tasks.

> Package management

See pacman and FAQ#Package Management for answers regarding installing,
updating, and managing packages.

> Service management

Arch Linux uses systemd as init, which is a system and service manager
for Linux. For maintaining your Arch Linux installation, it is a good
idea to learn the basics about it. Interaction with systemd is done
through the systemctl command. Read systemd#Basic systemctl usage for
more information.

> Sound

ALSA usually works out-of-the-box. It just needs to be unmuted. Install
alsa-utils (which contains alsamixer) and follow these instructions.

ALSA is included with the kernel and it is recommended. If it does not
work, OSS is a viable alternative. If you have advanced audio
requirements, take a look at Sound system for an overview of various
articles.

> Video driver

The Linux kernel includes open-source video drivers and support for
hardware accelerated framebuffers. However, userland support is required
for OpenGL and 2D acceleration in X11.

If you don't know which video chipset is available on your machine, run:

    $ lspci | grep VGA

For a complete list of open-source video drivers, search the package
database:

    $ pacman -Ss xf86-video | less

The vesa driver is a generic mode-setting driver that will work with
almost every GPU, but will not provide any 2D or 3D acceleration. If a
better driver cannot be found or fails to load, Xorg will fall back to
vesa. To install it:

    # pacman -S xf86-video-vesa

In order for video acceleration to work, and often to expose all the
modes that the GPU can set, a proper video driver is required:

Brand

Type

Driver

Multilib Package  
(for 32-bit applications on Arch x86_64)

Documentation

AMD/ATI

Open source

xf86-video-ati

lib32-ati-dri

ATI

Proprietary

catalyst-dkms

lib32-catalyst-utils

AMD Catalyst

Intel

Open source

xf86-video-intel

lib32-intel-dri

Intel Graphics

Nvidia

Open source

xf86-video-nouveau

lib32-nouveau-dri

Nouveau

xf86-video-nv

–

(legacy driver)

Proprietary

nvidia

lib32-nvidia-utils

NVIDIA

nvidia-304xx

lib32-nvidia-304xx-utils

> Display server

The X Window System (commonly X11, or X) is a networking and display
protocol which provides windowing on bitmap displays. It is the de-facto
standard for implementating graphical user interfaces. See the Xorg
article for details.

Wayland is a new display server protocol and the Weston reference
implementation is available. There is very little support for it from
applications at this early stage of development.

> Fonts

You may wish to install a set of TrueType fonts, as only unscalable
bitmap fonts are included by default. DejaVu is a set of high quality,
general-purpose fonts with good Unicode coverage:

    # pacman -S ttf-dejavu

Refer to Font Configuration for how to configure font rendering and
Fonts for font suggestions and installation instructions.

Appendix
--------

For a list of applications that may be of interest, see List of
Applications.

See General Recommendations for post-installation tutorials like setting
up a touchpad or font rendering.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installation_Guide&oldid=255961"

Categories:

-   About Arch
-   Getting and installing Arch
