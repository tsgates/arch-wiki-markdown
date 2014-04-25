Beginners' guide/Installation
=============================

Tip:This is part of a multi-page article for The Beginners' Guide. Click
here if you would rather read the guide in its entirety.

Contents
--------

-   1 Installation
    -   1.1 Change the language
    -   1.2 Establish an internet connection
        -   1.2.1 Wired
        -   1.2.2 Wireless
            -   1.2.2.1 Without wifi-menu
        -   1.2.3 Analog modem, ISDN, or PPPoE DSL
        -   1.2.4 Behind a proxy server
    -   1.3 Prepare the storage drive
        -   1.3.1 Choose a partition table type
        -   1.3.2 Partitioning tool
        -   1.3.3 Partition scheme
        -   1.3.4 Considerations for dualbooting with Windows
        -   1.3.5 Example
            -   1.3.5.1 Using cgdisk to create GPT partitions
            -   1.3.5.2 Using fdisk to create MBR partitions
        -   1.3.6 Create filesystems
    -   1.4 Mount the partitions
    -   1.5 Select a mirror
    -   1.6 Install the base system
    -   1.7 Generate an fstab
    -   1.8 Chroot and configure the base system
        -   1.8.1 Locale
        -   1.8.2 Console font and keymap
        -   1.8.3 Time zone
        -   1.8.4 Hardware clock
        -   1.8.5 Kernel modules
        -   1.8.6 Hostname
    -   1.9 Configure the network
        -   1.9.1 Wired
            -   1.9.1.1 Dynamic IP
            -   1.9.1.2 Static IP
        -   1.9.2 Wireless
            -   1.9.2.1 Adding wireless networks
            -   1.9.2.2 Connect automatically to known networks
        -   1.9.3 Analog modem, ISDN or PPPoE DSL
    -   1.10 Create an initial ramdisk environment
    -   1.11 Set the root password
    -   1.12 Install and configure a bootloader
        -   1.12.1 For BIOS motherboards
            -   1.12.1.1 Syslinux
            -   1.12.1.2 GRUB
        -   1.12.2 For UEFI motherboards
            -   1.12.2.1 Gummiboot
            -   1.12.2.2 GRUB
    -   1.13 Unmount the partitions and reboot

Installation
------------

You are now presented with a shell prompt, automatically logged in as
root. For editing text files, the console editor nano is suggested. If
you are not familiar with it, see nano#nano usage.

> Change the language

Tip:These are optional for the majority of users. Useful only if you
plan on writing in your own language in any of the configuration files,
if you use diacritical marks in the Wi-Fi password, or if you would like
to receive system messages (e.g. possible errors) in your own language.
Changes here only affect the installation process.

By default, the keyboard layout is set to us. If you have a non-US
keyboard layout, run:

    # loadkeys layout

...where layout can be fr, uk, dvorak, be-latin1, etc. See here for
2-letter country code list. Use the command localectl list-keymaps to
list all available keymaps.

The font should also be changed, because most languages use more glyphs
than the 26 letter English alphabet. Otherwise some foreign characters
may show up as white squares or as other symbols. Note that the name is
case-sensitive, so please type it exactly as you see it:

    # setfont Lat2-Terminus16

By default, the language is set to English (US). If you would like to
change the language for the install process (German, in this example),
remove the # in front of the locale you want from /etc/locale.gen, along
with English (US). Please choose the UTF-8 entry.

    # nano /etc/locale.gen

    en_US.UTF-8 UTF-8
    de_DE.UTF-8 UTF-8

    # locale-gen
    # export LANG=de_DE.UTF-8

> Establish an internet connection

Warning:As of v197, udev no longer assigns network interface names
according to the wlanX and ethX naming scheme. If you are coming from a
different distribution or are reinstalling Arch and not aware of the new
interface naming style, please do not assume that your wireless
interface is named wlan0, or that your wired interface is named eth0.
You can use the command ip link to discover the names of your
interfaces.

The dhcpcd network daemon starts automatically during boot and it will
attempt to start a wired connection. Try to ping a server to see if a
connection was established. For example, Google's webservers:

    # ping -c 3 www.google.com

    PING www.l.google.com (74.125.132.105) 56(84) bytes of data.
    64 bytes from wb-in-f105.1e100.net (74.125.132.105): icmp_req=1 ttl=50 time=17.0 ms
    64 bytes from wb-in-f105.1e100.net (74.125.132.105): icmp_req=2 ttl=50 time=18.2 ms
    64 bytes from wb-in-f105.1e100.net (74.125.132.105): icmp_req=3 ttl=50 time=16.6 ms

    --- www.l.google.com ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2003ms
    rtt min/avg/max/mdev = 16.660/17.320/18.254/0.678 ms

If you get a ping: unknown host error, first check if there is an issue
with your cable or wireless signal strength. If not, you will need to
set up the network manually, as explained below. Once a connection is
established move on to Prepare the storage drive.

Wired

Follow this procedure if you need to set up a wired connection via a
static IP address.

First, disable the dhcpcd service which was started automatically at
boot:

    # systemctl stop dhcpcd.service

Identify the name of your Ethernet interface.

    # ip link

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: enp2s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
        link/ether 00:11:25:31:69:20 brd ff:ff:ff:ff:ff:ff
    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT qlen 1000
        link/ether 01:02:03:04:05:06 brd ff:ff:ff:ff:ff:ff

In this example, the Ethernet interface is enp2s0f0. If you are unsure,
your Ethernet interface is likely to start with the letter "e", and
unlikely to be "lo" or start with the letter "w".

You also need to know these settings:

-   Static IP address.
-   Subnet mask.
-   Gateway's IP address.
-   Name servers' (DNS) IP addresses.
-   Domain name (unless you are on a local LAN, in which case you can
    make it up).

Activate the connected Ethernet interface (e.g. enp2s0f0):

    # ip link set enp2s0f0 up

Add the address:

    # ip addr add ip_address/mask_bits dev interface_name

For example:

    # ip addr add 192.168.1.2/24 dev enp2s0f0

For more options, run man ip.

Add your gateway like this, substituting your own gateway's IP address:

    # ip route add default via ip_address

For example:

    # ip route add default via 192.168.1.1

Edit resolv.conf, substituting your name servers' IP addresses and your
local domain name:

    # nano /etc/resolv.conf

    nameserver 61.23.173.5
    nameserver 61.95.849.8
    search example.com

Note:Currently, you may include a maximum of three nameserver lines. In
order to overcome this limitation, you can use a locally caching
nameserver like Dnsmasq.

You should now have a working network connection. If you do not, check
the detailed Network configuration page.

Wireless

Follow this procedure if you need wireless connectivity (Wi-Fi) during
the installation process.

First, identify the name of your wireless interface.

    # iw dev

    phy#0
            Interface wlp3s0
                    ifindex 3
                    wdev 0x1
                    addr 00:11:22:33:44:55
                    type managed

In this example, wlp3s0 is the available wireless interface. If you are
unsure, your wireless interface is likely to start with the letter "w",
and unlikely to be "lo" or start with the letter "e".

Note:If you do not see output similar to this, then your wireless driver
has not been loaded. If this is the case, you must load the driver
yourself. Please see Wireless network configuration for more detailed
information.

Bring the interface up with:

    # ip link set wlp3s0 up

To verify that the interface is up, inspect the output of the following
command:

    # ip link show wlp3s0

    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state DOWN mode DORMANT group default qlen 1000
        link/ether 00:11:22:33:44:55 brd ff:ff:ff:ff:ff:ff

The UP in <BROADCAST,MULTICAST,UP,LOWER_UP> is what indicates the
interface is up, not the later state DOWN.

Most wireless chipsets require firmware in addition to a corresponding
driver. The kernel tries to identify and load both automatically. If you
get output like SIOCSIFFLAGS: No such file or directory, this means you
will need to manually load the firmware. If unsure, invoke dmesg to
query the kernel log for a firmware request from the wireless chipset.
For example, if you have an Intel chipset which requires and has
requested firmware from the kernel at boot:

    # dmesg | grep firmware

    firmware: requesting iwlwifi-5000-1.ucode

If there is no output, it may be concluded that the system's wireless
chipset does not require firmware.

Warning:Wireless chipset firmware packages (for cards which require
them) are pre-installed under /usr/lib/firmware in the live environment
(on CD/USB stick) but must be explicitly installed to your actual system
to provide wireless functionality after you reboot into it! Package
installation is covered later in this guide. Ensure installation of both
your wireless module and firmware before rebooting! See Wireless network
configuration if you are unsure about the requirement of corresponding
firmware installation for your particular chipset.

Next, use netctl's wifi-menu to connect to a network:

    # wifi-menu wlp3s0

You should now have a working network connection. If you do not, check
the detailed Wireless network configuration page.

Without wifi-menu

Alternatively, use iw dev wlp3s0 scan | grep SSID to scan for available
networks, then connect to a network with:

    # wpa_supplicant -B -i wlp3s0 -c <(wpa_passphrase "ssid" "psk")

You need to replace ssid with the name of your network (e.g. "Linksys
etc...") and psk with your wireless password, leaving the quotes around
the network name and password.

Finally, you have to give your interface an IP address. This can be set
manually or using the dhcp:

    # dhcpcd wlp3s0

If that does not work, issue the following commands:

    # echo 'ctrl_interface=DIR=/run/wpa_supplicant' > /etc/wpa_supplicant.conf
    # wpa_passphrase <ssid> <passphrase> >> /etc/wpa_supplicant.conf
    # ip link set <interface> up # May not be needed, but does no harm in any case
    # wpa_supplicant -B -D nl80211 -c /foobar.conf -i <interface name>
    # dhcpcd -A <interface name>

Analog modem, ISDN, or PPPoE DSL

For xDSL, dial-up, and ISDN connections, see Direct Modem Connection.

Behind a proxy server

If you are behind a proxy server, you will need to export the http_proxy
and ftp_proxy environment variables. See Proxy settings for more
information.

> Prepare the storage drive

Warning:Partitioning can destroy data. You are strongly cautioned and
advised to backup any critical data before proceeding.

Choose a partition table type

You have to choose between GUID Partition Table (GPT) and Master Boot
Record (MBR). GPT is more modern and recommended for new installations.

-   If you want to setup a system which dual boots with windows, this
    must be taken into account as explained in Partitioning#Choosing
    between GPT and MBR.
-   It is recommended to always use GPT for UEFI boot, as some UEFI
    firmwares do not allow UEFI-MBR boot.
-   Some BIOS systems may have issues with GPT. See
    http://mjg59.dreamwidth.org/8035.html and
    http://rodsbooks.com/gdisk/bios.html for more info and possible
    workarounds.

Note:If you are installing to a USB flash key, see Installing Arch Linux
on a USB key.

Partitioning tool

Absolute beginners are encouraged to use a graphical partitioning tool.
GParted is a good example, and is provided as a "live" CD. It is also
included on live CDs of most Linux distributions such as Ubuntu and
Linux Mint. A drive should first be partitioned and afterwards the
partitions should be formatted with a file system.

Tip:When using Gparted, selecting the option to create a new partition
table gives an "msdos" partition table by default. If you are intending
to follow the advice to create a GPT partition table then you need to
choose "Advanced" and then select "gpt" from the drop-down menu.

While gparted may be easier to use, if you just want to create a few
partitions on a new disk you can get the job done quickly by just using
one of the fdisk variants which are included on the install medium. In
the next section short usage instructions for both gdisk and fdisk
follow.

Partition scheme

You can decide into how many partitions the disk should be split, and
for which directory each partition should be used in the system. The
mapping from partitions to directories (frequently called 'mount
points') is the Partition scheme. The simplest, and not a bad choice, is
to make just one huge / partition. Another popular choice is to have a /
and a /home partition.

Additional required partitions:

-   If you have a UEFI motherboard, you will need to create an extra EFI
    System Partition.
-   If you have a BIOS motherboard (or plan on booting in BIOS
    compatibility mode) and you want to setup GRUB on a GPT-partitioned
    drive, you will need to create an extra BIOS Boot Partition of size
    1 or 2 MiB and EF02 type code. Syslinux does not need one.
-   If you have a requirement for a Disk encryption of the system
    itself, this must be reflected in your partition scheme. It is
    unproblematic to add encrypted folders, containers or home
    directories after the system is installed.
-   If you are planning to use any filesystem for root filesystem
    different than ext4 (-3,-2) , you should check first if GRUB
    supports it. If it is not supported you need to create a GRUB
    compatible partition (such as ext4) and use it for /boot.

See Swap for details if you wish to set up a swap partition or swap
file. A swap file is easier to resize than a partition and can be
created at any point after installation, but cannot be used with a Btrfs
filesystem.

Considerations for dualbooting with Windows

If you have an existing OS installation, please keep in mind that if you
were to just write a completely new partition table to disk then all the
data which was previously on disk would be lost.

The recommended way to setup a Linux/Windows dual booting system is to
first install Windows, only using part of the disk for its partitions.
When you have finished the Windows setup, boot into the Linux install
environment where you can create additional partitions for Linux while
leaving the existing Windows partitions untouched.

Some newer computers come pre-installed with Windows 8 which will be
using Secure Boot. Arch Linux currently does not support Secure Boot,
but some Windows 8 installations have been seen not to boot if Secure
Boot is turned off in the BIOS. In some cases it is necessary to turn
off both Secure Boot as well as Fastboot in the BIOS options in order to
allow Windows 8 to boot without Secure Boot. However there are potential
security risks in turning off Secure Boot for booting up Windows 8.
Therefore, it may be a better option to keep the Windows 8 install
intact and have an independent hard drive for the Linux install - which
can then be partitioned from scratch using a GPT partition table. Once
that is done, creating several ext4/FAT32/swap partitions on the second
drive may be a better way forward if the computer has two drives
available. This is often not easy or possible on a small laptop.
Currently, Secure Boot is still not in a fully stable state for reliable
operation, even for Linux distributions that support it.

Warning:Windows 8 includes a new feature called Fast Startup, which
turns shutdown operations into suspend-to-disk operations. The result is
that filesystems shared between Windows 8 and any other OS are almost
certain to be damaged when booting between the two OSes. Even if you
don't intend to share filesystems, the EFI System Partition is likely to
be damaged on an EFI system. Therefore, you should disable Fast Startup,
as described here, before you install Linux on any computer that uses
Windows 8.

If you have already created your partitions, proceed to #Create
filesystems.

Otherwise, see the following example.

Example

The Arch Linux install media includes the following partitioning tools:
fdisk, gdisk, cfdisk, cgdisk, parted.

Tip:Use the lsblk -f or lsblk -o NAME,FSTYPE,SIZE,LABEL command to list
the hard disks attached to your system, along with the sizes of their
existing partitions. This will help you to be confident you are
partitioning the right disk.

The example system will contain a 15 GB root partition, and a home
partition for the remaining space. Choose either MBR or GPT. Do not
choose both!

It should be emphasized that partitioning is a personal choice and that
this example is only for illustrative purposes. See Partitioning.

Using cgdisk to create GPT partitions

    # cgdisk /dev/sda

Root
    

-   Choose New (or press N) – Enter for the first sector (2048) – type
    in 15G – Enter for the default hex code (8300) – Enter for a blank
    partition name.

Home
    

-   Press the down arrow a couple of times to move to the larger free
    space area.
-   Choose New (or press N) – Enter for the first sector – Enter to use
    the rest of the drive (or you could type in the desired size; for
    example 30G) – Enter for the default hex code (8300) – Enter for a
    blank partition name.

Here is what it should look like:

    Part. #     Size        Partition Type            Partition Name
    ----------------------------------------------------------------
                1007.0 KiB  free space
       1        15.0 GiB    Linux filesystem
       2        123.45 GiB  Linux filesystem

Double check and make sure that you are happy with the partition sizes
as well as the partition table layout before continuing.

If you would like to start over, you can simply select Quit (or press Q)
to exit without saving changes and then restart cgdisk.

If you are satisfied, choose Write (or press Shift+W) to finalize and to
write the partition table to the drive. Type yes and choose Quit (or
press Q) to exit without making any more changes.

Using fdisk to create MBR partitions

Note:There is also cfdisk, which is similar in UI to cgdisk, but it
currently does not automatically align the first partition properly.
That is why the classic fdisk tool is used here.

Launch fdisk with:

    # fdisk /dev/sda

Create the partition table:

-   Command (m for help): type o and press Enter

Then create the first partition:

1.  Command (m for help): type n and press Enter
2.  Partition type: Select (default p): press Enter
3.  Partition number (1-4, default 1): press Enter
4.  First sector (2048-209715199, default 2048): press Enter
5.  Last sector, +sectors or +size{K,M,G} (2048-209715199....., default 209715199):
    type +15G and press Enter

Then create a second partition:

1.  Command (m for help): type n and press Enter
2.  Partition type: Select (default p): press Enter
3.  Partition number (1-4, default 2): press Enter
4.  First sector (31459328-209715199, default 31459328): press Enter
5.  Last sector, +sectors or +size{K,M,G} (31459328-209715199....., default 209715199):
    press Enter

Now preview the new partition table:

-   Command (m for help): type p and press Enter

    Disk /dev/sda: 107.4 GB, 107374182400 bytes, 209715200 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x5698d902

       Device Boot     Start         End     Blocks   Id  System
    /dev/sda1           2048    31459327   15728640   83   Linux
    /dev/sda2       31459328   209715199   89127936   83   Linux

Then write the changes to disk:

-   Command (m for help): type w and press Enter

If everything went well fdisk will now quit with the following message:

    The partition table has been altered!

    Calling ioctl() to re-read partition table.
    Syncing disks. 

In case this does not work because fdisk encountered an error, you can
use the q command to exit.

Create filesystems

Simply partitioning is not enough; the partitions also need a
filesystem. To format the partitions with an ext4 filesystem:

Warning:Double check and triple check that it is actually /dev/sda1 and
/dev/sda2 that you want to format. You can use lsblk to help with this.

    # mkfs.ext4 /dev/sda1
    # mkfs.ext4 /dev/sda2

If you have made a partition dedicated to swap (code 82), do not forget
to format and activate it with:

    # mkswap /dev/sdaX
    # swapon /dev/sdaX

For UEFI, you should format the EFI System Partition (for example
/dev/sdXY) with:

    # mkfs.fat -F32 /dev/sdXY

> Mount the partitions

Each partition is identified with a number suffix. For example, sda1
specifies the first partition of the first drive, while sda designates
the entire drive.

To display the current partition layout:

    # lsblk -f

Note:Do not mount more than one partition to the same directory. And pay
attention, because the mounting order is important.

First, mount the root partition on /mnt. Following the example above
(yours may be different), it would be:

    # mount /dev/sda1 /mnt

Then mount the home partition and any other separate partition (/boot,
/var, etc), if you have any:

    # mkdir /mnt/home
    # mount /dev/sda2 /mnt/home

In case you have a UEFI motherboard, mount the EFI System Partition at
your preferred mountpoint (/boot used for example):

    # mkdir /mnt/boot
    # mount /dev/sdXY /mnt/boot

> Select a mirror

Before installing, you may want to edit the mirrorlist file and place
your preferred mirror first. A copy of this file will be installed on
your new system by pacstrap as well, so it is worth getting it right.

    # nano /etc/pacman.d/mirrorlist

    ##
    ## Arch Linux repository mirrorlist
    ## Sorted by mirror score from mirror status page
    ## Generated on 2012-MM-DD
    ##

    Server = http://mirror.example.xyz/archlinux/$repo/os/$arch
    ...

If you want, you can make it the only mirror available by deleting all
other lines, but it is usually a good idea to have a few more, in case
the first one goes offline.

> Tip:

-   Use the Mirrorlist Generator to get an updated list for your
    country. HTTP mirrors are faster than FTP, because of something
    called keepalive. With FTP, pacman has to send out a signal each
    time it downloads a package, resulting in a brief pause. For other
    ways to generate a mirror list, see Sorting mirrors and Reflector.
-   Arch Linux MirrorStatus reports various aspects about the mirrors
    such as network problems with mirrors, data collection problems, the
    last time mirrors have been synced, etc.

> Note:

-   Whenever in the future you change your mirrorlist, refresh all
    package lists with pacman -Syy, to ensure that the package lists are
    updated consistently. See Mirrors for more information.
-   If you are using an older installation medium, your mirrorlist might
    be outdated, which might lead to problems when updating Arch Linux
    (see FS#22510). Therefore it is advised to obtain the latest mirror
    information as described above.
-   Some issues have been reported in the Arch Linux forums regarding
    network problems that prevent pacman from updating/synchronizing
    repositories (see [1] and [2]). When installing Arch Linux natively,
    these issues have been resolved by replacing the default pacman file
    downloader with an alternative (see Improve pacman performance for
    more details). When installing Arch Linux as a guest OS in
    VirtualBox, this issue has also been addressed by using "Host
    interface" instead of "NAT" in the machine properties.

> Install the base system

The base system is installed using the pacstrap script. The -i switch
can be omitted if you wish to install every package from the base group
without prompting. You may also want to include base-devel, as you will
need these packages should you want to build from the AUR.

    # pacstrap -i /mnt base

> Note:

-   If in the middle of the installation of base packages you get a
    request to import a PGP key, agree to download the key to proceed.
    This is likely to happen if the Arch ISO you are using is out of
    date.
-   If pacman fails to verify your packages, stop the process with
    Ctrl+C and check the system time with cal. If the system date is
    invalid (e.g. it shows the year 2010), signing keys will be
    considered expired (or invalid), signature checks on packages will
    fail and installation will be interrupted. Make sure to correct the
    system time, using the command ntpd -qg, and retry running the
    pacstrap command. Refer to Time page for more information on
    correcting system time.
-   If pacman complains that
    error: failed to commit transaction (invalid or corrupted package),
    run the following command:

    # pacman-key --init && pacman-key --populate archlinux

This will give you a basic Arch system. Other packages can be installed
later using pacman.

> Generate an fstab

Generate an fstab file with the following command. UUIDs will be used
because they have certain advantages (see fstab#Identifying
filesystems). If you would prefer to use labels instead, replace the -U
option with -L.

    # genfstab -U -p /mnt >> /mnt/etc/fstab
    # nano /mnt/etc/fstab

Warning:The fstab file should always be checked after generating it. If
you encounter errors running genfstab or later in the install process,
do not run genfstab again; just edit the fstab file.

A few considerations:

-   The last field determines the order in which partitions are checked
    at start up: use 1 for the (non-btrfs) root partition, which should
    be checked first; 2 for all other partitions you want checked at
    start up; and 0 means 'do not check' (see fstab#Field definitions).
-   All btrfs partitions should have 0 for this field. Normally, you
    will also want your swap partition to have 0.

> Chroot and configure the base system

Next, chroot into your newly installed system:

    # arch-chroot /mnt /bin/bash

Note:Leave out /bin/bash to chroot into the sh shell.

At this stage of the installation, you will configure the primary
configuration files of your Arch Linux base system. These can either be
created if they do not exist, or edited if you wish to change the
defaults.

Closely following and understanding these steps is of key importance to
ensure a properly configured system.

Locale

Locales are used by glibc and other locale-aware programs or libraries
for rendering text, correctly displaying regional monetary values, time
and date formats, alphabetic idiosyncrasies, and other locale-specific
standards.

There are two files that need editing: locale.gen and locale.conf.

Uncomment as many lines as needed. Remove the # in front of the line(s)
you want to use. Using UTF-8 is highly recommended over ISO-8859:

    # nano /etc/locale.gen

    #en_PH.UTF-8 UTF-8
    #en_PH ISO-8859-1
    #en_SG.UTF-8 UTF-8
    #en_SG ISO-8859-1
    en_US.UTF-8 UTF-8
    #en_US ISO-8859-1
    #en_ZA.UTF-8 UTF-8
    #en_ZA ISO-8859-1

Note:The locale.gen file has everything commented out by default.

Generate the locale(s) specified in /etc/locale.gen:

    # locale-gen

Note:This will also run with every update of glibc.

Create the /etc/locale.conf file substituting your chosen locale:

    # echo LANG=en_US.UTF-8 > /etc/locale.conf

> Note:

-   The locale specified in the LANG variable must be uncommented in
    /etc/locale.gen.
-   The locale.conf file does not exist by default. Setting only LANG
    should be enough as it will act as the default value for all other
    variables.

Export substituting your chosen locale:

    # export LANG=en_US.UTF-8

Tip:To use other locales for other LC_* variables, run locale to see the
available options and add them to locale.conf. It is not recommended to
set the LC_ALL variable. See Locale#Setting system-wide locale for
details.

Console font and keymap

If you set a keymap at the beginning of the install process, load it
now, as well, because the environment has changed. For example:

    # loadkeys de-latin1
    # setfont Lat2-Terminus16

To make them available after reboot, edit vconsole.conf (create it if it
does not exist):

    # nano /etc/vconsole.conf

    KEYMAP=de-latin1
    FONT=Lat2-Terminus16

-   KEYMAP – Please note that this setting is only valid for your TTYs,
    not any graphical window managers or Xorg.

-   FONT – Available alternate console fonts reside in
    /usr/share/kbd/consolefonts/. The default (blank) is safe, but some
    foreign characters may show up as white squares or as other symbols.
    It is recommended that you change it to Lat2-Terminus16, because
    according to /usr/share/kbd/consolefonts/README.Lat2-Terminus16, it
    claims to support "about 110 language sets".

-   Possible option FONT_MAP – Defines the console map to load at boot.
    Read man setfont. Removing it or leaving it blank is safe.

See Fonts#Console fonts and man vconsole.conf for more information.

Time zone

Available time zones and subzones can be found in the
/usr/share/zoneinfo/<Zone>/<SubZone> directories.

To view the available <Zone>, check the directory /usr/share/zoneinfo/:

    # ls /usr/share/zoneinfo/

Similarly, you can check the contents of directories belonging to a
<SubZone>:

    # ls /usr/share/zoneinfo/Europe

Create a symbolic link /etc/localtime to your zone file
/usr/share/zoneinfo/<Zone>/<SubZone> using this command:

    # ln -s /usr/share/zoneinfo/<Zone>/<SubZone> /etc/localtime

> Example:

    # ln -s /usr/share/zoneinfo/Europe/Minsk /etc/localtime

Hardware clock

Set the hardware clock mode uniformly between your operating systems.
Otherwise, they may overwrite the hardware clock and cause time shifts.

You can generate /etc/adjtime automatically by using one of the
following commands:

-   UTC (recommended)

Note:Using UTC for the hardware clock does not mean that software will
display time in UTC.

    # hwclock --systohc --utc

-   localtime (discouraged; used by default in Windows)

Warning:Using localtime may lead to several known and unfixable bugs.
However, there are no plans to drop support for localtime.

    # hwclock --systohc --localtime

Tip:If you have (or plan on having) a dual boot setup with Windows:

-   Recommended: Set both Arch Linux and Windows to use UTC. A quick
    registry fix is needed. Also, be sure to prevent Windows from
    synchronizing the time on-line, because the hardware clock will
    default back to localtime.

-   Not recommended: Set Arch Linux to localtime and disable any
    time-related services, like NTPd . This will let Windows take care
    of hardware clock corrections and you will need to remember to boot
    into Windows at least two times a year (in Spring and Autumn) when
    DST kicks in. So please do not ask on the forums why the clock is
    one hour behind or ahead if you usually go for days or weeks without
    booting into Windows.

Kernel modules

Tip:This is just an example, you do not need to set it. All needed
modules are automatically loaded by udev, so you will rarely need to add
something here. Only add modules that you know are missing.

For kernel modules to load during boot, place a *.conf file in
/etc/modules-load.d/, with a name based on the program that uses them.

    # nano /etc/modules-load.d/virtio-net.conf

    # Load 'virtio-net.ko' at boot.

    virtio-net

If there are more modules to load per *.conf, the module names can be
separated by newlines. A good example are the VirtualBox Guest
Additions.

Empty lines and lines starting with # or ; are ignored.

Hostname

Set the hostname to your liking (e.g. arch):

    # echo myhostname > /etc/hostname

Note:There is no need to edit /etc/hosts.

> Configure the network

You need to configure the network again, but this time for your newly
installed environment. The procedure and prerequisites are very similar
to the one described above, except we are going to make it persistent
and automatically run at boot.

> Note:

-   For more in-depth information on network configration, visit Network
    configuration and Wireless network configuration.
-   If you would like to use the old interface naming scheme (ie. eth*
    and wlan*) you can accomplish this by creating an empty file at
    /etc/udev/rules.d/80-net-setup-link.rules which will mask the file
    of the same name located under /usr/lib/udev/rules.d.

Wired

Dynamic IP

Using dhcpcd

If you only use a single fixed wired network connection, you do not need
a network management service and can simply enable the dhcpcd service:

    # systemctl enable dhcpcd.service

Note:If it does not work, use:
# systemctl enable dhcpcd@interface_name.service

Using netctl

Copy a sample profile from /etc/netctl/examples to /etc/netctl:

    # cd /etc/netctl
    # cp examples/ethernet-dhcp my_network

Edit the profile as needed (update Interface from eth0 to match network
adapter ID as shown by running ip link):

    # nano my_network

Enable the my_network profile:

    # netctl enable my_network

Note:You will get the message "Running in chroot, ignoring request.".
This can be ignored for now.

Using netctl-ifplugd

Warning:You cannot use this method in conjunction with explicitly
enabling profiles, such as netctl enable <profile>.

Alternatively, you can use netctl-ifplugd, which gracefully handles
dynamic connections to new networks:

Install ifplugd, which is required for netctl-ifplugd:

    # pacman -S ifplugd

Then enable for interface that you want:

    # systemctl enable netctl-ifplugd@<interface>.service

Tip:Netctl also provides netctl-auto, which can be used to handle wired
profiles in conjunction with netctl-ifplugd.

Static IP

Manual connection at boot using netctl

Copy a sample profile from /etc/netctl/examples to /etc/netctl:

    # cd /etc/netctl
    # cp examples/ethernet-static my_network

Edit the profile as needed (modify Interface, Address, Gateway and DNS):

    # nano my_network

-   Notice the /24 in Address which is the CIDR notation of a
    255.255.255.0 netmask

Enable above created profile to start it at every boot:

    # netctl enable my_network

Manual connection at boot using systemd

See systemd-networkd.

Wireless

Note:If your wireless adapter requires a firmware (as described in the
above Establish an internet connection section and also here), install
the package containing your firmware. Most of the time, the
linux-firmware package will contain the needed firmware. Though for some
devices, the required firmware might be in its own package. For example:

    # pacman -S zd1211-firmware

See Wireless network configuration#Installing driver/firmware for more
info.

Install iw and wpa_supplicant which you will need to connect to a
network:

    # pacman -S iw wpa_supplicant

Adding wireless networks

Using wifi-menu

Install dialog, which is required for wifi-menu:

    # pacman -S dialog

After finishing the rest of this installation and rebooting, you can
connect to the network with wifi-menu interface_name (where
interface_name is the interface of your wireless chipset).

    # wifi-menu interface_name

Warning:This must be done *after* your reboot when you are no longer
chrooted. The process spawned by this command will conflict with the one
you have running outside of the chroot. Alternatively, you could just
configure a network profile manually using the following templates so
that you do not have to worry about using wifi-menu at all.

Using manual netctl profiles

Copy a network profile from /etc/netctl/examples to /etc/netctl:

    # cd /etc/netctl
    # cp examples/wireless-wpa my-network

Edit the profile as needed (modify Interface, ESSID and Key):

    # nano my-network

Enable above created profile to start it at every boot:

    # netctl enable my-network

Connect automatically to known networks

Warning:You cannot use this method in conjunction with explicitly
enabling profiles, such as netctl enable <profile>.

Install wpa_actiond, which is required for netctl-auto:

    # pacman -S wpa_actiond

Enable the netctl-auto service, which will connect to known networks and
gracefully handle roaming and disconnects:

    # systemctl enable netctl-auto@interface_name.service

Tip:Netctl also provides netctl-ifplugd, which can be used to handle
wired profiles in conjunction with netctl-auto.

Analog modem, ISDN or PPPoE DSL

For xDSL, dial-up and ISDN connections, see Direct Modem Connection.

> Create an initial ramdisk environment

Tip:Most users can skip this step and use the defaults provided in
mkinitcpio.conf. The initramfs image (from the /boot folder) has already
been generated based on this file when the linux package (the Linux
kernel) was installed earlier with pacstrap.

Here you need to set the right hooks if the root is on a USB drive, if
you use RAID, LVM, or if /usr is on a separate partition.

Edit /etc/mkinitcpio.conf as needed and re-generate the initramfs image
with:

    # mkinitcpio -p linux

Note:Arch VPS installations on QEMU (e.g. when using virt-manager) may
need virtio modules in mkinitcpio.conf to be able to boot.

    # nano /etc/mkinitcpio.conf

    MODULES="virtio virtio_blk virtio_pci virtio_net"

> Set the root password

Set the root password with:

    # passwd

> Install and configure a bootloader

For BIOS motherboards

For BIOS systems, several boot loaders are available, see Boot Loaders
for a complete list. Choose one as per your convenience. Here, two of
the possibilities are given as examples:

-   Syslinux is (currently) limited to loading only files from the
    partition where it was installed. Its configuration file is
    considered to be easier to understand. An example configuration can
    be found here.

-   GRUB is more feature-rich and supports more complex scenarios. Its
    configuration file(s) is more similar to 'sh' scripting language,
    which may be difficult for beginners to manually write. It is
    recommended that they automatically generate one.

Syslinux

If you opted for a GUID partition table (GPT) for your hard drive
earlier, you need to install the gptfdisk package now for the
installation of syslinux to work.

    # pacman -S gptfdisk

Install the syslinux package and then use the syslinux-install_update
script to automatically install the bootloader (-i), mark the partition
active by setting the boot flag (-a), and install the MBR boot code
(-m):

    # pacman -S syslinux
    # syslinux-install_update -i -a -m

Configure syslinux.cfg to point to the right root partition. This step
is vital. If it points to the wrong partition, Arch Linux will not boot.
Change /dev/sda3 to reflect your root partition (if you partitioned your
drive as in the example, your root partition is /dev/sda1). Do the same
for the fallback entry.

    # nano /boot/syslinux/syslinux.cfg

    ...
    LABEL arch
            ...
            APPEND root=/dev/sda3 rw
            ...

For more information on configuring and using Syslinux, see Syslinux.

GRUB

Install the grub package and then run grub-install to install the
bootloader:

    # pacman -S grub
    # grub-install --target=i386-pc --recheck /dev/sda

> Note:

-   Change /dev/sda to reflect the drive you installed Arch on. Do not
    append a partition number (do not use sdaX).
-   For GPT-partitioned drives on BIOS motherboards, you also need a
    "BIOS Boot Partition". See GPT-specific instructions in the GRUB
    page.
-   A sample /boot/grub/grub.cfg  gets installed as part of the grub
    package, and subsequent grub-* commands may not over-write it.
    Ensure that your intended changes are in grub.cfg, rather than in
    grub.cfg.new or some such file.

While using a manually created grub.cfg is absolutely fine, it is
recommended that beginners automatically generate one:

Tip:To automatically search for other operating systems on your
computer, install os-prober (pacman -S os-prober) before running the
next command.

    # grub-mkconfig -o /boot/grub/grub.cfg

Note:It is possible that multiple redundant menu entries will be
generated. See GRUB#Redundant_menu_entries.

For more information on configuring and using GRUB, see GRUB.

For UEFI motherboards

For UEFI systems, several boot loaders are available, see Boot Loaders
for a complete list. Choose one as per your convenience. Here, two of
the possibilities are given as examples:

-   gummiboot is a minimal UEFI Boot Manager which basically provides a
    menu for EFISTUB kernels and other UEFI applications. This is
    recommended UEFI boot method.
-   GRUB is a more complete bootloader, useful if you run into problems
    with Gummiboot.

Note:For UEFI boot, the drive needs to be GPT-partitioned and an EFI
System Partition (512 MiB or larger, gdisk type EF00, formatted with
FAT32) must be present. In the following examples, this partition is
assumed to be mounted at /boot. If you have followed this guide from the
beginning, you have already done all of these.

Gummiboot

First install the gummiboot package and then run gummiboot install to
install the bootloader to the EFI System Partition:

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
    # pacman -S gummiboot
    # gummiboot install

You will need to manually create a configuration file to add an entry
for Arch Linux to the gummiboot manager. Create
/boot/loader/entries/arch.conf and add the following contents, replacing
/dev/sdaX with your root partition, usually /dev/sda2:

    # nano /boot/loader/entries/arch.conf

    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=/dev/sdaX rw

For more information on configuring and using gummiboot, see gummiboot.

GRUB

Install the grub and efibootmgr packages and then run grub-install to
install the bootloader:

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
    # pacman -S grub efibootmgr
    # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck

Next, while using a manually created grub.cfg is absolutely fine, it is
recommended that beginners automatically generate one:

Tip:To automatically search for other operating systems on your
computer, install os-prober before running the next command. However
os-prober is not known to properly detect UEFI OSes.

    # grub-mkconfig -o /boot/grub/grub.cfg

For more information on configuring and using GRUB, see GRUB.

> Unmount the partitions and reboot

Exit from the chroot environment:

    # exit

Since the partitions are mounted under /mnt, use the following command
to unmount them:

    # umount -R /mnt

Reboot the computer:

    # reboot

Tip:Be sure to remove the installation media, otherwise you will boot
back into it.

Beginners' guide

* * * * *

Preparation >> Installation >> Post-installation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Beginners%27_guide/Installation&oldid=305865"

Categories:

-   Getting and installing Arch
-   About Arch

-   This page was last modified on 20 March 2014, at 14:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
