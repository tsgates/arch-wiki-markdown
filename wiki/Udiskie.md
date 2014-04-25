Udiskie
=======

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with File        
                           manager                  
                           functionality#Udiskie.   
                           Notes: May be too short  
                           for a separate article.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

udiskie is an automatic disk mounting service using udisks. It can be
used for mounting CDs, flash drives, and other media. It is simple to
use and requires no configuration.

Installation
------------

You can install udiskie by using the udiskie package that is found in
the official repositories. Start the udiskie service by adding:

    udiskie --tray &

to your xinitrc file, before the window manager is loaded. The tray icon
is optional and requires the pygtk package to be installed. If you want
to use experimental support for udisks2, start the udiskie service with:

    udiskie -2 --tray &

Once udiskie is running, all removable media will automatically be
mounted under /media under a new directory that matches the device name.

Unmounting
----------

Use the udiskie-umount command to unmount media. For example, for a
device named "MY_USB_DRIVE":

     udiskie-umount /media/MY_USB_DRIVE

Or, you can unmount all media with the command:

     udiskie-umount -a

Retrieved from
"https://wiki.archlinux.org/index.php?title=Udiskie&oldid=304096"

Category:

-   Hardware detection and troubleshooting

-   This page was last modified on 12 March 2014, at 06:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
