System Restore from Configurations
==================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Mentions of      
                           rc.conf and AIF need to  
                           be removed. (Discuss)    
  ------------------------ ------------------------ ------------------------

This article is intended to show you how to backup your configurations
and your package list, then to do a full system restore, restore
packages, and finally restore your configurations..

Contents
--------

-   1 Motivation
-   2 Backup
    -   2.1 Include and exclude files
    -   2.2 Packages
        -   2.2.1 Creating a package list
        -   2.2.2 Saving package tarballs
            -   2.2.2.1 Yaourt
    -   2.3 Storing the backup
-   3 Restoring
    -   3.1 AIF install
    -   3.2 Change root
    -   3.3 Reinstall your packages
        -   3.3.1 Official
        -   3.3.2 The AUR
    -   3.4 Extract configurations
    -   3.5 Final details

Motivation
----------

The need for this documentation is uncommon in the sense that the need
to restore from configurations only is only really necessary for the
following reasons:

1.  You would like to change your system architecture (e.g. 32bit to
    64bit).
2.  If a program or programs begin to behave unexpectedly and no help in
    the forums (or elsewhere) is available is able to fix the problem.
    By chance reinstalling your programs and other configurations might
    fix the problem.
3.  You have limited hard disk space and are not capable of doing a full
    restore from backup.

Tip:If you are a regular computer user, generally it is good practice to
backup your primary drive to a backup hard drive after getting your
system installed. Secondary storage disks can be found relatively
inexpensively these days and are able to store/restore an entire drive
of programs, configurations, documents, etc. in a safe and reliable way.
If you have a hardware setup like this, look at programs like the
Clonezilla CD, or the Parted Magic CD (includes Clonzilla and other
tools) which are both open-source and can image your hard drive for
later restoration.

Backup
------

Using tar in a script can make archiving configurations get done in just
a couple steps.

> Include and exclude files

Tar has the ability to read from both an include and an exclude file.
This means that you can tell tar everything you would like to include in
the backup and exclude just by using two files. The format used is one
line per file or directory that indicates the full path. For example:

    /etc/pacman.conf
    /etc/rc.conf
    /home/user
    ...

And is invoked like this:

    tar --files-from=include.txt --exclude-from=exclude.txt -c --xz -f backupname.tar.xz

The name of the files can be anything you want. The exclude file is like
the include file but additionally has the ability to be able to use
regexps, as well as being able to be commented and have blank lines.

> Packages

Package lists can be created that can re-install your programs upon a
restore. If you have the hard disk space available, you might also want
to consider saving the install packages (*.pkg.tar.gz) as well.

Creating a package list

You can create a list of all installed official packages with:

    $ pacman -Qqe | grep -v "$(pacman -Qqm)" > pkglist-off.txt

This will create a list of all packages in the official, enabled pacman
repositories (i.e. core, extra, community and testing).

To create a list of all local packages (includes packages installed from
the AUR):

    $ pacman -Qqm > pkglist-loc.txt

Saving package tarballs

Pacman saves all package tarballs in /var/cache/pacman/pkg/. Saving
these will increase your re-install speed so consider saving these as
well. You might want to think about reducing the size of the cache
before backing up too. Pacman has the ability to remove any uninstalled
packages from the cache with:

    # pacman -Sc

Yaourt

If you use Yaourt to install packages from the AUR, you might want to
consider setting up a cache for it (Yaourt by default does not save the
built package tarballs). To setup a cache directory, edit /etc/yaourtrc
to include one:

    ExportToLocalRepository /var/cache/pacman/pkg-local

Then give the directory the necessary permissions so Yaourt can write to
it as a regular user:

    # mkdir -p /var/cache/pacman/pkg-local
    # chmod 766 /var/cache/pacman/pkg-local

Copy these packages to your seperate medium.

> Storing the backup

After you have made up your tarred configurations, package lists, and
(optionally) your install packages, you are going to need to store them
on a seperate medium than your install partition/drive. Do not put your
package lists and install packages in your tarred configurations. This
is because all packages must be reinstalled first before you restore
your configurations to prevent file conflicts (pacman will not install
packages with file conflicts). If you have large enough USB Flash Drive
these work well. Optionally you can burn them to a CD or use a partition
utility like gparted to create an extra partition. If using CD's you can
span large archives by using the split utility. To create a new
partition consider using the Parted Magic CD which has GParted on it.

Restoring
---------

Restoring will involve:

1.  Installing the base system through the AIF (Arch Installation
    Framework).
2.  Changing root.
3.  Reinstalling all your packages.
4.  Extracting your configurations.
5.  Adding a new user.

> AIF install

Install Arch Linux as you normally would through the AIF on the LiveCD.

> Change root

When finished, mount your USB Flash Drive (or whatever medium you choose
to save your configurations... on).

    # mkdir /backup-files
    # mount /dev/disk-drive-parition /backup-files

Your Arch install will already be mounted on /mnt so now copy these
files to your Arch install:

    # mkdir -p /mnt/opt/restore
    # cd /backup-files
    # cp -a * /mnt/opt/restore

Now you will need to change root to your Arch install:

    $ cd /mnt
    # cp /etc/resolv.conf /mnt/etc
    # mount -t proc none /mnt/proc
    # mount -t sysfs none /mnt/sys
    # mount -o bind /dev /mnt/dev
    # chroot /mnt /bin/bash

> Reinstall your packages

Reinstall packages from the official repositories, the AUR, and locally
installed packages separately to better diagnose problems if they occur.

Official

First reinstall packages from the official repositories;

    pacman -Sy
    pacman -S --needed $(cat /opt/restore/pkglist-off.txt)

The AUR

Yaourt comes in handy here. To quickly install yaourt again:

    $ wget https://aur.archlinux.org/packages/yaourt/yaourt.tar.gz
    $ tar xvf yaourt.tar.gz && cd yaourt*
    $ makepkg -s
    # pacman -U yaourt-*.pkg.tar.gz

Then to install AUR pakages from the list:

    $ yaourt -S $(cat /opt/restore/pkglist-loc.txt | grep -vx "$(pacman -Qqm)")

grep -vx ... here is used to remove packages that are already installed.
This comes in useful in case you have to restart the command because you
had trouble installing one of the packages. If you have packages already
built by yaourt and in your yaourt cache, you can avoid recompiling
again by going to that cache and installing the packages manually
(pacman -U ...).

> Extract configurations

Once all packages have been installed you can extract the
configurations:

    tar xvf /opt/restore/hostname-arch-configs-date-tar.gz -C /mnt

A couple things to look out for:

-   Be aware of any changes to your partition layout. If you changed
    your partition, you will need to edit both /etc/fstab and
    /boot/grub/menu.lst.
-   If you had special options for the kernel ram disk (initrd), then
    you will have to re-compile it before your reboot to get your
    expected behavior.

> Final details

Good time to add your user now before you reboot. When creating a user,
consider giving the user a unique user id (UID). This will help prevent
conflicts in the future with other users and programs having the same
UID (UIDs for users generally start at 1000):

    # useradd -m -u 1050 -G audio,optical,power,storage,users,video -s /bin/bash user

If you have restored a user home directory (/home/user) from your backup
configurations, the -m switch will give a warning about an already
existing home directory but will not alter the directory. Do not forget
to change permissions in your home directory if your UIDs differ:

    # chown -R username:users /home/user

Now, reboot. Expect a few unexpected things here. No re-install is
perfect. ALSA may pop up a warning and may have to be configure again
and there may be a few other things unconsidered. That's it.
Congratulations on your reinstall.

Retrieved from
"https://wiki.archlinux.org/index.php?title=System_Restore_from_Configurations&oldid=290378"

Category:

-   System recovery

-   This page was last modified on 25 December 2013, at 21:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
