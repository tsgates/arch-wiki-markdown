DSL SpeedTouch modem
====================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Kernel config and ppp                                              |
| -   3 Configuring pppd                                                   |
| -   4 Configure Udev:                                                    |
| -   5 Firmware                                                           |
| -   6 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Introduction
------------

This howto shows one way to get a working speedtouch USB modem. It uses
the kernel driver, not the userspace driver. This howto assumes that
your ISP uses PPPoA and not PPPoE. For info about PPPoE with these
modems see first url below.

Important sites where most info comes from:

-   http://www.linux-usb.org/SpeedTouch
-   http://lkml.org/lkml/2004/12/27/63

If the below instructions are not enough to get it working, then read
the above sites.

The following steps are needed to get the modem working:

Kernel config and ppp
---------------------

Make sure you have a kernel with the proper support (at least the
modules ppp_generic, pppoatm, slhc, atm, usbatm and speedtch). The
default Arch kernel should work.

Otherwise make sure that your kernel supports firmware loading:

    $ zgrep FW_LOADER /proc/config.gz 

Install ppp: pacman -S ppp

Configuring pppd
----------------

    ###  /etc/ppp/peers/speedtch

    # To connect to using this configuration file, do
    #       pppd call speedtch

    lcp-echo-interval 10
    lcp-echo-failure 10
    noipdefault
    defaultroute
    user "username@ispname"
    noauth
    noaccomp
    nopcomp
    noccp
    novj
    holdoff 4
    persist
    maxfail 25
    updetach
    usepeerdns
    plugin pppoatm.so
    # Following entry is country/ISP dependent
    8.48

The last entry depends on your country/ISP and is created from the VPI
and VCI setting in the format VPI.VCI. This page has a VPI / VCI Setting
List.

You also need to configure /etc/ppp/pap-secrets or chap-secrets,
depending on your ISP. pap-secrets files are of the format:

    # Secrets for authentication using PAP
    # client        server  secret		IP addresses
    "ISP-Username"	*	ISP-password	*

See The PAP/CHAP secrets file for more details.

If you want to use the DNS servers provided by your ISP (you probably
do!) then make a symlink /etc/resolv.conf pointing to
/etc/ppp/resolv.conf:

    cd etc
    rm resolv.conf
    ln -s ppp/resolv.conf resolv.conf

Configure Udev:
---------------

Make a file /etc/udev/rules.d/99-speedtouch.rules and put something like
the following in it:

    ACTION=="add", SUBSYSTEM=="atm", KERNEL=="speedtch*", RUN="/usr/sbin/pppd call speedtch"

With this Udev will start pppd automatically, if you do not want this
you can simply bring up your modem using pppd call speedtch

Firmware
--------

Now you have everything except the firmware loading. The easiest way is
to let hotplug/udev do it. Download rev4fw.zip (note disclaimer here)
and unzip it. It contains two files, a small one and a big one. Copy the
small file to /lib/firmware/speedtch-1.bin and the big one to
/lib/firmware/speedtch-2.bin

    mkdir -p /lib/firmware
    cp small_file /lib/firmware/speedtch-1.bin
    cp large_file /lib/firmware/speedtch-2.bin

If you cannot download this file then follow the instructions of the
second link above and use the firmware extractor (or download another
firmware which has the two files).

Troubleshooting
---------------

If the modem is being detected correctly and the firmware is loading,
you should see something like the following in dmesg:

    usbcore: registered new driver speedtch
    usb 1-1: found stage 1 firmware speedtch-1.bin
    CSLIP: code copyright 1989 Regents of the University of California
    PPP generic driver version 2.4.2
    usb 1-1: found stage 2 firmware speedtch-2.bin
    ip_tables: (C) 2000-2002 Netfilter core team
    ADSL line is synchronising
    DSL line goes up
    ADSL line is up (800 Kib/s down || 256 Kib/s up)

pppd output in /var/log/messages should look something like:

    Plugin pppoatm.so loaded.
    PPPoATM plugin_init
    PPPoATM setdevname - remove unwanted options
    PPPoATM setdevname_pppoatm - SUCCESS:8.48
    Using interface ppp0
    Connect: ppp0 <--> 8.48
    PAP authentication succeeded
    local  IP address 123.45.67.89
    remote IP address 195.190.249.10
    primary   DNS address 195.121.1.34
    secondary DNS address 195.121.1.66

If you are having problems you can check pppd debug messages by adding
debug to /etc/ppp/peers/speedtch. This can help identify authentication
problems (e.g. pap vs chap auth), etc. Otherwise make sure you check
your VPI/VCI settings!

* * * * *

For the origin of this doc, feedback or requests go to the Forum
discussion

Retrieved from
"https://wiki.archlinux.org/index.php?title=DSL_SpeedTouch_modem&oldid=238340"

Category:

-   Modems
