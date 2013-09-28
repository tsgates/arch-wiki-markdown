lm sensors
==========

lm_sensors (Linux monitoring sensors) is a free and open-source
application that provides tools and drivers for monitoring temperatures,
voltage, and fans. This document explains how to install, configure, and
use lm_sensors so that you can monitor CPU temperatures, motherboard
temperatures, and fan speeds.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Usage                                                              |
|     -   1.1 Installation                                                 |
|     -   1.2 Setting up lm_sensors                                        |
|     -   1.3 Automatic lm_sensors deployment                              |
|     -   1.4 Testing your lm_sensors                                      |
|     -   1.5 Reading SPD values from memory modules (optional)            |
|                                                                          |
| -   2 Using sensor data                                                  |
|     -   2.1 Graphical Front-ends                                         |
|     -   2.2 sensord                                                      |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Renumbering Cores for Multi-CPU Systems                      |
|         -   3.1.1 Step 1. ID what each chip is reporting                 |
|         -   3.1.2 Step 2. Redefine the cores                             |
|                                                                          |
|     -   3.2 Sensors not working since Linux 2.6.31                       |
|     -   3.3 K10Temp Module                                               |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Usage
-----

> Installation

Install the lm_sensors package from the official repositories.

> Setting up lm_sensors

Use sensors-detect to detect and generate a list of kernel modules:

    # sensors-detect

This will create the /etc/conf.d/lm_sensors configuration file which is
used by the sensors daemon to automatically load kernel modules on boot.
You will be asked if you want to probe for various hardware. The "safe"
answers are the defaults, so just hitting Enter to all the questions
will generally not cause any problems.

When the detection is finished, you will be presented with a summary of
the probes. Here is an example summary from my system:

    # sensors-detect

    Now follows a summary of the probes I have just done.
    Just press ENTER to continue:
    Driver `it87':
      * ISA bus, address 0x290
         Chip `ITE IT8718F Super IO Sensors' (confidence: 9)
    Driver `coretemp':
      * Chip `Intel Core family thermal sensor' (confidence: 9)

If you plan on using the daemon, be sure to answer YES when asked if you
want to to generate /etc/conf.d/lm_sensors.

To automatically load the kernel modules at boot time:

    systemctl enable lm_sensors.service

Alternatively, instead of using the daemon, you can add the modules to
the MODULES array in /etc/modules-load.d/lm_sensors.conf:

    coretemp
    it87
    acpi-cpufreq

> Automatic lm_sensors deployment

If you wish to deploy lm-sensors on multiple diferent linux machines
issue is that sensors-detect ask you quite a few questions. There are
few tricks that you can use to automate replies.

First one is if you wish to accept defaults which sensors-detect suggest
you need just to press [ENTER] all the time. To automate this use this
one liner:

    # yes "" | sensors-detect

If you wish to override defaults and answer YES to all questions then
use this oneliner:

    # yes | sensors-detect

> Testing your lm_sensors

To test your setup, load the kernel modules manually or by using the
/etc/rc.d/sensors init script. You do NOT have to do both. Example
manually adding them

    # modprobe it87
    # modprobe coretemp

Example using the script

    # systemctl start lm_sensors

You should see something like this when you run sensors

    $ sensors

    coretemp-isa-0000
    Adapter: ISA adapter
    Core 0:      +30.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0001
    Adapter: ISA adapter
    Core 1:      +30.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0002
    Adapter: ISA adapter
    Core 2:      +32.0°C  (high = +76.0°C, crit = +100.0°C)  

    coretemp-isa-0003
    Adapter: ISA adapter
    Core 3:      +30.0°C  (high = +76.0°C, crit = +100.0°C)  

    it8718-isa-0290
    Adapter: ISA adapter
    in0:         +1.17 V  (min =  +0.00 V, max =  +4.08 V)   
    in1:         +1.31 V  (min =  +1.28 V, max =  +1.68 V)   
    in2:         +3.28 V  (min =  +2.78 V, max =  +3.78 V)   
    in3:         +2.88 V  (min =  +2.67 V, max =  +3.26 V)   
    in4:         +2.98 V  (min =  +2.50 V, max =  +3.49 V)   
    in5:         +1.34 V  (min =  +0.58 V, max =  +1.34 V)   ALARM
    in6:         +2.02 V  (min =  +1.04 V, max =  +1.36 V)   ALARM
    in7:         +2.83 V  (min =  +2.67 V, max =  +3.26 V)   
    Vbat:        +3.28 V
    fan1:       1500 RPM  (min = 3245 RPM)  ALARM
    fan2:          0 RPM  (min = 3245 RPM)  ALARM
    fan3:          0 RPM  (min = 3245 RPM)  ALARM
    temp1:       +18.0°C  (low  = +127.0°C, high = +64.0°C)  sensor = thermal diode
    temp2:       +32.0°C  (low  = +127.0°C, high = +64.0°C)  sensor = thermistor
    temp3:       +38.0°C  (low  = +127.0°C, high = +64.0°C)  sensor = thermistor
    cpu0_vid:   +2.050 V

    acpitz-virtual-0
    Adapter: Virtual device
    temp1:       +18.0°C  (crit = +64.0°C)

> Reading SPD values from memory modules (optional)

To read the SPD timing values from your memory modules, install
i2c-tools from the official repositories. Once you have i2c-tools
installed, you will need to load the eeprom kernel module.

    # modprobe eeprom

Finally, you can view your memory information with decode-dimms.

Here is partial output from one machine:

    $ decode-dimms

    # decode-dimms version 5733 (2009-06-09 13:13:41 +0200)

    Memory Serial Presence Detect Decoder
    By Philip Edelbrock, Christian Zuckschwerdt, Burkart Lingner,
    Jean Delvare, Trent Piepho and others


    Decoding EEPROM: /sys/bus/i2c/drivers/eeprom/0-0050
    Guessing DIMM is in                             bank 1

    ---=== SPD EEPROM Information ===---
    EEPROM CRC of bytes 0-116                       OK (0x583F)
    # of bytes written to SDRAM EEPROM              176
    Total number of bytes in EEPROM                 512
    Fundamental Memory type                         DDR3 SDRAM
    Module Type                                     UDIMM

    ---=== Memory Characteristics ===---
    Fine time base                                  2.500 ps
    Medium time base                                0.125 ns
    Maximum module speed                            1066MHz (PC3-8533)
    Size                                            2048 MB
    Banks x Rows x Columns x Bits                   8 x 14 x 10 x 64
    Ranks                                           2
    SDRAM Device Width                              8 bits
    tCL-tRCD-tRP-tRAS                               7-7-7-33
    Supported CAS Latencies (tCL)                   8T, 7T, 6T, 5T

    ---=== Timing Parameters ===---
    Minimum Write Recovery time (tWR)               15.000 ns
    Minimum Row Active to Row Active Delay (tRRD)   7.500 ns
    Minimum Active to Auto-Refresh Delay (tRC)      49.500 ns
    Minimum Recovery Delay (tRFC)                   110.000 ns
    Minimum Write to Read CMD Delay (tWTR)          7.500 ns
    Minimum Read to Pre-charge CMD Delay (tRTP)     7.500 ns
    Minimum Four Activate Window Delay (tFAW)       30.000 ns

    ---=== Optional Features ===---
    Operable voltages                               1.5V
    RZQ/6 supported?                                Yes
    RZQ/7 supported?                                Yes
    DLL-Off Mode supported?                         No
    Operating temperature range                     0-85C
    Refresh Rate in extended temp range             1X
    Auto Self-Refresh?                              Yes
    On-Die Thermal Sensor readout?                  No
    Partial Array Self-Refresh?                     No
    Thermal Sensor Accuracy                         Not implemented
    SDRAM Device Type                               Standard Monolithic

    ---=== Physical Characteristics ===---
    Module Height (mm)                              15
    Module Thickness (mm)                           1 front, 1 back
    Module Width (mm)                               133.5
    Module Reference Card                           B

    ---=== Manufacturer Data ===---
    Module Manufacturer                             Invalid
    Manufacturing Location Code                     0x02
    Part Number                                     OCZ3G1600LV2G     

    ...

Using sensor data
-----------------

> Graphical Front-ends

There are a variety of front-ends for sensors data.

-   xsensors - X11 interface to lm_sensors
-   xfce4-sensors-plugin - A lm_sensors plugin for the Xfce panel
-   conky - Conky is an advanced, highly configurable system monitor for
    X based on torsmo
-   kdeutils-superkaramba - Superkaramba is a tool which gives
    posibility to create different widgets for KDE desktop. Check the
    karamba section on kde-look.org for examples of making karamba
    front-ends for sensors data.
-   sensors-applet - applet for the GNOME Panel to display readings from
    hardware sensors, including CPU temperature, fan speeds and voltage
    readings.

> sensord

There is an optional daemon called sensord (included with the lm_sensors
package) which can log your data to a round robin database (rrd) and
later visualize graphically. See the sensord man page for details.

Troubleshooting
---------------

> Renumbering Cores for Multi-CPU Systems

In rare cases, the actual numbering of physical cores on multi-processor
motherboards can be incorrect. Consider the following HP Z600
workstation with dual Xeons:

    $ sensors

    coretemp-isa-0000
    Adapter: ISA adapter
    Core 0:       +65.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 1:       +65.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 9:       +66.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 10:      +66.0°C  (high = +85.0°C, crit = +95.0°C)

    coretemp-isa-0004
    Adapter: ISA adapter
    Core 0:       +54.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 1:       +56.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 9:       +60.0°C  (high = +85.0°C, crit = +95.0°C)
    Core 10:      +61.0°C  (high = +85.0°C, crit = +95.0°C)

    smsc47b397-isa-0480
    Adapter: ISA adapter
    fan1:        1730 RPM
    fan2:        1746 RPM
    fan3:        1224 RPM
    fan4:        2825 RPM
    temp1:        +46.0°C
    temp2:        +37.0°C
    temp3:        +23.0°C
    temp4:       -128.0°C

Note the cores are numbered 0, 1, 9, 10 which is repeated into the
second CPU. Most users want the core temperatures to report out in
sequential order, i.e. 0,1,2,3,4,5,6,7. Fixing the order is accomplished
in two steps.

Step 1. ID what each chip is reporting

Run sensors with the -u switch to see what options are available for
each physical chip:

    $ sensors -u coretemp-isa-0000

    coretemp-isa-0000
    Adapter: ISA adapter
    Core 0:
      temp2_input: 61.000
      temp2_max: 85.000
      temp2_crit: 95.000
      temp2_crit_alarm: 0.000
    Core 1:
      temp3_input: 61.000
      temp3_max: 85.000
      temp3_crit: 95.000
      temp3_crit_alarm: 0.000
    Core 9:
      temp11_input: 62.000
      temp11_max: 85.000
      temp11_crit: 95.000
    Core 10:
      temp12_input: 63.000
      temp12_max: 85.000
      temp12_crit: 95.000

    $ sensors -u coretemp-isa-0004

    coretemp-isa-0004
    Adapter: ISA adapter
    Core 0:
      temp2_input: 53.000
      temp2_max: 85.000
      temp2_crit: 95.000
      temp2_crit_alarm: 0.000
    Core 1:
      temp3_input: 54.000
      temp3_max: 85.000
      temp3_crit: 95.000
      temp3_crit_alarm: 0.000
    Core 9:
      temp11_input: 59.000
      temp11_max: 85.000
      temp11_crit: 95.000
    Core 10:
      temp12_input: 59.000
      temp12_max: 85.000
      temp12_crit: 95.000

Step 2. Redefine the cores

Create /etc/sensors.d/cores.conf wherein the new definitions are defined
based on the output of step 1:

    /etc/sensors.d/cores.conf

    chip "coretemp-isa-0000"

        label temp2 "Core 0"
        label temp3 "Core 1"
        label temp11 "Core 2"
        label temp12 "Core 3"

    chip "coretemp-isa-0004"

        label temp2 "Core 4"
        label temp3 "Core 5"
        label temp11 "Core 6"
        label temp12 "Core 7"

Problem solved. Output after completing these steps:

    $ sensors

    coretemp-isa-0000
    Adapter: ISA adapter
    Core0:        +64.0°C  (high = +85.0°C, crit = +95.0°C)
    Core1:        +63.0°C  (high = +85.0°C, crit = +95.0°C)
    Core2:        +65.0°C  (high = +85.0°C, crit = +95.0°C)
    Core3:        +66.0°C  (high = +85.0°C, crit = +95.0°C)

    coretemp-isa-0004
    Adapter: ISA adapter
    Core4:        +53.0°C  (high = +85.0°C, crit = +95.0°C)
    Core5:        +54.0°C  (high = +85.0°C, crit = +95.0°C)
    Core6:        +59.0°C  (high = +85.0°C, crit = +95.0°C)
    Core7:        +60.0°C  (high = +85.0°C, crit = +95.0°C)

    smsc47b397-isa-0480
    Adapter: ISA adapter
    fan1:        1734 RPM
    fan2:        1726 RPM
    fan3:        1222 RPM
    fan4:        2827 RPM
    temp1:        +45.0°C  
    temp2:        +37.0°C  
    temp3:        +23.0°C  
    temp4:       -128.0°C  

> Sensors not working since Linux 2.6.31

A change in version 2.6.31 has made some sensors stop working. See this
FAQ entry for a detailed explanation and for some example errors. To fix
sensors, add the following kernel parameters:

    acpi_enforce_resources=lax

Warning:In some situations, this may be dangerous. Consult the FAQ for
details.

Note that in most cases the information is still accessible via other
modules (e.g. via ACPI modules) for the hardware in question. Many
utilities and monitors (e.g. /usr/bin/sensors) can gather information
from either source. Where possible, this is the preferred solution.

> K10Temp Module

Some K10 processors have issues with their temperature sensor. From the
kernel documentation (linux-<version>/Documentation/hwmon/k10temp):

All these processors have a sensor, but on those for Socket F or AM2+,
the sensor may return inconsistent values (erratum 319). The driver will
refuse to load on these revisions unless you specify the force=1 module
parameter.

Due to technical reasons, the driver can detect only the mainboard's
socket type, not the processor's actual capabilities. Therefore, if you
are using an AM3 processor on an AM2+ mainboard, you can safely use the
force=1 parameter.

On affected machines the module will report "unreliable CPU thermal
sensor; monitoring disabled". If you still want to use the module you
can:

    # rmmod k10temp
    # modprobe k10temp force=1

Confirm with Lm_sensors#Testing your lm_sensors that the sensor is in
fact valid and reliable. If it is, you can edit
/etc/modprobe.d/k10temp.conf and add:

    options k10temp force=1

This will allow the module to load at boot.

See also
--------

-   hddtemp - Software to read temperatures of hard drives.
-   monitorix - Monitorix is a free, open source, lightweight system
    monitoring tool designed to monitor as many services and system
    resources as possible.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lm_sensors&oldid=255223"

Categories:

-   Status monitoring and notification
-   CPU
