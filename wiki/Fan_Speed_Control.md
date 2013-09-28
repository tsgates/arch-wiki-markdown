Fan Speed Control
=================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: This is a        
                           bare-bones article.      
                           Additional details would 
                           help new users.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

Fancontrol, part of lm_sensors, can be used to control the speed and
sound of CPU/case fans. This article covers configuration/setup of the
utility

Related

Lm_sensors

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preface                                                            |
| -   2 lm-sensors                                                         |
|     -   2.1 Increasing fan_div                                           |
|                                                                          |
| -   3 pwmconfig                                                          |
|     -   3.1 Tweaking                                                     |
|                                                                          |
| -   4 fancontrol                                                         |
+--------------------------------------------------------------------------+

> Preface

Support for newer motherboards may not yet be in the linux kernel. Check
the official lm-sensors devices table to see if experimental drivers are
available for such motherboards. At the time this statement was written
for example, support for the Asus P8Z77 series of motherboards was not
mainlined, yet nct677x-git was available in the AUR.

It is recommended not to use lm_sensors.service to load the needed
modules for fancontrol. Instead, manually place them in
/etc/modules-load.d/load_these.conf since the order in which these
modules are loaded dictate the order in which the needed symlinks for
hwmon get created. In other words, using the lm_sensors.service causes
inconsistencies boot-to-boot which will render the configuration file
for fancontrol worthless for a consistency point of view.

For more, see this thread:
https://bbs.archlinux.org/viewtopic.php?pid=1251766

> lm-sensors

Set up lm_sensors.

    $ sensors
    coretemp-isa-0000
    Adapter: ISA adapter
    Core 0:      +29.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0001
    Adapter: ISA adapter
    Core 1:      +29.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0002
    Adapter: ISA adapter
    Core 2:      +31.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0003
    Adapter: ISA adapter
    Core 3:      +29.0°C  (high = +76.0°C, crit = +100.0°C)  

    it8718-isa-0290
    Adapter: ISA adapter
    Vcc:         +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
    VTT:         +2.08 V  (min =  +0.00 V, max =  +4.08 V)   
    +3.3V:       +3.33 V  (min =  +0.00 V, max =  +4.08 V)   
    NB Vcore:    +0.03 V  (min =  +0.00 V, max =  +4.08 V)   
    VDRAM:       +2.13 V  (min =  +0.00 V, max =  +4.08 V)   
    fan1:        690 RPM  (min =   10 RPM)
    temp1:       +37.5°C  (low  = +129.5°C, high = +129.5°C)  sensor = thermistor
    temp2:       +25.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = thermal diode

If the output does not display an RPM value for the CPU fan, one may
need to increase the fan divisor. If fan speed is shown and higher than
0, skip the next step.

Increasing fan_div

The first line of the sensors output is the chipset used by the
motherboard for readings of temperatures and voltages.

Edit /etc/sensors.d/sensors.conf and look up the exact chipset. A few
chipset names are similar, so make sure the one to edit is correct. Add
the line 'set fanX_div 4' near the start of the chipset config,
replacing X with the number of CPU fans in the target system.

Save the file, and run as root:

    # sensors -s

which will reload the sensors.conf's set variables. Run sensors again
and check if there is an RPM readout. If not, increase the divisor to 8,
16 or 32. YMMV!

> pwmconfig

Note:Advanced users may want to skip this section and write
/etc/fancontrol on their own, which also saves them from hearing all of
the fans at full speed.

Once sensors is properly configured, run pwmconfig to test and configure
speed control. Follow the instructions in pwmconfig to set up basic
speeds. The default configuration options should create a new file,
/etc/fancontrol.

Tweaking

Warning:Some of the steps outlined below describe how to tweak fan
speeds. Before doing this be sure to have a low CPU load.

Note:On several systems, the included script may report errors as it
trys to calibrate fans to the respective PWM. Users may safely ignore
these errors. The problem is that the script does not wait long enough
before ramping up or down the PWM.

Users wishing more more control may need to tweak the generated
configuration. Here is a sample configuration file:

    INTERVAL=10
    DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon2=devices/platform/w83627ehf.656
    DEVNAME=hwmon0=coretemp hwmon2=w83627dhg
    FCTEMPS=hwmon0/device/pwm1=hwmon0/device/temp1_input
    FCFANS= hwmon0/device/pwm1=hwmon0/device/fan1_input
    MINTEMP=hwmon0/device/pwm1=20
    MAXTEMP=hwmon0/device/pwm1=55
    MINSTART=hwmon0/device/pwm1=150
    MINSTOP=hwmon0/device/pwm1=105

-   INTERVAL: how often the daemon should poll CPU temps and adjust fan
    speeds. INTERVAL is in seconds.

The rest of the configuration file is split into (at least) two values
per configuration option. Each configuration option first points to a
PWM device which is written to which sets the fan speed. The second
"field" is the actual value to set. This allows monitoring and
controlling multiple fans and temperatures.

-   FCTEMPS: The temperature input device to read for cpu temperature.
    The above example corresponds to
    /sys/class/hwmon/hwmon0/device/temp1_input.
-   FCFANS: The current fan speed, which can be read (like the
    temperature) in /sys/class/hwmon/hwmon0/device/fan1_input
-   MINTEMP: The temperature (°C) at which to SHUT OFF the CPU fan.
    Efficient CPUs often will not need a fan while idling. Be sure to
    set this to a temperature that you know is safe. Setting this to 0
    is not recommended and may ruin your hardware!
-   MAXTEMP: The temperature (°C) at which to spin the fan at its
    MAXIMUM speed. This should be probably be set to perhaps 10 or 20
    degrees (°C) below your CPU's critical/shutdown temperature. Setting
    it closer to MINTEMP will result in higher fan speeds overall.
-   MINSTOP: The PWM value at which your fan stops spinning. Each fan is
    a little different. Power tweakers can echo different values
    (between 0 and 255) to /sys/class/hwmon/hwmon0/device/pwm1 and then
    watch the CPU fan. When the CPU fan stops, use this value.
-   MINSTART: The PWM value at which your fan starts to spin again. This
    is often a higher value than MINSTOP as more voltage is required to
    overcome inertia.

There are also two settings fancontrol needs to verify the configuration
file is still up to date. The lines start with the setting name and a
equality sign, followed by groups of hwmon-class-device=setting,
seperated by spaces. You need to specify each setting for each hwmon
class device you use anywhere in the config, or fancontrol will not
work.

-   DEVPATH: Sets the physical device. You can determine this by
    executing the command

    readlink -f /sys/class/hwmon/<hwmon-device>/device | sed -e 's/^\/sys\///'

-   DEVNAME: Sets the name of the device. Try

    cat /sys/class/hwmon/<hwmon-device>/device/name | sed -e 's/[[:space:]=]/_/g'

Tip:Use MAXPWM and MINPWM options that limit fan speed range. See
man fancontrol for details.

> fancontrol

Try to run fancontrol:

    # /usr/sbin/fancontrol

A properly configured setup will not error out and will take control of
system fans. Users should hear system fans slowing shortly after
executing this command.

Note:For Dell Latitude/Inspiron laptops, i8kutils/i8kmon are available.
Note that these two packages do not work on the Inspiron 1764.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fan_Speed_Control&oldid=252371"

Category:

-   CPU
