Kernels/Compilation/Arch Build System
=====================================

The Arch Build System can be used to build a custom kernel based on the
official linux package. This compilation method can automate the entire
process, and is based on a very well tested package. You can edit the
PKGBUILD to use a custom kernel configuration or add additional patches.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Getting the Ingredients                                            |
| -   2 Modifying the PKGBUILD                                             |
|     -   2.1 Changing build()                                             |
|                                                                          |
| -   3 Compiling                                                          |
| -   4 Installing                                                         |
| -   5 Boot Loader                                                        |
+--------------------------------------------------------------------------+

Getting the Ingredients
-----------------------

    # pacman -S abs base-devel

First of all, you need a clean kernel to start your customization from.
Fetch the kernel package files from ABS:

    $ ABSROOT=. abs core/linux

If you have some problem with the firewall blocking the rsync port, you
can try with -t, which uses the tarball to sync.

    $ ABSROOT=. abs core/linux -t

Then, get any other file you need (e.g. custom configuration files,
patches, etc.) from the respective sources.

Modifying the PKGBUILD
----------------------

Modify pkgbase for your custom package name, e.g.:

     pkgbase=linux-custom

If you dont want to build -headers or -docs package, remove them from
pkgname at the bottom of the file, e.g.:

     pkgname=("${pkgbase}")

> Changing build()

If you need to change a few config options you can use the default one
and append your options the config file:

    $ echo '
    CONFIG_DEBUG_INFO=y
    CONFIG_FOO=n
    ' >> config.x86_64

Or you can use GUI tool to tweak the options. Uncomment one of the
possibilities shown in the build() function of the PKGBUILD, e.g.:

    PKGBUILD

    ...
      # load configuration
      # Configure the kernel. Replace the line below with one of your choice.
      #make menuconfig # CLI menu for configuration
      make nconfig # new CLI menu for configuration
      #make xconfig # X-based configuration
      #make oldconfig # using old config from previous kernel version
      # ... or manually edit .config
    ...

  
 If you have already a kernel config file, I suggest to uncomment one
interactive config tool, such as nconfig, and load your config from
there. This avoids problems with kernel naming I have met with other
methods.

Note:If you uncomment return 1, you can change to the kernel source
directory after makepkg finishes extraction and then make nconfig. This
lets you configure the kernel over multiple sessions. When you're ready
to compile, copy the .config file over top of either config or
config.x86_64 (depending on your architecture), comment return 1 and use
makepkg -i. But not use this for custom patch, put you patch commands
after these lines. If you do patch manually bztar unpack and replace
your patch.

Compiling
---------

Tip:Running compilation jobs simultaneously can reduce compilation time
significantly on multi-core systems.

You can now proceed to compile you kernel by the usual command makepkg
If you have chosen an interactive program for configuring the kernel
parameters (like menuconfig), you need to be there during the
compilation.

Note:A kernel needs some time to be compiled. 1h is not unusual.

Installing
----------

After the makepkg, you can have a look at the linux.install file. You
will see that some variables have changed. Now, you only have to install
the package as usual with pacman (or equivalent program):

    # pacman -U <kernel_package>

Boot Loader
-----------

Now, the folders and files for your custom kernel have been created,
e.g. /boot/vmlinuz-linux-test. To test your kernel, update your
bootloader (/boot/grub/menu.lst for GRUB) and add new entries ('default'
and 'fallback') for your custom kernel. That way, you can have both the
stock kernel and the custom one to choose from.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernels/Compilation/Arch_Build_System&oldid=254750"

Category:

-   Kernel
