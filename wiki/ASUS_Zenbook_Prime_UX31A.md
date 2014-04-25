ASUS Zenbook Prime UX31A
========================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: This should only 
                           have information         
                           specific to the          
                           hardware. Other content  
                           should not be duplicated 
                           here. (Discuss)          
  ------------------------ ------------------------ ------------------------

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the ASUS Zenbook UX31A and
UX21A Ultrabooks. Most of it should also hold for UX32VD.

See previous generation ASUS Zenbook UX31E page that has mostly
orthogonal information to those here (may be only partially applicable
to UX31A)

Contents
--------

-   1 Installation
    -   1.1 Boot from USB medium
    -   1.2 Grub2 Installation
-   2 Kernel Parameters
-   3 Function keys
    -   3.1 Screen backlight
        -   3.1.1 Screen backlight workarounds
            -   3.1.1.1 Method 1
            -   3.1.1.2 Method 2
        -   3.1.2 Screen backlight fix
            -   3.1.2.1 Getting the DIDL and CADL offsets
    -   3.2 Keyboard backlight
        -   3.2.1 UPower Script
        -   3.2.2 Automatic Backlight Control
-   4 Solid State Drive
-   5 Touchpad
    -   5.1 Multitouch gestures
    -   5.2 Multi-tap, two-finger scrolling doesn't work
    -   5.3 Multitouch gestures in Gnome 3
    -   5.4 Disable Touchpad While Typing
-   6 HDMI plugged at boot
-   7 Powersave management
-   8 Hardware and Modules
    -   8.1 PCI
    -   8.2 Other Devices and Drivers
        -   8.2.1 mei
        -   8.2.2 rdrand
        -   8.2.3 watchdog
    -   8.3 Problem with ACPI and gpio_ich
    -   8.4 Problem with USB and Laptop_Mode_Tools
-   9 Random kernel panics on boot
-   10 BIOS Version Problems
-   11 See also
-   12 Additional resources

Installation
------------

To install Arch Linux on UX31A, you can follow the official Installation
guide. Since the UX31A uses UEFI and GPT, make sure to also read the
UEFI, GPT and UEFI_Bootloaders pages. It is recommended to use GRUB as a
bootloader. To prepare a UEFI USB device, read
UEFI#Create_UEFI_bootable_USB_from_ISO.

> Boot from USB medium

Press Escape to get into the boot menu. If the USB bootable device is
not listed, enter the configuration menu and directly press F10 to save.
Press Escape again on reboot: This time the USB bootable device should
appear in the menu.

Select 'Boot Arch Linux (x86_64)" and press Enter. The installation
system will be booted and you will end up with a terminal.

> Grub2 Installation

The UX31A should come with an EFI System Partition ("ESP", see
UEFI#Booting_an_OS_using_UEFI). For an Arch-only installation, following
normal install procedure without formatting that partition -- thus using
Windows' bootloader -- will result in a bootable system. However,
partitioning the disk from scratch, creating a new ESP, and installing
Arch will result in a non bootable system, because Grub will not be
added to the UEFI boot option menu (instead, the user will likely be
dropped to the UEFI BIOS). To fix this, after following normal
installation procedure, follow the instructions at
GRUB_EFI_Examples#Z68_Family_and_U47_Family. (UX31A's BIOS has the
"Launch EFI shell from filesystem device" option, so only follow the
instructions for that specific case). You should now be able to boot
into your newly installed system.

Kernel Parameters
-----------------

These kernel parameters offer some speed optimizations and longer
battery life. It is recommended to enable them. To add kernel paramaters
to GRUB2 you have to edit /etc/default/grub and add them to the
GRUB_CMDLINE_LINUX_DEFAULT line.

add_efi_memmap i915.i915_enable_rc6=1 pcie_aspm=force drm.vblankoffdelay=1 i915.semaphores=1

Function keys
-------------

Note: A working keymap means that there is some output in xev when the
key combination is pressed OR that the functionality is built in and
"just works". It does not means that the keymap is linked to the
functionality. For that it is often necessary to add a keyboard shortcut
by the method of your choice or to use a desktop shell with built-in
shortcut support for the keycode in question. For some of the keys the
function operates on a BIOS level and no shortcut is needed.

This table shows the function keys, their intended function, what
keycode (if any) X recognizes and whether the function key operates at
the BIOS level or if it needs a shortcut.

  Keys       Function                      X sees                     shortcut needed
  ---------- ----------------------------- -------------------------- -----------------
  Fn+F1      Sleep                         XF86Sleep                  no
  Fn+F2      Turn off WLAN and Bluetooth   XF86WLAN & XF86Bluetooth   no
  Fn+F3      Dim keyboard backlight        XF86KbdBrightnessDown      yes
  Fn+F4      Brighten keyboard backlight   XF86KbdBrightnessUp        yes
  Fn+F5      Dim LCD backlight             XF86MonBrightnessDown      no
  Fn+F6      Brighten LCD backlight        XF86MonBrightnessUp        no
  Fn+F7      Turn off LCD                  No named key               no
  Fn+F8      Toggle display                XF86Display                yes
  Fn+F9      Toggle touchpad               XF86TouchpadToggle         yes
  Fn+F10     Audio mute/unmute             XF86AudioMute              yes
  Fn+F11     Audio volume down             XF86AudioLowerVolume       yes
  Fn+F12     Audio volume up               XF86AudioRaiseVolume       yes
  Fn+a       Ambient light sensor          No recognized key          N/A
  Fn+c       Switch display profiles       XF86Launch1                yes
  Fn+v       Webcam                        XF86WebCam                 yes
  Fn+space   Switch power profiles         XF86Launch6                yes

> Screen backlight

Note: Since kernel 3.7.3 screen brightness keys are working out of the
box with boot parameter acpi_osi= , so this section is legacy and will
soon be moved

Screen Brightness keymaps (Fn+F5, Fn+F6) does not work. It means the
system does not get any keymap when the key combination is pressed. You
get two options here :

-   try to fix the problem
-   work around the problem and just use a different key combination

The lazy option first:

Screen backlight workarounds

Method 1

Install xorg-xbacklight

You can add some convenient keyboard shortcuts by the method of your
choice.

Method 2

Install asus-screen-brightness from AUR. To allow users to change the
brightness, say:

    # asus-screen-brightness allowusers

If you use initscripts, put this into your /etc/rc.local:

    # echo "asus-screen-brightness allowusers" >> /etc/rc.local

Users of systemd can use the unit file included in the package.

    # systemctl daemon-reload
    # systemctl start asus-screen-brightness.service
    # systemctl enable asus-screen-brightness.service

Adding to .zshrc or .bashrc :

    alias -g "backlight"="/bin/bash /usr/bin/asus-screen-brightness"

allows to easy toggle backlight in terminal :

    $ backlight up
    $ backlight down
    $ backlight max
    $ backlight off
    $ backlight night
    $ backlight 2000
    $ backlight show

And finally, add some convenient keyboard shortcuts by the method of
your choice.

Screen backlight fix

Note: UX31A BIOS 211 IGDM Base Address is 0xDA8A9018, UX31A BIOS 206
UGDM Base Address is 0xDA8CE018 and UX31A BIOS 204 IGDM Base Address is
0xDA8CF018, everything else is the same.

Warning: This is highly experimental. It works for the UX32VD with bios
2.06, no guarantee that it works for different configurations.

First off, this method requires that you know what you are doing
(although there are good tutorials anyway), and needs a little bit
patience. It also requires that you have the hexidecimal dump and undump
package xxd available in the AUR:
https://aur.archlinux.org/packages.php?ID=35311 .

This method is based on a proposed fix posted on
https://bugs.freedesktop.org/show_bug.cgi?id=45452, which apparently
works for the UX31A/UX32VD too. The cause why the brightness buttons
don't work is exactly the same as in the bugreport.

As root, create the file /usr/local/share/backlightfix: This script is
posted here:
https://bbs.archlinux.org/viewtopic.php?pid=1156051#p1156051

    #!/bin/bash                                                                                                                                                                                                                                  
    #                                                                                                                                                                                                                                            
    # Asus UX32VD acpi backlight fix                                                                                                                                                                                                             
    #                                                                                                                                                                                                                                            
    # Copyright(C) 2012 Eugen Dahm <eugen.dahm@gmail.com>.                                                                                                                                                                                       
    #                                                                                                                                                                                                                                            
    # fix is based on a proposed bugfix posted on <[url]https://bugs.freedesktop.org/show_bug.cgi?id=45452[/url]>                                                                                                                                           
    #                                                                                                                                                                                                                                            
    #  This program is free software; you can redistribute it and/or modify                                                                                                                                                                      
    #  it under the terms of the GNU General Public License as published by                                                                                                                                                                      
    #  the Free Software Foundation; either version 2 of the License, or                                                                                                                                                                         
    #  (at your option) any later version.                                                                                                                                                                                                       
    #                                                                                                                                                                                                                                            
    #  This program is distributed in the hope that it will be useful,                                                                                                                                                                           
    #  but WITHOUT ANY WARRANTY; without even the implied warranty of                                                                                                                                                                            
    #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                                                                                                                                             
    #  GNU General Public License for more details.                                                                                                                                                                                              
    #                                                                                                                                                                                                                                            
    #  You should have received a copy of the GNU General Public License                                                                                                                                                                         
    #  along with this program; if not, write to the Free Software                                                                                                                                                                               
    #  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA                                                                                                                                                                 
    #                                                                                                                                                                                                                                              
    # Asus UX32VD acpi backlight fix                                                                                                                                                                                                             
    # Disclaimer!!!! not recommended to use if laptop is not the Asus UX32VD\                                                                                                                                                                    
    # probably works with other models too, but the didl and cadl offset needs to be extracted                                                                                                                                                   
    # from the dsdt                                                                                                                                                                                                                              
    # Tested with bios 2.06                                                                                                                                                                                                                       
    # IGDM_BASE has to be determined for each notebook                                                                                                                                                                                           
    # IGDM is the operation region (\_SB_.PCI0.GFX0.IGDM) containing the CADL/DIDL fields                                                                                                                                                        
    # \aslb is a named field containing the base-address of the IGDM region                                                                                                                                                                      
    # this address depends on the installed ram 
    # how to get the address:                                                          
    # - git clone git://github.com/Bumblebee-Project/acpi_call.git                                                                                                                                                                               
    # - make                                                                                                                                                                                                                                     
    # - load module with insmod or copy to /lib/modules/.... and modprobe                                                                                                                                                                        
    # - echo '\aslb' > /proc/acpi/call                                                                                                                                                                                                           
    # - cat /proc/acpi/call                                                                                                                                                                                                                      
    # - this is the IGDM base address - fill in below                                                                                                                                                                                             
    IGDM_BASE=0xBE8B7018
    DIDL_OFFSET=0x120
    CADL_OFFSET=0x160
    # this basically copies the values of the initialized fields DIDL-DDL8 in the IGDM opregion and initializes CADL-CAL8 with it                                                                                                                
    # CADL-CAL8 are fields, telling the bios that a screen or something is connected (this is a bit speculation - check                                                                                                                          
    # <[url]https://bugs.freedesktop.org/show_bug.cgi?id=45452[/url]> for  more                                                                                                                                                                              
    # if interested, disasselbe the dsdt to understand, why no notifyevent gets thrown, when CADL isn't initialized                                                                                                                              
    # (hint: _Q0E/_Q0F are the backlight methods on the UX32VD)                                                                                                                                                                                  
    dd if=/dev/mem skip=$(( $IGDM_BASE + $DIDL_OFFSET )) count=32 bs=1 | xxd  | xxd -r | dd of=/dev/mem bs=1 seek=$(( $IGDM_BASE + $CADL_OFFSET )) count=32 

This script still needs to be adjusted to your notebook configuration
(it uses a memory address which strongly depends on the amount of
installed system memory.

The exact address can be determined with following steps:

1.  git clone git://github.com/Bumblebee-Project/acpi_call.git
2.  cd acpi_call
3.  make
4.  gzip acpi_call.ko
5.  load module acpi_call.ko.gz with insmod or copy to /lib/modules/....
    and modprobe
6.  echo '\aslb' > /proc/acpi/call
7.  cat /proc/acpi/call
8.  this is the IGDM base address - initialize the IGDM_BASE variable
    with this value in the script

Initialize your bios with this script on boot :

    # echo "/usr/local/share/backlightfix" >> /etc/rc.local

Execute the script and hope the backlight buttons work afterwards. If
they don't you probably have to disasselbe the dsdt for yourself,
because you have to adjust the following 2 variables in the script:

    DIDL_OFFSET=0x120
    CADL_OFFSET=0x160

These are the offsets on the Asus UX32VD bios version 2.06. Try google
to find a tutorial how to disassemble the dsdt.

Getting the DIDL and CADL offsets

Now comes the funny part:

1.  open your disassembled dsdt. The should have the filename dsdt.dsl.
2.  find the operationregion IGBM. It should have a Field statement
    below, and probably looks something like this:

    OperationRegion (IGDM, SystemMemory, ASLB, 0x2000)
                  Field (IGDM, AnyAcc, NoLock, Preserve)
                  {
                      SIGN,   128, 
                      SIZE,   32, 
                      OVER,   32, 
    ...

This specifies some variables in this IGDM field (for me, they look
similar to a c struct, except that you don't need to give the size of
each element in a struct). The numbers are the size for each element in
bit.

You must add those field sizes until you reach the DIDL variable. With
the UX32VD the DIDL offset is easy, because of this statement:

    ..
    Offset (0x120), 
    DIDL,   32,

.. Don't know exactly why they use the Offset statement, since this is
somewhat redundant. It tells you that the following element has the
offset 0x120.

Since I thought it is obvious what this statement does, I didn't bother
to look it up in the dsl language specification. I thought it tells the
bios that the following variable starts with an offset of 0x120 bytes
relative to the previous element, but I was wrong. It basically tells
you/bios that the following variable starts with an offset of 0x120
relative to the beginning of the opregion (in this case its completely
unnecessary).

Now the only thing left is the CADL offset. Add the numbers starting
from DIDL until you reach CADL and add it to your previous offset. This
should be the 2nd needed offset.

After updating both offset variables in the script and executing it
again, the backlight should now work (no guarantee).

> Keyboard backlight

Load the asus-nb-wmi kernel module:

    # modprobe asus-nb-wmi

You'll also want to create the file
/etc/modules-load.d/asus-kbd-backlight.conf with the following content,
to ensure that the module is loaded when the laptop is booted:

    # Enable control of keyboard backlight using asus-kbd-backlight (https://aur.archlinux.org/packages/asus-kbd-backlight/)
    asus-nb-wmi

Next, install asus-kbd-backlight from AUR. To allow users to change the
brightness, say:

    # asus-kbd-backlight allowusers

If you use initscripts, put this into your /etc/rc.local:

    # echo "asus-kbd-backlight allowusers" >> /etc/rc.local

Users of systemd can use the unit file included in the package.

    # systemctl daemon-reload
    # systemctl start asus-kbd-backlight.service
    # systemctl enable asus-kbd-backlight.service

Now you can easily change keyboard backlight in terminal:

    $ asus-kbd-backlight up
    $ asus-kbd-backlight down
    $ asus-kbd-backlight max
    $ asus-kbd-backlight off
    $ asus-kbd-backlight night
    $ asus-kbd-backlight 2
    $ asus-kbd-backlight show

And finally, add some convenient keyboard shortcuts by the method of
your choice.

UPower Script

Upower allows control of the keyboard backlight as an ordinary user. Use
of these scripts requires installation of dbus, upower and if you want
the OSD notifications, libnotify.

This script increases the keyboard brightness and provides onscreen
notification of the current brightness:

    #! /bin/bash
    # get current keyboard brightness from UPower
    current_state=$(dbus-send --type=method_call --print-reply=literal --system \
    --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.GetBrightness)
    # strip leading 9 characters "   int32 "
    current_state=${current_state:9}
    # get maximum keyboard brightness from UPower
    max_brightness=$(dbus-send --type=method_call --print-reply=literal --system \
    --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.GetMaxBrightness)
    # strip leading 9 characters "   int32 "
    max_brightness=${max_brightness:9}
    # if the current keyboard brightness is less than max, increment brightness by one
    if [ $current_state -lt $max_brightness ] ; then 
    dbus-send --type=method_call --print-reply=literal --system \
    --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness \
    int32:$((current_state+1))
    notify-send "Keyboard brightness reset to $((current_state+1))"
    else
    # if the keyboard brightness is already at maximum, complain
    notify-send "Keyboard brightness already at maximum"
    fi

This script decreases the keyboard brightness and provides onscreen
notification of the current brightness:

    #! /bin/bash
    # get current keyboard brightness from UPower
    current_state=$(dbus-send --type=method_call --print-reply=literal --system \
    --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.GetBrightness)
    # strip leading 9 characters "   int32 "
    current_state=${current_state:9}
    min_brightness=0
    # if the current keyboard brightness is greater than zero, decrement brightness by one
    if [ $current_state -gt $min_brightness ] ; then 
    dbus-send --type=method_call --print-reply=literal --system \
    --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness \
    int32:$((current_state-1))
    notify-send "Keyboard brightness reset to $((current_state-1))"
    else
    # if the keyboard brightness is already at zero, complain
    notify-send "Keyboard brightness already at zero"
    fi

Automatic Backlight Control

This C program will automatically turn off the backlight after a given
idle time, and turn it on proportionally to the screen brightness.
Written for Asus N56DP but will probably work here as well. Please email
me if not. Note that you must run it as root, or if using some other
user, give that user write permission to the backlight brightness file.
This program works in plain tty mode as well as in X, but if you're
using X you must start the X server first before starting this program,
otherwise the X server will hang. Hyc (talk) 13:24, 16 January 2013
(UTC)

    /* Author: Howard Chu <hyc@symas.com> 2013-01-15
     *
     * monitor keyboard activity and toggle keyboard backlight
     * for Asus laptops. Tested on Asus N56DP.
     */
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>
    #include <poll.h>

    static char dummybuf[8192];

    /** @brief How many milliseconds before turning off kbd light */
    #ifndef IDLE_MSEC
    #define IDLE_MSEC	7000
    #endif

    int main(int argc, char *argv[])
    {
    	struct pollfd pfd;
    	int rc, blfd, scfd;
    	int brt, timeout, prev = -1;
    	char bm[2] = "0\n";

    	scfd = open("/sys/class/backlight/acpi_video0/brightness", O_RDONLY);
    	blfd = open("/sys/class/leds/asus::kbd_backlight/brightness", O_WRONLY);
    	pfd.fd = open("/dev/input/by-path/platform-i8042-serio-0-event-kbd", O_RDONLY);
    	pfd.events = POLLIN;

    	timeout = IDLE_MSEC;
    	while (1) {
    		rc = poll(&pfd, 1, timeout);
    		/* Kbd brightness ranges from 0 to 3.
    		 * Screen brightness ranges from 1 to 10.
    		 * Make the keyboard brightness
    		 * depend on the screen brightness.
    		 *
    		 * Assume 10 means working in a bright room.
    		 * In that case, leave the kbd light off.
    		 * map screen 1-9 to kbd 1-3.
    		 */
    		if (rc) {
    			/* got keyboard input, flush it all and
    			 * wait for the next event. Also check
    			 * the screen brightness and set the kbd
    			 * backlight accordingly.
    			 */
    			read(pfd.fd, dummybuf, sizeof(dummybuf));
    			timeout = IDLE_MSEC;
    			read(scfd, dummybuf, sizeof(dummybuf));
    			lseek(scfd, 0, SEEK_SET);
    			brt = atoi(dummybuf);
    			if (brt == 10) {
    				brt = 0;
    			} else {
    				brt = (brt + 2) / 3;
    			}
    		} else {
    			/* once we've gotten a timeout, turn off
    			 * kbd backlight and wait forever for
    			 * the next keypress
    			 */
    			timeout = -1;
    			brt = 0;
    		}
    		if (brt == prev)
    			continue;
    		bm[0] = brt + '0';
    		write(blfd, bm, 2);
    		lseek(blfd, 0, SEEK_SET);
    		prev = brt;
    	}
    }

Solid State Drive
-----------------

Check Solid_State_Drives

Touchpad
--------

Instructions to activate the right button. (As an alternative you cant
try This).

Multifinger taps work out of the box.

Tip:Multifinger taps: Two finger for middle click; three fingers for
right click.

> Multitouch gestures

To enable multitouch gestures like those under Windows, one can install
touchegg from the AUR. Using touchegg will require disabling some
input-handling that is done by the synaptics input driver. Edit your
/etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
            Identifier "touchpad catchall"
            Driver "synaptics"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Option "TapButton1" "1"
            Option "TapButton2" "0"
            Option "TapButton3" "0"
            Option "ClickFinger2" "0"
            Option "ClickFinger3" "0"
            Option "HorizTwoFingerScroll" "0"
            Option "VertTwoFingerScroll" "0"
            Option "ClickPad" "true"
            Option "EmulateMidButtonTime" "0"
            Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
    EndSection

An alternative to X.org configuration files is to use the synclient
command within the .xinitrc script. This method will limit changes to
your desktop environment.

     synclient TapButton2=0 TapButton3=0 ClickFinger2=0 ClickFinger3=0 HorizTwoFingerScroll=0 VertTwoFingerScroll=0

touchegg will need to be autostarted for multitouch gestures to be
activated. This can be done with touchegg & in your .xinitrc, or using
the autostart/startup applications functionality of your desktop
environment. ~/.config/touchegg/touchegg.conf can then be configured as
necessary.

> Multi-tap, two-finger scrolling doesn't work

Check "xinput list" and see whether the Elantech touchpad was recognized
as an Elantech Click-pad. If so, brenix's comment in psmouse-elantech
AUR fixed it for me.

> Multitouch gestures in Gnome 3

GNOME 3's gnome-shell does its own mouse-handling, which can interfere
with synaptics and touchegg settings unless the appropriate plugin is
disabled.

     gsettings set org.gnome.settings-daemon.plugins.mouse active false

Note that disabling this plugin will cause the the current settings
within the Mouse & Touchpad section of System Settings to be ignored.

> Disable Touchpad While Typing

One of the criticisms this laptop gets (see reviews at Amazon) is that
the placement of the touchpad results in frequent touchpad brushing
during typing. You should use whatever touchpad disabling method you
prefer. See Touchpad Synaptics#Disable trackpad while typing.

HDMI plugged at boot
--------------------

There seems to be a problem whereby having an HDMI device plugged in at
boot results in the screens being switched and also the laptop screen
not coming on. To make this more bearable you can automate switching
HDMI on with the following udev rule and script:

  

Add the following script as root:

    /usr/local/share/hdmi-plugged-startup

    #!/bin/bash

    export XAUTHORITY=/home/$USER/.Xauthority
    export DISPLAY=:0

    /usr/bin/xrandr -display :0 --output eDP1 --auto --output HDMI1 --auto --above eDP1

then make it executable

    # chmod +x /usr/local/share/hdmi-plugged-startup

And add the following udev rule:

    # echo 'ACTION=="change", SUBSYSTEM=="drm", RUN+="/usr/local/share/hdmi-plugged-startup"' >> /etc/udev/rules.d/10-local.rules

Suspending, unplugging the HDMI cable, and resuming is a way to enable
the Zenbook's screen without rebooting if it was booted with the cable
plugged in.

Powersave management
--------------------

For automatic powersaving when on battery configure Laptop_Mode_Tools.
For manual power saving see Power saving

Hardware and Modules
--------------------

PCI

This is output of lspci -nnn -k:

  Description                                                                              PCI Id       Module
  ---------------------------------------------------------------------------------------- ------------ ---------------
  Intel Corporation 3rd Gen Core processor DRAM Controller                                 8086:0154    none
  Intel Corporation 3rd Gen Core processor Graphics Controller                             8086:0166    i915
  Intel Corporation Device                                                                 8086:0153    none
  Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller           8086:1e31    xhci_hcd
  Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1                  8086:1e3a    mei
  Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2    8086:1e2d    ehci_hcd
  Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller   8086:1e20    snd_hda_intel
  Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1            8086:1e10    pcieport
  Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2            8086:1e12    pcieport
  Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1    8086:1e26    ehci_hcd
  Intel Corporation HM76 Express Chipset LPC Controller                                    8086:1e59    lpc_ich
  Intel Corporation 7 Series Chipset Family 6-port SATA Controller                         8086:1e03    ahci
  Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller                   8086:1e22]   none
  Intel Corporation 7 Series/C210 Series Chipset Family Thermal Management Controller      8086:1e24    none
  Intel Corporation Centrino Advanced-N 6235                                               8086:088e    iwlwifi

Other Devices and Drivers

mei

PCE device 8086:1e3a, the Intel Corporation 7 Series/C210 Series Chipset
Family MEI Controller #1 and the associated device "/dev/mei" (10,59)
relating to an Intel-specific hardware monitoring technology called
"Advanced Management Technology".

The MEI driver speaks to or through the "Local Manageability Service" or
LMS. The LMS driver is available here. Note that with GCC 4.7.2-2, the
driver will refuse to compile. I was able to convince it to compile by:

-   adding "#include <unistd.h>" to src/tools/ATVersion.cpp
-   adding "#include <stdio.h>" to src/tools/ATNetworkTool.cpp

It then installs the driver file lms in /usr/local/sbin and the
init.d-type daemon file lms in /etc/init.d/.

rdrand

The i7 Core CPU has an on-chip random number generator, rdrand, code
named "Bull Mountain". It appears that since 3.2, this is used as a
source for /dev/urandom. It is also used as a randomness source by
rng-tools version 4.

In contrast to other hardware random number generators, rdrand does not
create a character device in /dev. However, rngd version 4 does appear
to detect and use it.

First, make sure rngd sees it:

    [root@asarum system]# rngd -v --no-tpm=1
    Available entropy sources:
       	DRNG

Second, start rngd:

    [root@asarum log]# rngd -f --no-tpm=1

The options for rngd.service are found in /etc/conf.d/rngd. I modified
the file as follows:

    # RNGD_OPTS="-o /dev/random -r /dev/urandom"
    RNGD_OPTS=" -o /dev/random --no-tpm=1"

Test:

    [root@asarum system]# cat /dev/random | rngtest -c 1000
    rngtest 4
    Copyright (c) 2004 by Henrique de Moraes Holschuh
    This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    rngtest: starting FIPS tests...
    rngtest: bits received from input: 20000032
    rngtest: FIPS 140-2 successes: 1000
    rngtest: FIPS 140-2 failures: 0
    rngtest: FIPS 140-2(2001-10-10) Monobit: 0
    rngtest: FIPS 140-2(2001-10-10) Poker: 0
    rngtest: FIPS 140-2(2001-10-10) Runs: 0
    rngtest: FIPS 140-2(2001-10-10) Long run: 0
    rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
    rngtest: input channel speed: (min=891.472; avg=2161.828; max=2788.585)Kibits/s
    rngtest: FIPS tests speed: (min=28.682; avg=47.816; max=146.719)Mibits/s
    rngtest: Program run time: 9434482 microseconds

watchdog

The chipset also has an hardware watchdog:

    root@asarum chris]# wdctl
    Device:        /dev/watchdog
    Identity:      iTCO_wdt [version 0]
    Timeout:       30 seconds
    Timeleft:       2 seconds
    FLAG           DESCRIPTION               STATUS BOOT-STATUS
    KEEPALIVEPING  Keep alive ping reply          0           0
    MAGICCLOSE     Supports magic close char      0           0
    SETTIMEOUT     Set timeout (in seconds)       0           0

Activating the watchdog under systemd is trivial, as systemd author
Lennart Poettering explains in this blog post.

All you do is go into /etc/systemd/system.conf, uncomment the
RuntimeWatchdogSec=0 line and change zero to how long the watchdog
should go without receiving a ping before it reboots the system. I used
30s, which is the default setting for iTCO_wdt and seemed sane.

    #RuntimeWatchdogSec=0
    RuntimeWatchdogSec=30

Check after next boot:

    [root@asarum chris]# journalctl | grep -i watchdog
    Oct 06 06:36:27 asarum kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
    Oct 06 06:36:27 asarum systemd[1]: Hardware watchdog 'iTCO_wdt', version 0
    Oct 06 06:36:27 asarum systemd[1]: Set hardware watchdog to 30s.

Problem with ACPI and gpio_ich

The gpio_ich module causes the following error:

    ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 2 (20120711/utaddress-251)
    ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
    ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts with Region \GP01 2 (20120711/utaddress-251)
    lpc_ich: Resource conflict(s) found affecting gpio_ich
    ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \SMB0 1 (20120711/utaddress-251)
    ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 2 (20120711/utaddress-251)

In this case an lsmod shows that the gpio_ich module doesn't wind up
being loaded

    # lsmod | grep gpio
    # 

I then rebooted with apci_enforce_resources=lax. A cat /proc/ioports
showed the conflict:

         0420-042f : ACPI GPE0_BLK
          0428-042f : gpio_ich

and

         0500-057f : pnp 00:05
           0500-053f : gpio_ich

In contrast, here's the same lines without acpi_enforce_resources=lax:

         0420-042f : ACPI GPE0_BLK

and

         0500-057f : pnp 00:05

So, net/net, there's no real problem.

Problem with USB and Laptop_Mode_Tools

USB mouse problems and hotplug does not working in some cases with
messages in dmesg like:

         xhci_hcd 0000:00:14.0: setting latency timer to 64
         xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with no TDs queued?

The solution is to set "CONTROL_USB_AUTOSUSPEND" in
/etc/laptop-mode/conf.d/usb-autosuspend.conf to 1 and having a long
"AUTOSUSPEND_TIMEOUT"

Random kernel panics on boot
----------------------------

If Archlinux boots without any problems sometimes, but locks up with a
kernel panic other times, the cause (as described by Whef in this
thread: https://bbs.archlinux.org/viewtopic.php?pid=1169781#p1169781) is
likely the 'btusb' module.

To fix the problem, blacklist the 'btusb' module on the next boot by
running:

     sudo echo "blacklist btusb" > /etc/modprobe.d/disable_btusb.conf

Then use rc.local to load it at the end of the boot process by running:

     sudo echo "modprobe btusb" >> /etc/rc.local

This appears to avoid whatever race condition conflict that causes the
kernel to panic on boot, but if you're still having the same problem,
try removing 'modprobe btusb' from /etc/rc.local to avoid the module
completely.

BIOS Version Problems
---------------------

It seems that updating the BIOS to versions 215 and higher causes
problems with ACPI handling of the battery charge levels. In particular
it seems that one cannot charge the battery beyond 91%-93%. The problem
does not seem to be present in Windows however. For further details
please see the forum thread here. The most up to date BIOS version
without any problems is 212. Unless it's absolutely necessary, refrain
from updating your BIOS.

See also
--------

-   Power saving

Additional resources
--------------------

-   https://help.ubuntu.com/community/AsusZenbookPrime
-   http://ubuntuforums.org/showthread.php?t=2005999
-   Wikipedia:Zenbook#UX32.2C_UX42_and_UX52

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Zenbook_Prime_UX31A&oldid=304816"

Category:

-   ASUS

-   This page was last modified on 16 March 2014, at 07:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
