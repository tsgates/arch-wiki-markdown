Raspberry Pi
============

Summary

Raspberry Pi is a minimalist computer built for the ARMv6 architecture.
More information about this project and technical specification.

Related

Beginners'_Guide

RPi Config - Excellent source of info relating to under-the-hood tweaks.

RPi vcgencmd usage - Overview of firmware command vcgencmd.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Article Preface                                                    |
| -   2 Installing Arch Linux ARM                                          |
| -   3 Audio                                                              |
|     -   3.1 Caveats for HDMI Audio                                       |
|                                                                          |
| -   4 Onboard Hardware Sensors                                           |
|     -   4.1 Temperature                                                  |
|     -   4.2 Voltage                                                      |
|                                                                          |
| -   5 Overclocking/Underclocking                                         |
| -   6 Serial Console                                                     |
| -   7 Video                                                              |
+--------------------------------------------------------------------------+

Article Preface
---------------

This article is not meant to be an exhaustive setup guide and assumes
that the reader has setup an Arch system before. Arch newbies are
encouraged to read the Beginners'_Guide if unsure how to preform
standard tasks such as creating users, managing the system, etc.

Note:Support for the ARM architecture is provided on
http://archlinuxarm.org not through posts to the official Arch Linux
Forum. Any posts related to ARM specific issues will be promptly closed
per the Arch_Linux_Distrubution_Support_ONLY policy.

Installing Arch Linux ARM
-------------------------

See the archlinuxarm documentation.

Audio
-----

Note: The requisite module snd-bcm2835 should be autoloaded by default.

Install the needed packages:

    pacman -S alsa-utils alsa-firmware alsa-lib alsa-plugins

Optionally adjust the default volume using `alsamixer` and ensure that
the sole source "PCM" is not muted (denoted by double MM if muted).

Select an audio source for output:

    amixer cset numid=3 x

Where 'x' corresponds to:

-   0 for Auto
-   1 for Analog out
-   3 for HDMI

> Caveats for HDMI Audio

Some applications require a setting in /boot/config.txt to force audio
over HDMI:

    hdmi_drive=2

Onboard Hardware Sensors
------------------------

> Temperature

Temperatures sensors for the board itself are including as part of the
raspberrypi-firmware-tools package. The RPi offers a sensor on the
BCM2835 SoC (CPU/GPU):

    /opt/vc/bin/vcgencmd measure_temp
    temp=49.8'C

Alternatively, simply read from the filesystem:

    % cat /sys/class/thermal/thermal_zone0/temp                
    49768

> Voltage

Four different voltages can be monitored via /opt/vc/bin/vcgencmd as
well:

    % /opt/vc/bin/vcgencmd measure_volts <id>

-   core for core voltage
-   sdram_c for sdram Core voltage
-   sdram_i for sdram I/O voltage
-   sdram_p for sdram PHY voltage

Overclocking/Underclocking
--------------------------

The Raspberry Pi can be overclocked by editing /boot/config.txt, for
example:

    arm_freq=800
    arm_freq_min=100
    core_freq=300
    core_freq_min=75
    sdram_freq=400
    over_voltage=0

The optional xxx_min lines define the min usage of their respective
settings. When the system is not under load, the values will drop down
to those specified. Consult the Overclocking article on elinux for
additional options and examples.

A reboot is needed for new settings to take effect.

Note:The overclocked setting for CPU clock applies only when the
governor throttles up the CPU, i.e. under load.

Users may query the current frequency of the CPU via this command:

    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

Serial Console
--------------

Edit the default /boot/cmdline.txt

Change loglevel to 5 to see boot messages

    loglevel=5

Change speed from 115200 to 38400

    console=ttyAMA0,38400 kgdboc=ttyAMA0,38400

Start getty service

    systemctl start getty@ttyAMA0

Enable on boot

    systemctl enable getty@ttyAMA0.service

Creating the proper service link:

    ln -s /usr/lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyAMA0.service

Then connect :)

    screen /dev/ttyUSB0 38400

Video
-----

    pacman -S xf86-video-fbdev

Adjustments are likely required to correct proper overscan/underscan and
are easily achieved in boot/config.txt in which many tweaks are set. To
fix, simply uncomment the corresponding lines and setup per the
commented instructions:

    # uncomment the following to adjust overscan. Use positive numbers if console
    # goes off screen, and negative if there is too much border
    #overscan_left=16
    overscan_right=8
    overscan_top=-16
    overscan_bottom=-16

Users wishing to use the analog video out should consult this config
file which contains options for non-NTSC outputs.

A reboot is needed for new settings to take effect.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Raspberry_Pi&oldid=255335"

Category:

-   Getting and installing Arch
