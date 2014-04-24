MacBook Aluminum
================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with MacBook 5,2 
                           (early-mid 2009).        
                           Notes: same model        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is to provide information on how to get components of
Apple's MacBook5,1 and 5,2 also know as the MacBook Aluminum, or the
unibody Macbook, working in Arch. Please first visit the MacBook page
that should work for these models and provide more detailed information.

Discussion of this in in this thread
https://bbs.archlinux.org/viewtopic.php?pid=444664

Contents
--------

-   1 Installation
-   2 Multi-Touch Trackpad
-   3 Sound
    -   3.1 Gnome Support
-   4 Video
-   5 Wireless
-   6 Suspend/Power Management
-   7 iSight
-   8 Sensors, temperature and fan settings
-   9 Pommed
-   10 Anything else?

Installation
------------

To install, follow the instruction on the MacBook page.

Multi-Touch Trackpad
--------------------

Works partially with kernel 2.6.30. (follow MacBook instructions)

Sound
-----

The Alsa section on Arch wiki covers the sound setup mostly. However to
get speaker output working, edit the following file:

    /etc/modprobe.d/modprobe.conf

And put the following in:

    options snd_hda_intel model=mbp3

or

    options snd_hda_intel model=mb5

(yes, it is mb5, not mbp5).

It appears that alsa fails to correctly detect and setup the soundcard.
This is typical behaviour on some older models aswell.

NOTE: "LINE" is speakers and "PCM" and others control speakers.

> Gnome Support

The system should automatically switch between headphone and speaker
output depending on whether you have plugged anything in the 3.5 mm
jack. Sometimes this is not the case, and the system may default to
headphone output. I am unsure as to why this is the case.

By default Gnome 3 cannot tell the difference between the headphone and
speaker channels. If you are not getting any sound through your
speakers, check if the headphone jack is making sound.

You can change between these channels by installing 'gnome-alsamixer',
and adjusting the "Headphon" and "Front Sp" channels.

Video
-----

Aluminium MacBooks usually have NVIDIA graphics, so you can choose to
use the free & open Nouveau driver or the closed NVIDIA driver. Each
have benefits and drawbacks, however Nouveau is substantially more
straightforward to set up.

Wireless
--------

Follow the instructions in the Broadcom_BCM4312 article and install the
broadcom-wl driver.

Suspend/Power Management
------------------------

Suspend works (tested in GNOME)

iSight
------

Works.

Issue: When using it in Cheese, logs spill out "uvcvideo: unknown event
type 79." (number changes).

Sensors, temperature and fan settings
-------------------------------------

motion sensor: Works out-of-the-box - tested with neverball

an ambient light sensor: How do i test?

For reading temperature just install and configure lm_sensors. See Lm
sensors page.

Controlling the fan speed could be done by installing the package
cmp-daemon in AUR.

Add cmp-daemon to the DAEMONS array in your /etc/rc.conf.

For the daemon to work the applesmc (modprobe -v applesmc) module must
be loaded.

Output can be seen in /var/log/daemons.log

Pommed
------

If you have a macbook pro 5,2 you will notice that pommed will give you
an error when you run it(something about you are using a MBP 5,2
badboy!). To get this to not be the case you have to edit the pommed.c
file and look for MACHINE_MACBOOKPRO (there is many instances) and
sooner or later you will see where they have a if statement that says if
it is a 5,1 or a 5,5 then run this, so there you should copy and paste
5,5 and replace with yep, you guessed it 5,2. I sent a email to the
developers so that they can change that.

A set of scripts which can be used as an alternative to Pommed can be
found here along with a sample Fluxbox keys configuration to use the
scripts.

Anything else?
--------------

If your box is freezing on reboot "restarting..." then just add
"reboot=pci" at the end of your kernel line in menu.lst file.

The SD card slot works automatically like any other removable device.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBook_Aluminum&oldid=263564"

Category:

-   Apple

-   This page was last modified on 20 June 2013, at 07:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
