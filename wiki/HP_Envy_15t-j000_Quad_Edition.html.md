HP Envy 15t-j000 Quad Edition
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Power Management, 
                           Video Card, NVIDIA       
                           optimus, Mouse, mSATA    
                           SSD cache, more on       
                           installing, fingerprint  
                           reader, camera, sound,   
                           what works/dosen't work  
                           summary,wireless, dual   
                           boot, hard drive         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The HP Envy 15t-j000 Quad Edition is a laptop released in 2013.

> Device

> Status

> Modules

Intel

> Working

xf86-video-intel (on some versions use NVIDIA with bumblebee)

Ethernet

> Working

atl1c

Wireless

> Working

iwlwifi

Audio

> Working

snd_hda_intel

Touchpad

> Working

synaptics

Camera

> Working

Card Reader

> Working

rts5229

Fingerprint Reader

Not Working

Contents
--------

-   1 Installing Arch
-   2 Backlight Issue
-   3 Battery and Power Management
-   4 Mouse and Trackpad
-   5 Graphics, Video Card, and NVIDIA Optimus
-   6 Fingerprint Reader
-   7 Wireless Networking
-   8 Sound
-   9 mSATA SSD Cache
-   10 Dual Boot

Installing Arch
---------------

This laptop has secure boot enabled by default. In order to install Arch
this should be disabled. UFEI should be set to legacy mode.

Backlight Issue
---------------

On some kernels the laptop backlight will not turn on, leaving a black
screen on boot. This can be solved with the following kernel parameter.

     acpi_backlight=vendor

The following kernel parameter will also work, but will disable 3d
acceleration.

     nomodeset

Battery and Power Management
----------------------------

The rated battery life for this laptop is 9hrs and with configuration |
5.5 hrs is usually possible.

Install acpi.

Install thermald

    # systemctl enable thermald.service && systemctl start thermald.service

Install tlp

Configure it as per https://wiki.archlinux.org/index.php/TLP

Install iw

Install smartmontools

Install intel-ucode

    # su -c 'echo "microcode" >> /etc/modules-load.d/microcode.conf'

Install granola

Install cpupower

    # sudo systemctl start cpupower
    # sudo systemctl enable cpupower

Mouse and Trackpad
------------------

The trackpad for this laptop supports a virtual scroll wheel. To enable
it edit /etc/X11/xorg.conf.d/10-evdev.conf

and make sure the following is commented out

    Section "InputClass"
           Identifier "evdev touchpad catchall"
           MatchIsTouchpad "on"
           MatchDevicePath "/dev/input/event*"
           Driver "evdev"
    EndSection

Graphics, Video Card, and NVIDIA Optimus
----------------------------------------

If you have the version of this laptop with an NVIDIA card then you have
an optimus based chipset.

Fingerprint Reader
------------------

This laptop comes with a fingerprint reader but there is no Linux driver
for it.

Wireless Networking
-------------------

Recent kernels contain a driver for this laptop's wireless adapter.

Sound
-----

Sound works out of the box. pulseaudio and pavucontrol may be useful in
configuring audio.

mSATA SSD Cache
---------------

This laptop has a mSATA bay that can include a cache hard drive. This
mSATA can be used as a primary hard drive with some configuration.

Dual Boot
---------

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Envy_15t-j000_Quad_Edition&oldid=306129"

Category:

-   HP

-   This page was last modified on 20 March 2014, at 17:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
