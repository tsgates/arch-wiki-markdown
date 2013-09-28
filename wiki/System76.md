System76
========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

System76 makes laptops, desktops, and servers that run on Ubuntu. They
can also be configured to use Arch Linux. Once Arch is installed you can
use some of these tips.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Graphics Drivers                                                   |
| -   2 Wifi Drivers                                                       |
| -   3 Battery                                                            |
| -   4 Webcam                                                             |
| -   5 Fingerprint Reader                                                 |
| -   6 Bluetooth                                                          |
| -   7 CD Drive                                                           |
+--------------------------------------------------------------------------+

Graphics Drivers
----------------

System76 computer offer Nvidia and ATI.

Wifi Drivers
------------

For at least my Pangolin laptop, they use the 'iwlwifi-5000-ucode'
driver. It is available in the core repository:

    # pacman -S iwlwifi-5000-ucode

For more info see Configuring Network

Battery
-------

It is best to use acpi:

    # pacman -S acpi acpid

For more info see acpid

Webcam
------

For webcam support, you need to load the 'uvcvideo' and 'videodev'
kernel modules.

    # modprobe -a uvcvideo videodev

For more info see Webcam Setup

Fingerprint Reader
------------------

For using the fingerprint reader on some System76 laptops, you will need
to install fprint.

Bluetooth
---------

The bluetooth device should be supported by bluez:

    # pacman -S bluez bluez-firmware

System76 laptops do not turn on bluetooth on boot up, instead you must
manually turn it on by pressing Fn-F12.

CD Drive
--------

Should work from the start.

Retrieved from
"https://wiki.archlinux.org/index.php?title=System76&oldid=206756"

Category:

-   Hardware
