Uswsusp
=======

Related articles

-   Suspending to RAM with hibernate-script
-   Suspending to Disk with hibernate-script
-   Pm-utils
-   TuxOnIce

uswsusp (userspace software suspend) is a set of user space tools used
for hibernation (suspend-to-disk) and suspend (suspend-to-RAM or
standby) on Linux systems. It consists of:

-   s2ram - a wrapper around the kernel's suspend-to-RAM mechanism
    allowing the user to perform some graphics adapter manipulations
    from the user land before suspending and after resuming that may
    help to bring the graphics (and the entire system) back to life
    after the resume. Incorporates the functionality of vbetool and
    radeontool as well as some tricks of its own. Includes a list of
    working hardware configurations along with the appropriate sets of
    operations to be performed to resume them successfully. This is
    accomplished by a hardware whitelist maintained by HAL - s2ram
    translates the HAL database options into s2ram parameters.

Note:Since HAL is deprecated and KMS drivers can save the state of the
grahic card directly without userspace quirks, s2ram development is
discontinued and no further whitelist entries are accepted. If a KMS
driver is in use, s2ram will directly suspend the machine.

-   s2disk - the reference implementation of the userspace software
    suspend (µswsusp); it coordinates the steps necessary to suspend the
    system (such as freezing the processes, preparing the swap space,
    etc.) and handles image writing and reading. s2disk already supports
    compression and encryption of the image and other features (e.g. a
    nice progress bar, saving the image on a remote disk, playing tetris
    while resuming, etc.) can be easily added.

-   s2both - combines the funtionalities of s2ram and s2disk and it's
    very useful when the battery is almost depleted. s2both writes the
    system snapshot to the swap (just like s2disk) but then puts the
    machine into STR (just like s2ram). If the battery has enough power
    left you can quickly resume from STR, otherwise you can still resume
    from disk without losing your work.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Support for encryption
    -   2.2 Recreate initramfs
    -   2.3 Sample config
-   3 Usage
    -   3.1 Standalone
    -   3.2 With pm-utils
    -   3.3 With systemd
-   4 Troubleshooting
    -   4.1 My machine is not whitelisted
    -   4.2 s2ram -f doesn't work
    -   4.3 s2ram does not work with any combination of options
-   5 See also

Installation
------------

uswsusp is available in the AUR under the name uswsusp-git.

Configuration
-------------

You must edit /etc/suspend.conf before attempting to suspend to disk.

-   If using a swap partition:

    resume device = /dev/disk/by-label/swap

where /dev/disk/by-label/swap must be replaced with the correct block
device containing the swap partition.

-   If using a swap file:

    resume device = /dev/sdXN  # the partition which contains swapfile 
    resume offset = 123456

where 123456 is the offset from the beginning of the resume device where
the swap file's header is located. The resume offset can be obtained by
running

    # swap-offset your-swap-file

-   The image size parameter (optional) can be used to limit the size of
    the system snapshot image created by s2disk. If it's not possible to
    create an image of the desired size, s2disk will suspend anyway,
    using a bigger image. If image size is set to 0, the image will be
    as small as possible.

-   The shutdown method parameter (optional) specifies the operation
    that will be carried out when the machine is ready to be powered
    off. If set to "reboot" the machine will be rebooted immediately. If
    set to "platform" the machine will be shut down using special power
    management operations available from the kernel that may be
    necessary for the hardware to be properly reinitialized after the
    resume, and may cause the system to resume faster.

-   If the compute checksum parameter is set to 'y', the s2disk and
    resume tools will use the MD5 algorithm to verify the image
    integrity.

-   If the compress parameter is set to 'y', the s2disk and resume tools
    will use the LZF compression algorithm to compress/decompress the
    image.

-   If splash is set to 'y', s2disk and/or resume will use a splash
    system. Currently splashy and fbsplash are supported.
    Note:This requires additional configure flags for uswsusp
    (--enable-splashy and --enable-fbsplash, respectively).

-   The resume pause option will introduce a delay after successfully
    resuming from hibernation, in order to allow the user to read the
    stats (read and write speed, image size, etc.)

-   If threads is enabled, s2disk will use several threads for
    compressing, encrypting and writing the image. This is supposed to
    speed things up. For details, read the comments in suspend.c

> Support for encryption

-   generate a key with the suspend-keygen utility included in the
    package;
-   write the name of the key in /etc/suspend.conf;

    encrypt = y
    RSA key file = <path_to_keyfile>

> Recreate initramfs

Note:Whenever you modify /etc/suspend.conf, you will need to rebuild
your initramfs. If you fail to do so, and linux cannot find your image
at startup, you will not see an error message indicating this. Your boot
process will hang after starting the uresume hook, typically after the
message with the libgcrypt version.

Edit your /etc/mkinitcpio.conf file and add "uresume" to the HOOKS
entry.

    HOOKS="base udev autodetect block uresume filesystems"

-   rebuild the ramdisk

    # mkinitcpio -p linux

> Sample config

    /etc/suspend.conf

    snapshot device = /dev/snapshot

    resume device = /dev/disk/by-label/swap

    # image size is in bytes
    image size = 1468006400

    #suspend loglevel = 2

    compute checksum = y

    compress = y

    #encrypt = y

    #early writeout = y

    #splash = y

    # up to 60 (seconds)
    #resume pause = 30  

    threads = y

Usage
-----

> Standalone

To suspend to disk, run:

    # s2disk

To suspend to ram, first run:

    # s2ram --test

to see if your machine is in the database of machines known to work. If
it returns something like "Machine matched entry xyz" then go ahead and
run:

    # s2ram

Otherwise, the --force parameter will be necessary, possibly combined
with other parameters (see s2ram --help). It may fail.

Now you could try to suspend directly calling s2disk from the command
line:

    # s2disk

It is probably necessary to resort to a userspace tool which calls
internally s2disk, like Pm-utils or hibernate-script. See Suspending to
Disk with hibernate-script about details for defining the ususpend-disk
method as default.

> With pm-utils

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Since February   
                           2013, the suspend and    
                           hibernate functions in   
                           UPower have been         
                           deprecated. (Discuss)    
  ------------------------ ------------------------ ------------------------

Pm-utils can utilise several sleep back-ends, including uswsusp. Create
or edit /etc/pm/config.d/module:

    SLEEP_MODULE=uswsusp

This way, pm-suspend and pm-hibernate will use uswsusp. There is an
advantage to this: regular users can use these commands to suspend with
uswsusp:

    $ dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend

    $ dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate

Note:The user's window manager or desktop environment needs to be
started either with a login manager like gdm or kdm. Also, upower needs
to be installed.

> With systemd

To to put your system into hibernation a.k.a Suspend to Disk with
systemctl hibernate, do:

    # cp /usr/lib/systemd/system/systemd-hibernate.service /etc/systemd/system/
    # cd /etc/systemd/system/

Open systemd-hibernate.service with your preferred text editor and edit
the line from this:

    /etc/systemd/system/systemd-hibernate.service

    ...
    ExecStart=/usr/lib/systemd/systemd-sleep hibernate

to this:

    /etc/systemd/system/systemd-hibernate.service

    ...
    ExecStart=/bin/sh -c 's2disk && run-parts --regex .\* -a post /usr/lib/systemd/system-sleep'

After that, execute systemctl hibernate to put your system into
hibernation. Do similar changes for systemd-hybrid-sleep.service to
enable uswsusp-based hybrid sleep too.

Troubleshooting
---------------

> My machine is not whitelisted

If s2ram doesn't match your machine to an entry in its whitelist, it
will output some general purpose identification strings for your machine
(the same as those provided s2ram -i). In this case, you may try to
force s2ram to suspend your machine by using s2ram -f.

> s2ram -f doesn't work

If s2ram -f doesn't work, try the different workarounds offered by
s2ram. Run s2ram -h to get a list of the possible options:

    # s2ram -h

    Usage: s2ram [-nhi] [-fspmrav]

    Options:
        -h, --help:       this text.
        -n, --test:       test if the machine is in the database.
                          returns 0 if known and supported
        -i, --identify:   prints a string that identifies the machine.
        -f, --force:      force suspending, even on unknown machines.

    The following options are only available with -f/--force:
        -s, --vbe_save:   save VBE state before suspending and restore after resume.
        -p, --vbe_post:   VBE POST the graphics card after resume
        -m, --vbe_mode:   get VBE mode before suspend and set it after resume
        -r, --radeontool: turn off the backlight on radeons before suspending.
        -a, --acpi_sleep: set the acpi_sleep parameter before suspend
                          1=s3_bios, 2=s3_mode, 3=both
        -v, --pci_save:   save the PCI config space for the VGA card.

Try the following variations:

      s2ram -f -a 1
      s2ram -f -a 2
      s2ram -f -a 3
      s2ram -f -p -m
      s2ram -f -p -s
      s2ram -f -m
      s2ram -f -s
      s2ram -f -p
      s2ram -f -a 1 -m
      s2ram -f -a 1 -s

If none of those combinations work, start again but add the -v switch.

Note that mixing the -a options and the vbetool options (-p, -m, -s) is
normally only a measure of last resort, it usually does not make much
sense.

If you find several combinations that work (e.g. s2ram -f -a 3 and
s2ram -f -p -m both work on your machine), the in-kernel method (-a)
should be preferred over the userspace methods (-p, -m, -s).

Verify all combinations in both cases when reporting success to the
s2ram developers:

-   when issuing s2ram from console
-   when issuing s2ram from X

> s2ram does not work with any combination of options

There is a trick which does not correspond to a command line option,
because it requires additional operations from you. It is marked with
NOFB in the whitelist and used for those laptops which suspend and
resume properly only if no framebuffer is used. If you verify that no
command line option of s2ram works, you can try disabling the
framebuffer. To do this, you need to edit your bootloader configuration,
remove any possible vga=<foo> values from the kernel line and reboot.
This at least if you use the VESAFB framebufeer (as in the arch default
kernel). If you use a different framebuffer driver, refer to the
documentation of the driver to see how to disable it.

See also
--------

-   Uswsusp Home Page
-   HOWTO file included with the source code
-   /usr/share/doc/suspend/README Uswsusp Documentation
-   /usr/share/doc/suspend/README.s2ram-whitelist s2ram-whitelist README

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uswsusp&oldid=301326"

Category:

-   Power management

-   This page was last modified on 24 February 2014, at 11:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
