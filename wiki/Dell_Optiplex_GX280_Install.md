Dell Optiplex GX280 Install
===========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This model Dell computer does not have any PS/2 ports, and it comes with
a SATA hard-drive. This has caused some difficulty with installing Arch
Linux on it.

The main reason for the difficulty is that it does not have any sort of
USB legacy keyboard support.

When I figure out how to get Arch Linux installed on this bad boy, I'll
put some instructions here.

If anyone has some pointers on how to get this done, please add them.
Sucks having to use Windows XP on it.

* * * * *

Update
======

I managed to get Arch Linux on this system by installing an (additional)
IDE drive on the system that already had Arch Linux installed on it.
Once it is all installed, and the USB module is installed, Arch works
fine on this system, even with a USB keyboard. Have had no problems with
any of the hardware, including the SATA drive, which I managed to resize
the existing NTFS partition and format the remaining space with EXT3
which is now the /home and /var directories.

Apparently, the next version of the Install CD will have this USB
keyboard problem fixed.

* * * * *

Hyperthreading
==============

I'm not sure if linux takes advantage of hyperthreading, but with it
turned on with this machine, hwd was able to see both processors. I'm
not sure how to tell if it is actually improving things.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Optiplex_GX280_Install&oldid=204824"

Category:

-   Other hardware
