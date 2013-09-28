Dynamic Kernel Module Support
=============================

Dynamic Kernel Module Support allows one to compile and install kernel
modules without recompiling the entire kernel.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Guidelines                                                         |
|     -   4.1 Package name                                                 |
|     -   4.2 Where should source go?                                      |
|     -   4.3 Where should patches be applied?                             |
|     -   4.4 Should the .install file attempt to modprobe/rmmod the       |
|         module?                                                          |
|     -   4.5 How to create .install / dkms.conf files?                    |
|     -   4.6 DKMS breaks the ABS                                          |
|     -   4.7 namcap issues                                                |
|                                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install package dkms in the Official Repositories.

After installing the DKMS, you still need to install a DKMS package such
as nvidia-dkms, otherwise having DKMS installed is just wasting your
disk space.

Configuration
-------------

To get modules get rebuilt automatically after a kernel upgrade, enable
the dkms service. This service will build DKMS modules if they were not
already available and then exit. For systemd:

    # systemctl enable dkms.service

Sometimes, a program depends on the module. If that program is started
before the DKMS module is built, you often need to reboot (or restart
that program). An example are the proprietary graphics drivers such as
nvidia and catalyst.

Usage
-----

If you have just upgraded your kernel and want to avoid a reboot, you
can trigger a rebuild for all modules by executing
dkms autoinstall -k NEW_KERNEL_VERSION as root. This will build and
install DKMS modules for all available kernel versions if they have not
been built before.

Forcing a build of a specific module for a specific kernel version is
also possible, for example:

    # dkms install -m nvidia -v 304.51 -k 3.6.2-1-ARCH

Hint: use tab completion to get the module and kernel version.

Guidelines
----------

Here are some guidelines to follow.

> Package name

DKMS packages are named by appending -dkms to their non-DKMS counterpart
(or the module name if no counterpart can be found).

> Where should source go?

DKMS by default uses /usr/src/, but [namcap] complains that is a
non-standard directory. (Even though the FHS reference namcap uses
states that /usr/src is "optional". One could place the source in
/opt/<package> and then sym-link it (which is what some non-DKMS
packages do.)

Sources should go into /usr/src/<package>-<package version> which is the
default directory that DKMS commands use. <package> is the "true package
name" (which is usually the PKGBUILD $_pkgname variable, which is the
$pkgname minus the "dkms-" prefix). <package version> refers to the
PACKAGE_VERSION field in dkms.conf. By convention, PKGBUILDs $pkgver
should have the same value.

> Where should patches be applied?

One could patch the source either in the PKGBUILD or through DKMS. Since
non-DKMS packages patch from the PKGBUILD, and to keep the DKMS PKGBUILD
as close to the non-DKMS version, I am patching in the PKGBUILD.

> Should the .install file attempt to modprobe/rmmod the module?

No, it should not. Consider a module that crashes when loaded. That
could halt a pacman upgrade or installation which has more severe
consequences.

Loading/ removing modules is a task for the user.

> How to create .install / dkms.conf files?

Try to avoid updating things like version numbers in multiple files. Try
to avoid cluttering up PKGBUILDs/.install files with DKMS-specific
stuff. (This keeps them closer to the non-DKMS files).

I've just started using a simple bash script to create the dkms.conf
file and to replace text in an install.template file. This leads to much
cleaner and easier to understand files.

You should not run depmod in your .install script, this is done
automatically by dkms install. Running dkms install depends on
dkms build which depends on dkms add and are executed automatically.
Thus, you only need to put the sources in /usr/src/MODULE-VERSION and
run dkms install in your .install script.

Example for a module put in /usr/src/MODULE-VERSION (substitute MODULE
and PACKAGE_NAME accordingly):

    post_install() {
        dkms install -m MODULE -v ${1%%-*}
    }
    pre_upgrade() {
        local curver=${2%%-*}
        # $2 is unset due to a bug. See, https://bugs.archlinux.org/task/32278
        # Query current version using pacman as fallback
        [ -n "$curver" ] || curver=$(pacman -Q PACKAGE_NAME | cut -d' ' -f2)
        pre_remove $curver
    }
    post_upgrade() {
        post_install ${1%%-*}
    }
    pre_remove() {
        dkms remove -m MODULE -v ${1%%-*} --all
    }

> DKMS breaks the ABS

Sort of, yes. The problem is that the resulting modules don't belong to
the package, so pacman can't track or report on them.

I don't think that's a show-stopper, but it probably puts DKMS out on
the fringe a bit. There is some talk about pacman adding similar support
through pacman hooks. [1]. I think you could "fake" the ownership, by
installing the module as normal (or even a "dummy" file) and just
letting DKMS overwrite it.

> namcap issues

As mentioned earlier, namcap complains if you put source in /usr/src.
Also, namcap can not detect that dkms is a dependency. (I guess maybe
it's not technically a dependency, but...)

Basically, take the dependencies of the non-DKMS version, add 'dkms' and
remove 'linux-headers' (since dkms optdepends on that)

See Also
--------

-   Dell's DKMS man page Official site.
-   Ubuntu's DKMS man page (Documents some officially un-documented
    bits.)
-   Exploring Dynamic Kernel Module Support

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dynamic_Kernel_Module_Support&oldid=253370"

Category:

-   Kernel
