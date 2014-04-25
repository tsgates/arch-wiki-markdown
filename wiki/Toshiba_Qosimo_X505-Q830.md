Toshiba Qosimo X505-Q830
========================

Contents
--------

-   1 lspci
-   2 Video
-   3 Networking
    -   3.1 Wired
    -   3.2 Wireless
-   4 Audio
    -   4.1 Internal Mic
    -   4.2 HDMI Audio
-   5 Touchpad
-   6 Function keys
-   7 Other special keys
-   8 Webcam
-   9 USB

> lspci

    00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
    00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11)
    00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
    00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
    00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
    00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
    00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
    00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 05)
    00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 05)
    00:1c.6 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 7 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation GT215 [GeForce GTS 250M] (rev a2)
    01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
    07:00.0 FireWire (IEEE 1394): O2 Micro, Inc. Device 10f7 (rev 01)
    07:00.1 SD Host controller: O2 Micro, Inc. Device 8120 (rev 01)
    07:00.2 Mass storage controller: O2 Micro, Inc. Device 8130 (rev 01)
    0a:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
    0b:00.0 Ethernet controller: Atheros Communications AR8131 Gigabit Ethernet (rev c0)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-Core Registers (rev 04)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 04)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 04)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 04)
    ff:03.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller (rev 04)
    ff:03.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Target Address Decoder (rev 04)
    ff:03.4 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Test Registers (rev 04)
    ff:04.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Control Registers (rev 04)
    ff:04.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Address Registers (rev 04)
    ff:04.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Rank Registers (rev 04)
    ff:04.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Thermal Control Registers (rev 04)
    ff:05.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Control Registers (rev 04)
    ff:05.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Address Registers (rev 04)
    ff:05.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Rank Registers (rev 04)
    ff:05.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Thermal Control Registers (rev 04)

> Video

Nvidia

HDMI output: if it plugged in at boot time, the default monitor will be
the *external* monitor (for the console). Use nvidia-settings to
enable/disable external monitor.

Have tested Blu-Ray playback, with VDPAU(?)-enabled media player, works
fine.

> Networking

Wired

Works out of the box.

Wireless

Requires additional drivers: rtl8192se (or dkms-rtl8192se) Kernel
version 3.0 introduced drivers out-of-the-box for this chipset:


    [✍]  ~ $ modinfo rtl8192se                                                                                                                                                         
    filename:       /lib/modules/3.0-ARCH/kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko.gz
    firmware:       rtlwifi/rtl8192sefw.bin
    description:    Realtek 8192S/8191S 802.11n PCI wireless
    license:        GPL
    author:         Realtek WlanFAE <wlanfae@realtek.com>
    author:         lizhaoming      <chaoming_li@realsil.com.cn>
    alias:          pci:v000010ECd00008174sv*sd*bc*sc*i*
    alias:          pci:v000010ECd00008173sv*sd*bc*sc*i*
    alias:          pci:v000010ECd00008172sv*sd*bc*sc*i*
    alias:          pci:v000010ECd00008171sv*sd*bc*sc*i*
    alias:          pci:v000010ECd00008192sv*sd*bc*sc*i*
    depends:        rtlwifi,mac80211
    vermagic:       3.0-ARCH SMP preempt mod_unload 
    parm:           fwlps:bool
    parm:           swenc:using hardware crypto (default 0 [hardware])
     (bool)
    parm:           ips:using no link power save (default 1 is open)
     (bool)
    parm:           swlps:using linked sw control power save (default 1 is open)
     (bool)

> Audio

Internal Mic

To get the internal mic working, somewhere under /modprobe.d:

    options snd-hda-intel model=dell-vostro

HDMI Audio

To get HDMI audio out working, per This Arch forums thread: In
/etc/modprobe.d/sound.conf:

     options snd-hda-intel probe_mask=0xffff,0xfff2

The HDMI audio ALSA device is then plughw:1,3, and can be tested like
so:

     aplay -D plughw:1,3 /usr/share/sounds/alsa/Noise.wav

> Touchpad

Works, does not require additional drivers/software.

> Function keys

Some function keys work (when typed with with FN key):

-   ESC- Toggles muted on/off
-   F3- Hibernate (save state to disk and powers off)
-   F6- Brightness down
-   F7- Brightness up
-   F9- Toggle touchpad on/off

> Other special keys

-   The small button above the touchpad to toggle touchpad on/off works
-   The mute toggle on/off on the left side
-   The volume up/down buttons on the left side

> Webcam

Works out of the box, tested in KDE and with Skype.

> USB

Works out of the box.

Note: When booting from USB, the drives change during boot. When
prompted that the boot drive can not be found, remove and re-insert the
USB stick.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Qosimo_X505-Q830&oldid=196738"

Category:

-   Toshiba

-   This page was last modified on 23 April 2012, at 13:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
