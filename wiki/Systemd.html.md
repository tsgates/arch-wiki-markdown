systemd
=======

Related articles

-   systemd/User
-   systemd/Services
-   systemd/cron functionality
-   systemd FAQ
-   init Rosetta
-   Daemons List
-   udev
-   Improve boot performance

From the project web page:

systemd is a system and service manager for Linux, compatible with SysV
and LSB init scripts. systemd provides aggressive parallelization
capabilities, uses socket and D-Bus activation for starting services,
offers on-demand starting of daemons, keeps track of processes using
Linux control groups, supports snapshotting and restoring of the system
state, maintains mount and automount points and implements an elaborate
transactional dependency-based service control logic.

Note:For a detailed explanation as to why Arch has moved to systemd, see
this forum post.

Contents
--------

-   1 Basic systemctl usage
    -   1.1 Analyzing the system state
    -   1.2 Using units
    -   1.3 Power management
-   2 Writing custom .service files
    -   2.1 Handling dependencies
    -   2.2 Type
    -   2.3 Editing provided unit files
    -   2.4 Syntax highlighting for units within Vim
-   3 Targets
    -   3.1 Get current targets
    -   3.2 Create custom target
    -   3.3 Targets table
    -   3.4 Change current target
    -   3.5 Change default target to boot into
-   4 Temporary files
-   5 Timers
-   6 Journal
    -   6.1 Filtering output
    -   6.2 Journal size limit
    -   6.3 Journald in conjunction with syslog
    -   6.4 Forward journald to /dev/tty12
-   7 Troubleshooting
    -   7.1 Investigating systemd errors
    -   7.2 Diagnosing boot problems
    -   7.3 Shutdown/reboot takes terribly long
    -   7.4 Short lived processes do not seem to log any output
    -   7.5 Disabling application crash dumps journaling
    -   7.6 Error message on reboot or shutdown
        -   7.6.1 cgroup : option or name mismatch, new: 0x0 "", old:
            0x4 "systemd"
        -   7.6.2 watchdog watchdog0: watchdog did not stop!
-   8 See also

Basic systemctl usage
---------------------

The main command used to introspect and control systemd is systemctl.
Some of its uses are examining the system state and managing the system
and services. See man 1 systemctl for more details.

Tip:You can use all of the following systemctl commands with the
-H user@host switch to control a systemd instance on a remote machine.
This will use SSH to connect to the remote systemd instance.

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
/etc/systemd/system/ (the latter takes precedence). You can see a list
of the installed unit files with:

    $ systemctl list-unit-files

> Using units

Units can be, for example, services (.service), mount points (.mount),
devices (.device) or sockets (.socket).

When using systemctl, you generally have to specify the complete name of
the unit file, including its suffix, for example sshd.socket. There are
however a few short forms when specifying the unit in the following
systemctl commands:

-   If you do not specify the suffix, systemctl will assume .service.
    For example, netcfg and netcfg.service are equivalent.
-   Mount points will automatically be translated into the appropriate
    .mount unit. For example, specifying /home is equivalent to
    home.mount.
-   Similar to mount points, devices are automatically translated into
    the appropriate .device unit, therefore specifying /dev/sda2 is
    equivalent to dev-sda2.device.

See man systemd.unit for details.

Tip:Most of the following commands also work if multiple units are
specified, see man systemctl for more information.

Activate a unit immediately:

    # systemctl start unit

Deactivate a unit immediately:

    # systemctl stop unit

Restart a unit:

    # systemctl restart unit

Ask a unit to reload its configuration:

    # systemctl reload unit

Show the status of a unit, including whether it is running or not:

    $ systemctl status unit

Check whether a unit is already enabled or not:

    $ systemctl is-enabled unit

Enable a unit to be started on bootup:

    # systemctl enable unit

Note:Services without an [Install] section are usually called
automatically by other services. If you need to install them manually,
use the following command, replacing foo with the name of the service.

    # ln -s /usr/lib/systemd/system/foo.service /etc/systemd/system/graphical.target.wants/

Disable a unit to not start during bootup:

    # systemctl disable unit

Show the manual page associated with a unit (this has to be supported by
the unit file):

    $ systemctl help unit

Reload systemd, scanning for new or changed units:

    # systemctl daemon-reload

> Power management

polkit is necessary for power management as an unprivileged user. If you
are in a local systemd-logind user session and no other session is
active, the following commands will work without root privileges. If not
(for example, because another user is logged into a tty), systemd will
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

Writing custom .service files
-----------------------------

The syntax of systemd's unit files is inspired by XDG Desktop Entry
Specification .desktop files, which are in turn inspired by Microsoft
Windows .ini files.

See systemd/Services for more examples.

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
-   Type=oneshot: this is useful for scripts that do a single job and
    then exit. You may want to set RemainAfterExit=yes as well so that
    systemd still considers the service as active after the process has
    exited.
-   Type=notify: identical to Type=simple, but with the stipulation that
    the daemon will send a signal to systemd when it is ready. The
    reference implementation for this notification is provided by
    libsystemd-daemon.so.
-   Type=dbus: the service is considered ready when the specified
    BusName appears on DBus's system bus.

> Editing provided unit files

To edit a unit file provided by a package, you can create a directory
called /etc/systemd/system/unit.d/ for example
/etc/systemd/system/httpd.service.d/ and place *.conf files in there to
override or add new options. systemd will parse these *.conf files and
apply them on top of the original unit. For example, if you simply want
to add an additional dependency to a unit, you may create the following
file:

    /etc/systemd/system/unit.d/customdependency.conf

    [Unit]
    Requires=new dependency
    After=new dependency

As another example, in order to replace the ExecStart directive for a
unit that is not of type oneshot, create the following file:

    /etc/systemd/system/unit.d/customexec.conf

    [Service]
    ExecStart=
    ExecStart=new command

One more example to automatically restart a service:

    /etc/systemd/system/unit.d/restart.conf

    [Service]
    Restart=always
    RestartSec=30

Then run the following for your changes to take effect:

    # systemctl daemon-reload
    # systemctl restart unit

Alternatively you can copy the old unit file from
/usr/lib/systemd/system/ to /etc/systemd/system/ and make your changes
there. A unit file in /etc/systemd/system/ always overrides the same
unit in /usr/lib/systemd/system/. Note that when the original unit in
/usr/lib/ is changed due to a package upgrade, these changes will not
automatically apply to your custom unit file in /etc/. Additionally you
will have to manually reenable the unit with systemctl reenable unit. It
is therefore recommended to use the *.conf method described before
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

systemd uses targets which serve a similar purpose as runlevels but act
a little different. Each target is named instead of numbered and is
intended to serve a specific purpose with the possibility of having
multiple ones active at the same time. Some targets are implemented by
inheriting all of the services of another target and adding additional
services to it. There are systemd targets that mimic the common
SystemVinit runlevels so you can still switch targets using the familiar
telinit RUNLEVEL command.

> Get current targets

The following should be used under systemd instead of running runlevel:

    $ systemctl list-units --type=target

> Create custom target

The runlevels that are assigned a specific purpose on vanilla Fedora
installs; 0, 1, 3, 5, and 6; have a 1:1 mapping with a specific systemd
target. Unfortunately, there is no good way to do the same for the
user-defined runlevels like 2 and 4. If you make use of those it is
suggested that you make a new named systemd target as
/etc/systemd/system/your target that takes one of the existing runlevels
as a base (you can look at /usr/lib/systemd/system/graphical.target as
an example), make a directory /etc/systemd/system/your target.wants, and
then symlink the additional services from /usr/lib/systemd/system/ that
you wish to enable.

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

In systemd targets are exposed via target units. You can change them
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

The effect of this command is output by systemctl; a symlink to the new
default target is made at /etc/systemd/system/default.target. This works
if, and only if:

    [Install]
    Alias=default.target

is in the target's configuration file. Currently, multi-user.target and
graphical.target both have it.

Temporary files
---------------

"systemd-tmpfiles creates, deletes and cleans up volatile and temporary
files and directories." It reads configuration files in /etc/tmpfiles.d/
and /usr/lib/tmpfiles.d/ to discover which actions to perform.
Configuration files in the former directory take precedence over those
in the latter directory.

Configuration files are usually provided together with service files,
and they are named in the style of /usr/lib/tmpfiles.d/program.conf. For
example, the Samba daemon expects the directory /run/samba to exist and
to have the correct permissions. Therefore, the samba package ships with
this configuration:

    /usr/lib/tmpfiles.d/samba.conf

    D /run/samba 0755 root root

Configuration files may also be used to write values into certain files
on boot. For example, if you used /etc/rc.local to disable wakeup from
USB devices with echo USBE > /proc/acpi/wakeup, you may use the
following tmpfile instead:

    /etc/tmpfiles.d/disable-usb-wake.conf

    w /proc/acpi/wakeup - - - - USBE

See the systemd-tmpfiles and tmpfiles.d(5) man pages for details.

Note:This method may not work to set options in /sys since the
systemd-tmpfiles-setup service may run before the appropriate device
modules is loaded. In this case you could check whether the module has a
parameter for the option you want to set with modinfo module and set
this option with a config file in /etc/modprobe.d. Otherwise you will
have to write a udev rule to set the appropriate attribute as soon as
the device appears.

Timers
------

Systemd can replace cron functionality to a great extent. For further
information, please refer to systemd/cron functionality.

Journal
-------

systemd has its own logging system called the journal; therefore,
running a syslog daemon is no longer required. To read the log, use:

    # journalctl

In Arch Linux, the directory /var/log/journal/ is a part of the systemd
package, and the journal (when Storage= is set to auto in
/etc/systemd/journald.conf) will write to /var/log/journal/. If you or
some program delete that directory, systemd will not recreate it
automatically; however, it will be recreated during the next update of
the systemd package. Until then, logs will be written to
/run/systemd/journal, and logs will be lost on reboot.

Tip:If /var/log/journal/ resides in a btrfs file system, you should
consider disabling Copy-on-Write for the directory. See the main article
for details: Btrfs#Copy-On-Write (CoW).

> Filtering output

journalctl allows you to filter the output by specific fields. Be aware
that if there are many messages to display or filtering of large time
span has to be done, the output of this command can be delayed for quite
some time.

Examples:

Show all messages from this boot:

    # journalctl -b

However, often one is interested in messages not from the current, but
from the previous boot (e.g. if an unrecoverable system crash happened).
This is possible through optional offset parameter of the -b flag:
journalctl -b -0 shows messages from the current boot, journalctl -b -1
from the previous boot, journalctl -b -2 from the second previous and so
on. See man 1 journalctl for full description, the semantics is much
more powerful.

Follow new messages:

    # journalctl -f

Show all messages by a specific executable:

    # journalctl /usr/lib/systemd/systemd

Show all messages by a specific process:

    # journalctl _PID=1

Show all messages by a specific unit:

    # journalctl -u netcfg

Show kernel ring buffer:

    # journalctl _TRANSPORT=kernel

See man 1 journalctl, man 7 systemd.journal-fields, or Lennert's blog
post for details.

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

> Forward journald to /dev/tty12

In /etc/systemd/journald.conf enable the following:

    ForwardToConsole=yes
    TTYPath=/dev/tty12
    MaxLevelConsole=info

Restart journald with sudo systemctl restart systemd-journald.

Troubleshooting
---------------

> Investigating systemd errors

As an example, we will investigate an error with systemd-modules-load
service:

1. Lets find the systemd services which fail to start:

    $ systemctl --state=failed

    systemd-modules-load.service   loaded failed failed  Load Kernel Modules

2. Ok, we found a problem with systemd-modules-load service. We want to
know more:

    $ systemctl status systemd-modules-load

    systemd-modules-load.service - Load Kernel Modules
       Loaded: loaded (/usr/lib/systemd/system/systemd-modules-load.service; static)
       Active: failed (Result: exit-code) since So 2013-08-25 11:48:13 CEST; 32s ago
         Docs: man:systemd-modules-load.service(8).
               man:modules-load.d(5)
      Process: 15630 ExecStart=/usr/lib/systemd/systemd-modules-load (code=exited, status=1/FAILURE)

If the Process ID is not listed, just restart the failed service with
systemctl restart systemd-modules-load

3. Now we have the process id (PID) to investigate this error in depth.
Enter the following command with the current Process ID (here: 15630):

    $ journalctl -b _PID=15630

    -- Logs begin at Sa 2013-05-25 10:31:12 CEST, end at So 2013-08-25 11:51:17 CEST. --
    Aug 25 11:48:13 mypc systemd-modules-load[15630]: Failed to find module 'blacklist usblp'
    Aug 25 11:48:13 mypc systemd-modules-load[15630]: Failed to find module 'install usblp /bin/false'

4. We see that some of the kernel module configs have wrong settings.
Therefore we have a look at these settings in /etc/modules-load.d/:

    $ ls -Al /etc/modules-load.d/

    ...
    -rw-r--r--   1 root root    79  1. Dez 2012  blacklist.conf
    -rw-r--r--   1 root root     1  2. Mär 14:30 encrypt.conf
    -rw-r--r--   1 root root     3  5. Dez 2012  printing.conf
    -rw-r--r--   1 root root     6 14. Jul 11:01 realtek.conf
    -rw-r--r--   1 root root    65  2. Jun 23:01 virtualbox.conf
    ...

5. The Failed to find module 'blacklist usblp' error message might be
related to a wrong setting inside of blacklist.conf. Lets deactivate it
with inserting a trailing # before each option we found via step 3:

    /etc/modules-load.d/blacklist.conf

    # blacklist usblp
    # install usblp /bin/false

6. Now, try to start systemd-modules-load:

    $ systemctl start systemd-modules-load.service

If it was successful, this shouldn't prompt anything. If you see any
error, go back to step 3. and use the new PID for solving the errors
left.

If everything is ok, you can verify that the service was started
successfully with:

    $ systemctl status systemd-modules-load

    systemd-modules-load.service - Load Kernel Modules
       Loaded: loaded (/usr/lib/systemd/system/systemd-modules-load.service; static)
       Active: active (exited) since So 2013-08-25 12:22:31 CEST; 34s ago
         Docs: man:systemd-modules-load.service(8)
               man:modules-load.d(5)
     Process: 19005 ExecStart=/usr/lib/systemd/systemd-modules-load (code=exited, status=0/SUCCESS)
    Aug 25 12:22:31 mypc systemd[1]: Started Load Kernel Modules.

Often you can solve these kind of problems like shown above. For further
investigation look at Diagnosing boot problems.

> Diagnosing boot problems

Boot with these parameters on the kernel command line:
systemd.log_level=debug systemd.log_target=kmsg log_buf_len=1M

More Debugging Information

> Shutdown/reboot takes terribly long

If the shutdown process takes a very long time (or seems to freeze) most
likely a service not exiting is to blame. systemd waits some time for
each service to exit before trying to kill it. To find out if you are
affected, see this article.

> Short lived processes do not seem to log any output

If journalctl -u foounit does not show any output for a short lived
service, look at the PID instead. For example, if
systemd-modules-load.service fails, and
systemctl status systemd-modules-load shows that it ran as PID 123, then
you might be able to see output in the journal for that PID, i.e.
journalctl -b _PID=123. Metadata fields for the journal such as
_SYSTEMD_UNIT and _COMM are collected asynchronously and rely on the
/proc directory for the process existing. Fixing this requires fixing
the kernel to provide this data via a socket connection, similar to
SCM_CREDENTIALS.

> Disabling application crash dumps journaling

Run the following in order to overwrite the settings from
/lib/sysctl.d/:

    # ln -s /dev/null /etc/sysctl.d/50-coredump.conf
    # sysctl kernel.core_pattern=core

This will disable logging of coredumps to the journal.

Note that the default RLIMIT_CORE of 0 means that no core files are
written, either. If you want them, you also need to "unlimit" the core
file size in the shell:

    $ ulimit -c unlimited

See sysctl.d and the documentation for /proc/sys/kernel for more
information.

> Error message on reboot or shutdown

cgroup : option or name mismatch, new: 0x0 "", old: 0x4 "systemd"

See this thread for an explanation.

watchdog watchdog0: watchdog did not stop!

See this thread for an explanation.

See also
--------

-   Official web site
-   Wikipedia article
-   Manual pages
-   systemd optimizations
-   FAQ
-   Tips and tricks
-   systemd for Administrators (PDF)
-   About systemd on Fedora Project
-   How to debug systemd problems
-   Two part introductory article in The H Open magazine.
-   Lennart's blog story
-   Status update
-   Status update2
-   Status update3
-   Most recent summary
-   Fedora's SysVinit to systemd cheatsheet
-   Configuring systemd to allow normal users to shutdown
-   Gentoo Wiki systemd page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd&oldid=305088"

Categories:

-   Daemons and system services
-   Boot process

-   This page was last modified on 16 March 2014, at 12:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
