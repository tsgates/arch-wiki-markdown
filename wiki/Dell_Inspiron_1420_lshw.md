Dell Inspiron 1420/lshw
=======================

Output of lshw on a Dell Inspiron 1420

    hostname              
       description: Portable Computer
       product: Inspiron 1420
       vendor: Dell Inc.
       serial: 1BMHTG1
       width: 32 bits
       capabilities: smbios-2.4 dmi-2.4
       configuration: boot=normal chassis=portable uuid=44454C4C-4200-104D-8048-B1C04F544731
     *-core
          description: Motherboard
          product: 0JX269
          vendor: Dell Inc.
          physical id: 0
          serial: .1BMHTG1.CN7878385A04QS.
        *-firmware
             description: BIOS
             vendor: Dell Inc.
             physical id: 0
             version: A08 (04/21/2008)
             size: 64KiB
             capacity: 960KiB
             capabilities: isa pci pcmcia pnp upgrade shadowing cdboot bootselect int13floppy720 int5printscreen int9keyboard int14serial int17printer int10video acpi usb agp smartbattery biosbootspecification netboot
        *-cpu
             description: CPU
             product: Intel(R) Core(TM)2 Duo CPU     T5850  @ 2.16GHz
             vendor: Intel Corp.
             physical id: 400
             bus info: cpu@0
             version: 6.15.13
             serial: 0000-06FD-0000-0000-0000-0000
             slot: Microprocessor
             size: 2167MHz
             capacity: 2167MHz
             width: 64 bits
             clock: 166MHz
             capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx x86-64 constant_tsc arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm cpufreq
             configuration: id=0
           *-cache:0
                description: L1 cache
                physical id: 700
                size: 32KiB
                capacity: 32KiB
                capabilities: internal write-back data
           *-cache:1
                description: L2 cache
                physical id: 701
                size: 2MiB
                capacity: 2MiB
                clock: 66MHz (15.0ns)
                capabilities: pipeline-burst internal varies unified
           *-logicalcpu:0
                description: Logical CPU
                physical id: 0.1
                width: 64 bits
                capabilities: logical
           *-logicalcpu:1
                description: Logical CPU
                physical id: 0.2
                width: 64 bits
                capabilities: logical
        *-memory
             description: System Memory
             physical id: 1000
             slot: System board or motherboard
             size: 3GiB
           *-bank:0
                description: DIMM DDR Synchronous 667 MHz (1.5 ns)
                product: HYMP125S64CP8-Y5
                vendor: AD00000000000000
                physical id: 0
                serial: 00006052
                slot: DIMM_A
                size: 2GiB
                width: 64 bits
                clock: 667MHz (1.5ns)
           *-bank:1
                description: DIMM DDR Synchronous 667 MHz (1.5 ns)
                product: HYMP112S64CP6-Y5
                vendor: AD00000000000000
                physical id: 1
                serial: 00004016
                slot: DIMM_B
                size: 1GiB
                width: 64 bits
                clock: 667MHz (1.5ns)
        *-pci
             description: Host bridge
             product: Mobile PM965/GM965/GL960 Memory Controller Hub
             vendor: Intel Corporation
             physical id: 100
             bus info: pci@0000:00:00.0
             version: 0c
             width: 32 bits
             clock: 33MHz
           *-pci:0
                description: PCI bridge
                product: Mobile PM965/GM965/GL960 PCI Express Root Port
                vendor: Intel Corporation
                physical id: 1
                bus info: pci@0000:00:01.0
                version: 0c
                width: 32 bits
                clock: 33MHz
                capabilities: pci pm msi pciexpress normal_decode bus_master cap_list
                configuration: driver=pcieport-driver
              *-display
                   description: VGA compatible controller
                   product: GeForce 8400M GS
                   vendor: nVidia Corporation
                   physical id: 0
                   bus info: pci@0000:01:00.0
                   version: a1
                   width: 64 bits
                   clock: 33MHz
                   capabilities: pm msi pciexpress vga_controller bus_master cap_list
                   configuration: driver=nvidia latency=0 module=nvidia
           *-usb:0
                description: USB Controller
                product: 82801H (ICH8 Family) USB UHCI Contoller #4
                vendor: Intel Corporation
                physical id: 1a
                bus info: pci@0000:00:1a.0
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0 module=uhci_hcd
           *-usb:1
                description: USB Controller
                product: 82801H (ICH8 Family) USB UHCI Controller #5
                vendor: Intel Corporation
                physical id: 1a.1
                bus info: pci@0000:00:1a.1
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0 module=uhci_hcd
           *-usb:2
                description: USB Controller
                product: 82801H (ICH8 Family) USB2 EHCI Controller #2
                vendor: Intel Corporation
                physical id: 1a.7
                bus info: pci@0000:00:1a.7
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pm debug ehci bus_master cap_list
                configuration: driver=ehci_hcd latency=0 module=ehci_hcd
           *-multimedia
                description: Audio device
                product: 82801H (ICH8 Family) HD Audio Controller
                vendor: Intel Corporation
                physical id: 1b
                bus info: pci@0000:00:1b.0
                version: 02
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
                configuration: driver=HDA Intel latency=0 module=snd_hda_intel
           *-pci:1
                description: PCI bridge
                product: 82801H (ICH8 Family) PCI Express Port 1
                vendor: Intel Corporation
                physical id: 1c
                bus info: pci@0000:00:1c.0
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
                configuration: driver=pcieport-driver
           *-pci:2
                description: PCI bridge
                product: 82801H (ICH8 Family) PCI Express Port 2
                vendor: Intel Corporation
                physical id: 1c.1
                bus info: pci@0000:00:1c.1
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
                configuration: driver=pcieport-driver
              *-network
                   description: Wireless interface
                   product: BCM4310 USB Controller
                   vendor: Broadcom Corporation
                   physical id: 0
                   bus info: pci@0000:0c:00.0
                   logical name: wlan0
                   version: 01
                   serial: 00:1f:e2:c6:5a:3b
                   width: 64 bits
                   clock: 33MHz
                   capabilities: pm msi pciexpress bus_master cap_list ethernet physical wireless
                   configuration: broadcast=yes driver=ndiswrapper+bcmwl5 driverversion=1.52+Broadcom,09/20/2007, 4.170. ip=192.168.10.9 latency=0 link=yes module=ndiswrapper multicast=yes wireless=IEEE 802.11g
           *-pci:3
                description: PCI bridge
                product: 82801H (ICH8 Family) PCI Express Port 4
                vendor: Intel Corporation
                physical id: 1c.3
                bus info: pci@0000:00:1c.3
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
                configuration: driver=pcieport-driver
           *-pci:4
                description: PCI bridge
                product: 82801H (ICH8 Family) PCI Express Port 6
                vendor: Intel Corporation
                physical id: 1c.5
                bus info: pci@0000:00:1c.5
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
                configuration: driver=pcieport-driver
              *-network
                   description: Ethernet interface
                   product: NetLink BCM5906M Fast Ethernet PCI Express
                   vendor: Broadcom Corporation
                   physical id: 0
                   bus info: pci@0000:09:00.0
                   logical name: eth0
                   version: 02
                   serial: 00:1e:c9:08:00:c5
                   capacity: 100MB/s
                   width: 64 bits
                   clock: 33MHz
                   capabilities: pm vpd msi pciexpress bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd autonegotiation
                   configuration: autonegotiation=on broadcast=yes driver=tg3 driverversion=3.90 latency=0 link=no module=tg3 multicast=yes port=twisted pair
           *-usb:3
                description: USB Controller
                product: 82801H (ICH8 Family) USB UHCI Controller #1
                vendor: Intel Corporation
                physical id: 1d
                bus info: pci@0000:00:1d.0
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0 module=uhci_hcd
           *-usb:4
                description: USB Controller
                product: 82801H (ICH8 Family) USB UHCI Controller #2
                vendor: Intel Corporation
                physical id: 1d.1
                bus info: pci@0000:00:1d.1
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0 module=uhci_hcd
           *-usb:5
                description: USB Controller
                product: 82801H (ICH8 Family) USB UHCI Controller #3
                vendor: Intel Corporation
                physical id: 1d.2
                bus info: pci@0000:00:1d.2
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: uhci bus_master
                configuration: driver=uhci_hcd latency=0 module=uhci_hcd
           *-usb:6
                description: USB Controller
                product: 82801H (ICH8 Family) USB2 EHCI Controller #1
                vendor: Intel Corporation
                physical id: 1d.7
                bus info: pci@0000:00:1d.7
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pm debug ehci bus_master cap_list
                configuration: driver=ehci_hcd latency=0 module=ehci_hcd
           *-pci:5
                description: PCI bridge
                product: 82801 Mobile PCI Bridge
                vendor: Intel Corporation
                physical id: 1e
                bus info: pci@0000:00:1e.0
                version: f2
                width: 32 bits
                clock: 33MHz
                capabilities: pci subtractive_decode bus_master cap_list
              *-firewire
                   description: FireWire (IEEE 1394)
                   product: R5C832 IEEE 1394 Controller
                   vendor: Ricoh Co Ltd
                   physical id: 1
                   bus info: pci@0000:03:01.0
                   version: 05
                   width: 32 bits
                   clock: 33MHz
                   capabilities: pm ohci bus_master cap_list
                   configuration: driver=firewire_ohci latency=64 maxlatency=4 mingnt=2 module=firewire_ohci
              *-system:0
                   description: SD Host controller
                   product: R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter
                   vendor: Ricoh Co Ltd
                   physical id: 1.1
                   bus info: pci@0000:03:01.1
                   version: 22
                   width: 32 bits
                   clock: 33MHz
                   capabilities: pm bus_master cap_list
                   configuration: driver=sdhci latency=64 module=sdhci
              *-system:1
                   description: System peripheral
                   product: R5C592 Memory Stick Bus Host Adapter
                   vendor: Ricoh Co Ltd
                   physical id: 1.2
                   bus info: pci@0000:03:01.2
                   version: 12
                   width: 32 bits
                   clock: 33MHz
                   capabilities: pm bus_master cap_list
                   configuration: driver=ricoh-mmc latency=64 module=ricoh_mmc
              *-system:2 UNCLAIMED
                   description: System peripheral
                   product: xD-Picture Card Controller
                   vendor: Ricoh Co Ltd
                   physical id: 1.3
                   bus info: pci@0000:03:01.3
                   version: 12
                   width: 32 bits
                   clock: 33MHz
                   capabilities: pm bus_master cap_list
                   configuration: latency=64
              *-generic UNCLAIMED
                   product: Illegal Vendor ID
                   vendor: Illegal Vendor ID
                   physical id: 1.4
                   bus info: pci@0000:03:01.4
                   version: ff
                   width: 32 bits
                   clock: 66MHz
                   capabilities: bus_master vga_palette cap_list
                   configuration: latency=255 maxlatency=255 mingnt=255
           *-isa
                description: ISA bridge
                product: 82801HEM (ICH8M) LPC Interface Controller
                vendor: Intel Corporation
                physical id: 1f
                bus info: pci@0000:00:1f.0
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: isa bus_master cap_list
                configuration: latency=0
           *-ide
                description: IDE interface
                product: 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller
                vendor: Intel Corporation
                physical id: 1f.1
                bus info: pci@0000:00:1f.1
                logical name: scsi3
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: ide bus_master emulated
                configuration: driver=ata_piix latency=0 module=ata_piix
              *-cdrom
                   description: DVD-RAM writer
                   product: DVD+-RW TS-L632H
                   vendor: TSSTcorp
                   physical id: 0.0.0
                   bus info: scsi@3:0.0.0
                   logical name: /dev/cdrom
                   logical name: /dev/cdrom0
                   logical name: /dev/cdrw
                   logical name: /dev/cdrw0
                   logical name: /dev/dvd
                   logical name: /dev/dvd0
                   logical name: /dev/scd0
                   logical name: /dev/sr0
                   version: D400
                   capabilities: removable audio cd-r cd-rw dvd dvd-r dvd-ram
                   configuration: ansiversion=5 status=nodisc
           *-storage
                description: SATA controller
                product: 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller
                vendor: Intel Corporation
                physical id: 1f.2
                bus info: pci@0000:00:1f.2
                logical name: scsi0
                version: 02
                width: 32 bits
                clock: 66MHz
                capabilities: storage msi pm ahci_1.0 bus_master cap_list emulated
                configuration: driver=ahci latency=0 module=ahci
              *-disk
                   description: ATA Disk
                   product: Hitachi HTS72201
                   vendor: Hitachi
                   physical id: 0.0.0
                   bus info: scsi@0:0.0.0
                   logical name: /dev/sda
                   version: DCDO
                   serial: 080616DP1D80DGGKMZUT
                   size: 149GiB (160GB)
                   capabilities: partitioned partitioned:dos
                   configuration: ansiversion=5 signature=00000080
                 *-volume:0
                      description: Linux swap volume
                      physical id: 1
                      bus info: scsi@0:0.0.0,1
                      logical name: /dev/sda1
                      version: 1
                      serial: 3df9f91d-beb0-421b-8ce6-b4e74c4203dc
                      size: 1027MiB
                      capacity: 1027MiB
                      capabilities: primary nofs swap initialized
                      configuration: filesystem=swap pagesize=4096
                 *-volume:1
                      description: Windows NTFS volume
                      physical id: 2
                      bus info: scsi@0:0.0.0,2
                      logical name: /dev/sda2
                      version: 3.1
                      serial: 4e355124-86ed-254d-8a3c-e6e179d4ce4d
                      size: 45GiB
                      capacity: 45GiB
                      capabilities: primary bootable ntfs initialized
                      configuration: clustersize=4096 created=2008-07-19 14:38:45 filesystem=ntfs label=Vista state=clean
                 *-volume:2
                      description: EXT3 volume
                      vendor: Linux
                      physical id: 3
                      bus info: scsi@0:0.0.0,3
                      logical name: /dev/sda3
                      logical name: /
                      version: 1.0
                      serial: e8bd8fd6-30b0-49e7-be36-3d0d6e0f77dc
                      size: 99GiB
                      capacity: 99GiB
                      capabilities: primary journaled extended_attributes large_files huge_files recover ext3 ext2 initialized
                      configuration: created=2008-07-19 14:38:08 filesystem=ext3 modified=2008-07-24 10:59:13 mount.fstype=ext3 mount.options=rw,errors=continue,data=ordered mounted=2008-07-24 10:59:13 state=mounted
                 *-volume:3
                      description: Extended partition
                      physical id: 4
                      bus info: scsi@0:0.0.0,4
                      logical name: /dev/sda4
                      size: 3074MiB
                      capacity: 3074MiB
                      capabilities: primary extended partitioned partitioned:extended
                    *-logicalvolume
                         physical id: 5
                         logical name: /dev/sda5
                         capacity: 3074MiB
           *-serial
                description: SMBus
                product: 82801H (ICH8 Family) SMBus Controller
                vendor: Intel Corporation
                physical id: 1f.3
                bus info: pci@0000:00:1f.3
                version: 02
                width: 32 bits
                clock: 33MHz
                configuration: driver=i801_smbus latency=0 module=i2c_i801
     *-battery
          product: DELL KX11785
          vendor: SMP
          physical id: 1
          slot: Sys. Battery Bay
          capacity: 78000mWh
          configuration: voltage=11.1V

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1420/lshw&oldid=196558"

Category:

-   Dell
