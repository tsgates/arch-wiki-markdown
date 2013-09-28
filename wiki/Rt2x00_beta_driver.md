Rt2x00 beta driver
==================

This page describes how you can make the new rt2x00 drivers work. This
page does not describe the legacy rt2500, rt2400, rt2570, rt61 and rt73
drivers derived from the original Ralink drivers. The rt2x00 driver has
a few advantages over the legacy drivers: It works with all the standard
tools, it is in active development as part of the kernel, and it is
SMP-safe.

A lot has changed since these drivers were out-of-tree, so it's worth
trying the modules (now in the main kernel package) even if the drivers
have not worked for you in the past.

For help with these drivers see the rt2x00 Driver Support section of the
rt2x00 forums.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing the driver                                              |
| -   2 Setting the interface up                                           |
| -   3 Using the driver                                                   |
|     -   3.1 wpa_supplicant                                               |
|     -   3.2 Using WEP                                                    |
+--------------------------------------------------------------------------+

Installing the driver
---------------------

The rt2x00 drivers are now part of the mainline kernel. One need only
load the relevant module:

    # modprobe rt2400pci

    # modprobe rt2500pci

    # modprobe rt2500usb

    # modprobe rt61pci

    # modprobe rt73usb

The last two require a firmware file, provided by the Linux firmwares
package:

    pacman -S linux-firmware

Setting the interface up
------------------------

If you have module autoloading enabled, the drivers should be loaded
automatically when you boot your machine or insert the device. If this
doesn't work or autoloading is disabled, load the modules manually:

    modprobe 80211
    modprobe rc80211_simple
    modprobe $driver

where $driver is one of the following: rt2500pci, rt2400pci, rt2500usb
or rt61pci.

When the driver is loaded, you will have two interfaces, wmaster0 and
wlan0.

Using the driver
----------------

See Wireless Setup#Part II: Wireless management

> wpa_supplicant

rt2x00 should work fine with the wpa_supplicant wext driver. It is not
necessary to patch it any more. See WPA supplicant

> Using WEP

WEP works with the wireless extensions used by iwconfig. See Wireless
Setup#Wireless Quickstart.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rt2x00_beta_driver&oldid=249570"

Category:

-   Wireless Networking
