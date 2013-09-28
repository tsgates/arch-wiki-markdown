systemd
=======

Summary

Covers how to install and configure systemd.

Related

systemd/User

systemd/Services

systemd FAQ

init Rosetta

udev

From the project web page:

systemd is a system and service manager for Linux, compatible with SysV
and LSB init scripts. systemd provides aggressive parallelization
capabilities, uses socket and D-Bus activation for starting services,
offers on-demand starting of daemons, keeps track of processes using
Linux control groups, supports snapshotting and restoring of the system
state, maintains mount and automount points and implements an elaborate
transactional dependency-based service control logic. It can work as a
drop-in replacement for sysvinit.

Note:For a detailed explanation as to why Arch has moved to systemd, see
this forum post.

See also the Wikipedia article.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Considerations before switching                                    |
| -   2 Installation                                                       |
|     -   2.1 Supplementary information                                    |
|                                                                          |
| -   3 Native configuration                                               |
|     -   3.1 Virtual console                                              |
|     -   3.2 Hardware clock                                               |
|         -   3.2.1 Hardware clock in localtime                            |
|                                                                          |
|     -   3.3 Kernel modules                                               |
|         -   3.3.1 Extra modules to load at boot                          |
|         -   3.3.2 Configure module options                               |
|         -   3.3.3 Blacklisting                                           |
|                                                                          |
|     -   3.4 Filesystem mounts                                            |
|         -   3.4.1 Automount                                              |
|         -   3.4.2 LVM                                                    |
|                                                                          |
|     -   3.5 ACPI power management                                        |
|         -   3.5.1 Sleep hooks                                            |
|             -   3.5.1.1 Suspend/resume service files                     |
|             -   3.5.1.2 Combined Suspend/resume service file             |
|             -   3.5.1.3 Hooks in /usr/lib/systemd/system-sleep           |
|                                                                          |
|     -   3.6 Temporary files                                              |
|     -   3.7 Units                                                        |
|                                                                          |
| -   4 Basic systemctl usage                                              |
|     -   4.1 Analyzing the system state                                   |
|     -   4.2 Using units                                                  |
|     -   4.3 Power management                                             |
|                                                                          |
| -   5 Running DMs under systemd                                          |
|     -   5.1 Using systemd-logind                                         |
|                                                                          |
| -   6 Writing custom .service files                                      |
|     -   6.1 Handling dependencies                                        |
|     -   6.2 Type                                                         |
|     -   6.3 Editing provided unit files                                  |
|     -   6.4 Syntax highlighting for units within Vim                     |
|                                                                          |
| -   7 Targets                                                            |
|     -   7.1 Get current targets                                          |
|     -   7.2 Create custom target                                         |
|     -   7.3 Targets table                                                |
|     -   7.4 Change current target                                        |
|     -   7.5 Change default target to boot into                           |
|                                                                          |
| -   8 Journal                                                            |
|     -   8.1 Filtering output                                             |
|     -   8.2 Journal size limit                                           |
|     -   8.3 Journald in conjunction with syslog                          |
|                                                                          |
| -   9 Optimization                                                       |
|     -   9.1 Analyzing the boot process                                   |
|         -   9.1.1 Using systemd-analyze                                  |
|         -   9.1.2 Using systemd-bootchart                                |
|         -   9.1.3 Using bootchart2                                       |
|                                                                          |
|     -   9.2 Readahead                                                    |
|                                                                          |
| -   10 Troubleshooting                                                   |
|     -   10.1 Shutdown/reboot takes terribly long                         |
|     -   10.2 Short lived processes don't seem to log any output          |
|     -   10.3 Diagnosing Boot Problems                                    |
|                                                                          |
| -   11 See also                                                          |
+--------------------------------------------------------------------------+

Considerations before switching
-------------------------------

-   Do some reading about systemd.
-   Note the fact that systemd has a journal system that replaces
    syslog, although the two can co-exist. See the section on the
    journal below.
-   While systemd can replace some of the functionality of cron, acpid,
    or xinetd, there is no need to switch away from using the
    traditional daemons unless you want to.
-   Interactive initscripts are not working with systemd. In particular,
    netcfg-menu cannot be used at system start-up.

Installation
------------

Note:systemd and systemd-sysvcompat are both installed by default on
installation media newer than 2012-10-13.

Note:If you are running Arch Linux inside a VPS, please see the
appropriate page.

The following section is aimed at Arch Linux installations that still
rely on sysvinit and initscripts which have not migrated to systemd.

1.  Install systemd and append the following to your kernel parameters:
    init=/usr/lib/systemd/systemd
2.  Once completed you may enable any desired services via the use of
    systemctl enable <service_name> (this roughly equates to what you
    included in the DAEMONS array. New names can be found here).
3.  Reboot your system and verify that systemd is currently active by
    issuing the following command: cat /proc/1/comm. This should return
    the string systemd.
4.  Make sure your hostname is set correctly under systemd:
    hostnamectl set-hostname myhostname.
5.  Proceed to remove initscripts and sysvinit from your system and
    install systemd-sysvcompat.
6.  Optionally, remove the init=/usr/lib/systemd/systemd parameter as it
    is no longer needed. systemd-sysvcompat provides the default init.

> Supplementary information

-   If you have quiet in your kernel parameters, you might want to
    remove it for your first couple of systemd boots, to assist with
    identifying any issues during boot.

-   Adding your user to groups (sys, disk, lp, network, video, audio,
    optical, storage, scanner, power, etc.) is not necessary for most
    use cases with systemd. The groups can even cause some functionality
    to break. For example, the audio group will break fast user
    switching and allows applications to block software mixing. Every
    PAM login provides a logind session, which for a local session will
    give you permissions via POSIX ACLs on audio/video devices, and
    allow certain operations like mounting removable storage via udisks.

-   See the Network Configuration article for how to set up networking
    targets.

Native configuration
--------------------

Note:You may need to create these files. All files should have 644
permissions and root:root ownership.

> Virtual console

The virtual console (keyboard mapping, console font and console map) is
configured in /etc/vconsole.conf:

    /etc/vconsole.conf

    KEYMAP=us
    FONT=lat9w-16
    FONT_MAP=8859-1_to_uni

Note:As of systemd-194, the built-in kernel font and the us keymap are
used if KEYMAP= and FONT= are empty or not set.

Another way to set the keyboard mapping (keymap) is doing:

    # localectl set-keymap de

localectl can also be used to set the X11 keymap:

    # localectl set-x11-keymap de

See man 1 localectl and man 5 vconsole.conf for details.

-   For more information, see console fonts and keymaps.

> Hardware clock

Systemd will use UTC for the hardware clock by default.

Tip:It is advised to have a Network Time Protocol daemon running to keep
the system time synchronized with Internet time and the hardware clock.

Hardware clock in localtime

If you want to change the hardware clock to use local time (STRONGLY
DISCOURAGED) do:

    # timedatectl set-local-rtc true

If you want to revert to the hardware clock being in UTC, do:

    # timedatectl set-local-rtc false

Be warned that, if the hardware clock is set to localtime, dealing with
daylight saving time is messy. If the DST changes when your computer is
off, your clock will be wrong on next boot (there is a lot more to it).
Recent kernels set the system time from the RTC directly on boot,
assuming that the RTC is in UTC. This means that if the RTC is in local
time, then the system time will first be set up wrongly and then
corrected shortly afterwards on every boot. This is the root of certain
weird bugs (time going backwards is rarely a good thing).

One reason for allowing the RTC to be in local time is to allow dual
boot with Windows (which uses localtime). However, Windows is able to
deal with the RTC being in UTC with a simple registry fix. It is
recommended to configure Windows to use UTC, rather than Linux to use
localtime. If you make Windows use UTC, also remember to disable the
"Internet Time Update" Windows feature, so that Windows don't mess with
the hardware clock, trying to sync it with internet time. You should
instead leave touching the RTC and syncing it to internet time to Linux,
by enabling an NTP daemon, as suggested previously.

-   For more information, see Time.

> Kernel modules

Today, all necessary module loading is handled automatically by udev, so
that, if you don't want/need to use any out-of-tree kernel modules,
there is no need to put modules that should be loaded at boot in any
config file. However, there are cases where you might want to load an
extra module during the boot process, or blacklist another one for your
computer to function properly.

Extra modules to load at boot

Extra kernel modules to be loaded during boot are configured as a static
list in files under /etc/modules-load.d/. Each configuration file is
named in the style of /etc/modules-load.d/<program>.conf. Configuration
files simply contain a list of kernel module names to load, separated by
newlines. Empty lines and lines whose first non-whitespace character is
# or ; are ignored.

    /etc/modules-load.d/virtio-net.conf

    # Load virtio-net.ko at boot
    virtio-net

See man 5 modules-load.d for more details.

Configure module options

Additional module options must be set in the
/etc/modprobe.d/modprobe.conf.

Example:

-   we have /etc/modules-load.d/loop.conf with module loop inside to
    load during the boot.

-   in the /etc/modprobe.d/modprobe.conf specify the additional options,
    e.g. options loop max_loop=64

Afterwards, the newly set option might be verified via
cat /sys/module/loop/parameters/max_loop

Blacklisting

Module blacklisting works the same way as with initscripts since it is
actually handled by kmod. See Module Blacklisting for details.

> Filesystem mounts

The default setup will automatically fsck and mount filesystems before
starting services that need them to be mounted. For example, systemd
automatically makes sure that remote filesystem mounts like NFS or Samba
are only started after the network has been set up. Therefore, local and
remote filesystem mounts specified in /etc/fstab should work out of the
box.

See man 5 systemd.mount for details.

Automount

-   If you have a large /home partition, it might be better to allow
    services that do not depend on /home to start while /home is checked
    by fsck. This can be achieved by adding the following options to the
    /etc/fstab entry of your /home partition:

    noauto,x-systemd.automount

This will fsck and mount /home when it is first accessed, and the kernel
will buffer all file access to /home until it is ready.

Note: this will make your /home filesystem type autofs, which is ignored
by mlocate by default. The speedup of automounting /home may not be more
than a second or two, depending on your system, so this trick may not be
worth it.

-   The same applies to remote filesystem mounts. If you want them to be
    mounted only upon access, you will need to use the
    noauto,x-systemd.automount parameters. In addition, you can use the
    x-systemd.device-timeout=# option to specify a timeout in case the
    network resource is not available.

-   If you have encrypted filesystems with keyfiles, you can also add
    the noauto parameter to the corresponding entries in /etc/crypttab.
    Systemd will then not open the encrypted device on boot, but instead
    wait until it is actually accessed and then automatically open it
    with the specified keyfile before mounting it. This might save a few
    seconds on boot if you are using an encrypted RAID device for
    example, because systemd doesn't have to wait for the device to
    become available. For example:

    /etc/crypttab

    data /dev/md0 /root/key noauto

LVM

If you have LVM volumes not activated via the initramfs, enable the
lvm-monitoring service, which is provided by the lvm2 package:

    # systemctl enable lvm-monitoring

> ACPI power management

Systemd handles some power-related ACPI events. They can be configured
via the following options from /etc/systemd/logind.conf:

-   HandlePowerKey: specifies which action is invoked when the power key
    is pressed.
-   HandleSuspendKey: specifies which action is invoked when the suspend
    key is pressed.
-   HandleHibernateKey: specifies which action is invoked when the
    hibernate key is pressed.
-   HandleLidSwitch: specifies which action is invoked when the lid is
    closed.

The specified action can be one of ignore, poweroff, reboot, halt,
suspend, hibernate, hybrid-sleep, lock or kexec.

If these options are not configured, systemd will use its defaults:
HandlePowerKey=poweroff, HandleSuspendKey=suspend,
HandleHibernateKey=hibernate, and HandleLidSwitch=suspend.

On systems which run no graphical setup or only a simple window manager
like i3 or awesome, this may replace the acpid daemon which is usually
used to react to these ACPI events.

Note:Run systemctl restart systemd-logind for your changes to take
effect.

Note:Systemd cannot handle AC and Battery ACPI events, so if you use
Laptop Mode Tools or other similar tools acpid is still required.

In the current version of systemd, the Handle* options will apply
throughout the system unless they are "inhibited" (temporarily turned
off) by a program, such as a power manager inside a desktop environment.
If these inhibits are not taken, you can end up with a situation where
systemd suspends your system, then when it wakes up the other power
manager suspends it again.

Warning:Currently, the power managers in the newest versions of KDE and
GNOME are the only ones that issue the necessary "inhibited" commands.
Until the others do, you will need to set the Handle options to ignore
if you want your ACPI events to be handled by Xfce, acpid or other
programs.

Note:Systemd can also use other suspend backends (such as Uswsusp or
TuxOnIce), in addition to the default kernel backend, in order to put
the computer to sleep or hibernate.

For systemctl hibernate to work on your system you need to follow
instructions at Hibernation and possibly at Mkinitcpio Resume Hook
(pm-utils does not need to be installed).

Sleep hooks

Systemd does not use pm-utils to put the machine to sleep when using
systemctl suspend, systemctl hibernate or systemctl hybrid-sleep;
pm-utils hooks, including any custom hooks, will not be run. However,
systemd provides two similar mechanisms to run custom scripts on these
events.

Suspend/resume service files

Service files can be hooked into suspend.target, hibernate.target and
sleep.target to execute actions before or after suspend/hibernate.
Separate files should be created for user actions and root/system
actions. To activate the user service files,
# systemctl enable suspend@<user> && systemctl enable resume@<user>.
Examples:

    /etc/systemd/system/suspend@.service

    [Unit]
    Description=User suspend actions
    Before=sleep.target

    [Service]
    User=%I
    Type=forking
    Environment=DISPLAY=:0
    ExecStartPre= -/usr/bin/pkill -u %u unison ; /usr/local/bin/music.sh stop ; /usr/bin/mysql -e 'slave stop'
    ExecStart=/usr/bin/sflock

    [Install]
    WantedBy=sleep.target

    /etc/systemd/system/resume@.service

    [Unit]
    Description=User resume actions
    After=suspend.target

    [Service]
    User=%I
    Type=simple
    ExecStartPre=/usr/local/bin/ssh-connect.sh
    ExecStart=/usr/bin/mysql -e 'slave start'

    [Install]
    WantedBy=suspend.target

For root/system actions (activate with # systemctl enable root-suspend):

    /etc/systemd/system/root-resume.service

    [Unit]
    Description=Local system resume actions
    After=suspend.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/systemctl restart mnt-media.automount

    [Install]
    WantedBy=suspend.target

    /etc/systemd/system/root-suspend.service

    [Unit]
    Description=Local system suspend actions
    Before=sleep.target

    [Service]
    Type=simple
    ExecStart=-/usr/bin/pkill sshfs

    [Install]
    WantedBy=sleep.target

A couple of handy hints about these service files (more in
man systemd.service):

-   If Type=OneShot then you can use multiple ExecStart= lines.
    Otherwise only one ExecStart line is allowed. You can add more
    commands with either ExecStartPre or by separating commands with a
    semicolon (see the first example above -- note the spaces before and
    after the semicolon...these are required!).
-   A command prefixed with '-' will cause a non-zero exit status to be
    ignored and treated as a successful command.
-   The best place to find errors when troubleshooting these service
    files is of course with journalctl.

Combined Suspend/resume service file

With the combined suspend/resume service file, a single hook does all
the work for different phases (sleep/resume) and for different targets
(suspend/hibernate/hybrid-sleep).

Example and explanation:

    /etc/systemd/system/wicd-sleep.service

    [Unit]
    Description=Wicd sleep hook
    Before=sleep.target
    StopWhenUnneeded=yes

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=-/usr/share/wicd/daemon/suspend.py
    ExecStop=-/usr/share/wicd/daemon/autoconnect.py

    [Install]
    WantedBy=sleep.target

-   RemainAfterExit=yes: After started, the service is considered active
    until it is explicitly stopped.
-   StopWhenUnneeded=yes: When active, the service will be stopped if no
    other active service requires it. In this specific example, it will
    be stopped after sleep.target is stopped.
-   Because sleep.target is pulled in by suspend.target,
    hibernate.target and hybrid-sleep.target and sleep.target itself is
    a StopWhenUnneeded service, the hook is guaranteed to start/stop
    properly for different tasks.

Hooks in /usr/lib/systemd/system-sleep

Systemd runs all executables in /usr/lib/systemd/system-sleep/, passing
two arguments to each of them:

-   Argument 1: either pre or post, depending on whether the machine is
    going to sleep or waking up
-   Argument 2: suspend, hibernate or hybrid-sleep, depending on which
    is being invoked

In contrast to pm-utils, systemd will run these scripts concurrently and
not one after another.

The output of any custom script will be logged by
systemd-suspend.service, systemd-hibernate.service or
systemd-hybrid-sleep.service. You can see its output in systemd's
journal:

    # journalctl -b -u systemd-suspend

Note that you can also use sleep.target, suspend.target,
hibernate.target or hybrid-sleep.target to hook units into the sleep
state logic instead of using custom scripts.

An example of a custom sleep script:

    /usr/lib/systemd/system-sleep/example.sh

    #!/bin/sh
    case $1/$2 in
      pre/*)
        echo "Going to $2..."
        ;;
      post/*)
        echo "Waking up from $2..."
        ;;
    esac

Don't forget to make your script executable:

    # chmod a+x /usr/lib/systemd/system-sleep/example.sh

See man 7 systemd.special and man 8 systemd-sleep for more details.

> Temporary files

Systemd-tmpfiles uses configuration files in /usr/lib/tmpfiles.d/ and
/etc/tmpfiles.d/ to describe the creation, cleaning and removal of
volatile and temporary files and directories which usually reside in
directories such as /run or /tmp. Each configuration file is named in
the style of /etc/tmpfiles.d/<program>.conf. This will also override any
files in /usr/lib/tmpfiles.d/ with the same name.

tmpfiles are usually provided together with service files to create
directories which are expected to exist by certain daemons. For example
the Samba daemon expects the directory /run/samba to exist and to have
the correct permissions. The corresponding tmpfile looks like this:

    /usr/lib/tmpfiles.d/samba.conf

    D /run/samba 0755 root root

tmpfiles may also be used to write values into certain files on boot.
For example, if you use /etc/rc.local to disable wakeup from USB devices
with echo USBE > /proc/acpi/wakeup, you may use the following tmpfile
instead:

    /etc/tmpfiles.d/disable-usb-wake.conf

    w /proc/acpi/wakeup - - - - USBE

See man 5 tmpfiles.d for details.

Note:This method may not work to set options in /sys since the
systemd-tmpfiles-setup service may run before the appropriate device
modules is loaded. In this case you could check whether the module has a
parameter for the option you want to set with modinfo <module> and set
this option with a config file in /etc/modprobe.d. Otherwise you will
have to write a udev rule to set the appropriate attribute as soon as
the device appears.

> Units

A unit configuration file encodes information about a service, a socket,
a device, a mount point, an automount point, a swap file or partition, a
start-up target, a file system path or a timer controlled and supervised
by systemd. The syntax is inspired by XDG Desktop Entry Specification
.desktop files, which are in turn inspired by Microsoft Windows .ini
files.

See man 5 systemd.unit for details.

Basic systemctl usage
---------------------

The main command used to introspect and control systemd is systemctl.
Some of its uses are examining the system state and managing the system
and services. See man 1 systemctl for more details.

Tip:You can use all of the following systemctl commands with the
-H <user>@<host> switch to control a systemd instance on a remote
machine. This will use SSH to connect to the remote systemd instance.

Note:systemadm is the official graphical frontend for systemctl. It is
provided by the systemd-ui-git package from the AUR.

> Analyzing the system state

List running units:

    $ systemctl

or:

    $ systemctl list-units

List failed units:

    $ systemctl --failed

The available unit files can be seen in /usr/lib/systemd/system/ and
/etc/systemd/system/ (the latter takes precedence). You can see list
installed unit files by:

    $ systemctl list-unit-files

> Using units

Units can be, for example, services (.service), mount points (.mount),
devices (.device) or sockets (.socket).

When using systemctl, you generally have to specify the complete name of
the unit file, including its suffix, for example sshd.socket. There are
however a few shortforms when specifying the unit in the following
systemctl commands:

-   If you don't specify the suffix, systemctl will assume .service. For
    example, netcfg and netcfg.service are treated equivalent.
-   Mount points will automatically be translated into the appropriate
    .mount unit. For example, specifying /home is equivalent to
    home.mount.
-   Similiar to mount points, devices are automatically translated into
    the appropriate .device unit, therefore specifying /dev/sda2 is
    equivalent to dev-sda2.device.

See man systemd.unit for details.

Activate a unit immediately:

    # systemctl start <unit>

Deactivate a unit immediately:

    # systemctl stop <unit>

Restart a unit:

    # systemctl restart <unit>

Ask a unit to reload its configuration:

    # systemctl reload <unit>

Show the status of a unit, including whether it is running or not:

    $ systemctl status <unit>

Check whether a unit is already enabled or not:

    $ systemctl is-enabled <unit>

Enable a unit to be started on bootup:

    # systemctl enable <unit>

Note:Services without an [Install] section are usually called
automatically by other services. If you need to install them manually,
use the following command, replacing foo with the name of the service.

    # ln -s /usr/lib/systemd/system/foo.service /etc/systemd/system/graphical.target.wants/

Disable a unit to not start during bootup:

    # systemctl disable <unit>

Show the manual page associated with a unit (this has to be supported by
the unit file):

    $ systemctl help <unit>

Reload systemd, scanning for new or changed units:

    # systemctl daemon-reload

> Power management

polkit is necessary for power management. If you are in a local
systemd-logind user session and no other session is active, the
following commands will work without root privileges. If not (for
example, because another user is logged into a tty), systemd will
automatically ask you for the root password.

Shut down and reboot the system:

    $ systemctl reboot

Shut down and power-off the system:

    $ systemctl poweroff

Suspend the system:

    $ systemctl suspend

Put the system into hibernation:

    $ systemctl hibernate

Put the system into hybrid-sleep state (or suspend-to-both):

    $ systemctl hybrid-sleep

Running DMs under systemd
-------------------------

To enable graphical login, run your preferred Display Manager daemon
(e.g. KDM). At the moment, service files exist for GDM, KDM, SLiM, XDM,
LXDM and LightDM.

    # systemctl enable kdm

This should work out of the box. If not, you might have a default.target
set manually or from a older install:

    # ls -l /etc/systemd/system/default.target

    /etc/systemd/system/default.target -> /usr/lib/systemd/system/graphical.target

Simply delete the symlink and systemd will use its stock default.target
(i.e. graphical.target).

    # rm /etc/systemd/system/default.target

> Using systemd-logind

Note:As of 2012-10-30, ConsoleKit has been replaced by systemd-logind as
the default mechanism to login to the DE.

In order to check the status of your user session, you can use loginctl.
All PolicyKit actions like suspending the system or mounting external
drives will work out of the box.

    $ loginctl show-session $XDG_SESSION_ID

Writing custom .service files
-----------------------------

See: Systemd/Services

> Handling dependencies

With systemd, dependencies can be resolved by designing the unit files
correctly. The most typical case is that the unit A requires the unit B
to be running before A is started. In that case add Requires=B and
After=B to the [Unit] section of A. If the dependency is optional, add
Wants=B and After=B instead. Note that Wants= and Requires= do not imply
After=, meaning that if After= is not specified, the two units will be
started in parallel.

Dependencies are typically placed on services and not on targets. For
example, network.target is pulled in by whatever service configures your
network interfaces, therefore ordering your custom unit after it is
sufficient since network.target is started anyway.

> Type

There are several different start-up types to consider when writing a
custom service file. This is set with the Type= parameter in the
[Service] section. See man systemd.service for a more detailed
explanation.

-   Type=simple (default): systemd considers the service to be started
    up immediately. The process must not fork. Do not use this type if
    other services need to be ordered on this service, unless it is
    socket activated.
-   Type=forking: systemd considers the service started up once the
    process forks and the parent has exited. For classic daemons use
    this type unless you know that it is not necessary. You should
    specify PIDFile= as well so systemd can keep track of the main
    process.
-   Type=oneshot: This is useful for scripts that do a single job and
    then exit. You may want to set RemainAfterExit=yes as well so that
    systemd still considers the service as active after the process has
    exited.
-   Type=notify: Identical to Type=simple, but with the stipulation that
    the daemon will send a signal to systemd when it is ready. The
    reference implementation for this notification is provided by
    libsystemd-daemon.so.
-   Type=dbus: The service is considered ready when the specified
    BusName appears on DBus's system bus.

> Editing provided unit files

To edit a unit file provided by a package, you can create a directory
called /etc/systemd/system/<unit>.d/ for example
/etc/systemd/system/httpd.service.d/ and place *.conf files in there to
override or add new options. Systemd will parse these *.conf files and
apply them on top of the original unit. For example, if you simply want
to add an additional dependency to a unit, you may create the following
file:

    /etc/systemd/system/<unit>.d/customdependency.conf

    [Unit]
    Requires=<new dependency>
    After=<new dependency>

Then run the following for your changes to take effect:

    # systemctl daemon-reload
    # systemctl restart <unit>

Alternatively you can copy the old unit file from
/usr/lib/systemd/system/ to /etc/systemd/system/ and make your changes
there. A unit file in /etc/systemd/system/ always overrides the same
unit in /usr/lib/systemd/system/. Note that when the original unit in
/usr/lib/ is changed due to a package upgrade, these changes will not
automatically apply to your custom unit file in /etc/. Additionally you
will have to manually reenable the unit with systemctl reenable <unit>.
It is therefore recommended to use the *.conf method described before
instead.

Tip:You can use systemd-delta to see which unit files have been
overridden and what exactly has been changed.

As the provided unit files will be updated from time to time, use
systemd-delta for system maintenance.

> Syntax highlighting for units within Vim

Syntax highlighting for systemd unit files within Vim can be enabled by
installing vim-systemd from the official repositories.

Targets
-------

Systemd uses targets which serve a similar purpose as runlevels but act
a little different. Each target is named instead of numbered and is
intended to serve a specific purpose with the possibility of having
multiple ones active at the same time. Some targets are implemented by
inheriting all of the services of another target and adding additional
services to it. There are systemd targets that mimic the common
SystemVinit runlevels so you can still switch targets using the familiar
telinit RUNLEVEL command.

> Get current targets

The following should be used under systemd instead of runlevel:

    $ systemctl list-units --type=target

> Create custom target

The runlevels that are assigned a specific purpose on vanilla Fedora
installs; 0, 1, 3, 5, and 6; have a 1:1 mapping with a specific systemd
target. Unfortunately, there is no good way to do the same for the
user-defined runlevels like 2 and 4. If you make use of those it is
suggested that you make a new named systemd target as
/etc/systemd/system/<your target> that takes one of the existing
runlevels as a base (you can look at
/usr/lib/systemd/system/graphical.target as an example), make a
directory /etc/systemd/system/<your target>.wants, and then symlink the
additional services from /usr/lib/systemd/system/ that you wish to
enable.

> Targets table

  SysV Runlevel   systemd Target                                          Notes
  --------------- ------------------------------------------------------- ----------------------------------------------------------------------------------------------
  0               runlevel0.target, poweroff.target                       Halt the system.
  1, s, single    runlevel1.target, rescue.target                         Single user mode.
  2, 4            runlevel2.target, runlevel4.target, multi-user.target   User-defined/Site-specific runlevels. By default, identical to 3.
  3               runlevel3.target, multi-user.target                     Multi-user, non-graphical. Users can usually login via multiple consoles or via the network.
  5               runlevel5.target, graphical.target                      Multi-user, graphical. Usually has all the services of runlevel 3 plus a graphical login.
  6               runlevel6.target, reboot.target                         Reboot
  emergency       emergency.target                                        Emergency shell

> Change current target

In systemd targets are exposed via "target units". You can change them
like this:

    # systemctl isolate graphical.target

This will only change the current target, and has no effect on the next
boot. This is equivalent to commands such as telinit 3 or telinit 5 in
Sysvinit.

> Change default target to boot into

The standard target is default.target, which is aliased by default to
graphical.target (which roughly corresponds to the old runlevel 5). To
change the default target at boot-time, append one of the following
kernel parameters to your bootloader:

Tip:The .target extension can be left out.

-   systemd.unit=multi-user.target (which roughly corresponds to the old
    runlevel 3),
-   systemd.unit=rescue.target (which roughly corresponds to the old
    runlevel 1).

Alternatively, you may leave the bootloader alone and change
default.target. This can be done using systemctl:

    # systemctl enable multi-user.target

The effect of this command is outputted by systemctl; a symlink to the
new default target is made at /etc/systemd/system/default.target. This
works if, and only if:

    [Install]
    Alias=default.target

is in the target's configuration file. Currently, multi-user.target and
graphical.target both have it.

Journal
-------

Since version 38, systemd has its own logging system, the journal.
Therefore, running a syslog daemon is no longer required. To read the
log, use:

    # journalctl

By default (when Storage= is set to auto in /etc/systemd/journald.conf),
the journal writes to /var/log/journal/. The directory /var/log/journal/
is part of core/systemd. If you or some program delete it, systemd will
not recreate it automatically, however it will be recreated during the
next update of systemd. Till then, logs will be written to
/run/systemd/journal. This means that logs will be lost on reboot.

> Filtering output

journalctl allows you to filter the output by specific fields.

Examples:

Show all messages from this boot:

    # journalctl -b

However, often one is interested in messages not from the current, but
from the previous boot (e.g. if an unrecoverable system crash happened).
Currently, this feature is not implemented, though there was a
discussion at systemd-devel@lists.freedesktop.org (September/October
2012).

As a workaround you can use at the moment:

    # journalctl --since=today | tac | sed -n '/-- Reboot --/{n;:r;/-- Reboot --/q;p;n;b r}' | tac

provided, that the previous boot happened today. Be aware that, if there
are many messages for the current day, the output of this command can be
delayed for quite some time.

Follow new messages:

    # journalctl -f

Show all messages by a specific executable:

    # journalctl /usr/lib/systemd/systemd

Show all messages by a specific process:

    # journalctl _PID=1

Show all messages by a specific unit:

    # journalctl -u netcfg

See man journalctl, systemd.journal-fields or Lennert's blog post for
details.

> Journal size limit

If the journal is persistent (non-volatile), its size limit is set to a
default value of 10% of the size of the respective file system. For
example, with /var/log/journal located on a 50 GiB root partition this
would lead to 5 GiB of journal data. The maximum size of the persistent
journal can be controlled by SystemMaxUse in /etc/systemd/journald.conf,
so to limit it for example to 50 MiB uncomment and edit the
corresponding line to:

    SystemMaxUse=50M

Refer to man journald.conf for more info.

> Journald in conjunction with syslog

Compatibility with classic syslog implementations is provided via a
socket /run/systemd/journal/syslog, to which all messages are forwarded.
To make the syslog daemon work with the journal, it has to bind to this
socket instead of /dev/log (official announcement). The syslog-ng
package in the repositories automatically provides the necessary
configuration.

    # systemctl enable syslog-ng

A good journalctl tutorial is here.

Optimization
------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Improve     
                           Boot Performance.        
                           Notes: Should be moved   
                           to the article covering  
                           this topic. (Discuss)    
  ------------------------ ------------------------ ------------------------

See Improve Boot Performance.

> Analyzing the boot process

Using systemd-analyze

Systemd provides a tool called systemd-analyze that allows you to
analyze your boot process so you can see which unit files are causing
your boot process to slow down. You can then optimize your system
accordingly.

To see how much time was spent in kernelspace and userspace on boot,
simply use:

    $ systemd-analyze

Tip:

-   If you append the timestamp hook to your HOOKS array in
    /etc/mkinitcpio.conf and rebuild your initramfs with
    mkinitcpio -p linux, systemd-analyze is also able to show you how
    much time was spent in the initramfs.
-   If you boot via UEFI and use a boot loader which implements
    systemds' Boot Loader Interface (which currently only Gummiboot
    does), systemd-analyze can additionally show you how much time was
    spent in the EFI firmware and the boot loader itself.

To list the started unit files, sorted by the time each of them took to
start up:

    $ systemd-analyze blame

You can also create a SVG file which describes your boot process
graphically, similiar to Bootchart:

    $ systemd-analyze plot > plot.svg

Using systemd-bootchart

Bootchart has been merged into systemd since Oct. 17, and you can use it
to boot just as you would with the original bootchart. Add this to your
kernel line:

    initcall_debug printk.time=y init=/usr/lib/systemd/systemd-bootchart

Using bootchart2

You could also use a version of bootchart to visualize the boot
sequence. Since you are not able to put a second init into the kernel
command line you won't be able to use any of the standard bootchart
setups. However the bootchart2 package from AUR comes with an
undocumented systemd service. After you've installed bootchart2 do:

    # systemctl enable bootchart

Read the bootchart documentation for further details on using this
version of bootchart.

> Readahead

Systemd comes with its own readahead implementation, this should in
principle improve boot time. However, depending on your kernel version
and the type of your hard drive, your mileage may vary (i.e. it might be
slower). To enable, do:

    # systemctl enable systemd-readahead-collect systemd-readahead-replay

Remember that in order for the readahead to work its magic, you should
reboot a couple of times.

Troubleshooting
---------------

> Shutdown/reboot takes terribly long

If the shutdown process takes a very long time (or seems to freeze) most
likely a service not exiting is to blame. Systemd waits some time for
each service to exit before trying to kill it. To find out if you are
affected, see this article.

> Short lived processes don't seem to log any output

If journalctl -u foounit doesn't show any output for a short lived
service, look at the PID instead. For example, if
systemd-modules-load.service fails, and
systemctl status systemd-modules-load shows that it ran as PID 123, then
you might be able to see output in the journal for that PID, i.e.
journalctl -b _PID=123. Metadata fields for the journal such as
_SYSTEMD_UNIT and _COMM are collected asynchronously and rely on the
/proc directory for the process existing. Fixing this requires fixing
the kernel to provide this data via a socket connection, similar to
SCM_CREDENTIALS.

> Diagnosing Boot Problems

Boot with these parameters on the kernel command line:
systemd.log_level=debug systemd.log_target=kmsg log_buf_len=1M

More Debugging Information

See also
--------

-   Official Web Site
-   Manual Pages
-   systemd Optimizations
-   FAQ
-   Tips And Tricks
-   systemd for Administrators (PDF)
-   About systemd on Fedora Project
-   How to debug systemd problems
-   Two part introductory article in The H Open magazine.
-   Lennart's blog story
-   status update
-   status update2
-   status update3
-   most recent summary
-   Fedora's SysVinit to systemd cheatsheet

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd&oldid=256088"

Categories:

-   Daemons and system services
-   Boot process
