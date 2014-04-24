Raspberry Pi
============

Raspberry Pi (RPi) is a minimalist computer built for the ARMv6
architecture. More information about this project and technical
specification.

Contents
--------

-   1 Article Preface
-   2 Installing Arch Linux ARM
-   3 Audio
    -   3.1 Caveats for HDMI Audio
-   4 Video
    -   4.1 HDMI / Analog TV-Out
    -   4.2 X.org driver
-   5 Onboard Hardware Sensors
    -   5.1 Temperature
    -   5.2 Voltage
    -   5.3 Lightweight Monitoring Suite
-   6 Overclocking/Underclocking
-   7 Tips for Maximizing SD Card Performance
    -   7.1 Enable TRIM and noatime by Mount Flags
    -   7.2 Move /var/log to RAM
    -   7.3 Link bash_history to /dev/null
-   8 Serial Console
-   9 Raspberry Pi Camera module
-   10 Hardware Random Number Generator
-   11 GPIO
    -   11.1 Python
-   12 See also

Article Preface
---------------

This article is not meant to be an exhaustive setup guide and assumes
that the reader has setup an Arch system before. Arch newbies are
encouraged to read the Beginners' guide if unsure how to preform
standard tasks such as creating users, managing the system, etc.

Note:Support for the ARM architecture is provided on
http://archlinuxarm.org not through posts to the official Arch Linux
Forum. Any posts related to ARM specific issues will be promptly closed
per the Arch Linux Distribution Support ONLY policy.

Installing Arch Linux ARM
-------------------------

See the Arch Linux ARM documentation.

Audio
-----

Note:The requisite module snd-bcm2835 should be autoloaded by default.

Install the alsa-utils, alsa-firmware, alsa-lib and alsa-plugins
packages:

    # pacman -S alsa-utils alsa-firmware alsa-lib alsa-plugins

Optionally adjust the default volume using alsamixer and ensure that the
sole source "PCM" is not muted (denoted by MM if muted, press M to
unmute).

Select an audio source for output:

    $ amixer cset numid=3 x

Where x corresponds to:

-   0 for Auto
-   1 for Analog out
-   3 for HDMI

> Caveats for HDMI Audio

Some applications require a setting in /boot/config.txt to force audio
over HDMI:

    hdmi_drive=2

Video
-----

> HDMI / Analog TV-Out

To turn the HDMI or analog TV-Out on or off, have a look at

    /opt/vc/bin/tvservice

Use the -s parameter to check the status of your display, the -o
parameter to turn your display off and -p parameter to power on HDMI
with preferred settings.

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

> X.org driver

The X.org driver for Raspberry Pi can be installed with the
xf86-video-fbdev package:

    # pacman -S xf86-video-fbdev

Onboard Hardware Sensors
------------------------

> Temperature

Temperatures sensors can be queried with utils in the
raspberrypi-firmware-tools package. The RPi offers a sensor on the
BCM2835 SoC (CPU/GPU):

    $ /opt/vc/bin/vcgencmd measure_temp

    temp=49.8'C

Alternatively, simply read from the file system:

    $ cat /sys/class/thermal/thermal_zone0/temp

    49768

For human readable output:

    awk '{printf "%3.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp

    54.1°C

> Voltage

Four different voltages can be monitored via /opt/vc/bin/vcgencmd as
well:

    $ /opt/vc/bin/vcgencmd measure_volts <id>

Where <id> is:

-   core for core voltage
-   sdram_c for sdram Core voltage
-   sdram_i for sdram I/O voltage
-   sdram_p for sdram PHY voltage

> Lightweight Monitoring Suite

monitorix has specific support for the RPi since v3.2.0. Screenshots
available here.

Overclocking/Underclocking
--------------------------

The RPi can be overclocked by editing /boot/config.txt, for example:

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

    $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

Tips for Maximizing SD Card Performance
---------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Very             
                           questionable tips, see   
                           also [1]. (Discuss)      
  ------------------------ ------------------------ ------------------------

> Enable TRIM and noatime by Mount Flags

Using this flag in one's /etc/fstab enables TRIM and noatime on the root
ext4 partition. For example:

    /dev/root  /  ext4  noatime,discard  0  0

Note:/dev/root entry maybe missing from your /etc/fstab; by default it
is mounted as a VFS by the kernel during system boot.

> Move /var/log to RAM

Warning:All system logs will be lost on every reboot.

Add this entry to your /etc/fstab to create a RAM disk that is 16MiB in
size:

    tmpfs   /var/log        tmpfs   nodev,nosuid,size=16M   0       0

Delete your existing log directory:

    # rm -R /var/log

Reboot system for changes to take affect.

> Link bash_history to /dev/null

Warning:Your bash history be lost at the end of each session.

    # ln -sf /dev/null ~/.bash_history

Serial Console
--------------

Edit the default /boot/cmdline.txt, change loglevel to 5 to see boot
messages:

    loglevel=5

Change speed from 115200 to 38400:

    console=ttyAMA0,38400 kgdboc=ttyAMA0,38400

Start getty service

    # systemctl start getty@ttyAMA0

Enable on boot

    # systemctl enable getty@ttyAMA0.service

Creating the proper service link:

    # ln -s /usr/lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/serial-getty@ttyAMA0.service

Then connect :)

    # screen /dev/ttyUSB0 38400

Raspberry Pi Camera module
--------------------------

The commands for the camera module are including as part of the
raspberrypi-firmware-tools package - which is installed by default. You
can then use:

    $ /opt/vc/bin/raspistill
    $ /opt/vc/bin/raspivid

You need to append to /boot/config.txt:

    start_file=start_x.elf
    fixup_file=fixup_x.dat

Optionally

    disable_camera_led=1

if you get the following error:

    mmal: mmal_vc_component_enable: failed to enable component: ENOSPC
    mmal: camera component couldn't be enabled
    mmal: main: Failed to create camera component
    mmal: Failed to run camera app. Please check for firmware updates

try setting these values in /boot/config.txt:

    cma_lwm=
    cma_hwm=
    cma_offline_start=

Hardware Random Number Generator
--------------------------------

ArchLinux ARM for the Raspberry Pi is distributed with the rng-tools
package installed and the bcm2708-rng module set to load at boot (see
this), but we must also tell the Hardware RNG Entropy Gatherer Daemon
(rngd) where to find the hardware random number generator.

This can be done by editing /etc/conf.d/rngd:

    RNGD_OPTS="-o /dev/random -r /dev/hwrng"

and restarting the rngd daemon:

    systemctl restart rngd

Once completed, this change ensures that data from the hardware random
number generator is fed into the kernel's entropy pool at /dev/random.

GPIO
----

> Python

To be able to use the GPIO pins from Python, you can use the RPi.GPIO
library.

To install it, first install the base-devel group. Download the latest
version of the library from PyPI (link above), extract it and run the
following command:

    # python setup.py install

See also
--------

-   RPi Config - Excellent source of info relating to under-the-hood
    tweaks.
-   RPi vcgencmd usage - Overview of firmware command vcgencmd.
-   Archlinux ARM on Raspberry PI - A FAQ style site with hints and tips
    for running Archlinux on the rpi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Raspberry_Pi&oldid=305115"

Category:

-   ARM architecture

-   This page was last modified on 16 March 2014, at 15:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
