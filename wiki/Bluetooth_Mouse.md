Bluetooth Mouse
===============

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Bluetooth   
                           mouse configuration.     
                           Notes: This article does 
                           not include all          
                           necessary informations   
                           to make mouse work in    
                           linux. Also this article 
                           include lots of outdated 
                           info. (Discuss)          
  ------------------------ ------------------------ ------------------------

This article describes how to set up a bluetooth mouse with Arch Linux.
I used a Logitech v270 with a Trendnet TBW-101UB USB Bluetooth dongle,
but the general process should be the same for any model.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required software                                                  |
| -   2 Configuration                                                      |
| -   3 Finding out your mouse's bdaddr                                    |
| -   4 kernel modules                                                     |
| -   5 Connecting the mouse                                               |
| -   6 Connecting the mouse at startup                                    |
| -   7 Troubleshooting tips                                               |
+--------------------------------------------------------------------------+

Required software
-----------------

You need the bluez package from the extra repository.

Configuration
-------------

The pertinent options in /etc/conf.d/bluetooth are

    HIDD_ENABLE=true

after that, start bluetooth services with

    # systemctl enable bluetooth.service
    # systemctl start bluetooth.service

If you don't use systemd use following command instead

    /etc/rc.d/bluetooth start

Finding out your mouse's bdaddr
-------------------------------

It is of the form 12:34:56:78:9A:BC. Either find it in the documentation
of your mouse, on the mouse itself or with the hcitool scan command.

kernel modules
--------------

No additional actions are necessary if the bluetooth service is started
using systemd. If it does not work try following.

The command

    # modprobe -v btusb bluetooth hidp l2cap

loads the kernel modules you need, if they weren't loaded automatically.

(See below for some tips if you're stuck at this point)

Connecting the mouse
--------------------

    hidd --search
    hcitool inq

are good for device scanning (I needed to use sudo for 'hidd --search'
to automatically connect mouse, searching worked even without sudo).

    hidd --connect <bdaddr>

to actually connect.

    hidd --show

will show your currently connected devices. The mouse should show up in
this list. If it doesn't, press the reset button to make it
discoverable.

Note: If you have the ipw3945 module loaded (wifi on HP computer) the
bluetooth wont work.

Connecting the mouse at startup
-------------------------------

Edit /etc/conf.d/bluetooth:

    # Arguments to hidd
    HIDD_OPTIONS="--connect <enter here your bluetooth mouse address>"

and test the new settings:

    /etc/rc.d/bluetooth stop
    hidd --killall (drop mouse connection)
    /etc/rc.d/bluetooth start

Note: The above instructions to start the mouse at startup do not work
with the now outdated 3.11 bluetooth packages. New versions such as the
current (3.32) packages are not affected. If you are using an older
version, then to start the mouse at startup, add:

    hidd --connect <enter here your bluetooth mouse address (No capitals!!!)>

to your /etc/rc.local file.

Note #2: You can connect any bluetooth mouse and/or keyboard without any
further configuration and without knowing the device address. You can do
it by adding the --master and/or --server option in HIDD_OPTIONS
depending on your device.

Troubleshooting tips
--------------------

If you have trouble with your USB dongle, you may also want to try

    # modprobe -v rfcomm

At this point, you should get an hci0 device with

    # hcitool dev

Sometimes the device is not active right away - try starting the
interface with

    # hciconfig hci0 up

and searching for devices as shown above.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_Mouse&oldid=252440"

Categories:

-   Mice
-   Bluetooth
