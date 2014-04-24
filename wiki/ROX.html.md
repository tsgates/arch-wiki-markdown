ROX
===

Related articles

-   Desktop environment
-   Display manager
-   Window manager

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Usage            
                           instructions as a        
                           desktop manager do not   
                           work. (Discuss)          
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Unclear          
                           instructions (e.g. file  
                           to edit for incorrect    
                           use to manage desktop is 
                           not explicitly stated.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

From the project home page:

ROX is a fast, user friendly desktop which makes extensive use of
drag-and-drop. The interface revolves around the file manager, or filer,
following the traditional Unix view that 'everything is a file' rather
than trying to hide the filesystem beneath start menus, wizards, or
druids. The aim is to make a system that is well designed and clearly
presented. The ROX style favors using several small programs together
instead of creating all-in-one mega-applications.

ROX is an attempt to bring some of the good features from RISC OS to
Unix and Linux. This article covers its installation, configuration, and
troubleshooting.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 File manager
    -   2.2 Desktop environment
    -   2.3 Mounting with static mountpoints
    -   2.4 Mounting with pmount

Installation
------------

ROX can be installed with the package rox, available in the official
repositories.

Alternatively, you can install it through zeroinstall-injector - see
http://www.0install.net/injector-using.html.

Usage
-----

> File manager

To execute ROX, simply type:

    $ rox

> Desktop environment

You need to run ROX before your window manager. Here is an example line,
using Openbox as the WM:

    rox -b Default -p default; exec openbox

> Mounting with static mountpoints

Rox supports mounting and unmounting devices in /etc/fstab, simply by
clicking on the mount directory. For instance, you can create a
directory /mnt/cdrom, and set up an fstab entry like so:

    /dev/sr0 /mnt/cdrom auto noauto,user,ro 0 0

Clicking on /mnt/cdrom will now automatically mount whatever data disk
is in your first CD drive.

> Mounting with pmount

Static mountpoints in fstab are obviously somewhat inflexible; mounting
two USB sticks at once, for instance, would require fstab entries for
both USB sticks. Fortunately, ROX lets you create custom right-click
menu entries for files, including device nodes in /dev. Thus, you can
use custom menu entries that invoke the pmount and pumount commands to
mount and unmount drives.

To do this, install the pmount package, then open up /dev in ROX and
right-click on a block device node (e.g. /dev/sr0). Enter the file menu
and click on Customize Menu. A window will appear in which you can
create files that will invoke the necessary commands. Create, and then
make executable, the following files:

    mount.sh

    #!/bin/sh
    pmount "$@"

    umount.sh

    #!/bin/sh
    pumount "$@"

If you want your mount directories to use device labels or UUID use this
mount script instead:

    mount.sh

    #!/bin/bash

    #Get device label using blkid
    blkid -o value -s LABEL "$@" > /tmp/roxmount.tmp.$$
    LABEL=$(cat /tmp/roxmount.tmp.$$)

    #Use UUID if no label is set
    if [ -z $LABEL ]; then
        blkid -o value -s UUID "$@" > /tmp/roxmount.tmp.$$
        LABEL=$(cat /tmp/roxmount.tmp.$$)
    fi

    #Ask for mount name if no LABEL/UUID is found (NEEDS xdialog package installed)
    if [ -z $LABEL ]; then
        Xdialog --title "Input Parameters" --inputbox "Enter a mount name" 0 0 2> /tmp/roxmount.tmp.$$
        LABEL=$(cat /tmp/roxmount.tmp.$$)
    fi

    #Mount the device
    pmount "$@" $LABEL

You will now be able to mount device nodes to appropriately named
directories in /media, and unmount them as necessary, using the new menu
entries. For convenience, you should probably also change the mount and
unmount commands in ROX's configuration (under Action Windows) to pmount
and pumount; this will let you unmount devices via the mount directory's
right-click menu.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ROX&oldid=301286"

Category:

-   Desktop environments

-   This page was last modified on 24 February 2014, at 11:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
