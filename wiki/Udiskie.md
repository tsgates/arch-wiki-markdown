Udiskie
=======

Udiskie is an automatic disk mounting service using udisks. It can be
used for mounting CDs, flash drives, and other media. It is simple to
use and requires no configuration.

Installation
------------

You can install Udiskie by using the udiskie package that is found in
the Official Repositories. Start the Udiskie service by adding

    udiskie &

to your xinitrc file, before the window manager is loaded.

Once Udiskie is running, all removable media will automatically be
mounted under /media under a new directory that matches the device name.

Unmounting
----------

Use the udiskie-umount command to unmount media. For example, for a
device named "MY_USB_DRIVE":

     udiskie-umount /media/MY_USB_DRIVE

Or, you can unmount all media with the command:

     udiskie-umount -a

Retrieved from
"https://wiki.archlinux.org/index.php?title=Udiskie&oldid=253852"

Category:

-   Hardware detection and troubleshooting
