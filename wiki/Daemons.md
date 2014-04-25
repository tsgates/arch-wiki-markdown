Daemons
=======

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with systemd.    
                           Notes: This article is   
                           practically no longer    
                           useful after the         
                           introduction of systemd, 
                           and already duplicates   
                           part of its content.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

A daemon is a program that runs as a "background" process (without a
terminal or user interface), commonly waiting for events to occur and
offering services. A good example is a web server that waits for a
request to deliver a page, or a ssh server waiting for someone trying to
log in. While these are full featured applications, there are daemons
whose work is not that visible. Daemons are for tasks like writing
messages into a log file (e.g. syslog, metalog) or keeping your system
time accurate (e.g. ntpd). For more information see man 7 daemon.

Note:The word daemon is sometimes used for a class of programs that are
started at boot but have no process which remains in memory. They are
called daemons simply because they utilize the same startup/shutdown
framework (e.g. systemd service files of Type oneshot) used to start
traditional daemons. For example, the service files for alsa-store and
alsa-restore provide persistent configuration support but do not start
additional background processes to service requests or respond to
events.

From the user's perspective the distinction is typically not significant
unless the user tries to look for the "daemon" in a process list.

Managing daemons
----------------

In Arch Linux, daemons are managed by systemd. The systemctl command is
the user interface used to manage them. It reads <service>.service files
that contain information about how and when to start the associated
daemon. Service files are stored in /{etc,usr/lib,run}/systemd/system.
See systemd#Using units for details.

List of daemons
---------------

See Daemons List for a list of daemons with the name of the service and
legacy rc.d script.

See also
--------

-   systemd
-   Examples for writing Systemd/Services

Retrieved from
"https://wiki.archlinux.org/index.php?title=Daemons&oldid=264940"

Categories:

-   Boot process
-   Daemons and system services

-   This page was last modified on 2 July 2013, at 15:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
