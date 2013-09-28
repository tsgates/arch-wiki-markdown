mkinitcpio
==========

Summary

A detailed guide to the Arch initramfs creation utility.

Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

mkinitcpio is the next generation of initramfs creation.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Installation                                                       |
| -   3 Image creation and activation                                      |
| -   4 Configuration                                                      |
|     -   4.1 MODULES                                                      |
|     -   4.2 BINARIES and FILES                                           |
|     -   4.3 HOOKS                                                        |
|         -   4.3.1 Build hooks                                            |
|         -   4.3.2 Runtime hooks                                          |
|         -   4.3.3 Common hooks                                           |
|         -   4.3.4 Deprecated hooks                                       |
|                                                                          |
|     -   4.4 COMPRESSION                                                  |
|     -   4.5 COMPRESSION_OPTIONS                                          |
|                                                                          |
| -   5 Runtime customization                                              |
|     -   5.1 init                                                         |
|     -   5.2 Using RAID                                                   |
|     -   5.3 Using net                                                    |
|     -   5.4 Using LVM                                                    |
|     -   5.5 Using encrypted root                                         |
|     -   5.6 /usr as a separate partition                                 |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Extracting the image                                         |
|                                                                          |
| -   7 See also                                                           |
| -   8 References                                                         |
+--------------------------------------------------------------------------+

Overview
--------

mkinitcpio is a Bash script used to create an initial ramdisk
environment. From the mkinitcpio man page:

The initial ramdisk is in essence a very small environment (early
userspace) which loads various kernel modules and sets up necessary
things before handing over control to init. This makes it possible to
have, for example, encrypted root filesystems and root filesystems on a
software RAID array. mkinitcpio allows for easy extension with custom
hooks, has autodetection at runtime, and many other features.

Traditionally, the kernel was responsible for all hardware detection and
initialization tasks early in the boot process before mounting the root
filesystem and passing control to init. However, as technology advances,
these tasks have become increasingly complex.

Nowadays, the root filesystem may be on a wide range of hardware, from
SCSI to SATA to USB drives, controlled by a variety of drive controllers
from different manufacturers. Additionally, the root filesystem may be
encrypted or compressed; within a software RAID array or a logical
volume group. The simple way to handle that complexity is to pass
management into userspace: an initial ramdisk.

See also: /dev/brain0 » Blog Archive » Early Userspace in Arch Linux.

mkinitcpio is a modular tool for building an initramfs CPIO image,
offering many advantages over alternative methods; these advantages
include:

-   The use of BusyBox to provide a small and lightweight base for early
    userspace.
-   Support for udev for hardware auto-detection at runtime, thus
    preventing the loading of unnecessary modules.
-   Using an extendable hook-based init script, which supports custom
    hooks that can easily be included in pacman packages.
-   Support for LVM2, dm-crypt for both legacy and LUKS volumes, mdadm,
    and swsusp and suspend2 for resuming and booting from USB mass
    storage devices.
-   The ability to allow many features to be configured from the kernel
    command line without needing to rebuild the image.
-   Support for the inclusion of the initial ramdisk image in a kernel,
    thus making a self-contained kernel image possible.

mkinitcpio has been developed by the Arch Linux developers and from
community contributions. See the public Git repository.

Installation
------------

The mkinitcpio package is available in the official repositories and is
installed by default as a member of the base group.

Advanced users may wish to install the latest development version of
mkinitcpio from Git:

    $ git clone git://projects.archlinux.org/mkinitcpio.git

Note:It is highly recommended that you follow the arch-projects mailing
list if you use mkinitcpio from Git!

Image creation and activation
-----------------------------

By default, the mkinitcpio script generates two images after kernel
installation or upgrades: /boot/initramfs-linux.img and
/boot/initramfs-linux-fallback.img. The fallback image utilizes the same
configuration file as the default image, except the autodetect hook is
skipped during creation, thus including a full range of modules. The
autodetect hook detects required modules and tailors the image for
specific hardware, shrinking the initramfs.

Users may create any number of initramfs images with a variety of
different configurations. The desired image must be specified for the
bootloader, often in its configuration file. After changes are made to
the configuration file, the image must be regenerated. For the stock
Arch Linux kernel, linux, this is done by running this command with root
privileges:

    # mkinitcpio -p linux

The -p switch specifies a preset to utilize; most kernel packages
provide a related mkinitcpio preset file, found in /etc/mkinitcpio.d
(e.g. /etc/mkinitcpio.d/linux.preset for linux). A preset is a
predefined definition of how to create an initramfs image instead of
specifying the configuration file and output file every time.

Warning:preset files are used to automatically regenerate the initramfs
after a kernel update; be careful when editing them.

Users can manually create an image using an alternative configuration
file. For example, the following will generate an initramfs image
according to the directions in /etc/mkinitcpio-custom.conf and save it
at /boot/linux-custom.img.

    # mkinitcpio -c /etc/mkinitcpio-custom.conf -g /boot/linux-custom.img

If creating an image for a kernel other than the one currently running,
add the kernel version to the command line. You can see available kernel
versions in /usr/lib/modules.

    # mkinitcpio -g /boot/linux.img -k 3.3.0-ARCH

Configuration
-------------

The primary configuration file for mkinitcpio is /etc/mkinitcpio.conf.
Additionally, preset definitions are provided by kernel packages in the
/etc/mkinitcpio.d directory (e.g. /etc/mkinitcpio.d/linux.preset).

Warning:lvm2, mdadm, and encrypt are NOT enabled by default. Please read
this section carefully for instructions if these hooks are required.

Note:Users with multiple hardware disk controllers that use the same
node names but different kernel modules (e.g. two SCSI/SATA or two IDE
controllers) should ensure the correct order of modules is specified in
/etc/mkinitcpio.conf. Otherwise, the root device location may change
between boots, resulting in kernel panics. A more elegant alternative is
to use persistent block device naming to ensure that the right devices
are mounted.

Users can modify six variables within the configuration file:

 MODULES
    Kernel modules to be loaded before any boot hooks are run.
 BINARIES
    Additional binaries to be included in the initramfs image.
 FILES
    Additional files to be included in the initramfs image.
 HOOKS
    Hooks are scripts that execute in the initial ramdisk.
 COMPRESSION
    Used to compress the initramfs image.
 COMPRESSION_OPTIONS
    Command line options to pass to the COMPRESSION program.

> MODULES

The MODULES array is used to specify modules to load before anything
else is done.

Modules suffixed with a ? will not throw errors if they are not found.
This might be useful for custom kernels that compile in modules which
are listed explicitly in a hook or config file.

Note:If using reiser4, it must be added to the modules list.
Additionally, if you'll be needing any filesystem during the boot
process that isn't live when you run mkinitcpio—for example, if your
LUKS encryption key file is on an ext2 filesystem but no ext2
filesystems are mounted when you run mkinitcpio—that filesystem module
must also be added to the MODULES list. See here for more details.

> BINARIES and FILES

These options allow users to add files to the image. Both BINARIES and
FILES are added before hooks are run, and may be used to override files
used or provided by a hook. BINARIES are auto-located within a standard
PATH and dependency-parsed, meaning any required libraries will also be
added. FILES are added as-is. For example:

    FILES="/etc/modprobe.d/modprobe.conf"

    BINARIES="kexec"

For both, BINARIES and FILES, multiple entries can be added delimited
with spaces.

> HOOKS

The HOOKS setting is the most important setting in the file. Hooks are
small scripts which describe what will be added to the image. For some
hooks, they will also contain a runtime component which provides
additional behavior, such as starting a daemon, or assembling a stacked
block device. Hooks are referred to by their name, and executed in the
order they exist in the HOOKS setting in the config file.

The default HOOKS setting should be sufficient for most simple, single
disk setups. For root devices which are stacked or multi-block devices
such as LVM, mdadm, or LUKS, see the respective wiki pages for further
necessary configuration.

Build hooks

Build hooks are found in /usr/lib/initcpio/install. These files are
sourced by the bash shell during runtime of mkinitcpio and should
contain two functions: build and help. The build function describes the
modules, files, and binaries which will be added to the image. An API,
documented by mkinitcpio(8), serves to facilitate the addition of these
items. The help function outputs a description of what the hook
accomplishes.

For a list of all available hooks:

    $ mkinitcpio -L

Use mkinitcpio's -H option to output help for a specific hook, for
example:

    $ mkinitcpio -H udev

Runtime hooks

Runtime hooks are found in /usr/lib/initcpio/hooks. For any runtime
hook, there should always be a build hook of the same name, which calls
add_runscript to add the runtime hook to the image. These files are
sourced by the busybox ash shell during early userspace. With the
exception of cleanup hooks, they will always be run in the order listed
in the HOOKS setting. Runtime hooks may contain several functions:

run_earlyhook: Functions of this name will be run once the API
filesystems have been mounted and the kernel command line has been
parsed. This is generally where additional daemons, such as udev, which
are needed for the early boot process are started from.

run_hook: Functions of this name are run shortly after the early hooks.
This is the most common hook point, and operations such as assembly of
stacked block devices should take place here.

run_latehook: Functions of this name are run after the root device has
been mounted. This should be used, sparingly, for further setup of the
root device, or for mounting other filesystems, such as /usr.

run_cleanuphook: Functions of this name are run as late as possible, and
in the reverse order of how they are listed in the HOOKS setting in the
config file. These hooks should be used for any last minute cleanup,
such as shutting down any daemons started by an early hook.

Common hooks

A table of common hooks and how they affect image creation and runtime
follows. Note that this table is not complete, as packages can provide
custom hooks.

  Hook          Installation                                                                                                                                                                                                                                                                                                                              Runtime
  ------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  base          Sets up all initial directories and installs base utilities and libraries. Always add this hook as the first hook unless you know what you are doing.                                                                                                                                                                                     --
  udev          Adds udevd, udevadm, and a small subset of udev rules to your image.                                                                                                                                                                                                                                                                      Starts the udev daemon and processes uevents from the kernel; creating device nodes. As it simplifies the boot process by not requiring the user to explicitly specify necessary modules, using the udev hook is recommended.
  autodetect    Shrinks your initramfs to a smaller size by creating a whitelist of modules from a scan of sysfs. Be sure to verify included modules are correct and none are missing. This hook must be run before other subsystem hooks in order to take advantage of auto-detection. Any hooks placed before 'autodetect' will be installed in full.   --
  modconf       --                                                                                                                                                                                                                                                                                                                                        Loads modprobe configuration files from /etc/modprobe.d and /usr/lib/modprobe.d
  block         Adds all block device modules, formerly separately provided by fw, mmc, pata, sata, scsi , usb and virtio hooks.                                                                                                                                                                                                                          --
  pcmcia        Adds the necessary modules for PCMCIA devices. You need to have pcmciautils installed to use this.                                                                                                                                                                                                                                        --
  net           Adds the necessary modules for a network device. For PCMCIA net devices please add the pcmcia hook too.                                                                                                                                                                                                                                   Provides handling for an NFS based root filesystem.
  dmraid        Provides support for fakeRAID root devices. You must have dmraid installed to use this.                                                                                                                                                                                                                                                   Locates and assembles fakeRAID block devices using mdassemble.
  mdadm         Provides support for assembling RAID arrays from /etc/mdadm.conf, or autodetection during boot. You must have mdadm installed to use this. The mdadm_udev hook is preferred over this hook.                                                                                                                                               Locates and assembles software RAID block devices using mdassemble.
  mdadm_udev    Provides support for assembling RAID arrays via udev. You must have mdadm installed to use this.                                                                                                                                                                                                                                          Locates and assembles software RAID block devices using udev and mdadm incremental assembly. This is the preferred method of mdadm assembly (rather than using the above mdadm hook).
  keyboard      Adds the necessary modules for keyboard devices. Use this if you have an USB keyboard and need it in early userspace (either for entering encryption passphrases or for use in an interactive shell). As a side-effect modules for some non-keyboard input devices might be added to, but this should not be relied on.                   --
  keymap        Adds keymap and consolefonts from /etc/vconsole.conf.                                                                                                                                                                                                                                                                                     Loads the specified keymap and consolefont from /etc/vconsole.conf during early userspace.
  encrypt       Adds the dm_crypt kernel module and the cryptsetup tool to the image. You must have cryptsetup installed to use this.                                                                                                                                                                                                                     Detects and unlocks an encrypted root partition. See #Runtime customization for further configuration.
  lvm2          Adds the device mapper kernel module and the lvm tool to the image. You must have lvm2 installed to use this.                                                                                                                                                                                                                             Enables all LVM2 volume groups. This is necessary if you have your root filesystem on LVM.
  fsck          Adds the fsck binary and filesystem-specific helpers. If added after the autodetect hook, only the helper specific to your root filesystem will be added. Usage of this hook is strongly recommended, and it is required with a separate /usr partition.                                                                                  Runs fsck against your root device (and /usr if separate) prior to mounting.
  resume        --                                                                                                                                                                                                                                                                                                                                        Tries to resume from the "suspend to disk" state. Works with both swsusp and suspend2. See #Runtime customization for further configuration.
  filesystems   This includes necessary filesystem modules into your image. This hook is required unless you specify your filesystem modules in MODULES.                                                                                                                                                                                                  --
  shutdown      Adds shutdown initramfs support. Usage of this hook is strongly recommended if you have a separate /usr partition or encrypted root.                                                                                                                                                                                                      Unmounts and disassembles devices on shutdown.
  usr           Add supports for /usr on a separate partition.                                                                                                                                                                                                                                                                                            Mounts the /usr partition after the real root has been mounted.
  timestamp     Add the systemd-timestamp binary to the image. Provides support for RD_TIMESTAMP in early userspace. RD_TIMESTAMP can be read by in example systemd-analyze to determine boot time.                                                                                                                                                       --

  :  Current hooks

Deprecated hooks

As of mkinitcpio 0.13.0, the usbinput hook is deprecated in favor of the
keyboard hook.

As of mkinitcpio 0.12.0, the following hooks are deprecated. If you use
any of these hooks, you need to replace them with a single instance of
the block hook.

-   fw
-   mmc
-   pata
-   sata
-   scsi
-   usb
-   virtio

For more information, you can review Git commit 97368c0e78 or see the
arch-projects mailing list.

> COMPRESSION

The kernel supports several formats for compression of the initramfs -
gzip, bzip2, lzma, xz (also known as lzma2), and lzo. For most use
cases, gzip or lzop provide the best balance of compressed image size
and decompression speed.

    COMPRESSION="gzip"
    COMPRESSION="bzip2"
    COMPRESSION="lzma"
    COMPRESSION="lzop"
    COMPRESSION="xz"

Specifying no COMPRESSION will result in a gzip compressed initramfs
file. To create an uncompressed image, specify COMPRESSION=cat in the
config or use -z cat on the command line.

Make sure you have the correct file compression utility installed for
the method you wish to use.

> COMPRESSION_OPTIONS

These are additional flags passed to the program specified by
COMPRESSION, such as:

    COMPRESSION_OPTIONS='-9'

In general these should never be needed as mkinitcpio will make sure
that any supported compression method has the necessary flags to produce
a working image.

Runtime customization
---------------------

Runtime configuration options can be passed to init and certain hooks
via the kernel command line. Kernel command line parameters are often
supplied by the bootloader. The options discussed below can be appended
to the kernel command line to alter default behavior. See Kernel
parameters and Arch Boot Process for more information.

> init

Note:The following options alter the default behavior of init in the
initramfs environment. See /usr/lib/initcpio/init for details.

 root
    This is the most important parameter specified on the kernel command
    line, as it determines what device will be mounted as your proper
    root device. mkinitcpio is flexible enough to allow a wide variety
    of formats, for example:

    root=/dev/sda1                                                # /dev node
    root=LABEL=CorsairF80                                         # label
    root=UUID=ea1c4959-406c-45d0-a144-912f4e86b207                # UUID
    root=/dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0-part1    # udev symlink (requires the udev hook)
    root=801                                                      # hex-encoded major/minor number

 break
    If break or break=premount is specified, init pauses the boot
    process (after loading hooks, but before mounting the root
    filesystem) and launches an interactive shell which can be used for
    troubleshooting purposes. This shell can be launched after the root
    has been mounted by specifying break=postmount. Normal boot
    continues after exiting from the shell.

 disablehooks
    Disable hooks at runtime by adding disablehooks=hook1{,hook2,...}.
    For example:

        disablehooks=resume

 earlymodules
    Alter the order in which modules are loaded by specifying modules to
    load early via earlymodules=mod1{,mod2,...}. (This may be used, for
    example, to ensure the correct ordering of multiple network
    interfaces.)

 rootdelay=N
    Pause for N seconds before mounting the root file system by
    appending rootdelay. (This may be used, for example, if booting from
    a USB hard drive that takes longer to initialize.)

See also: Debugging with GRUB and init

> Using RAID

First, add the mdadm hook to the HOOKS array and any required RAID
modules (raid456, ext4) to the MODULES array in /etc/mkinitcpio.conf.

Kernel Parameters: Using the mdadm hook, you no longer need to configure
your RAID array in the GRUB parameters. The mdadm hook will either use
your /etc/mdadm.conf file or automatically detect the array(s) during
the init phase of boot.

Assembly via udev is also possible using the mdadm_udev hook. Upstream
prefers this method of assembly. /etc/mdadm.conf will still be read for
purposes of naming the assembled devices if it exists.

> Using net

Warning:NFSv4 is not yet supported.

Required Packages:

net requires the mkinitcpio-nfs-utils package from the official
repositories.

Kernel Parameters:

ip=

An interface spec can be either short form, which is just the name of an
interface (eth0 or whatever), or long form. ( Kernel Documentation )

The long form consists of up to seven elements, separated by colons:

  

     ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
     nfsaddrs= is an alias to ip= and can be used too.

Parameter explanation:

     <client-ip>   IP address of the client. If empty, the address will
                   either be determined by RARP/BOOTP/DHCP. What protocol
                   is used depends on the <autoconf> parameter. If this
                   parameter is not empty, autoconf will be used.
     
     <server-ip>   IP address of the NFS server. If RARP is used to
                   determine the client address and this parameter is NOT
                   empty only replies from the specified server are
                   accepted. To use different RARP and NFS server,
                   specify your RARP server here (or leave it blank), and
                   specify your NFS server in the `nfsroot' parameter
                   (see above). If this entry is blank the address of the
                   server is used which answered the RARP/BOOTP/DHCP
                   request.
     
     <gw-ip>       IP address of a gateway if the server is on a different
                   subnet. If this entry is empty no gateway is used and the
                   server is assumed to be on the local network, unless a
                   value has been received by BOOTP/DHCP.
     
     <netmask>     Netmask for local network interface. If this is empty,
                   the netmask is derived from the client IP address assuming
                   classful addressing, unless overridden in BOOTP/DHCP reply.
     
     <hostname>    Name of the client. If empty, the client IP address is
                   used in ASCII notation, or the value received by
                   BOOTP/DHCP.
     
     <device>      Name of network device to use. If this is empty, all
                   devices are used for RARP/BOOTP/DHCP requests, and the
                   first one we receive a reply on is configured. If you
                   have only one device, you can safely leave this blank.
     
     <autoconf>	Method to use for autoconfiguration. If this is either
                   'rarp', 'bootp', or 'dhcp' the specified protocol is
                   used.  If the value is 'both', 'all' or empty, all
                   protocols are used.  'off', 'static' or 'none' means
                   no autoconfiguration.

Examples:

     ip=127.0.0.1:::::lo:none  --> Enable the loopback interface.
     ip=192.168.1.1:::::eth2:none --> Enable static eth2 interface.
     ip=:::::eth0:dhcp --> Enable dhcp protocol for eth0 configuration.

BOOTIF=

If you have multiple network cards, this parameter can include the MAC
address of the interface you are booting from. This is often useful as
interface numbering may change, or in conjunction with pxelinux IPAPPEND
2 or IPAPPEND 3 option. If not given, eth0 will be used.

Example:

     BOOTIF=01-A1-B2-C3-D4-E5-F6  # Note the prepended "01-" and capital letters.

nfsroot=

If the nfsroot parameter is NOT given on the command line, the default
/tftpboot/%s will be used.

     nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]

Parameter explanation:

     <server-ip>   Specifies the IP address of the NFS server. If this field
                   is not given, the default address as determined by the
                   `ip' variable (see below) is used. One use of this
                   parameter is for example to allow using different servers
                   for RARP and NFS. Usually you can leave this blank.
     
     <root-dir>    Name of the directory on the server to mount as root. If
                   there is a "%s" token in the string, the token will be
                   replaced by the ASCII-representation of the client's IP
                   address.
     
     <nfs-options> Standard NFS options. All options are separated by commas.
                   If the options field is not given, the following defaults
                   will be used:
                           port            = as given by server portmap daemon
                           rsize           = 1024
                           wsize           = 1024
                           timeo           = 7
                           retrans         = 3
                           acregmin        = 3
                           acregmax        = 60
                           acdirmin        = 30
                           acdirmax        = 60
                           flags           = hard, nointr, noposix, cto, ac

root=/dev/nfs

If you do not use the nfsroot parameter, you need to set root=/dev/nfs
to boot from an NFS root via automatic configuration.

> Using LVM

If your root device is on LVM, you must add the lvm2 hook. You have to
pass your root device on the kernel command line in the following
format:

    root=/dev/mapper/<volume group name>-<logical volume name>

for example:

    root=/dev/mapper/myvg-root

In addition, if your root device might initialize slowly (e.g. a USB
device) and/or you receive a "volume group not found" error during boot,
you might need to add the following to the kernel command line:

    lvmwait=/dev/mapper/<volume group name><logical volume name>

for example:

    lvmwait=/dev/mapper/myvg-root

This lets the boot process wait until LVM manages to make the device
available.

> Using encrypted root

If your root volume is encrypted, you need to add the encrypt hook.

For an encrypted root, use something similar to:

    root=/dev/mapper/root cryptdevice=/dev/sda5:root

In this case, /dev/sda5 is the encrypted device, and we give it an
arbitrary name of root, which means our root device, once unlocked, is
mounted as /dev/mapper/root. On bootup, you will be prompted for the
passphrase to unlock it.See LUKS#Configuration_of_initcpio for more
details about using encrypted root.

> /usr as a separate partition

If you keep /usr as a separate partition, you must adhere to the
following requirements:

-   Add the shutdown hook. The shutdown process will pivot to a saved
    copy of the initramfs and allow for /usr (and root) to be properly
    unmounted from the VFS.
-   Add the fsck hook, mark /usr with a passno of 0 in /etc/fstab. While
    recommended for everyone, it is mandatory if you want your /usr
    partition to be fsck'ed at boot-up. Without this hook, /usr will
    never be fsck'd.
-   Add the usr hook. This will mount the /usr partition after root is
    mounted. Prior to 0.9.0, mounting of /usr would be automatic if it
    was found in the real root's /etc/fstab.

Troubleshooting
---------------

> Extracting the image

If you are curious about what is inside the initrd image, you can
extract it and poke at the files inside of it.

The initrd image is an SVR4 CPIO archive, generated via the find and
bsdcpio commands, optionally compressed with a compression scheme
understood by the kernel. For more information on the compression
schemes, see #COMPRESSION.

mkinitcpio includes a utility called lsinitcpio which will list and
extract the contents of initramfs images.

You can list the files in the image with:

    $ lsinitcpio /boot/initramfs-linux.img

And to extract them all in the current directory:

    $ lsinitcpio -x /boot/initramfs-linux.img

You can also get a more human-friendly listing of the important parts in
the image:

    $ lsinitcpio -a /boot/initramfs-linux.img

See also
--------

-   Boot Debugging - Debugging with GRUB

References
----------

1.  Linux Kernel documentation on initramfs
2.  Linux Kernel documentation on initrd
3.  Wikipedia article on initrd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mkinitcpio&oldid=256012"

Categories:

-   Boot process
-   Kernel
