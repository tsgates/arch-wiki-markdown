Boot Debugging
==============

The kernel provides for a convenient way to configure all sorts of
advanced settings to enable you to quickly and conveniently boot into
your existing system with varying levels of debugging output extended
kernel parameters. It is very easy and useful to create several levels
of debugging just by adding additional entries to your bootloader
configuration. And if you ever have issues or problems down the road due
to a power-failure or hardware failure, it can save you hours of
trouble, and of course nothing can beat debugging output when it comes
to learning about your system.

First, see the Kernel parameters article for method to add a kernel
parameter for different boot loaders.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Debug levels                                                       |
|     -   1.1 Light Debug                                                  |
|     -   1.2 Medium Debug                                                 |
|     -   1.3 Heavy Debug                                                  |
|     -   1.4 Extreme Debug                                                |
|     -   1.5 Insane Debug                                                 |
|                                                                          |
| -   2 Debug methods                                                      |
|     -   2.1 Module Parameters                                            |
|     -   2.2 Break Into Init                                              |
|     -   2.3 Debugging init                                               |
|     -   2.4 Net Console                                                  |
|     -   2.5 Hijacking cmdline                                            |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Repairing with Arch live-cd                                  |
|         -   3.1.1 Mounting and Chrooting broken system                   |
|         -   3.1.2 Reinstalling with Pacman                               |
|                                                                          |
| -   4 See Also                                                           |
| -   5 External Links                                                     |
+--------------------------------------------------------------------------+

Debug levels
------------

> Light Debug

A quick way to see more verbose messages on your console is to boot up
your bootloader entry after appending verbose to the kernel line.

> Medium Debug

Adding the debug kernel parameter to your kernel line is recognized by a
lot of linux internals and enables quite a bit of debugging compared to
the default.

> Heavy Debug

An even more impressive kernel parameter is the ignore_loglevel, which
causes the system to ignore any loglevel and keeps the internal loglevel
at the maximum debugging level, basically rendering dmesg unable to
lower the debug level.

> Extreme Debug

If the "Heavy Debug" seemed like a lot of output, that's about 1/2 of
the logging that occurs with kernel parameters:

    debug ignore_loglevel log_buf_len=10M print_fatal_signals=1 LOGLEVEL=8 earlyprintk=vga,keep sched_debug

This does a couple things:

-   it uses the earlyprintk parameter to setup your kernel for "early"
    "printing" of messages to your "vga" screen.
-   The keep just lets it stay on the screen longer. This will let you
    see logs that normally are hidden due to the boot-up process.
-   log_buf_len=10M changes the log buffer length to 10MB
-   Instructs that any fatal signals be printed with print_fatal_signals
-   The last one, sched_debug, you can look up in the very excellent
    kernel documentation on kernel parameters.

> Insane Debug

The first few debugging kernel parameters turn on really verbose
debugging. This kind of debugging is absolutely critical if you want to
max out your system or just learn more about what is going on behind the
scenes. But there is a final trick that is my favorite, it is the
ability to set both environment variables, and more importantly, module
parameters at boot.

As an example, here is some truly insane debugging kernel parameters.
Note that the actual grub entry is all on one line. This turns on many
devices to be at the absolute max debug level. The machine maybe slower
than a TI-89 calculator (See Improve Boot Performance).

    rootwait ignore_loglevel debug debug_locks_verbose=1 sched_debug initcall_debug 
    mminit_loglevel=4 udev.log_priority=8 loglevel=8 earlyprintk=vga,keep log_buf_len=10M
    print_fatal_signals=1 apm.debug=Y i8042.debug=Y drm.debug=1 scsi_logging_level=1
    usbserial.debug=Y option.debug=Y pl2303.debug=Y firewire_ohci.debug=1 hid.debug=1
    pci_hotplug.debug=Y pci_hotplug.debug_acpi=Y shpchp.shpchp_debug=Y apic=debug
    show_lapic=all hpet=verbose lmb=debug pause_on_oops=5 panic=10 sysrq_always_enabled

A couple key items are sysrq_always_enabled which forces on the sysrq
magic, which really is a lifesaver when debugging at this level as your
machine will freeze/stop-responding sometimes and it is nice to use
sysrq to kill all tasks, change the loglevel, unmount all filesystems,
or do a hard reboot. Another key parameter is the initcall_debug, which
debugs the init process in excruciating detail. Very useful at times.
The last parametery I find very useful is the udev.log_priority=8 to
turn on udev logging.

Debug methods
-------------

> Module Parameters

In Kernel modules#Parameters you can find a nice bash function to be run
as root that will show a list of all the loaded modules and all of their
parameters, including the current value of the parameter.

> Break Into Init

For instance, If you add break=y to your kernel cmdline, init will pause
early in the boot process (after loading modules) and launch an
interactive sh shell which can be used for troubleshooting purposes.
(Normal boot continues after logout.) This is very similar to the shell
that shows up if your computer gets turned off before it is able to
shutdown properly. But using this parameter lets you enter into this
mode differently at will.

> Debugging init

This awesome parameter udev.log_priority=8 does the same thing as
editing the file /etc/udev/udev.conf except it executes earlier, turning
on debugging output for udev. If you want to know your hardware, that is
the key parameter right there. Another trick is if you change the
/etc/udev/udev.conf to be verbose, then you can make your initrd image
include that file to turn on verbose udeb debugging by adding it to your
/etc/mkinitcpio.conf like:

    FILES="/etc/modprobe.d/modprobe.conf /etc/udev/udev.conf"

, which on arch is as easy as

    # mkinitcpio -p linux

Debugging udev is key because the initrd performs a root change at the
end of its run to usually launch a program like /sbin/init as part of a
chroot, and unless the new file system has a valid /dev directory, udev
must be initialized before invoking chroot in order to provide
/dev/console.

    exec chroot . /sbin/init <dev/console >dev/console 2>&1
     

So basically, you are not able to view the logs that are generated
before /dev/console is initialized by udev or by a special initrd you
compiled yourself. One method the kernel developers use to be able to
still get the log messages generated before /dev/console is available is
to provide an alternative console that you can enable or disable from
grub.

> Net Console

If you read through the kernel documentation regarding debugging, you
will hear about Netconsole, which can be compiled into your kernel or
loaded at runtime as a module. Having a netconsole entry in your kernel
parameters is most excellent for debugging slower computers like old
laptops or thin-clients. It is easy to use:

1.  Just setup a 2nd computer (running arch) to accept syslog requests
    on a remote port, very fast and quick to do on arch-linux, 1 line to
    syslog.conf.
2.  Then you could use a log-color-parser like ccze to view all syslog
    logs, or just tail your everything.log.
3.  On your laptop, boot up and add
    netconsole=514@10.0.0.2/12:34:56:78:9a:bc debug ignore_loglevel into
    kernel parameters.
4.  You will start seeing as much logging as you want on your syslog
    system. This logging lets you view even earlier log output than is
    available with the earlyprintk=vga kernel parameter, as netconsole
    is used by kernel hackers and developers, so it is very powerful.

> Hijacking cmdline

If you do not have access to GRUB or the kernel boottime cmdline, like
on a server or virtual machine, as long as you have root permissions you
can still enable this kind of simplistic verbose logging using a neat
hack. While you cannot modify the /proc/cmdline even as root, you can
place your own cmdline file on top of /proc/cmdline, so that accessing
/proc/cmdline actually accesses your file.

For example if I cat /proc/cmdline, I have the following:

    root=/dev/disk/by-label/ROOT ro console=tty1 logo.nologo quiet

So I use a simple sed command to replace quiet with verbose like:

    sed 's/ quiet/ verbose/' /proc/cmdline > /root/cmdline

Then I bind mount /root/cmdline so that it becomes /proc/cmdline, using
the -n option to mount so that this mount will not be recorded in the
systems mtab.

    mount -n --bind -o ro /root/cmdline /proc/cmdline

Now if I cat /proc/cmdline, I have the following:

    root=/dev/disk/by-label/ROOT ro console=tty1 logo.nologo verbose

Troubleshooting
---------------

> Repairing with Arch live-cd

In case grub is unable to boot your kernel, or if your initramfs is
broken, you can boot into a safe system using an Arch live-cd. Once
finished with repairs, unmount the broken system and reboot.

Mounting and Chrooting broken system

Once booted and at a console prompt, use the following to mount and
repair your broken system (where /dev/sda3 is / and /dev/sda1 is /boot):

First create the mount-point and mount your root / filesystem to it,
then cd into it.

    # mkdir /mnt/arch
    # mount /dev/sda3 /mnt/arch
    # cd /mnt/arch

Now create the proc, sysfs, and dev filesystems

    # mount -t proc proc proc/
    # mount -t sysfs sys sys/
    # mount -o bind /dev dev/

Next mount the boot partition if you use one.

    # mount /dev/sda1 boot/

Finally chroot into /mnt/arch which will become /.

    # chroot .

Turn on networking

Reinstalling with Pacman

The author uses pacman in a chrooted broken system to reinstall the
kernel, grub, initramfs, udev, and any other packages that may be broken
and/or needed to get the system up and running.

This will reinstall the kernel and initramfs so check that
/etc/mkinitcpio.conf is correct or remove the file entirely and
re-install mkinitcpio.

    # pacman -Syyu mkinitcpio linux udev

Afterwards, unmount and reboot.

See Also
--------

-   Netconsole
-   Syslinux
-   GRUB2
-   GRUB Legacy
-   Kernel modules
-   mkinitcpio
-   Fstab
-   Kernel Mode Setting
-   LILO
-   GUID Partition Table
-   Systemd

External Links
--------------

-   Memtest
-   List of Tools for UBCD - Can be added to custom menu.lst like
    memtest
-   Official GRUB2 Manual -
    https://www.gnu.org/software/grub/manual/grub.html
-   Ubuntu wiki page for GRUB2 - https://help.ubuntu.com/community/Grub2
-   GRUB2 wiki page describing steps to compile for UEFI systems -
    https://help.ubuntu.com/community/UEFIBooting
-   Wikipedia's page on BIOS Boot partition
-   QA/Sysrq - Using sysrq
-   Systemd Docs: Debug Logging to a Serial Console
-   How to Isolate Linux ACPI Issues

Retrieved from
"https://wiki.archlinux.org/index.php?title=Boot_Debugging&oldid=252433"

Categories:

-   Boot process
-   System recovery
