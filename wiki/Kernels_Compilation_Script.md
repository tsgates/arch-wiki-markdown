Kernels/Compilation/Script
==========================

NEW, and still more to come: A thoroughly tested BASH script is
available which automates the entire manual compiling process listed
below and encourages the "bleeding edge" philosophy when it comes to the
latest Linux Kernel. This script allows a safe, easy, and alternative
method to using makepkg. It includes an easy-to-use option for patching
a MAINLINE(RC) Kernel release. Recent testing of the mainline kernel
with patch linux-3.1-rc3-git1 (August 24, 2011) resulted in successful
compiling, and installing.
(uname -a:  Linux Galicja 3.1.0-rc3-git1-ARCHMOD #1 PREEMPT Wed Aug 24 03:08:37 CEST 2011 x86_64 Genuine Intel(R) CPU 575 @ 2.00GHz GenuineIntel GNU/Linux).

Procedures:

-   Download the script (See link below procedures).

-   Prior to initially opening or running the file linux_kernel.sh, go
    into root (#) and use chmod to give it appropriate execution
    permissions (755):

    # chmod 755 linux_kernel.sh

-   Download the kernel source for stable, mainline (rc), and snapshot
    (git/patch) from the Linux Kernel website placing the files into the
    appropriate directory (/usr/src).

-   Open up linux_kernel.sh and carefully enter values for only 5
    variables which are required for the script to run, then save the
    file (See sample input area below procedures).

-   Once values have been entered and source files downloaded, run the
    script in root (#):

    # ./linux_kernel.sh

-   While running, one or two pauses which require brief user
    intervention are necessary, and this occurs at the very beginning
    (first minute). The current kernel .config file will be extracted
    and copied from /proc/config.gz to the new kernel directory,
    'menuconfig' will be automatically invoked, and the
    CONFIG_LOCALVERSION value from .config will be obtained and
    utilized. Keep in mind, this script will never override or delete
    any original files (soft-link only) without a warning first, or
    automatic termination. There are numerous checks and controls built
    into it to ensure safe execution. The script works VERY well, so
    enjoy it!

Note: NVIDIA users, please make additional NECESSARY adjustments after
script is completed, PRIOR to rebooting. Feel free to contact the author
for any assistance and/or suggestions.

Script Download

       linux_kernel.sh at Google Docs (Last Updated: Wednesday, August 24, 2011, 10:53 CET)

Sample linux_kernel.sh BASH script Input Area for 5 required variables:

    #==========================================================================
    # Enter 5 Kernel Variable Values Here (You MUST fill in ALL values after "="):

    # Directory Name holding "mainline", "stable" and/or "snapshot"(patch) source files from kernel.org
    # Must end with "/"
    kern_src_dir=/usr/src/

    # File Name of "mainline" or "stable" Linux Kernel (Must be downloaded and reside in the "kern_src_dir" (/usr/src/)
    kern_file_name=linux-3.1-rc3.tar.bz2

    # Is a Patch file involved? YES or NO (Must be CAPITALIZED Letters)
    patch=YES

    # If patch=YES, File Name of "snapshot" patch (Ex. patch-2.6.37-rc1-git12.bz2) residing in "kern_src_dir" (/usr/src/)
    # If patch=NO, then this value does NOT matter. If you wish, enter NONE (patch=NONE)
    patch_file_name=patch-3.1-rc3-git1.bz2

    # To build the kernel in a multithreaded (faster) way, the -j option is used with the 'make' program
    # It is BEST to give a number to the -j option that corresponds to TWICE the number of processors in the system
    # ( Ex. Machine with 1 processor: jval=2, Machine with 2 processors: jval=4, etc.)
    # To disable this option, enter the value zero ("0"): ( Ex. jval=0 )
    jval=0
    #==========================================================================

Sample Output at End of Script:

                                *Summary of Changes - File(s) Created and/or Deleted*

                                   8 File(s) Created:

                                   /usr/src/linux-3.1-rc3-git1-KNL/
                                   /boot/vmlinuz-3.1-rc3-git1-ARCHMOD
                                   /boot/kernel30-3.1-rc3-git1-ARCHMOD.img
                                   /lib/modules/3.1.0-rc3-git1-ARCHMOD/
                                   /usr/src/linux
                                   /usr/src/linux-3.0
                                   /boot/System.map-3.1-rc3-git1
                                   /boot/System.map

                                   3 File(s) Deleted:

                                   /boot/System.map
                                   /usr/src/linux
                                   /usr/src/linux-3.0


                                       *SUCCESS - Main Processes COMPLETE*

                          *NVIDIA users, please make additional NECESSARY adjustments*

              *Please Configure /boot/grub/menu.lst accordingly and you are done. Then REBOOT & TEST!*

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernels/Compilation/Script&oldid=207201"

Category:

-   Kernel
