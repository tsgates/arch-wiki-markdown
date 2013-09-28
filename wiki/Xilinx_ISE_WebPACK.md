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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
|     -   1.1 Dependencies                                                 |
|     -   1.2 Default Shell                                                |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 License Installation                                         |
|     -   2.2 Node-Locked Licenses                                         |
|                                                                          |
| -   3 Post-Installation Fixes and Tweaks                                 |
|     -   3.1 Dynamic Library Fix (libstdc++.so)                           |
|     -   3.2 Digilent USB-JTAG Drivers                                    |
|     -   3.3 Locale Issues                                                |
|     -   3.4 Web Browser doesn't launch from within XSDK                  |
|     -   3.5 GNU make                                                     |
|     -   3.6 Segmentation faults in XMD                                   |
|     -   3.7 Hardcoded "touch" symlink in PlanAhead                       |
|     -   3.8 Running Xilinx tools from within KDE                         |
|                                                                          |
| -   4 Xilinx Cable Drivers                                               |
|     -   4.1 Update 2010-08-02                                            |
|                                                                          |
| -   5 Links                                                              |
+--------------------------------------------------------------------------+

Prerequisites
-------------

> Dependencies

If you plan to develop software for an embedded ARM core (e.g. for
Xilinx Zynq SoC devices), you will want to install the GCC
cross-compiler bundled included with the Xilinx Embedded Development Kit
(EDK). This compiler requires two packages from the multilib repository:
lib32-glibc and lib32-ncurses.

If you are running the 32-bit version of Arch Linux, these dependencies
will already be present in your system.

> Default Shell

During the installation, the Mentor CodeSourcery toolchains for embedded
processors will be installed along the Xilinx tools. This installation
silently fails when the default shell is set to "dash". Make sure
/bin/sh points to /usr/bin/bash.

This can be checked by running this command:

    $ ls -l /bin/sh

If the output looks like this:

    lrwxrwxrwx 1 root root 15 13 Mar 06:47 /bin/sh -> ../usr/bin/bash

then /bin/sh already points to /usr/bin/bash (the default in Arch
Linux).

If not, run the following commands as root:

    $ rm /bin/sh
    $ ln -s /usr/bin/bash /bin/sh

Installation
------------

Note:The installation is last known to work with Linux kernel 3.8.4 and
Xilinx ISE 14.4, requiring the dynamic library fix described below.

The ISE WebPACK Linux version can be downloaded from the official
download page. It requires registration and licensing agreement, but
there is no charge, i.e. it's free as in "free beer", but not free as in
"free speech".

You will want to download both the "Vivado and ISE Design Suites -
2012.4" and the " Device Pack - 14.4 (2012.4) Product Update" tarballs.

Once the tarballs are downloaded, unpack them:

    $ tar -xvf Xilinx_ISE_DS_14.4_P.49d.3.0.tar
    $ tar -xvf Xilinx_2012.4.1_Device_Pack.tar

First, install the Vivado and ISE Design Suites.

    $ cd Xilinx_ISE_DS_14.4_P.49d.3.0/
    $ ./xsetup

Then, follow the instructions to install the ISE. By default, the whole
application is installed to /opt/Xilinx/, so make sure the user running
the installer has permissions to write to this directory.

During installation, uncheck the "Install Cable Drivers" option. Leaving
it checked will cause errors during the installation.

Then, install the Device Pack on top:

    $ cd Xilinx_2012.4.1_Device_Pack
    $ ./xsetup

The ISE design tools include a shell script that modifies the
environment variables (mostly PATH and LD_LIBRARY_PATH). This script
must be sourced before starting the ISE tools:

    $ source /opt/Xilinx/14.4/ISE_DS/settings64.sh

or, for a 32-bit installation:

    $ source /opt/Xilinx/14.4/ISE_DS/settings32.sh

Then, the ISE design tools will be found in your PATH and can be started
by typing their name in the terminal (e.g. ise, planAhead, xsdk, ...)

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
you require node-locked licenses, you might have to disable this feature
to re-gain the kernel naming scheme for network interfaces. The systemd
wiki describes how to do this.

Post-Installation Fixes and Tweaks
----------------------------------

After installation, a few manual fixes are required to work around
problems caused by running the Xilinx tools on a Linux distribution that
is not officially supported by Xilinx. Most of these fixes are taken
from this forum post.

> Dynamic Library Fix (libstdc++.so)

The ISim simulator will not work out of the box because the proprietary
libraries included with ISE are too old for Arch's constantly up-to-date
software. To fix this issue, replace them with symlinks to the native
system versions:

    # cd /opt/Xilinx/14.4/ISE_DS/ISE/lib/lin64/
    # mv libstdc++.so libstdc++.so-orig
    # mv libstdc++.so.6 libstdc++.so.6-orig
    # mv libstdc++.so.6.0.8 libstdc++.so.6.0.8-orig
    # ln -s /usr/lib/libstdc++.so
    # ln -s libstdc++.so libstdc++.so.6
    # ln -s libstdc++.so libstdc++.so.6.0.8

> Digilent USB-JTAG Drivers

To use Digilent Adept USB-JTAG adapters (e.g. the onboard JTAG adapter
on the ZedBoard) from within the Xilinx design tools, you need to
install the Digilent Adept Runtime and Plugin.

To install the Digilent Adept Runtime, it is recommended to build and
install adept-runtime-xilinx and its dependencies libftd2xx-digilent and
usbdrv from the Arch User Repository.

WARNING: At the time of writing, the Xilinx installation contains a
newer (pre-release?) version of the Digilent Adept Runtime and Plugin
than the Digilent website (above links). Because of this, the packaging
tools will not be able to automatically download the sources. Instead,
you will have to create the tarball yourself from within the Xilinx
installation directory:

    $ cd </path/to/PKGBUILD>
    $ tar -cvzf digilent.adept.runtime_2.10.4-x86_64.tar.gz \
          -C /opt/xilinx/14.4/ISE_DS/ISE/bin/lin64/digilent/ \
          digilent.adept.runtime_2.10.4-x86_64

Then, run makepkg to build the package.

To install the Digilent plugin, you have to copy two files to the ISE
plugin directory. Run the following commands as root:

    $ mkdir -p /opt/Xilinx/14.4/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent
    $ cd /opt/Xilinx/14.4/ISE_DS/ISE/bin/lin64/digilent/libCseDigilent_2.4.4-x86_64/lin64/14.1/libCseDigilent
    $ cp libCseDigilent.{so,xml} /opt/Xilinx/14.4/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent
    $ chmod -x /opt/Xilinx/14.4/ISE_DS/ISE/lib/lin64/plugins/Digilent/libCseDigilent/libCseDigilent.xml

Finally, add every user that should have access to the Digilent USB-JTAG
adapter to the "uucp" group.

You may have to add the USB Vendor/Product IDs of your JTAG adapter to
the udev rules in /etc/udev/rules.d/20-digilent.rules.

> Locale Issues

PlanAhead doesn't like locales using other literals than '.' as the
decimal point (e.g. German, which uses ','). Run the following command
before launching PlanAhead:

    $ unset LANG

> Web Browser doesn't launch from within XSDK

XSDK tries to launch the browser from within the environment modified by
the Xilinx settings script (e.g. /opt/Xilinx/14.4/ISE_DS/settings64.sh),
which modifies the library search path (by exporting the LD_LIBRARY_PATH
variable).

This causes the dynamic linker trying to link the browser against the
libraries shipped with the Xilinx design tools, which are too old for
Arch's constant up-to-date system.

To solve this issue, we need to execute the browser without this
environment variable set. Create a script in
/opt/Xilinx/14.4/ISE_DS/ISE/bin/lin64/<name of your preferred browser>
with the following contents:

    #!/bin/bash
    unset LD_LIBRARY_PATH
    exec /usr/bin/<your preferred browser> "$@"

Then, make the script executable:

    $ chmod +x /opt/Xilinx/14.4/ISE_DS/ISE/bin/lin64/<name of your preferred browser>

> GNU make

XSDK looks for the gmake executable, which is not present in Arch Linux
by default. Create a symlink somewhere in your path, e.g.

    $ ln -s /usr/bin/make /home/<user>/bin/gmake

Make sure this directory is in your PATH variable.

> Segmentation faults in XMD

When used with Digilent USB-JTAG adapters, XMD (the Xilinx
Microprocessor Debugger) might cause segmentation faults. These happen
in libdpcomm.so.2, which is the Digilent Adept driver. A possible
solution is described here.

To permanently solve this issue, rename the xmd binary (as root):

    $ cd /opt/Xilinx/14.4/ISE_DS/EDK/bin/lin64
    $ mv xmd xmd-xilinx
    $ mv unwrapped/xmd unwrapped/xmd-xilinx

Then, create a script in its place with the following contents:

    #!/bin/bash
    LD_PRELOAD=libdpcomm.so.2 /opt/Xilinx/14.4/ISE_DS/EDK/bin/lin64/xmd-xilinx "$@"

Finally, make the script executable:

    $ chmod +x /opt/Xilinx/14.4/ISE_DS/EDK/bin/lin64/xmd

> Hardcoded "touch" symlink in PlanAhead

PlanAhead apparently looks for the "touch" executable only in
"/bin/touch", which causes the synthesis to never finish. Create the
symlink by running the following command as root:

    $ ln -s /usr/bin/touch /bin/touch

> Running Xilinx tools from within KDE

KDE by default defines the QT_PLUGIN_PATH shell variable. Some of the
Xilinx software (ISE, Impact, XPS) are Qt applications, which means that
they will search for Qt plugins in the locations defined by this shell
variable.

Because the Xilinx tools are compiled against and ship with an older
version of the Qt framework which cannot use these plugins, they will
crash when launched with this environment variable present.

To fix this issue, run the following command before launching the tools:

    $ unset QT_PLUGIN_PATH

Xilinx Cable Drivers
--------------------

Warning:The information in this section might be outdated.

However once I reached the point of trying to download a design to a
target device I ran into some trouble. Installing the cable drivers for
talking to the target interface cable yielded errors.

I downloaded the standalone driver installation utility from:
ftp://ftp.xilinx.com/pub/utilities/fpga/install_drivers.tar.gz

This download yields a file named install_drivers.tar.gz

    $ tar xzf install_drivers.tar.gz

yields a directory named install_drivers/. When I attempted to build the
drivers from this file I encountered the following errors:

    linux_wrappers.c:48:31: error: linux/ioctl32.h: No such file or directory

and

    linux_wrappers.c:1398: error: ‘struct scatterlist’ has no member named ‘page’

Reading in the Gentoo HOWTO's listed above led me to download the latest
Jungo source code, which is the core of the Xilinx linux USB support. I
modified the link after reading that the latest Jungo driver was 9.20. I
got WinDriver 9.20 from: http://www.jungo.com/st/download/WD920LN.tgz

    $ tar xzf WD920LN.tgz

yields a directory named WinDriver/ Within this directory you'll find:

    $ ls WinDriver/redist/
    configure*      linux_wrappers.c  makefile.in      wdreg*             wdusb_linux.c     windrvr_gcc_v3.a
    linux_common.h  linux_wrappers.h  setup_inst_dir*  wdusb_interface.h  windrvr_gcc_v2.a  windrvr_gcc_v3_regparm.a

These are the same core files also found in:

    $ ls install_drivers/linux_drivers/windriver32/windrvr/
    config.cache    LINUX.2.6.24-ARCH.i386/  makefile         wdusb_interface.h  windrvr_gcc_v3_regparm.a
    config.log      linux_common.h           makefile.in      wdusb_linux.c
    config.status*  linux_wrappers.c         setup_inst_dir*  windrvr_gcc_v2.a
    configure*      linux_wrappers.h         wdreg*           windrvr_gcc_v3.a

So I copied the 9.20 WinDriver files over those found in the
install_drivers/ subdirectory:

    $ cp -p WinDriver/redist/* install_drivers/linux_drivers/windriver32/windrvr/

This update to the Jungo driver eliminated the error: linux/ioctl32.h:
No such file or directory, but the error: ‘struct scatterlist’ has no
member named ‘page’ was still persisting.

After research regarding changes to scatterlist.h lead to these
discussions: http://kerneltrap.org/Linux/SG_Chaining_Merged

Which describe changes in scatter/gather lists that were implemented in
kernel 2.6.23 in Oct 2007.

I implemented the following:

    $ cd install_drivers/linux_drivers/windriver32/windrvr/

and apply the patch indicated below to linux_wrappers.c:

    124a125,127
    > /* added to fix scatterlist without page compile bug -jea 2008-05-09 */
    > // #include <linux/scatterlist.h>
    >
    1791c1794
    <     sgl[0].page = pages[0];
    ---
    >     sgl[0].page_link = (unsigned long)pages[0];
    1798c1801
    <             sgl[i].page = pages[i];
    ---
    >             sgl[i].page_link = (unsigned long)pages[i];
    1823c1826
    <         void *va = page_address(sgl[i].page) + sgl[i].offset;
    ---
    >         void *va = page_address((struct page *)sgl[i].page_link) + sgl[i].offset;
    1954,1956c1957,1959
    <         if (!PageReserved(sgl[i].page))
    <             SetPageDirty(sgl[i].page);
    <         page_cache_release(sgl[i].page);
    ---
    >         if (!PageReserved((struct page *)sgl[i].page_link))
    >             SetPageDirty((struct page *)sgl[i].page_link);
    >         page_cache_release((struct page *)sgl[i].page_link);

or, viewed as a unified patch:

    --- before/install_drivers/linux_drivers/windriver32/windrvr/linux_wrappers.c   2008-02-19 09:58:43.000000000  -0800
    +++ after/install_drivers/linux_drivers/windriver32/windrvr/linux_wrappers.c    2008-05-15 20:02:23.000000000  -0700
    @@ -122,6 +122,9 @@
         static struct pci_dev *pci_root_dev;
     #endif

    +/* added to fix scatterlist without page compile bug -jea 2008-05-09 */
    +// #include <linux/scatterlist.h>
    +
     typedef struct
     {
         struct page **pages;
    @@ -1788,14 +1791,14 @@

         memset (sgl, 0, sizeof(struct scatterlist) * page_count);
         sgl[0].offset = ((unsigned long)buf) & (~PAGE_MASK);
    -    sgl[0].page = pages[0];
    +    sgl[0].page_link = (unsigned long)pages[0];
         if (page_count > 1)
         {
             sgl[0].length = PAGE_SIZE - sgl[0].offset;
             size -= sgl[0].length;
             for (i=1; i < page_count ; i++, size -= PAGE_SIZE)
             {
    -            sgl[i].page = pages[i];
    +            sgl[i].page_link = (unsigned long)pages[i];
                 sgl[i].length = size < PAGE_SIZE ? size : PAGE_SIZE;
             }
         }
    @@ -1820,7 +1823,7 @@
         for (i=0; i<*dma_sglen; i++)
         {
     #if defined(_CONFIG_SWIOTLB)
    -        void *va = page_address(sgl[i].page) + sgl[i].offset;
    +        void *va = page_address((struct page *)sgl[i].page_link) + sgl[i].offset;
             dma_addr_t dma_addr = virt_to_phys(va);

             if (dma_addr & ~mask)
    @@ -1951,9 +1954,9 @@
     #if defined(_CONFIG_SWIOTLB)
             pci_unmap_single(dev_handle, sg_dma_address(&sgl[i]), sg_dma_len(&sgl[i]), (int)dma_direction);
     #endif
    -        if (!PageReserved(sgl[i].page))
    -            SetPageDirty(sgl[i].page);
    -        page_cache_release(sgl[i].page);
    +        if (!PageReserved((struct page *)sgl[i].page_link))
    +            SetPageDirty((struct page *)sgl[i].page_link);
    +        page_cache_release((struct page *)sgl[i].page_link);
         }
         vfree(sgl);
     #elif defined(LINUX_24)

This corrected the compile errors in the Jungo USB driver and produced
the windrvr6.ko kernel module. However there was still a nagging error
in the compilation of
install_drivers/linux_drivers/xpc4drvr2_6/xpc4drvr/

    scripts/Makefile.build:46: *** CFLAGS was changed in "/home/johnea/src/before/install_drivers/linux_drivers/xpc4drvr2_6/xpc4drvr/Makefile". Fix it to use EXTRA_CFLAGS.  Stop.
    make[1]: *** [_module_/home/johnea/src/before/install_drivers/linux_drivers/xpc4drvr2_6/xpc4drvr] Error 2
    make[1]: Leaving directory `/usr/src/linux-2.6.24-ARCH'
    make: *** [default] Error 2

which was corrected by the following brutal hack to the Makefile:

    diff before/install_drivers/linux_drivers/xpc4drvr2_6/xpc4drvr/Makefile  \
          after/install_drivers/linux_drivers/xpc4drvr2_6/xpc4drvr/Makefile

    25c25
    < ifeq ($(GET_USER_SIZE_SYM),0)
    ---
    > #ifeq ($(GET_USER_SIZE_SYM),)
    27c27
    < endif
    ---
    > #endif

This corrected all compilation errors, but the xpc4drvr.ko still yielded
the following error in /var/log/everything.log whenever it was attempted
to be loaded:

    xpc4drvr: Unknown symbol get_user_size

However this did allow compilation of the entire driver tree and the
install script was able to successfully install the drivers via:

    cd install_drivers/
    ./install_drivers

There is also a udev rule entry that will make the driver accessible to
all users after each reboot. (Which I haven't yet applied)

So after this brief modification, I am able to successfully run ISE on
Arch Linux (kernel26 2.6.24) with full USB cable support.

There is a GPL'd libusb based driver mentioned in the Gentoo HOWTO:
http://www.rmdir.de/~michael/xilinx/ that I was particularly interested
in using. However while the source built without error, I continued to
receive runtime errors when attempting to run it in ISE.

I never attempted to use the Xup driver.

There were quite a few pertinent facts along the way that I'm failing to
capture here. Such as the fact that I discovered the same directory:

    install_drivers/

in the base install of the entire ISE package under:

    /opt/Xilinx/10.1/common/bin/lin/install_script/install_drivers/

I would expect that this procedure could be applied directly to that
without the additional step of downloading the install_drivers.tar.gz
but I haven't tried this.

Additionally, as a housekeeping note, the commands above expect all
files to be downloaded and untared in the same working directory.

All in all this is the crux of what was necessary for me to get the USB
support running on Arch.

Sorry for the somewhat fragmented description, but hopefully this allows
others to get this great tool for linux users running on the post 2.6.23
kernels.

Happy Hardware Hacking!!!

> Update 2010-08-02

Comments in the forum thread announcing this wiki entry make reference
to the page:

http://rmdir.de/~michael/xilinx/

This is the upstream source for non-proprietary Xilinx USB drivers using
libusb. This is now the Xilinx recommended linux usb interface and is
shipped with new versions of Xilinx ISE WebPack.

Per a note on the rmdir.de website, newer versions of udev no longer
support the older syntax of the /etc/udev/rules.d/xusbdfwu.rules file:

    * 2010-03-15: If you are using newer udev-versions (like the version included in Debian Squeeze and Ubuntu 9.10), then the file /etc/udev/rules.d/xusbdfwu.rules is incompatible with this udev version. The effect of this is that the cable-firmware gets never loaded and the cable led never lights up.

    To fix this, run the following command as root:
    sed -i -e 's/TEMPNODE/tempnode/' -e 's/SYSFS/ATTRS/g' -e 's/BUS/SUBSYSTEMS/' /etc/udev/rules.d/xusbdfwu.rules
    You may have to reboot for this change to take effect.

I didn't require a reboot for this patch to take affect while running:

    [root@vhost pcusb]# pacman -Q udev
    udev 151-3
    [root@vhost pcusb]# pacman -Q kernel26
    kernel26 2.6.33.4-1

In both the x86_64 host and the i686 chroot.

android

Links
-----

-   http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/archive/2007/03/msg00101.html
-   http://groups.google.com/group/comp.arch.fpga/msg/2dfa36541174a4f2
-   http://groups.google.com/group/comp.arch.fpga/browse_thread/thread/24884c2d0e90b97f
-   http://groups.google.com/group/comp.arch.fpga/browse_thread/thread/f149e5b6028e2c70/066766d9510e407a#066766d9510e407a

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xilinx_ISE_WebPACK&oldid=252784"

Categories:

-   Development
-   Mathematics and science
