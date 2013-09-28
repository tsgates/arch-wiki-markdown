Lenovo ThinkPad Edge E530
=========================

Note:Sctually this is just nothing more than a copy from Lenovo ThinkPad
Edge E430 im working on it to modifi it for the E530)

The following is regarding the Lenovo Thinkpad Edge E430 with 3rd
Generation Ivy Bridge Intel processor, released in mid 2012. The E430 is
intended to be an affordable, yet still entirely capable business
machine. Unlike some of its siblings, it is not to military specs, but
is still a well built and quite durable machine. If you are reading this
with the intention of ordering yourself this machine, do yourself a
favor and opt for the Intel WiFi card for the extra ~$20. The default
Realtek works, albiet with a bit of coaxing. Ergo, this article is meant
to suppliment the current Installation Guide or Beginners Guide.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Hardware                                                           |
|     -   2.1 Wireless                                                     |
|     -   2.2 SD Card Reader                                               |
|     -   2.3 GPU                                                          |
|                                                                          |
| -   3 Fingerprint Reader                                                 |
| -   4 Trackpoint                                                         |
| -   5 Fans                                                               |
| -   6 Linux-pf                                                           |
| -   7 Device information                                                 |
|     -   7.1 lspci output                                                 |
|     -   7.2 lsusb output                                                 |
+--------------------------------------------------------------------------+

Installation
------------

With the release of 2012.07.15 and chroot installation process, the
documented installation procedure is recommended. Though the Realtek
RTL8111/8168B ethernet controller may be realitvely unreliable with the
r8169 module. Better ethernet connectivity can be acheived with the
r8168 module. It is available in the official repositories.

    # pacman -S r8168

Following pacman's installation of the module, it may be used to replace
the r8169 module. If, while using the live cd, you are informed that
pacman needs to be updated, you may ignore it if your only intention is
to install the module to facilitate the Arch installation.

    # rmmod r8169
    # modprobe r8168

Hardware
--------

As of Kernel 3.4.6-1

  Device                                                     Works
  ---------------------------------------------------------- -----------------------
  Video (Intel HD4000/Nvidia GTX 630)                        Yes
  Ethernet (Realtek RTL8111/8168B)                           Yes*
  Wireless (Intel Centrino Wireless-N 2230/Thinkpad b/g/n)   Yes*
  Bluetooth                                                  Yes
  Audio (Intel HD Audio)                                     Yes
  Camera                                                     Yes
  Finger Print Reader                                        Yes (Fingerprint-gui)
  Card Reader (Realtek RTS5229)                              Yes*

  

  

> Wireless

If the Thinkpad in question has the Thinkpad branded WiFi adapter, it
semi-works out of the box. There may be a delay preceding any attempted
network activity, which can be resolved by disabling the power saving
feature. The usual

    # ip link wlan0 power off

is not a feature of this particular card. Instead, the over aggressive
power saving feature may be turned off upon loading the module on boot.

This may be achieved in two ways.

    # echo "options rtl8192ce fwlps=0" >> /etc/modprobe.d/modprobe.conf

Or you may add the following to your kernel boot parameters:

    rtl8192ce.fwlps=0

This will turn off the firmware lowpowerstate or fwlps.

If you have not yet ordered your computer, it is advisable to spend the
extra money to have it include the Intel Centrino wlan/bluetooth 4.0
card, as it is much better supported. Also, because Lenovo is one of a
few comanies that whitelist wlan cards, replacing/upgarding can be
challenging, costly, or just downright impossible. For example, this
model with the Ivy Bridge is new, ergo the wlan cards with the proper
FRU (field replaceable unit) number to pass the whitelist, can not yet
(7-31-2012) be found on sites such as ebay. To find what FRU's this
machine accepts, go the the Lenovo support site where you should be able
to find the necessary documentation.

On default configuration Lenovo Thinkpad Edge E530 has BCM4313 Wireless
LAN Controller. It work out of box with bcma driver. But it recommended
install broadcom-wl. Also b43 doesn't working with BCM4113.

> SD Card Reader

As of 3.8 a third party module is not needed, device is accessible @
/dev/mmcX

The card reader will not work out-of-the-box pre 3.8, but thanks to
Icetonic, the necessary kernel module, rts5229, can be found from the
Realtek website or from the Arch User Repository.

Note:My personal experience with the PKGBUILD was that Realtek uses some
rediculous "login" for their ftp download link, thereby dynamically
changing the address. I was able to navigate to the site and copy the
download link address and insert it into the PKGBUILD so that I could
create a pkg.tar.gz and install it with pacman.

> GPU

Everything works fine as regular with Bumblebee. With 3.6.x there some
Bugs see Forums (link needed). If you run Linux-pf, you may use
nvidia-pf-bumblebee.

Fingerprint Reader
------------------

Typically with older hardware, one can get the fingerprint reader to
function by using one of two open-source fingerprint reader projects.
They are [thinkfinger] and [fprint], but unfortunately both are no
longer active, so the newest generations are not supported by these
projects. Instead, Ubuntu has put together a system that includes
drivers included in these previous projects, as well as including
proprietary drivers for the newest models. In typical Ubuntu fashion, it
is gui driven and appropriately named fingerprint-gui and it is
available from the [Arch User Repository].

The fingerprint reader included on the newest generation of Thinkpad
E430 is a Upek. To verify the model of the device in a given machine,
one may use lsusb.

    $ lsusb
    Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 001 Device 003: ID 147e:1002 Upek

The '147e:1002 Upek' being the relevant information here. For help
setting up this device, see Fingerprint-gui

Trackpoint
----------

The trackpoint works out of the box, though scroll wheel emulation
button needs a bit of configuring. The following will set the middle
Trackpoint button to scroll, though it will also disable the possibility
of using it to generate a middle click. Create the file
/etc/X11/xorg.conf.d/20-thinkpad.conf as root with the following:

    Section "InputClass"
    	Identifier	"Trackpoint Wheel Emulation"
    	MatchProduct	"TPPS/2 IBM TrackPoint"
    	MatchDevicePath	"/dev/input/event*"
    	Option		"EmulateWheel"		"true"
    	Option		"EmulateWheelButton"	"2"
    	Option		"Emulate3Buttons"	"false"
    	Option		"XAxisMapping"		"6 7"
    	Option		"YAxisMapping"		"4 5"
    EndSection

This information was taken from Thinkwiki's page regarding the
Trackpoint. You can find it here:
http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint . Keep in
mind that your Trackpoint might be identified by a different
"MatchProduct", so you may want to determine the exact indentifier. The
easiest way to do this is with the hwinfo package available in the
Official Repositories. Simply run 'hwinfo' as a normal user or root and
look for the PS/2 information.

Fans
----

Warning: Thinkfan has been reported to not work on this model currently.
Tread lightly.

The thinkpad_acpi kernel module needs to be configured so user space
programs can control the fan speed.

    /etc/modprobe.d/modprobe.conf

    options thinkpad_acpi fan_control=1

The thinkfan configuration file also needs to know how to set the fan
speed. Replace the default sensor settings with the following.

    /etc/thinkfan.conf

    sensor /sys/devices/platform/coretemp.0/temp1_input

Direct fan control can be achieved by using "echo" to apply the desired
level. Set the speed as shown in the following examples:

    # echo engage > /proc/acpi/ibm/fan
    # echo level auto > /proc/acpi/ibm/fan
    # echo level 1 > /proc/etc/ibm/fan

Once thinkpad_acpi has been loaded with fan_control=1, available
settings can be displayed like so:

    $ cat /proc/acpi/ibm/fan

  

  

Linux-pf
--------

Linux-pf works fine with bumblebee and TuxOnIce with the package I
posted above. Howerver I suggest to use suspend to file. In
Kconfig/menuconfig, you can select "Intel Core 3rd Gen AVX" as processor
family to set the right -march -mtune flags, to get right and best
optimisations for your CPU.

  

Note:I ordered my computer with a camera but I never use those things.
Other reports I have come across seem to indicate these work without
issue, though a bit of configuration is needed.

Device information
==================

lspci output
------------

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
    00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 VGA compatible controller: NVIDIA Corporation Device 1058 (rev a1)
    02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader (rev 01)
    03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
    0c:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)

lsusb output
------------

    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 003: ID 0a5c:21f4 Broadcom Corp. 
    Bus 003 Device 004: ID 147e:1002 Upek 
    Bus 004 Device 003: ID 05ca:1823 Ricoh Co., Ltd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_Edge_E530&oldid=253191"

Category:

-   Lenovo
