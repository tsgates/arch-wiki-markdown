ASUS U31SD
==========

Contents
--------

-   1 System specification
-   2 What does not work out of the box
-   3 What works out of the box / with default configuration
-   4 Not tested
-   5 Input/touchpad
-   6 Bluetooth
-   7 Nvidia GPU (Optimus)
-   8 Suspend/hibernate
-   9 Fn multimedia keys
-   10 Optimize power consumption

System specification
--------------------

-   CPU: Intel(R) Core(TM) i3-2330M CPU @ 2.20GHz (Sandy Bridge)
-   Memory: 4 GB DDR3 PC1333 - can be expanded to a maximum of 8GB (two
    DIMM slots)
-   WiFi: Atheros Communications Inc. AR9285
-   Ethernet: Atheros Communications Inc. AR8151 v2.0 Gigabit Ethernet
-   Bluetooth: Atheros Communications, Inc. AR3011 Bluetooth
-   Hard-Drive: 640GB Hitachi HTS547564A9E384
-   Optical Drive: None
-   Integrated Graphics: Intel 2nd Generation
-   Discrete Graphics: Nvidia GT520M (GF119)
-   Sound: Intel Corporation 6 Series/C200
-   Screen: 13.3" LCD 1366x768)
-   SD Card Reader
-   Webcam: V4L compatible

Note:This page was written for the i3 model but I'm sure the i5 model
will not be much different

What does not work out of the box
---------------------------------

-   Sleep/Hibernate (see below)
-   Nvidia GPU (Switchable GPU, see below)
-   Fn Volume Keys (see below)

What works out of the box / with default configuration
------------------------------------------------------

-   CPU (all cores detected)
-   Wireless
-   Ethernet
-   Framebuffer resolution (nouveau and intel xorg drivers provide this)
-   Intel GPU
-   Touchpad
-   Bluetooth
-   Hotkeys (Brightness / Monitor on-off / wifi / sleep)
-   USB

Not tested
----------

-   HDMI

Input/touchpad
--------------

The keyboard and touchpad work more or less without problems using the
xf86-input-keyboard and xf86-input-synaptics modules, respectively.
Right- and left-clicking works, as well as Two-Finger scroll. Tapping is
enabled out of the box and can be disabled in

     /etc/X/xorg.conf.d/10-synaptics.

Bluetooth
---------

Installing a tool like "blueman" from the AUR and starting the bluetooth
DAEMON allowed communication to bluetooth keyboards and mice. Bluetooth
speakers not tested. (*users feel free to add to this)

Nvidia GPU (Optimus)
--------------------

Tip:Your best bet for this part is to install yaourt from the AUR to
ease in installing the following packages

You need to install the packages bumblebee and bbswitch.

In short, Bumblebee allows you to use the switchable GPU and use it only
when you want to via the 'optirun' application.

Be sure enable bumblebeed Systemd service to start Bumblebee at boot.

Once you reboot, you should start seeing huge power saving.

To check and make sure that you aren't using your GPU all the time:

    $ lsmod | grep nv

Should return nothing, this means your GPU is off.

You can check your GPU by running glxgears with and without the
'optirun' prefix and comparing the Frames Per Second.

Read the Bumblebee page for further informations.

Suspend/hibernate
-----------------

The USB unbind hook is no longer necessary as of Linux 3.5.

Note:ACPI by default doesn't call pm-suspend, if we want to customize
the sleep process, we need pm-suspend

If you want sleep your machine when you close your lid, you need to edit
ACPI handler script /etc/acpi/handler.sh

Change line 20, to this:

    SLPB|SBTN)    pm-suspend ;;

And Towards the bottom, make lines 58 and 59 look line like this:

    close)
            pm-suspend

So now you can use the hotkey (F1) or close your lid and your laptop
will sleep.

Fn multimedia keys
------------------

As with most Asus laptops/netbooks, this laptop sends its Multimedia
events via ACPI. Using acpi_listen, I was able to discover the button
commands the buttons sent to acpi. Add the following to your
/etc/acpi/handler.sh file (make sure you add this after the ;; in the
button/lid section):

        button/volumeup)
          amixer set Master 5+
          ;;
        button/volumedown)
          amixer set Master 5-
          ;;
        button/mute)
          amixer set Master toggle
          ;;

You can mess with these values to move your volume at different
intervals, 5 seemed to work well for me.

Optimize power consumption
--------------------------

Add this to the kernel line of your bootloader[1]:

    pcie_aspm=force i915.i915_enable_rc6=1

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_U31SD&oldid=273697"

Category:

-   ASUS

-   This page was last modified on 1 September 2013, at 11:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
