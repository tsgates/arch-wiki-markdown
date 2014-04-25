IBM ThinkPad T30
================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Extensive information about Linux on the T30 can be found at [1]. What
follows here are details specific to Arch Linux.

Contents
--------

-   1 Configuration
    -   1.1 Modules
        -   1.1.1 cpufreq Drivers
        -   1.1.2 Wireless Drivers
        -   1.1.3 Sound Drivers
    -   1.2 Networking
    -   1.3 ACPI
    -   1.4 Xorg

Configuration
-------------

> Modules

udev in Arch does a pretty good job of detecting the T30's hardware. I
modified the MODULES line in /etc/rc.conf as follows:

    MODULES=(!usbserial !acpi_cpufreq !p4-clockmod !powernow-k6 !powernow-k7
     !powernow-k8 !cpufreq-nforce2 !speedstep-smi !hostap !hostap_pci 
     orinoco_pci snd_intel8x0 fuse)

cpufreq Drivers

This blacklists most of the cpufreq drivers so that only speedstep-ich
will be loaded. It's not clear to me that the speedstep-ich driver is
actually doing anything on this laptop, but it does appear to load and
operate correctly.

Wireless Drivers

For T30s with the Intel 802.11b mini-PCI wireless adapter, either the
hostap or orinoco driver modules should work. I've blacklisted hostap
and forced the orinoco wireless driver to be loaded. ThinkWiki talks
about some possible problems with the orinoco driver, but I've seen no
issues on my T30 with the stock Arch kernel.

Sound Drivers

For whatever reason, udev wasn't able to get the right ALSA drivers
loaded automatically. Simply forcing the load of the snd_intel8x0
resolved the issue so I didn't debug further.

> Networking

The asignment of interface names to the wired and wireless ethernet
adapters is a function of the order in which the modules load and
complete their initializtion. This can make network configuration
difficult because on one boot cycle the wireless may be eth0 but on the
next boot it may be eth1. It should be possible to rename the interfaces
through udev rules, but I had little success with that.

I solved the problem using the nameif utility. nameif uses the file
/etc/mactab to associate ethernet adapter MAC addresses to interface
names. My /etc/mactab is as follows:

    eth0 00:09:6B:90:31:D4
    wlan0 00:05:3C:04:B9:A0

Obviously you need to change the MAC addresses to match your hardware.

In addition, a small change to /etc/rc.d/network is necessary to run the
nameif command prior to configuring the interfaces. The following
excerpt from /etc/rc.d/network shows the lines that need to be added.
This change simply checks for the existance of the /etc/mactab file and
if it exists executes nameif to assign interface names.

                   stat_busy "Starting Network"
                   error=0
                   ##### begin nameif change #####
                   # set names
                   if [ -n /etc/mactab ]; then
                     /sbin/nameif
                   fi
                   ##### end nameif change #####
                   # bring up bridge interfaces
                   bridge_up
                   # bring up ethernet interfaces

> ACPI

> Xorg

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T30&oldid=196662"

Category:

-   IBM

-   This page was last modified on 23 April 2012, at 13:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
