Power management
================

Related articles

-   Power saving
-   Display Power Management Signaling
-   Suspend and Hibernate

The purpose of this page is to provide general overview of power
management in Arch Linux. As Arch Linux uses systemd as system manager,
this article focuses on it.

There are multiple places where one can change power management
settings:

-   Kernel parameters
-   Kernel modules
-   udev rules

There are also many power management tools:

-   systemd
-   pm-utils
-   Laptop Mode Tools
-   TLP
-   acpid

Note:Power settings you set in one place/tool could be overwritten in
another place/tool.

Contents
--------

-   1 Power management with systemd
    -   1.1 ACPI events
    -   1.2 Suspend and hibernate
    -   1.3 Sleep hooks
        -   1.3.1 Suspend/resume service files
        -   1.3.2 Combined Suspend/resume service file
        -   1.3.3 Hooks in /usr/lib/systemd/system-sleep
-   2 See Also

Power management with systemd
-----------------------------

> ACPI events

systemd handles some power-related ACPI events. They can be configured
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

> Note:

-   Restart the systemd-logind daemon for your changes to take effect.
-   systemd cannot handle AC and Battery ACPI events, so if you use
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

> Suspend and hibernate

systemd provides commands for suspend to RAM, hibernate and a hybrid
suspend using the kernel's native suspend/resume functionality. There
are also mechanisms to add hooks to customize pre- and post-suspend
actions.

Note:systemd can also use other suspend backends (such as Uswsusp or
TuxOnIce), in addition to the default kernel backend, in order to put
the computer to sleep or hibernate. See Uswsusp#With systemd for an
example.

systemctl suspend should work out of the box, for systemctl hibernate to
work on your system you need to follow the instructions at Suspend and
Hibernate#Hibernation.

> Sleep hooks

systemd does not use pm-utils to put the machine to sleep when using
systemctl suspend, systemctl hibernate or systemctl hybrid-sleep;
pm-utils hooks, including any custom hooks, will not be run. However,
systemd provides two similar mechanisms to run custom scripts on these
events.

Suspend/resume service files

Service files can be hooked into suspend.target, hibernate.target and
sleep.target to execute actions before or after suspend/hibernate.
Separate files should be created for user actions and root/system
actions. Enable the suspend@user and resume@user services to have them
started at boot. Examples:

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

For root/system actions (enable the root-resume and root-suspend
services to have them started at boot):

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
    semicolon (see the first example above; note the spaces before and
    after the semicolon, as they are required).
-   A command prefixed with - will cause a non-zero exit status to be
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

systemd runs all executables in /usr/lib/systemd/system-sleep/, passing
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

Note:You can also use sleep.target, suspend.target, hibernate.target or
hybrid-sleep.target to hook units into the sleep state logic instead of
using custom scripts.

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

Do not forget to make your script executable:

    # chmod a+x /usr/lib/systemd/system-sleep/example.sh

See man 7 systemd.special and man 8 systemd-sleep for more details.

See Also
--------

-   Laptop#Power management describes power management specific for
    laptops - especially battery monitoring.
-   General recommendations#Power management

Retrieved from
"https://wiki.archlinux.org/index.php?title=Power_management&oldid=299463"

Category:

-   Power management

-   This page was last modified on 21 February 2014, at 22:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
