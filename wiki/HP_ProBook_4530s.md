HP ProBook 4530s
================

  --------------- --------- ----------------------------
  Device          Status    Modules
  Graphics        Working   xf86-video-intel
  Bluetooth       Working   bluetooth
  Ethernet        Working   r8169
  Wireless        Working   ath9k
  Audio           Working   snd_hda_intel
  Camera          Working   uvcvideo
  Card Reader     Working   sdhci/sdhci_pci, jmb38x_ms
  Function Keys   Working   hp_wmi
  --------------- --------- ----------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Device information                                                 |
|     -   1.1 lspci                                                        |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Network                                                      |
|     -   2.2 Bluetooth                                                    |
|         -   2.2.1 hciconfig -a                                           |
|                                                                          |
|     -   2.3 Graphics                                                     |
|         -   2.3.1 Brightness                                             |
|                                                                          |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Miscellaneous hardware                                       |
|         -   2.5.1 Card reader                                            |
|         -   2.5.2 Function keys                                          |
|         -   2.5.3 Camera                                                 |
|                                                                          |
|     -   2.6 Power                                                        |
|     -   2.7 Suspend/hibernation                                          |
|         -   2.7.1 Sensors                                                |
+--------------------------------------------------------------------------+

Device information
------------------

This model has many hardware configurations. Mine has an i3 processor,
Intel HD3000 video card, and an Atheros AR9285 Wi-Fi card.

> lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
    00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b4)
    00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 (rev b4)
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    23:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 30)
    23:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 30)
    23:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 30)
    24:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
    25:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
    26:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)

Configuration
-------------

> Network

Both wired and wireless network works out-of-the-box. Atheros card
requires ath9k module, Realtek ethernet card requires r8169 module. More
information on Wireless Setup#ath9k

Note:With some revisions of this Realtek ethernet card, one may find
better performance from the Realtek provided r8168 module, available in
the official repositories.

> Bluetooth

Sending/receiving files, switching bluetooth on/off works. Requires
ath3k module.

hciconfig -a

    hci0:	Type: BR/EDR  Bus: USB
    	BD Address: D0:DF:9A:91:B2:51  ACL MTU: 1022:8  SCO MTU: 121:3
    	UP RUNNING PSCAN ISCAN 
    	RX bytes:1823103 acl:11471 sco:0 events:10296 errors:0
    	TX bytes:334040 acl:9846 sco:0 commands:259 errors:0
    	Features: 0xff 0xfe 0x0d 0xfe 0x98 0x7f 0x79 0x87
    	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
    	Link policy: RSWITCH HOLD SNIFF 
    	Link mode: SLAVE ACCEPT 
    	Name: '4530s'
    	Class: 0x580100
    	Service Classes: Capturing, Object Transfer, Telephony
    	Device Class: Computer, Uncategorized
    	HCI Version: 3.0 (0x5)  Revision: 0x9999
    	LMP Version: 3.0 (0x5)  Subversion: 0x9999
    	Manufacturer: Atheros Communications, Inc. (69)

> Graphics

Intel HD3000 card is supported by open-source xf86-video-intel driver.
Dual-head with HDMI works.

    pacman -S xf86-video-intel

Brightness

Controlling brightness with Fn+F2 and Fn+F3 buttons works in Gnome 3,
did not test in other DEs.

> Touchpad

Works with xf86-input-synaptics package. Could not get it to switch off
while double tapped in top-left corner, like it worked in Suse Linux
Enterprise Desktop, which was factory OS. Tested tapping, two- and
three-finger tapping and two-finger scrolling.

    pacman -S xf86-input-synaptics

> Miscellaneous hardware

Card reader

    23:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 30)
    23:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 30)
    23:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 30)

SD cards tested and working. Memory Stick cards do not work, despite
having module jmb38x_ms loaded. Dmesg does not show any info about
Memory Stick card being inserted. With 3.4.7 kernel, Memory Stick card
works as intended.

Function keys

Module hp-wmi is likely to be required for the keys to work. In Gnome 3
every Fn+F* key works. Fn-F6 key requires gnome-power-manager installed.
Keys above numeric keypad are also recognized. The Web key has a
XF86HomePage symbol (opens home page) and Wi-Fi key has NoSymbol and
does nothing.

Camera

Works with uvcvideo module.

> Power

Module acpi-cpufreq and at least one of CPU governors (cpufreq_ondemand,
cpufreq_conservative, etc.) are required. More informations on CPU
Frequency Scaling.

Note:i915 module parameter i915_enable_rc6 can give up to 2 hours of
additional battery life. However it is considered unstable and might
cause crashes and graphical glitches. Add i915.i915_enable_rc6=1 to your
kernel line in bootloader to try it.

Note:With laptop-mode-tools, tune from powertop2 and i915_enable_rc6
parameter I was able to get about 5:30h of estimated battery life.

Note:Keep in mind that the powertop "good/bad" parameters will not
survive a reboot. As of 3.4.x rc6 is enabled by default for Ivy Bridge
and Sandy Bridge processors. The default (marked -1) is equivalent of
i915_enable_rc6=3 which enables rc6 and rc6p. An additional, lower power
state can also be enabled by using i915_enable_rc6=7, though this has
been reported to sometimes come at the cost of stability. Also, as of
2011Q4 the i915 module in Sandy Bridge and Ivy Bridge also have
framebuffer compression enabled by default.

> Suspend/hibernation

Both suspend and hibernation work with pm-utils and kernel backend.

Sensors

Lm-sensors shows one acpitz-virtual device with 4 working temperature
readings and coretemp-isa device which has one sensor for each CPU core.
It does not show any info about fans RPMs.

    pacman -S lm_sensors

    acpitz-virtual-0
    Adapter: Virtual device
    temp1:        +51.0°C  (crit = +128.0°C)
    temp2:         +0.0°C  (crit = +128.0°C)
    temp3:        +38.0°C  (crit = +128.0°C)
    temp4:        +50.0°C  (crit = +128.0°C)
    temp5:        +26.0°C  (crit = +128.0°C)
    temp6:         +0.0°C  (crit = +128.0°C)
    temp7:         +0.0°C  (crit = +128.0°C)
    temp8:         +0.0°C  (crit = +128.0°C)

    coretemp-isa-0000
    Adapter: ISA adapter
    Physical id 0:  +53.0°C  (high = +80.0°C, crit = +85.0°C)
    Core 0:         +49.0°C  (high = +80.0°C, crit = +85.0°C)
    Core 1:         +50.0°C  (high = +80.0°C, crit = +85.0°C)

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_ProBook_4530s&oldid=234917"

Category:

-   HP
