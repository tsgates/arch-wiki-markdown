DeveloperWiki:usrlib
====================

All files in the /lib directory have been moved to /usr/lib and now /lib
is a symlink to usr/lib.

During this update, pacman will identify a conflict in the /lib
directory with the message:

    error: failed to commit transaction (conflicting files)
    glibc: /lib exists in filesystem
    Errors occurred, no packages were upgraded.

  

Warning:DO NOT USE --force! This will seriously break your system. If
you are coming to this guide too late and you have already used
--force... there are ways to fix your system. These two do not even
require a rescue disk.

  

Note:for installs that have not been updated to glibc-2.16, it will save
you lots of time and prevent major breakage to do:

    pacman -U http://pkgbuild.com/~allan/glibc-2.16.0-1-<arch>.pkg.tar.xz

where <arch> is replaced by i686 or x86_64 as required. Add a single
"-d" if needed. The instructions below assume that this has been done.

  
 In the simplest case, the update can be performed by doing:

    pacman -Syu --ignore glibc
    pacman -Su

To be safe, also regenerate your initramfs after finishing:

    mkinitcpio -p linux

  

There are two possible issues that might occur during this update.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Issue 1: glibc dependency errors                                   |
| -   2 Issue 2: The final "pacman -Su" still has conflicts in /lib        |
|     -   2.1 Packages that own files in /lib                              |
|     -   2.2 Unpackaged files                                             |
|                                                                          |
| -   3 Success                                                            |
+--------------------------------------------------------------------------+

Issue 1: glibc dependency errors
--------------------------------

If running "pacman -Syu --ignore glibc,curl" gives:

    warning: ignoring package glibc-2.16.0-2
    warning: cannot resolve "glibc>=2.16", a dependency of "gcc-libs"

    ...

    :: The following packages cannot be upgraded due to unresolvable dependencies:
         binutils  gcc  gcc-libs

    Do you want to skip the above packages for this upgrade [y/N]

Say "y" to skipping the packages, then install them all using (e.g.):

    pacman -Sd binutils gcc gcc-libs

Warning:If pacman is part of this list, install the glibc-2.16.0-1
package from the above note first, to prevent breakage.

Note the use of a single "-d" only ignores the versioning of
dependencies and not the actual dependency itself. Then finish the
update using:

    pacman -Su

Issue 2: The final "pacman -Su" still has conflicts in /lib
-----------------------------------------------------------

> Packages that own files in /lib

If after this the "pacman -Su" still has conflicts with /lib, this is
likely because a package on your system other than glibc owns files in
/lib. Such packages can be detected using:

    $ grep '^lib/' /var/lib/pacman/local/*/files

These packages need rebuilding so as not to include the /lib directory.
They can also simply be uninstalled and reinstalled again after
upgrading glibc. The the final "pacman -Su" will successfully install
glibc if there are no untracked files (see the next section).

> Unpackaged files

This means that you have files or folders still in /lib or pacman thinks
a package apart from glibc still own /lib. You can see which package own
files in /lib by using:

    $ find /lib -exec pacman -Qo -- {} +

If any package apart from glibc is listed as owning a file, that package
needs to be updated to install its files in /usr/lib. Any files unowned
by a package should either be deleted or moved to /usr/lib and any
directories within /lib need deleted (after they are empty...).

One common source of files in /lib is left overs from running depmod
after upgrading the kernel, but prior to reboot. The kernel modules
included with the linux package in the repositories are now stored in
/usr/lib/modules.

Success
-------

You can confirm the update is complete by looking in your root directory
to see that lib is a symlink to usr/lib.

    $ ls -ld /lib

    lrwxrwxrwx   1 root root     7 Jul 11 21:10 lib -> usr/lib

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:usrlib&oldid=232588"

Category:

-   DeveloperWiki
