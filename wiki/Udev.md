udev
====

udev replaces the functionality of both hotplug and hwdetect.

"Udev is the device manager for the Linux kernel. Primarily, it manages
device nodes in /dev. It is the successor of devfs and hotplug, which
means that it handles the /dev directory and all user space actions when
adding/removing devices, including firmware load." Source: Wikipedia
article

Udev loads kernel modules by utilizing coding parallelism to provide a
potential performance advantage versus loading these modules serially.
The modules are therefore loaded asynchronously. The inherent
disadvantage of this method is that udev does not always load modules in
the same order on each boot. If the machine has multiple block devices,
this may manifest itself in the form of device nodes changing
designations randomly. For example, if the machine has two hard drives,
/dev/sda may randomly become /dev/sdb. See below for more info on this.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 About udev rules                                                   |
|     -   2.1 Writing udev rules                                           |
|     -   2.2 List attributes of a device                                  |
|     -   2.3 Testing rules before loading                                 |
|     -   2.4 Loading new rules                                            |
|                                                                          |
| -   3 Udisks                                                             |
|     -   3.1 Automounting udisks wrappers                                 |
|     -   3.2 Udisks shell functions                                       |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Accessing firmware programmers and USB virtual comm devices  |
|     -   4.2 Execute on USB insert                                        |
|     -   4.3 Detect new eSATA drives                                      |
|     -   4.4 Mark internal SATA ports as eSATA                            |
|     -   4.5 Setting static device names                                  |
|         -   4.5.1 iscsi device                                           |
|         -   4.5.2 Video devices                                          |
|                                                                          |
|     -   4.6 Running HAL                                                  |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Blacklisting modules                                         |
|     -   5.2 udevd hangs at boot                                          |
|     -   5.3 Known problems with hardware                                 |
|         -   5.3.1 BusLogic devices can be broken and will cause a freeze |
|             during startup                                               |
|         -   5.3.2 Some devices, that should be treated as removable, are |
|             not                                                          |
|                                                                          |
|     -   5.4 Known problems with auto-loading                             |
|         -   5.4.1 Sound problems with some modules not loaded            |
|             automatically                                                |
|                                                                          |
|     -   5.5 Known problems for custom kernel users                       |
|         -   5.5.1 Udev doesn't start at all                              |
|                                                                          |
|     -   5.6 IDE CD/DVD-drive support                                     |
|     -   5.7 Optical drives have group ID set to "disk"                   |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Udev is now part of systemd and is installed by default on Arch Linux
systems.

About udev rules
----------------

Udev rules written by the administrator go in /etc/udev/rules.d/, their
file name has to end with .rules. The udev rules shipped with various
packages are found in /usr/lib/udev/rules.d/. If there are two files by
the same name under /usr/lib and /etc, the ones in /etc take precedence.

> Writing udev rules

-   To learn how to write udev rules, see Writing udev rules.
-   To see an example udev rule, see Improved Udev Rule For Arch Linux.

This is an example of a rule that places a symlink /dev/video-cam1 when
a webcamera is connected. First, we have found out that this camera is
connected and has loaded with the device /dev/video2. The reason for
writing this rule is that at the next boot the device might just as well
show up under a different name like /dev/video0.

    # udevadm info -a -p $(udevadm info -q path -n /dev/video2)

    Udevadm info starts with the device specified by the devpath and then
    walks up the chain of parent devices. It prints for every device
    found, all possible attributes in the udev rules key format.
    A rule to match, can be composed by the attributes of the device
    and the attributes from one single parent device.

      looking at device '/devices/pci0000:00/0000:00:04.1/usb3/3-2/3-2:1.0/video4linux/video2':
        KERNEL=="video2"
        SUBSYSTEM=="video4linux"
        ...
      looking at parent device '/devices/pci0000:00/0000:00:04.1/usb3/3-2/3-2:1.0':
        KERNELS=="3-2:1.0"
        SUBSYSTEMS=="usb"
        ...
      looking at parent device '/devices/pci0000:00/0000:00:04.1/usb3/3-2':
        KERNELS=="3-2"
        SUBSYSTEMS=="usb"
        ...
        ATTRS{idVendor}=="05a9"
        ...
        ATTRS{manufacturer}=="OmniVision Technologies, Inc."
        ATTRS{removable}=="unknown"
        ATTRS{idProduct}=="4519"
        ATTRS{bDeviceClass}=="00"
        ATTRS{product}=="USB Camera"
        ...

From the video4linux device we use KERNEL=="video2" and
SUBSYSTEM=="video4linux", then we match the webcam using vendor and
product ID's from the usb parent SUBSYSTEMS=="usb",
ATTRS{idVendor}=="05a9" and ATTRS{idProduct}=="4519".

    /etc/udev/rules.d/83-webcam.rules

    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", \
            ATTRS{idVendor}=="05a9", ATTRS{idProduct}=="4519", SYMLINK+="video-cam1"

In the example above we create a symlink using SYMLINK+="video-cam1" but
we could easily set user OWNER="john" or group using GROUP="video" or
set the permissions using MODE="0660"

> List attributes of a device

To get a list of all of the attributes of a device you can use to write
rules, run this command:

    # udevadm info -a -n [device name]

Replace [device name] with the device present in the system, such as
/dev/sda or /dev/ttyUSB0.

If you do not know the device name you can also list all attributes of a
specific system path:

    # udevadm info -a -p /sys/class/backlight/acpi_video0

> Testing rules before loading

    # udevadm test $(udevadm info -q path -n [device name]) 2>&1

This will not perform all actions in your new rules but it will however
process symlink rules on existing devices which might come in handy if
you are unable to load them otherwise. You can also directly provide the
path to the device you want to test the udev rule for:

    # udevadm test /sys/class/backlight/acpi_video0/

> Loading new rules

Udev automatically detects changes to rules files, so changes take
effect immediately without requiring udev to be restarted. However, the
rules are not re-triggered automatically on already existing devices.
Hot-pluggable devices, such as USB devices, will probably have to be
reconnected for the new rules to take effect, or at least unloading and
reloading the ohci-hcd and ehci-hcd kernel modules and thereby reloading
all USB drivers.

To manually force udev to trigger your rules

    # udevadm trigger

Udisks
------

If you want to mount removable drives please do not call 'mount' from
udev rule. In case of fuse filesystems (e.g. ntfs-3g) you'll get
"Transport endpoint not connected" error. Instead use udisks that
handles automount correctly.

There are two incompatible versions, udisks and udisks2, a
compatibility-breaking rewrite of udisks. Depending on your DE, one of
the following version will be needed (should already be installed as a
dependency):

-   For GNOME or KDE 4.10+, install udisks2
-   For XFCE, install udisks

There is no need for any additional rules either way. As an extra bonus
you can remove HAL if you were only using that for auto mounting
purposes.

> Automounting udisks wrappers

A udisks wrapper has the advantage of being very easy to install and
needing no (or minimal) configuration. The wrapper will automatically
mount things like CDs and flash drives.

-   udevil - udevil "mounts and unmounts removable devices without a
    password, shows device info, and monitors device changes". It is
    written in C and can replace UDisks and includes devmon, which can
    be installed separately from the AUR (devmon). It can also
    selectively automatically start applications or execute commands
    after mounting, ignore specified devices and volume labels, and
    unmount removable drives.
-   ldm - A lightweight daemon that mounts usb drives, cds, dvds or
    floppys automagically. [1]
-   udiskie - Written in Python. Enables automatic mounting and
    unmounting by any user.
-   udisksevt - Written in Haskell. Enables automatic mounting by any
    user. Designed to be integrated with traydevice.
-   udisksvm - A GUI UDisks wrapper which uses the udisks2 dbus
    interface. It calls a 'traydvm' script, included in the package. The
    'traydvm' GUI utility is a script which displays a systray icon for
    a plugged-in device, with a right-click menu to perform simple
    actions on the device. As the automount function can be disabled,
    this tool should work with other automounting tools, to show system
    tray icons. It is independent of any file manager.
-   You can easily automount and eject removable devices with the
    combination of pmount, udisks2 and spacefm. Note you have to run
    spacefm in daemon mode with spacefm -d & in your startup scripts,
    ~/.xinitrc or ~/.xsession, to get automounting. You can also mount
    internal disks by adding them to /etc/pmount.allow.

> Udisks shell functions

While udisks includes a simple method of (un)mounting devices via
command-line, it can be tiresome to type the commands out each time.
These shell functions will generally shorten and ease command-line
usage.

-   udisks_functions - Written for Bash.
-   bashmount - bashmount is a menu-driven Bash script with a
    configuration file that makes it easy to configure and extend.

Tips and tricks
---------------

> Accessing firmware programmers and USB virtual comm devices

The following ruleset will allow normal users (within the "users" group)
the ability to access the USBtinyISP USB programmer for AVR
microcontrollers and a generic (SiLabs CP2102) USB to UART adapter, the
Atmel AVR Dragon programmer, and the Atmel AVR ISP mkII. Adjust the
permissions accordingly. Verified as of 31-10-2012.

    /etc/udev/rules.d/50-embedded_devices.rules

    # USBtinyISP Programmer rules
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", GROUP="users", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0479", GROUP="users", MODE="0666"
    # USBasp Programmer rules http://www.fischl.de/usbasp/
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", GROUP="users", MODE="0666"

    # Mdfly.com Generic (SiLabs CP2102) 3.3v/5v USB VComm adapter
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", GROUP="users", MODE="0666"

    #Atmel AVR Dragon (dragon_isp) rules
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2107", GROUP="users", MODE="0666"

    #Atmel AVR JTAGICEMKII rules
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2103", GROUP="users", MODE="0666"

    #Atmel Corp. AVR ISP mkII
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2104", GROUP="users", MODE="0666"

> Execute on USB insert

See the Execute on USB insert article or the devmon wrapper script.

> Detect new eSATA drives

If your eSATA drive isn't detected when you plug it in, there are a few
things you can try. You can reboot with the eSATA plugged in. Or you
could try

    # for f in /sys/class/scsi_host/host*/scan; do echo "0 0 0" > $f; done

Or you could install scsiadd (from the AUR) and try

    # scsiadd -s

Hopefully, your drive is now in /dev. If it doesn't, you could try the
above commands while running

    # udevadm monitor

to see if anything is actually happening.

> Mark internal SATA ports as eSATA

If you connected a eSATA bay or an other eSATA adapter the system will
still recognize this disk as an internal SATA drive. GNOME and KDE will
ask you for your root password all the time. The following rule will
mark the specified SATA-Port as an external eSATA-Port. With that, a
normal GNOME user can connect their eSATA drives to that port like a USB
drive, without any root password and so on.

    /etc/udev/rules.d/10-esata.rules

    DEVPATH=="/devices/pci0000:00/0000:00:1f.2/host4/*", ENV{UDISKS_SYSTEM_INTERNAL}="0"

Note:The DEVPATH can be found after connection the eSATA drive with the
following commands (replace sdb accordingly):

    # udevadm info -q path -n /dev/sdb
    /devices/pci0000:00/0000:00:1f.2/host4/target4:0:0/4:0:0:0/block/sdb

    # find /sys/devices/ -name sdb
    /sys/devices/pci0000:00/0000:00:1f.2/host4/target4:0:0/4:0:0:0/block/sdb

> Setting static device names

Because udev loads all modules asynchronously, they are initialized in a
different order. This can result in devices randomly switching names. A
udev rule can be added to use static device names:

-   See Persistent block device naming for block devices.
-   See Network_Configuration#Device_names for network devices

iscsi device

Test the output from scsi_id:

    # /usr/lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/sdb
    3600601607db11e0013ab5a8e371ce111

    /etc/udev/rules.d/75-iscsi.rules

    #The iscsi device rules.
    #This will create an iscsi device for each of the targets.
    KERNEL=="sd*", SUBSYSTEM=="block", \
         PROGRAM="/usr/lib/udev/scsi_id --whitelisted --replace-whitespace /dev/$name", \ RESULT=="3600601607db11e0013ab5a8e371ce111", \
         NAME="isda"

Video devices

For setting up the webcam in the first place, refer to Webcam
configuration.

Using multiple webcams, useful for example with motion (software motion
detector which grabs images from video4linux devices and/or from
webcams), will assign video devices as /dev/video0..n randomly on boot.
The recommended solution is to create symlinks using an udev rule (as in
the example in Writing udev rules).

    /etc/udev/rules.d/83-webcam.rules

    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", \
            ATTRS{idVendor}=="05a9", ATTRS{idProduct}=="4519", SYMLINK+="video-cam1"
    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", \
            ATTRS{idVendor}=="046d", ATTRS{idProduct}=="08f6", SYMLINK+="video-cam2"
    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", \
            ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0840", SYMLINK+="video-cam3"

Note:Using names other than "/dev/video*" will break preloading of
v4l1compat.so and perhaps v4l2convert.so.

> Running HAL

Some programs still require HAL (like Flash DRM content). Hal can be
installed from hal and hal-info.

Using Systemd: one can start and stop the hal service using the
following systemd commands:

Start HAL: # systemctl start hal.service

Stop HAL: # systemctl stop hal.service

Alternatively, one can use the following script:

    #!/bin/bash

    ## written by Mark Lee <bluerider>
    ## using information from <https://wiki.archlinux.org/index.php/Chromium#Google_Play_.26_Flash>

    ## Start and stop Hal service on command for Google Play Movie service

    function main () {  ## run the main insertion function
         clear-cache;  ## remove adobe cache
         start-hal;  ## start the hal daemon
         read -p "Press 'enter' to stop hal";  ## pause the command line with a read line
         stop-hal;  ## stop the hal daemon
    }

    function clear-cache () {  ## remove adobe cache
         cd ~/.adobe/Flash_Player;  ## go to Flash player user directory
         rm -rf NativeCache AssetCache APSPrivateData2;  ## remove cache
    }

    function start-hal () {  ## start the hal daemon
         sudo systemctl start hal.service && ( ## systemd : start hal daemon
              echo "Started hal service..."
    ) || (
              echo "Failed to start hal service!") 
    }

    function stop-hal () {  ## stop the hal daemon
    sudo systemctl stop hal.service && (  ## systemd : stop hal daemon
              echo "Stopped hal service..."
         ) || (
              echo "Failed to stop hal service!"
         )
    }

    main;  ## run the main insertion function

Troubleshooting
---------------

> Blacklisting modules

In rare cases, udev can make mistakes and load the wrong modules. To
prevent it from doing this, you can blacklist modules. Once blacklisted,
udev will never load that module. See blacklisting. Not at boot-time or
later on when a hotplug event is received (eg, you plug in your USB
flash drive).

> udevd hangs at boot

After migrating to LDAP or updating an LDAP-backed system udevd can hang
at boot at the message "Starting UDev Daemon". This is usually caused by
udevd trying to look up a name from LDAP but failing, because the
network is not up yet. The solution is to ensure that all system group
names are present locally.

Extract the group names referenced in udev rules and the group names
actually present on the system:

    # fgrep -r GROUP /etc/udev/rules.d/ /usr/lib/udev/rules.d | perl -nle '/GROUP\s*=\s*"(.*?)"/ && print $1;' | sort | uniq > udev_groups
    # cut -f1 -d: /etc/gshadow /etc/group | sort | uniq > present_groups

To see the differences, do a side-by-side diff:

    # diff -y present_groups udev_groups
    ...
    network							      <
    nobody							      <
    ntp							      <
    optical								optical
    power							      |	pcscd
    rfkill							      <
    root								root
    scanner								scanner
    smmsp							      <
    storage								storage
    ...

In this case, the pcscd group is for some reason not present in the
system. Add the missing groups:

    # groupadd pcscd

Also, make sure that local resources are looked up before resorting to
LDAP. /etc/nsswitch.conf should contain the following line:

    group: files ldap

> Known problems with hardware

BusLogic devices can be broken and will cause a freeze during startup

This is a kernel bug and no fix has been provided yet.

Some devices, that should be treated as removable, are not

Create a custom udev rule, setting UDISKS_SYSTEM_INTERNAL=0. For more
details, see the manpage of udisks.

> Known problems with auto-loading

Sound problems with some modules not loaded automatically

Some users have traced this problem to old entries in
/etc/modprobe.d/sound.conf. Try cleaning that file out and trying again.

Note:Since udev>=171, the OSS emulation modules (snd_seq_oss,
snd_pcm_oss, snd_mixer_oss) are not automatically loaded by default.

> Known problems for custom kernel users

Udev doesn't start at all

Make sure you have a kernel version later than or equal to 2.6.32.
Earlier kernels do not have the necessary uevent stuff that udev needs
for auto-loading.

> IDE CD/DVD-drive support

Starting with version 170, udev doesn't support CD-ROM/DVD-ROM drives,
which are loaded as traditional IDE drives with the ide_cd_mod module
and show up as /dev/hd*. The drive remains usable for tools which access
the hardware directly, like cdparanoia, but is invisible for higher
userspace programs, like KDE.

A cause for the loading of the ide_cd_mod module prior to others, like
sr_mod, could be e.g. that you have for some reason the module piix
loaded with your initramfs. In that case you can just replace it with
ata_piix in your /etc/mkinitcpio.conf.

> Optical drives have group ID set to "disk"

If the group ID of your optical drive is set to disk and you want to
have it set to optical, you have to create a custom udev rule:

    /etc/udev/rules.d

    # permissions for IDE CD devices
    SUBSYSTEMS=="ide", KERNEL=="hd[a-z]", ATTR{removable}=="1", ATTRS{media}=="cdrom*", GROUP="optical"

    # permissions for SCSI CD devices
    SUBSYSTEMS=="scsi", KERNEL=="s[rg][0-9]*", ATTRS{type}=="5", GROUP="optical"

See also
--------

-   Udev Homepage
-   An Introduction to Udev
-   Udev mailing list information

Retrieved from
"https://wiki.archlinux.org/index.php?title=Udev&oldid=254071"

Category:

-   Hardware detection and troubleshooting
