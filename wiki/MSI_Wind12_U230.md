MSI Wind12 U230
===============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

MSI Wind12 U230
===============

Introduction
------------

This wiki will guide you through configuration of the MSI Wind12 U230.
If you are going to install Arch on this netbook you should be aware
that ATI Radeon HD (xf86-video-radeonhd) will NOT work. If you install
everything as the Beginner's Guide indicates, you'll get this error:

    A Hyper Tarnsport sync flood error occurred on last boot.

Install
-------

Everything should be done as indicated in Beginner's Guide up to the
point of installing Xorg (Beginner's Guide#Step 2: Install X). At this
point you'll have to install xf86-video-ati and Xorg files.

    #pacman -S xf86-video-ati libgl ati-dri xorg

Once it is installed, enable KMS for ATI as indicated on ATI#Kernel mode
setting.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MSI_Wind12_U230&oldid=196712"

Category:

-   MSI
