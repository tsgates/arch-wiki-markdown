SELinux
=======

Security-Enhanced Linux (SELinux) is a Linux feature that provides a
variety of security policies, including U.S. Department of Defense style
mandatory access controls (MAC), through the use of Linux Security
Modules (LSM) in the Linux kernel. It is not a Linux distribution, but
rather a set of modifications that can be applied to Unix-like operating
systems, such as Linux and BSD. Its architecture strives to streamline
the volume of software charged with security policy enforcement, which
is closely aligned with the Trusted Computer System Evaluation Criteria
(TCSEC, referred to as Orange Book) requirement for trusted computing
base (TCB) minimization (applicable to evaluation classes B3 and A1) but
is quite unrelated to the least privilege requirement (B2, B3, A1) as is
often claimed. The germinal concepts underlying SELinux can be traced to
several earlier projects by the U.S. National Security Agency (NSA). [1]

Running SELinux under a Linux distribution requires three things: An
SELinux enabled kernel, SELinux Userspace tools and libraries, and
SELinux Policies (mostly based on the Reference Policy). Some common
Linux programs will also need to be patched/compiled with SELinux
features.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Installing needed packages                                         |
|     -   2.1 Package description                                          |
|         -   2.1.1 SELinux aware system utils                             |
|         -   2.1.2 SELinux userspace                                      |
|         -   2.1.3 SELinux policy                                         |
|         -   2.1.4 Other SELinux tools                                    |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Changing boot loader configuration                           |
|     -   3.2 Mounting selinuxfs                                           |
|     -   3.3 Main SELinux configuration file                              |
|     -   3.4 Set up PAM                                                   |
|                                                                          |
| -   4 Reference policy                                                   |
|     -   4.1 Installing a precompiled refpolicy                           |
|     -   4.2 Installing refpolicy from a source package                   |
|                                                                          |
| -   5 Post-installation steps                                            |
| -   6 Useful tools                                                       |
| -   7 References                                                         |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Prerequisites
-------------

Only ext2, ext3, ext4, JFS and XFS filesystems are supported to use
SELinux.

Note: This is probably not needed anymore:

XFS users should use 512 byte inodes (the default is 256). SELinux uses
extended attributes for storing security labels in files. XFS stores
this in the inode, and if the inode is too small, an extra block has to
be used, which wastes a lot of space and incurs performance penalties.

     # mkfs.xfs -i size=512 /dev/sda1  (for example)

Installing needed packages
--------------------------

You should install at least linux-selinux, selinux-pam,
selinux-usr-policycoreutils and selinux-refpolicy-src from the AUR.
Installing all SELinux-related packages is recommended.

When installing from the AUR, you can use an AUR helper or download
tarballs from the AUR manually and build with makepkg. Especially when
installing for the first time, take extreme caution when replacing the
pam and coreutils packages, as they are vital to your system. Having the
Arch Linux live CD or live USB drive ready to use is strongly
encouraged.

Warning: Do not remove pam via sudo, as PAM is what takes care of
authentication, and you just removed it. Instead first su to root and
then do:

    pacman -Rdd pam
    pacman -U selinux-pam

Doing pacman -Rdd coreutils, pacman -U selinux-coreutils may also cause
you troubles, so maybe the best way is to install the selinux-* packages
from a live CD chroot to your system.

Warning: Do not install selinux-sysvinit package unless everything is
set up, as you may end up with an unbootable system. Or, do not reboot
unless you have everything set up.

> Package description

All SELinux related packages belong to the selinux group. Group
selinux-system-utilities is used for modified packages from the [core]
repository. Group selinux-userspace contains packages from SELinux
Userspace project. Security policies belong to selinux-policies group.
Other packages are in selinux-extras group.

SELinux aware system utils

linux-selinux 
    SELinux enabled kernel. Compiling custom modules like virtualbox
    works.

selinux-coreutils 
    Modified coreutils package compiled with SELinux support enabled.

selinux-flex 
    Flex version needed only to build checkpolicy. Current flex has
    error causing failure in checkmodule command.

selinux-pam 
    PAM package with pam_selinux.so.

selinux-sysvinit 
    Sysvinit which loads policy at startup. Be careful; it fails if
    SELinux policy cannot be loaded!

selinux-util-linux 
    Modified util-linux package compiled with SELinux support enabled.

selinux-udev made obsolete by selinux-sysvinit 
    Modified udev package compiled with SELinux support enabled for
    labeling of files in /dev to work correctly. The udev functionality
    is now provided by selinux-sysvinit-tools [1] which is part of the
    selinux-sysvinit splitpackage.

selinux-findutils 
    Patched findutils package compiled with SELinux support to make
    searching of files with specified security context possible.

selinux-sudo 
    Modified sudo package compiled with SELinux support which sets
    security context correctly.

selinux-procps 
    Procps package with SELinux patch based on some Fedora patches.

selinux-psmisc 
    Psmisc package compiled with SELinux support; for example, it adds
    the -Z option to killall.

selinux-shadow 
    Shadow package compiled with SELinux support; contains a modified
    /etc/pam.d/login file to set correct security context for user after
    login.

selinux-cronie 
    Fedora fork of Vixie cron with SELinux enabled.

selinux-logrotate 
    Logrotate package compiled with SELinux support.

selinux-openssh 
    OpenSSH package compiled with SELinux support to set security
    context for user sessions.

SELinux userspace

selinux-usr-checkpolicy 
    Tools to build SELinux policy

selinux-usr-libselinux 
    Library for security-aware applications. Python bindings needed for
    semanage and setools now included.

selinux-usr-libsemanage 
    Library for policy management. Python bindings needed for semanage
    and setools now included.

selinux-usr-libsepol 
    Library for binary policy manipulation.

selinux-usr-policycoreutils 
    SELinux core utils such as newrole, setfiles, etc.

selinux-usr-sepolgen 
    A Python library for parsing and modifying policy source.

SELinux policy

selinux-refpolicy 
    Precompiled modular-otherways-vanilla Reference policy with headers
    and documentation but without sources.

selinux-refpolicy-src 
    Reference policy sources

selinux-refpolicy-arch 
    Precompiled modular Reference policy with headers and documentation
    but without sources. Development Arch Linux Refpolicy patch
    included, but for now [February 2011] it only fixes some issues with
    /etc/rc.d/* labeling.

Other SELinux tools

selinux-setools 
    CLI and GUI tools to manage SELinux

audit 
    User space utilities for storing and searching the audit records
    generated by the audit subsystem in the Linux kernel. SELinux (AVC)
    will log all denials using audit. Very useful in troubleshooting
    SELinux. Also audit2allow use log from this program.

Note:If using proprietary drivers, such as NVIDIA graphics drivers, you
may need to rebuild them for custom kernels.

Configuration
-------------

After the installation of needed packages, you have to set up a few
things so that SELinux can be used.

> Changing boot loader configuration

You have to manually change GRUB's /boot/grub/menu.lst so that the
custom kernel is booted, e.g.:

    # (1) Arch Linux
    title  Arch Linux (SELinux)
    root   (hd0,4)
    kernel /boot/vmlinuz-linux-selinux root=/dev/sda5 ro vga=775
    initrd /boot/initramfs-linux-selinux.img

> Mounting selinuxfs

Add following to /etc/fstab:

    none   /selinux   selinuxfs   noauto   0   0

Do not forget to create the mount point:

    mkdir /selinux

> Main SELinux configuration file

Main SELinux configuration file (/etc/selinux/config) is part of the
selinux-refpolicy package currently in the AUR. It has default contents
as follows:

    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    #       enforcing - SELinux security policy is enforced.
    #       permissive - SELinux prints warnings 
    #                       instead of enforcing.
    #       disabled - No SELinux policy is loaded.
    SELINUX=permissive
    # SELINUXTYPE= takes the name of SELinux policy to
    # be used. Current options are:
    #       refpolicy (vanilla reference policy)
    #       refpolicy-arch (reference policy with 
    #       Arch Linux patch)
    SELINUXTYPE=refpolicy

Note:Option SELINUX=permissive is suitable only for testing. It gives no
security. When everything is set up and working, you should change it to
SELINUX=enforcing. Option SELINUXTYPE=refpolicy specifies the name of
used policy. Change it if you choose another name for your policy. If
you plan to compile policy from source, you have to create the file
yourself.

> Set up PAM

Correctly set-up PAM is important to get a proper security context after
login. There should be the following lines in /etc/pam.d/system-login:

    # pam_selinux.so close should be the first session rule
    session         required        pam_selinux.so close
    # pam_selinux.so open should only be followed by sessions to be executed in the user context
    session         required        pam_selinux.so open

Similarly for logging in via SSH in /etc/pam.d/sshd, which is part of
selinux-openssh package.

If you want to use SELinux with GUI, you should add the aforementioned
lines to other files such as /etc/pam.d/kde, /etc/pam.d/kde-np, ...
depending on your login manager.

Note:Running SELinux with GUI applications in Arch Linux is not much
supported at the time being.

Reference policy
----------------

There are currently two possible ways of installing reference policy:
From a pre-compiled package (selinux-refpolicy) or from a source package
(selinux-refpolicy-src).

Note: It is possible to have both the source and the binary package
installed. If you plan to build from source in that case, you should
probably change the name of policy in build.conf to avoid overwriting of
selinux-refpolicy package files.

> Installing a precompiled refpolicy

Install selinux-refpolicy from AUR. This is a modular-otherways-vanilla
refpolicy. This package includes policy headers (you can therefore
compile your own modules), policy documentation and an install script
which will load the policy for you and relabel your filesystem (which
will likely take some time). It does not include the sources though.

This package also includes the main SELinux configuration file
(/etc/selinux/config) defaulting to refpolicy and permissive SELinux
enforcement for testing purposes.

You should verify that the policy was correctly loaded, that is if the
file /etc/selinux/refpolicy/policy/policy.24 has non-zero size. If so
and if you have installed selinux-sysvinit and other needed packages,
you are ready to reboot and make sure that everything works.

Warning: On newer kernels (eg. 3.0) policy in file
/etc/selinux/refpolicy/policy/policy.24 has zero bytes size, because it
is used new version of policy from file:
/etc/selinux/refpolicy/policy/policy.26

In case the policy was not correctly loaded you can as root use the
following command inside of the /usr/share/selinux/refpolicy directory
to do so:

    /bin/ls *.pp | /bin/grep -Ev "base.pp|enableaudit.pp" | /usr/bin/xargs /usr/sbin/semodule -s refpolicy -b base.pp -i

To manually relabel your filesystem you can as root use:

    /sbin/restorecon -r /

> Installing refpolicy from a source package

Install selinux-refpolicy-src from AUR. Edit the file
/etc/selinux/refpolicy/src/policy/build.conf to your liking.

Note:Build configuration file build.conf is overwritten on every
selinux-refpolicy-src package upgrade, so backup your configuration.

To build, install and load policy from source do the following. (For
other possibilities consult the README file located in
/etc/selinux/refpolicy/src/policy/.)

    cd /etc/selinux/refpolicy/src/policy
    make bare
    make conf 
    make load

Copy or link the compiled binary policy to /etc/policy.bin for sysvinit
to find and install selinux-sysvinit:

    ln -s /etc/selinux/refpolicy/policy/policy.21 /etc/policy.bin

At this moment files do not have any context, so you should relabel the
whole filesystem, which will take a while:

    make relabel

Create the main SELinux configuration file (/etc/selinux/config)
according to the example in related section.

Now you are ready to reboot and make sure that everything works.

Post-installation steps
-----------------------

Warning: If you did not install selinux-sysvinit, then you will see
SELinux in disabled mode, and /selinux will not be mounted.

You can check that SELinux is working with sestatus. You should get
something like:

    SELinux status:                 enabled
    SELinuxfs mount:                /selinux
    Current mode:                   permissive
    Mode from config file:          enforcing
    Policy version:                 24
    Policy from config file:        refpolicy

To maintain correct context, you can use restorecond:

    touch /etc/rc.d/restorecond
    chmod ugo+x /etc/rc.d/restorecond

Which should contain:

    #!/bin/sh
    restorecond

Note:Do not forget to add restorecond into your DAEMONS array in
/etc/rc.conf.

To switch to enforcing mode without reboot, you can use:

    echo 1 >/selinux/enforce

Note:If setting SELINUX=enforcing in /etc/selinux/config does not work
for you, create /etc/rc.d/selinux-enforce containing the preceding
command similarly as with restorecond daemon.

Useful tools
------------

There are some tools/commands that can greatly help with SELinux.

restorecon
    Restores the context of a file/directory (or recursively with -R)
    based on any policy rules
rlpkg
    Relabels any files belonging to that Gentoo package to their proper
    security context (if they have one)
chcon
    Change the context on a specific file
audit2allow
    Reads in log messages from the AVC log file and tells you what rules
    would fix the error. Do not just add these rules without looking at
    them though, they cannot detect errors in other places (e.g. the
    application is running in the wrong context in the first place), or
    sometimes things will generate error messages but may maintain
    functionality so it would be better to add dontaudit to just ignore
    the access attempts.

References
----------

-   Security Enhanced Linux
-   Gentoo SELinux Handbook
-   Fedora Project's SELinux Wiki
-   NSA's Official SELinux Homepage
-   Reference Policy Homepage
-   SELinux Userspace Homepage
-   SETools Homepage

See also
--------

-   AppArmor (Similar to SELinux, much easier to configure, less
    features.)

Retrieved from
"https://wiki.archlinux.org/index.php?title=SELinux&oldid=239046"

Categories:

-   Security
-   Kernel
