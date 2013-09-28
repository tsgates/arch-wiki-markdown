PB BU45
=======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Arch Linux in the Packard Bell BU45                                |
|     -   1.1 X.org configuration                                          |
|     -   1.2 Touchpad Configuration                                       |
|     -   1.3 Wifi configuration                                           |
|     -   1.4 Sound                                                        |
|     -   1.5 Vista Partition                                              |
|     -   1.6 Bluetooth                                                    |
|     -   1.7 Web cam                                                      |
|     -   1.8 Card reader and fingerprint reader                           |
|     -   1.9 Hibernation                                                  |
+--------------------------------------------------------------------------+

Arch Linux in the Packard Bell BU45
===================================

I have just bought this laptop from Packard Bell (model PB BU45 O O61).
The configuration of xorg and wifi have been a bit (just a bit)
difficult, so I will be posting here my configuration files and my
experiences. This wiki page is still a work in progress, if somebody is
having problems, just send me an email at yiyu dot jgl at gmail.

X.org configuration
-------------------

If you want to use the screen with its native resolution of 1280x800
(absolutely recommended) you will need the last drivers from intel. The
package you will need is xf86-video-intel, available (atm) from the
testing repositories.

Then, you will have to edit your /etc/X11/xorg.conf file in order to use
this driver. Just edit your line in your Device section which tells
Driver to Driver "intel". This is my xorg.conf file:

    Section "ServerLayout"
           Identifier     "X.org Configured"
           Screen      0  "Screen0" 0 0
           InputDevice    "Mouse0" "CorePointer"
           InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

    Section "Files"
           RgbPath      "/usr/share/X11/rgb"
           ModulePath   "/usr/lib/xorg/modules"
           FontPath     "/usr/share/fonts/misc"
           FontPath     "/usr/share/fonts/100dpi:unscaled"
           FontPath     "/usr/share/fonts/75dpi:unscaled"
           FontPath     "/usr/share/fonts/TTF"
           FontPath     "/usr/share/fonts/Type1"
    EndSection

    Section "Module"
           Load  "extmod"
           Load  "dbe"
           Load  "record"
           Load  "dri"
           Load  "GLcore"
           Load  "glx"
           Load  "xtrap"
           Load  "type1"
           Load  "freetype"
    EndSection

    Section "InputDevice"
           Identifier  "Keyboard0"
           Driver      "kbd"

           Option  "XkbLayout"     "es"
    EndSection

    Section "InputDevice"
           Identifier  "Mouse0"
           Driver      "mouse"
           Option      "Protocol" "auto"
           Option      "Device" "/dev/input/mice"
           Option      "ZAxisMapping" "4 5 6 7"
    EndSection

    Section "Monitor"
           #DisplaySize      260   160     # mm
           Identifier   "Monitor0"
           VendorName   "QDS"
           ModelName    "2e"
    EndSection

    Section "Device"
            ### Available Driver options are:-
            ### Values: <i>: integer, <f>: float, <bool>: "True"/"False",
            ### <string>: "String", <freq>: "<f> Hz/kHz/MHz"
            ### [arg]: arg optional
            #Option     "NoAccel"                  # [<bool>]
            #Option     "SWcursor"                 # [<bool>]
            #Option     "ColorKey"                 # <i>
            #Option     "CacheLines"               # <i>
            #Option     "Dac6Bit"                  # [<bool>]
            #Option     "DRI"                      # [<bool>]
            #Option     "NoDDC"                    # [<bool>]
            #Option     "ShowCache"                # [<bool>]
            #Option     "XvMCSurfaces"             # <i>
            #Option     "PageFlip"                 # [<bool>]
           Identifier  "Card0"
           Driver      "intel"
           VendorName  "Intel Corporation"
           BoardName   "Mobile 945GM/GMS/940GML Express Integrated Graphics Controller"
           BusID       "PCI:0:2:0"
    EndSection

    Section "Screen"
           Identifier "Screen0"
           Device     "Card0"
           Monitor    "Monitor0"
           SubSection "Display"
                   Viewport   0 0
                   Depth     1
                   Modes   "1280x800"
           EndSubSection
           SubSection "Display"
                   Viewport   0 0
                   Depth     4
                   Modes   "1280x800"
           EndSubSection
           SubSection "Display"
                   Viewport   0 0
                   Depth     8
                   Modes   "1280x800"
           EndSubSection
           SubSection "Display"
                   Viewport   0 0
                   Depth     15
                   Modes   "1280x800"
           EndSubSection
           SubSection "Display"t
                   Viewport   0 0
                   Depth     16
                   Modes   "1280x800"
           EndSubSection
           SubSection "Display"
                   Viewport   0 0
                   Depth     24
                   Modes   "1280x800"
           EndSubSection
    EndSection

Be careful, because this file also sets my keyboard layout to Spanish.
You probably won't need that line.

You can also activate scrolling with the touchpad installing the
synaptics package and following the instructions in Touchpad Synaptics.
Don't forget to read the messages when you install the package

Now, I would like to configure twin view to attach an external monitor
to the laptop. It shouldn't be difficult, but I haven't tested it yet
because I do not have physical space for the screen in my desktop (real
life wood desktop).

Touchpad Configuration
----------------------

Since this is a small touchpad, I prefer two finger scrolling ("a la"
Macintosh), instead of the edge scrolling. This section covers that.

First of all:

    sudo pacman -S synaptics

Then you can do:

    man synaptics

And see all the options this amazing driver offers. Moving along, you'll
have to edit your /etc/X11/xorg.conf file:

     (...)
    Section "InputDevice"
    Driver          "synaptics"
    Identifier      "Mouse0"
    Option  "Device"        "/dev/psaux"
    Option  "Protocol"      "auto-dev"
    Option  "LeftEdge"      "1800"
    Option  "RightEdge"     "5000"
    Option  "TopEdge"       "1600"
    Option  "BottomEdge"    "4900"
    Option  "FingerLow"     "25"
    Option  "FingerHigh"    "30"
    Option  "FingerPress" "250"
    Option  "MaxTapTime"    "130"
    Option  "MaxTapMove"    "150"
    Option  "VertScrollDelta" "300"
    Option  "VertEdgeScroll"        "false"
    Option	"HorizEdgeScroll"	"false"
    Option  "VertTwoFingerScroll"   "true"
    Option  "MinSpeed"      "0.06"
    Option  "MaxSpeed"      "0.12"
    Option  "AccelFactor" "0.0010"
    Option  "SHMConfig"     "on"
    Option  "EdgeMotionUseAlways" "false"
    EndSection
     (...)

This configuration is what worked best for me, but you can disable
VertTwoFingerScroll, and change the EdgeScrolls to "true". Be aware that
to enable edge scrolling, maybe you have to change your RightEdge and
BottomEdge values.

Using this driver, you won't be able to plug in an external USB mouse
and use it right away. Not in Arch anyway.Thsi is what I did:

in /etc/X11/xorg.conf:

    Section "InputDevice"
    Identifier  "Mouse1"
    Driver      "mouse"
    Option	    "Protocol" 	"IMPS/2"
    Option	    "Device" "/dev/psaux"
    Option	    "ZAxisMapping" "4 5 6 7"
    EndSection

and add this to the ServerLayout section:

  

    Section "ServerLayout"
    Identifier     "X.org Configured"
    Screen      0  "Screen0" 0 0
    InputDevice    "Mouse0" "CorePointer"
    InputDevice	"Mouse1"	"SendCoreEvents"  ##THIS
    InputDevice    "Keyboard0" "CoreKeyboard"
    Option "AIGLX"	"true"
    EndSection

  

And that's it!! Enjoy =)

This section was written by Raul Silva. Any question/remarks, contact
raul_nds in the Arch Forums.

Wifi configuration
------------------

The wireless card included in this laptop is an Intel® Pro WLAN 3945
Internal Wireless (802.11a/b/g 54 Mbps). I think you can use the ipw
drivers, but they will be deprecated in favour of new iwl drivers, so we
will be using the last ones. You will need iwlwifi and
iwlwifi-3945-ucode packages.

The configuration is standard, as with any other wlan (I will try to
document it more extensively in the future, but you can find good
general instructions in the wiki) except that the drivers gives some
problems if you do not pass the disable_hw_scan=1 option to the module
when you load it into the kernel. To not have to do it manually each
time, add this to your /etc/modprobe.d/modprobe.conf:

    options iwl3945 disable_hw_scan=1

I do not know why you have to do it, neither what are its consequences,
but it wasn't working and I found (I think in ubuntu forums or perhaps
in some mailing list) that this little trick solves the problem.

To test your wireless connection you can use the instructions found on
HOWTO-iwlwifi.

Sound
-----

Sound works with alsa, so just check ALSA 's wiki page. The multimedia
buttons (for volume) do not seem to work though. Even if they did, with
alsa, the primary control is always the headphone's, but the one that
matters is the Front control. Annoying bug.

Vista Partition
---------------

If your laptop, like mine, was sold with Vista on an ntfs partition and
you haven't completly get rid of it probably you will want to access to
the data on that partition. The ntfs-3g driver works perfectly, just
follow the instructions in NTFS Write Support.

Bluetooth
---------

Bluetooth is working, just add dbus and {{Ic|bluetooth</th> to your
daemons section in rc.conf (You will need to install the packages
bluez-utils, bluez-libs and dbus with pacman). Then you can find devices
with hcitool. I'm using it to connect to my mobile phone with obexfs. I
created an entry in /etc/fstab to mount it with a simple
mount /mnt/mobile. This is my modified /etc/fstab (it also includes the
entry to mount the vista partition as a normal user):

    none                   /dev/pts      devpts    defaults            0      0
    none                   /dev/shm      tmpfs     defaults            0      0
    /dev/cdrom /mnt/cdrom   iso9660   ro,user,noauto,unhide   0      0
    /dev/dvd /mnt/dvd   udf   ro,user,noauto,unhide   0      0
    /dev/sda3 / ext3 defaults 0 1
    /dev/sda4 swap swap defaults 0 0
    /dev/sda2 /mnt/vista ntfs-3g users,uid=1000,gid=100,fmask=0113,dmask=002,locale=es_ES.utf8 0 0
    obexfs#-bxx-xx-xx-xx-xx-xx\040-Bx /mnt/mobile fuse user,fsname=obexfs#-bxx-xx-xx-xx-xx-xx 0 0

You will have to change the xx to the values you will see for your
device with hcitool. The obexftp faq was very helpful to get it working.

Web cam
-------

It works perfectly with the driver available in aur for syntek webcams:
stk11xx

Card reader and fingerprint reader
----------------------------------

I have read they do not work under Linux, though haven't looked into it
yet. I just know the card reader is from Genesys and the fingerprint
reader is an AuthenTec Inc AES1610 (its web page tells it is supported
under Linux. Any help would be appreciated.

Hibernation
-----------

If you want, you can hibernate and resume your system with the help of
the kernel26suspend2 kernel. I just followed the steps in the wiki page,
and then found my system was hanging during the hibernation. I solved
the problems adding this two options to the kernel parameter in
/boot/grub/menu.lst : highres=off nohz=off

I found this solution in a forum and do not know why it wasn't working
or why it works now. Some help would be welcomed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PB_BU45&oldid=225296"

Category:

-   Laptops
