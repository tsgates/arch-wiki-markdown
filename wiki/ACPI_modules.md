ACPI modules
============

From ACPI site:

ACPI (Advanced Configuration and Power Interface) is an open industry
specification co-developed by Hewlett-Packard, Intel, Microsoft,
Phoenix, and Toshiba.

ACPI modules are kernel modules for different ACPI parts. They enable
special ACPI functions or add information to /proc or /sys. These
information can be parsed by acpid for events or other monitoring
applications.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Which modules are available?                                       |
| -   2 How to select the correct ones                                     |
| -   3 Getting Information                                                |
| -   4 Troubleshooting                                                    |
|     -   4.1 DSDT fix                                                     |
|     -   4.2 ACPI fix for notebooks                                       |
|     -   4.3 Acpica                                                       |
+--------------------------------------------------------------------------+

Which modules are available?
----------------------------

This is a small list and summary of ACPI kernel modules:

-   ac (power connector status)
-   asus-laptop (useful on ASUS/medion laptops)
-   battery (battery status)
-   bay (bay status)
-   button (catch button events, like LID or POWER BUTTON)
-   container (container status)
-   dock (docking station status)
-   fan (fan status)
-   i2c_ec (EC SMBUs driver)
-   thinkpad_acpi (useful on Lenovo Thinkpad laptops)
-   processor (processor status)
-   sbs (smart battery status)
-   thermal (status of thermal sensors)
-   toshiba_acpi (useful for Toshiba laptops)
-   video (status of video devices)

complete list of your running kernel:

    $ ls -l /usr/lib/modules/$(uname -r)/kernel/drivers/acpi

    total 112
    -rw-r--r-- 1 root root  2808 Aug 29 23:58 ac.ko.gz
    -rw-r--r-- 1 root root  3021 Aug 29 23:58 acpi_ipmi.ko.gz
    -rw-r--r-- 1 root root  3354 Aug 29 23:58 acpi_memhotplug.ko.gz
    -rw-r--r-- 1 root root  4628 Aug 29 23:58 acpi_pad.ko.gz
    drwxr-xr-x 2 root root  4096 Aug 29 23:59 apei
    -rw-r--r-- 1 root root  7120 Aug 29 23:58 battery.ko.gz
    -rw-r--r-- 1 root root  3700 Aug 29 23:58 button.ko.gz
    -rw-r--r-- 1 root root  2181 Aug 29 23:58 container.ko.gz
    -rw-r--r-- 1 root root  1525 Aug 29 23:58 custom_method.ko.gz
    -rw-r--r-- 1 root root  1909 Aug 29 23:58 ec_sys.ko.gz
    -rw-r--r-- 1 root root  2001 Aug 29 23:58 fan.ko.gz
    -rw-r--r-- 1 root root  1532 Aug 29 23:58 hed.ko.gz
    -rw-r--r-- 1 root root  3241 Aug 29 23:58 pci_slot.ko.gz
    -rw-r--r-- 1 root root 17742 Aug 29 23:58 processor.ko.gz
    -rw-r--r-- 1 root root  3073 Aug 29 23:58 sbshc.ko.gz
    -rw-r--r-- 1 root root  7098 Aug 29 23:58 sbs.ko.gz
    -rw-r--r-- 1 root root  6311 Aug 29 23:58 thermal.ko.gz
    -rw-r--r-- 1 root root  8891 Aug 29 23:58 video.ko.gz

How to select the correct ones
------------------------------

You have to try yourself which module works for your machine:

    # modprobe <yourmodule>

then check if the module is supported on your hardware by using

    $ dmesg

Tip: It may help to add a grep text search to narrow your results.

    $ dmesg | grep acpi
    [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
    [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
    [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
    [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
    [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
    [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
    [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
    [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
    [    5.066752] ACPI: acpi_idle yielding to intel_idle
    [    5.438998] acpi device:04: registered as cooling_device4

Add the working ones to configuration files in /etc/modules-load.d
according to the pattern described in man modules-load.d.

Getting Information
-------------------

To read out battery information you can simply install package acpi in
Official Repositories and run:

    acpi -i

Using /proc to store ACPI information has been discouraged and
deprecated since 2.6.24. The same data is available in /sys now and
interested parties can (should) subscribe to ACPI events from the kernel
via netlink.E.g for battery:

    /sys/class/power_supply/BAT0/

Troubleshooting
---------------

> DSDT fix

If problems with power management persist despite having loaded the
proper modules, a Linux-unfriendly DSDT might be the cause. See the wiki
article on DSDT.

> ACPI fix for notebooks

Sometimes you see "ACPI: EC: input buffer is not empty, aborting
transaction". This is a problem with acpi, more specifically an
incompatibility of the BIOS. There are four ways to solve this:

1. Update your BIOS.

2. "Easy" Put acpi=off in the kernel line in menu.lst (if you are using
GRUB), but that will kill all acpi functionality like battery charging
and power saving.

3. In some cases (such as here) the following has been reported to solve
the issue. However, screen brightness may no longer be fully
controllable.

    $ xset dpms force off

4. "Hard" build your kernel with patch bugs.launchpad.net.

5.seems fixed in 3.6 pf

  
 If notebook doesn't start just remove AC adapter and remove battery for
5 sec and start without AC!

> Acpica

Installing Acpica from the AUR may fix suspend-related lockups on some
machines.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ACPI_modules&oldid=254173"

Category:

-   Power management
