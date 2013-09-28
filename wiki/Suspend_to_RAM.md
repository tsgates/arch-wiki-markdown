Suspend to RAM
==============

Summary

Describes the operation of the pm-utils suspend framework and supported
backend methods

Related

Pm-utils

Uswsusp

TuxOnIce

Sleep mode can go by many different names, including Stand By, Sleep,
and Suspend. When placed in this sleep mode, aside from the RAM which is
required to restore the machine's state, the computer attempts to cut
power to all unneeded parts of the machine. Because of the large power
savings, most laptops automatically enter this mode when the computer is
running on batteries and the lid is closed. (from Wikipedia:Sleep mode)

There is a variety of mechanisms to enable your operating system to
suspend to memory or to disk. To understand the difference between these
systems, you need to know that there exists a suspend/resume
implementation in the kernel (swsusp) and (typically) a set of
additional tweaks to handle specific drivers/modules/hardware (ex: video
card re-initialization).

-   systemd provides commands for suspend to RAM, hibernate and a hybrid
    suspend using the kernel's native suspend/resume functionality.
    There are also mechanisms to add hooks to customize pre- and
    post-suspend actions.

-   pm-utils is a set of shell scripts that encapsulate the kernel's
    suspend/resume functionality. It comes with a set of pre- and
    post-suspend tweaks and various hooks to customize the process.

-   uswsusp also aims to provide programs that encapsulate the kernel's
    suspend/resume functionality with the additional tweaks necessary.
    It also aims to provide a suspend-to-both functionality - this
    allows resuming from memory if battery is not depleted and resuming
    from disk if battery is completely depleted.

-   TuxOnIce differs from pm-utils and uswsusp in that it attempts to
    directly patch the kernel's suspend/resume functionality to add more
    functionality than the default implementation. It therefore requires
    a custom kernel.

-   Suspending to RAM with hibernate-script

Note that the end goal of these packages is to provide binaries/scripts
that can be invoked to perform suspend/resume. Actually hooking them up
to power buttons or menu clicks or laptop lid events is left to other
mechanisms. To automatically suspend/resume on certain power events,
such as laptop lid close or battery depletion percentage, you may want
to look into running Acpid.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Suspend methods                                                    |
|     -   1.1 kernel                                                       |
|     -   1.2 systemd                                                      |
|     -   1.3 uswsusp                                                      |
|     -   1.4 tuxonice                                                     |
|     -   1.5 pm-utils configuration                                       |
|                                                                          |
| -   2 Deciding between these options                                     |
|     -   2.1 Pm-utils framework or not?                                   |
|     -   2.2 Selecting the backend/method                                 |
|     -   2.3 ACPI_OS_NAME                                                 |
|                                                                          |
| -   3 Other Resources                                                    |
+--------------------------------------------------------------------------+

Suspend methods
---------------

These methods can be used to suspend/resume directly. pm-utils is also
fairly generic, so its pm-suspend and pm-hibernate scripts can be
configured to use any of these methods.

> kernel

The most straightforward approach is to directly inform the in-kernel
software suspend code (swsusp) to enter a suspended state; the exact
method and state depends on the level of hardware support. On modern
kernels, writing appropriate strings to /sys/power/state is the primary
mechanism to trigger this suspend. For example, let us study out how
pm-utils does this.

/usr/lib/pm-utils/pm-functions::294 (comments added):

    if grep -q mem /sys/power/state; then
        SUSPEND_MODULE="kernel"
        # Suspend-to-RAM
        # ACPI State S3
        # Device State D3
        # Greatest power savings, slower resume
        do_suspend() { echo -n "mem" >/sys/power/state; }
    elif [ -c /dev/pmu ] && pm-pmu --check; then
        SUSPEND_MODULE="kernel"
        # Suspend using Macintosh-style PMU
        # Fallback for older kernels in which the sysfs interface does not support this hardware
        do_suspend() { pm-pmu --suspend; }
    elif grep -q standby /sys/power/state; then
        SUSPEND_MODULE="kernel"
        # Power-On-Suspend
        # ACPI State S1
        # Device State D1 (supported devices)
        # Minimal power savings, fast resume
        do_suspend() { echo -n "standby" >/sys/power/state; }
    fi

In general, it is possible that just installing pm-utils and invoking
pm-suspend (which uses the kernel backend by default) just works for
you. In some cases, you may need to force specific modules to be
unloaded to make this work, as described in pm-utils#Advanced
Configuration.

> systemd

Systemd provides native commands for suspend, hibernate and a hybrid
suspend.

    # systemctl suspend
    # systemctl hibernate
    # systemctl hybrid-sleep

See Systemd#ACPI_power_management for additional information on
configuring suspend/resume hooks. Also see man systemctl,
man systemd-sleep, and man systemd.special.

> uswsusp

The uswsusp ('Userspace Software Suspend') package provides s2ram, a
wrapper around the kernel's suspend-to-RAM mechanism which perform some
graphics adapter manipulations from userspace before suspending and
after resuming. See Uswsusp.

> tuxonice

TuxOnIce is a fork of the kernel implementation of suspend/resume that
provides kernel patches to improve the default implementation. It
requires a custom kernel to achieve this purpose. Since pm-utils is a
set of shell scripts with a variety of hooks, it can be configured to
use TuxOnIce as well.

> pm-utils configuration

See pm-utils.

Deciding between these options
------------------------------

> Pm-utils framework or not?

Directly calling the kernel backend method is significantly faster than
calling pm-suspend, since running all the hooks provided by the pm-utils
framework invariable takes time. Even uswsusp is faster than pm-suspend.
However, the recommended approach is to use pm-utils as it can properly:

-   set hardware clock
-   restore wireless
-   etc...

In fact, only the pm-utils approach can be called without special
privileges, see pm-utils#Suspend.2FHibernate as regular user

> Selecting the backend/method

-   kernel - hooks provided by pm-utils (including video quirks) with
    kernel method. This is the recommended mechanism. It may require
    specific kernel modules to be unloaded before it will work properly.
    Searching on the arch linux bbs for your specific laptop is a good
    idea to discover these modules.

-   uswsusp - hooks provided by pm-utils except video99 with s2ram
    assuming responsibility for video quirks. Not necessary unless the
    kernel method explicitly fails to work.

-   tuxonice - since it requires a kernel recompile, make sure you are
    getting a specific feature out of it that is not supported by the
    default kernel implementation.

> ACPI_OS_NAME

You might want to tweak your DSDT table to make it work. See DSDT
article

However, you could try simply to use a acpi_os_name parameter, like:

    acpi_os_name="Microsoft Windows NT"

Add this to your kernel boot option. For example, for grub legacy:

    kernel /boot/vmlinuz-linux root=/dev/sdx resume=/dev/sdy ro quiet acpi_os_name="Microsoft Windows NT"

It just fools the BIOS about the real OS used, and work-around custom
behavior; i.e. the BIOS/ACPI is broken for everything but Windows.

You might want to try another string if this one does not work.

Other Resources
---------------

-   Uswsusp Home Page
-   Advanced Configuration and Power Interface
-   /usr/share/doc/suspend/README Uswsusp Documentation
-   /usr/share/doc/suspend/README.s2ram-whitelist s2ram-whitelist README
-   /usr/src/linux-2.6.38-ARCH/Documentation/power/interface.txt Kernel
    Power Management Interface
-   /usr/src/linux-2.6.38-ARCH/Documentation/power/states.txt System
    Power Management States

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suspend_to_RAM&oldid=250184"

Category:

-   Power management
