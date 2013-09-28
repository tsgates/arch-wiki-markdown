Official Install Guide on a PowerPC
===================================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Project is no    
                           longer maintained;       
                           documentation is         
                           therefore useless        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: The isos are no  
                           longer available.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Arch Linux PPC is a project to port Arch Linux to the PowerPC
architecture. This tutorial is designed to show you how to install Arch
Linux on your NewWorld PowerPC computer (i.e. any Apple machine with a
built-in USB port).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Download                                                           |
| -   2 Booting the Install-CD                                             |
| -   3 Install                                                            |
| -   4 Partitioning                                                       |
| -   5 Post-Install                                                       |
|     -   5.1 Adding Packages                                              |
|     -   5.2 ABS                                                          |
|     -   5.3 Other Packages                                               |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 G4 PowerMac will not boot                                    |
+--------------------------------------------------------------------------+

Download
--------

The latest ISO are available for download from here

Booting the Install-CD
----------------------

To boot a CD in most PowerMacs simply hold down C while switching on the
machine. If it starts continue to the install procedure.

If the CD doesn't boot, check the version of OpenFirmware by booting
into it. You get to the Open Firmware by booting you computer and
immediately pressing Apple+Option+O+F. Your Open Firmware version will
be displayed on the top. Only newer versions of Open Firmware are able
to boot these types of CDs. Generally it should at least be version 3.0
or higher. If you are able, it is recommended you update your Open
Firmware before proceeding. If you have the newest firmware, you may
have to direct Open Firmware to CD bootloader:

    boot cd:,\\yaboot

If none of the above works or if you do not own an Apple keyboard, there
is an alternative way to make the CD boot. An existing installation of
OS X is required for this method:

-   Boot into OS X and insert the Arch Linux PPC Boot CD into the drive.
    Now open a terminal window and wait until the CD has been
    auto-mounted. Run mount and search the output for a line similar to
    /dev/disk1s1s2 on /Volumes/arch-boot. In this example the CD-ROM
    device is /dev/disk1s1s2. Now run:
    sudo bless -device /dev/disk1s1s2 -setBoot to change the Open
    Firmware boot device.
-   You can now reboot the machine and install Arch Linux PPC. Once
    yaboot has been installed, the primary boot device should have been
    reset to your hard disk automatically.

Install
-------

Start the installer and follow the steps one by one:

    /arch/setup

For the most part installing is self-explainatory and is based on the
original i686/x64_86 install method. Refer to the Beginners' Guide for
more details. Below will note changes that are only for Arch Linux PPC
installs (particularly for partitioning and the bootloader). Keep in
mind that Arch Linux is generally designed for advanced users. If you do
not have familiarity with Linux systems, it would probably be better to
try another distribution like Debian.

Partitioning
------------

Because Apple using a different partitioning scheme, Arch Linux PPC
needs to use a special partitioning tool called mac-fdisk. An example
way to partition your disk:

    p         # print current partition map
    i         # init new partition map

    b         # Open Firmware needs an Apple bootstrap partition
    2p        # on second partition

    c         # create (for swap)
    3p
    768M      # twice the size of the physical RAM
    swap      # name

    c         # for root
    4p
    4p        # to the end of the physical drive
    /         # name

    w         # write partition map
    q         # quit

Post-Install
------------

To begin, here are a few tips.

> Adding Packages

Some packages are available in the main repository (core and extra) and
can be added with Pacman.

> ABS

Arch Linux PPC includes many packages in common with it's i686 and
x86_64 but not all of them. If you need a package that is a part of the
i686/x86_64 repository you can install it through Arch Build System. See
Arch Build System.

> Other Packages

The Arch User Repository (AUR) has more packages that are available.
There are even a few PPC binary packages available. For packages that
are built from source in the AUR you can add 'ppc' to the PKGBUILDs.

Troubleshooting
---------------

> G4 PowerMac will not boot

If your G4 is not willing to boot with the C button pressed on boot, you
should try to insert another CD-ROM drive, instead of the original. Then
the machine will boot on C.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Official_Install_Guide_on_a_PowerPC&oldid=239605"

Categories:

-   PowerPC
-   Getting and installing Arch
