ROX
===

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

ROX is an attempt to bring some of the good features from RISC OS to
Unix and Linux. This article covers its installation, configuration, and
troubleshooting.

ROX uses the GTK+ toolkit.

Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

From ROX Desktop | ROX Desktop:

ROX is a fast, user friendly desktop which makes extensive use of
drag-and-drop. The interface revolves around the file manager, or filer,
following the traditional Unix view that 'everything is a file' rather
than trying to hide the filesystem beneath start menus, wizards, or
druids. The aim is to make a system that is well designed and clearly
presented. The ROX style favors using several small programs together
instead of creating all-in-one mega-applications.

From About ROX | ROX Desktop:

Traditionally, Unix users have always based their activities around the
filesystem. Just about everything that's anything appears as a file:
regular files, hardware devices, and even processes on many systems (for
example, inside the /proc filesystem on Linux).

However, recent desktop efforts (such as KDE and GNOME) seem to be
following the Windows approach of trying to hide the filesystem and get
users to do things via a Start-menu or similar. Modern desktop users, on
Windows or Unix, often have no idea where their programs are installed,
or even where their data files are saved. This leads to a feeling of not
being in control, and a poor understanding of how the system works.

The ROX Desktop, however, is based around the filesystem. Its core
component is ROX-Filer, a powerful graphical file manager which, in
addition to being a popular filer in its own right, provides a couple of
extra features which allow it to solve the above problems...

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Pacman                                                       |
|     -   1.2 Zero Install                                                 |
|                                                                          |
| -   2 Usage                                                              |
|     -   2.1 File manager                                                 |
|     -   2.2 Desktop Environment                                          |
|     -   2.3 Mounting with static mountpoints                             |
|     -   2.4 Mounting with pmount                                         |
+--------------------------------------------------------------------------+

Installation
------------

There are two ways to install it, the usual way, and through Zero
Install.

> Pacman

The package, though it doesn't seem like it, has the desktop stuff with
it. Install it with:

    pacman -S rox

> Zero Install

Arch Linux does not exactly have a zero-install package (that I am aware
of), so this can be a potential PITA.

Make sure you have the packages 'python' 'gnupg' 'pygtk' installed.

Download the GPG key

     gpg --recv-key --keyserver www.keyserver.net 59A53CC1 

Download the actual 'injector'.

     wget http://osdn.dl.sourceforge.net/sourceforge/zero-install/zeroinstall-injector-0.26.tar.gz.gpg 

Check the signature using GPG, if you care.

    gpg zeroinstall-injector-0.26.tar.gz.gpg

You can stuff everything in a new directory like I did, or sit in $HOME.
Then extract and cd into the extracted directory.

Fun python install stuff (as root).

     python setup.py install 

Actually installing and using things is a little different, just read
their stuff: http://www.0install.net/injector-using.html

Usage
-----

> File manager

To execute rox, simply type:

    rox

> Desktop Environment

You need to run rox before your window manager. Here is my line, using
openbox as the WM

    rox -b Default -p default ; exec openbox

> Mounting with static mountpoints

Rox supports mounting and unmounting devices in /etc/fstab, simply by
clicking on the mount directory. For instance, you can create a
directory /mnt/cdrom, and set up an fstab entry like so:

     /dev/cdrom /mnt/cdrom auto noauto,user,ro 0 0 

Clicking on /mnt/cdrom will now automatically mount whatever data disk
is in your first CD drive.

> Mounting with pmount

Static mountpoints in fstab are obviously somewhat inflexible; mounting
two USB sticks at once, for instance, would require fstab entries for
both USB sticks. Fortunately, Rox lets you create custom right-click
menu entries for files, including device nodes in /dev. Thus, you can
use custom menu entries that invoke the pmount and pumount commands to
mount and unmount drives.

To do this, install the pmount package, then open up /dev in Rox and
right-click on a block device node (e.g. /dev/sr0). Enter the file menu
and click on "Customize Menu." A window will appear in which you can
create files that will invoke the necessary commands. Create, and then
make executable, the following files:

mount.sh:

    #!/bin/sh
    pmount "$@"

umount.sh:

    #!/bin/sh
    pumount "$@"

If you want your mount directories to use device labels or UUID use this
mount script instead: mount.sh:

    #!/bin/bash

    #Get device label using blkid
    blkid -o value -s LABEL  "$@" > /tmp/roxmount.tmp.$$
    LABEL=`cat /tmp/roxmount.tmp.$$`

    #Use UUID if no label is set
    if [ -z $LABEL ]
       then
       blkid -o value -s UUID  "$@" > /tmp/roxmount.tmp.$$
       LABEL=`cat /tmp/roxmount.tmp.$$`
    fi

    #Ask for mount name if no LABEL/UUID is found (NEEDS xdialog package installed)
    if [ -z $LABEL ]
       then
       Xdialog --title "Input Parameters" --inputbox "Enter a mount name" 0 0 2> /tmp/roxmount.tmp.$$
       LABEL=`cat /tmp/roxmount.tmp.$$`
    fi

    #Mount the device
    pmount "$@" $LABEL

You will now be able to mount device nodes to appropriately named
directories in /media, and unmount them as necessary, using the new menu
entries. For convenience, you should probably also change the mount and
unmount commands in Rox's configuration (under "Action Windows") to
"pmount" and "pumount"; this will let you unmount devices via the mount
directory's right-click menu.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ROX&oldid=218557"

Category:

-   Desktop environments
