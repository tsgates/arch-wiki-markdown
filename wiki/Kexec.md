Kexec
=====

> Summary

Covers how to install and configure kexec.

> Related

Systemd

Kexec is a system call that enables you to load and boot into another
kernel from the currently running kernel. This is useful for kernel
developers or other people who need to reboot very quickly without
waiting for the whole BIOS boot process to finish. Note that there may
appear some problems and kexec may not work correctly for you because
the devices won't fully reinitiate when using this method.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Rebooting using kexec                                              |
|     -   2.1 Systemd                                                      |
|     -   2.2 Manually                                                     |
|                                                                          |
| -   3 References                                                         |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

To install kexec, install the kexec-tools package which is available in
the official repositories.

Rebooting using kexec
---------------------

> Systemd

You will need to create a new unit file, kexec-load@.service, that will
load the specified kernel to be kexec'ed[1].

    # vim /etc/systemd/system/kexec-load@.service

    [Unit]
    Description=load %I kernel into the current kernel
    Documentation=man:kexec(8)
    DefaultDependencies=no
    Before=shutdown.target umount.target final.target

    [Service]
    Type=oneshot
    ExecStart=/sbin/kexec -l /boot/vmlinuz-%I --initrd=/boot/initramfs-%I.img --reuse-cmdline

    [Install]
    WantedBy=kexec.target

Then enable the service file for the kernel you want to load, for
example simply the default kernel linux:

    # systemctl enable kexec-load@linux

    ln -s '/etc/systemd/system/kexec-load@.service' '/etc/systemd/system/kexec.target.wants/kexec-load@linux.service'

Ensure that the shutdown hook is not part of your initramfs image by
removing it from the HOOKS array in /etc/mkinitcpio.conf. If it is,
remove it and rebuild your initrd image with mkinitcpio -p linux.

Then to kexec

    # systemctl kexec

If you wish to load a different kernel for the next kexec, for example
linux-lts, disable the service for the current kernel and enable the one
for the new kernel:

    # systemctl disable kexec-load@linux
    # systemctl enable kexec-load@linux-lts

> Manually

It is also perfectly legal to invoke kexec manually:

    # kexec -l /boot/vmlinuz-linux --initrd=/boot/initramfs-linux.img --reuse-cmdline

References
----------

1. [systemd-devel] Right way to do kexec

See also
--------

-   kdump: a kexec based crash dumping mechansim for Linux
-   Reboot Linux faster using kexec

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kexec&oldid=247554"

Categories:

-   Boot process
-   Kernel
