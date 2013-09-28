Jack Listener Daemon
====================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: functionality of 
                           jacklistenerd is added   
                           to acpid and no futher   
                           developement seems to be 
                           planned (Discuss)        
  ------------------------ ------------------------ ------------------------

Jack Listener Daemon is a daemon that monitors ALSA jacks
plugging/unplugging events and sends signals with these events to D-Bus.
Other applications can monitor this signals and display notifications,
execute commands, enable/disable music playback etc.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Rationale                                                          |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Clients                                                            |
+--------------------------------------------------------------------------+

Rationale
---------

Jack plugging/unplugging events are rarely supported by acpi and can be
only monitored by parsing binary structures read from few files in /sys/
which can only be accessed by root. On the other hand such tasks as
displaying notifications and interacting with music players can only be
done by processes running within user's session (e. g. daemon clients).

Note:Jack Listener Daemon can monitor headphone, microphone, line and
video jacks at the same time.

Installation
------------

Jack Listener Daemon can be installed with package jacklistener-git,
available in AUR. Owners of Intel HDA cards with custom kernels should
ensure that CONFIG_SND_HDA_INPUT_JACK is enabled in kernel
configuration.

Configuration
-------------

Add jacklistenerd to the list of daemons in /etc/rc.conf.

Clients
-------

Several clients exist that monitor signals from Jack Listener Daemon and
perform more or less advanced operations on jacks plugging/unplugging
events:

-   Jack Event Handler — desktop session daemon that executes required
    commands on (un)plugging events

Note:Daemon is controlled by configuration file ~/.config/jackeventcmd
(see /usr/share/config/jackeventcmd for example one).

https://github.com/gentoo-root/jackeventcmd || jackeventcmd-git

-   Jack Notification Daemon — desktop session daemon that shows simple
    pop-ups about ALSA jacks plugging/unplugging events using libnotify

Note:notification-daemon or some other notification server should be
installed for this to work.

https://github.com/gentoo-root/jacknotifier || jacknotifier-git

Retrieved from
"https://wiki.archlinux.org/index.php?title=Jack_Listener_Daemon&oldid=237303"

Category:

-   Audio/Video
