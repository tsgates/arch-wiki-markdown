Bluetooth Keyboard
==================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: These commands   
                           are deprecated in bluez  
                           v4 and seem not to work. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Warning:hidd is deprecated in bluez v4. The current procedure is given
in Bluetooth mouse configuration.

This article describes how to set up a Bluetooth keyboard with Arch
Linux, bluez version 3. I used an Apple Wireless Keyboard (aluminium)
but it should work for other models.

The setup is similar than the one of a Bluetooth Mouse. Follow this
guide first to add kernel modules, bluetooth libraries.

The tricky part for the Apple Wireless Keyboard is to have the correct
settings in /etc/bluetooth/hcid.conf. Obviously you need to replace the
mac address with yours:

    device 00:01:02:03:04:05 {
      name "Apple Wireless Keyboard";
      auth disable;
      encrypt disable;
    }

And then to have /etc/conf.d/bluetooth with the following options to
connect automatically when starting the bluetooth daemon:

    HCID_ENABLE="true"
    HIDD_ENABLE="true"
    HIDD_OPTIONS="--timeout 8 --master --server --connect 00:01:02:03:04:05"

If you loaded the bluetooth modules from the Bluetooth Mouse guide you
can now test by doing a /etc/rc.d/bluetooth restart

Bluetooth Keyboard at Startup
-----------------------------

in /etc/rc.conf add the following modules:

    MODULES=(... hci_usb bluetooth hidp l2cap)

and add the bluetooth daemon:

    DAEMONS=(... @bluetooth ...)

Then it should work on reboot automatically !

Bluez v4.39
-----------

In this version of bluez, there is no /etc/bluetooth/hcid.conf To create
a trust between your BT adapter and a BT device, add the device's BT
address to a file called trusts inside /var/lib/bluetooth/<MAC address
of BT host adapter>/trusts, like so:

    echo "00:02:76:05:45:E1 [all]" >> /var/lib/bluetooth/00\:1E\:37\:B0\:47\:24/trusts

This line appends a new line to that file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_Keyboard&oldid=237732"

Categories:

-   Bluetooth
-   Keyboards
