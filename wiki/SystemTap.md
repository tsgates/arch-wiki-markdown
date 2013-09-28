SystemTap
=========

SystemTap provides free software (GPL) infrastructure to simplify the
gathering of information about the running Linux system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Easy and fast                                                      |
|     -   1.1 Prepare                                                      |
|     -   1.2 modify config                                                |
|     -   1.3 Update checksum                                              |
|     -   1.4 Build and Install                                            |
|     -   1.5 SystemTap                                                    |
|                                                                          |
| -   2 Build custom kernel                                                |
| -   3 Troubleshooting                                                    |
|     -   3.1 Pass 4 fails when launching                                  |
|     -   3.2 System.map is missing                                        |
+--------------------------------------------------------------------------+

Easy and fast
-------------

Officially, it is recommended to build a linux-custom package to run
SystemTap, but rebuilding the original linux package can be very easy
and efficient.

> Prepare

You can run ABSROOT=. abs core/linux; cd core/linux to get the original
kernel build files. Then use makepkg --verifysource to get the
additional files. By performing the verification, you can safely skip
the step of "Update checksum".

> modify config

Edit config (for 32-bit systems) or config.x86_64 (for 64-bit systems),
turn on these options:

-   CONFIG_KPROBES=y
-   CONFIG_KPROBES_SANITY_TEST=n
-   CONFIG_KPROBE_EVENT=y
-   CONFIG_NET_DCCPPROBE=m
-   CONFIG_NET_SCTPPROBE=m
-   CONFIG_NET_TCPPROBE=y
-   CONFIG_DEBUG_INFO=y
-   CONFIG_DEBUG_INFO_REDUCED=n
-   CONFIG_X86_DECODER_SELFTEST=n

By default only CONFIG_DEBUG_INFO and CONFIG_DEBUG_INFO_REDUCED are not
set.

With current core/linux (3.6.10) you can simply append these lines into
config[.x86_64]:

    x86_64


    echo '
    CONFIG_KPROBES=y
    CONFIG_KPROBES_SANITY_TEST=n
    CONFIG_KPROBE_EVENT=y
    CONFIG_NET_DCCPPROBE=m
    CONFIG_NET_SCTPPROBE=m
    CONFIG_NET_TCPPROBE=y
    CONFIG_DEBUG_INFO=y
    CONFIG_DEBUG_INFO_REDUCED=n
    CONFIG_X86_DECODER_SELFTEST=n
    ' >> config.x86_64

> Update checksum

You can safely skip this step if you believe the source files are
correct.

Run md5sum config[.x86_64] to get a new md5sum.

In PKGBUILD file, the md5sums=('sum-of-first' ... 'sum-of-last') has the
same order with source=('first-source' ... 'last-source'), put your new
md5sum in the right place.

> Build and Install

Optional: you can set MAKEFLAGS="-j16" in /etc/makepkg.conf to speed up
the compilation.

Run makepkg or makepkg --skipchecksums to compile, then simply
sudo pacman -U *.pkg.tar.gz to install the packages. pacman will tell
you reinstall, That's great!

linux and linux-headers should be reinstalled, linux-docs does not
matter.

Via this method, external modules (e.g. nvidia and virtualbox) don't
need to be rebuilt.

> SystemTap

Simply install SystemTap from AUR: systemtap, all done.

However, the SystemTap package in AUR seems to be outdated. You could
also try a newer version of PKGBUILD from this site: [1].

Build custom kernel
-------------------

Please reference this README

Troubleshooting
---------------

> Pass 4 fails when launching

If you have:

       /usr/share/systemtap/runtime/stat.c:214:2: error: 'cpu_possible_map' undeclared (first use in this function)

Try to install systemtap-git package

> System.map is missing

You can recover it where you build your linux kernel with DEBUG_INFO
enabled

       cp src/linux-3.6/System.map /boot/System.map-3.6.7-1-ARCH

Retrieved from
"https://wiki.archlinux.org/index.php?title=SystemTap&oldid=254690"

Category:

-   Kernel
