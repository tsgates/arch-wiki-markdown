Sub32
=====

Summary
-------

sub32 is a set of scripts available in the AUR which help you to create
and manage a i686 chroot.

Setup
-----

After you installed the sub32 package, you need to set up your chroot.
This can be done by sub32-init.

    sub32-init [mirror]

Mirror can be any mirror, by default ftp.archlinux.org is used. Reminder
that you need to escape it, e.g.

    ftp://ftp5.gwdg.de/pub/linux/archlinux/$repo/os/i686

turns into

    ftp://ftp5.gwdg.de/pub/linux/archlinux/\$repo/os/i686

After sub32-init completed successfully, you need to start the sub32
"daemon"(well, it isn't a real daemon) by issuing:

    /etc/rc.d/sub32 start

You can start it automatically by adding "sub32" to your daemons list in
/etc/rc.conf. After everything is done, you may want to configure your
chroot like your normal system. You may also want to mount your home to
/chroot32(e.g. mount -o bind /home /chroot32/home).

Usage
-----

Sub32 uses "profiles", scripts that are located in ~/.sub32. By default,
only one profile is available called "shell". Execute it using

    sub32 shell

Profiles are just shell scripts, so you can write your own and place
them into ~/.sub32.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sub32&oldid=206365"

Category:

-   Arch64
