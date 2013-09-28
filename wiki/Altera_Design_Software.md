Altera Design Software
======================

This tutorial shows how to install the following softwares form the
Altera Design Software

-   Quartus II (Web edition)
-   USB-Blaster Driver
-   ModelSim (starter edition)

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Only version     
                           12.1 is provided in the  
                           download page. Need to   
                           update to the latest     
                           version. (Discuss)       
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Quartus II                                                         |
|     -   1.1 Installation                                                 |
|     -   1.2 Libpng12                                                     |
|     -   1.3 Integrating Quartus II with the system                       |
|     -   1.4 USB-Blaster Driver                                           |
|                                                                          |
| -   2 Model Sim                                                          |
|     -   2.1 Install                                                      |
|     -   2.2 Compatibility with Archlinux                                 |
|         -   2.2.1 With the kernel 3.x                                    |
|         -   2.2.2 Install libraries                                      |
|                                                                          |
|     -   2.3 Add icon to the system                                       |
+--------------------------------------------------------------------------+

Quartus II
----------

The following procedure shows how to install the 10.2 sp2 version of
Quartus II

> Installation

Quartus II is downloadable at:
https://www.altera.com/download/software/quartus-ii-we Downloading
Altera softwares requires registration. Once this is done, proceed with
the download. Download the file 12.0sp2_quartus_free_linux.tar.gz.

Once you have downloaded the file, unzip it. Now you can proceed with
the installation

    $ cd <Download-folder>
    $ sudo ./altera_installer/bin/altera_installer_gui --gui

Executing this script should open a setup GUI. Just follow the
instructions. For the purpose of this tutorial, I assume that you are
installing Quartus II in the /opt/altera folder. Don't forget to select
the file for the source of install if you don't want to download again
quartus.

Now you need to install manually the 64 bit edition

    $ cd <Download-folder>
    $ sudo linux_installer/quartus_free_64bit/install

type your install folder path (/opt/altera) choose "n" for not deleting
the 32bit install

> Libpng12

Quartus II requires libpng12 to work and can be found on aur.

> Integrating Quartus II with the system

Let's now add the Quartus bin folder to the PATH variable as well as
select if we want to run it in 64 bits mode. Create a quartus.sh file in
the /etc/profile.d directory

    /etc/profile.d/quartus.sh

    export PATH=$PATH:/opt/altera/quartus/bin

Other environment variables related to Quartus can be found in the
official installation manual
http://www.altera.com/literature/manual/quartus_install.pdf

And now you can try launching launching Quartus II

    $ source /etc/profile.d/quartus.sh
    $ quartus

You can add Quartus II to your system application menu by creating a
quartus.desktop file in your ~/.local/share/applications directory

    ~/.local/share/applications/quartus.desktop

    [Desktop Entry]
    Version=1.0
    Name=Quartus II
    Comment=Quartus II design software for Altera FPGA's
    Exec=/opt/altera/quartus/bin/quartus
    Icon=/opt/altera/quartus/adm/quartusii.png
    Terminal=false
    Type=Application
    Categories=Development

> USB-Blaster Driver

The USB-Blaster is a cable that allows you to download configuration
data from you computer to you FPGA, CPLD or EEPROM configuration device.
However Altera only provides support for RedHat Entreprise, SUSE
Entreprise and Cent OS and we are required to do a little bit of work to
make it work with Archlinux. If you want some more detail about this
cable, please refer to
http://www.altera.com/literature/ug/ug_usb_blstr.pdf

Create a new file :

    /etc/udev/rules.d/51-usbblaster.rules

    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666", NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", RUN+="/bin/chmod 0666 %c"

Then 'reload' that file using

    $ sudo udevadm control --reload-rules

Now to check that everything is working, plug your FPGA or CPLD board
using your USB-Blaster cable and run

    $ sudo /opt/altera/quartus/bin/jtagconfig

You should have an output similar to this one

    1) USB-Blaster [USB 1-1.1]
      020B30DD   EP2C15/20

If there seems to be an error message about linux64, create a symlink
from linux to linux64 in /opt/altera/quartus

    # ln -s linux linux64

Model Sim
---------

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
"https://wiki.archlinux.org/index.php?title=Altera_Design_Software&oldid=240869"

Categories:

-   Development
-   Mathematics and science
