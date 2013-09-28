Upgrade Path
============

Warning:It is strongly advised to avoid the --force switch as it is not
safe. This will seriously break your system, especially for the /lib
update.

Note:mkinitcpio can fail during a kernel install, especially after a
lengthy delay in updating. If it fails run it again manually before
updating or the system will fail to boot

Note:Remember to deal with Pacnew and Pacsave Files after upgrading.

Archlinux upgrades occasionally require manual intervention to complete.
While its best practise to regularly update an archlinux installation,
sometimes this isn't possible and upgrading a system can be complicated
by multiple simultaneous conflicting updates, especially since conflicts
can interact with each other. Collected here are detailed instructions
to bring old machines from various points of time up to date.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Timeline                                                           |
| -   2 End of initscripts support                                         |
| -   3 Fontconfig 2.10.1 update                                           |
| -   4 The /lib directory becomes a symlink                               |
| -   5 Upgrading Filesystem                                               |
|     -   5.1 Symlinks to /run and /run/lock                               |
|     -   5.2 Conflict with mtab                                           |
+--------------------------------------------------------------------------+

Timeline
========

The timeline of recent breaking changes detailed on this page:

-   2012-11-04 End of initscripts support
-   2012-09-06 Fontconfig 2.10.1 update
-   2012-07-14 The /lib directory becomes a symlink
-   2012-06-07 Symlinks to /run
-   2011-12-20 Symlinks to /proc/self/mounts

End of initscripts support
==========================

Systemd is now the default init system. Its strongly encourage for all
users to migrate as soon as possible. Please refer to the Systemd page
for more instructions.

Fontconfig 2.10.1 update
========================

The fontconfig 2.10.1 update overwrites symlinks created by the former
package version. These symlinks need to be removed before the update:

     rm /etc/fonts/conf.d/20-unhint-small-vera.conf
     rm /etc/fonts/conf.d/20-fix-globaladvance.conf
     rm /etc/fonts/conf.d/29-replace-bitmap-fonts.conf
     rm /etc/fonts/conf.d/30-metric-aliases.conf
     rm /etc/fonts/conf.d/30-urw-aliases.conf
     rm /etc/fonts/conf.d/40-nonlatin.conf
     rm /etc/fonts/conf.d/45-latin.conf
     rm /etc/fonts/conf.d/49-sansserif.conf
     rm /etc/fonts/conf.d/50-user.conf
     rm /etc/fonts/conf.d/51-local.conf
     rm /etc/fonts/conf.d/60-latin.conf
     rm /etc/fonts/conf.d/65-fonts-persian.conf
     rm /etc/fonts/conf.d/65-nonlatin.conf
     rm /etc/fonts/conf.d/69-unifont.conf
     rm /etc/fonts/conf.d/80-delicious.conf
     rm /etc/fonts/conf.d/90-synthetic.conf
     pacman -Sy fontconfig

Main systemwide configuration should be done by symlinks (especially for
autohinting, sub-pixel and lcdfilter):

     cd /etc/fonts/conf.d
     ln -s ../conf.avail/XX-foo.conf

For more information, refer to Font Configuration and Fonts.

The /lib directory becomes a symlink
====================================

All Arch Linux packages have had their files in the /lib directory moved
to /usr/lib and now /lib is a symlink to usr/lib. When performing this
update, pacman will likely identify a conflict in the /lib directory. In
the simplest case, this is worked around by doing:

Instructions for dealing with this update have been enumerated here.
Please read this page very carefully before proceeding.

https://wiki.archlinux.org/index.php/DeveloperWiki:usrlib

Upgrading Filesystem
====================

Upgrading the filesystem package can get tricky since there are several
different breaking changes that may have accumulated over time that
somewhat interact with each other. Pick the section below that best
describes the conflict you see for instructions to bring the filesystem
package up to date.

Symlinks to /run and /run/lock
------------------------------

As of filesystem-2012.6-2 the folders /var/run and /var/lock will be
replaced by symlinks to /run and /run/lock, respectively.

On most systems this is already the case, as initscripts create the
symlinks on boot. However, these symlinks are not owned by any package,
which is what we are fixing with this upgrade.

If the symlinks are already in place on your system (which should be the
case for most people), then you can simply perform:

     pacman -Sy
     rm -r /var/{lock,run} /etc/profile.d/locale.sh
     pacman -S filesystem

Then reboot the system before continuing along with the upgrade.

Upgrading while running a kernels prior to linux-3.4 will get a warning
about permissions on /sys. This is nothing to worry about, as of
linux-3.4 the permissions will be 555, and this upgrade reflects this in
the filesystem package.

Conflict with mtab
------------------

The file /etc/mtab used to be generated at boot and hence was owned by
any package. Now it is a symlink to /proc/self/mounts owned by
filesystem. This change means that initscripts no longer requires write
access to the rootfs (though other packages might).

However following the instructions on the news, while sufficiently for
dealing with this conflict at the time, will now interact with later
filesystem update. To upgrade do

     pacman -Sy
     pacman -S initscripts
     rm -r /var/{lock,run} /etc/mtab

Now you'll to comment out CheckSpace in /etc/pacman.conf as pacman needs
to access /etc/mtab to enable this feature. It is highly recommended to
enable to restore it after dealing with the conflict.

     pacman -S filesystem

And then reboot the system before continuing along with the upgrade like
described in the previous section.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Upgrade_Path&oldid=236589"

Category:

-   System administration
