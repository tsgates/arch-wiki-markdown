Automatic login to virtual console
==================================

> Summary

Describes how to automatically log in to a virtual console.

> Related

Display Manager

Silent boot

Start X at Login

This article describes how to automatically log in to a virtual console
at the end of the boot process. This article only covers console
log-ins; methods for starting an X server are described in Start X at
Login.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Creating the service file                                    |
|     -   1.2 Enabling the service                                         |
|                                                                          |
| -   2 Tips & Tricks                                                      |
|     -   2.1 Avoiding unnecessary dmesg errors                            |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> Creating the service file

Create a new service file similar to getty@.service by copying it to
/etc/systemd/system/:

    # cp /usr/lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service

Note:/etc/systemd/system/ takes precedence over
/usr/lib/systemd/system/.

Then change the ExecStart line to include the -a USERNAME parameter:

    /etc/systemd/system/autologin@.service

    [Service]
    [...]
    ExecStart=-/sbin/agetty --noclear -a USERNAME %I 38400
    [...]

    [Install]
    WantedBy=getty.target

Tip:The option Type=simple (default) will delay the execution of agetty
until all jobs (state change requests to units) are completed. On the
other hand it may cause systemd boot-up messages to pollute the login
prompt. This option is more useful when starting X automatically. See
man systemd.service for more info.

> Enabling the service

Finally, you need to disable the old getty@ttyX.service for the
specified tty and enable the new autologin@ttyX.service, e.g.:

    # systemctl daemon-reload
    # systemctl disable getty@tty1
    # systemctl enable autologin@tty1

To test it out, use:

    # systemctl start autologin@tty1

Tips & Tricks
-------------

> Avoiding unnecessary dmesg errors

To avoid errors related to display-manager.service in dmesg, you should
set the default target to multi-user instead of graphical:

    # systemctl enable multi-user.target

See also
--------

-   Change default runlevel/target to boot into.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Automatic_login_to_virtual_console&oldid=254921"

Categories:

-   Boot process
-   Security
