Powerdown
=========

Summary

powerdown is a bunch of scripts by Taylorchu that combine all sorts of
settings to make your computer consume less energy and thus save
batterylife.

Related

Pm-utils

Udev

Display Power Management Signaling

Powerdown is a bunch of scripts to take the hassle out of maximizing
battery-life.

Warning:Use at your own risk. It is recommended to read through all the
tweaks in order to disable those that might not be compatible with your
system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Automatically running powerdown at power state changes             |
| -   4 Configuration                                                      |
| -   5 FAQ                                                                |
|     -   5.1 I do get more spinups and clicks from my HDD. Where is this  |
|         setting stored in powerdown?                                     |
|                                                                          |
| -   6 Packages that are no longer necessary after installation           |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

powerdown-git is available from the AUR.

Note:Powerdown tries disabling NMI watchdog on the fly. If this doesn't
work for you, you'll see "Dazed and confused" messages when suspending.
You can disable it completely by adding nmi_watchdog=0 to the kernel
command line.

Add the following lines to ~/.xinitrc to turn off your screen after 5
minutes of idling by default:

    ~/.xinitrc

    # screen powersave
    xset +dpms
    xset dpms 0 0 300

Note:The script. If unsatisfactory, add consoleblank=0 to the kernel
command line and run the following xset commands (this would be a great
addition to the powerdown scripts):

    xset s off
    xset s noblank
    xset s noexpose
    xset c on
    xset -dpms

The powerdown shell script located in /usr/bin can be customised to your
needs. To disable any undesired features simply comment out its
appropriate line.

Usage
-----

The following table presents all scripts installed.

  Name                                                      Function
  --------------------------------------------------------- -------------------------------------------------------------------------
  powerdown, powerup                                        Powers everything down or up.
  powerdown-functions                                       Defines functions that are used by powerdown and powerup.
  powernow                                                  Displays current power usage and settings.
  powerdown.rules                                           The Udev rule that loads powerdown or powerup.
  suspend-to-mem                                            Suspends to RAM.
  suspend-to-disk                                           Suspends to HDD, creates a 2GB swap file at the first time doing so.
  suspend-hybrid                                            First, suspends to RAM. After 10 minutes, wakes up and suspends to HDD.
  pm-is-supported, pm-powersave, pm-suspend, pm-hibernate   Wrappers with pm-utils syntax (for legacy support?).

After a reboot the scripts can now be run in a terminal.

Automatically running powerdown at power state changes
------------------------------------------------------

Powerdown is automatically loaded by a Udev rule, so no daemon,
rc-script or service-file is necessary.

However, this doesn't work on every machine, so you might want to enable
upower.service in systemd with

    # systemctl enable upower.service

or add upower -e to your .xinitrc.

Configuration
-------------

As there are no config files for powerdown, you have to edit
/usr/bin/powerdown by hand and adjust the values. Note, however, that
these changes will be overwritten during an update!

FAQ
---

I do get more spinups and clicks from my HDD. Where is this setting stored in powerdown?

Set the following tweak to a higher value:

    hdparm -B

Packages that are no longer necessary after installation
--------------------------------------------------------

Source

1.  powertop, powertop2: these packages have no updates for at least 3-4
    years. if you think kernel has no changes on power management for 3
    or 4 years, go ahead and continue to use them. Replacement: powernow
    is included in new powerdown. it shows laptop power usage in mWh.
    the value is usually between 10000 to 25000.
2.  laptop-mode-tools: this is a huge framework on power management. It
    has dozens of configs you need to setup, which normally no one knows
    how to control them. I think it is a "troubleware"; to use it
    properly, you have to google more. most of time, you dont even know
    what works or not. Replacement: powerdown shows what does not work
    right in the screen. it contains all the rules optimized that just
    work.
3.  tuxonice, uswsusp, pm-utils: too hassle to set things up. again,
    they complicate suspend and resume. the default kernel already
    support suspends and resume pretty well. Replacement: ps2mem uses
    default kernel for ram suspend and resume. you just run "sudo
    suspend-to-mem"; no framework, no setup.
4.  turn-off solves a bug in kernel(even in 3,4 rc that ehci_hcd messes
    up shutdown when it is set to powersave mode). This is a wrapper for
    'poweroff'. You just call it to shut down your arch box.

See also
--------

-   Initial thread on the forum
-   AUR page
-   Github repository
-   Alternative, more simple powersave script
-   Another simple power saving system

Retrieved from
"https://wiki.archlinux.org/index.php?title=Powerdown&oldid=254567"

Category:

-   Power management
