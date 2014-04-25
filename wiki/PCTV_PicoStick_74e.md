PCTV PicoStick 74e
==================

How to use a PCTV PicoStick 74e DVB-T tuner with Archlinux.

Download firmware
-----------------

As superuser (root), issue the following commands :

    cd /lib/firmware
    wget http://www.kernellabs.com/firmware/as102/as102_data1_st.hex
    wget http://www.kernellabs.com/firmware/as102/as102_data2_st.hex

Firmware is now installed and you can connect the tuner to an USB port
and is should "just work".

Checking if it works
--------------------

Issue the following command (being superuser doesn't matter here) :

    dmesg | tail

You should get an output similar to this :

    [  737.936943] usb 2-2.4.4: new high-speed USB device number 42 using ehci-pci
    [  738.022688] as10x_usb: device has been detected
    [  738.022707] DVB: registering new adapter (PCTV Systems picoStick (74e))
    [  738.022991] usb 2-2.4.4: DVB: registering adapter 0 frontend 0 (PCTV Systems picoStick (74e))...
    [  738.186315] as10x_usb: firmware: as102_data1_st.hex loaded with success
    [  738.433948] as10x_usb: firmware: as102_data2_st.hex loaded with success

As you can see, it tells us that both firmware files were loaded
successfully and that the tuner is ready to be used.

Have fun !

Retrieved from
"https://wiki.archlinux.org/index.php?title=PCTV_PicoStick_74e&oldid=269731"

Category:

-   Other hardware

-   This page was last modified on 4 August 2013, at 03:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
