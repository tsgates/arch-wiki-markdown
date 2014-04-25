HP Pavilion dv7-3110er
======================

  Description help replacing me
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  This article is written from personal experience and the experience gained from resource archlinux.org. I would like to express my gratitude for creating this resource.

Contents
--------

-   1 Hardware
-   2 lspci (All)
-   3 lspci (nVidia)
-   4 lsusb
-   5 lsusb (Validity Sensors, Inc. VFS301 - 138a:0005)
-   6 lsmod
-   7 cpuinfo
-   8 modprobe
-   9 Makepkg.conf
-   10 Wireless
-   11 Network
-   12 System
-   13 Need Help With

Hardware
--------

-   CPU:
    -   Microprocessor 1.60 GHz Intel Core processor i7-720QM
    -   Microprocessor Cache 6 MB Level 2 cache
-   Memory: 2 slots - ships with 2x2GB DDR3
-   GPU:
    -   NVIDIA GeForce GT 230M, Up to 2815 MB (1 GB dedicated)
-   Display: 17.3” Diagonal HD+ High-Definition HP LED BrightView
    Widescreen Display (1600 x 900)
-   Multimedia:
    -   Sound:

Intel Corporation 5 Series/3400 Series Chipset High Definition Audio
(Intel HDA)

nVidia Corporation High Definition Audio Controller (nVidia HDA)

-   -   Speakers: Altec Lansing with SRS Premium Sound and Sub-woofer
        (?)
    -   WebCam: integrated HP webcam
-   Net
    -   Wireless: Broadcom Corporation BCM4312 802.11b/g LP-PHY
    -   Ethernet: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
        Express Gigabit Ethernet controller

lspci (All)
-----------


    00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: fast devsel
    	Capabilities: <access denied>

    00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11) (prog-if 00 [Normal decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    	I/O behind bridge: 00006000-00006fff
    	Memory behind bridge: d2000000-d30fffff
    	Prefetchable memory behind bridge: 00000000c0000000-00000000d1ffffff
    	Capabilities: <access denied>
    	Kernel driver in use: pcieport
    	Kernel modules: shpchp

    00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
    	Subsystem: Device 003c:005c
    	Flags: fast devsel
    	Capabilities: <access denied>

    00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
    	Subsystem: Device 003c:005c
    	Flags: fast devsel
    	Capabilities: <access denied>

    00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
    	Subsystem: Device 003c:005c
    	Flags: fast devsel
    	Capabilities: <access denied>

    00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
    	Subsystem: Device 003c:005c
    	Flags: fast devsel

    00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
    	Flags: fast devsel

    00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
    	Flags: fast devsel

    00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, medium devsel, latency 0, IRQ 16
    	Memory at db105c00 (32-bit, non-prefetchable) [size=1K]
    	Capabilities: <access denied>
    	Kernel driver in use: ehci_hcd
    	Kernel modules: ehci-hcd

    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 47
    	Memory at db100000 (64-bit, non-prefetchable) [size=16K]
    	Capabilities: <access denied>
    	Kernel driver in use: snd_hda_intel
    	Kernel modules: snd-hda-intel

    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05) (prog-if 00 [Normal decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    	I/O behind bridge: 00005000-00005fff
    	Memory behind bridge: da100000-db0fffff
    	Prefetchable memory behind bridge: 00000000d3100000-00000000d40fffff
    	Capabilities: <access denied>
    	Kernel driver in use: pcieport
    	Kernel modules: shpchp

    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05) (prog-if 00 [Normal decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    	I/O behind bridge: 00004000-00004fff
    	Memory behind bridge: d9100000-da0fffff
    	Prefetchable memory behind bridge: 00000000d4100000-00000000d50fffff
    	Capabilities: <access denied>
    	Kernel driver in use: pcieport
    	Kernel modules: shpchp

    00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 05) (prog-if 00 [Normal decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    	I/O behind bridge: 00003000-00003fff
    	Memory behind bridge: d8100000-d90fffff
    	Prefetchable memory behind bridge: 00000000d5100000-00000000d60fffff
    	Capabilities: <access denied>
    	Kernel driver in use: pcieport
    	Kernel modules: shpchp

    00:1c.7 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 8 (rev 05) (prog-if 00 [Normal decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=05, subordinate=08, sec-latency=0
    	I/O behind bridge: 00002000-00002fff
    	Memory behind bridge: d7100000-d80fffff
    	Prefetchable memory behind bridge: 00000000d6100000-00000000d70fffff
    	Capabilities: <access denied>
    	Kernel driver in use: pcieport
    	Kernel modules: shpchp

    00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, medium devsel, latency 0, IRQ 21
    	Memory at db105800 (32-bit, non-prefetchable) [size=1K]
    	Capabilities: <access denied>
    	Kernel driver in use: ehci_hcd
    	Kernel modules: ehci-hcd

    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5) (prog-if 01 [Subtractive decode])
    	Flags: bus master, fast devsel, latency 0
    	Bus: primary=00, secondary=09, subordinate=09, sec-latency=32
    	Capabilities: <access denied>

    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, medium devsel, latency 0
    	Capabilities: <access denied>
    	Kernel modules: iTCO_wdt

    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 45
    	I/O ports at 7048 [size=8]
    	I/O ports at 7054 [size=4]
    	I/O ports at 7040 [size=8]
    	I/O ports at 7050 [size=4]
    	I/O ports at 7020 [size=32]
    	Memory at db105000 (32-bit, non-prefetchable) [size=2K]
    	Capabilities: <access denied>
    	Kernel driver in use: ahci

    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: medium devsel, IRQ 19
    	Memory at db106000 (64-bit, non-prefetchable) [size=256]
    	I/O ports at 7000 [size=32]
    	Kernel driver in use: i801_smbus
    	Kernel modules: i2c-i801

    01:00.0 VGA compatible controller: nVidia Corporation GT216 [GeForce GT 230M] (rev a2) (prog-if 00 [VGA controller])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 16
    	Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
    	Memory at c0000000 (64-bit, prefetchable) [size=256M]
    	Memory at d0000000 (64-bit, prefetchable) [size=32M]
    	I/O ports at 6000 [size=128]
    	[virtual] Expansion ROM at d3080000 [disabled] [size=512K]
    	Capabilities: <access denied>
    	Kernel driver in use: nvidia
    	Kernel modules: nouveau, nvidia, nvidiafb

    01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 48
    	Memory at d3000000 (32-bit, non-prefetchable) [size=16K]
    	Capabilities: <access denied>
    	Kernel driver in use: snd_hda_intel
    	Kernel modules: snd-hda-intel

    02:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g LP-PHY (rev 01)
    	Subsystem: Hewlett-Packard Company Device 1508
    	Flags: bus master, fast devsel, latency 0, IRQ 16
    	Memory at da100000 (64-bit, non-prefetchable) [size=16K]
    	Capabilities: <access denied>
    	Kernel driver in use: b43-pci-bridge
    	Kernel modules: ssb

    03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 46
    	I/O ports at 4000 [size=256]
    	Memory at d4104000 (64-bit, prefetchable) [size=4K]
    	Memory at d4100000 (64-bit, prefetchable) [size=16K]
    	Expansion ROM at d4110000 [disabled] [size=64K]
    	Capabilities: <access denied>
    	Kernel driver in use: r8168
    	Kernel modules: r8169, r8168

    04:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (prog-if 10 [OHCI])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 16
    	Memory at d8100000 (32-bit, non-prefetchable) [size=2K]
    	Memory at d8100d00 (32-bit, non-prefetchable) [size=128]
    	Memory at d8100c80 (32-bit, non-prefetchable) [size=128]
    	Memory at d8100c00 (32-bit, non-prefetchable) [size=128]
    	Capabilities: <access denied>
    	Kernel driver in use: firewire_ohci
    	Kernel modules: firewire-ohci

    04:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 16
    	Memory at d8100b00 (32-bit, non-prefetchable) [size=256]
    	Capabilities: <access denied>
    	Kernel driver in use: sdhci-pci
    	Kernel modules: sdhci-pci

    04:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (prog-if 01)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: fast devsel, IRQ 16
    	Memory at d8100a00 (32-bit, non-prefetchable) [size=256]
    	Capabilities: <access denied>
    	Kernel modules: sdhci-pci

    04:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 16
    	Memory at d8100900 (32-bit, non-prefetchable) [size=256]
    	Capabilities: <access denied>
    	Kernel driver in use: jmb38x_ms
    	Kernel modules: jmb38x_ms

    04:00.4 System peripheral: JMicron Technology Corp. xD Host Controller
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0, IRQ 11
    	Memory at d8100800 (32-bit, non-prefetchable) [size=256]
    	Capabilities: <access denied>

    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-Core Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0
    	Kernel driver in use: i7core_edac
    	Kernel modules: i7core_edac

    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:03.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:03.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Target Address Decoder (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:03.4 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Test Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:04.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Control Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:04.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Address Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:04.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Rank Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:04.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Thermal Control Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:05.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Control Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:05.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Address Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:05.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Rank Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

    ff:05.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Thermal Control Registers (rev 04)
    	Subsystem: Hewlett-Packard Company Device 365c
    	Flags: bus master, fast devsel, latency 0

lspci (nVidia)
--------------

    01:00.0 VGA compatible controller: nVidia Corporation GT216 [GeForce GT 230M] (rev a2) (prog-if 00 [VGA controller])
    	Subsystem: Hewlett-Packard Company Device 365c
    	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    	Latency: 0
    	Interrupt: pin A routed to IRQ 16
    	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
    	Region 1: Memory at c0000000 (64-bit, prefetchable) ['''size=256M''']
    	Region 3: Memory at d0000000 (64-bit, prefetchable) [size=32M]
    	Region 5: I/O ports at 6000 [size=128]
    	[virtual] Expansion ROM at d3080000 [disabled] [size=512K]
    	Capabilities: [60] Power Management version 3
    		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
    		Address: 0000000000000000  Data: 0000
    	Capabilities: [78] Express (v2) Endpoint, MSI 00
    		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
    			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
    			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
    			MaxPayload 128 bytes, MaxReadReq 256 bytes
    		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
    			ClockPM+ Surprise- LLActRep- BwNot-
    		LnkCtl:	ASPM L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
    			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
    		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
    		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
    			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
    			 Compliance De-emphasis: -6dB
    		LnkSta2: Current De-emphasis Level: -6dB
    	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
    	Capabilities: [100 v1] Virtual Channel
    		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
    		Arb:	Fixed- WRR32- WRR64- WRR128-
    		Ctrl:	ArbSelect=Fixed
    		Status:	InProgress-
    		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
    			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
    			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
    			Status:	NegoPending- InProgress-
    	Capabilities: [128 v1] Power Budgeting <?>
    	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
    	Kernel driver in use: nvidia
    	Kernel modules: nouveau, nvidia, nvidiafb

  

lsusb
-----

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 003: ID 138a:0005 Validity Sensors, Inc. VFS301 Fingerprint Reader
    Bus 002 Device 004: ID 064e:c107 Suyin Corp. HP webcam [dv6-1190en]

lsusb (Validity Sensors, Inc. VFS301 - 138a:0005)
-------------------------------------------------

    Bus 002 Device 003: ID 138a:0005 Validity Sensors, Inc. VFS301 Fingerprint Reader
    libusb couldn't open USB device /dev/bus/usb/002/003: Permission denied.
    libusb requires write access to USB device nodes.
    Couldn't open device, some information will be missing
    Device Descriptor:
      bLength                18
      bDescriptorType         1
      bcdUSB               1.10
      bDeviceClass          255 Vendor Specific Class
      bDeviceSubClass        16 
      bDeviceProtocol       255 
      bMaxPacketSize0         8
      idVendor           0x138a Validity Sensors, Inc.
      idProduct          0x0005 VFS301 Fingerprint Reader
      bcdDevice            c.90
      iManufacturer           0 
      iProduct                0 
      iSerial                 1 
      bNumConfigurations      1
      Configuration Descriptor:
        bLength                 9
        bDescriptorType         2
        wTotalLength           39
        bNumInterfaces          1
        bConfigurationValue     1
        iConfiguration          0 
        bmAttributes         0xa0
          (Bus Powered)
          Remote Wakeup
        MaxPower              100mA
        Interface Descriptor:
          bLength                 9
          bDescriptorType         4
          bInterfaceNumber        0
          bAlternateSetting       0
          bNumEndpoints           3
          bInterfaceClass       255 Vendor Specific Class
          bInterfaceSubClass      0 
          bInterfaceProtocol      0 
          iInterface              0 
          Endpoint Descriptor:
            bLength                 7
            bDescriptorType         5
            bEndpointAddress     0x01  EP 1 OUT
            bmAttributes            2
              Transfer Type            Bulk
              Synch Type               None
              Usage Type               Data
            wMaxPacketSize     0x0040  1x 64 bytes
            bInterval               0
          Endpoint Descriptor:
            bLength                 7
            bDescriptorType         5
            bEndpointAddress     0x81  EP 1 IN
            bmAttributes            2
              Transfer Type            Bulk
              Synch Type               None
              Usage Type               Data
            wMaxPacketSize     0x0040  1x 64 bytes
            bInterval               0
          Endpoint Descriptor:
            bLength                 7
            bDescriptorType         5
            bEndpointAddress     0x82  EP 2 IN
            bmAttributes            2
              Transfer Type            Bulk
              Synch Type               None
              Usage Type               Data
            wMaxPacketSize     0x0040  1x 64 bytes
            bInterval               0

lsmod
-----

    Module                  Size  Used by
    ipv6                  277723  44 
    fuse                   67066  2 
    r8168                 201694  0 
    ext2                   61132  1 
    snd_hda_codec_hdmi     21981  4 
    snd_hda_codec_idt      54851  1 
    snd_hda_intel          21666  2 
    snd_hda_codec          76028  3 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel
    snd_hwdep               5837  1 snd_hda_codec
    snd_pcm                71096  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
    vboxdrv              1778833  1 
    arc4                    1306  2 
    uvcvideo               62796  0 
    videodev               80332  1 uvcvideo
    v4l2_compat_ioctl32     8252  1 videodev
    b43                   314502  0 
    mac80211              213579  1 b43
    cfg80211              162516  2 b43,mac80211
    i7core_edac            15712  0 
    edac_core              34697  3 i7core_edac
    i2c_i801                8053  0 
    iTCO_wdt               11597  0 
    ir_lirc_codec           4211  0 
    lirc_dev                8847  1 ir_lirc_codec
    snd_timer              18419  1 snd_pcm
    bcma                   16339  1 b43
    iTCO_vendor_support     1761  1 iTCO_wdt
    ir_mce_kbd_decoder      4078  0 
    ir_sony_decoder         2115  0 
    ir_jvc_decoder          2209  0 
    snd                    54266  11 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
    sdhci_pci               8496  0 
    snd_page_alloc          6729  2 snd_hda_intel,snd_pcm
    sdhci                  21798  1 sdhci_pci
    firewire_ohci          28682  0 
    firewire_core          48408  1 firewire_ohci
    crc_itu_t               1257  1 firewire_core
    jmb38x_ms               7961  0 
    memstick                6366  1 jmb38x_ms
    ssb                    46055  1 b43
    mmc_core               67237  3 b43,sdhci,ssb
    pcmcia                 34681  2 b43,ssb
    pcmcia_core            11414  1 pcmcia
    psmouse                53509  0 
    serio_raw               3998  0 
    rc_rc6_mce              1308  0 
    ir_rc6_decoder          2785  0 
    ir_rc5_decoder          2209  0 
    joydev                  9575  0 
    acpi_cpufreq            5773  1 
    mperf                   1171  1 acpi_cpufreq
    ir_nec_decoder          2593  0 
    hp_wmi                  7386  0 
    sparse_keymap           2952  1 hp_wmi
    rfkill                 14554  3 cfg80211,hp_wmi
    ene_ir                 14143  0 
    rc_core                14690  10 ir_lirc_codec,ir_mce_kbd_decoder,ir_sony_decoder,ir_jvc_decoder,rc_rc6_mce,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,ene_ir
    video                  10773  0 
    evdev                   9146  12 
    ext4                  258793  2 
    mbcache                 5521  2 ext2,ext4
    jbd2                   52260  1 ext4
    crc16                   1257  1 ext4
    usbhid                 34012  0 
    hid                    55205  1 usbhid
    sd_mod                 27507  5 
    sr_mod                 14695  0 
    cdrom                  35915  1 sr_mod
    ehci_hcd               39794  0 
    usbcore               136838  4 uvcvideo,usbhid,ehci_hcd
    nvidia              12066749  44 

cpuinfo
-------

cat /proc/cpuinfo


    processor	: 0
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 0
    cpu cores	: 4
    apicid		: 0
    initial apicid	: 0
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm 
    constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 
    popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3192.09
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 1
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 1
    cpu cores	: 4
    apicid		: 2
    initial apicid	: 2
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.95
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 2
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 2
    cpu cores	: 4
    apicid		: 4
    initial apicid	: 4
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.94
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 3
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 3
    cpu cores	: 4
    apicid		: 6
    initial apicid	: 6
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.94
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 4
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 0
    cpu cores	: 4
    apicid		: 1
    initial apicid	: 1
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.95
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 5
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 1
    cpu cores	: 4
    apicid		: 3
    initial apicid	: 3
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.94
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 6
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 2
    cpu cores	: 4
    apicid		: 5
    initial apicid	: 5
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.94
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 7
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 30
    model name	: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz
    stepping	: 5
    cpu MHz		: 933.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 8
    core id		: 3
    cpu cores	: 4
    apicid		: 7
    initial apicid	: 7
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 11
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp 
    lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 
    sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
    bogomips	: 3191.95
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

modprobe
--------

cat /etc/modprobe.d/alsa-base.conf

    options snd-hda-intel enable_msi=1
    options snd-hda-intel model=hp-dv5

(for headphones on linux kernel > 3)

---

cat /etc/modprobe.d/modprobe.conf

    #
    # /etc/modprobe.d/modprobe.conf
    #
    #options nvidia NVreg_Mobile=3
    options nvidia NVreg_DeviceFileUID=0 NVreg_DeviceFileGID=33 NVreg_DeviceFileMode=0660 NVreg_SoftEDIDs=0 NVreg_Mobile=1

Makepkg.conf
------------

cat /etc/makepkg.conf

    #
    # /etc/makepkg.conf
    #

    #########################################################################
    # SOURCE ACQUISITION
    #########################################################################
    #
    #-- The download utilities that makepkg should use to acquire sources
    #  Format: 'protocol::agent'
    DLAGENTS=('ftp::/usr/bin/wget -c --passive-ftp -t 3 --waitretry=3 -O %o %u'
              'http::/usr/bin/wget -c -t 3 --waitretry=3 -O %o %u'
              'https::/usr/bin/wget -c -t 3 --waitretry=3 --no-check-certificate -O %o %u'
              'rsync::/usr/bin/rsync -z %u %o'
              'scp::/usr/bin/scp -C %u %o')
    #DLAGENTS=('ftp::/usr/bin/aria2c %u --no-conf -s 2 -m 2 -d / -o %o'
    #          'http::/usr/bin/aria2c %u -o %o'
    #          'https::/usr/bin/aria2c %u -o %o'
    #          'rsync::/usr/bin/rsync -z %u %o'
    #          'scp::/usr/bin/scp -C %u %o')
    # Other common tools:
    # /usr/bin/snarf
    # /usr/bin/lftpget -c
    # /usr/bin/curl

    #########################################################################
    # ARCHITECTURE, COMPILE FLAGS
    #########################################################################
    #
    CARCH="x86_64"
    CHOST="x86_64-unknown-linux-gnu"

    #-- Exclusive: will only run on x86_64
    # -march (or -mcpu) builds exclusively for an architecture
    # -mtune optimizes for an architecture, but builds for whole processor family
    CFLAGS="-march=corei7 -mtune=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
    CXXFLAGS="-march=corei7 -mtune=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
    #LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,--hash-style=gnu"
    #-- Make Flags: change this for DistCC/SMP systems
    MAKEFLAGS="-j9"

    #########################################################################
    # BUILD ENVIRONMENT
    #########################################################################
    #
    # Defaults: BUILDENV=(fakeroot !distcc color !ccache check)
    #  A negated environment option will do the opposite of the comments below.
    #
    #-- fakeroot: Allow building packages as a non-root user
    #-- distcc:   Use the Distributed C/C++/ObjC compiler
    #-- color:    Colorize output messages
    #-- ccache:   Use ccache to cache compilation
    #-- check:    Run the check() function if present in the PKGBUILD
    #
    BUILDENV=(fakeroot !distcc color !ccache check)
    #
    #-- If using DistCC, your MAKEFLAGS will also need modification. In addition,
    #-- specify a space-delimited list of hosts running in the DistCC cluster.
    #DISTCC_HOSTS=""

    #########################################################################
    # GLOBAL PACKAGE OPTIONS
    #   These are default values for the options=() settings
    #########################################################################
    #
    # Default: OPTIONS=(strip docs libtool emptydirs zipman purge)
    #  A negated option will do the opposite of the comments below.
    #
    #-- strip:     Strip symbols from binaries/libraries
    #-- docs:      Save doc directories specified by DOC_DIRS
    #-- libtool:   Leave libtool (.la) files in packages
    #-- emptydirs: Leave empty directories in packages
    #-- zipman:    Compress manual (man and info) pages in MAN_DIRS with gzip
    #-- purge:     Remove files specified by PURGE_TARGETS
    #
    OPTIONS=(strip docs libtool emptydirs zipman purge)

    #-- File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512
    INTEGRITY_CHECK=(md5)
    #-- Options to be used when stripping binaries. See `man strip' for details.
    STRIP_BINARIES="--strip-all"
    #-- Options to be used when stripping shared libraries. See `man strip' for details.
    STRIP_SHARED="--strip-unneeded"
    #-- Options to be used when stripping static libraries. See `man strip' for details.
    STRIP_STATIC="--strip-debug"
    #-- Manual (man and info) directories to compress (if zipman is specified)
    MAN_DIRS=({usr{,/local}{,/share},opt/*}/{man,info})
    #-- Doc directories to remove (if !docs is specified)
    DOC_DIRS=(usr/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc})
    #-- Files to be removed from all packages (if purge is specified)
    PURGE_TARGETS=(usr/{,share}/info/dir .packlist *.pod)

    #########################################################################
    # PACKAGE OUTPUT
    #########################################################################
    #
    # Default: put built package and cached source in build directory
    #
    #-- Destination: specify a fixed directory where all packages will be placed
    #PKGDEST=/home/packages
    #-- Source cache: specify a fixed directory where source files will be cached
    #SRCDEST=/home/sources
    #-- Source packages: specify a fixed directory where all src packages will be placed
    #SRCPKGDEST=/home/srcpackages
    #-- Packager: name/email of the person or organization building packages
    #PACKAGER="John Doe <tuxuls@gmail.conf>"

    #########################################################################
    # EXTENSION DEFAULTS
    #########################################################################
    #
    # WARNING: Do NOT modify these variables unless you know what you are
    #          doing.
    #
    PKGEXT='.pkg.tar.xz'
    SRCEXT='.src.tar.gz'

    # vim: set ft=sh ts=2 sw=2 et:

Wireless
--------

yaourt -S b43-fwcutter b43-firmware

modprobe -a b43 ssb

* * * * *

nano /etc/rc.conf

    MODULES=(... b43 ssb ... )

Network
-------

yaourt -S r8168

rmmod r8169

modprobe -a r8168

* * * * *

nano /etc/rc.conf

    MODULES=(... r8168 ... )

System
------

Distribution: Arch Linux (x86_64)

DE: Gnome

Kernel: linux-pf

Need Help With
--------------

- Validity Sensors, Inc. VFS301 Fingerprint Reader (not found variants
to configure)

- nVidia GeForce GT 230M (sees only 256 MB of video RAM), need for swap
on video ram

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv7-3110er&oldid=207231"

Category:

-   HP

-   This page was last modified on 13 June 2012, at 15:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
