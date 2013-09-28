Lenovo ThinkPad T420s
=====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Fans                                                               |
| -   2 Using multiple monitors with NVIDIA-Optimus                        |
|     -   2.1 Example X.org-Configuration using Intel and NVIDIA together  |
|     -   2.2 Switching configurations when the device is docked at boot   |
|                                                                          |
| -   3 Sound                                                              |
| -   4 TrackPoint                                                         |
|     -   4.1 Setting                                                      |
|     -   4.2 Configuration Tool                                           |
+--------------------------------------------------------------------------+

Fans
----

The thinkpad_acpi kernel module needs to be configured so user space
programs can control the fan speed.

    /etc/modprobe.d/modprobe.conf

    options thinkpad_acpi fan_control=1

The thinkfan configuration file also needs to know how to set the fan
speed. Replace the default sensor settings with the following.

    /etc/thinkfan.conf

    sensor /sys/devices/platform/coretemp.0/temp1_input

Using multiple monitors with NVIDIA-Optimus
-------------------------------------------

Note:This solution may work on other devices with NVIDIA-Optimus, too.

It seems that the digital video ports (DVI or DisplayPort) only
connected to the NVIDIA-card (Only if you have one, of course, see
ThinkWiki - Switchable Graphics and Docks). So you can't use a monitor
via DisplayPort/DVI with the integrated graphics card (Intel). You can
solve this problem by switching completly to the NVIDIA card in the BIOS
settings, but this uses more battery power. A better solution is to
activate the NVIDIA-Card only when you connected to an external monitor.

First install and configure Bumblebee.

After that you can start a secound XServer on your NVIDIA-Card (replace
the $path-to-nvidia-org-configuration-file !):

    Xorg :9 -config $path-to-nvidia-org-configuration-file -nolisten tcp -noreset -verbose 3 -isolateDevice PCI:01:00:0 -modulepath /usr/lib/nvidia-bumblebee/xorg/,/usr/lib/xorg/modules

With a minimal xorg-configuration for your NVIDIA-Card, as example:

    Section "Device"
        Identifier     "Device0"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "NVS 4200M"
        Option "NoLogo" "true"
        Option "UseEDID" "true"
    EndSection

This minimal configuration should detected the connected monitor and use
it automatically.

If Bumblebee is correctly configured, your NVIDIA-Card should wake-up
when you start the secound X-Server and if you kill it, it should be
going to sleep again.

> Example X.org-Configuration using Intel and NVIDIA together

You can use your internal monitor (connected only to the intel card) and
some external monitor (Connected to the NVIDIA card) together with
Xinerama. The example configuration below shows how to use three screens
with Xinerama, two external with the NVIDIA card and the internal with
the intel card.

    /etc/X11/xorg.conf

    Section "ServerLayout"
        Identifier     "X.org Configured"
        Screen      0  "Screen0" 0 0
        Screen      1  "Screen1" LeftOf "Screen0"
        Screen      2  "Screen2" LeftOf "Screen1"
        Option         "Xinerama" "1"
    EndSection

    Section "Device"
        Identifier     "intelDevice"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Device"
        Identifier     "nvidiaDevice"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "NVS 4200M"
        Option "NoLogo" "true"
        #Option "UseEDID" "true"
        BusID          "PCI:1:0:0"
        Screen         0
    EndSection

    Section "Device"
        Identifier     "nvidiaDevice2"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "NVS 4200M"
        BusID          "PCI:1:0:0"
        Screen          1
    EndSection

    Section "Monitor"
        # HorizSync source: edid, VertRefresh source: edid
        Identifier     "nvidiaMonitor"
        VendorName     "Unknown"
        ModelName      "DELL U2412M"
        HorizSync       30.0 - 83.0
        VertRefresh     50.0 - 61.0
        Option         "DPMS"
    EndSection

    Section "Screen"
        Identifier     "Screen0"
        Device         "nvidiaDevice"
        Monitor        "nvidiaMonitor"
        DefaultDepth    24
        Option         "TwinView" "0"
        Option         "TwinViewXineramaInfoOrder" "DFP-6"
        Option         "metamodes" "nvidia-auto-select +0+0"
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen1"
        Device         "intelDevice"
        Monitor        "intelMonitor"
        DefaultDepth    24
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen2"
        Device         "nvidiaDevice2"
        Monitor        "nvidiaTVMonitor"
        DefaultDepth    24
        Option         "TwinView" "0"
        Option         "metamodes" "DFP-2: nvidia-auto-select +0+0"
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection

    Section "Monitor"
        Identifier     "intelMonitor"
        VendorName     "Unknown"
        ModelName      "LVDS"
    EndSection

    Section "Monitor"
        # HorizSync source: edid, VertRefresh source: edid
        Identifier     "nvidiaTVMonitor"
        VendorName     "Unknown"
        ModelName      "SONY TV"
        HorizSync       14.0 - 70.0
        VertRefresh     48.0 - 62.0
        Option         "DPMS"
    EndSection

> Switching configurations when the device is docked at boot

The following rc-script detects at boot if your ThinkPad is connected to
the dock. If the device is docked, it activates the NVIDIA card and copy
a custom XOrg-Configuration (with an external monitor configured, as
example) to /etc/X11/xorg.conf. If the device is not docked, the
/etc/X11/xorg.conf is removed, so the default configuration is used and
the NVIDIA card is disabled. (So it saves power on travel.)

Save this script to /etc/rc.d/dockscript or something and make it
executable. Your custom XOrg-Configuration should at
/etc/X11/xorg.conf.nvidia. Then add dockscript to DAEMONS in your
rc.conf. bumblebeed should start before and your X-Server must start
after.

You can detect the correct dock_usb_id by using lsusb.

    /etc/rc.d/dockscript

    #!/bin/bash
    dock_usb_id="17ef:100a Lenovo ThinkPad Mini Dock Plus Series 3"
    dock_xorg_file=/etc/X11/xorg.conf.nvidia
    xorg_file=/etc/X11/xorg.conf

    . /etc/rc.conf
    . /etc/rc.d/functions

    case "$1" in
      start)
        stat_busy "Starting Dock Detection"
        lsusb | grep "$dock_usb_id" > /dev/null
        if [ $? -eq 0 ]; then
          tee /proc/acpi/bbswitch <<<ON
          cp "$dock_xorg_file" "$xorg_file"
        else
          rm "$xorg_file"
        fi
        stat_done
        ;;
      stop)
        stat_busy "Stopping Dock Detection"
        rm "$xorg_file"
        tee /proc/acpi/bbswitch <<<OFF
        stat_done
        ;;
      restart)
        $0 stop
        sleep 3
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"
    esac
    exit 0

Sound
-----

To make sound work, make sure all channels are unmuted via alsamixer or
similar, and configure the snd-hda-intel module to load specifically for
a thinkpad.

    /etc/modprobe.d/modprobe.conf

    options snd-hda-intel model=thinkpad

TrackPoint
----------

> Setting

Create 20-thinkpad.conf under /etc/X11/xorg.conf.d/.

    Section "InputClass"
            Identifier      "Trackpoint Wheel Emulation"
            MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
            MatchDevicePath "/dev/input/event*"
            Option          "EmulateWheel"          "true"
            Option          "EmulateWheelButton"    "2"
            Option          "Emulate3Buttons"       "false"
            Option          "XAxisMapping"          "6 7"
            Option          "YAxisMapping"          "4 5"
    EndSection

> Configuration Tool

The GPointing Device Settings is a great tool for configuring the Track
Point. You may install it via AUR: gpointing-device-settings.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T420s&oldid=207180"

Category:

-   Lenovo
