initscripts/rc.conf
===================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: There's no more  
                           initscripts package      
                           (either in the repos or  
                           AUR), and this           
                           information isn't        
                           accurate for forks that  
                           have made various        
                           changes. (Discuss)       
  ------------------------ ------------------------ ------------------------

Warning:Arch only supports systemd. Arch's old initscripts package is
obsolete and is no longer supported. All Arch users need to move to
systemd.

/etc/rc.conf is the configuration file for initscripts. It configures
what daemons to start at boot, the basic network daemon, and certain
aspects of hardware discovery.

Contents
--------

-   1 Overview
-   2 New configuration file
-   3 Daemons
-   4 Hardware
    -   4.1 Interface configuration
-   5 Modules
-   6 Localization
-   7 Networking
    -   7.1 Network Persist
-   8 GUI Frontends
    -   8.1 ArchLinux Daemon Manager GUI
    -   8.2 rcconf-settings

Overview
--------

This is what a typical rc.conf file looks like on an up-to-date Arch
install. (current version):

    /etc/rc.conf

    #
    # /etc/rc.conf - configuration file for initscripts
    #
    # Most of rc.conf has been replaced by various other configuration
    # files. See archlinux(7) for details.
    #
    # For more details on rc.conf see rc.conf(5).
    #

    DAEMONS=()

    # A reasonable DAEMONS array when using sysvinit is:
    # DAEMONS=(syslog-ng network crond)
    #
    # When using systemd, it is recommended to only enable daemons that
    # do not have native systemd service files.

    # Storage
    #
    # USEDMRAID="no"
    # USELVM="no"

    # Network
    #
    # interface=
    # address=
    # netmask=
    # gateway=

New configuration file
----------------------

In the past, this file also used to contain configurations for other
parts of the system. If you are using initscripts as your init system,
/etc/rc.conf configures which daemons to start during boot-up and some
networking and storage information.

Note:Using the legacy configuration options in /etc/rc.conf for system
configuring still works (for now) with the default init system, but the
new configuration files take precedence and using them is recommended.
The new files will also work for configuring systemd. See
Systemd#Native_configuration

+--------------------------+--------------------------+--------------------------+
| Configuration            | Configuration file(s) or | Legacy rc.conf section   |
|                          | tool                     |                          |
+==========================+==========================+==========================+
| Hostname                 | /etc/hostname            | NETWORKING               |
+--------------------------+--------------------------+--------------------------+
| Console fonts and keymap | /etc/vconsole.conf       | LOCALIZATION             |
+--------------------------+--------------------------+--------------------------+
| Locale                   | /etc/locale.conf         | LOCALIZATION             |
|                          | /etc/locale.gen          |                          |
+--------------------------+--------------------------+--------------------------+
| Timezone                 | /etc/localtime           | LOCALIZATION             |
+--------------------------+--------------------------+--------------------------+
| Hardware clock           | /etc/adjtime             | LOCALIZATION             |
+--------------------------+--------------------------+--------------------------+
| Kernel modules           | /etc/modules-load.d/     | HARDWARE                 |
+--------------------------+--------------------------+--------------------------+
| Daemons                  | systemctl tool           | DAEMONS                  |
+--------------------------+--------------------------+--------------------------+
| Static network           | /etc/conf.d/network      | NETWORKING               |
+--------------------------+--------------------------+--------------------------+

Configuration files can simply be created if they do not exist already
and you wish to change the defaults.

Daemons
-------

 DAEMONS 
    Warning:Systemd can handle daemons in Arch. Arch users need to
    migrate to systemd and use systemd to start daemons instead. See
    systemd for more information.
    A space-separated list of scripts located in /etc/rc.d/ which are
    started during the boot process. Usually you do not need to change
    the defaults to get a running system, but you are going to edit this
    array whenever you install system services like sshd, and want to
    start these automatically during boot-up. This is basically Arch's
    way of handling what others handle with various symlinks to an
    init.d directory. For more info see: Writing rc.d scripts
    1.  If a script name is prefixed with a bang (!), it is not
        executed.
    2.  If a script is prefixed with an "at" symbol (@), then it will be
        executed in the background, i.e. the startup sequence will not
        wait for successful completion before continuing.

    Example:
    DAEMONS=(@syslog-ng !network net-profiles crond sshd)

    Note:The order in which the daemons are listed is important as they
    are loaded in that order.

Hardware
--------

USEDMRAID

Scan for FakeRAID (dmraid) Volumes at startup (runs dmraid -i -ay).

USELVM

Scan for LVM volume groups at start-up, which is required if you use
LVM. Setting to YES runs vgchange --sysinit -a y (handled by
activate_vgs() function) during sysinit.

Note:USEBTRFS is no longer needed, as it is taken care of by udev.

> Interface configuration

rc.conf only supports the configuration of a single interface. For the
configuration of multiple interfaces or other advanced network
configurations like bridging, use netcfg.

These settings should go into /etc/conf.d/network. See also Using a
static IP address

 interface
    name of device (required)
 address
    IP address (leave blank for DHCP)
 netmask
    subnet mask (ignored for DHCP) (optional, defaults to 255.255.255.0)
 broadcast
    broadcast address (ignored for DHCP) (optional)
 gateway
    default route (ignored for DHCP)

    Static IP Example

    interface=eth0
    address=192.168.0.2
    netmask=255.255.255.0
    broadcast=192.168.0.255
    gateway=192.168.0.1

    DHCP example

    interface=eth0
    address=
    netmask=
    gateway=

Note:Make sure to add network to DAEMONS

    DAEMONS=(... network sshd)

or, if using netcfg, add net-profiles

    DAEMONS=(... !network net-profiles sshd)

Modules
-------

 MODULES
    Warning:Modules to be autoloaded at boot are now specified in
    /etc/modules-load.d/, and modules to be blacklisted are now
    specified in /etc/modprobe.d/.

Modules to load at boot-up in addition to auto-loaded ones, to do this
see Kernel modules#Loading, and to blacklist modules, see Kernel
modules#Blacklisting.

Note:MOD_AUTOLOAD is deprecated as of initscripts 2011.06.1-1, you can
use udev rules to achieve the same effect.

Tip:Some modules may not be loaded in the order they are listed, as they
might also be loaded on-demand by udev. For consistent network interface
names between boots, create the appropriate udev rules.

Localization
------------

 HARDWARECLOCK 
    Warning:This setting is now configured in /etc/adjtime.
    Specifies whether the hardware clock, which is synchronized from on
    bootup and to on shutdown, stores UTC time, or the localtime. If
    this value is not set, then the value stored by hwclock in
    /var/lib/hwclock/adjtime is used instead. See Time for more
    information.
    1.  UTC makes sense because it greatly simplifies changing timezones
        and daylight savings time. Linux will change to-and-from DST,
        regardless of whether Linux was running at the time DST is
        entered or left.
    2.  localtime is necessary if you dual boot with an operating system
        that only stores localtime, such as Windows. Linux will not
        adjust the time, operating under the assumption that your system
        may be a dual-boot system at that time and that the other OS
        takes care of the DST switch. If that was not the case, the DST
        change needs to be made manually.
    3.  empty: fall back to the value in /etc/adjtime, which defaults to
        UTC. This is recommended as other users of hwclock might change
        the adjtime file and hence cause rc.conf and adjtime to be out
        of sync
    4.  any other value will result in the hardware clock being left
        untouched (useful for virtualization)

 TIMEZONE 
    Warning:This setting is now configured by the /etc/localtime
    symlink.
    Specifies your time zone. Possible time zones are the relative path
    to a zoneinfo file starting from the directory /usr/share/zoneinfo.
    For example, a German timezone would be Europe/Berlin, which refers
    to the file /usr/share/zoneinfo/Europe/Berlin.
 KEYMAP 
    Warning:This setting is now configured in /etc/vconsole.conf.
    The keyboard layout you want to use. If you live in the US, you
    probably use qwerty, which is referred using us (default). The
    available keymaps are in /usr/share/kbd/keymaps.
    Note:Please note that this setting is only valid for your TTYs, not
    any graphical window managers or X!

 CONSOLEFONT 
    Warning:This setting is now configured in /etc/vconsole.conf.
    Defines the console font to load with the setfont program on boot-up
    (ter-v14b for example). Possible fonts are found in
    /usr/share/kbd/consolefonts (only needed for non-US). FONT in
    /etc/vconsole.conf takes precedence. For more info see: Console
    fonts
 CONSOLEMAP 
    Warning:This setting is now configured in /etc/vconsole.conf.
    Defines the console map to load with the setfont program on boot-up
    (8859-1_to_uni for example). Possible maps are found in
    /usr/share/kbd/consoletrans. You will want to set this to a map
    suitable for your locale (8859-1 for Latin1, for example) if you use
    an utf8 locale above and use programs that generate 8-bit output.
    FONT_MAP in /etc/vconsole.conf takes precedence.
    Note:If using X11 for everyday work, note that this only affects the
    output of console applications.
 LOCALE 
    Warning:This setting is now configured in /etc/locale.gen. Run
    locale-gen to update changes. The system-wide locale can be set in
    /etc/locale.conf.
    This sets your system language, which will be used by all
    i18n-friendly applications and utilities. You can get a list of the
    available locales by running locale -a from the command line. This
    setting's default is fine for US English users. The LANG variable in
    /etc/locale.conf takes precedence if it is set, and users of login
    shells that cannot source /etc/rc.conf, should set that value
    instead.
 DAEMON_LOCALE
    Warning:This setting is obsolete.
    If set to yes, use $LOCALE as the locale during daemon startup and
    during the boot process. If set to no, the C locale is used. Default
    value is yes.
 USECOLOR
    Warning:This setting is obsolete.
    Enable (or disable) colorized status messages during boot-up.

Networking
----------

The HOSTNAME variable is deprecated, and the hostname is now set in
/etc/hostname (see man 5 hostname).

> Network Persist

The NETWORK_PERSIST variable tells the system whether or not to skip
network shutdown. This is required if your root device is on NFS. The
default setting is "no".

    # default
    NETWORK_PERSIST="no"

    # NFS-based root device
    # NETWORK_PERSIST="yes"

GUI Frontends
-------------

This is a list of /etc/rc.conf GUI front-ends, designed to provide a
graphical interface to the /etc/rc.conf file. The list includes
GTK2-based software and Qt based software.

Warning:None of these tools are officially supported by the Arch
developers. Moreover, systemd is now the default init daemon, so
/etc/rc.conf is obsolete.

> ArchLinux Daemon Manager GUI

ArchLinux Daemon Manager allows you to easily change settings in
/etc/rc.conf using GTK application aldm-gui or command-line application
aldm.

-   Homepage: https://github.com/Harvie/ArchLinux-Daemon-Manager
-   AUR Package Details: aldm
-   Screenshots: http://img130.imageshack.us/img130/4200/aldmgui03.png

> rcconf-settings

rcconf-settings is a tool designed for the Chakra GNU/Linux distribution
but should also work on Arch Linux.

-   Homepage: http://gitorious.org/chakra/rcconf-settings
-   AUR Package Details: kcm-rcconf-settings
-   Screenshots:
    http://s2.subirimagenes.com/imagen/5986587instantnea1.png

Retrieved from
"https://wiki.archlinux.org/index.php?title=Initscripts/rc.conf&oldid=300355"

Category:

-   Boot process

-   This page was last modified on 23 February 2014, at 14:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
