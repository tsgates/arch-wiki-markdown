Dell Vostro 1400
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

This page deals with setting up Arch Linux on the Dell Vostro 1400
laptop. Nvidia graphics work excellently with the Nvidia 8400GS with no
real hacks. I get about 4400 fps in glxgears.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 CPU                                                                |
| -   2 Network                                                            |
|     -   2.1 Ethernet                                                     |
|     -   2.2 Wireless                                                     |
|         -   2.2.1 mini Dell Wireless / Broadcom based cards              |
|         -   2.2.2 Intel based cards                                      |
|                                                                          |
| -   3 Graphical Input                                                    |
|     -   3.1 Touchpad                                                     |
|                                                                          |
| -   4 Graphics                                                           |
|     -   4.1 Nvidia GeForce 8400M GS                                      |
+--------------------------------------------------------------------------+

CPU
---

For the Intel Core 2 Duo (and all laptop cpu's) you must follow the
instructions to setup the CPU Frequency Scaling.

Network
-------

> Ethernet

> Wireless

To know your exact wireless card you can run:

    lspci | grep Net

mini Dell Wireless / Broadcom based cards

If you have a Broadcom BCM4328 802.11a/b/g/n (and maybe other flavours)
you can follow the installation instructions for Broadcom BCM4312.

Intel based cards

Follow the instructions for the Intel Wifi 4965 chipset

Graphical Input
---------------

There is more than one way to do this but we'll use HAL. First enter
this as root to get hal.

    pacman -S hal

Once it is installed you can start it by typing this as root.

    /etc/rc.d/hal start

You will want to add "hal" to your daemons list in /etc/rc.conf.

> Touchpad

Now that HAL is installed follow the instructions for Synaptic touchpad
via HAL policy (this is based on the Vostro 1500 and may not apply but
if it seems like everything is frozen after starting X you should
probably try this)

Graphics
--------

First of all it is necessary to install the Xorg server. The easiest way
to do this is by entering the following command as root:

    pacman -S xorg

Press Y to install all the packages and wait for the download to finish.

> Nvidia GeForce 8400M GS

The proprietry Nvidia drivers are setup very easily for the GeForce
8400M GS. Having installed Xorg (see above) you type in this command
into the console as root:

    pacman -S nvidia

After it has finished downloading you need to configure the Nvidia
drivers. You will need to be logged in as root. Enter the following
command:

    nvidia-config

Now, open up /etc/X11/XF86Config in a text editor and comment out the
line; Load "type1". For this example we'll use nano:

    nano /etc/X11/XF86Config

and comment it out with a hash (#) symble like so:

    #    Load           "type1"

You should now have successfully setup the Nvidia drivers.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1400&oldid=196591"

Category:

-   Dell
