Kernels/Compilation/Traditional
===============================

This article is an introduction to building custom kernels from
kernel.org sources. This method of compiling kernels is the traditional
method common to all distributions. If this seems too complicated, see
some alternatives at: Kernels#Compilation

Contents
--------

-   1 Fetching source
    -   1.1 What about /usr/src/ ?
-   2 Build configuration
    -   2.1 Configure your kernel
        -   2.1.1 First-timers
        -   2.1.2 Traditional menuconfig
        -   2.1.3 Versioning
-   3 Compilation and installation
    -   3.1 Compile
    -   3.2 Install modules
    -   3.3 Copy kernel to /boot directory
    -   3.4 Make initial RAM disk
    -   3.5 Copy System.map
-   4 Bootloader configuration
-   5 Using the NVIDIA video driver with your custom kernel

Fetching source
---------------

-   Fetch the kernel source from http://www.kernel.org. This can be done
    with GUI or text-based tools that utilize: HTTP, FTP, RSYNC, or Git.

For instance, using wget via http:

    $ wget -c https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.4.tar.xz

-   It is always a good idea to verify the signature for any downloaded
    tarball. See kernel.org/signature for how this works and other
    details.

-   Copy the kernel source to your build directory, e.g.:

    $ cp linux-3.10.4.tar.xz ~/kernelbuild/

-   Unpack it and enter the source directory:

    $ cd ~/kernelbuild
    $ tar -xvJf linux-3.10.4.tar.xz
    $ cd linux-3.10.4

Prepare for compilation by running the following command:

    make mrproper

This ensures that the kernel tree is absolutely clean. The kernel team
recommends that this command be issued prior to each kernel compilation.
Do not rely on the source tree being clean after un-tarring.

> What about /usr/src/ ?

Using /usr/src/ for compilation as root, along with the creation of the
corresponding symlink, has been the target of much debate.

-   It is considered poor practice by some users. They consider the
    cleanest method to simply use your home directory for configuring
    and compiling. Then installing as root.

-   Other experienced users consider the practice of the entire
    compiling process as root to be completely safe, acceptable, and
    even preferable.

Use whichever method you feel more comfortable with. The following
instructions can be interchangeable for either method.

Build configuration
-------------------

This is the most crucial step in customizing the kernel to reflect your
computer's precise specifications. By setting the options in .config
properly, your kernel and computer will function most efficiently.

> Configure your kernel

Warning: If compiling the radeon driver into the kernel(>3.3.3) for
early KMS with a newer video card, you must include the firmware files
for your card. Otherwise acceleration will be crippled. See here

Tip: It is possible, to configure a kernel that does not require
initramfs on simple configurations. Ensure that all your modules
required for video/input/disks/fs are compiled into the kernel. As well
as support for DEVTMPFS_MOUNT, TMPFS, AUTOFS4_FS at the very least. If
in doubt, learn about these options and what they mean before
attempting.

First-timers

Two options for beginners to ease use or save time:

-   Copy the .config file from the running kernel, if you want to modify
    default Arch settings.

     $ zcat /proc/config.gz > .config

-   localmodconfig Since kernel 2.6.32, this should only select those
    options which are currently being used.
    1.  Boot into stock -ARCH kernel, and plug in all devices that you
        expect to use on the system.
    2.  cd into your source directory and run: $ make localmodconfig
    3.  The resulting configuration file will be written to .config. You
        can then compile and install as stated below.

Traditional menuconfig

$ make menuconfig

This will start with a fresh .config, unless one already exists (e.g.
copied over). Option dependencies are automatically selected. And new
options (i.e. with an older kernel .config) may or may not be
automatically selected.

Make your changes to the kernel and save your config file. It is a good
idea to make a backup copy outside the source directory, since you could
be doing this multiple times until you get all the options right. If
unsure, only change a few options between compiles. If you cannot boot
your newly built kernel, see the list of necessary config items here.
Running $ lspci -k # from liveCD lists names of kernel modules in use.
Most importantly, you must maintain CGROUPS support. This is necessary
for systemd.

Versioning

If you are compiling a kernel using your current config file, do not
forget to rename your kernel version, or you may replace your existing
one by mistake.

    $ make menuconfig
    General setup  --->
     (-ARCH) Local version - append to kernel release '3.n.n-RCn'

Compilation and installation
----------------------------

> Compile

Compilation time will vary from 15 minutes to over an hour. This is
largely based on how many options/modules are selected, as well as
processor capability. See Makeflags for details.

Warning: If you use GRUB and still have LILO installed; make all will
configure LILO, and may result in an unbootable system.

Run  $ make .

> Install modules

    # make modules_install

This copies the compiled modules into
/lib/modules/[kernel version + CONFIG_LOCALVERSION]. This way, modules
can be kept separate from those used by other kernels on your machine.

> Copy kernel to /boot directory

    # cp -v arch/x86/boot/bzImage /boot/vmlinuz-YourKernelName

> Make initial RAM disk

If you do not know what this is, please see: Initramfs on Wikipedia and
mkinitcpio.

    # mkinitcpio -k FullKernelName -c /etc/mkinitcpio.conf -g /boot/initramfs-YourKernelName.img

You are free to name the /boot files anything you want. However, using
the [kernel-major-minor-revision] naming scheme helps to keep order if
you:

-   Keep multiple kernels
-   Use mkinitcpio often
-   Build third-party modules.

Tip: If rebuilding images often, it might be helpful to create a
separate preset file resulting in the command being something
like:# mkinitcpio -p custom. See here

If you are using LILO and it cannot communicate with the kernel
device-mapper driver, you have to run modprobe dm-mod first.

> Copy System.map

The System.map file is not required for booting Linux. It is a type of
"phone directory" list of functions in a particular build of a kernel.
The System.map contains a list of kernel symbols (i.e function names,
variable names etc) and their corresponding addresses. This "symbol-name
to address mapping" is used by:

-   Some processes like klogd, ksymoops etc
-   By OOPS handler when information has to be dumped to the screen
    during a kernel crash (i.e info like in which function it has
    crashed).

Copy System.map to /boot and create symlink

    # cp System.map /boot/System.map-YourKernelName

After completing all steps above, you should have the following 3 files
and 1 soft symlink in your /boot directory along with any other
previously existing files:

-   Kernel: vmlinuz-YourKernelName
-   Initramfs-YourKernelName.img
-   System Map: System.map-YourKernelName

Bootloader configuration
------------------------

Add an entry for your amazing new kernel in your bootloader's
configuration file - see GRUB, LILO, GRUB2 or Syslinux for examples.

Tip: Kernel sources include a script to automate the process for LILO:
$ arch/x86/boot/install.sh. Remember to type lilo as root at the prompt
to update it.

Using the NVIDIA video driver with your custom kernel
-----------------------------------------------------

To use the NVIDIA driver with your new custom kernel, see: How to
install nVIDIA driver with custom kernel. You can also install nvidia
drivers from AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernels/Compilation/Traditional&oldid=301981"

Category:

-   Kernel

-   This page was last modified on 25 February 2014, at 06:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
