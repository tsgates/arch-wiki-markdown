Lenovo ThinkPad X230
====================

+--------------------------------------------------------------------------+
| Summary help replacing me                                                |
+==========================================================================+
| Lenovo Thinkpad X230's basic test setup and configuration. It is more of |
| a review!                                                                |
|                    +                                                     |
|                    #                                                     |
|                   ###              Test Setup Configuration              |
|                  #####                                                   |
|                  ######                                                  |
|                 ; #####;                                                 |
|                +##.#####                                                 |
|               +##########           Distro: Arch Linux                   |
|              #############;         Kernel: 3.7.1-3-ck                   |
|             ###############+        Uptime: 12 day, 6:49                 |
|            #######   #######        Window Manager: Xfwm                 |
|          .######;     ;###;`".      Desktop Environment: Xfce            |
|         .#######;     ;#####.       Shell: /bin/bash                     |
|         #########.   .########`     Terminal: xterm                      |
|        ######'           '######    Packages: 1048                       |
|       ;####                 ####;   CPU: i5-3210M CPU @ 2.50GHz          |
|       ##'                     '##   RAM: 1402 MB / 3676 MB               |
|      #'                         `#  Disk: 6G / 103G                      |
|                                                                          |
|                                                                          |
|      systemd-analyze: Startup finished in \                              |
|                 2.234s (kernel) + 1.048s (userspace) = 3.282s            |
|      systemd-analyze blame:                                              |
|                 407ms NetworkManager.service                             |
|                 62ms systemd-modules-load.service                        |
|                 58ms systemd-vconsole-setup.service                      |
|                 44ms avahi-daemon.service                                |
|                 41ms systemd-logind.service                              |
|                 41ms systemd-tmpfiles-clean.service                      |
|                 38ms polkit.service                                      |
|                 33ms systemd-udev-trigger.service                        |
|                 32ms ModemManager.service                                |
|                 29ms systemd-sysctl.service                              |
|                 23ms systemd-tmpfiles-setup-dev.service                  |
|                 20ms colord.service                                      |
|                 20ms sys-kernel-debug.mount                              |
|                 20ms systemd-remount-fs.service                          |
|                 16ms dev-hugepages.mount                                 |
|                 15ms dev-mqueue.mount                                    |
|                 12ms wpa_supplicant.service                              |
|                 12ms systemd-tmpfiles-setup.service                      |
|                 11ms systemd-journal-flush.service                       |
|                 11ms upower.service                                      |
|                  8ms rtkit-daemon.service                                |
|                  7ms alsa-restore.service                                |
|                  6ms dev-sda2.swap                                       |
|                  5ms systemd-random-seed-load.service                    |
|                  5ms systemd-readahead-collect.service                   |
|                  4ms systemd-udevd.service                               |
|                  4ms systemd-readahead-replay.service                    |
|                  3ms systemd-update-utmp.service                         |
|                  3ms systemd-readahead-done.service                      |
|                  3ms atd.service                                         |
|                  2ms systemd-user-sessions.service                       |
|                  1ms tmp.mount                                           |
|                903us sys-kernel-config.mount                             |
+--------------------------------------------------------------------------+

  
 Lenovo ThinkPad X230 comes with a wide range of available
configurations. Since Lenovo's acquisition of the ThinkPad brand from
IBM, it has received lots of negative criticism for not maintaining the
original quality and compromising the brand itself. Regardless, ThinkPad
still is one of the first preferences for many geeks, students (mainly
due to student discounts) and Linux users. It is the standard option
available in Lenovo's X Series under 12-13 inches display category.

Contents
--------

-   1 Hardware
    -   1.1 Tested Configuration
-   2 System Configuration
    -   2.1 Systemd
    -   2.2 Fingerprint scanner
    -   2.3 Kernel
    -   2.4 TrackPoint
    -   2.5 Touchpad
    -   2.6 Backlight Control Keys
    -   2.7 Power Saving
    -   2.8 Suspension
        -   2.8.1 Suspend failing
-   3 External links

> Hardware

Below is the short list for this setup. After-market RAMs and SSD were
bought because Lenovo is apparently charging a lot for these.

Tested Configuration

Tip:Below were the tested configurations at the time. If you are
interested in more details and review, see the gist A Hacker's Ongoing
Review for Lenovo ThinkPad X230 for full details.

  Feature                       Configuration
  ----------------------------- ------------------------------------------
  System                        X230 2306CTO
  CPU                           Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
  Graphics                      Intel HD 4000 - Ivy Bridge
  Ram                           3.5GB (Kingston)
  Disk                          Crucial M4 120GB SSD
  Display                       12.5" IPS
  Wireless                      2x2 Centrino Wireless-N 2200
  Built-in Battery              9 Cell
  Additional Plugable Battery   6 Cell 19+
  Backlit Keyboard              No
  ThinkLight                    Yes
  Fingerprint Scanner           Yes
  Bluetooth                     Yes
  Cam                           Yes

> System Configuration

Systemd

Configured as usual with readahead and the below services.

-   NetworkManager
-   cups
-   slim
-   sshd
-   syslog-ng
-   vnstat
-   cronie
-   atd

Boot time was as roughly ~3 seconds.

Fingerprint scanner

Works out of the box. See fprint article for installation instructions.
No extrac actions are needed.

Kernel

Note:You may want to run 'linux-ck' instead of the default kernel to
conserve power and to fix iwlwifi issue with system sleep and wakeup.
See power saving section below

To reduce power consumption, as neither the stock nor Arch supplied
kernel is optimized to run on any laptop efficiently, try patched
kernels like linux-ck or linux-pf instead.

    /etc/mkinitcpio.conf

    MODULES="i915"
    BINARIES="badblocks"
    FILES="/etc/modprobe.d/modprobe.conf"
    HOOKS="base udev autodetect block filesystems keyboard fsck"

    /etc/modprobe.d/modprobe.conf

    options i915 i915_enable_rc6=1 i915_enable_fbc=1 lvds_downclock=1
    options iwlwifi 11n_disable=1

The badblocks binary helps fix logical bad blocks if detected by fsck
during system startup. The first line in modprobe.conf file enables
different Intel HD power saving options. To see what each of the
parameters does, issue the command modinfo i915. The second line
disables the wifi N mode as the Intel wireless driver suffers connection
loss due to possible bugs. You can comment out this line if you want to
transfer data at wireless N speeds.

After saving the above files, make sure to regenerate your init ram
image by the command mkinitcpio -p linux && mkinitcpio -p linux-ck.

Then, to update grub2 with the new kernels you have to run
grub-mkconfig -o /boot/grub/grub.cfg.

Note:Using i915_enable_rc6=1 will enable basic power saving with first
stage of C-state 6 (sleeping state). The stages vary by the depth of
sleep, that can be attained by setting the value of i915_enable_rc6
between 1 to 7 in ascending order as can be seen in its documentation
with modinfo i915 command shown above.

Warning:Keep in mind that c-state power saving always comes at
performance sacrifice and setting a higher value can cause a jittery
display or some other unexplained and unexpected misbehavior with i915
so you may want to experiment with different values to find out what
suits your needs.

TrackPoint

Pretty much self-explanatory.

    /etc/X11/xorg.conf.d/20-thinkpad.conf

    Section "InputClass"
        Identifier	"Trackpoint Wheel Emulation"
        MatchProduct	    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
        MatchDevicePath	    "/dev/input/event*"
        Option		    "EmulateWheel"        "true"
        Option		    "EmulateWheelButton"  "2"
        Option		    "Emulate3Buttons"	  "false"
        Option		    "XAxisMapping"	  "6 7"
        Option		    "YAxisMapping"        "4 5"
    EndSection

Touchpad

The original configuration renders the touchpad quite useless, as it
behaves very jumpily. [Ubuntu Bugtracker] offers a solution for this
issue. Add the following

    /etc/X11/xorg.conf.d/50-synaptics.conf

    Section "InputClass"
            Identifier "touchpad"
            MatchProduct "SynPS/2 Synaptics TouchPad"
            Driver "synaptics"
            # fix touchpad resolution
            Option "VertResolution" "100"
            Option "HorizResolution" "65"
            # disable synaptics driver pointer acceleration
            Option "MinSpeed" "1"
            Option "MaxSpeed" "1"
            # tweak the X-server pointer acceleration
            Option "AccelerationProfile" "2"
            Option "AdaptiveDeceleration" "16"
            Option "ConstantDeceleration" "16"
            Option "VelocityScale" "32"
    EndSection

Setting e.g. the motion-acceleration value in dconf to 2.8 works nicely.

Backlight Control Keys

Note: On most X230 models, backlight works by default without any
issues. Use below only in case of any problems.

Due to an issue with the firmware of several ThinkPads the backlight
control keys (fn + F7/F8 on the X230) don't work correctly. Setting the
brightness via e.g. the GNOME power control panel or altering the
brightness value in sysfs is possible.

The issue can be temporarily and partially fixed in adding the
acpi_osi="!Windows 2012" kernel parameter in

    /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi=\"!Windows 2012\""

    sudo grub-mkconfig -o /boot/grub/grub.cfg

The fix is partial in that only 8 steps are accessible via the keys.

For more information see
https://bugzilla.kernel.org/show_bug.cgi?id=51231 .

Power Saving

Tip:The parameter pcie_aspm may not be needed in the more recent 3.9+
kernels

Tip:Don't enable pcie_aspm if dmesg | grep -i "doesn't support pcie
aspm" is true because even if you do, kernel will still keep it disabled

One option is to use Powerdown to save power. On this setup, it gave 14+
hours on a 9 cell battery and 6+ hours on plugable 6 cell external
battery, with normal usage of cmus, firefox and thunderbird. Power
saving kernel parameters in addition to graphics card power saving, are
shown below.

    grep GRUB_CMDLINE /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1 elevator=bfq"
    GRUB_CMDLINE_LINUX="init=/usr/lib/systemd/systemd pcie_aspm=force acpi_backlight=vendor"

The parameter elevator=bfq enables the Brain Fuck Scheduler written by
Con Kolivas, part of Linux-ck and Linux-pf kernel forks. pcie_aspm=force
forcefully enables the PCIE Active State Power Management and
apci_backlight=vendor loads the vendor specific Backlight#ACPI driver
(i.e. thinkpad_acpi) so the brightness keys (Fn + F8 and Fn + F9) work
correctly. After editing the grub file, make sure to regenerate your
grub configuration by the command grub-mkconfig -o /boot/grub/grub.cfg.

Note that the apci_backlight=vendor kernel option also works with the
standard Arch kernel (currently 3.7.10-1) and has the additional bonus
that (Fn + spacebar) controls the keyboard lighting.

Suspension

Warning:If you suspend your system quite often, it is inevitable that
you will stumble upon a wireless driver iwlwifi bug with errors 'fifo
queues full' in dmesg. It is caused by weird PCIEM power control
behaviors and is inhibited in all default kernels (as of writing
3.7.1-3). The only fix is to either enable PREEMPT & BFS with custom
compiled kernel or use an optimized kernel like Linux-ck as reported by
forum user Bassu. Default kernels are not suitable for
power-conservation anyway. Check
https://bbs.archlinux.org/viewtopic.php?pid=1209357 for details.

Sleep/suspension and unsuspension can be easily managed by systemd
without setting it up in Desktop Environment applet or pm-utils. But
there are some modules that must be loaded off and on every time the
system is put to sleep or is awaken. There's also a need to kill
wpa_supplicant by adding systemctl restart wpa_supplicant.service in the
sleep.sh file below. And it is quite fast with systemd anyway.

    /usr/lib/systemd/system-sleep/sleep.sh

    #!/bin/bash
    if [ "$1" = "pre" ]; then
    	killall -9 wpa_supplicant #nm-applet bug's workaround
    fi

    if [ "$1" = "post" ]; then
            /sbin/modprobe -rvf iwldvm
            /sbin/modprobe -rvf iwlwifi
    	/sbin/modprobe -v iwldvm
    	/sbin/modprobe -v iwlwifi

    fi

Put vboxdrv in it too, if you use VirtualBox. There is also an issue
with system shutdown with power saving tools that cannot distinguish sys
devices. You will need to add to the systemd shutdown trigger on this
machine or else you'll get a system reboot when you shutdown the
machine. Put this in /etc/rc.local.shutdown and update and enable its
service, if not already.

    /etc/rc.local.shutdown

    #!/bin/bash
    # /etc/rc.local.shutdown: Local shutdown script.
    # A script to act as a workaround for the bug in the runtime power management module, which causes thinkpad laptops to restart after shutting down. 
    # Bus list for the runtime power management module.
    buslist="pci i2c"
    for bus in $buslist; do                                                             
      for i in /sys/bus/$bus/devices/*/power/control; do                              
        echo on > $i
      done
    done

    /usr/lib/systemd/system/rc-local-shutdown.service

    [Unit]
    Description=/etc/rc.local.shutdown Compatibility
    ConditionFileIsExecutable=/etc/rc.local.shutdown
    DefaultDependencies=no
    After=rc-local.service basic.target
    Before=shutdown.target

    [Service]
    Type=oneshot
    ExecStart=/etc/rc.local.shutdown
    StandardInput=tty
    RemainAfterExit=yes

Suspend failing

As of kernel 3.10 and 3.11 suspend may fail because the kernel tries to
switch off the onboard ethernet device twice (see
http://forums.fedoraforum.org/archive/index.php/t-293457.html).

A workaround is to unload the driver manually and reload it on wake.

    /usr/lib/systemd/system-sleep/e1000e-probe.sh

    #!/bin/bash
    # /usr/lib/systemd/system-sleep/e1000e-probe.sh
    # handles e1000e driver suspend problems:
    #	pci_pm_suspend(): e1000_suspend+0x0/0x20 [e1000e] returns -2
    #	dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -2
    #	PM: Device 0000:00:19.0 failed to suspend async: error -2
    #	PM: Some devices failed to suspend

    case "$1" in
       "pre") rmmod e1000e
       ;;
       "post") modprobe e1000e
       ;;
    esac

> External links

-   [ Review based on first hand experience by original tester]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X230&oldid=297629"

Category:

-   Lenovo

-   This page was last modified on 15 February 2014, at 08:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
