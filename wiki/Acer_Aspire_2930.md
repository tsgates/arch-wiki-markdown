Acer Aspire 2930
================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Ethernet                                                           |
| -   3 Wireless                                                           |
| -   4 Xorg                                                               |
| -   5 Sound                                                              |
| -   6 Card Reader                                                        |
| -   7 Webcam                                                             |
| -   8 ACPI                                                               |
| -   9 Touchpad                                                           |
+--------------------------------------------------------------------------+

Hardware
--------

Processor: Intel Core 2 Duo T5800 This can vary based on exact model

Video: Intel Corporation GM45 Chipset

Audio: Intel Coporation 82801I HD Audio Controller

Wired NIC: Realtek RTL8111/8168B

Wireless NIC: Intel Corporation Wireless Wifi Link 5100

Ethernet
--------

Should work out of the box

Wireless
--------

Install iwlwifi-5000-ucode

    # pacman -S iwlwifi-5000-ucode

Add iwlagn to your rc.conf

    MODULES=(iwlagn)

Xorg
----

No real difficult getting Xorg running - heres the packages I installed
- should get everything running;

    # pacman -S xorg xf86-input-keyboard xf86-input-mouse synaptics xf86-video-intel

Then auto configure X using your favorite method and you're good to go.

Sound
-----

Pulseaudio did the job admirably for me getting the sound working;

    # pacman -S pulseaudio alsaplugins jack-audio-connection-kit

External speakers will work after configuration, however headphone and
microphone jacks need one additional fix

Simply add

    options snd-hda-intel model=acer position_fix=1 enable=yes

to /etc/modprobe.d/modprobe.conf

Card Reader
-----------

Seemed to work with no additional configuration.

Webcam
------

Worked with no additional configuration.

ACPI
----

Worked with no additional configuration

Touchpad
--------

Works after synaptics is installed - still working on touchpad taps

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_2930&oldid=196464"

Category:

-   Acer
