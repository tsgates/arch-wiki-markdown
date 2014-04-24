Lxc-systemd
===========

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Linux       
                           Containers.              
                           Notes: Should be merged  
                           to main page after clean 
                           up. (Discuss)            
  ------------------------ ------------------------ ------------------------

These are brief notes that describe how to configure a Linux container
that runs systemd inside. They ought to be consumed into the main Linux
Containers wiki page when that is rewritten.

Without specific configuration, conflicts arise between systemd and lxc
in the /dev tree. A new mode called 'autodev' has been added to LXC to
help rectify this.

LXC needs to be configured to use its new "autodev" mode which causes it
to create a new /dev tree.

     lxc.autodev = 1

This will cause LXC to create its own device tree but this also means
that the traditional way of manually creating device nodes in the
container rootfs /dev tree will not work because /dev is overmounted by
LXC. Should you require (and you probably will) any device nodes that
are not created by LXC by default then you will need to use an autodev
hook script:

     lxc.hook.autodev = /path/to/script

Where the script is similar to:

     #!/bin/bash
     # LXC Autodev hook.
     cd ${LXC_ROOTFS_MOUNT}/dev
     mknod .....

The other thing you must do is disable services that are not supported
inside a container. Chroot into the container rootfs and mask those
services:

     ln -s /dev/null /etc/systemd/system/systemd-udevd.service
     ln -s /dev/null /etc/systemd/system/systemd-udevd-control.socket
     ln -s /dev/null /etc/systemd/system/systemd-udevd-kernel.socket
     ln -s /dev/null /etc/systemd/system/proc-sys-fs-binfmt_misc.automount

This disables udev and mounting of /proc/sys/fs/binfmt_misc.

An alternative way to prevent systemd from starting udev is to deny
mknod capabilities in the container:

     lxc.cap.drop = mknod

Dropping the mknod capability is described at
http://www.freedesktop.org/wiki/Software/systemd/ContainerInterface
where it explains that this is necessary to prevent systemd from
starting udev. However, masking the systemd services is a better
approach because it allows you to retain mknod capability inside a
container if you need it.

Additionally you should ensure that you have a pty declaration in your
LXC container because the presence of this causes LXC to mount devpts as
a new instance (without this the container gets the host's devpts and
that is not a good thing - more strange things will happen!):

     lxc.pts = 1024

Note that there is no need to explicitly mount system devices (either
via the container config or via its own /etc/fstab) and this should not
be done because systemd (or LXC in the case of /dev...) takes care of
it:

-   /dev/pts
-   /dev/shm
-   /proc
-   /sys

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lxc-systemd&oldid=253005"

Category:

-   Security

-   This page was last modified on 5 April 2013, at 15:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
