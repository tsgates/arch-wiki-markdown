AHCI
====

  Summary
  ---------------------------------------------------
  Enabling AHCI data transfer mode for SATA devices

AHCI, abbreviation for advanced host controller interface, is the native
work mode for SATA drives, and has been present in the Linux kernel
since version 2.6.19.

While SATA drives are usually configured as legacy/parallel ATA by
default, enabling AHCI through the BIOS has two main benefits: support
for hot pluggable SATA drives (mimicking USB drives' behavior) and NCQ,
or native command queuing.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Add the AHCI module to the kernel image                            |
| -   2 Configure from BIOS                                                |
| -   3 Pitfalls                                                           |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

Add the AHCI module to the kernel image
---------------------------------------

Edit /etc/mkinitcpio.conf and add ahci to the MODULES variable:

    MODULES="ahci"

Rebuild the kernel image so that it includes the newly added module:

    # mkinitcpio -p linux

Configure from BIOS
-------------------

The way for accessing the BIOS depends on the motherboard; usually, Del
is used to display the menu.

Once the BIOS options are available, search for parameters resembling:

    Enable SATA as: IDE/AHCI

or:

    SATA: PATA Emulation/Native/Enhanced

Choose AHCI or Native, save the settings and exit the BIOS. Consult the
motherboard's manual if it's not clear which of the modes is AHCI, since
the naming can vary.

After altering and saving the BIOS settings, Linux should load the AHCI
driver on the next boot. dmesg's output should confirm this:

    SCSI subsystem initialized
    libata version 3.00 loaded.
    ahci 0000:00:1f.2: version 3.0
    ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
    ahci 0000:00:1f.2: irq 764 for MSI/MSI-X
    ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
    ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
    ahci 0000:00:1f.2: setting latency timer to 64
    scsi0 : ahci
    scsi1 : ahci
    scsi2 : ahci
    scsi3 : ahci
    scsi4 : ahci
    scsi5 : ahci

and for NCQ:

    ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)

Pitfalls
--------

-   Windows XP does not have stock AHCI drivers. A user with SATA drives
    wishing to enable AHCI mode and dual-boot into Windows XP will need
    AHCI drivers for their motherboard. This issue does not affect
    Windows Vista onwards.
-   During booting, if there is a delay before GRUB appears, check BIOS
    settings. There might be an option that introduces such a delay so
    that "lazy" optical drives are able to boot.

Resources
---------

-   AHCI on Wikipedia
-   NCQ on Wikipedia

Retrieved from
"https://wiki.archlinux.org/index.php?title=AHCI&oldid=206371"

Category:

-   Storage
