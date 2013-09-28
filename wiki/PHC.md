PHC
===

  ------------------------ ------------------------ ------------------------
  [Tango-preferences-deskt This article or section  [Tango-preferences-deskt
  op-locale.png]           needs to be translated.  op-locale.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

Provides a guide to installing, configuring and using a PHC.

Related articles

Laptop

Pm-utils

CPU Frequency Scaling

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Alternative to PHC                                           |
|                                                                          |
| -   2 Supported CPUs                                                     |
|     -   2.1 Intel                                                        |
|     -   2.2 AMD                                                          |
|                                                                          |
| -   3 Installing the necessary packages                                  |
| -   4 Configuring PHC                                                    |
|     -   4.1 Finding safe low voltages                                    |
|     -   4.2 Editing the configuration                                    |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Module loading                                               |
|     -   5.2 Hardware recognition                                         |
|     -   5.3 Voltage controlling                                          |
|     -   5.4 System stability                                             |
|                                                                          |
| -   6 Links                                                              |
+--------------------------------------------------------------------------+

Introduction
------------

PHC is an acpi-cpufreq patch built with the purpose of enabling
undervolting on your processor. This can potentially divide the power
consumption of your processor by two or more, and in turn increase
battery life and reduce fan noise noticiably. PHC works only if your
processor's architecture supports undervolting.

For a complete power management suite see Related articles in top-right
of the page.

> Alternative to PHC

cpupowerd is a userland solution to replace the in-kernel cpufreq
governors and also enable undervolting, only on AMD processors. Like
PHC, it requires the user to find safe voltages by himself.

Supported CPUs
--------------

PHC supports the following processor families:

> Intel

-   Mobile Centrino
-   Atom (N2xx)
-   Core / Core2 (T and P Series)
-   Core i (tested on Core i3 550)

Note:Frequency locking does not seem to be working on Core i3 with the
current stable 0.3.2 release of PHC, so finding the best vids for all
but the highest frequency might be difficult or impossible.

> AMD

-   K8 series

Installing the necessary packages
---------------------------------

Install from the AUR either phc-intel if you have an Intel processor, or
phc-k8 if you have an AMD-K8-series one.

Next you need to compile the module for your kernel; this will also be
necessary after a kernel update.

You need to have linux-headers and/or linux-lts-headers installed to be
able to build the module.

Type:

    # phc-intel setup

or

    # rc.d setup phc-k8

If the acpi-cpufreq module is not already being loaded at boot, create
the appropriate file in /etc/modules-load.d/. See this wiki article for
more information.

Note:In the case of phc-intel, the acpi-cpufreq module is automatically
loaded by /usr/lib/modprobe.d/phc-intel.conf.

Configuring PHC
---------------

> Finding safe low voltages

To automatically find the best voltages, you can use the
mprime-phc-setup script. Just copy the code into a text file, chmod +x
it to make it executable and run it. You need to install mprime first
(it is used to check that the CPU is stable). This script has not been
tested on many systems yet, but should be safe.

You can also try linux-phc-optimize, although it has produced unsafe
vids on some setups. The script progressively lowers the values until
the system crashes, and adds two to the values for stability. Because
the system will crash, do not do anything else during the tests. Run it
once for each value, then check
/usr/share/linux-phc-optimize/phc_tweaked_vids.

> Editing the configuration

After the phc module is compiled and the lowest voltages are found, they
need to be added to the configuration file at /etc/phc-intel.conf or
/etc/phc-k8.conf.

For example:

    VIDS="25 22 15 8 5"

If you are still running a sysvinit configuration, then just restart the
phc daemon:

    # rc.d start phc-intel

or

    # rc.d start phc-k8

In case you are using systemd (recommended), simply restart the system
and the modules will be loaded and setup automatically.

Troubleshooting
---------------

> Module loading

Run:

    $ dmesg | grep acpi-cpufreq

If you see errors regarding this module, something has gone wrong OR you
cannot use PHC.

> Hardware recognition

There should be some files in /sys/devices/system/cpu/cpu0/cpufreq/
beginning with "phc_". To check whether PHC is working or not, just
type:

    $ cat /sys/devices/system/cpu/cpu0/cpufreq/phc_controls

you should read some values. If the values do not appear, then PHC is
probably not supported by your CPU.

> Voltage controlling

You can easily check whether PHC is working or not by looking at the cpu
voltages: if the voltages are lower than the normal ones, then PHC has
done its job. You can also manually set voltages, for example:

    # echo 34 26 18 12 8 5 > /sys/devices/system/cpu/cpu0/cpufreq/phc_vids

> System stability

To make sure that your undervolted CPU is stable, you can run long
sessions of mprime and/or linpack (Intel-only).

Links
-----

-   PHC homepage
-   PHC official wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=PHC&oldid=246795"

Categories:

-   CPU
-   Power management
