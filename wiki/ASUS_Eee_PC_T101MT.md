ASUS Eee PC T101MT
==================

  --------------- ------------- ----------------
  Device          Status        Information
  Graphics        Working       Intel GMA 3150
  Ethernet        Working       
  Wireless        Working       
  Audio           Working       
  Camera          Working       3.0.0
  Card Reader     Working       
  Function Keys   Working       
  Suspend2RAM     Working       
  Hibernate       Not working   
  Touchscreen     Working       3.0.0
  Multi-Touch     Working       
  --------------- ------------- ----------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Arch                                                    |
|     -   1.1 Following the Beginners Guide                                |
|     -   1.2 Camera                                                       |
|     -   1.3 Function Keys                                                |
|     -   1.4 Installing OpenBox                                           |
|                                                                          |
| -   2 Rotating the touch screen                                          |
|     -   2.1 Xbindkeys                                                    |
|     -   2.2 On Screen Keyboard                                           |
|     -   2.3 Suspend2RAM                                                  |
|     -   2.4 Hibernate                                                    |
|     -   2.5 Multi-Touch                                                  |
|                                                                          |
| -   3 Brightness                                                         |
| -   4 Hardware                                                           |
| -   5 More Resources                                                     |
+--------------------------------------------------------------------------+

Installing Arch
---------------

This wiki page supplements these pages: Beginners Guide, the Official
Install Guide, and Installing Arch Linux on the Asus EEE PC. Please
refer to those guides first before following the eeepc-specific pointers
on this page.

> Following the Beginners Guide

Graphics, Ethernet, Wireless, Audio and the Card Reader work "out of the
box".

> Camera

Is working fine with Ekiga

If Skype displays the image upside-down  
 to fix this use command:

for x86_x64

    LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so skype

for i686

    LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype

To make this happen automatically just create a script named skyp (or
anything you want it to be)

    #!/bin/bash

    #get the architecture of the system
    arch=`uname -m`

    #corrects upside down webcam in skype
    case $arch in
         x86_64)
           LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so skype;
           ;;
         i686)
           LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype;
           ;;
    esac

Save this script as "skyp" and '#chmod +x skyp'. Move this script to
'/usr/bin/' with '#mv skyp /usr/bin/'. From now on typing in skyp should
load skype with the proper webcam orientation.

> Function Keys

Suspend-, Brightness- and Audiokeys work. Others may need special
configuration. My Suspendkey was executing the suspend from KDE and from
the acpi Interface. I disabled the KDE event, and now Suspend works.

In openbox, editting ~/.config/rc.xml and appending (under <keyboard>);
this was taken from https://wiki.archlinux.org/index.php/Openbox:

       <!-- Keybindings for audio control -->
       <keybind key="XF86AudioRaiseVolume">
         <action name="Execute">
           <command>amixer set Master 5%+ unmute</command>
         </action>
       </keybind>
       <keybind key="XF86AudioLowerVolume">
         <action name="Execute">
           <command>amixer set Master 5%- unmute</command>
         </action>
       </keybind>
       <keybind key="XF86AudioMute">
         <action name="Execute">
           <command>amixer set Master toggle</command>
         </action>
       </keybind>

will make the audio keys work if alsa is installed.

> Installing OpenBox

OpenBox can be installed by issuing #pacman -S openbox. Follow the
instructions on screen to copy the openbox scripts to
'~/.config/openbox/'.

Rotating the touch screen
-------------------------

Editing the openbox rc.xml file in '~/.config/openbox/rc.xml' will allow
configuration of the Express Gate button. Open a terminal and run $xev
(non-root) to find out the key associated with the Express Gate button
(just click it while in xev). For my system it was key 248 (0xF8) in
hexadecimal. Edit your ~/.config/openbox/rc.xml to include the following
code under <keyboard>:

       <!-- Keybindings for express gate button --> 
       <keybind key="0xF8">
           <action name="ShowMenu">
             <menu>root-menu</menu>
            </action>
        </keybind>

This will bind the express gate key to show the openbox menu whenever
clicked.

To rotate the screen, use the following script (note the following
script can also be bound to the expressgate button itself to generate
rotations (bypass any menu):

-   -   As of evdev 2.7.3-1, this script no longer properly rotates the
        touchscreen axes.

    #!/bin/bash

    ## script to rotate touch screens
    ## will include support for rotating specific monitors

    ###############################################
    #					      #
    #	 Touch_rotate for Asus T101mt	      #
    #             written by Mark Lee             #
    #					      #
    ###############################################

    function main () {  ## main insertion function
    args=("$@");  ## store the arguments in an array
    check-arg;  ## read and check the arguments
    resolve-rotate;  ## resolve the rotation
    rotate-screen;  ## rotate the screen
    }

    function help-man () {  ## print the help manual
    echo "
     where options are:
      [usage]: touch_rotate [options]
      
      -r or -rotate             | rotate the screen; ex. -r right
                                |   <left,right,normal,upside-down>
      -c or -counter-clockwise  | rotate the screen counter clockwise
      -m or -monitor            | set the monitor to rotate; ex. -m native
                                |  <primary,external>
      -i or -id                 | set the id of the touch screen device
      --help                    | print this help screen

      Examples:
         touch_rotate -m native -r right

      Press "Ctrl-C" to exit any time
    "
    }

    function check-arg () {  ## read and check console arguments
    for ((i = 0; i <= ${#args}; i++)); do  ## loop for all arguments passed
      case ${args[$i]} in  ## parse each argument
        -c|-C|-counter-clockwise)
           counter="yes";  ## toggle to rotate counter clockwise
           ;;       
        -r|-R|-rotate|-Rotate)
           rot="${args[$[i + 1]]}";  ## set the new rotation
           ;;
        -m|-M|-monitor|-Monitor)
          mon="${args[$[i + 1]]}";  ## set the monitor to control
          ;;
        -i|-I|-id)
          id="$id";  ## set the id of the device
          ;;
        -help|--help|/?)  ## help menu
          help-man;  ## print the help menu
          exit;  ## exit the script
          ;;
        -*)  ## for all other options
          echo "Unrecognized option: ${args[$i]}"
          help-man;  ## print the help menu
          ;;
      esac;
    done;
    if [ -z "$mon" ]; then  ## check if monitor was specified
       mon="primary";  ## set the monitor to be the primary monitor
    fi;
    if [ "$mon" == "primary" ]; then
       mon="$(xrandr | awk '$2~/^connected/ {print $1}')";  ## set the monitor to be the connected monitor
    fi;
    if [ "$counter" == "yes" ]; then  ## if user wants to rotate counter clockwise
       rot=$(xrandr -q --verbose | awk "/$mon/ {print \$5}");  ## capture the current rotation
       resolve-rotate;  ## convert the current rotation to an integer
       rot=$[$[int_rot + 1] % 4];  ## increment the rotation by one and divide by four
    fi;
    if [ -z "$rot" ]; then  ## check if a rotation was specified
       echo "Which orientation do you want your display to be?";
       select rot in normal left upside-down right; do  ## print menu of possible rotations
          break;  ## break the loop
       done;
    fi;
    if [ -z "$id" ]; then  ## if the id of the device is not specified
       id=$(xinput -list | awk '/MultiTouch/ {print $6}' | awk -F'=' '{print $2}');  ## get the id of the touch screen
    fi;
    }

    function resolve-rotate () {  ## resolve the touch screen matrix
    case $rot in
      normal|0)
        int_rot=0;
        rot_mat="1 0 0 0 1 0"
        ;;
      left|1)
        int_rot=1;
        rot_mat="0 -1 1 1 0 0"
        ;;
      inverted|upside-down|2)
        int_rot=2;
        rot_mat="-1 0 1 0 -1 1"
        ;;
      right|3)
        int_rot=3;
        rot_mat="0 1 0 -1 0 1"
        ;;
    esac;
    }


    ## touch cursor jumps around when in any other orientation than normal
    function rotate-screen () {  ## rotate the touch screen
    xrandr -o $int_rot;  ## rotate the display screen
    xinput set-float-prop $id "Coordinate Transformation Matrix" $rot_mat 0 0 1;  ## rotate the touch screen
    }

    main $@;  ## call the main function and pass console arguments

Edit '~/.config/openbox/menu.xml' to include the following code:

    		<menu id="root-menu-773645" label="Rotate Screen">
    			<item label="Normal">
    				<action name="Execute">
    					<execute>
    						touch_rotate normal
    					</execute>
    				</action>
    			</item>
    			<item label="Right">
    				<action name="Execute">
    					<execute>
    						touch_rotate right
    					</execute>
    				</action>
    			</item>
    			<item label="Upside Down">
    				<action name="Execute">
    					<execute>
    						touch_rotate upside-down
    					</execute>
    				</action>
    			</item>
    			<item label="Left">
    				<action name="Execute">
    					<execute>
    						touch_rotate left
    					</execute>
    				</action>
    			</item>

You can edit the position of this piece of code (if you know XML) or
just add it in somewhere before the last line '</openbox_menu>' of the
script. Change the position by using obmenu (GUI interface for editing
openbox menu).

> Xbindkeys

Install xbindkeys with pacman -S xbindkeys and
runxbindkeys --default >~/.xbindkeysrc. Press the express gate button to
determine the key code. Copy the resultant output to xbindkeysrc. Change
"No command" to "touch_rotate".

Launch xbindkeys in gnome3 via gnome-session-properties. Add it as a
launcher app (xbindkeys).

> On Screen Keyboard

Install kvkbd with from the Arch user repository (if using packer :
packer -S kvkbd). Make sure you have some sort of system tray (I used
tint2) and edit '~/.config/openbox/autostart' to include the following
statement:

    kvkbd &

This will start up kvkbd everytime openbox starts up. Once kvkbd is
started up it will appear in the system tray, simply clicking the icon
in the tray will pop out the virtual keyboard.

> Suspend2RAM

Touchscreen is not working afterwards.

It will work after you reload hid_multitouch kernel module:

    # rmmod hid_multitouch
    # modprobe hid_multitouch

As a workaround, you can add the following line to the file
'/etc/pm/config.d/modules':

    SUSPEND_MODULES="hid_multitouch"

This way the kernel module will be explicitly unloaded before suspend.

If you are using twofing you also need to restart it:

    $ killall twofing
    $ twofing --wait

This instruction may be useful for solving this problem

> Hibernate

Not Working.

> Multi-Touch

Modern kernels out-of-the-box support multitouch in our devises, but not
Xorg. In Ubuntu there is some Xorg patches for a multitouch support and
utouch (ginn) for multitouch gestures, but in other linux distributives
you can use twofing. You can find utouch packages in AUR, but they are
untested on our device.

But you can use twofing experimental daemon to use some gestures.

While we are waiting someone to build AUR packages, we can install it
from sources. Get the latest git version here.

After this, you must fix /etc/udev/rules.d/70-touchscreen-egalax.rules
file. Replace custom touchscreen code rule to following:

    SUBSYSTEMS=="usb",ACTION=="add",KERNEL=="event*",ATTRS{idProduct}=="0186",SYMLINK+="twofingtouch",RUN+="/bin/chmod a+r /dev/twofingtouch"

Replace idProduct variable to idProduct of latest model touchscreen ID.
To to check it, try this

    lsusb | grep "ASUS Comp"

Then, create symlink to touchscreen device:

    ln -s /dev/input/mouse1 /dev/twofingtouch

Add 'twofing --wait' command to start with user session. You can read
more about it here. It works on all linux distributives with actual
hid_multitouch module.

Brightness
----------

With some Eee PC's, the brightness setting are either too low, or are
sometimes a little inconstant or arbitrary (cycling high/low/completely
off). If you have issues with this, issue this command to fix it:

And regenerate the grub2 file:

    # setpci -s 00:02.0 f4.b=80

The 80 represents the highest brightness level in hexadecimal, which can
be replaced with up to FF if desired. 80 is about half, being
approximately the same brightness range as windows or grub.

This is not perminent, so it can be added to rc.local:

    /etc/rc.d/rc.local

    #!/bin/sh

    ...

    setpci -s 00:02.0 f4.b=80

Hardware
--------

For N450 versions:

    $ lspci
    00:00.0 Host bridge: Intel Corporation Pineview DMI Bridge
    00:02.0 VGA compatible controller: Intel Corporation Pineview Integrated Graphics Controller
    00:02.1 Display controller: Intel Corporation Pineview Integrated Graphics Controller
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation Tigerpoint LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 02)
    01:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

For N570 versions:

    00:00.0 Host bridge: Intel Corporation N10 Family DMI Bridge (rev 02)
    00:02.0 VGA compatible controller: Intel Corporation N10 Family Integrated Graphics Controller (rev 02)
    00:02.1 Display controller: Intel Corporation N10 Family Integrated Graphics Controller (rev 02)
    00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA AHCI Controller (rev 02)
    01:00.0 Ethernet controller: Atheros Communications AR8132 Fast Ethernet (rev c0)
    02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

More Resources
--------------

-   Asus Eee PC General Guide for EEE PCs on Arch
-   Ubuntu T101MT Howto

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_T101MT&oldid=244946"

Category:

-   ASUS
