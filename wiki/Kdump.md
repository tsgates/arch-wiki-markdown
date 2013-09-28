Kdump
=====

Summary

Covers how to setup kdump.

Related

Kexec

Kdump is a standrad Linux mechanism to dump machine memory content on
kernel crash. Kdump is based on Kexec. Kdump utilizes two kernels:
system kernel and dump capture kernel. System kernel is a normal kernel
that is booted with special kdump-specific flags. We need to tell the
system kernel to reserve some amount of physical memory where
dump-capture kernel will be loaded. We need to load the dump capture
kernel in advance because at the moment crash happens there is no way to
read any data from disk because kernel is broken.

Once kernel crash happens the kernel crash handler uses Kexec mechanism
to boot dump capture kernel. Please note that memory with system kernel
is untouched and accessible from dump capture kernel as seen at the
moment of crash. Once dump capture kernel is booted user can use
/dev/vmcore file to get access to memory of crashed system kernel. The
dump can be saved to disk or copied over network to some other machine
for further investigation.

In real production environments system and dump capture kernel will be
different - system kernel needs a lot of features and compiled with a
many kernel flags/drivers. While dump capture kernel goal is to be
minimalistic and take as small amount of memory as possible, e.g. dump
capture kernel can be compiled without network support if we store
memory dump to disk only. But in this article we will simplify things
and use the same kernel both as system and dump capture one. In means we
will load the same kernel code twice - one as normal system kernel,
another one to reserved memory area.

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Compiling kernel                                                   |
| -   2 Setup kdump kernel                                                 |
| -   3 Testing crash                                                      |
| -   4 Dump crashed kernel                                                |
| -   5 Analyzing core dump                                                |
| -   6 Additional information                                             |
+--------------------------------------------------------------------------+

Compiling kernel
----------------

System/dump capture kernel requires some configuration flags that are
not set by default. Please consult Kernels#Compilation for more
information about compiling custom kernel in Arch. Here we will
emphasize on Kdump specific configuration.

To create a kernel you need to edit kernel config (or config.x86_64)
file and enable following configuration options:

    config{.x86_64} file

    CONFIG_DEBUG_INFO=y
    CONFIG_CRASH_DUMP=y
    CONFIG_PROC_VMCORE=y

Also change package base name to something like linux-kdump to
distinguish the kernel from the default Arch one. Compile kernel package
and install it. Save ./src/linux-X.Y/vmlinux uncompressed system kernel
binary - it contains debug symbols and you will need them later when
analyzing crash.

In case if you have separate kernel for system and dump capture then it
is recommended to consult Kdump documentation. It has several
recommendations how to make dump capture kernel smaller.

Setup kdump kernel
------------------

First you need to reserve memory for dump capture kernel. Edit you
bootloader config file and add crashkernel=64M boot option to the system
kernel you just installed. For example Syslinux boot entry would look
like:

    /boot/syslinux/syslinux.cfg

    LABEL arch-kdump
            MENU LABEL Arch Linux Kdump
            LINUX ../vmlinuz-linux-kdump
            APPEND root=/dev/sda1 crashkernel=64M
            INITRD ../initramfs-linux-kdump.img

64M of memory should be enough to hadle crash dumps on machines with up
to 12G of RAM. Some systems require more reserved memory. In case if
dump capture kernel unable not load try to increase the memory to 256M
or even to 512M, but note that this memory is unavailable to system
kernel.

Reboot into your system kernel. To make sure that the kernel is booted
with correct options please check /proc/cmdline file.

Next you need to tell Kexec that you want to use your dump capture
kernel. Specify your kernel, initramfs file, device for root fs and
other parameters if needed.

    # kexec -p [/boot/vmlinuz-linux-kdump] --initrd=[/boot/initramfs-linux-kdump.img] --append="root=[root-device] single irqpoll maxcpus=1 reset_devices"

It loads the kernel into reserved area. Without -p flag kexec would boot
the kernel right away, but in presence of the flag kernel will be loaded
into reserved memory but boot postponed until crash.

Instead of runnig kexec manually you might want to setup Systemd service
that will run kexec on boot:

    /etc/systemd/system/kdump.service

    [Unit]
    Description=Load dump capture kernel
    After=local-fs.target

    [Service]
    ExecStart=/sbin/kexec -p [/boot/vmlinuz-linux-kdump] --initrd=[/boot/initramfs-linux-kdump.img] --append="root=[root-device] single irqpoll maxcpus=1 reset_devices"
    Type=oneshot

    [Install]
    WantedBy=multi-user.target

Then enable the service

    # systemctl enable kdump

To check whether the crash kernel is already loaded please run following
command:

    $ cat /sys/kernel/kexec_crash_loaded

Testing crash
-------------

If you want to test crash then you can use sysrq for this.

Warning:kernel crash may corrupt data on your disks, run it at your own
risk!

    $ echo c | sudo tee /proc/sysrq-trigger

Once crash happens kexec will load your dump capture kernel.

Dump crashed kernel
-------------------

Once booted into dump capture kernel you can read /dev/vmcore file. It
is recommended to dump core to a file and analyze it later.

    # cp /proc/vmcore /root/crash.dump

or optionally you can copy the crash to other machine. Once dump is
saved you should reboot machine into normal system kernel.

Analyzing core dump
-------------------

You can use either gdb tool or special gdb extension called crash that
can be found in AUR. Run crash as

    $ crash <vmlinux> <path>/crash.dump

Where vmlinux previously saved kernel binary with debug symbols.

Follow man crash or http://people.redhat.com/~anderson/crash_whitepaper/
for more information about debugging practices.

Additional information
----------------------

-   Official kdump documentation
    https://www.kernel.org/doc/Documentation/kdump/kdump.txt
-   The crash book
    http://www.dedoimedo.com/computers/www.dedoimedo.com-crash-book.pdf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kdump&oldid=255025"

Categories:

-   Boot process
-   Kernel
