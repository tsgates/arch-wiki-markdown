Compal CL56
===========

  

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This will follow the steps involved in setting up Arch Linux on a Compal
CL56/CL56P Laptop. This is a very common base laptop system that is
rebranded by a lot of different companies. This is specifically going to
be about the steps needed for a Velocity Micro B51 Campus Edition
working fully. There is a linux-laptop.net page: [1] for the CL56, as
well as another page here: [2] also for the CL56.

This will follow all the special things I have had to do and anything
new that I come across as it happens. Out of the 'box' as it were Arch
works decently.

lspci output:

    00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 21)
    00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 21)
    00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
    00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
    00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
    00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
    01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10]
    02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
    02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
    02:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network Connection (rev 05)
    02:03.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)

-   Wireless (Intel Pro Wireless 2200BG)
    -   The ipw2200 driver which make it work is included in the kernel
        but you may have to install the ipw2200 firmware to make it work
        (pacman -S ipw2200-fw). The card supports managed, ad-hoc and
        monitor modes.
    -   The wifi switch needs the acerhk module: its source is available
        at [3], but a PKGBUILD is available on the AUR.
    -   After compiling the module, it needs to be added to the MODULES
        array in /etc/rc.conf. The AUR build includes a daemon that
        activates the module, to have it started at boot time add it to
        the DAEMONS array in /etc/rc.conf.

-   SD (Secure Digital) card reader/writer
    -   It is physically located just underneath the CardBus slot.
    -   MMC read/write support works with mmc_block driver.
    -   Add mnt/mmc directory and the following line to /etc/fstab

    /dev/mmcblk0p1 /mnt/mmc vfat rw,user,auto,exec,sync 0 0 

-   Sound
    -   After loading the snd_intel8x0 module the card works without
        problems.

-   ATI Radeon
    -   just follow the ATI wiki
    -   use X.org and just download the proper driver from ATI homepage
    -   performance is is about 2100 fps with glxgears and 410 fps with
        fgl_glxgears if drivers are installed correctly

-   VGA Dual Monitor Head Output/S-Video output
    -   works, just use the configuration application included with ATI
        drivers

-   PCMCIA
    -   works with standard kernel, just add the following line to
        /etc/rc.local

    cardmgr

-   Infrared
    -   add irda ircomm ircomm-tty to /etc/rc.conf MODULES list.
    -   for using GPRS over IR add the following line to /etc/rc.local

    mknod /dev/ppp c 108 0

and use pppconfig to configure the connection settings (use /dev/ttyS0
as the port)

-   Touchpad and access to few informations like temperature and fan
    level
    -   install aur/omnibook-svn (here with kernel 2.6.25-ARCH, the
        aur/omnibook did not work)
    -   add omnibook to MODULES in /etc/rc.conf (MODULES=(... omnibook
        ...))
    -   add a line with "options omnibook ectype=1" in
        /etc/modprobe.d/modprobe.conf (if not set, loading omnibook will
        fail)
    -   For touchpad configuration see Touchpad_Synaptics (use first
        configuration, not the one for the ALPS touchpads)
    -   to get temperature: cat /proc/omnibook/temperature
    -   to see other options: ls /proc/omnibook/*

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compal_CL56&oldid=196409"

Category:

-   Laptops
