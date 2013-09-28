Using File Capabilities Instead Of Setuid
=========================================

The intention of this article is to remove the setuid attribute in the
binaries that require certain root-privileges. In this way, it
eliminates the need for "all or nothing", using a fine grained control
with POSIX 1003.1e capabilities.

Use with caution, some programs do not know about file capabilities. It
apparently works correctly, but have some unexpected side effects (see
for example #util-linux-ng)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Setuid-root files by package                                       |
|     -   2.1 coreutils                                                    |
|     -   2.2 dcron                                                        |
|     -   2.3 inetutils                                                    |
|     -   2.4 iputils                                                      |
|     -   2.5 pam                                                          |
|     -   2.6 pmount                                                       |
|     -   2.7 pulseaudio                                                   |
|     -   2.8 screen                                                       |
|     -   2.9 shadow                                                       |
|     -   2.10 sudo                                                        |
|     -   2.11 util-linux-ng                                               |
|     -   2.12 xorg-xserver                                                |
|                                                                          |
| -   3 Other programs that benefit from capabilities                      |
|     -   3.1 beep                                                         |
|     -   3.2 chvt                                                         |
|     -   3.3 iftop                                                        |
|     -   3.4 mii-tool                                                     |
|                                                                          |
| -   4 Useful commands                                                    |
| -   5 Additional Resources                                               |
+--------------------------------------------------------------------------+

Prerequisites
-------------

You need libcap, for setting file capabalities that are extended
attributes, with the utility setcap.

    # pacman -S libcap

Setuid-root files by package
----------------------------

> coreutils

Note:Warning: Do not use it, because su will return incorrect password.

    # chmod u-s /bin/su
    # setcap cap_setgid,cap_setuid+ep /bin/su

> dcron

    # chmod u-s /usr/bin/crontab
    # setcap cap_dac_override,cap_setgid+ep /usr/bin/crontab

> inetutils

    # chmod u-s /usr/bin/rsh
    # setcap cap_net_bind_service+ep /usr/bin/rsh

    # chmod u-s /usr/bin/rcp
    # setcap cap_net_bind_service+ep /usr/bin/rcp

    # chmod u-s /usr/bin/rlogin
    # setcap cap_net_bind_service+ep /usr/bin/rlogin

> iputils

    # chmod u-s /bin/ping
    # setcap cap_net_raw+ep /bin/ping

    # chmod u-s /bin/ping6
    # setcap cap_net_raw+ep /bin/ping6

    # chmod u-s /bin/traceroute
    # setcap cap_net_raw+ep /bin/traceroute

    # chmod u-s /bin/traceroute6
    # setcap cap_net_raw+ep /bin/traceroute6

> pam

    # chmod u-s /sbin/unix_chkpwd
    # setcap cap_dac_read_search+ep /sbin/unix_chkpwd

> pmount

Does not work without setuid.

> pulseaudio

    # chmod u-s /usr/lib/pulse/proximity-helper
    # setcap cap_net_raw+ep /usr/lib/pulse/proximity-helper

> screen

Needs setuid for multiuser sessions, but if you don't need that feature,
you can safely turn off setuid.

> shadow

    # chmod u-s /usr/bin/chage
    # setcap cap_dac_read_search+ep /usr/bin/chage

    # chmod u-s /usr/bin/chfn
    # setcap cap_chown,cap_setuid+ep /usr/bin/chfn

    # chmod u-s /usr/bin/chsh
    # setcap cap_chown,cap_setuid+ep /usr/bin/chsh

    # chmod u-s /usr/bin/expiry
    # setcap cap_dac_override,cap_setgid+ep /usr/bin/expiry

    # chmod u-s /usr/bin/gpasswd
    # setcap cap_chown,cap_dac_override,cap_setuid+ep /usr/bin/gpasswd

    # chmod u-s /usr/bin/newgrp
    # setcap cap_dac_override,cap_setgid+ep /usr/bin/newgrp

    # chmod u-s /usr/bin/passwd
    # setcap cap_chown,cap_dac_override,cap_fowner+ep /usr/bin/passwd

> sudo

Sudo does not work without setuid.

> util-linux-ng

Note:Warning: Do not use it, because mount and umount can not do some
checks, then users can mount/umount filesystems that do not have
permission.

    # chmod u-s /bin/mount
    # setcap cap_dac_override,cap_sys_admin+ep /bin/mount

    # chmod u-s /bin/umount
    # setcap cap_dac_override,cap_sys_admin+ep /bin/umount

> xorg-xserver

    # chmod u-s /usr/bin/Xorg
    # setcap cap_chown,cap_dac_override,cap_sys_rawio,cap_sys_admin+ep /usr/bin/Xorg

Other programs that benefit from capabilities
---------------------------------------------

The following packages do not have files with the setuid attribute but
require root privileges to work. By enabling some capabilities, regular
users can use the program without privilege elevation.

> beep

    # setcap cap_dac_override,cap_sys_tty_config+ep /usr/bin/beep

> chvt

    # setcap cap_dac_read_search,cap_sys_tty_config+ep /usr/bin/chvt

> iftop

    # setcap cap_net_raw+ep /usr/sbin/iftop

> mii-tool

    # setcap cap_net_admin+ep /sbin/mii-tool

Useful commands
---------------

Find setuid-root files

    $ find /bin /sbin /lib /usr/bin /usr/sbin /usr/lib -perm /4000 -user root

Find setgid-root files

    $ find /bin /sbin /lib /usr/bin /usr/sbin /usr/lib -perm /2000 -group root

Additional Resources
--------------------

-   Man Page capabilities(7) setcap(8) getcap(8)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Using_File_Capabilities_Instead_Of_Setuid&oldid=223502"

Category:

-   Security
