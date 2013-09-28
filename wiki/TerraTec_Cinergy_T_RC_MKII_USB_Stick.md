TerraTec Cinergy T RC MKII USB Stick
====================================

TerraTec Cinergy T RC MKII is a USB DVB-T receiver manufactured by
TerraTec Electronic GmbH. This page describes the installation of the
TerraTec Cinergy T RC MKII USB Stick (USB ID 0ccd:0097). It is supported
since kernel version 2.6.37.

Verify Device ID
----------------

Make sure you have the 'correct' device. The USB ID is '0ccd:0097':

    $ lsusb
    Bus 001 Device 004: ID 0ccd:0097 TerraTec Electronic GmbH Cinergy T RC MKII

Installation
------------

If you plug-in the device you will see the following kernel message:

    $dmesg
    [ 4403.369654] usb 1-1: new high-speed USB device number 5 using ehci_hcd
    [ 4403.862797] dvb-usb: found a 'TerraTec Cinergy T Stick RC' in cold state, will try to load a firmware
    [ 4403.864076] dvb-usb: did not find the firmware file. (dvb-usb-af9015.fw) Please see linux/Documentation/dvb/ for more details on firmware-problems. (-2)
    [ 4403.864103] dvb_usb_af9015: probe of 1-1:1.0 failed with error -2

You need to install the firmware file:

    $ wget http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
    $ sudo cp dvb-usb-af9015.fw /usr/lib/firmware/

Reconnect the device and you should see the following output. The device
is now ready to use :)

    $dmesg
    [ 4867.138959] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
    [ 4870.056313] usb 1-1: new high-speed USB device number 6 using ehci_hcd
    [ 4870.549447] dvb-usb: found a 'TerraTec Cinergy T Stick RC' in cold state, will try to load a firmware
    [ 4870.551676] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
    [ 4870.618834] dvb-usb: found a 'TerraTec Cinergy T Stick RC' in warm state.
    [ 4870.618971] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
    [ 4870.619381] DVB: registering new adapter (TerraTec Cinergy T Stick RC)
    [ 4870.622186] af9013: firmware version:4.95.0.0
    [ 4870.627936] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
    [ 4870.630198] tda18218: NXP TDA18218HN successfully identified.
    [ 4870.631940] Registered IR keymap rc-terratec-slim-2
    [ 4870.632197] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/rc/rc2/input11
    [ 4870.632437] rc2: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/rc/rc2
    [ 4870.632446] dvb-usb: schedule remote query interval to 500 msecs.
    [ 4870.632454] dvb-usb: TerraTec Cinergy T Stick RC successfully initialized and connected.

External links
--------------

-   TerraTec Cinergy T RC MKII at Linux TV
-   Product Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=TerraTec_Cinergy_T_RC_MKII_USB_Stick&oldid=229999"

Category:

-   Audio/Video
