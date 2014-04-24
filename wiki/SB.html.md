Sony vaio VGN-SA/SB
===================

SONY VAIO SA/SB ( S series ) Model No. VPCSA**/VPCSB** Getting started
instruction.

Please edit this article, keep fresh, your own idea to touch and go.

Summary help replacing me

Contents
--------

-   1 1. Features
-   2 2. Hardware
    -   2.1 2.1 Wired/Wireless
    -   2.2 2.2 Hybrid Graphics
        -   2.2.1 2.2.1 Disable discrete graphics on boot with a systemd
            unit
        -   2.2.2 2.2.2 ATI disabled on boot. Get long battery life.
        -   2.2.3 2.2.3 Use both at any time. Switchable.
        -   2.2.4 2.2.3 New functions. Set variety.
    -   2.3 2.3 Keyboard, Automatic light sensor
    -   2.4 2.4 Touchpad
    -   2.5 2.5 Fingerprint
    -   2.6 2.6 Web Camera
    -   2.7 2.7 TPM
    -   2.8 2.8 Optical(Secondary Channel)
    -   2.9 2.9 HDD/SSD(Primary Channel)
    -   2.10 2.10 Display brightness, Sound volume
    -   2.11 2.11 Gravity Sensor
-   3 3. Power Management
    -   3.1 3.1 ACPI modules
    -   3.2 3.2 Sandy/Ivy bridge issue
    -   3.3 3.3 Hybrid Graphics
    -   3.4 3.4 Wireless (WiFi, Bluetooth, WiMAX)
    -   3.5 3.5 Chipset, Optical, USB and more
    -   3.6 3.6 CPU

1. Features
-----------

-   Sandy/Ivy PCI bridge: Intel Core i platform, generation 2nd/3rd. GPU
    integrated
-   VGA(Internal/External): Intel GMA3000 or 4000 / ATI(AMD) RADEON HD
    6600M or nVIDIA GeForce GT 640M LE
-   Chipset: intel HM67 Express
-   RAID: intel 82801 Mobile SATA controller
-   Wireless: Centrino Wireless-N + WiMAX 6150(Bluetooth, WiFi, WiMAX)
-   Wired: Ethernet: Realtek RTL8111/8168B
-   Additional USB3.0 Host: NEC uPD720200(External), 1 Port
-   TPM is also available(Optional).

-   First edition of this article: kernel 3.3.5

2. Hardware
-----------

> 2.1 Wired/Wireless

There is nothing to do. Some udev errors are shown at boot like this,

    [   16.369825] Bad LUN (0:2)

    [   16.392657] Bad target number (1:0)

    [   16.405941] Bad target number (2:0)

    [   16.419294] Bad target number (3:0)

    [   16.469295] Bad target number (4:0)

    [   16.522611] Bad target number (5:0)

    [   16.575913] Bad target number (6:0)

    [   16.629228] Bad target number (7:0)

However, nothing to effect in use. If you want to solve these messages,
realtek official drivers may be required.

> 2.2 Hybrid Graphics

"STAMINA-SPEED" switch is designed as a software switch. This DIP switch
is located on one of the individual circuit from mainboard, separately.
For easy to understand it, just imagine such as a wireless switch on
laptop computers. Therefore, there is nothing to do; feel free to
control this switch. Follows are only suggestions within ATI models,
your style to go.

2.2.1 Disable discrete graphics on boot with a systemd unit

You can use systemd to automatically disable your discrete graphics card
on boot. You need to make a script file and a service file. You won't
need to do what's in section 2.2.2 if you do this

1) First make a script file in /usr/lib/systemd/scripts an example name
would be ati_off.

    #!/bin/bash
    echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

2) Next make a service file (ex: atioff.service) in
/usr/lib/systemd/system.

    [Unit]
    Description=Turn off the discrete graphics card on boot

    [Service]
    Type=oneshot
    ExecStart=/bin/bash /usr/lib/systemd/scripts/ati_off
    RemainAfterExit=no

    [Install]
    Wantedby=multi-user.target

Now run:

    systemctl enable atioff.service

This enables the atioff service and makes it run every time the computer
boots

2.2.2 ATI disabled on boot. Get long battery life.

If you want to get more long battery life first, take this method is
recommended.

1) mounting debugfs

    # mount -t debugfs debugfs /sys/kernel/debug

or /etc/fstab

    debugfs /sys/kernel/debug debugfs 0 0

2) disable ATI using "vga_switcheroo"

Radeon module should be loaded.

    # modprobe radeon

Power OFF ATI.

    # echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

Check status correct or not.

    cat /sys/kernel/debug/vgaswitcheroo/switch

Result;

    0:IGD:+:Pwr:0000:00:02.0

    1:DIS: :Off:0000:01:00.0

When you use these setting on boot, putting these lines into rc.local is
useful.

Warning:initscripts is obsolete systemd should be used for startup
scripts instead.

2.2.3 Use both at any time. Switchable.

If you want to use both intel and ati, commands are avaiable.

1) mounting debugfs

2) using "vga_switcheroo" Radeon module should be loaded.

Enable ATI

    # echo DDIS > /sys/kernel/debug/vgaswitcheroo/switch

Enable intel

    # echo DIGD > /sys/kernel/debug/vgaswitcheroo/switch

Power ON/OFF

    # echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
    # echo ON > /sys/kernel/debug/vgaswitcheroo/switch

Check current status

    cat /sys/kernel/debug/vgaswitcheroo/switch

2.2.3 New functions. Set variety.

For more control completely, there is a way to use various functions
which you like, e.g. setkeycode.

Please note: Unfortunatelly BIOS on this machine has no option in order
to select which cards you want to use definitly.

> 2.3 Keyboard, Automatic light sensor

There is nothing to do; within its simply works. Automatic light sensor
is located on the right side of hybrid graphics switch.

> 2.4 Touchpad

ALPS touchpad is recognized as Im/PS2 Wheel Mouse with scrolling on the
right edge. It is hard to be recognized as ALPS currently. A fix that
allows for multitouch has been provided here:
http://nwoki.wordpress.com/2012/10/02/multitouch-fix-for-alps-touchpad/

> 2.5 Fingerprint

Not tested.

> 2.6 Web Camera

Not tested.

> 2.7 TPM

Not tested.

> 2.8 Optical(Secondary Channel)

The button to open this optical drive on the top of keybaord is
available by default, power management timer is also good to work (see
3.Power Management > 3.5 Chipset, Optical, USB and more). When it
remove/replacement, you can easy to turn only 2 screws or disable from
BIOS.

> 2.9 HDD/SSD(Primary Channel)

You can easy to access in order to remove/replacement. Just open back
pannel in front of this machine, then you could see battery on the
right, memory module slot on the top-left, and 2.5 inch drive space (9mm
height) on this bottom.

Please note: Press release bar at the bottom of battery, remove it
first.

> 2.10 Display brightness, Sound volume

There is nothing to do; keyboard shortcuts with Fn key are available by
default.

> 2.11 Gravity Sensor

Not tested.

3. Power Management
-------------------

You can get battery life into 4-5 hours (HDDs), 6-7 hours and more
(SSDs), even if "ondemand" governor. You never have to give up a
performance working with built-in battery only.

> 3.1 ACPI modules

There is nothing to do. Kernel supports sony_acpi module.

> 3.2 Sandy/Ivy bridge issue

Sandy/Ivy bridge platforms have to add special options on your kernel
line for intel video power management. These options would be deprecated
for near the future.

pcie_aspm=force i915.i915_enable_rc6=1 i915.i915_enable_fbc=1
i915.lvds_downclock=1

Please note: Options should be selected by your using style, to know
what effects are expected on every option. In fact, some electric
reports show less or no evaluate battery life than ever before.

> 3.3 Hybrid Graphics

Please refer to "2. Hardware > 2.2 Hybrid Graphics" in this article.

> 3.4 Wireless (WiFi, Bluetooth, WiMAX)

Please refer to wireless wiki, in order to set power management is ON.

> 3.5 Chipset, Optical, USB and more

Tlp is comletely available and functional except ThinkPad features. To
set them manually, please refer to laptop wiki.

> 3.6 CPU

Cpufrequtils is useful to set govonors. To change voltage manually,
cpupower provides better solution currently.

Please note: If you try to use Gnome 3 with cpupower, confliction with
cpufrequtils may arouse. To avoid this, pacman "-Sddf" option is also
unfunctional. Please refer to bug report.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_vaio_VGN-SA/SB&oldid=296535"

Category:

-   Sony

-   This page was last modified on 8 February 2014, at 03:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
