Power Management
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: The purpose of    
                           this article currently   
                           overlaps other           
                           introductions like       
                           General                  
                           Recommendations#Power    
                           management and           
                           Laptop#Power Management; 
                           application-specific     
                           information must be      
                           moved to the respective  
                           articles; only a generic 
                           introduction to power    
                           management in Arch and   
                           to related articles      
                           should stay here.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The aim of this page is to try to gather all the informations which are
available on the topic of linux power management features. There are
several places where one can change power management settings:

-   Kernel command line parameters in the boot loader
-   systemd
-   Settings by pm-utils
-   Upower
-   Laptop Mode Tools

Power settings you set in one place could be overwritten in another
place.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Power saving                                                       |
| -   2 Where To Change Power Settings                                     |
| -   3 Kernel Command Line Parameters                                     |
|     -   3.1 PCI-e ASPM                                                   |
|     -   3.2 Enable RC6 Power Save Options                                |
|     -   3.3 Change Usbcore Autosuspend Time                              |
|                                                                          |
| -   4 pm-utils Settings                                                  |
|     -   4.1 Enable SATA Link Power Management                            |
|     -   4.2 Scripts For Pm-utils Which Enable Power Management Options   |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Connection problems with Atheros AR9485 Wireless Network     |
|         Adapter                                                          |
|                                                                          |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Power saving
------------

See power saving.

Where To Change Power Settings
------------------------------

One can pass a kernel command line parameter in the boot loader to
activate power management features in certain kernel modules. If you are
using systemd you can change some power management options in systemd
config files or execute your own config file. pm-utils and upower work
together. pm-utils is responsible for changing the power management
options while upower informs pm-utils about system changes. For example,
if you unplug your laptop from AC power then upower will signal to
pm-utils that the laptop is running on battery. This will cause pm-utils
to change some power management options according to its config files.

Have a look at the power management category to get an overview on what
power management options exists in Archlinux:.

Kernel Command Line Parameters
------------------------------

Append the lines to your kernel command line parameter to enable these
options. If you change settings for kernel modules make sure they are
either compiled into your initrd (insert module name in MODULES in
/etc/mkinitcpio.conf) or pass an option via a modprobe config file
(Kernel_modules#Using_files_in_.2Fetc.2Fmodprobe.d.2F).

> PCI-e ASPM

     pcie_aspm=force

> Enable RC6 Power Save Options

     i915_enable_rc6=#Nr

Where #Nr:

-   1: enable rc6
-   3: enable rc6 and deep rc6
-   5: enable rc6 and deepest rc6
-   7: enable rc6, deep and deepest rc6

> Change Usbcore Autosuspend Time

     usbcore.autosuspend=<time in seconds>

pm-utils Settings
-----------------

The pm-utils (see also: Pm-utils#Power_saving) package provides quirks
for suspend to RAM and suspend to disk but also includes some scripts
for power management. You need upower which registers power changes and
signals that information to pm-utils.

> Enable SATA Link Power Management

Execute the following command to enable SATA link power management when
on battery:

     # echo SATA_ALPM_ENABLE=true > /etc/pm/config.d/sata_alpm

> Scripts For Pm-utils Which Enable Power Management Options

These scripts have to be made executable via

     # chmod +x <script file>

Troubleshooting
---------------

> Connection problems with Atheros AR9485 Wireless Network Adapter

You may experience connection problems with the Atheros AR9485 Wireless
Network Adapter, which is caused by incorrect power management
functioning. You can notice the problem if you're experiencing random
disconnections in IM or other software that keeps connection alive for a
long time. In case you're using laptop, first you must disable battery
power-over-perfomance feature: Settings / Power Manager / On Battery /
Prefer power savings over perfomance

Next thing to do is switch off power management for adapter: You should
add

    iwconfig wlan0 power off

(assuming wlan0 is your AR9485 adapter) anywhere it can be executed on
system init (or simply run it once, to fix the problem for current
session) and that should do it.

See Also
--------

CPU Frequency Scaling

Retrieved from
"https://wiki.archlinux.org/index.php?title=Power_Management&oldid=241842"

Category:

-   Power management
