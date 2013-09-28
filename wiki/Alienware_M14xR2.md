Alienware M14xR2
================

This wiki page documents the configuration and troubleshooting specific
to the Alienware M14xR2 laptop.

See the Beginners' Guide for installation instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specifications                                              |
|     -   1.1 Base model                                                   |
|     -   1.2 Ports                                                        |
|     -   1.3 lspci output                                                 |
|                                                                          |
| -   2 Ethernet                                                           |
| -   3 Wireless LAN & Bluetooth                                           |
| -   4 Sound                                                              |
| -   5 Touchpad                                                           |
| -   6 Video                                                              |
| -   7 AlienFX                                                            |
| -   8 Known Bugs                                                         |
+--------------------------------------------------------------------------+

System Specifications
---------------------

The M14xR2 base model comes with the following options:

Base model

-   Intel® Core™ i5 or i7
-   6GB or 8GB or 12GB or 16GB of 1600MHz DDR3 RAM
-   1GB or 2GB GDDR5 NVIDIA® GeForce® GT 650M
-   1366x768 or 1600x900 WLED TrueLife 14" screen
-   750GB or 1000GB SATA drives and SSD until 500GB
-   SuperMulti 8x DVD±R/RW or Blu-ray double layer reader BD-ROM,
    DVD+RW, CD-RW
-   8 cell Lithium-ion battery (63 W/h)
-   1,3 megapixel webcap with 2 microphones
-   Optional 4.0 bluetooth
-   Wireless N capable

Ports

-   RJ-45 Gigabit Ethernet
-   SuperSpeed USB 3.0 (2x)
-   Hi-Speed USB 2.0 with PowerShare technology
-   Mini display port
-   HDMI 1.4
-   VGA port
-   9 in 1 card reader
-   Audio jack 1/8" (2x)
-   Input audio jack 1/8" (can be used for 5.1 audio output)
-   Security port

lspci output

    00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
    00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GT 650M] (rev ff)
    01:00.1 Audio device: NVIDIA Corporation GK107 HDMI Audio Controller (rev ff)
    07:00.0 Ethernet controller: Atheros Communications Inc. AR8151 v2.0 Gigabit Ethernet (rev c0)
    08:00.0 Network controller: Atheros Communications Inc. AR9462 Wireless Network Adapter (rev 01)
    09:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader (rev 01)
    09:00.1 SD Host controller: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader (rev 01)

Ethernet
--------

The AR8132 Ethernet controller uses the atl1c module and works
out-of-the-box with Linux kernel 3.x.

    # lspci -kv
    07:00.0 Ethernet controller: Atheros Communications Inc. AR8151 v2.0 Gigabit Ethernet (rev c0)
    	Subsystem: Dell Device 0552
    	Flags: bus master, fast devsel, latency 0, IRQ 48
    	Memory at d2600000 (64-bit, non-prefetchable) [size=256K]
    	I/O ports at 2000 [size=128]
    	Capabilities: <access denied>
    	Kernel driver in use: atl1c

    # modinfo atl1c
    filename:       /lib/modules/3.7.9-2-ARCH/kernel/drivers/net/ethernet/atheros/atl1c/atl1c.ko.gz
    version:        1.0.1.0-NAPI
    license:        GPL
    description:    Qualcom Atheros 100/1000M Ethernet Network Driver
    author:         Qualcomm Atheros Inc., <nic-devel@qualcomm.com>
    author:         Jie Yang
    srcversion:     1A550ECB609B4B690B47528
    alias:          pci:v00001969d00001083sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001073sv*sd*bc*sc*i*
    alias:          pci:v00001969d00002062sv*sd*bc*sc*i*
    alias:          pci:v00001969d00002060sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001062sv*sd*bc*sc*i*
    alias:          pci:v00001969d00001063sv*sd*bc*sc*i*
    depends:        
    intree:         Y
    vermagic:       3.7.9-2-ARCH SMP preempt mod_unload modversions 

    # dmesg | grep -i atl1c
    [    6.052602] atl1c 0000:07:00.0: version 1.0.1.0-NAPI
    [   17.706845] atl1c 0000:07:00.0: irq 48 for MSI/MSI-X

Wireless LAN & Bluetooth
------------------------

Alienware M14xR2 comes with the AR9462 chipset which provides WLAN and
Bluetooth capabilities.

    # lspci -kv
    08:00.0 Network controller: Atheros Communications Inc. AR9462 Wireless Network Adapter (rev 01)
    	Subsystem: Bigfoot Networks, Inc. Device 2003
    	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    	Latency: 0, Cache Line Size: 64 bytes
    	Interrupt: pin A routed to IRQ 18
    	Region 0: Memory at d2500000 (64-bit, non-prefetchable) [size=512K]
    	Expansion ROM at 9fb00000 [disabled] [size=64K]
    	Capabilities: [40] Power Management version 3
    		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
    		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
    		Address: 0000000000000000  Data: 0000
    		Masking: 00000000  Pending: 00000000
    	Capabilities: [70] Express (v2) Endpoint, MSI 00
    		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
    			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
    			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
    			MaxPayload 128 bytes, MaxReadReq 512 bytes
    		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
    			ClockPM- Surprise- LLActRep- BwNot-
    		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
    			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF Not Supported
    		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
    		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
    			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
    			 Compliance De-emphasis: -6dB
    		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
    			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    	Capabilities: [100 v1] Advanced Error Reporting
    		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
    		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
    		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
    		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
    		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
    		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    	Capabilities: [140 v1] Virtual Channel
    		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
    		Arb:	Fixed- WRR32- WRR64- WRR128-
    		Ctrl:	ArbSelect=Fixed
    		Status:	InProgress-
    		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
    			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
    			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
    			Status:	NegoPending- InProgress-
    	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
    	Kernel driver in use: ath9k

Wireless LAN is working out of the box with the ath9k module:

    # modinfo ath9k
    filename:       /lib/modules/3.7.9-2-ARCH/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko.gz
    license:        Dual BSD/GPL
    description:    Support for Atheros 802.11n wireless LAN cards.
    author:         Atheros Communications
    alias:          platform:qca955x_wmac
    alias:          platform:ar934x_wmac
    alias:          platform:ar933x_wmac
    alias:          platform:ath9k
    alias:          pci:v0000168Cd00000036sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000037sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000034sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000033sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000032sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000030sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
    alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
    alias:          pci:v0000168Cd0000002Csv*sd*bc*sc*i*
    alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
    alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
    alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
    depends:        ath9k_hw,ath9k_common,mac80211,ath,cfg80211
    intree:         Y
    vermagic:       3.7.9-2-ARCH SMP preempt mod_unload modversions 
    parm:           debug:Debugging mask (uint)
    parm:           nohwcrypt:Disable hardware encryption (int)
    parm:           blink:Enable LED blink on activity (int)
    parm:           btcoex_enable:Enable wifi-BT coexistence (int)
    parm:           enable_diversity:Enable Antenna diversity for AR9565 (int)

Bluetooth support is comming with kernel 3.8 as noted in this changelog.
Our device is AR9462 (Foxconn / Hon Hai [0489:e04e]).

As 28 of March, using kernel 3.8.4, there's no bluetooth support. A bug
should be filled.

Sound
-----

Alsa works out of the box except for headphone detection but a lot of
people complains on bugs on our chipset CA0132 that also affect to
M17xR4.

Changes are coming on 3.9 kernel, see this.

NOTE: At some point, my audio stopped working and I tried everithing. It
didn't work until I formated and reinstalled everything.

Touchpad
--------

TODO

Video
-----

Since kernel 3.5 PRIME technology is officially supported by the nouveau
graphic drivers. This means that Nvidia Optimus used in this computer is
supported. Anyway you need to install bumblebee for letting
vgaswitcheroo disable your graphics card.

In kernel 3.7 power managing methods were add so that battery life
increased a lot.

AlienFX
-------

AlienFX on Alienware M14xR2 is only supported by pyalienfx that can be
installed from AUR.

You can visit pyalienfx project webpage for reporting issues.

Known Bugs
----------

-   [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS error appears
    on dmesg. More information on this bugzilla report.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Alienware_M14xR2&oldid=253821"

Category:

-   Alienware
