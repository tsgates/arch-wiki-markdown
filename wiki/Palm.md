Palm
====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This guide is to help Arch users with Palm(R) devices. While
installation in Arch is easy, it can be confusing for those who are new.
Also see Palm Evolution.

Contents
--------

-   1 Installing Packages
-   2 Finding your Device
    -   2.1 tty* based sync
    -   2.2 libusb based sync
-   3 Setting up the Software
-   4 Hotsync over Bluetooth
-   5 Palm T|X
-   6 Palm Centro
-   7 Troubleshooting

Installing Packages
-------------------

You will need to install one of the various Personal Information
Management (PIM) softwares.

       sudu pacman -S jpilot

or, as root

       pacman -S jpilot

JPilot is the simplest client, though it is fully functional. Others
include KPilot

       sudo pacman -S kdepim

or gpilot

       sudo pacman -S gnome-pilot

Any of the above options should install all that you need.

Finding your Device
-------------------

You can sync in two ways, either by using libusb (preferred) or by using
ttyUSB*/ttyS*

> tty* based sync

Note: Do not have jpilot or other client open at this stage. Now, plug
your device into the cradle, then into your computer (i.e. Palm T3), or
straight USB cable (i.e. Tungsten E, TX) and attempt to hotsync.

Open up a terminal and type:

       dmesg

The last few lines will refer to your palm. For those who are familiar
with Arch, you know what to look for. Others, look for any text followed
by numbers, such as sr0, sg0. Just take a note of this, you may or may
not need it. Mine lists as:

       usb 3-2: Handspring Visor / Palm OS converter now attached to ttyUSB0
       usb 3-2: Handspring Visor / Palm OS converter now attached to ttyUSB1

Next, set the directory to /dev and list the contents

       cd /dev/ && ls

You should see an item there called 'palm', or 'pilot'. Again, take note
of which is listed. Mine is 'pilot'. Note: This will only show up when
hotsyncing. If it times out, retry.

> libusb based sync

By default J-Pilot uses the usb: pseudo device, do not change it.

This setting makes use of the /dev/bus/usb/ file system. If your user is
in the group owning files in this file system that's the only
configuration you'll need. (In mine is vboxusers but it's very unlikely
it's the default...)

Just press Sync button in J-Pilot and then hotsync in your Palm.

Works every time with the most troublesome Palm: T|X.

Setting up the Software
-----------------------

Open up JPilot (or other software), either from the 'Office' menu (for
Gnome) or by typing:

       jpilot
       kpilot
       gnome-pilot

in the terminal.

Open the settings menu. On JPilot, this is File -> Preferences ->
Settings. On KPilot or Kontact it is Settings -> Configure KPilot ->
Device.

The Device setting should be /dev/palm or /dev/pilot, as noted above.

Next, on JPilot go to File -> Install User and type the username on your
palm. In KPilot simply set the Pilot User setting in the Device area.

Now, first start a hotsync on your palm, then click the hotsync button
in JPilot or KPilot. If all goes well, it will connect and start
synchronizing. This will be quick, as it just does contacts, addresses,
etc. The standards. There are no special conduits in the standard
Jpilot, such as Documents-To-Go, so either find those on the Internet
(if they exist) or make them yourself. :)

Next, do the same thing, but click the button below, for backup. On
first run, this will take a long time, but well worth while.

That's it! You have successfully setup your palm device on Arch Linux.

  

Hotsync over Bluetooth
----------------------

Palm devices come with built-in networking capabilities, as well as
Bluetooth. If you also own a laptop, or have a USB Bluetooth adaptor,
syncing over bluetooth, while being noticeably slower, is probably more
convenient than keeping your sync cable handy.

First, of course, you have to have bluetooth set up. Bluetooth provides
the arch-specific guide to that, its currently quite short, but I had no
problems following it. Of course, there's also the forums to ask for
help.

Next, there's the actual setup for syncing. Basically, this involves
setting up a small LAN over Bluetooth connection. I did this following
the guide in [1], the author of which followed the guide in [2]. Anyway,
on to the real information.

First we'd need to pair the Palm and your PC. If you're using Bluez,
then use blueman-manager to search for your Palm (make sure bluetooth is
turned on and not hidden), then pair them (the button is labeled 'bond',
for some reason or other). You'd need to type in a verification
pass-key. Alternatively, from the palm, search for your PC's bluetooth
and set it as a trusted device.

Next, on your Palm, go to Preferences->Connection and create a new
connection, name it "Laptop Bluetooth" or whatever you like, set it to
connect to a PC via Bluetooth, and select your PC from the list below.
Next, you have to actually setup the network, going through
Prefences->Network, create a new network, naming it again anything you
want (I use "Linux"), select the connection you just created, and leave
the user name and password blank (you could put something here, you'd
need to change the following steps accordingly though).

To set up your PC, first create the file /etc/ppp/peers/dun, with these
contents:-

    115200
    10.0.1.8:10.0.1.40
    local
    ms-dns <enter your dns server address here>
    noauth
    debug

As root, edit the file /etc/ppp/pap-secrets, adding this line:-

    mylogin * mypassword *

In a terminal, run dund as root (prefix with sudo if you're not logged
in as root). You would need to make sure the bluetooth daemon is already
started at this point.

    dund --nodetach --listen --persist --msdun call dun

Click the 'Connect' button under Preferences->Networking for your Palm.
In the terminal, some text should start scrolling, indicating a new
connection, channels being used, and the sending and receiving of
various packets. At this point, your connectivity is working fine, and
you can add the following line to /etc/rc.local so dund starts at every
login:-

    dund --listen --persist --msdun call dun

For the Hotsync specific setup, navigate to 'Hotsync' on your palm,
select 'Modem' instead of local. Go to the menu, and change the
following preferences:-

    Modem Sync Preferences -> set Network instead of Direct to modem
    LANSync Preferences -> set LANSync instead of Local HotSync
    Primary PC Setup -> Set the Primary PC Name and Address to 10.0.1.8, according to the settings previously in /etc/ppp/peers/dun
    Connection Setup -> select the connection you previously created (Laptop Bluetooth, for example)

Under the Hotsync button, if the name you previously assigned to your
network does not show ("Linux" in this example), select that area and it
should automatically show "Linux". You are now ready to HotSync. Make
sure dund is running, run your preferred sync-ing program using the
interface net:any (I use JPilot, under
File->Preferences->Settings->Serial Port I select 'other' and specify
'net:any'), and then click on the HotSync icon on your Palm. Enjoy
wireless sync-ing.

Palm T|X
--------

In addition to usb and bluetooth, the Palm T|X model includes ethernet
connectivity. To sync the device using a direct ethernet connection
using jpilot simply set the serial device to net:any in the Preferences
dialog and then hotsync. On the Palm, you will need to select the
name/ip address of the machine where jpilot is running and then start
the hotsync. Enjoy high speed wireless hotsynching.

Palm Centro
-----------

The visor module does not currently work with the Palm Centro. It is not
needed, as newer software accesses the Centro through libusb. To make
the Palm work under Arch, take the following steps:

Edit /etc/rc.conf and blacklist the visor module:

    MODULES=(!visor)

You may have to reboot for this change to take effect.

When udev creates a device node for the Centro, it by default assigns it
owner and group to root. You need to create a non-root group for udev to
use for this device and make sure you're a member:

    groupadd palm
    usermod -a -G palm <your_username>

You'll need to logout and re-login for the new group assignment to take
effect. After you do, you should see palm in the list of groups when you
run the groups command.

You now need to tell udev how to assign the Centro to the group palm
when it is attached. Create a file called
/etc/udev/rules.d/55-palm-centro.rules

    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", \
    ATTR{idVendor}=="0830", ATTR{idProduct}=="0061", \
    NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0664", GROUP="palm"

Now plug in the device. Verify that a device has been added which has
group palm:

    find /dev -group palm

The device name doesn't really matter, as libusb will find it when
needed.

To sync the device, if using jpilot, simply specify usb: as the serial
port in preferences.

Troubleshooting
---------------

If you get a message such as stating that you do not have proper
permissions, you probably need to add your user to a group with the
proper permissions. This may be 'usb' or 'uucp'.

       gpasswd -a username usb

or

       gpasswd -a username uucp

Also, your software may have difficulty finding the device.

       ls -l /dev/pilot

or

       ls -l /dev/palm

may help you to discover a different name for the device. Output may
look like this:

       lrwxrwxrwx 1 root root 8 2002-01-03 16:13 /dev/pilot -> tts/USB1

Now change the Device setting (as above) to /dev/tts/USB1 or
/dev/tts/USB0.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Palm&oldid=239496"

Category:

-   Mobile devices

-   This page was last modified on 8 December 2012, at 13:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
