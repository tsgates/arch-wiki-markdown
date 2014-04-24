Bose speakers
=============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

In order to get ALSA to work with your Bose speakers (after you have
properly configured ALSA):

The trick is to set a new default device for ALSA.

First, run

    $ cat /proc/asound/cards

My sample result:

    0 [Intel          ]: HDA-Intel - HDA Intel  HDA Intel at 0xfdff8000 irq 16
    1 [Audio          ]: USB-Audio - Bose USB Audio Bose Corporation Bose USB Audio at  usb-0000:00:1d.2-2, full speed

Look at /usr/share/alsa/alsa.conf and the find parameters you need to
edit.

    # defaults
    defaults.ctl.card 0
    defaults.pcm.card 0

Change the default number on both values to the number that corresponds
with your card. In my case, this is 1.

Then, select the device in System > Preferences > Sound (for Gnome) and
change Alsa mixer volume settings.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bose_speakers&oldid=206015"

Categories:

-   Sound
-   Audio/Video

-   This page was last modified on 13 June 2012, at 11:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
