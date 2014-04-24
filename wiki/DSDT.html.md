DSDT
====

Related articles

-   ACPI modules
-   acpid

DSDT (Differentiated System Description Table) is a part of the ACPI
specification. It supplies information about supported power events in a
given system. ACPI tables are provided in firmware from the
manufacturer. A common Linux problem is missing ACPI functionality, such
as: fans not running, screens not turning off when the lid is closed,
etc. This can stem from DSDTs made with Windows specifically in mind,
which can be patched after installation. The goal of this article is to
analyze and rebuild a faulty DSDT, so that the kernel can override the
default one.

Basically a DSDT table is the code run on ACPI (Power Management)
events.

Note:The goal of the Linux ACPI[dead link 2013-10-26] project is that
Linux should work on unmodified firmware. If you still find this type of
workaround necessary on modern kernels then you should consider
submiting a bug report.

Contents
--------

-   1 Before you start...
    -   1.1 Tell the kernel to report a version of Windows
    -   1.2 Find a fixed DSDT
-   2 Recompiling it yourself
-   3 Using modified code
    -   3.1 Compile into kernel
    -   3.2 Loading at runtime

Before you start...
-------------------

-   It is possible that the hardware manufacturer has released an
    updated firmware which fixes ACPI related problems. Installing an
    updated firmware is often preferred over this method because it
    would avoid duplication of effort.
-   This process does tamper with some fairly fundamental code on your
    installation. You will want to be absolutely sure of the changes you
    make. You might also wish to clone your disk beforehand.
-   Even before attempting to fix your DSDT yourself, you can attempt a
    couple of different shortcuts:

> Tell the kernel to report a version of Windows

Use the variable acpi_os_name as a kernel parameter. For example:

     acpi_os_name="Microsoft Windows NT"

Or

     acpi_osi="!Windows2012"

appended to the kernel line in grub legacy configuration

other strings to test:

-   "Microsoft Windows XP"
-   "Microsoft Windows 2000"
-   "Microsoft Windows 2000.1"
-   "Microsoft Windows ME: Millennium Edition"
-   "Windows 2001"
-   "Windows 2006"
-   "Windows 2009"
-   "Windows 2012"
-   when all that fails, you can even try "Linux"

Out of curiousity, you can follow the steps below to extract your DSDT
and search the .dsl file. Just grep for "Windows" and see what pops up.

> Find a fixed DSDT

A DSDT file is originally written in ACPI Source language (an .asl/.dsl
file). Using a compiler this can produce an 'ACPI Machine Language' file
(.aml) or a hex table (.hex). To incorporate the file in your Arch
install, you will need to get hold of a compiled .aml file. - whether
this means compiling it yourself or trusting some stranger on the
Internet is at your discretion. If you do download a file from the world
wide web, it will most likely be a compressed .asl file. So you will
need to unzip it and compile it. The upside to this is that you won't
have to research specific code fixes yourself.

Arch users with the same laptop as you are: a minority of a minority of
a minority. Try browsing other distro/linux forums for talk about the
same model. Likelihood is that they have the same problems and either
because there is a lot of them, or because they're tech savvy -- someone
there has produced a working DSDT and maybe even provides a precompiled
version (again, use at your own risk). Search engines are your best
tools. Try keeping it short: 'model name' + 'dsdt' will probably produce
results.

Recompiling it yourself
-----------------------

Your best resources in this endeavor are going to be The Gentoo wiki
article, ACPI Spec homepage, and Linux ACPI Project which supercedes the
activity that occurred at acpi.sourceforge.net. In a nutshell, you can
use Intel's ASL compiler to turn your systems DSDT table into source
code, locate/fix the errors, and recompile. This process is detailed
more comprehensively at the Gentoo wiki. You'll need to install iasl to
modify code, and be familiar with Kernel_Compilation#Compilation to
install it.

What compiled the original code? Check if your system's DSDT was
compiled using Intel or Microsoft compiler:

     $ dmesg|grep DSDT 

    ACPI: DSDT 00000000bf7e5000 0A35F (v02 Intel  CALPELLA 06040000 INTL 20060912)
    ACPI: EC: Look up EC in DSDT

In case Microsoft's compiler had been used, abbreviation INTL would
instead be MSFT. In the example, there were 5 errors on
decompiling/recompiling the DSDT. Two of them were easy to fix after a
bit of googling and delving into the ACPI specification. Three of them
were due to different versions of compiler used and are, as later
discovered, handled by the ACPICA at boot-time. The ACPICA component of
the kernel can handle most of the trivial errors you get while compiling
the DSDT. So do not fret yourself over compile errors if your system is
working the way it should.

1.) Extract ACPI tables (as root):
# cat /sys/firmware/acpi/tables/DSDT > dsdt.dat

2.) Decompile: iasl -d dsdt.dat

3.) Recompile: iasl -tc dsdt.dsl

4.) Examine errors and fix. e.g.:

    dsdt.dsl   6727:                         Name (_PLD, Buffer (0x10)  
    Error    4105 -          Invalid object type for reserved name ^  (found BUFFER, requires Package) 

     nano +6727 dsdt.dsl

    (_PLD, Package(1) {Buffer (0x10)...

5.) Compile fixed code: iasl -tc dsdt.dsl (Might want to try option -ic
for C include file to insert into kernel source)

If it says no errors and no warnings you should be good to go.

Using modified code
-------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Detail each      
                           method (Discuss)         
  ------------------------ ------------------------ ------------------------

There are 2 ways to use a custom DSDT Table:

-   compiling the custom DSDT into the kernel
-   loading the custom DSDT at runtime (not supported)

> Compile into kernel

Warning:After each BIOS update you need to fix DSDT again and compile it
into kernel again

You'll want to be familiar with compiling your own kernel. The most
straightforward way is with the "traditional" approach. After compiling
DSDT, iasl produce two files: dsdt.hex and dsdt.aml.

Using menuconfig:

-   Disable "Select only drivers that don't need compile-time external
    firmware". Located in "Device Drivers -> Generic Driver Options".
-   Enable "Include Custom DSDT" and specify the absolute path of your
    fixed DSDT file (dsdt.hex, not dsdt.aml). Located in "Power
    management and ACPI options -> ACPI (Advanced Configuration and
    Power Interface) Support".

  
 Check if you running custom DSDT

Simply type dmesg | grep DSDT

You will see something like that:

    [    0.000000] ACPI: Override [DSDT-   A M I], this is unsafe: tainting kernel
    [    0.000000] ACPI: DSDT 00000000be9b1190 Logical table override, new table: ffffffff81865af0
    [    0.000000] ACPI: DSDT ffffffff81865af0 0BBA3 (v02 ALASKA    A M I 000000F3 INTL 20130517)

If you see ...ACPI: Override..., you're running custom DSDT.

  

> Loading at runtime

Warning:Loading at runtime don't supports. DSDT hook removed due to bug,
see FS#27906 bug

Luckily the Arch stock kernel supports using a custom DSDT so, first
copy the .aml file compiled by iasl to:

    /boot/dsdt.aml

The bootloader will replace the DSDT so we need a method to include our
custom DSDT table into the bootloader image. Copy the following to
/etc/grub.d/01_acpi

    #!/bin/sh
    set -e

    # Uncomment to load custom ACPI table
    GRUB_CUSTOM_ACPI="/boot/dsdt.aml"


    # DON'T MODIFY ANYTHING BELOW THIS LINE!


    prefix=/usr
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib


    . /usr/share/grub/grub-mkconfig_lib
    #. ${libdir}/grub/grub-mkconfig_lib


    # Load custom ACPI table
    if [ x${GRUB_CUSTOM_ACPI} != x ] && [ -f ${GRUB_CUSTOM_ACPI} ] \
            && is_path_readable_by_grub ${GRUB_CUSTOM_ACPI}; then
        echo "Found custom ACPI table: ${GRUB_CUSTOM_ACPI}" >&2
        prepare_grub_to_access_device `${grub_probe} --target=device ${GRUB_CUSTOM_ACPI}` | sed -e "s/^/  /"
        cat << EOF
    acpi (\$root)`make_system_path_relative_to_its_root ${GRUB_CUSTOM_ACPI}`
    EOF
    fi

Make sure to make this file executable, or it will be ignored by
grub-mkconfig

    chmod +x /etc/grub.d/01_acpi

This will tell GRUB to include the DSDT into its core.img (change
GRUB_CUSTOM_ACPI to reflect the path to your .aml file). Next you will
need a new boot image. If you use GRUB run:

    grub-mkconfig -o /boot/grub/grub.cfg

Lastly, recreate your initrd

    mkinitcpio -p linux

and reboot. Done!

To check if you are really using your own DSDT read your table again
# cat /sys/firmware/acpi/tables/DSDT > dsdt.dat and decompile it with
iasl -d dsdt.dat

Retrieved from
"https://wiki.archlinux.org/index.php?title=DSDT&oldid=290948"

Categories:

-   Boot process
-   Kernel
-   Power management

-   This page was last modified on 30 December 2013, at 17:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
