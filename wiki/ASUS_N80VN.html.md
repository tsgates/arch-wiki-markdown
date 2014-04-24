ASUS N80VN
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: ...and the        
                           following statement      
                           seems contraddicted.     
                           Poorly written, by the   
                           way. (Discuss)           
  ------------------------ ------------------------ ------------------------

Works really good under Arch Linux.

Sound card
----------

You must set the right sound card model in modprobe.d in order to make
it work correctly with headphones.

in /etc/modprobe.d/alsa-base:

    options snd-hda-intel model=g71v

No model or position_fix needed. Remove any options snd-hda-intel in
/etc/modprobe.d/modprobe.conf and /etc/modprobe.d/sound if required.

Fingerprint scanner
-------------------

Don't bother using the fingerprint scanner right now, because of buggy
drivers.

Webcam
------

There's a /dev/video0 device present, it gets detected properly.
However, when opening the v4l stream in VLC, it seems to be using an
incompatible codec (YUY2 or something).

Apparently, from the USB ID of the camera, it's a Syntek USB 2.0 UVC PC
Camera ([1]) and should be supported. However, I can't make it work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_N80VN&oldid=259487"

Category:

-   ASUS

-   This page was last modified on 29 May 2013, at 13:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
