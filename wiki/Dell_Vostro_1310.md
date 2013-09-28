Dell Vostro 1310
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

This page deals with setting up Arch Linux on the Dell Vostro 1310
laptop. Nvidia graphics work excellently with the Nvidia 8400GS with no
real hacks. There have been some problems with the ethernet NIC, but it
is possible for it to work correctly.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Audio                                                        |
|         -   1.1.1 OSS                                                    |
|                                                                          |
|     -   1.2 Video                                                        |
|         -   1.2.1 Nvidia GeForce 8400M GS                                |
|         -   1.2.2 Intel X3100                                            |
|                                                                          |
|     -   1.3 Network                                                      |
|         -   1.3.1 Ethernet                                               |
|         -   1.3.2 Wireless                                               |
|             -   1.3.2.1 mini Dell Wireless / Broadcom based cards        |
|             -   1.3.2.2 Intel based cards                                |
|             -   1.3.2.3 Bluetooth                                        |
|                                                                          |
|     -   1.4 Webcam                                                       |
|                                                                          |
| -   2 Power Management                                                   |
|     -   2.1 CPU                                                          |
|     -   2.2 Hibernate/Suspend                                            |
+--------------------------------------------------------------------------+

Hardware
--------

> Audio

OSS

After comparing both ALSA & OSS on the Vostro 1310 I have come to the
conclusion that OSS indeed sounds clearer with more range. However I
cannot recommend the use of OSS on the 1310 due to a consistent
crackling noise that can be heard in the background whenever any audio
is played. A complete reinstall and several restarts of OSS has been
tried to correct the problem but has not helped the situation at all.
Instead I recommend installing ALSA which has given me zero problems.

> Video

First of all it is necessary to install the Xorg server. The easiest way
to do this is by entering the following command as root:

    pacman -S xorg

Press Y to install all the packages and wait for the download to finish.

Nvidia GeForce 8400M GS

The proprietry Nvidia drivers are setup very easily for the GeForce
8400M GS. Having installed Xorg (see above) you type in this command
into the console as root:

    pacman -S nvidia

After it has finished downloading you need to configure the Nvidia
drivers. You will need to be logged in as root. Enter the following
command:

    nvidia-xconfig

Now, open up /etc/X11/xorg.conf in a text editor and comment out the
line; Load "type1". For this example we'll use nano:

    nano /etc/X11/xorg.conf

and comment it out with a hash (#) symble like so:

    #    Load           "type1"

You should now have successfully setup the Nvidia drivers.

Intel X3100

> Network

Ethernet

The connection to an ADSL router was able to be set up using the r8169
drivers module for the network card. This was automatically placed in
the MODULES line of /etc/rc.conf after the 32-bit 2008.06 install. Below
is the appropriate parts of my /etc/rc.conf, the router's IP address is
192.168.1.1 .

    MOD_AUTOLOAD="yes"
    #MOD_BLACKLIST=() #deprecated
    MODULES=(r8169 iwl4965 snd-mixer-oss snd-pcm-oss snd-hwdep snd-page-alloc snd-pcm snd-timer snd snd-hda-intel soundcore)

    HOSTNAME="putYourComputersNameHere"

    eth0="dhcp"
    INTERFACES=(eth0)

    gateway="default gw 192.168.1.1"
    ROUTES=(gateway)

Of course, make sure that network is in the DAEMONS line so that the
network is started at boot:

    DAEMONS=(syslog-ng network netfs crond entranced)

Wireless

To know your exact wireless card you can run:

    lspci | grep Net

mini Dell Wireless / Broadcom based cards

If you have a Broadcom BCM4328 802.11a/b/g/n (and maybe other flavors)
you can follow the installation instructions for Broadcom BCM4312.

Intel based cards

Follow the instructions for the Intel Wifi 4965 chipset

Bluetooth

Currently does not work, will do more research and report back.

> Webcam

The webcam is detected by lsusb as the 0c45:63e0 Microdia Sonix
Integrated Webcam. To get the webcam to properly function follow the
steps listed below.

-   Make sure the uvcvideo module is loaded by performing the following
    command: "lsmod | grep uvcvideo". Your output should be something
    like

    # uvcvideo               68316  0
    # videodev               42080  1 uvcvideo
    # v4l1_compat            18228  2 uvcvideo,videodev
    # usbcore               179024  5 uvcvideo,usbhid,uhci_hcd,ehci_hcd

-   Once you have confirmed that the 'uvcvideo' module is loaded, add
    your user to the 'video' group.

    # gpasswd -a UserNameGoesHere video

-   Log your user out and back in to ensure that your user is apart of
    the the video group.
-   Now you should be able to install your Webcam application such as
    cheese and you should find that your camera works perfectly. See
    Webcam Setup for more details on configuring your webcam.

Power Management
----------------

> CPU

For the Intel Core 2 Duo (and all laptop cpu's) you must follow the
instructions to setup CPU Frequency Scaling.

> Hibernate/Suspend

Hibernate/Suspend works out of the box with pm-utils however integration
with HAL does not. In order for you to enable power-related settings
like "Suspend on closing of Laptop Lid" in Gnome you will need a
particular HAL policy file. This file (10-power-mgmt-policy.fdi) can be
found in /usr/share/hal/fdi/policy/10osvendor/ and must be copied to
/etc/hal/fdi/policy/ as root.

-   As previously stated copy the 10-power-mgmt-policy.fdi file to the
    correct directory

    # cp /usr/share/hal/fdi/policy/10ovendor/10-power-mgmt-policy.fdi /etc/hal/fdi/policy 

-   Add your user to the 'power' group

    # gpasswd -a UserNameGoesHere power 

-   Restart the HAL service or your machine for the change take affect.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1310&oldid=196589"

Category:

-   Dell
