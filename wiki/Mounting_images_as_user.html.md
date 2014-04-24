Mounting images as user
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 fuseiso
    -   2.1 Using it with Nautilus
-   3 MPlayer

Introduction
------------

Normally, when you want to mount an image, you have to become root using
su or sudo. This is quite inconvenient. But luckily there is FUSE
(Filesystem in Userspace).

fuseiso
-------

Using FUSE to mount image files is easy enough. Just install the fuseiso
package.

To mount an image, just type (the mountpoint has to be writable by the
user) :

    fuseiso imagefile mountpoint

To unmount the image, use:

    fusermount -u mountpoint

Note:fuseiso currently supports images of the following types: .iso,
.img, .bin, .mdf, .nrg.

> Using it with Nautilus

Note:The following is based on the scripts taken from here.

For users of GNOME there is an easy way of using fuseiso from the
nautilus-context menu. First you will need the nautilus-actions package,
Then you need to save the following scripts to an folder of your choise
(eg. /usr/bin):

    nautilus-actions-iso-mount.sh

     #!/bin/bash
     
     FILE=$(basename "$1")
     MOUNTPOINT="$HOME/Desktop/$FILE"
     
     fuseiso -p "$1" "$MOUNTPOINT"

    nautilus-actions-iso-umount.sh

     #!/bin/bash
     
     FILE=$(basename "$1")
     MOUNTPOINT="$HOME/Desktop/$FILE"
     
     fusermount -u "$MOUNTPOINT"

and make them executable:

    chmod +x /path_to_scripts/nautilus-actions-iso-*

Now, start nautilus-actions-config (System > Preferences > Nautilus
Actions Configuration).

Add a new action with the following settings:

-   Label: Mount ISO
-   Icon: A symbol of your choice (eg: gtk-cdrom)
-   Path: /path_to_scripts/nautilus-actions-iso-mount.sh
-   Parameters: %F
-   Working directory: %d
-   Basenames: *.iso ; *.nrg ; *.bin ; *.img ; *.mdf (for each add a
    seperated entry)
-   Match case: "must match one of"
-   Mimetypes: */*

With this action you can mount ISO-images to your Desktop. It will
create an folder in ~/Desktop with the name of the iso. fuseiso will
mount the iso to this folder.

And a second one:

-   Label: Unmount ISO
-   Icon: A symbol of your choice (eg: gtk-cdrom)
-   Path: /path_to_scripts/nautilus-actions-iso-umount.sh
-   Parameters: %F
-   Working directory: %d
-   Basenames: *.iso ; *.nrg ; *.bin ; *.img ; *.mdf (for each add a
    seperated entry)
-   Match case: "must match one of"
-   Mimetypes: */*

This second action will unmount the mounted iso and remove the folder
from the desktop.

Sometimes you have to logout to be able to mount any image of the given
types simply by right clicking it in Nautilus and selecting Mount ISO.
To unmount it again, just right click the corresponding folder on your
desktop and select Unmount ISO.

MPlayer
-------

Mplayer can play some images without mounting. Open Mplayer and choose
to open a file. At the bottom change video file to the type of image
that you have and navigate to the image.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mounting_images_as_user&oldid=264514"

Category:

-   File systems

-   This page was last modified on 27 June 2013, at 21:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
