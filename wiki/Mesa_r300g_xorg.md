Mesa r300g xorg
===============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There is a xorg state tracker for gallium. This means that you do not
need an xf86-video-* driver when you are using the xorg state tracker.
This is an experimental feature so there could be problems when using
this.

There is a package on aur which builds mesa with the needed state
tracker for cards supported by r300g: mesa-r300g-xorg

You need to remove at least xf86-video-ati and all the mesa packages
before installing the package.

Please add the following line to your xorg.conf in the "Device" Section:

     Section "Device"
       ...
       Option          "2DAccel"               "TRUE"
     EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mesa_r300g_xorg&oldid=196296"

Category:

-   Graphics
