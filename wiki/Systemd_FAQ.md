systemd FAQ
===========

Contents
--------

-   1 FAQ
    -   1.1 Q: Why do I get log messages on my console?
    -   1.2 Q: How do I change the number of gettys running by default?
    -   1.3 Q: How do I get more verbose output during boot?
    -   1.4 Q: How do I avoid clearing the console after boot?
    -   1.5 Q: What kernel options are required for Systemd?
    -   1.6 Q: What other units does a unit depend on?
    -   1.7 Q: My computer shuts down, but the power stays on
    -   1.8 Q: After migrating to systemd, why won't my fakeRAID mount?
    -   1.9 Q: How can I make a script start during the boot process?
    -   1.10 Q: Status of .service says "active (exited)" in green.
        (e.g. iptables)
    -   1.11 Q: Failed to issue method call: File exists error

FAQ
---

For an up-to-date list of known issues, look at the upstream TODO.

Q: Why do I get log messages on my console?

A: You must set the kernel loglevel yourself. Historically,
/etc/rc.sysinit did this for us and set dmesg loglevel to 3, which was a
reasonably quiet loglevel. Either add loglevel=3 or quiet to your kernel
parameters.

Q: How do I change the number of gettys running by default?

A: To add another getty, simply place another symlink for instantiating
another getty in the /etc/systemd/system/getty.target.wants/ directory:

    # ln -sf /usr/lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty9.service
    # systemctl start getty@tty9.service

To remove a getty, simply remove the getty symlinks you want to get rid
of in the /etc/systemd/system/getty.target.wants/ directory:

    # rm /etc/systemd/system/getty.target.wants/getty@{tty5,tty6}.service
    # systemctl stop getty@tty5.service getty@tty6.service

systemd does not use the /etc/inittab file.

Note:As of systemd 30, only one getty will be launched by default. If
you switch to another tty, a getty will be launched there
(socket-activation style). You can still force additional agetty
processes to start using the above methods.

Users may also change the number of gettys that may be auto-spawned by
editing /etc/systemd/logind.conf and changing the value of NAutoVTs. By
doing it this way, the on-demand spawning will be preserved, whereas the
above method will simply have the gettys running from boot.

Q: How do I get more verbose output during boot?

A: If you see no output at all in console after the initram message,
this means you have the quiet parameter in your kernel line. It's best
to remove it, at least the first time you boot with systemd, to see if
everything is ok. Then, You will see a list [ OK ] in green or
[ FAILED ] in red. Any messages are logged to the system log and if you
want to find out about the status of your system run systemctl (no root
privileges required) or look at the boot/system log with journalctl.

Q: How do I avoid clearing the console after boot?

A: Create a custom getty@tty1.service file by copying
/usr/lib/systemd/system/getty@.service to
/etc/systemd/system/getty@tty1.service and change TTYVTDisallocate to
no.

Q: What kernel options are required for Systemd?

A: Kernels prior to 2.6.39 are unsupported.

This is a partial list of required/recommended options, there might be
more:

    General setup
     CONFIG_FHANDLE=y
     CONFIG_AUDIT=y (recommended)
     CONFIG_CGROUPS=y
     -> Namespaces support
        CONFIG_NET_NS=y (for private network)
    Networking support -> Networking options
     CONFIG_IPV6=[y|m] (highly recommended)
    Device Drivers
     -> Generic Driver Options
        CONFIG_UEVENT_HELPER_PATH=""
        CONFIG_DEVTMPFS=y
        CONFIG_DEVTMPFS_MOUNT=y (required if you don't use an initramfs)
     -> Real Time Clock
        CONFIG_RTC_DRV_CMOS=y (highly recommended)
    File systems
     CONFIG_FANOTIFY=y (required for readahead)
     CONFIG_AUTOFS4_FS=[y|m]
     -> Pseudo filesystems
        CONFIG_TMPFS_POSIX_ACL=y (recommended, if you want to use pam_systemd.so)

Q: What other units does a unit depend on?

A: For example, if you want to figure out which services a target like
multi-user.target pulls in, use something like this:

    $ systemctl show -p "Wants" multi-user.target

    Wants=rc-local.service avahi-daemon.service rpcbind.service NetworkManager.service acpid.service dbus.service atd.service crond.service auditd.service ntpd.service udisks.service bluetooth.service cups.service wpa_supplicant.service getty.target modem-manager.service portreserve.service abrtd.service yum-updatesd.service upowerd.service test-first.service pcscd.service rsyslog.service haldaemon.service remote-fs.target plymouth-quit.service systemd-update-utmp-runlevel.service sendmail.service lvm2-monitor.service cpuspeed.service udev-post.service mdmonitor.service iscsid.service livesys.service livesys-late.service irqbalance.service iscsi.service

Instead of Wants you might also try WantedBy, Requires, RequiredBy,
Conflicts, ConflictedBy, Before, After for the respective types of
dependencies and their inverse.

Q: My computer shuts down, but the power stays on

A: Use:

    $ systemctl poweroff

Instead of systemctl halt.

Q: After migrating to systemd, why won't my fakeRAID mount?

A: Be sure you use:

    # systemctl enable dmraid.service

Q: How can I make a script start during the boot process?

A: Create a new file in /etc/systemd/system (e.g. myscript.service) and
add the following contents:

    [Unit]
    Description=My script

    [Service]
    ExecStart=/usr/bin/my-script

    [Install]
    WantedBy=multi-user.target 

Then:

    # systemctl enable myscript.service

This example assumes you want your script to start up when the target
multi-user is launched. Also do chmod 755 to your script to enable
execute permissions if you haven't done so already.

Note:In case you want to start a shell script, make sure you have
#!/bin/sh in the first line of the script. Do not write something like
ExecStart=/bin/sh /path/to/script.sh because that will not work.

Q: Status of .service says "active (exited)" in green. (e.g. iptables)

A: This is perfectly normal. In the case with iptables it is because
there is no daemon to run, it is controlled in the kernel. Therefore, it
exits after the rules have been loaded.

To check if your iptables rules have been loaded properly:

    # iptables --list

Q: Failed to issue method call: File exists error

A: This happens when using systemctl enable and the symlink it tries to
create in /etc/systemd/system/ already exists. Typically this happens
when switching from one display manager to another one (for instance GDM
to KDM, which can be enabled with gdm.service and kdm.service,
respectively) and the corresponding symlink
/etc/systemd/system/display-manager.service already exists. To solve
this problem, either first disable the relevent display manager before
enabling the new one, or use systemctl -f enable to overwrite an
existing symlink.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd_FAQ&oldid=304644"

Categories:

-   Daemons and system services
-   Boot process

-   This page was last modified on 15 March 2014, at 21:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
