ThinkPad X230
=============

+--------------------------------------------------------------------------+
| Summary                                                                  |
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
+--------------------------------------------------------------------------+

  
 Lenovo ThinkPad X230 comes off with a wide range of available
configurations. Since Lenovo's acquisition of ThinkPad brand from IBM,
it has received lots of negative critics for not maintaining the
original quality and compromising the brand itself. Regardless, ThinkPad
still is one of the first preferences for many geeks, students (mainly
due to student discounts) and Linux users. It is the standard option
available in Lenovo's X Series under 12-13 inches display category.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Review                                                             |
| -   2 Hardware                                                           |
|     -   2.1 Tested Configuration                                         |
|     -   2.2 Compatibility                                                |
|                                                                          |
| -   3 System Configuration                                               |
|     -   3.1 Systemd                                                      |
|     -   3.2 Kernel                                                       |
|     -   3.3 TrackPoint                                                   |
|     -   3.4 Power Saving                                                 |
|     -   3.5 Suspension                                                   |
+--------------------------------------------------------------------------+

> Review

Few things that are not liked:

-   The build "looks like" fairly cheap. It seems to be okay but not
    something extra-ordinary. Thinkpads are known for sturdiness and
    ruggedness; X230 is also but there is a 'plastic' feel.
-   The color at the bottom of wrist pad started to fade at small places
    cause of scratches in normal use - by placing it on hard surfaces
    like raw wood and marble.
-   X230 has a new keyboard. I have no complains about it except that of
    function keys. They are raised few millimeters higher than other
    keys and one can willingly manage to peel them off cause of their
    half-open bottoms.
-   Touch pad is totally useless. It is small. Though the cursor
    movement works but not the buttons because the touch pad itself is
    one big pushable button. Its designers perhaps struggled with space
    availability due to Trackpoint buttons leaving very less space for
    the touch pad. For Trackpoint users and fans, it may not be much of
    a deal breaker as the Trackpoint is more productive for them.
-   There are some parts that are not rigid, give away a feeling that
    they might not be well manufactured and are press-able -- like area
    under Thinkpad logo on top lid and hollow express card slot.
-   The audio is not that loud for its tiny speakers. I carry
    SoundBlaster headphones anyway.
-   Smaller resolution of 1366x768. Not that of an issue for me because
    smaller screen size of 12.5 inches still gives some good working
    space resolution but I could make use of more if it was 1080p or
    higher. But again, it still seems to be a standard screen resolution
    from other vendors as well, currently!

  
 Pros:

-   Steel hinges that hold the top lid. Eases the lid movement.
-   Of course, the 180 degrees bending LCD.
-   Crunchy IPS display.
-   TrackPoint -- the pointing stick.
-   Island-style keys give a grip for touch typing.
-   Good inner chassis can be found if you disassemble this laptop.
-   Ambient system temperatures and the uptime with Arch!

> Hardware

Below is the short list for this setup. After-market RAMs and SSD were
bought because Lenovo is apparently charging a lot for these.

Tested Configuration

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

Compatibility

Tip: A closed-source pre-compiled biometric device driver emerged at
volker.de, reported by Warnaud, successfully tested and found to be
functioning by Bassu.

Everything works fine out-of-box except the biometric / fingerprint
scanner cause of missing driver. X230 comes with a newer model of chip
from Upek. Its manufacturer Authentec was contacted and we found that
they only support Windows operating system. So for now, the Upek model
with PCIE ID 147e:2020 or newer will remain unsupported in Linux until
someone writes an open source driver.

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

Boot time was as roughly ~4-5 seconds.

Kernel

Note:You may want to run 'linux-ck' instead of the default kernel to
conserve power and to fix iwlwifi issue with system sleep and wakeup.
See power saving section below

If you really want to cut power then neither the stock kernel nor the
Arch supplied kernel is optimized to run on any laptop efficiently. Try
the patched kernels like linux-ck or linux-pf instead.

    /etc/mkinitcpio.conf

    MODULES="i915"
    BINARIES="badblocks"
    FILES="/etc/modprobe.d/modprobe.conf"
    HOOKS="base udev autodetect block filesystems usbinput fsck plymouth"

    /etc/modprobe.d/modprobe.conf

    options i915 i915_enable_rc6=1 i915_enable_fbc=1 lvds_downclock=1
    options iwlwifi 11n_disable=1

The badblocks binary helps fix logical bad blocks if detected by fsck
during system startup. First line in modprobe.conf file enables
different Intel HD power saving options. To see what each of the
parameters does, issue a command modinfo i915. The second line disables
the wifi N mode as Intel wireless driver suffers connection loss due to
possible bugs. You can comment on this line if you want to transfer data
at wireless N speeds. After saving the above files, make sure to
regenerate your init ram image by command
mkinitcpio -p linux && mkinitcpio -p linux-ck.

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

Power Saving

Use Powerdown to save power. On this setup, it gave 14+ hours on a 9
cell battery and 6+ hours on plugable 6 cell external battery, with
normal usage of cmus, firefox and thunderbird. Power saving kernel
parameters in addition to graphics card power saving, are as under.

    grep GRUB_CMDLINE /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1 elevator=bfq"
    GRUB_CMDLINE_LINUX="init=/usr/lib/systemd/systemd pcie_aspm=force acpi_backlight=vendor"

The parameter elevator=bfq enables the Brain Fuck Scheduler written by
Con Kolivas, part of Linux-ck and Linux-pf kernel forks. pcie_aspm=force
forcefully enables the PCIE Active State Power Management and
apci_backlight=vendor loads the vendor specific Backlight#ACPI driver
(i.e. thinkpad_acpi) so the brightness keys (Fn + F8 and Fn + F9) work
correctly. After editing the grub file, make sure to regenerate your
grub configuration by command grub-mkconfig -o /boot/grub/grub.cfg.

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
wpa_supplicant by adding systemctl restart wpa_supplicant.service in
below sleep.sh file. And it is quite fast with systemd anyway.

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=ThinkPad_X230&oldid=251570"

Category:

-   Lenovo
