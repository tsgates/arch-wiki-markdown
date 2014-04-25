Xilinx ISE WebPACK
==================

The Xilinx ISE WebPACK is a complete FPGA/CPLD programmable logic design
suite providing:

-   Specification of programmable logic via schematic capture or
    Verilog/VHDL
-   Synthesis and Place & Route of specified logic for various Xilinx
    FPGAs and CPLDs
-   Functional (Behavioral) and Timing (post-Place & Route) simulation
-   Download of configuration data into target device via communications
    cable

While Arch Linux is not one of the officially supported distributions,
many features are known to work on Arch Linux.

Contents
--------

-   1 Prerequisites
    -   1.1 Dependencies
    -   1.2 Default Shell
-   2 Installation
    -   2.1 Launching the ISE design tools
        -   2.1.1 Launching via desktop icons
    -   2.2 License Installation
    -   2.3 Node-Locked Licenses
-   3 Post-Installation Fixes and Tweaks
    -   3.1 Dynamic Library Fix (libstdc++.so)
    -   3.2 Digilent USB-JTAG Drivers
    -   3.3 Locale Issues
    -   3.4 Segmentation Fault on PlanAhead
    -   3.5 GNU make
    -   3.6 Running Xilinx tools from within KDE

Prerequisites
-------------

> Dependencies

If you plan to develop software for an embedded ARM core (e.g. for
Xilinx Zynq SoC devices), you will want to install the GCC
cross-compiler bundled included with the Xilinx Embedded Development Kit
(EDK). This compiler requires the glibc and ncurses packages. For i686
installations, these will most likely be already present.

If you are on a 64-bit Arch installation, you need to install them from
the multilib repository (lib32-glibc and lib32-ncurses).

> Default Shell

During the installation, the Mentor CodeSourcery toolchains for embedded
processors can be installed along with the Xilinx tools. This
installation silently fails when the default shell is set to "dash".
Make sure /usr/bin/sh points to /usr/bin/bash.

This can be checked by running this command:

    $ ls -l /usr/bin/sh

If the output looks like this:

    lrwxrwxrwx 1 root root 15 13 Mar 06:47 /usr/bin/sh -> bash

then /usr/bin/sh already points to /usr/bin/bash (the default in Arch
Linux).

If not, run the following commands as root:

    $ rm /usr/bin/sh
    $ ln -s bash /usr/bin/sh

Installation
------------

Note:The installation is last known to work with Xilinx ISE 14.6,
requiring the dynamic library fix described below.

The ISE Design Tools can be downloaded from the official download page.
It requires registration and licensing agreement, but there is no
charge, i.e. it's free as in "free beer", but not free as in "free
speech".

Once the tarballs has been downloaded, unpack it:

    $ tar -xvf Xilinx_ISE_DS_14.6_P.68d_3.tar

The ISE design tools installer is a Qt application. If you are running
the KDE desktop environment, the installer may try to load the "Oxygen"
widget theme, which will fail due to the older Qt framework bundled with
the Xilinx ISE design tools. You need to remove the QT_PLUGIN_PATH
environment variable before executing the installer:

    $ unset QT_PLUGIN_PATH

Then, install the ISE Design Tools:

    $ cd Xilinx_ISE_DS_14.6_P.68d_3
    $ ./xsetup

Follow the instructions to install the ISE. By default, the whole
application is installed to /opt/Xilinx/, so make sure the user running
the installer has permissions to write to this directory.

During installation, uncheck the "Install Cable Drivers" option. Leaving
it checked will cause errors during the installation.

> Launching the ISE design tools

The ISE design tools include a shell script that modifies the
environment variables (mostly PATH and LD_LIBRARY_PATH). This script
must be sourced before starting the ISE tools:

    $ source /opt/Xilinx/14.6/ISE_DS/settings64.sh

or, for a 32-bit installation:

    $ source /opt/Xilinx/14.6/ISE_DS/settings32.sh

Then, the ISE design tools will be found in your PATH and can be started
by typing their name in the terminal (e.g. ise, planAhead, xsdk, ...)

Launching via desktop icons

You can also create files at /usr/share/applications/

ise.deskop:

    #!/usr/bin/env xdg-open
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Xilinx ISE
    Exec=sh -c "export LANG=en_US.UTF-8 && source /opt/Xilinx/14.6/ISE_DS/settings64.sh && ise"
    Icon=/opt/Xilinx/14.6/ISE_DS/ISE/data/images/pn-ise.png
    Categories=Development;
    Comment=Xilinx ISE

xps.deskop:

    #!/usr/bin/env xdg-open
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Xilinx PS
    Exec=sh -c "export LANG=en_US.UTF-8 && source /opt/Xilinx/14.6/ISE_DS/settings64.sh && xps"
    Icon=/opt/Xilinx/14.6/ISE_DS/EDK/data/images/ps_platform_studio.ico
    Categories=Development;
    Comment=Xilinx Platform Studio

After that you can copy this files to Desktop folder on your home and
launch ISE tools from desktop

> License Installation

After requesting a WebPACK license from Xilinx using their Licensing
Site, you will be e-mailed a license file. This file can be imported
with the Xilinx License Manager (run xlcm -manage from the terminal).

Another way to import the license is to simply copy it to the ~/.Xilinx
directory.

> Node-Locked Licenses

Arch Linux by default uses systemd's Predictable Network Interface
Names. This means that your system will most likely not have its network
interfaces named "eth0", "eth1" and so forth.

However, the Xilinx License Manager looks for these names to find out
the system's MAC addresses, which are used for node-locked licenses. If
you require node-locked licenses, unfortunately but you have to disable
this feature to re-gain the kernel naming scheme for network interfaces
and fix the name of NIC that you obtained your license. The code below
will be your help:

    # echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="xx:xx:xx:xx:xx:xx", NAME="eth1"' > /etc/udev/rules.d/10-net-naming.rules

For more specific, reffer the page systemd wiki describes how to work
and what you have other(formal) ways.

Post-Installation Fixes and Tweaks
----------------------------------

After installation, a few manual fixes are required to work around
problems caused by running the Xilinx tools on a Linux distribution that
is not officially supported by Xilinx. Some of these fixes are taken
from this forum post.

> Dynamic Library Fix (libstdc++.so)

The ISE tools supply an outdated version of the libstdc++.so library,
which may cause segfaults when using the Xilinx Microprocessor Debugger
and prevents the usage of the oxygen-gtk theme. This outdated version is
located in two directories within the installation tree:
/opt/Xilinx/14.6/ISE_DS/ISE/lib/lin64/ and
/opt/Xilinx/14.6/ISE_DS/common/lib/lin64. To use Arch's newer version of
libstdc++, rename or delete the original files and replace them with
symlinks:

    cd /opt/Xilinx/14.6/ISE_DS/ISE/lib/lin64/
    mv libstdc++.so libstdc++.so-orig
    mv libstdc++.so.6 libstdc++.so.6-orig
    mv libstdc++.so.6.0.8 libstdc++.so.6.0.8-orig
    ln -s /usr/lib/libstdc++.so
    ln -s libstdc++.so libstdc++.so.6
    ln -s libstdc++.so libstdc++.so.6.0.8

Then, repeat this process in the
/opt/Xilinx/14.6/ISE_DS/common/lib/lin64 directory.

> Digilent USB-JTAG Drivers

To use Digilent Adept USB-JTAG adapters (e.g. the onboard JTAG adapter
on the ZedBoard) from within the Xilinx design tools, you need to
install the Digilent Adept Runtime and Plugin.

Make sure you have installed fxload from the Arch User Repository .

To install the Digilent Adept Runtime, it is recommended to build and
install adept-runtime-xilinx and its dependencies libftd2xx-digilent and
usbdrv from the Arch User Repository.

To install the Digilent plugin, you have to copy two files to the ISE
plugin directory. Run the following commands as root:

    $ mkdir -p /opt/Xilinx/14.6/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent
    $ cd /opt/Xilinx/14.6/ISE_DS/ISE/bin/lin64/digilent/libCseDigilent_2.4.4-x86_64/lin64/14.1/libCseDigilent
    $ cp libCseDigilent.{so,xml} /opt/Xilinx/14.6/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent
    $ chmod -x /opt/Xilinx/14.6/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent/libCseDigilent.xml

  

Finally, add every user that should have access to the Digilent USB-JTAG
adapter to the "uucp" group.

You may have to add the USB Vendor/Product IDs of your JTAG adapter
which can be found with

    $ lsusb | grep Xilinx

to the udev rules in /etc/udev/rules.d/20-digilent.rules.

If it still doesn't work, you can make further reading in
Xilinx_JTAG_Linux. The magic git repo there may be help.

> Locale Issues

PlanAhead doesn't like locales using other literals than '.' as the
decimal point (e.g. German, which uses ','). Run the following command
before launching PlanAhead:

    $ unset LANG

> Segmentation Fault on PlanAhead

When launching PlanAhead to generate a .ucf file, a segmentation fault
may occur. The issue seems unrelated to the previous topic. The ISE
console will show

    "/opt/Xilinx/13.1/ISE_DS/PlanAhead/bin/rdiArgs.sh: line 64: 14275 Segmentation fault      $RDI_PROG $*"

The problem seems to come from the bundled JRE as described here. To fix
the issue, symlink the OpenJDK libjvm.so into the Xilinx's installation
directory.

    # cd /opt/Xilinx/14.6/ISE_DS/PlanAhead/tps/lnx64/jre/lib/amd64/server
    # mv libjvm.so{,-orig}
    # ln -s /usr/lib/jvm/java-7-openjdk/jre/lib/amd64/server/libjvm.so

> GNU make

XSDK looks for the gmake executable, which is not present in Arch Linux
by default. Create a symlink somewhere in your path, e.g.

    $ ln -s /usr/bin/make /home/<user>/bin/gmake

Make sure this directory is in your PATH variable.

> Running Xilinx tools from within KDE

KDE by default defines the QT_PLUGIN_PATH shell variable. Some of the
Xilinx ISE tools (ISE, Impact, XPS) are Qt applications, which means
that they will search for Qt plugins in the locations defined by this
shell variable.

Because the Xilinx tools are compiled against and ship with an older
version of the Qt framework which cannot use these plugins, they will
crash when launched with this environment variable present.

To fix this issue, run the following command before launching the tools:

    $ unset QT_PLUGIN_PATH

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xilinx_ISE_WebPACK&oldid=297739"

Categories:

-   Development
-   Mathematics and science

-   This page was last modified on 15 February 2014, at 12:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
