Lenovo ThinkPad x121e
=====================

  Summary help replacing me
  --------------------------------------------------
  Installation notes for the Lenovo ThinkPad x121e

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

ThinkWiki x121e reference

Note that there are several models of this laptop. The notes below refer
to the model with the following specification and options:

-   Intel(R) Core(TM) i3-2367M CPU @ 1.40GHz GenuineIntel
-   Board 3045CTO
-   Intel Centrino Wireless-N 1000 (Note: this is not the default
    option)
-   US keyboard with Euro
-   320G HDD

Working out of the box:

-   graphics (intel_agp,i915 are loaded automatically; add i915 to the
    modules in mkinitcpio.conf for support during early boot)
-   wifi (with Intel Centrino Wireless-N 1000 option)
-   sound (with ALSA)
-   touchpad (with synaptics)
-   trackpoint
-   most function keys
-   suspend to RAM
-   suspend to disk
-   boot from MBR partitioned disk in BIOS mode (note: there must be at
    least one primary partition flagged as bootable)
-   webcam
-   microphone (barely - it does capture sound but it is unusably noisy
    on my setup)
-   headphones (tested with Gnome 3.4)
-   2 "Think" LEDs
-   HDD in AHCI mode
-   boot from USB key, USB HDD, internal HDD

  
 Working but not out of the box:

-   boot from GPT partitioned disk in UEFI mode (with hack to work
    around buggy firmware - see here and forum links below)
-   bluetooth (with BIOS upgrade - see below)

Partly working:

-   VGA out to external monitor (connection generally goes OK but
    disconnect frequently freezes X and sometimes causes hard lock up
    forcing cold reboot; could be configuration or DE related - see
    below)
-   SD card reader : In order to read SDHC cards, you need to install
    and run as daemon the Ricoh e823 fix

Not working:

-   boot from GPT partitioned disk in BIOS mode

Untested:

-   HDMI out
-   security chip thing
-   boot from USB FDD, network boot

Contents
--------

-   1 Arch user blogs about the x121e
-   2 Power saving options for the x121e
-   3 Bluetooth
-   4 Broadcom BCM43224 a/b/g/n wifi
-   5 Arch Forums x121e related threads

Arch user blogs about the x121e
-------------------------------

Power saving options for the x121e
----------------------------------

In /etc/rc.conf, add acpi-cpufreq to the MODULES array to enable CPU
frequency scaling. If you use laptop-mode-tools, that's enough.
Otherwise, add the governor you want to use, too e.g. cpufreq_ondemand.

Then add the following to the DAEMONS array:

-   either laptop-mode or cpufreq
-   acpid
-   sensors (if you want to monitor fan speed, temperature etc.)

thinkpad_acpi should be loaded automatically. Check this with lsmod |
grep think.

Add to the kernel command line:

    pcie_aspm=force i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.semaphores=1

Warning:Do not add these options without checking them out first as they
may cause problems depending on your setup. Be prepared to disable them
as necessary.

If using laptop-mode-tools stops your machine from shutting down while
on battery power, try the solution described in this thread.

tp_smapi does not currently support the x121e and is apparently not
likely to do so in the foreseeable future. Apparently the x121e is not
quite a "real" ThinkPad.

Bluetooth
---------

Getting bluetooth enabled can be a bit tricky. If bluetooth doesn't work
or stops working and cannot be unblocked by rfkill, check first that it
is enabled in the BIOS. If that isn't the problem, you may need a BIOS
upgrade (see below).

Even after a BIOS upgrade, it seems that bluetooth may stop working in
some cases. For example, changing the RAM in my machine seems to result
in a hard block which rfkill can't touch even though bluetooth is
enabled in BIOS. Repeating the post-bios-upgrade procedure of loading
the default BIOS settings, booting and then redoing your custom settings
seems to help. (I don't know if the reboot with the default settings is
actually needed or if loading the defaults, saving them and then
re-customising would be enough.) If you do this, remember that you may
need to re-add grub to your boot menu to get everything working normally
again. (This applies to GRUB2, at least.)

Broadcom BCM43224 a/b/g/n wifi
------------------------------

    $ lspci -vnn | grep 14e4:
    02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/g/n [14e4:0576] (rev 01)

Wifi can be enabled using the broadcom brcmsmac module. Be sure to
rfkill-enable it and disable power saving :

    $ ip link set eth1 down
    $ iwconfig eth1 channel auto
    $ iwconfig eth1 power off
    $ rfkill unblock wifi
    $ ip link set eth1 up

Arch Forums x121e related threads
---------------------------------

Some people experience difficulties booting if their disk is partitioned
using a GPT partition map. The correct way to avoid this problem is to
ensure that the EFI partition is at least 512M. The UEFI wiki page now
includes this instruction. If for some bizarre reason you do not wish to
do this, it may work to use a GPT partition map, UEFI boot and a fat 16
formatted EFI partition (this violates UEFI spec but may have the
advantage of actually working). See
https://bbs.archlinux.org/viewtopic.php?id=131149 and
https://bbs.archlinux.org/viewtopic.php?id=133074.

If bluetooth doesn't work or stops working and cannot be unblocked by
rfkill, check that it is enabled in the BIOS. If that's not the problem,
a BIOS upgrade may help. See
https://bbs.archlinux.org/viewtopic.php?id=137346. If that doesn't help
either, boot to BIOS, reload the defaults, reconfigure BIOS and reboot.
Note that this will wipe any entries in the EFI boot menu. (If anybody
knows a less annoying way, please comment!)

Speed up trackpoint: https://bbs.archlinux.org/viewtopic.php?id=130130.

Solution for difficulties suspending or hibernating:
https://bbs.archlinux.org/viewtopic.php?id=125011.

VGA disconnect problems:
https://bbs.archlinux.org/viewtopic.php?id=134886. The best "solution"
appears to be to make the VGA output inactive before pulling the plug.
This seems to prevent the confusion which otherwise ensues.

If you cannot power off when running on battery, see this thread for a
possible solution: https://bbs.archlinux.org/viewtopic.php?id=133108.
This seems to be unnecessary with systemd which is now default.

If you get errors on boot or resume complaining about the TPM, try
changing the settings for the security chip in the BIOS as described in
this thread.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_x121e&oldid=263947"

Category:

-   Lenovo

-   This page was last modified on 23 June 2013, at 10:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
