Time
====

Related articles

-   Network Time Protocol

In an operating system, the time (clock) is determined by four parts:
time value, time standard, time zone, and Daylight Saving Time (DST) if
applicable. This article explains what they are and how to read/set
them. To maintain accurate system time on a network see Network Time
Protocol.

Contents
--------

-   1 Hardware clock and system clock
    -   1.1 Read clock
    -   1.2 Set clock
    -   1.3 RTC clock
-   2 Time standard
    -   2.1 UTC in Windows
-   3 Time zone
-   4 Time skew
-   5 Troubleshooting
    -   5.1 Clock shows a value that is neither UTC nor local time
-   6 See also

Hardware clock and system clock
-------------------------------

A computer has two clocks that need to be considered: the "Hardware
clock" and the "System/software clock".

Hardware clock (a.k.a. the Real Time Clock (RTC) or CMOS clock) stores
the values of: Year, Month, Day, Hour, Minute, and the Seconds. It does
not have the ability to store the time standard (localtime or UTC), nor
whether DST is used.

System clock (a.k.a. the software clock) keeps track of: time, time
zone, and DST if applicable. It is calculated by the Linux kernel as the
number of seconds since midnight January 1st 1970, UTC. The initial
value of the system clock is calculated from the hardware clock,
dependent on the contents of /etc/adjtime. After boot-up has completed,
the system clock runs independently of the hardware clock. The Linux
kernel keeps track of the system clock by counting timer interrupts.

> Read clock

To check the current system clock time (presented both in local time and
UTC):

    $ timedatectl status

Run the same command as root to display also the hardware clock time.

> Set clock

To set the system clock directly:

    # timedatectl set-time "2012-10-30 18:17:16"

> RTC clock

Standard behavior of most operating systems is:

-   Set the system clock from the hardware clock on boot
-   Keep accurate time of the system clock with an NTP daemon
-   Set the hardware clock from the system clock on shutdown.

Time standard
-------------

Note:Systemd will use UTC for the hardware clock by default.

There are two time standards: localtime and Coordinated Universal Time
(UTC). The localtime standard is dependent on the current time zone,
while UTC is the global time standard and is independent of time zone
values. Though conceptually different, UTC is also known as GMT
(Greenwich Mean Time).

The standard used by hardware clock (CMOS clock, the time that appears
in BIOS) is defined by the operating system. By default, Windows uses
localtime, Mac OS uses UTC, and UNIX-like operating systems vary. An OS
that uses the UTC standard, generally, will consider CMOS (hardware
clock) time a UTC time (GMT, Greenwich time) and make an adjustment to
it while setting the System time on boot according to your time zone.

When using Linux it is beneficial to have the hardware clock set to the
UTC standard and made known to all operating systems. Defining the
hardware clock in Linux as UTC means that Daylight Saving Time will
automatically be accounted for. If using the localtime standard the
system clock will not be changed for DST occurrences assuming that
another operating system will take care of the DST switch (and provided
no NTP agent is operating).

You can set the hardware clock time standard through the command line.
You can check what you have set your Arch Linux install to use by:

    $ timedatectl status | grep local

The hardware clock can be queried and set with the timedatectl command.
To change the hardware clock time standard to localtime, use:

    # timedatectl set-local-rtc true

If you want to revert to the hardware clock being in UTC, do:

    # timedatectl set-local-rtc false

Be warned that, if the hardware clock is set to localtime, dealing with
daylight saving time is messy. If the DST changes when your computer is
off, your clock will be wrong on next boot (there is a lot more to it).
Recent kernels set the system time from the RTC directly on boot,
assuming that the RTC is in UTC. This means that if the RTC is in local
time, then the system time will first be set up wrongly and then
corrected shortly afterwards on every boot. This is the root of certain
weird bugs (time going backwards is rarely a good thing).

These will generate /etc/adjtime automatically; no further configuration
is required.

During kernel startup, at the point when the RTC driver is loaded, the
system clock may be set from the hardware clock. Whether this occurs or
not depends on the hardware platform, the version of the kernel and
kernel build options. If this does occur, at this point in the boot
sequence, the hardware clock time is assumed to be UTC and the value of
/sys/class/rtc/rtcN/hctosys (N=0,1,2,..) will be set to 1. Later, the
system clock is set again from the hardware clock from systemd,
dependent on values in /etc/adjtime. Hence, having the hardware clock
using localtime may cause some unexpected behavior during the boot
sequence; e.g system time going backwards, which is always a bad idea.

Note:The use of timedatectl requires an active dbus. Therefore, it may
not be possible to use this command under a chroot (such as during
installation). In these cases, you can revert back to the hwclock
command.

> UTC in Windows

One reason users often set the RTC in localtime to dual-boot with
Windows (which uses localtime). However, Windows is able to deal with
the RTC being in UTC with a simple registry fix. It is recommended to
configure Windows to use UTC, rather than Linux to use localtime. If you
make Windows use UTC, also remember to disable the "Internet Time
Update" Windows feature, so that Windows does not mess with the hardware
clock, trying to sync it with internet time. You should instead use NTP
to modify the RTC and sync to internet time.

Using regedit, add a DWORD value with hexadecimal value 1 to the
registry:

    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\RealTimeIsUniversal

Alternatively, create a *.reg file (on the desktop) with the following
content and double-click it to import it into registry:

    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
         "RealTimeIsUniversal"=dword:00000001

Windows XP and Windows Vista SP1 have support for setting the time
standard as UTC and can be activated in the same way. However, there is
a bug after resuming from the suspend/hibernation state that resets the
clock to localtime. For these operating systems, it is recommended to
use localtime.

Should Windows ask to update the clock due to DST changes, let it. It
will leave the clock in UTC as expected, only correcting the displayed
time.

The hardware clock and system clock time may need to be updated after
setting this value.

If you are having issues with the offset of the time, try reinstalling
tzdata and then setting your time zone again:

    # timedatectl set-timezone America/Los_Angeles

It makes sense to disable time synchronization in Windows - otherwise it
will mess up the hardware clock.

Time zone
---------

To check the current zone:

    $ timedatectl status

To list available zones:

    $ timedatectl list-timezones

To change your time zone:

    # timedatectl set-timezone Zone/SubZone

Example:

    # timedatectl set-timezone Canada/Eastern

This will create an /etc/localtime symlink that points to a zoneinfo
file under /usr/share/zoneinfo/. In case you choose to create the link
manually, keep in mind that it must be a relative link, not absolute, as
specified in archlinux(7).

See man 1 timedatectl, man 5 localtime, and man 7 archlinux for more
details.

Note:If the pre-systemd configuration file /etc/timezone still exists in
your system, you can remove it safely, since it is no longer used.

Time skew
---------

Every clock has a value that differs from real time (the best
representation of which being International Atomic Time); no clock is
perfect. A quartz-based electronic clock keeps imperfect time, but
maintains a consistent inaccuracy. This base 'inaccuracy' is known as
'time skew' or 'time drift'.

When the hardware clock is set with hwclock, a new drift value is
calculated in seconds per day. The drift value is calculated by using
the difference between the new value set and the hardware clock value
just before the set, taking into account the value of the previous drift
value and the last time the hardware clock was set. The new drift value
and the time when the clock was set is written to the file /etc/adjtime
overwriting the previous values. The hardware clock can therefore be
adjusted for drift when the command hwclock --adjust is run; this also
occurs on shutdown but only if the hwclock daemon is enabled (hence for
systems using systemd, this does not happen).

Note:If the hwclock has been set again less than 24 hours after a
previous set, the drift is not recalculated as hwclock considers the
elapsed time period too short to accurately calculate the drift.

If the hardware clock keeps losing or gaining time in large increments,
it is possible that an invalid drift has been recorded (but only
applicable, if the hwclock daemon is running). This can happen if you
have set the hardware clock time incorrectly or your time standard is
not synchronized with a Windows or Mac OS install. The drift value can
be removed by removing the file /etc/adjtime, then set the correct
hardware clock and system clock time, and check if your time standard is
correct.

Note:For those using systemd, but wish to make use of the drift value
stored in /etc/adjtime (i.e. perhaps cannot or do not want to use NTP);
they need to call hwclock --adjust on a regular basis, perhaps by
creating a cron job.

The software clock is very accurate but like most clocks is not
perfectly accurate and will drift as well. Though rarely, the system
clock can lose accuracy if the kernel skips interrupts. There are some
tools to improve software clock accuracy:

-   NTP can synchronize the software clock of a GNU/Linux system with
    Internet time servers using the Network Time Protocol. NTP can also
    adjust the interrupt frequency and the number of ticks per second to
    decrease system clock drift. Running NTP will also cause the
    hardware clock to be re-synchronised every 11 minutes.
-   adjtimex in the AUR can adjust kernel time variables like interrupt
    frequency to help improve the system clock time drift.

Troubleshooting
---------------

> Clock shows a value that is neither UTC nor local time

This might be caused by a number of reasons. For example, if your
hardware clock is running on local time, but timedatectl is set to
assume it is in UTC, the result would be that your timezone's offset to
UTC effectively gets applied twice, resulting in wrong values for your
local time and UTC.

To force your clock to the correct time, and to also write the correct
UTC to your hardware clock, follow these steps:

-   Setup NTP (enabling it as a service is not necessary).
-   Set your time zone correctly.
-   Run ntpd -qg to manually synchronize your clock with the network,
    ignoring large deviations between local UTC and network UTC.
-   Run hwclock --systohc to write the current software UTC time to the
    hardware clock.

See also
--------

-   Linux Tips - Linux, Clocks, and Time
-   Sources for Time Zone and Daylight Saving Time Data for tzdata
-   Time Scales
-   Wikipedia:Time

Retrieved from
"https://wiki.archlinux.org/index.php?title=Time&oldid=287603"

Categories:

-   Mainboards and BIOS
-   System administration

-   This page was last modified on 11 December 2013, at 06:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
