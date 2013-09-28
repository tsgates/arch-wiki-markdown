EyeTV DTT Deluxe v2
===================

There is not much information about the EyeTV DTT Deluxe v2 on the web
so here we go.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 lsusb                                                              |
| -   2 Installation                                                       |
| -   3 dmesg                                                              |
| -   4 External Resources                                                 |
+--------------------------------------------------------------------------+

lsusb
-----

    Bus 002 Device 005: ID 0fd9:002c Elgato Systems GmbH EyeTV DTT Deluxe v2

Installation
------------

Install linuxtv-dvb-apps using pacman

    pacman -S linuxtv-dvb-apps

Download the firmware and copy the files to /lib/firmware

    wget http://kernellabs.com/firmware/as102/as102_data1_st.hex
    wget http://kernellabs.com/firmware/as102/as102_data2_st.hex
    sudo mv as102_data* /usr/lib/firmware 
    sudo chmod 644 /usr/lib/firmware/as102_data*

Now you can plug it in and you are ready to go.

dmesg
-----

    [  484.336751] usb 2-1: new high-speed USB device number 5 using ehci_hcd
    [  484.804400] dvb_as102: module is from the staging directory, the quality is unknown, you have been warned.
    [  484.804853] as10x_usb: device has been detected
    [  484.804865] DVB: registering new adapter (Elgato EyeTV DTT Deluxe)
    [  484.805121] DVB: registering adapter 0 frontend 0 (Elgato EyeTV DTT Deluxe)...
    [  484.964484] as10x_usb: fimrware: as102_data1_st.hex loaded with success
    [  485.199985] as10x_usb: fimrware: as102_data2_st.hex loaded with success
    [  485.200015] usbcore: registered new interface driver Abilis Systems as10x usb driver

More info on DVB-T can be found on the DVB-S page. Do something like.

    pacman -S vlc
    scan /usr/share/dvb/dvb-t/de-Nordrhein-Westfalen |tee channels.conf
    vlc channels.conf 

External Resources
------------------

http://www.kernellabs.com/blog/?p=1378

Retrieved from
"https://wiki.archlinux.org/index.php?title=EyeTV_DTT_Deluxe_v2&oldid=213336"

Category:

-   Other hardware
