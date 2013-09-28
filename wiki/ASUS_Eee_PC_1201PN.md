ASUS Eee PC 1201PN
==================

Other than the noted differences, the settings for the
Asus_Eee_PC_1201NL apply to the 1201PN.

Wireless
--------

The 1201PN uses Atheros 9k drivers. This may not be the case with all
1201PNs, but at the very least, run lspci -v and look for your Network
controller. If it is AR9285 Wireless Network Adapter, you can follow the
instructions at Asus_Eee_PC#Installation. If evdev (it should) is not
detecting your card, you will need to add ath9k to your MODULES array in
rc.conf.

Function Keys/Power Saving
--------------------------

BE CAREFUL with laptop power-mode settings. The default settings will
spin your harddrive down every 20 seconds which is really bad. Read this
thread.

You can follow the instructions as outlined in the directions for the
1201NL to get your function keys working.

The acpi-generic-package scripts in the AUR are not necessary to get
your function keys working. They are hardware agnostic, so they are nice
to get things up and running quickly, but with the exception of the
sleep/suspend scripts (which are useful) everything else can be done
more quickly with a direct keybinding.

Disable the other settings and use your WMs default keybinding manager
(or Xbindkeys) to handle your Wlan/Display/Volume settings.

Xbindkeys Simply bind your keys to the necessary action.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1201PN&oldid=208401"

Category:

-   ASUS
