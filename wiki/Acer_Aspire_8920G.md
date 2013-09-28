Acer Aspire 8920G
=================

This is my 1st ever wiki and I hope that by writing this it can benefit
another user out there to setup archlinux on their laptop like me. I
should also like to explain that I am a novice in the World of Linux and
so I shall try and pass on as much knowledge as I possibly can. These
are the settings that apply to my machine and my network setup so you
must remember that what works for me will not necessarily work ok for
you. This machine is running 2.6.31-ARCH and all the hardware is ok
other than having to load the wireless driver iwl4965 and nvidia
everything else just worked from the core install.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Standard Hardware                                            |
|                                                                          |
| -   2 System Files and Command Outputs                                   |
|     -   2.1 Command Outputs                                              |
|         -   2.1.1 lsusb                                                  |
|         -   2.1.2 lspci                                                  |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Wireless                                                     |
|     -   3.2 Nvidia Graphics                                              |
|     -   3.3 Window Decorator & Compiz Error                              |
|         -   3.3.1 Disable Compiz and set Gnome to use Metacity           |
|         -   3.3.2 Loading Compiz with gtk-window-decorator               |
|                                                                          |
| -   4 Tips & Tricks                                                      |
|     -   4.1 fstab mounting and offline drives                            |
|     -   4.2 Ok, I've mounted my network shares now my laptop hangs on    |
|         shutdown!                                                        |
|     -   4.3 Saving Power                                                 |
|         -   4.3.1 Cpufreq is our first port of call                      |
|             -   4.3.1.1 Install the components                           |
|             -   4.3.1.2 Now setup the modules and daemons                |
|             -   4.3.1.3 Now configure the files for powersaving          |
|                                                                          |
|         -   4.3.2 Bluetooth                                              |
|             -   4.3.2.1 Verify that it works                             |
|             -   4.3.2.2 Saving power by turning off bluetooth by default |
|                 when the system is logged into the Desktop               |
+--------------------------------------------------------------------------+

Hardware
--------

> Standard Hardware

+--------------------------------------+--------------------------------------+
| Hardware                             | Description                          |
+======================================+======================================+
| Processor                            | Intel(R) Core(TM)2 DuoCPU T8300 @    |
|                                      | 2.40GHz                              |
+--------------------------------------+--------------------------------------+
| System Memory                        | 4GB DDR2 667 MHz                     |
+--------------------------------------+--------------------------------------+
| Graphic Card                         | NVIDIA® GeForce® 9500M GS with up to |
|                                      | 1280 MB of TurboCache™ (512 MB of    |
|                                      | dedicated GDDR2 VRAM, up to 768 MB   |
|                                      | of shared system memory              |
+--------------------------------------+--------------------------------------+
| Display                              | 18.4” Full HD 1920 x 1080            |
|                                      | resolution, high-brightness (300-    |
|                                      | cd/m2) Acer CineCrystal™ TFT LCD,    |
|                                      | two lamps, 8 ms high-def response    |
|                                      | time, 16:9 aspect ratio              |
+--------------------------------------+--------------------------------------+
| Sound Card                           | Intel High Definition Audio          |
|                                      | Controller                           |
+--------------------------------------+--------------------------------------+
| CD/DVD                               | 2X Blu-ray Disc™ Super Multi         |
|                                      | double-layer drive                   |
+--------------------------------------+--------------------------------------+
| Lan                                  | Attansic Technology Corp. Atheros    |
|                                      | AR8121/AR8113/AR8114 PCI-E Ethernet  |
|                                      | Controller                           |
+--------------------------------------+--------------------------------------+
| WLan                                 | Intel® Wireless WiFi Link 4965AGN    |
|                                      | (dual-band quad-mode                 |
|                                      | 802.11a/b/g/Draft-N)                 |
+--------------------------------------+--------------------------------------+
| WPan                                 | Bluetooth® 2.0+EDR (Enhanced Data    |
|                                      | Rate)                                |
+--------------------------------------+--------------------------------------+
| Webcam                               | Acer OrbiCam integrated 1.3          |
|                                      | megapixel                            |
+--------------------------------------+--------------------------------------+
| Touchpad                             | Synaptics PS/2 Port Touchpad         |
+--------------------------------------+--------------------------------------+
| I/O Interface                        | -   1 x ExpressCard™/54 slot         |
|                                      | -   1 x 5-in-one card reader: SD™    |
|                                      |     Card, MultiMediaCard, Memory     |
|                                      |     Stick®, Memory Stick PRO™ or     |
|                                      |     xD-Picture Card™                 |
|                                      | -   4 x USB 2.0 Ports                |
|                                      | -   1 x HDMI™ port with HDCP support |
|                                      | -   1 x Consumer infrared (CIR) port |
|                                      | -   1 x External display (VGA) port  |
|                                      | -   1 x RF-in jack                   |
|                                      | -   1 x Headphone/speaker/line-out   |
|                                      |     jack with S/PDIF support         |
|                                      | -   1 x Microphone-in jack, Line-in  |
|                                      |     jack                             |
|                                      | -   1 x Acer Bio-Protection          |
|                                      |     fingerprint solution             |
|                                      | -   1 x Modem: 56K ITU V.92          |
|                                      | -   1 x RF-in jack                   |
|                                      | -   1 x Acer CineDash media console  |
|                                      |     capacitive human interface       |
|                                      |     device                           |
|                                      | -   1 x 105-/106-key keyboard        |
|                                      |     English                          |
+--------------------------------------+--------------------------------------+
| Printer                              | HP Color OfficeJet 6300              |
+--------------------------------------+--------------------------------------+
| NAS                                  | Buffalo Linkstation Pro 1.5Tb        |
+--------------------------------------+--------------------------------------+

System Files and Command Outputs
--------------------------------

> Command Outputs

lsusb

    $ lsusb

    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 002: ID 138a:0001 DigitalPersona, Inc Fingeprint Reader
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 003: ID 064e:a103 Suyin Corp. 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lspci

    $ lspci

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
    00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 03)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 03)
    00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    01:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 9500M GS] (rev a1)
    02:00.0 Ethernet controller: Attansic Technology Corp. Atheros AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)
    08:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)

Troubleshooting
---------------

These are some of the things I needed to download and the configuration
files that needed modifying in order to configure the machine to behave
as a laptop should... be wireless and consume less power! I assume by
this point that you have already got to the stage of a working desktop
and just need to dot the i's and cross the t's to polish things off.

> Wireless

Works out of the box. See Network Configuration.

> Nvidia Graphics

I assume by now that you have a working desktop and just need to "tweak"
the system for 3-D apps and power management so this is what I changed
in my system.

In the /etc/X11/xorg.conf file I made the following changes to allow
compiz eye candy and power management. The PowerMizer options are set to
lowest performance on battery, with the option of increasing speed if
needed and the system will run at full speed when the mains are plugged
in.  

Make these changes to the Device section

    Section "Device"
       Identifier     "Device0"
       Driver         "nvidia"
       VendorName     "NVIDIA Corporation"
       Option         "AddARGBGLXVisuals" "True"
       Option         "NoLogo" "True"
       Option         "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x1"
    EndSection

> Window Decorator & Compiz Error

I have been using Compiz for effects and Emerald as my window decorator
(minimize, maximise buttons etc) and I have been having an on-going
fault where you login to Gnome and the desktop hangs for a couple of
seconds before continuing the loading process. Well I also broke my
window decorator Emerald over the weekend (24th Oct 2009) with a system
update that stopped Compiz loading up the window decorator Emerald.

Well having googled around the subject a bit and trying the usual
emerald --replace options which had been working until the update I came
across and article that fixed it for me. First I decided that I no
longer wished to use Emerald as my window decorator and to replace that
with gtk-window-decorator instead.

So to "fix" this I set the window decorator that starts when you load
Gnome back to metacity for when you login, then using a script to load
up compiz and the gtk-window-decorator after, which make Gnome load a
few seconds faster in my case!

Disable Compiz and set Gnome to use Metacity

I ran these commands from a terminal to reset Gnome to use Metacity as
the window decorator

    gconftool-2 --set -t string /desktop/gnome/session/required_components/windowmanager metacity
    gconftool-2 --set -t string /desktop/gnome/applications/window_manager/current /usr/bin/metacity
    gconftool-2 --set -t string /desktop/gnome/applications/window_manager/default /usr/bin/metacity

Loading Compiz with gtk-window-decorator

To do this I created an empty file in my home folder called compiz.sh
Then using right click on the file and choosing "permissions" tab I set
the "Allow executing file as program" Now open the file up for editing,
I double-clicked on the file and choose the "Display" option which
opened the file in Gedit. In the empty script file I added the following
code: -

    compiz --replace ccp & gtk-window-decorator --replace &
    exit

Note - Change gtk-window-decorator to emerald if that is your preffered
window decorator

I saved the file and then you need to add it to the "Startup programs"
Go to "System" then "Preferences" then "Startup Applications" and then
click "Add" Under name

    Compiz startup script

Under command, where mark becomes your username!

    /home/mark/compiz.sh

Under Comment

    This script loads Compiz after Gnome loads

Now when you next logon you should find that your desktop loads faster
and your Compiz effects are back to normal.

Tips & Tricks
-------------

Here are some of the hacks that I have made to my system in addition to
the above.

> fstab mounting and offline drives

I found that despite mounting my network drives is fstab and having the
wicd daemon loading that the network shares would not connect at
startup. I think that fstab mounts drives at an early stage and the wicd
daemon has not even loaded yet so they fail and the boot process carries
on. So I found a solution where I run a script just after I logon to
check to see if the drive is online and to connect if it is. I found
that if I tried to mount -a and the NAS box was offline that the mount
command would retry to connect a few times and this would cause the
system to hang until it is finished. So as you will see from the script
it first "pings" the NAS box to see if it is online and only then does
it issue the mount -a command, if it is offline then it just exits.

Since I use gdm to logon to Gnome I discovered that it could run scripts
at certain defined events via PostLogin, PreSession & PostSession. So I
added this script that I found on the internet whilst googling and
changed it a little to suit my needs.

Type this into a console, using su at the start to become root (nano
method)

    su
    <insert root password>
    cd /etc/gdm/PostLogin
    cp Default.Sample Default
    nano Default

in nano add these lines to the bottom of the script...

    # This ping's the NAS box to see if it is online, and if it is then mount
    # the shares.
    # If not then just exit, or the mount command will hang the system for
    # about 20~30 seconds which just plain sucks!
    if [ "$(ping -c 1 192.168.1.2 | grep '0 received')" ]
           then
                    : ; exit 1
           else
                    mount -a
    fi

Now exit nano by using "ctrl-x" and press "y" to save your changes. Then
logout of the terminal as you are still running as root! When you next
login to Gnome it will run the script and mount the drives if the NAS
box is online. Type this into a console

    exit
    exit

...or if running Gnome like me then use gedit as it is much easier on
the eye. Type this into a console, using su at the start to become root
(gedit method)

    su
    <insert root password>
    cd /etc/gdm/PostLogin
    cp Default.Sample Default
    gedit Default

in gedit add these lines to the bottom of the script...

    # This ping's the NAS box to see if it is online, and if it is then mount
    # the shares.
    # If not then just exit, or the mount command will hang the system for
    # about 20~30 seconds which just plain sucks!
    if [ "$(ping -c 1 192.168.1.2 | grep '0 received')" ]
           then
                    : ; exit 1
           else
                    mount -a
    fi

Now exit gedit and save your changes. Then logout of the terminal as you
are still running as root! When you next login to Gnome it will run the
script and mount the drives if the NAS box is online. Type this into a
console

    exit
    exit

> Ok, I've mounted my network shares now my laptop hangs on shutdown!

Sadly there is a bit of a bug with Linux which stretches back to it's
unix roots: The concept of connecting to network drives was not around
it seems and when the shutdown scripts execute it does things in
reverse... so basically one of the consequences is that networking goes
down before the drives have been un-mounted. This causes the system to
hang as it would like to shutdown the shares properly to check to see if
files are open etc but it cannot connect.

So to fix this we need to un-mount the drives at some stage before the
shutdown script gets rolling. I could have added a script to
/etc/gdm/PostSession/Default like above, but it seems silly to un-mount
the drives if I just logged out of Gnome and let someone else login to
use my laptop. So I found a suitable location that works well is
/etc/rc.local.shutdown and added these commands... Type this into a
console

    sudo nano /etc/rc.local.shutdown

in nano add these lines to the bottom of the script...

    # This un-maps my network drives and allows machine to shutdown faster
    umount //media/share
    umount //media/apps
    umount //media/data

Exit out of nano saving changes and voila! The system now shutdown clean
and fast.

> Saving Power

This is an ongoing concern for me... I am working on trying to have the
display dimmer when on battery and full brightness when on mains
adapter. If I get this fixed then it shall appear here. Meanwhile I have
so far been able to save some power with the PowerMizer settings for
nvidia in xorg.conf file above, but is there more? Well yes!

Cpufreq is our first port of call

We need to install acpi and cpufreq, then configure the system for AC
and battery.

Install the components

First you need to install "acpid"

    sudo pacman -S acpid

Then you need to install "cpufrequtils"

    sudo pacman -S cpufrequtils

Now setup the modules and daemons

We need to load the Modules and Daemons into /etc/rc.conf

    sudo nano /etc/rc.conf

In nano makes these changes to rc.conf Changes the bold entries in the
Modules & Daemons section

    MODULES=(acpi-cpufreq cpufreq_ondemand !net-pf-10 !ipv6 !parport !pcspkr loop iwl4965 lp)
    DAEMONS=(@syslog-ng !network @crond @alsa hal fam !netfs wicd @cpufreq @cupsd @openntpd @bluetooth gdm)

Now configure the files for powersaving

We shall first edit the cpufreq files making the changes in bold Type
this into a console

    sudo nano /etc/conf.d/cpufreq

in nano add these lines to the bottom of the script...

    #configuration for cpufreq control

    # valid governors:
    #  ondemand, performance, powersave,
    #  conservative, userspace
    governor="ondemand"

    # valid suffixes: Hz, kHz (default), MHz, GHz, THz
    min_freq="800MHz"
    max_freq="2.4GHz"

Now the "harder" one to do is sort out the power events in acpid as they
do not work out of the box. The problem is that the power event for
plugging in your power adapter is not defined in the script so you need
to add the event to the file. To see what I am talking about bring up a
terminal and type in this command

    sudo tail -f /var/log/messages.log

Now with this terminal open unplug the power adapter or plug it in and
you will see this pop up in the log open on the terminal (use ctrl-c to
exit log) Here is what should pop up

    Oct 22 12:34:27 8920g kernel: Restarting tasks ... done.
    Oct 22 12:34:27 8920g logger: ACPI action undefined: ADP0
    Oct 22 12:34:27 8920g acpid: client connected from 3654[0:0]
    Oct 22 12:34:27 8920g acpid: 1 client rule loaded

The bold entry is the one we are concerned with, this is what changes
when we plug in and remove the power adapter.

Now for the interesting part, changing the acpid events to "catch" this
change of power adapter. To make these changes bring up a terminal and
type in this command

    su
    cd /etc/acpi/events
    chmod +x anything
    cd ..
    gedit handler.sh

Now we need to change the bold entries in this file

    #!/bin/sh
    # Default acpi script that takes an entry for all actions

    # NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
    #       modify it to not use /sys

    minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
    maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
    setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

    set $*

    case "$1" in
       button/power)
           #echo "PowerButton pressed!">/dev/tty5
           case "$2" in
               PWRF)   logger "PowerButton pressed: $2" ;;
               *)      logger "ACPI action undefined: $2" ;;
           esac
           ;;
       button/sleep)
           case "$2" in
               SLPB)   echo -n mem >/sys/power/state ;;
               *)      logger "ACPI action undefined: $2" ;;
           esac
           ;;
       ac_adapter)
           case "$2" in
               # ADP0 is the name of my AC Adapter
               ADP0)
                   case "$4" in
                       # 0 Means that the AC Adapter is NOT present, therefore we are using the battery!
                       00000000)
                           # So we now change the CPU scaler to ondemand which is nice and responsive
                           # But do not forget we have 2 CPU Cores to contend with!
                           echo "ondemand" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                           echo "ondemand" >/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
                           # 
                           #echo -n $minspeed >$setspeed
                           #/etc/laptop-mode/laptop-mode start
                       ;;
                       # 1 Means that the AC Adapter is plugged in, so we need to ramp up the Cores!
                       00000001)
                           # So now we change both Cores to performance, which by default is full-whack!
                           echo "performance" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                           echo "performance" >/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
                           #echo -n $maxspeed >$setspeed
                           #/etc/laptop-mode/laptop-mode stop
                       ;;
                   esac
                   ;;
               *)  logger "ACPI action undefined: $2" ;;
           esac
           ;;
       battery)
           case "$2" in
               BAT0)
                   case "$4" in
                       00000000)   #echo "offline" >/dev/tty5
                       ;;
                       00000001)   #echo "online"  >/dev/tty5
                       ;;
                   esac
                   ;;
               CPU0)	
                   ;;
               *)  logger "ACPI action undefined: $2" ;;
           esac
           ;;
       button/lid)
           #echo "LID switched!">/dev/tty5
           ;;
       *)
           logger "ACPI group/action undefined: $1 / $2"
           ;;
    esac

Save and exit this file and after a reboot the system will load by
default the "ondemand" profile which changes the CPU speed quite nicely
I find. If you then plug in the mains for something intensive like a
game with graphics or some compiling then the both processor cores will
ramp up to full speed and so will the graphics card as we did that
earlier. Then when you need to use the laptop on the battery you will
find that the clock will drop down to 800MHz from 2,400MHz and the
graphics will slow down and conserve power.

Bluetooth

As we have a hardware switch for bluetooth then we can turn this on only
when we need it and this will save battery power and make the system a
bit more secure. Hopefully I won't need to tell you how to install
bluetooth, and on my machine I made no changes to the default
configuration files.

Verify that it works

If you have installed bluetooth stack and started the daemon as per the
wiki instructions available here Bluetooth Send a file to a mobile phone
using Gnome-Bluetooth utility in the system tray. If that worked out
fine then move onto the next step, if not then troubleshoot bluetooth
until you do get it working.

Saving power by turning off bluetooth by default when the system is logged into the Desktop

Basically I figured the best way to do this was to use gdm's PostLogin
script that I used earlier and add a line to turn off the power to the
device.

To make this change bring up a terminal and type in this command

    sudo nano /etc/gdm/PostLogin/Default

Then add this line in bold to nano and save the file

    #!/bin/sh
    #
    # Note: this is a sample and will not be run as is.  Change the name of this
    # file to <gdmconfdir>/PostLogin/Default for this script to be run.  This
    # script will be run before any setup is run on behalf of the user and is
    # useful if you for example need to do some setup to create a home directory
    # for the user or something like that.  $HOME, $LOGIN and such will all be
    # set appropriately and this script is run as root.


    # Now we shall try and powerdown the bluetooth device until we need it
    echo "0" > /sys/devices/platform/acer-wmi/rfkill/rfkill1/state


    # This ping's the NAS box to see if it is online, and if it is then mount
    # the shares.
    # If not then just exit, or the mount command will hang the system for
    # about 20~30 seconds which just plain sucks!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_8920G&oldid=238822"

Category:

-   Acer
