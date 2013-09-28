Kernels/Compilation/Traditional
===============================

The summary below is helpful for building custom kernels from kernel.org
sources. This method of compiling kernels is the traditional method
common to all distros; however, an excellent method of cleanly
installing the custom kernel with makepkg and pacman is also included.

Alternatively, you can use ABS to build and install your kernel; see:
Kernels#Compilation. Using the existing linux PKGBUILD will automate
most of the process and will result in a package. However, some Arch
users prefer the traditional way.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Fetching source                                                    |
|     -   1.1 What about /usr/src/ ?                                       |
|                                                                          |
| -   2 Build configuration                                                |
|     -   2.1 Pre-configuration                                            |
|     -   2.2 Configure your kernel                                        |
|         -   2.2.1 Traditional menuconfig                                 |
|         -   2.2.2 localmodconfig                                         |
|         -   2.2.3 Local version                                          |
|                                                                          |
| -   3 Compilation and installation                                       |
|     -   3.1 Compile                                                      |
|     -   3.2 Install modules                                              |
|     -   3.3 Copy kernel to /boot directory                               |
|     -   3.4 Make initial RAM disk                                        |
|     -   3.5 Copy System.map                                              |
|                                                                          |
| -   4 Bootloader configuration                                           |
| -   5 Using the NVIDIA video driver with your custom kernel              |
+--------------------------------------------------------------------------+

Fetching source
---------------

-   Fetch the kernel source from ftp.xx.kernel.org/pub/linux/kernel/,
    where xx is your country key (e.g. 'us', 'uk', 'de', ... - Check [1]
    for a complete list of mirrors). If you have no ftp gui, you can use
    wget. For this example, we will fetch and compile 3.2.9; you should
    need to change only the version to get a different kernel.

For instance:

    $ wget -c http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.2.9.tar.bz2

-   It is always a good idea to verify the signature for any downloaded
    tarball. See kernel.org/signature for how this works and other
    details.

-   Copy the kernel source to your build directory, e.g.:

    $ cp linux-3.2.9.tar.bz2 ~/kernelbuild/

-   Unpack it and enter the source directory:

    $ cd ~/kernelbuild
    $ tar -xvjf linux-3.2.9.tar.bz2
    $ cd linux-3.2.9

Prepare for compilation by running the following command:

    make mrproper

This ensures that the kernel tree is absolutely clean. The kernel team
recommends that this command be issued prior to each kernel compilation.
Do not rely on the source tree being clean after un-tarring.

> What about /usr/src/ ?

Using the /usr/src/ directory for kernel compilation as root, along with
the creation of the corresponding symlink, is considered poor practice
by some kernel hackers. They consider the cleanest method to simply use
your home directory. If you subscribe to this point of view, build and
configure your kernel as normal user, and install as root, or with
makepkg and pacman.

However, this concept has been the target of debate, and other very
experienced hackers consider the practice of compiling as root under
/usr/src/ to be completely safe, acceptable and even preferable.

Use whichever method you feel more comfortable with.

Build configuration
-------------------

This is the most crucial step in customizing the kernel to reflect your
computer's precise specifications. By setting the configurations in
'menuconfig' properly, your kernel and computer will function most
efficiently.

> Pre-configuration

Optional, but strongly recommended for first-timers:

-   Copy the .config file from the running kernel, if you want to modify
    default Arch settings.

     $ zcat /proc/config.gz > .config

-   Note the output of currently loaded modules with lsmod. This will be
    specific to each system.

> Configure your kernel

Warning: If compiling the radeon driver into the kernel(>3.3.3) for
early KMS with a newer video card, you must include the firmware files
for your card. Otherwise acceleration will be crippled. See here

Tip: It is possible, to configure a kernel without initramfs on simple
configurations. Ensure that all your modules required for
video/input/disks/fs are compiled into the kernel. As well as support
for DEVTMPFS_MOUNT, TMPFS, AUTOFS4_FS at the very least. If in doubt,
learn about these options and what they mean before attempting.

There are two main choices:

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

localmodconfig

Since kernel 2.6.32, this build option is provided to ease minimized
kernel configuration. This is a great shortcut for novices, which should
only select those options which are currently being used.

For maximum effectiveness:

1.  Boot into stock -ARCH kernel, and plug in all devices that you
    expect to use on the system.
2.  In your source directory, and run: $ make localmodconfig
3.  The resulting configuration file will be written to .config. Then
    you can build and install as normal.

Local version

If you are compiling a kernel using your current config file, do not
forget to rename your kernel version, or you may replace your existing
one by mistake.

    $ make menuconfig
    General setup  --->
     (-ARCH) Local version - append to kernel release '3.n.n-RCn'

Compilation and installation
----------------------------

To compile kernel manually, follow these steps:

> Compile

Warning: Do not run make all if you use GRUB and still have LILO
installed; it will configure LILO in the end, and you may no longer be
able to boot your machine! Remove LILO (pacman -R lilo) before running
make all if you use GRUB!

    $ make      (Same as make vmlinux && make modules && make bzImage - see 'make help' for more information on this.)

or

    $ make -jN   (N = # of processors + 1) (This utilizes all CPUs at 100%.)

Compilation time will vary from 15 minutes to over an hour. This is
largely based on how many options/modules are selected, as well as
processor capability.

> Install modules

    # make modules_install

This copies the compiled modules into /lib/modules/[kernel version +
CONFIG_LOCALVERSION]. This way, modules can be kept separate from those
used by other kernels on your machine.

> Copy kernel to /boot directory

    # cp -v arch/x86/boot/bzImage /boot/vmlinuz-YourKernelName

> Make initial RAM disk

The initial RAM disk (initrd option in the GRUB menu, or, the file
"initramfs-YourKernelName.img") is an initial root file system that is
mounted prior to when the real root file system is available. The initrd
is bound to the kernel and loaded as part of the kernel boot procedure.
The kernel then mounts this initrd as part of the two-stage boot process
to load the modules to make the real file systems available and get at
the real root file system. The initrd contains a minimal set of
directories and executables to achieve this, such as the insmod tool to
install kernel modules into the kernel. In the case of desktop or server
Linux systems, the initrd is a transient file system. Its lifetime is
short, only serving as a bridge to the real root file system. In
embedded systems with no mutable storage, the initrd is the permanent
root file system.

If you need any modules loaded in order to mount the root filesystem,
build a ramdisk (most users need this). The -k parameter accepts the
kernel version and appended string you set in menuconfig and is used to
locate the corresponding modules directory in '/usr/lib/modules':

    # mkinitcpio -k FullKernelName -c /etc/mkinitcpio.conf -g /boot/initramfs-YourKernelName.img

You are free to name the /boot files anything you want. However, using
the [kernel-major-minor-revision] naming scheme helps to keep order if
you: Keep multiple kernels/ Use mkinitcpio often/ Build third-party
modules.

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

    vmlinuz-YourKernelName          (Kernel)
    initramfs-YourKernelName.img    (Ramdisk)
    System.map-YourKernelName       (System Map)

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
"https://wiki.archlinux.org/index.php?title=Kernels/Compilation/Traditional&oldid=248012"

Category:

-   Kernel
