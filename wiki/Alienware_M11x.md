Alienware M11x
==============

This wiki page documents the configuration and troubleshooting specific
to the Alienware M11x laptop.

See the Beginners' Guide for installation instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
|     -   1.1 Alienware M11x R1                                            |
|         -   1.1.1 Ports                                                  |
|         -   1.1.2 Dimensions & Weight                                    |
|         -   1.1.3 lspci output                                           |
|                                                                          |
|     -   1.2 Alienware M11x R2                                            |
|         -   1.2.1 Ports                                                  |
|                                                                          |
|     -   1.3 Alienware M11x R3                                            |
|         -   1.3.1 Ports                                                  |
|         -   1.3.2 Dimensions & Weight                                    |
|         -   1.3.3 lspci output                                           |
|                                                                          |
| -   2 Ethernet                                                           |
| -   3 Wireless                                                           |
| -   4 Sound                                                              |
| -   5 Touchpad                                                           |
| -   6 Video                                                              |
|     -   6.1 Bumblebee                                                    |
|         -   6.1.1 Bumblebee Usage                                        |
|                                                                          |
|     -   6.2 ACPI_CALL                                                    |
|         -   6.2.1 acpi_call Usage                                        |
|         -   6.2.2 m11rx2hack                                             |
|         -   6.2.3 m11rx3hack                                             |
|                                                                          |
|     -   6.3 VGA_SWITCHEROO                                               |
|     -   6.4 Backlight Brightness                                         |
|         -   6.4.1 /sbin/backlight                                        |
|                                                                          |
| -   7 Lighting and colors                                                |
|     -   7.1 AlienFX                                                      |
|     -   7.2 pyalienfx                                                    |
|     -   7.3 Other applications                                           |
|                                                                          |
| -   8 laptop-init-script                                                 |
+--------------------------------------------------------------------------+

System Specifications
---------------------

The M11x base model comes with the following options :: (BLUE =
OPTIONAL)

> Alienware M11x R1

-   Intel Pentium Processor SU4100 (2M Cache, 1.30 GHz, 800 MHz FSB)
    -OR- Intel Core 2 Duo SU7300 (1.3GHz, 800 MHz, 3 MB)
-   2GB, -OR- 4GB, -OR- 8GB DDR3 - 800MHz RAM
-   11.6-inch WideHD 1366x768 (720p) LCD
-   1GB GDDR3 NVIDIA GeForce GT 335M discrete video
-   Mobile Intel GS45 Chipset
-   Intel 4500HD onboard video
-   Intel Internal High-Definition 5.1 Surround Sound Audio
-   Braodcom 4353 802.11a/b/g/n 2x2 MIMO wireless
-   160GB 5,400RPM hard drive -OR- 250GB, 320GB, 500GB - 7,200RPM hard
    drive -OR- 256GB - Solid State Drive
-   Internal Wireless Bluetooth 2.1
-   Internal WWAN Mobile Broadband
-   Two Built-In Front Speakers
-   AlienFX Illuminated Keyboard Keyboard
-   8 Cell Prismatic (64 whr) - Primary Battery

Ports

-   IEEE 1394a (4-pin) port
-   Integrated Ethernet RJ-45 (100 Mbps)
-   3 Hi-speed USB 2.0 ports
-   DP / HDMI / VGA - Video Output
-   3-in-1 Media Card Reader
-   2 Audio Out Connectors
-   Audio In / Microphone Jack (retaskable for 5.1 audio)

Dimensions & Weight

-   Height: 32.7mm (1.29 inches) x Width: 285.7mm (11.25 inches) x
    Depth: 233.3mm (9.19 inches)
-   Preliminary Weight: Start at 1.99kg (4.39 lbs)

lspci output

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0caf (rev a2)
    01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
    02:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    08:00.0 Network controller: Broadcom Corporation Device 4353 (rev 01)
    1a:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller
    1a:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
    1a:00.3 System peripheral: JMicron Technology Corp. MS Host Controller

> Alienware M11x R2

The M11x R2 is similar to the R1, but it has some processor and chipset
differences.

-   Processor: Intel® CoreTM i5 520UM (3M Cache, 1.066 GHZ, 1.866 GHz
    Max) or Intel® CoreTM i7 640UM (4M Cache, 1.2 GHZ with 2.266 GHz
    Max)
-   Chipset: Mobile Intel® QS57 Express Chipset
-   Uses NVIDIA Optimus to automatically switch between graphic cards
    when using Windows 7 drivers. There is no option on the BIOS to
    manually switch graphics.

Ports

-   The VGA port is not present in this model

> Alienware M11x R3

-   Processor: Intel® CoreTM i7 2637M (4M Cache, 1.70 GHz)
-   8GB DDR3 - 800MHz RAM
-   11.6-inch WideHD 1366x768 (720p) LCD
-   Intel Sandybridge Mobile Graphics Controller
-   2GB GDDR3 NVIDIA GeForce GT 540M/PCIe/SSE2 discrete video
-   Intel i915 onboard video
-   Intel Internal High-Definition 5.1 Surround Sound Audio
-   Dell Wireless DW375 Bluetooth Adapter
-   Attansic (atl1c) Ethernet Controller
-   Intel WiFi Link 6000 Series Wireless Ethernet Controller
-   700GB - 7,200RPM hard drive
-   Two Built-In Front Speakers
-   AlienFX Illuminated Keyboard Keyboard
-   8 Cell DELL 8P6X61C9 (64530 mWh) - Primary Battery

Ports

-   DP / HDMI - Video Output
-   The VGA port is not present in this model
-   IEEE 1394a (4-pin) port
-   Integrated Ethernet RJ-45 (100 Mbps)
-   3 Hi-speed USB 2.0 ports
-   3-in-1 Media Card Reader
-   2 Audio Out Connectors
-   Audio In / Microphone Jack

Dimensions & Weight

-   Height: 32.7mm (1.29 inches) x Width: 285.7mm (11.25 inches) x
    Depth: 233.3mm (9.19 inches)
-   Preliminary Weight: Start at 1.99kg (4.39 lbs)

lspci output

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
    00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5)
    00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5)
    00:1d.0 USB Controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation QS67 Express Chipset Family LPC Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation GF106 [GeForce GT 555M] (rev a1)
    07:00.0 Ethernet controller: Atheros Communications AR8151 v2.0 Gigabit Ethernet (rev c0)
    0d:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
    13:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (rev 30)
    13:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 30)
    13:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 30)
    19:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)

Ethernet
--------

The AR8132 10/100Mb fast Ethernet controller uses the atl1c module and
works out-of-the-box with Linux kernel 3.x.

    # lspci -kv
    02:00.0 Ethernet controller: Atheros Communications AR8132 Fast Ethernet (rev c0)
    	Subsystem: Dell Device 0443
    	Flags: bus master, fast devsel, latency 0, IRQ 48
    	Memory at f1100000 (64-bit, non-prefetchable) [size=256K]
    	I/O ports at 3000 [size=128]
    	Capabilities: [40] Power Management version 3
    	Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
    	Capabilities: [58] Express Endpoint, MSI 00
    	Capabilities: [6c] Vital Product Data
    	Capabilities: [100] Advanced Error Reporting
    	Capabilities: [180] Device Serial Number ff-xx-xx-xx-xx-xx-xx-xx
    	Kernel driver in use: atl1c
    	Kernel modules: atl1c

    # modinfo atl1c
    filename:       /lib/modules/3.0-ARCH/kernel/drivers/net/atl1c/atl1c.ko.gz
    version:        1.0.1.0-NAPI
    license:        GPL
    description:    Atheros 1000M Ethernet Network Driver
    author:         Jie Yang <jie.yang@atheros.com>
    srcversion:     4E5E179060C0F8631076B4A
    alias:          pci:v00001969d00001083sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001073sv*sd*bc*sc*i*
    alias:          pci:v00001969d00002062sv*sd*bc*sc*i*
    alias:          pci:v00001969d00002060sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001062sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001063sv*sd*bc*sc*i*
    depends:        
    vermagic:       3.0-ARCH SMP preempt mod_unload 

    # dmesg | grep -i atl1c
    atl1c 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
    atl1c 0000:02:00.0: setting latency timer to 64
    atl1c 0000:02:00.0: version 1.0.0.2-NAPI
    atl1c 0000:02:00.0: irq 30 for MSI/MSI-X
    atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>

Wireless
--------

The Broadcom Corporation Device 4353 (rev 01)(14e4:4353) 802.11a/b/g/n
MIMO adapter is the stock wireless device for the M11x (R1).

-   I have brcm80211 working with my 14e4:4353 "Broadcom Corporation
    Device 4353 (rev 01)" wireless adapter, using arch +
    compat-wireless-patched AUR package.
    -   Alternately you could just build the compat-wireless-brcm80211
        AUR package which ONLY installs the brcm80211 module driver.
        -   I used to use broadcom-wl AUR package and implemented some
            tips from the Broadcom_BCM4312 page.
            -   Currently, the brcm80211 driver in AUR and the 2.6.37
                kernel have a particularly crippling bug on multicore
                systems. This is fixed in 2.6.38-rc3 - the driver works
                great and is much faster (both in terms of initial
                connection and transfer rates; YMMV).

UPDATE: As of Kernel 2.6.39 brcm80211 was renamed to brcmsmac, that
should not give you any problems, BUT when using Kernel 3.0 you need to
add brcmsmac to your modules array in /etc/rc.conf, because of some bug
in which the wireless interface does not show up, that should solve it.

-   FN+F3 controls the internal radio on the wireless internal adapter -
    this allows you to turn it off/on.
-   Currently, this device does NOT support monitor mode, nor packet
    injection =(

Above in the rc.conf NETWORKING section, I am not using eth1 (actually
commented out), as I like using wlan0 for wireless interface, it is just
my preference. I am using the following config taken from
Broadcom_BCM4312 Interfaces swapped every time section, namely to create
my wlan0 interface, and to ensure eth0 and my wireless interface do not
get swapped around ::

Create a file called /etc/udev/rules.d/10-network.rules and bind the MAC
address of each of your cards to a certain interface name

    SUBSYSTEM=="net", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="eth0"
    SUBSYSTEM=="net", ATTR{address}=="ff:ee:dd:cc:bb:aa", NAME="wlan0"

> Where:

-   NAME="eth0" is the name of the interface that you want, for example
    the same name "eth0". You can use other names, for example "lan0" or
    "wlan0".
-   To get the MAC address of each card, use this command:
    udevadm info -a -p /sys/class/net/<yourdevice> | grep address.
    Please, note that this is case sensitive and you must use
    lower-case.

Sound
-----

Works out-of-the-box. See ALSA.

Touchpad
--------

See Synaptics.

Video
-----

- For Alienware M11x R1 owners: The Alienware M11x R1 has 2 video cards,
and can be manually changed with the system BIOS (accessed by pushing F2
during system POST) ::

-   Switchable => Linux will use the Intel 4500HD internal video
-   Discrete => Linux will use the NVIDIA GeForce GT 335M

Alienware M11x R1 users running Linux have some tools available which
will interact with the hybrid video cards in this laptop.

-   Bumblebee is a software implementation based on VirtualGL and a
    kernel driver to be able to use the dedicated GPU. Alienware M11x R1
    users CAN use this method to switch between the Onboard/Intel and
    the Discrete/NVIDIA without a system reboot and/or BIOS change (yet
    the BIOS would need to be set for Switchable).
-   acpi_call allows you to disable+power down the Discrete/NVIDIA card
    when the system is booted while BIOS Graphics mode is set to =>
    Switchable
-   vga_switcheroo allows one to switch between the Onboard/Intel and
    the Discrete/NVIDIA without a system reboot and/or BIOS change (yet
    the BIOS would need to be set for Switchable). vga_switcheroo has
    been reported as non-functional at this state for Alienware M11x
    users.

linux-hybrid-graphics.blogspot.com is a great site to check out for
up-to-date information regarding the state of hybrid graphics in Linux.

- For Alienware M11x R2 owners: There are detailed instructions on how
to switch on/off the discrete NVIDIA graphics card on the Optimus (R2)
models for the Alienware M11x laptop.

- For Alienware M11x R3 owners: Many of the methods for running Optimus
& bumblebeed on the M11xR3 are the same or similar to the M11xR2 however
the acpi calls are different for this model.

> Bumblebee

  Bumblebee is a solution to Nvidia Optimus hybrid-graphics technology
  allowing to use the dedicated graphics card for rendering. It was
  started by Martin Juhl.

The Arch Linux Wiki page for Bumblebee explains in detail how-to use
Bumblebee. Be aware it talks about Optimus technology, yet the Alienware
M11x R1 does not have Optimus - later revisions of the M11x
(specifically, the M11x R2 and R3) DO have Optimus. Alienware M11x R1
users have reported success with Bumblebee here.

Below is quick overview on how-to get Bumblebee up-and-running
specifically with Arch Linux, on the Alienware M11x R1. The best
resource for Bumblebee on Arch Linux is the Arch Linux wiki's Bumblebee
page.

1.  In the BIOS Graphics Mode must be set to => Switchable
2.  Grab the following packages from AUR: virtualgl, bumblebee-git,
    dkms, dkms-nvidia, lib32-virtualgl, nvidia-utils-bumblebee,
    lib32-nvidia-utils-bumblebee. Both "lib32-libxv" and "lib32-libxvmc"
    can be obtained from the multilib repository. All lib32-* packages
    are for running 32bit applications on the dedicated NVIDIA video
    card.
3.  Load the 'nvidia' module:

        modprobe nvidia

4.  To have the nvidia module load at boot, add the Nvidia module in the
    "MODULES" array in your /etc/rc.conf:

        MODULES=(... nvidia ...)

5.  Permission to use 'optirun' is granted to all members of the
    'bumblebee' group, so you must add yourself (and other users wanting
    to use bumblebee) to that group:

        usermod -a -G bumblebee <user>

    where <user> is the login name of the user to be added. Then log off
    and on again to apply the group changes.

6.  Bumblebee provides a daemon, to start it simply run:

        rc.d start bumblebee

7.  To start the Bumblebee daemon at boot, add it to your DAEMONS array
    in /etc/rc.conf

        # DAEMONS=(... @bumblebee)

8.  Add dkms_autoinstaller as early as possible to the DAEMONS array in
    /etc/rc.conf

        # DAEMONS=(syslog-ng dkms_autoinstaller ... )

9.  In the /etc/bumblebee/bumblebee.conf file, change the line

        DRIVER='nouveau'

    -TO-

        DRIVER='nvidia'

Bumblebee Usage

To launch an application using the dedicated graphics card:

    $ optirun [options] <application> [application-parameters]

For a list of options for 'optirun' run in a terminal:

    $ optirun --help

If you want to run a 32-bit application on a 64-bit system you may
install the proper 'lib32' packages.

-   All applications will by default run on the integrated/Intel card,
    calling 'optirun' is required to run any applications on the
    dedicated/NVIDIA card.
-   Power Management is still being worked on by the Bumblebee
    developers, for now it is suggested not to use the power management
    features of Bumblebee until this area of code matures.
    -   If you desire to power down the discrete/NVIDIA card while it is
        unused you can run into issues while running Bumblebee, this is
        completely unsupported and not suggested by the Bumblebee
        developers. To do it, follow the 'acpi_call' section in this
        wiki, just be aware you may very well run into "issues".

> ACPI_CALL

ACPI_CALL is a kernel module that enables you to call parameterless ACPI
methods by writing the method name to /proc/acpi/call, e.g. to turn off
the discrete graphics card in a dual graphics environment. acpi_call
works on the Alienware M11x R1 for disabling the discrete video card +
powering it down successfully. Make sure you boot with BIOS set to
switchable' ::

-   Grab the acpi_call-git AUR package(IMHO it is working pretty
    stable), and skip the manual installation/compilation of acpi_call.
    -   OR you can grab acpi_call and compile manually. Please see the
        acpi_call site for details on compilation if you wish to compile
        manually.

acpi_call Usage

    # modprobe acpi_call
    # grep rate /proc/acpi/battery/BAT1/state
    # echo '\_SB.PCI0.P0P2.PEGP._OFF' > /proc/acpi/call
    # grep rate /proc/acpi/battery/BAT1/state

1.  Modprobe the acpi_call module
2.  Check the current battery mW usage (not necessary)
3.  Echo '\_SB.PCI0.P0P2.PEGP._OFF' to (the now existing since acpi_call
    was loaded) /proc/acpi/call
4.  Check the current battery mW usage again to see that it dropped (not
    necessary)

-   Both #2 and #4 as noted are not necessary, they just demonstrate
    that the battery usage is dropping as long as you do them in the
    order listed here.

m11rx2hack

http://forums.fedoraforum.org/showpost.php?p=1402584&postcount=45

m11rx3hack

    #!/bin/sh
    # Based on m11xr2hack by George Shearer

    if ! lsmod | grep -q acpi_call; then
    echo "Error: acpi_call module not loaded"
    exit
    fi

    acpi_call () {
    echo "$*" > /proc/acpi/call
    cat /proc/acpi/call
    }

    case "$1" in
    off)
    echo NVOP $(acpi_call "\_SB.PCI0.PEG0.PEGP.NVOP 0 0x100 0x1A {255,255,255,255}")
    echo _PS3 $(acpi_call "\_SB.PCI0.PEG0.PEGP._PS3")
    ;;
    on)
    echo _PS0 $(acpi_call "\_SB.PCI0.PEG0.PEGP._PS0")
    ;;
    *)
    echo "Usage: $0 [on|off]"
    ;;
    esac

> VGA_SWITCHEROO

Currently, Alienware M11x R1 owner reports indicate the vga_switcheroo
method is not functional.

This explains how-to use VGA_SWITCHEROO for troubleshooting ::

-   kernel configuration flag - ensure CONFIG_VGA_SWITCHEROO is set as
    module, or built-in :: CONFIG_VGA_SWITCHEROO=y/m

    sudo modprobe vgaswitcheroo
    sudo mount -t debugfs none /sys/kernel/debug
    cd /sys/kernel/debug/vgaswitcheroo
    cat switch
      0:+:Pwr:0000:00:02.0
      1: :Pwr:0000:01:00.0

echo "DDIS" > /sys/kernel/debug/vgaswitcheroo/switch <= switch to
discrete card  
 echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch <= switch to
onboard card  
 echo "OFF" > /sys/kernel/debug/vgaswitcheroo/switch <= power-down the
card not in use

Use 'nvidia-settings' to configure the video card, and multiple screens
if using the discrete/NVIDIA card.

> Backlight Brightness

-   When booting into Arch Linux using NVIDIA/discrete video card just
    change brightness using the FUNCTION+F4 = brightness up, and
    FUNCTION+F5 = brightness down - also 'nvidia-settings' should allow
    brightness settings changes too.

-   When booting into Arch Linux using the INTEL/onboard video card, the
    only way to change brightness levels requires passing a command
    through 'setpci', the following script is adapted from
    Samsung_N150-Backlight ArchWiki article works fine (ymmv).
    REQUIREMENTS: bc, and setpci

1.  create a file @ /sbin/backlight
2.  sudo chown root:video /sbin/backlight
3.  sudo chmod 750 /sbin/backlight
4.  make sure to add the username allowed to change the backlight
    settings to the video group in /etc/group
5.  create an alias in your shell startup, and turn the brightness up or
    down via command, in turn you could tie this to a button combination
    in your xwindow manager settings.

.bashrc

    alias brup='/sbin/backlight up'
    alias brdown='/sbin/backlight down'
    alias brget='/sbin/backlight get'

.tcshrc

    alias brup '/sbin/backlight up'
    alias brdown '/sbin/backlight down'
    alias brget '/sbin/backlight get'

/sbin/backlight

    #!/bin/bash
    # increase/decrease/set/get the backlight brightness (range 0-255) by 16
    #
    #get current brightness in hex and convert to decimal
    #
    # REQUIRES: bc, and setpci
    var1=`sudo /usr/sbin/setpci -s 00:02.0 F4.B`
    var1d=$((0x$var1))
     case "$1" in
           up)
                  #calculate new brightness
                  var2=`echo "ibase=10; obase=16; a=($var1d+16);if (a<255) print a else print 255" | bc`
                  echo "$0: increasing brightness from 0x$var1 to 0x$var2"
                  sudo /usr/sbin/setpci -s 00:02.0 F4.B=$var2
                  ;;
           down)
                  #calculate new brightness
                  var2=`echo "ibase=10; obase=16; a=($var1d-16);if (a>15) print a else print 15" | bc`
                  echo "$0: decreasing brightness from 0x$var1 to 0x$var2"
                  sudo /usr/sbin/setpci -s 00:02.0 F4.B=$var2
                  ;;
           set)
                  #n.b. this does allow "set 0" i.e. backlight off
                  echo "$0: setting brightness to 0x$2"
                  sudo /usr/sbin/setpci -s 00:02.0 F4.B=$2
                  ;;
           get)
                  echo "$0: current brightness is 0x$var1"
                  ;;
           toggle)
                  if [ $var1d -eq 0 ] ; then
                          echo "toggling up"
                          sudo /usr/sbin/setpci -s 00:02.0 F4.B=FF
                  else
                          echo "toggling down"
                          sudo /usr/sbin/setpci -s 00:02.0 F4.B=0
                  fi
                  ;;
           *)
                  echo "usage: $0 {up|down|set <val>|get|toggle}"
                  ;;
     esac
    exit 0

Lighting and colors
-------------------

> AlienFX

AlienFX Lite is (according to the author's page) "a simple
cross-platform program to create profiles and set the AlienFX lightning
to the set colors. This application was done for the Allpowerfull M15x
and only tested on this machine. It should also work on the M17x. The
application will most likely accept the Area 51 m15x but it was
untested. The current supported platforms are: Linux (32 bit), Linux(64
bit), Mac OS X(UNTESTED), Windows 7(64 bit), Windows 7 (32 bit), Windows
Vista (32bit), Windows Vista 64bit, Windows XP"

In order to install AlienFX:

-   install alienfx-lite from the AUR.
-   then run /usr/bin/alienFX-lite to start the Java applet (a script
    that changes to proper directory, and runs
    sudo $JAVA_HOME/bin/java -jar /usr/share/alienFX-lite/AlienFXLite-0.4b.jar)

Also: alienFX-lite thread for overview, videos, support and interaction
with the developer (Wattos@NBR) directly.

> pyalienfx

pyalienfx: "This project intends to create a multiplatform python
software to control the AlienFX device of Alienware computer." Install
it from the AUR:

    $ yaourt -S pyalienfx

To use it:

    $ pyalienfx

> Other applications

-   A C-program which cycles through colors, plus information about how
    to understand it, can be found at [1].

laptop-init-script
------------------

laptop-init-script is small rc.d script located in
(/etc/rc.d/laptop-init) that is quite helpful for many laptop
optimizations, check it out if interested.

You can install laptop-init-script from the AUR.

...to be continued...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Alienware_M11x&oldid=248119"

Category:

-   Alienware
