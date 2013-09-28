CPU Frequency Scaling
=====================

Summary

An overview of the popular userspace tools for the kernel CPUfreq
subsystem.

Related

Laptop Mode Tools

pm-utils

PHC

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This article     
                           needs cleanup in         
                           sections: acpid,         
                           laptop-mode-tools, and   
                           bios limitations.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

cpufreq refers to the kernel infrastructure that implements CPU
frequency scaling. This technology enables the operating system to scale
the CPU speed up or down in order to save power. CPU frequencies can be
scaled automatically depending on the system load, in response to ACPI
events, or manually by userspace programs.

Since kernel 3.4 the necessary modules are loaded automatically and the
recommended ondemand governor is enabled by default. However, userspace
applications like cpupower, acpid, laptop-mode-tools, or GUI tools
provided for your desktop environment, may still be used for advanced
configuration.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Userspace tools (cpupower)                                         |
|     -   1.1 CPU frequency driver                                         |
|     -   1.2 Scaling governors                                            |
|         -   1.2.1 With cpupower                                          |
|         -   1.2.2 Without cpupower                                       |
|                                                                          |
|     -   1.3 Tuning governors (with cpupower)                             |
|         -   1.3.1 Sampling rate                                          |
|                                                                          |
|     -   1.4 Setting Maximum and Minimum Frequencies                      |
|                                                                          |
| -   2 Interaction with ACPI events                                       |
| -   3 Privilege Granting Under GNOME                                     |
| -   4 Laptop Mode Tools                                                  |
| -   5 Troubleshooting                                                    |
|     -   5.1 BIOS frequency limitation                                    |
+--------------------------------------------------------------------------+

Userspace tools (cpupower)
--------------------------

cpupower is a set of userspace utilities designed to assist with CPU
frequency scaling. The package is not required to use scaling, but is
highly recommended because it provides useful command-line utilities and
a service to change the governor at boot. The configuration file for
cpupower is located in /etc/default/cpupower. This configuration file is
read by a bash script in /usr/lib/systemd/scripts/cpupower which is
activated by systemd with cpupower.service. To enable cpupower on boot
with systemd, run

    # systemctl enable cpupower.service

A frontend for gnome-shell can be found at CPU Freq.

> CPU frequency driver

Note:As of kernel 3.4; the native cpu module is loaded automatically

cpupower requires modules (see table below) to know the limits of the
native cpu. To see a full list of available modules, run

    $ ls /lib/modules/$(uname -r)/kernel/drivers/cpufreq/

Tip:To load the module at boot, run

    # echo <module> >/etc/modules-load.d/<module>.conf

Note:Loading the wrong module will result in an error "No such device"

Load the appropriate module with

    # modprobe <module>

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Module          Description
  --------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  acpi-cpufreq    CPUFreq driver which utilizes the ACPI Processor Performance States. This driver also supports Intel Enhanced SpeedStep (previously supported by the deprecated speedstep-centrino module).

  speedstep-lib   CPUFreq drive for Intel speedstep enabled processors (mostly atoms and older pentiums (< 3))

  powernow-k8     CPUFreq driver for K8/K10 Athlon64/Opteron/Phenom processors. Deprecated since linux 3.7 - Use acpi_cpufreq.

  pcc-cpufreq     This driver supports Processor Clocking Control interface by Hewlett-Packard and Microsoft Corporation which is useful on some Proliant servers.

  p4_clockmod     CPUFreq driver for Intel Pentium 4 / Xeon / Celeron processors. When enabled it will lower CPU temperature by skipping clocks.  
                  You probably want to use a Speedstep driver instead.
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  

Once the appropriate cpufreq driver is loaded, detailed information
about the CPU(s) can be displayed by running

    $ cpupower frequency-info

> Scaling governors

Governors (see table below) are power schemes for the cpu. Only one may
be active at a time. For details, see the official documentation in the
kernel source.

Note:The kernel loads on_demand by default.

  Module                 Description
  ---------------------- ----------------------------------------------------------------
  cpufreq_ondemand       Dynamically switch between CPU(s) available if at 95% cpu load
  cpufreq_performance    Run the cpu at max frequency
  cpufreq_conservative   Dynamically switch between CPU(s) available if at 75% load
  cpufreq_powersave      Run the cpu at the minimum frequency
  cpufreq_userspace      Run the cpu at user specified frequencies

  

Tip: To monitor cpu speed in real time, run:

    $ watch grep \"cpu MHz\" /proc/cpuinfo

With cpupower

To load and activate a particular governor, one should run

    # cpupower frequency-set -g <governor_without cpufreq_>

Without cpupower

Tip:To load a governor at boot, run

    # echo <module> > /etc/modules-load.d/<module>

To load a particular governor, one should run

    # modprobe <governor>

> Tuning governors (with cpupower)

Tip:Add the following commands below to /etc/default/cpupower. <percent>
is the percentage of cpu load; <governor> is the cpupower governor

To set the threshold for stepping up to another frequency

    # echo -n <percent> > /sys/devices/system/cpu/cpufreq/<governor>/up_threshold

To set the threshold for stepping down to another frequency

    # echo -n <percent> > /sys/devices/system/cpu/cpufreq/<governor>/down_threshold

Sampling rate

The sampling rate determines how frequently the governor checks to tune
the cpu Setting sampling_down_factor greater than 1 improves performance
by reducing the overhead of load evaluation and keeping the CPU at its
highest clock frequency due to high load. This tunable has no effect on
behavior at lower CPU frequencies/loads.

To read the value (default = 1), run

    $ cat /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor

To set the value, run

    # echo -n <value> > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor

> Setting Maximum and Minimum Frequencies

Note:The governor, maximum, and minimum frequencies can be set in
/etc/default/cpupower. To adjust for only a single cpu core:
 -c <core #>. <clock_freq> is a clock frequency with units : GHz,MHz

To set the maximum clock frequency

    # cpupower frequency-set -u <clock_freq>

To set the minimum clock frequency

    # cpupower frequency-set -d <clock_freq>

To set the cpu to run at a specified frequency

    # cpupower frequency-set -f <clock_freq>

Interaction with ACPI events
----------------------------

Users may configure scaling governors to switch automatically based on
different ACPI events such as connecting the AC adapter or closing a
laptop lid. A quick example is given below, however it may be worth
reading full article on acpid.

Events are defined in /etc/acpi/handler.sh. If the acpid package is
installed, the file should already exist and be executable. For example,
to change the scaling governor from performance to conservative when the
AC adapter is disconnected and change it back if reconnected:

    /etc/acpi/handler.sh

    [...]

     ac_adapter)
         case "$2" in
             AC*)
                 case "$4" in
                     00000000)
                         echo "conservative" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor    
                         echo -n $minspeed >$setspeed
                         #/etc/laptop-mode/laptop-mode start
                     ;;
                     00000001)
                         echo "performance" >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                         echo -n $maxspeed >$setspeed
                         #/etc/laptop-mode/laptop-mode stop
                     ;;
                 esac
             ;;
             *) logger "ACPI action undefined: $2" ;;
         esac
     ;;

    [...]

  

Privilege Granting Under GNOME
------------------------------

Note:Systemd introduced logind which handles consolekit and policykit
actions. The following code below does not work

GNOME has a nice applet to change the governor on the fly. To use it
without the need to enter the root password, simply create
/var/lib/polkit-1/localauthority/50-local.d/org.gnome.cpufreqselector.pkla
and populate it with the following:

    [org.gnome.cpufreqselector]
    Identity=unix-user:USER
    Action=org.gnome.cpufreqselector
    ResultAny=no
    ResultInactive=no
    ResultActive=yes

0

Where the word USER is replaced with the username of interest.

The desktop-privileges package in the AUR contains a similar .pkla file
for authorizing all users of the power group to change the governor.

Laptop Mode Tools
-----------------

If you are already using or plan to use Laptop Mode Tools for other
power saving solutions, then you may want to let it also manage CPU
frequency scaling. To do so, you just have to insert the appropriate
frequency driver to the /etc/modules.d/ directory. (see #CPU frequency
driver above) and then go through the
/etc/laptop-mode/conf.d/cpufreq.conf file to define governors,
frequencies and policies. You will not need to load other modules and
daemons or to set up scaling governors and interaction with ACPI events.
Please refer to Laptop Mode Tools for more details.

Troubleshooting
---------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

-   Some applications, like ntop, do not respond well to automatic
    frequency scaling. In the case of ntop it can result in segmentation
    faults and lots of lost information as even the on-demand governor
    cannot change the frequency quickly enough when a lot of packets
    suddenly arrive at the monitored network interface that cannot be
    handled by the current processor speed.

-   Some CPU's may suffer from poor performance with the default
    settings of the on-demand governor (e.g. flash videos not playing
    smoothly or stuttering window animations). Instead of completely
    disabling frequency scaling to resolve these issues, the
    aggressiveness of frequency scaling can be increased by lowering the
    up_threshold sysctl variable for each CPU. See #Changing the
    on-demand governor's threshold.

-   Sometimes the on-demand governor may not throttle to the maximum
    frequency but one step below. This can be solved by setting max_freq
    value slightly higher than the real maximum. For example, if
    frequency range of the CPU is from 2.00 GHz to 3.00 GHz, setting
    max_freq to 3.01 GHz can be a good idea.

-   Some combinations of ALSA drivers and sound chips may cause audio
    skipping as the governor changes between frequencies, switching back
    to a non-changing governor seems to stop the audio skipping.

> BIOS frequency limitation

Some CPU/BIOS configurations may have difficulties to scale to the
maximum frequency or scale to higher frequencies at all. This is most
likely caused by BIOS events telling the OS to limit the frequency
resulting in /sys/devices/system/cpu/cpu0/cpufreq/bios_limit set to a
lower value.

Either you just made a specific Setting in the BIOS Setup Utility,
(Frequency, Thermal Management, etc.) you can blame a buggy/outdated
BIOS or the BIOS might have a serious reason for throttling the CPU on
it's own.

Reasons like that can be (assuming your machine's a notebook) that the
battery is removed (or near death) so you're on AC-power only. In this
case a weak AC-source might not supply enough electricity to fulfill
extreme peak demands by the overall system and as there is no battery to
assist this could lead to data loss, data corruption or in worst case
even hardware damage!

Not all BIOS'es limit the CPU-Frequency in this case, but for example
most IBM/Lenove Thinkpads do. Refer to thinkwiki for more thinkpad
related info on this topic.

If you checked there's not just an odd BIOS setting and you know what
you're doing you can make the Kernel ignore these BIOS-limitations.

Warning:Make sure you read and understood the section above. CPU
frequency limitation is a safety feature of your BIOS and you should not
need to work around it.

A special parameter has to be passed to the processor module.

For trying this temporarily change the value in
/sys/module/processor/parameters/ignore_ppc from 0 to 1.

For setting it permanent refer to Kernel modules or just read on. Add
processor.ignore_ppc=1 to your kernel boot line or create

    /etc/modprobe.d/ignore_ppc.conf

    # If the frequency of your machine gets wrongly limited by BIOS, this should help
    options processor ignore_ppc=1

Retrieved from
"https://wiki.archlinux.org/index.php?title=CPU_Frequency_Scaling&oldid=254959"

Categories:

-   Power management
-   CPU
