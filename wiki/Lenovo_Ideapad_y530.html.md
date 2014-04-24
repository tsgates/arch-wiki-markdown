Lenovo Ideapad y530
===================

Contents
--------

-   1 Making stuff work
    -   1.1 Enabling all speakers
    -   1.2 Workaround for brightness bug
    -   1.3 Switching wifi on/off during work
    -   1.4 Sample xorg.conf

Making stuff work
-----------------

> Enabling all speakers

    echo "options snd_hda_intel model=lenovo-sky" >> /etc/modprobe.d/modprobe.conf

> Workaround for brightness bug

The Lenovo Ideapad Y530 has an unusual implementation of the ACPI
system. A patch to the kernel (2.6.29) is being developed. Until its
release the following workaround should help control the display
brightness beyond the limited ability of the keyboard shortcuts.

To see the list of available options:

        cat /proc/acpi/video/VGA/LCDD/brightness

Replace XX in the following command with the display intensity you
desire.

        echo XX > /proc/acpi/video/VGA/LCDD/brightness

For full brightness:

       echo 65 > /proc/acpi/video/VGA/LCDD/brightness

> Switching wifi on/off during work

Any ideas? Currently you have to reboot to make it work.

> Sample xorg.conf

Remember to tweak your keymap and mouse number of keys.

     Section "ServerLayout"
    	Identifier     "Xorg Configured"
    	Screen      0  "Screen0" 0 0
    	InputDevice    "Keyboard0" "CoreKeyboard"
            InputDevice    "USB Mouse" "SendCoreEvents"
            InputDevice    "touchpad" "CorePointer"
     EndSection
     Section "ServerFlags"
    	Option "AllowMouseOpenFail"  "true"
    	Option "AutoAddDevices" "False"
     EndSection
     Section "Files"
    	ModulePath   "/usr/lib/xorg/modules"
    	FontPath     "/usr/share/fonts/misc:unscaled"
    	FontPath     "/usr/share/fonts/misc"
    	FontPath     "/usr/share/fonts/75dpi:unscaled"
    	FontPath     "/usr/share/fonts/75dpi"
    	FontPath     "/usr/share/fonts/100dpi:unscaled"
    	FontPath     "/usr/share/fonts/100dpi"
    	FontPath     "/usr/share/fonts/PEX"
    	FontPath     "/usr/share/fonts/cyrillic"
    	FontPath     "/usr/share/fonts/Type1"
    	FontPath     "/usr/share/fonts/ttf/western"
    	FontPath     "/usr/share/fonts/ttf/decoratives"
    	FontPath     "/usr/share/fonts/truetype"
    	FontPath     "/usr/share/fonts/truetype/openoffice"
    	FontPath     "/usr/share/fonts/truetype/ttf-bitstream-vera"
    	FontPath     "/usr/share/fonts/latex-ttf-fonts"
    	FontPath     "/usr/share/fonts/defoma/CID"
    	FontPath     "/usr/share/fonts/defoma/TrueType"
     EndSection
     Section "Module"
            Load  "ddc"  # ddc probing of monitor
    	Load  "dbe"
    	Load  "dri"
    	Load  "extmod"
    	Load  "glx"
            Load  "bitmap" # bitmap-fonts
    	Load  "type1"
    	Load  "freetype"
    	Load  "record"
    	Load  "synaptics"
     EndSection
     Section "InputDevice"
    	Identifier  "Keyboard0"
    	Driver      "keyboard"
            Option      "CoreKeyboard"
    	Option "XkbRules" "xorg"
    	Option "XkbModel" "pc105"
    	Option "XkbLayout" "pl"
    	Option "XkbVariant" ""
     EndSection
     Section "InputDevice"
            Identifier      "USB Mouse"
            Driver          "mouse"
            Option          "Device"                "/dev/input/mice"
    	Option		"SendCoreEvents"	"true"
            Option          "Protocol"              "IMPS/2"
            Option          "ZAxisMapping"          "4 5"
            Option          "Buttons"               "5"
     EndSection
     Section "InputDevice"
            Identifier      "touchpad"
            Driver          "synaptics"
    	Option		"SendCoreEvents"	"true"
    	Option      "VertEdgeScroll"    "true"
    	Option      "HorizEdgeScroll"   "true"
    	Option 	    "TapButton1" "1"
    	Option      "MaxTapTime"        "180"
     EndSection
     Section "Monitor"
     	Identifier "Monitor0"
     	Option "DPMS" "true"
     EndSection
     Section "Device"
    	Identifier  "Card0"
    	Driver      "nvidia"
     EndSection
     Section "Screen"
    	Identifier "Screen0"
    	Device     "Card0"
    	Monitor    "Monitor0"
    	DefaultColorDepth 24
    	SubSection "Display"
    		Depth     16
    	EndSubSection
    	SubSection "Display"
    		Depth     24
    	EndSubSection
    	SubSection "Display"
    		Depth     32
    	EndSubSection
     EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_y530&oldid=196678"

Category:

-   Lenovo

-   This page was last modified on 23 April 2012, at 13:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
