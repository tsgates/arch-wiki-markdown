Altera Design Software
======================

This tutorial shows how to get, install and configure the following
softwares from Altera:

-   Quartus II Web Edition v13.0
    -   USB-Blaster (I and II) Download Cable Driver
-   ModelSim - Altera Starter Edition

Contents
--------

-   1 Quartus II Web Edition v13.0
    -   1.1 Get Quartus II
    -   1.2 Install dependencies
    -   1.3 Installing
    -   1.4 Launching Quartus II
    -   1.5 Integrating Quartus II with the system
        -   1.5.1 PATH variable
        -   1.5.2 Application menu entry
    -   1.6 USB-Blaster Download Cable Driver
-   2 ModelSim
    -   2.1 Install
    -   2.2 Compatibility with Archlinux
        -   2.2.1 With the kernel 3.x
        -   2.2.2 With freetype2 2.5.0.1-1
        -   2.2.3 Install libraries
    -   2.3 Add icon to the system

Quartus II Web Edition v13.0
----------------------------

The following procedure shows how to get, install and configure Altera
Quartus II Web Edition v13.0 for Arch Linux. Quartus II is Altera's big
software collection to design and interact with about all their
FPGAs/CPLDs/etc. products.

The procedure focuses on Arch Linux 64-bit systems, although 32-bit
installations should work fine too.

Quartus II Web Edition v13.0 is officially supported for RHEL 5 and RHEL
6, but since it's one of those huge collections of proprietary software
that doesn't interact so much with the distribution, it's fairly easy to
install on Arch Linux.

> Get Quartus II

In Altera's Downloads section, select Linux as the operating system and
get the Combined Files tar archive (something like
Quartus-web-13.0.0.156-linux.tar).

> Install dependencies

Although the main Quartus II software is 64-bit, lots of Altera tools
shipped with Quartus II are still 32-bit softwares. Those include the
Nios II EDS and Qsys, for example. This is why we need to install lots
of lib32- libraries and other programs from the Arch Linux Multilib
repo. Obviously, if you have a 32-bit Arch Linux system, you don't need
the Multilib versions.

In order to install Multilib packages using Pacman, you need to enable
the Multilib repository (if not already done). Open /etc/pacman.conf and
uncomment the following lines:

    [multilib]
    Include = /etc/pacman.d/mirrorlist

Then, synchronize the repository.

    # pacman -Sy

You should see multilib being updated.

All the packages required below are taken from Altera Software
Installation and Licensing (sect. 1-4).

Let's first install the native versions of the required packages:

    # sudo pacman -S expat fontconfig freetype2 glibc gtk2 libcanberra libpng \
      libpng12 libice libsm util-linux ncurses tcl tcllib zlib libx11 libxau \
      libxdmcp libxext libxft libxrender libxt libxtst

And the Multilib versions:

    # sudo pacman -S lib32-expat lib32-fontconfig lib32-freetype2 lib32-glibc lib32-gtk2 lib32-libcanberra lib32-libpng \
      lib32-libpng12 lib32-libice lib32-libsm lib32-util-linux lib32-ncurses lib32-zlib lib32-libx11 lib32-libxau \
      lib32-libxdmcp lib32-libxext lib32-libxft lib32-libxrender lib32-libxt lib32-libxtst  

You are now ready to install and launch Quartus II.

> Installing

To install, first extract the downloaded tar archive:

    $ tar -xvf Quartus-web-13.0.0.156-linux.tar

and launch setup.sh. If you're going to install Quartus II anywhere
outside your home directory, run it as root:

    # ./setup.sh

You will probably get a GUI install wizard if you installed all the
aforementioned packages. You might also get a command-line interactive
install wizard, which will do the same.

The default install path is ~/altera/13.0, but some prefer
/opt/altera/13.0, which we assume for the rest of this document.

Make sure to include the 64-bit option of Quartus II when installing.

> Launching Quartus II

Assuming you installed Quartus II in /opt/altera/13.0, Quartus II
binaries are located into /opt/altera/13.0/quartus/bin. Run Quartus II
(64-bit version):

    $ /opt/altera/13.0/quartus/bin/quartus --64bit

or the 32-bit version:

    $ /opt/altera/13.0/quartus/bin/quartus

All other Altera tools, like Qsys, the Nios II EDS, Chip Planner and
SignalTap II may be launched without any problem from the Tools menu of
Quartus II.

> Integrating Quartus II with the system

Quartus II can be integrated with the system in several ways, but those
are optional.

PATH variable

Let's now add the Quartus bin folder to the PATH variable so it can be
executed without specifying its absolute path. Create a quartus.sh file
in the /etc/profile.d directory

    /etc/profile.d/quartus.sh

    export PATH=$PATH:/opt/altera/13.0/quartus/bin

Also, make sure it can be executed:

    # chmod +x /etc/profile.d/quartus.sh

Please note that those profile.d files are loaded at each login. In the
mean time, simply source that file in Bash:

    $ source /etc/profile.d/quartus.sh

Other environment variables related to Quartus can be found in the
official installation manual.

Even if quartus is now a command known by Bash, you still need to add
the --64bit argument in order to launch the 64-bit version. A shell
alias, like quartus64, is a great solution to avoid typing it each time.

Application menu entry

A freedesktop.org application menu entry (which a lot of desktop
environments and window managers follow) can be added to the system by
creating a quartus.desktop file in your ~/.local/share/applications
directory:

    ~/.local/share/applications/quartus.desktop

    [Desktop Entry]
    Version=1.0
    Name=Quartus II Web Edition v13.0
    Comment=Quartus II design software for Altera FPGA's
    Exec=/opt/altera/13.0/quartus/bin/quartus --64bit
    Icon=/opt/altera/13.0/quartus/adm/quartusii.png
    Terminal=false
    Type=Application
    Categories=Development

> USB-Blaster Download Cable Driver

The USB-Blaster (I and II) Download Cable is a cable that allows you to
download configuration data from your computer to your FPGA, CPLD or
EEPROM configuration device. However, Altera only provides official
support for RHEL, SUSE Entreprise and CentOS, so we are required to do a
little bit of work to make it work with Arch Linux. If you want some
more detail about this cable, please refer to the USB-Blaster Download
Cable User Guide.

Create a new udev rule:

    /etc/udev/rules.d/51-altera-usb-blaster.rules

    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"

Then, reload that file using udevadm:

    # udevadm control --reload

To check that everything is working, plug your FPGA or CPLD board using
your USB-Blaster Download Cable and run:

    $ /opt/altera/13.0/quartus/bin/jtagconfig

You should have an output similar to this one

    1) USB-Blaster [USB 1-1.1]
      020B30DD   EP2C15/20

If jtagconfig output doesn't contain board name, you might have problems
with launching nios2 tools. In order to workaround this issue, you
should copy jtagd settings to /etc/jtagd:

    # mkdir /etc/jtagd
    # cp /opt/altera/13.0/quartus/linux/pgm_parts.txt /etc/jtagd/jtagd.pgm_parts

and restart jtagd:

    $ jtagconfig
    1) USB-Blaster [2-4]
    020F30DD 
    $ killall jtagd
    $ jtagd
    $ jtagconfig
    1) USB-Blaster [2-4]
    020F30DD EP3C25/EP4CE22

If there seems to be an error message about "linux64" and you didn't
install the 64-bit version of Quartus II, create a symlink from linux to
linux64 in /opt/altera/13.0/quartus:

    # ln -s /opt/altera/13.0/quartus/linux /opt/altera/13.0/quartus/linux64

ModelSim
--------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This section is  
                           intended for Quartus II  
                           v12.0 and should be      
                           updated for Quartus II   
                           v13.0 (Discuss)          
  ------------------------ ------------------------ ------------------------

Note:The ModelSim version installed with Quartus II Web Edition v13.0
works without any modification when launched from Quartus II's Tool
menu.

> Install

ModelSim is downloadable at:
https://www.altera.com/download/software/modelsim-starter/12.0

You need to download these 3 files :

-   Modelsim v10.0d for Quartus II v12.0
    (12.0_modelsim_ase_linux.tar.gz)
-   Service Pack 2 for Modelsim v10.0d
    (12.0sp2_modelsim_ase_linux.tar.gz)
-   Service Pack 1 for Modelsim v10.0d
    (12.0sp1_modelsim_ase_linux.tar.gz)

Unzip 12.0_modelsim_ase_linux.tar.gz

    $ cd <Download-folder>
    $ sudo ./setup

Executing this script should open a setup GUI. Just follow the
instructions. For the purpose of this tutorial, I assume that you are
installing Quartus II in the /opt/altera folder. Don't forget to select
the file for the source of install if you don't want to download again
quartus.

Repeat this procedure for the sp1 file then the sp2.

> Compatibility with Archlinux

With the kernel 3.x

Modelsim has a problem with the version 3 of linux kernel. You need to
edit the file to make it compatible :

change

    /opt/altera/modelsim_ase/bin/vsim line 204

     *)                vco="linux_rh60" ;;

to

    /opt/altera/modelsim_ase/bin/vsim line 204

     *)                vco="linux" ;;

With freetype2 2.5.0.1-1

The upgrade from freetype2 version 2.5.0.1-1 to 2.5.0.1-2 (October
2013[1]) causes the following error in Modelsim/Questa:

    $ vsim
    Error in startup script:
    Initialization problem, exiting.
    Initialization problem, exiting.
    Initialization problem, exiting.
       while executing
    "EnvHistory::Reset"
       (procedure "PropertiesInit" line 3)
       invoked from within
    "PropertiesInit"
       invoked from within
    "ncFyP12 -+"
       (file "/opt/questasim/linux_x86_64/../tcl/vsim/vsim" line 1)
    ** Fatal: Read failure in vlm process (0,0)

Downgrade the Package (
http://seblu.net/a/arm/2013/10/11/multilib/os/x86_64/lib32-freetype2-2.5.0.1-1-x86_64.pkg.tar.xz
or
http://seblu.net/a/arm/2013/10/11/extra/os/x86_64/freetype2-2.5.0.1-1-x86_64.pkg.tar.xz
) or replace the Library for Modelsim/Questa only, as shown here:
http://communities.mentor.com/mgcx/message/46770

Install libraries

Install library libxft and ncurses.

    $ sudo pacman -S libxft ncurses libxext

For 64 bit edition, install these library from multilib repository

    $ sudo pacman -S lib32-libxft lib32-ncurses lib32-libxext (from multilib repo)

> Add icon to the system

You can add Modelsim to your system application menu by creating a
modelsim.desktop file in your ~/.local/share/applications directory

    ~/.local/share/applications/modelsim.desktop

    [Desktop Entry]
    Version=1.0
    Name=ModelSim
    Comment=ModelSim simulation software for Altera FPGA's
    Exec=/opt/altera/modelsim_ase/bin/vsim
    Icon=/opt/altera/modelsim_ase/modesim.gif
    Terminal=true
    Type=Application
    Categories=Development

Retrieved from
"https://wiki.archlinux.org/index.php?title=Altera_Design_Software&oldid=289155"

Categories:

-   Development
-   Mathematics and science

-   This page was last modified on 18 December 2013, at 18:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
