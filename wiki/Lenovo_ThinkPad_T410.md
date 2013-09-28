Lenovo ThinkPad T410
====================

The ThinkPad T410 is a laptop with little to no hardware issues.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Trackpoint                                                         |
| -   2 Fingerprint reader                                                 |
| -   3 Graphics                                                           |
| -   4 Modules                                                            |
+--------------------------------------------------------------------------+

Trackpoint
----------

To make the trackpoint able to scroll while holding down the middle
button, make a xorg configuration file
/etc/X11/xorg.conf.d/20-trackpoint.conf with the following contents:

    Section "InputClass"
    	Identifier	"Trackpoint Wheel Emulation"
    	MatchProduct	"TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
    	MatchDevicePath	"/dev/input/event*"
    	Option		"EmulateWheel"		"true"
    	Option		"EmulateWheelButton"	"2"
    	Option		"Emulate3Buttons"	"false"
    	Option		"XAxisMapping"		"6 7"
    	Option		"YAxisMapping"		"4 5"
    EndSection

Fingerprint reader
------------------

The fingerprint reader works, just follow the setup guide in Fprint.

    Bus 001 Device 004: ID 147e:2016 Upek Biometric Touchchip/Touchstrip Fingerprint Sensor

Graphics
--------

If you happen to have the nvidia graphics card, and you intend to use
the properitary driver (packages called 'nvidia' from extra), you may
have problems to use the fn keys to adjust the brightness of the
backlight. The solution is to make a Xorg configuration file,
/etc/X11/xorg.conf.d/15-nvidia.conf, with the following contents:

    Section "Device"
      Identifier              "Device0"
      Driver                  "nvidia"
      VendorName              "NVIDIA Corporation"
      Option "RegistryDwords" "EnableBrightnessControl=1"
      Option "NoLogo"         "true"
      Option "Coolbits"       "1"
      Option "TripleBuffer"   "True"
      Option "DPMS" "True"
    EndSection

Where the important part is the option:

    Option "RegistryDwords" "EnableBrightnessControl=1"

This at least works for the graphics card:

    01:00.0 VGA compatible controller: NVIDIA Corporation GT218 [NVS 3100M] (rev a2)

Modules
-------

The tp_smapi module is available in the AUR. After installation put the
following in /etc/modules-load.d/thinkpad.conf to load the module on
boot.

    tp_smapi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T410&oldid=235317"

Category:

-   Lenovo
