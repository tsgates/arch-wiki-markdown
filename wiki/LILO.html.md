LILO
====

Related articles

-   Arch Boot Process
-   Boot Loaders

The LInux LOader, or LILO for short, is a legacy multi-boot loader for
Linux systems. In spite of being the standard choice over the course of
several years, it has been slowly phased out thanks to the advent of
GRUB, an alternative boot loader offering easier configuration and less
chance of rendering systems unbootable. However, many users still prefer
the simplicity of LILO and it continues to be actively developed.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Sample setup
    -   2.2 Using an image as background
-   3 Troubleshooting
    -   3.1 Read write error message whilst booting
    -   3.2 Devmapper not found error message after kernel upgrade
-   4 See also

Installation
------------

LILO is available as lilo and lilo-git (the development version) from
the AUR. LILO only works on BIOS systems. ELILO is a version of LILO for
UEFI systems and it can be installed from the elilo-efi package in the
AUR.

Running the command lilo (as root) will install LILO to the MBR. Before
running the lilo command you should edit /etc/lilo.conf to ensure that
the root entry points towards the root partition. If your root partition
is on /dev/sda1 then the root entry should look like this:
root=/dev/sda1. Remember to change the root line for both the 'arch' and
the 'arch-fallback' entries.

Configuration
-------------

LILO is configured by editing the /etc/lilo.conf file and running lilo
afterwards to apply the new configuration.

As a reminder, consider that LILO needs to be run after every kernel
upgrade, otherwise the system is likely to be left in an unbootable
state.

More help on setting up LILO can be found in the LILO-mini-HOWTO.

> Sample setup

A typical LILO setup:

Tip:If LILO is really slow while loading the bzImage, try adding compact
to /etc/lilo.conf's global section, as shown below.

    /etc/lilo.conf

    #
    # /etc/lilo.conf
    #

    boot=/dev/hda
    # This line often fixes L40 errors on bootup
    # disk=/dev/hda bios=0x80

    default=Arch
    timeout=100
    lba32
    prompt
    compact

    image=/boot/vmlinuz-linux
            label=Arch
    	append="devfs=nomount"
    	vga=788
            root=/dev/hda2
            read-only

    image=/boot/vmlinuz-linux
            label=ArchRescue
            root=/dev/hda8
            read-only

    other=/dev/hda1
            label=Windows

    # End of file

You can use hwinfo --framebuffer to determine what vga modes you can
use.

> Using an image as background

First prepare the background image:

-   Open it in GIMP.
-   Scale it to 640x480.
-   Change it to indexed mode (Image-->Mode-->indexed).
-   Select "Create optimal palette" and set it to 16 colours. Choose
    whatever dithering method suits you.
-   Open the "Indexed Palette" dialog. Make note of which colours you
    want to use for menu text entries, the clock, etc. In your
    lilo.conf, you refer to the colours by index.
-   Export the image as a bmp in your /boot directory. In Export dialog
    check option "Do not write color space information"

Now edit lilo.conf. There are a few options that can be set for your
graphical menu. See man lilo.conf for more information.

-   bitmap=<bitmap-file> Set this to the file that you saved above.
-   bmp-colors=<fg>,<bg>,<sh>,<hfg>,<hbg>,<hsh>

These are the colours of the entries in the menu. They refer to the
foreground, background, and shadow colours respectively, followed by the
same for highlighted text. Do not use spaces. The values used are
indices into the colour palette that you discovered in the previous
step. If you choose, you can leave a value blank (but do not forget the
comma). The default background is transparent, the default shadow is to
have none.

-   bmp-table=<x>,<y>,<ncol>,<nrow>,<xsep>,<spill> This option specifies
    where the menu is placed. x and y are the character coordinates. You
    can also suffix them with a p to specify pixel coordinates.
-   bmp-timer=<x>,<y>,<fg>,<bg>,<sh> This option specifies the
    coordinates and colour of the timer that counts down the timeout
    before booting a default entry. It uses colour indices for the
    colours, and character (or pixel) coordinates.

For example:

    bitmap=/boot/arch-lilo.bmp
    bmp-colors=1,0,8,3,8,1
    bmp-table=250p,150p,1,18
    bmp-timer=250p,350p,3,8,1

Save lilo.conf, run lilo as root, and reboot and see how it looks!

Troubleshooting
---------------

> Read write error message whilst booting

This error message is caused by a recent change in mkinitcpio which was
in response to this Systemd commit. The change causes partitions to be
fsck'ed twice when mounted read only. To fix this error edit
/etc/lilo.conf and change the 'read only' line to 'read write' for both
arch entries.

See this forum thread (post 6 in particular) for more information.

> Devmapper not found error message after kernel upgrade

It is possible that running the lilo command after a kernel upgrade
results in a devmapper not found error. If this is the case run
modprobe dm-mod before running lilo after a kernel upgrade.

See also
--------

-   List of kernel parameters that can be used at boot time
-   List of kernel paramaters with further explanation and grouped by
    like options ('Kernel Boot Command-Line Parameter Reference', Linux
    Kernel In A Nutshell)

Retrieved from
"https://wiki.archlinux.org/index.php?title=LILO&oldid=300510"

Category:

-   Boot loaders

-   This page was last modified on 23 February 2014, at 15:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
