Realtek ALC892
==============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

How to get Realtek ALC892 HD Audio working:

Verify Codec
------------

First, ensure you in fact have the right kind of hda-intel card

    # cat /proc/asound/card*/codec* | grep Codec

Should produce a similar output to:

    Codec: Realtek ALC892

Install AUR Package
-------------------

From AUR, install alsa-driver.hda-intel.hda-codec-realtek

Reinstall Kernel
----------------

For some reason, the AUR package seems to eliminate some of the kernel
modules such as snd-usb-audio. To get the old modules back, simply
reinstall the kernel by running the command:

    # pacman -S linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Realtek_ALC892&oldid=252487"

Category:

-   Sound
