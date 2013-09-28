Powernowd
=========

Powernowd is a very simple daemon that will adjust the speed of your CPU
depending on system load.

Warning:This software, while may still work fine on modern kernels, is
no longer in active development and likely less efficent than using
cpufreq's ondemand governor. Using the cpufreq-ondemand kernel module is
preferable over powernowd. See CPU Frequency Scaling for more
information on using the cpufreq-ondemand kernel module.

Note:Don't let the name fool you. Despite being named after AMD's
PowerNow! technology, it should work on any system supported by the
cpufreq-userspace governor.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Obsolescent Note                                                   |
| -   2 Features                                                           |
| -   3 Installation                                                       |
|     -   3.1 Prerequisites                                                |
|     -   3.2 Installation of Powernowd                                    |
|                                                                          |
| -   4 Basic Configuration                                                |
+--------------------------------------------------------------------------+

> Obsolescent Note

Although elegant, this software is actually obsolete. One can achieve
the same effect with the cpufreq-ondemand kernel module and adjusting
the ondemand governor's threshold. See CPU Frequency Scaling for more
information.

> Features

-   One, simple heuristic to determine CPU load: "user + sys" time.
-   Ignore "niced" programs (setiathome, itself, etc). In my mind this
    is consistent with what is meant when someone 'nice's a program to
    begin with. (configurable in v0.85+)
-   Designed for CPU's that support more then two speed states, but
    works well with anything.
-   Very fast, low overhead /proc/stat gathering (method stolen from
    procps).
-   Supports SMP
-   Will automatically switch to 'userspace' governor.
-   Care taken to make the code non-root exploitable (but please audit
    for yourself first!)
-   Frequency step size is configurable (default to 100MHz/step)
-   4 different behavioral modes to choose from (SINE, AGGRESSIVE,
    PASSIVE, LEAPS), which determine the behavior when the load changes.
    Configurable from the command line.
-   Written in C for speed and simplicity.
-   Logging to stdout or syslog
-   Configurable Polling frequency in milliseconds (defaults to 1s)
-   Configurable highwater/lowwater marks for CPU usage. (defaults
    80/20%)

Installation
------------

> Prerequisites

In order for frequency scaling to work properly, you will need to load
the appropriate frequency driver for your processor as well as the
cpufreq-userspace governor. See CPU Frequency Scaling.

> Installation of Powernowd

This package is available in the AUR: powernowd. If you haven't used the
AUR before, you may want to check out AUR_User_Guidelines at your
leisure as there are a wealth of great software there for you, and
building the package on your machine is trivial. Install 'powernowd',
then start the daemon:

    # /etc/rc.d/powernowd start

To have it automatically load at startup, add powernowd to your DAEMONS
array in /etc/rc.conf.

    DAEMONS=( ... powernowd ... )

Basic Configuration
-------------------

The only configuration you need is to set the highwater/lowwater marks
for CPU usage. Basically this means when the CPU usage is >=highwater
mark, then powernowd will use your highest CPU multiplier (i.e. full
power); when the CPU usage <=lowwater mark, then powernowd will use your
lowest CPU multiplier. The defaults are 80/20% but I find that adjusting
them down gives me a more responsive system. I use 15/5% for example. To
do so edit your /etc/conf.d/powernowd inserting the following line:

    OPTIONS="-q -u 15 -l 5"

Restart the daemon and enjoy

    # /etc/rc.d/powernowd restart

There are other options you can set such as modes of operation (sine,
passive, aggressive, leaps), polling frequency, number of threads per
core, etc. To see what is available, invoke powernowd with the -h switch

    $ powernowd -h
    PowerNow Daemon v1.00, (c) 2003-2008 John Clemens
    Daemon to control the speed and voltage of cpus.

    This is a simple client to the CPUFreq driver, and uses
    linux kernel v2.5+ sysfs interface.  You need a supported
    cpu, and a kernel that supports sysfs to run this daemon.

    Available Options:
     	-h	Print this help message 
    	-d	Don't detach from terminal (default is to
    		detach and run in the background)
    	-v	Increase output verbosity, can be used more than once.
    	-q	Quiet mode, only emergency output.
    	-n	Include 'nice'd processes in calculations
    	-m #	Modes of operation, can be 0, 1, 2, or 3:
    		0 = SINE, 1 = AGGRESSIVE (default),
    		2 = PASSIVE, 3 = LEAPS
    	-s #	Frequency step in kHz (default = 100000)
    	-p #	Polling frequency in msecs (default = 1000)
    	-c #	Specify number of threads per power-managed core
    	-u #	CPU usage upper limit percentage [0 .. 100, default 80]
    	-l #    CPU usage lower limit percentage [0 .. 100, default 20]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Powernowd&oldid=240513"

Category:

-   Power management
