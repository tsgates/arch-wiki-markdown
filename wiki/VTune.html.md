VTune
=====

Contents
--------

-   1 VTune Amplifier XE 2013
    -   1.1 Missing asm/system.h
    -   1.2 Implicit declaration of this_cpu_read
    -   1.3 kmap_atomic and kunmap_atomic deprecated
-   2 VTune Amplifier XE 2011
    -   2.1 Installing VTune
-   3 VTune 9.1
    -   3.1 Installing VTune
    -   3.2 Installing driver

VTune Amplifier XE 2013
-----------------------

Follow the instructions for 2011. If you see errors while building the
driver, it may be because intel is using deprecated functionality
subsections. In the following sections, lines beginning with "-"
indicates code that should be removed, lines beginning with "+" should
be added.

Note:The following steps should not be need as of update5.

> Missing asm/system.h

Edit lwpmudrv.c as follows:

    -#include <asm/system.h>
    +#include <linux/version.h>

> Implicit declaration of this_cpu_read

Edit eventmux.c as follows:

    +#include <linux/percpu.h>

> kmap_atomic and kunmap_atomic deprecated

Edit vtssp/user_vm.c as follows:

    -this->m_maddr = kmap_atomic(this->m_page, in_nmi() ? KM_NMI : KM_IRQ0);
    +this->m_maddr = kmap_atomic(this->m_page);
    -kunmap_atomic(this->m_maddr, in_nmi() ? KM_NMI : KM_IRQ0);
    +kunmap_atomic(this->m_maddr);

VTune Amplifier XE 2011
-----------------------

Starting with update 7 of the VTune Amplifier XE 2011, you can now use
it on Linux 3.x and hence on Archlinux, even though the latter is not
officially supported. See also: VTune on Archlinux

> Installing VTune

Using the following HOWTO you "install" VTune locally and can run it.
Vtune requires a kernel module for all functionality. Nevertheless,
VTune in user mode is very powerful and comes with lots of possibilities
for profiling. Have fun!

Preparation:

-   download VTune Amplifier XE 2011 (there is a free version for
    non-commercial use on linux)
-   unpack the tarball
-   install libpng12 from AUR
-   install libjpeg6 from AUR
-   install rpmextract from extra repo
-   install linux-headers from core
-   if using a custom kernel, ensure that your kernel is compiled with
    the following options:
    -   CONFIG_MODULES=y
    -   CONFIG_MODULE_UNLOAD=y
    -   CONFIG_SMP=y
    -   CONFIG_KPROBES=y
    -   CONFIG_PROFILING=y
    -   CONFIG_OPROFILE=y

Now to "install" vtune:

    cd vtune_amplifier_xe_2011_update7
    find -name "*.rpm" -exec rpmextract.sh {} \;

Kernel module:

-   Create the group vtune and add yourself.
-   Build and load the driver in
    /opt/intel/vtune_amplifier_xe_2011/sepdk/src/

    ./build-driver
    ./insmod-sep3 -g vtune

-   Add your license file to /opt/intel/licenses/

You can now start vtune:

    ./opt/intel/vtune_amplifier_xe_2011/bin64/amplxe-gui

For ease-of-use I suggest you move the
./opt/intel/vtune_amplifier_xe_2011 to your homefolder or similar and
add a symlink to the amplxe-gui binary to one of your PATH folders or
similar.

VTune 9.1
---------

Installing Intel VTune 9.1 on Arch Linux

> Installing VTune

-   download VTune
-   download patch
-   unpack VTune and patch its scripts
-   install rpm from AUR/rpm4
-   do rpm --initdb
-   run VTune installer

> Installing driver

(VTune does not work on my 2.6.31 kernel, so you may be need to install
kernel26-lts)

-   download driver patch
-   copy the driver sources from /opt/intel/vtune/vdk/src to a new
    directory and patch them.
-   do ./configure and make
    -   if your build fails with 'the frame size of 1140 bytes is larger
        than 1024 bytes', append -Wframe-larger-than=2048 to
        EXTRA_CFLAGS in Makefile
-   cp vtune_drv*.ko /lib/modules/misc/vtune_drv.ko # copy the module to
    the kernel modules directory
-   depmod -AeF /boot/System.map26 #rebuild module maps and resolve
    symbols
-   modprobe vtune_drv #activate the module
    -   As of kernel 2.6.31 there was an api change,
        find_task_by_pid_ns() cannot be found. The only recourse is to
        downgrade your kernel to 2.6.30 or to wait for Intel to update
        the driver source code. If someone has a patch that resolves the
        issue you can post it here.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VTune&oldid=249913"

Category:

-   Development

-   This page was last modified on 8 March 2013, at 11:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
