ASUS Eee PC 1000HA
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before You Begin                                                   |
|     -   1.1 Choosing Your Installation Media                             |
|                                                                          |
| -   2 Installing Arch Linux                                              |
|     -   2.1 Mount the installation media                                 |
|     -   2.2 Start the Installation                                       |
|     -   2.3 Prepare Hard Drive                                           |
|     -   2.4 Select Packages                                              |
|     -   2.5 Small BIOS notice                                            |
|                                                                          |
| -   3 Getting Everything Working                                         |
|     -   3.1 Xorg                                                         |
|     -   3.2 Setting up large external monitors                           |
+--------------------------------------------------------------------------+

Before You Begin
----------------

> Choosing Your Installation Media

The EEE PC does not have an optical drive installed on the machine. This
means you will need to install Arch Linux through one of the alternative
methods:

1.  External USB CD-ROM drive
2.  USB pen drive (Recommended)

Installing Arch Linux
---------------------

-   NOTE: Please refer to the Official Arch Linux Install Guide and
    Beginners Guide for detailed instructions.

> Mount the installation media

The installer should mount USB source media automatically. If it fails
you can manually mount the source media on the stick to the /src
directory with the following command:

    mount /dev/sd[x] /src

> Start the Installation

Just run:

    /arch/setup

To start the installation just like normal.

> Prepare Hard Drive

-   It is recommended to backup Eee's partitions and MBR before
    proceeding!

The default Eee PC drive is split up into four partitions (here is some
information about the partitioning). You can install Arch in the empty
partition, or wipe the existing partitions.

> Select Packages

Choose the proper source of package, this should be done automatically
if you are installing from USB.

In addition to the BASE category, you also need all of the packages in
the DEVEL category if you are planning on compiling stuffs on your Eee.

> Small BIOS notice

Your wireless card might not turn on by default, if you want it to power
up on boot, go to BIOS, the device tab, and make sure Wireless is
enabled.

Getting Everything Working
--------------------------

By now, you should have Arch installed. The following is the guide on
how to get the rest of your system working.

> Xorg

See Intel Graphics.

> Setting up large external monitors

If you are connecting a large external monitor, the integrated chipset
may not be able to handle a resolution that high. If the resolution of
the netbook's display and the external monitor add up to above 2000x1500
you will experience graphical glitches (eg. being able to move the mouse
off corners off the screen and not being able to get it back). To be
able to use the monitor at its large resolution you will have to disable
the netbook's screen with this command.

    xrandr --output LVDS1 --off && xrandr --output VGA1 --auto

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1000HA&oldid=249613"

Category:

-   ASUS
