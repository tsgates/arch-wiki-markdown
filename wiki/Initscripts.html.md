Initscripts
===========

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: There's no more  
                           initscripts package      
                           either in the            
                           repositories or the AUR  
                           - this documentation     
                           isn't going to be        
                           accurate for the various 
                           forks, which will need   
                           their own pages if       
                           someone is willing to    
                           document them. (Discuss) 
  ------------------------ ------------------------ ------------------------

Warning:Arch only supports systemd. Arch's old initscripts package as
described on this page is obsolete and is no longer supported. All Arch
users need to migrate to systemd.

This article is intended to give a chronological overview of the
initscripts process and the system files and processes involved,
providing links to relevant wiki articles where necessary. Initscripts
follows the BSD init convention as opposed to the more common SysV. What
this means is that there is little distinction between runlevels, since
the system by default is configured to use the same modules and run the
same processes on all runlevels. The advantage is that users have a
simple way to configure the startup process (see rc.conf); the
disadvantage is that some fine-grained configuration options that SysV
offers are lost. See Adding Runlevels for a way to hack some SysV-like
capabilities into Arch. See Wikipedia:init for more on the distinctions
between SysV and BSD style.

Contents
--------

-   1 init and boot scripts
    -   1.1 /etc/rc.sysinit
    -   1.2 /etc/rc.single
    -   1.3 /etc/rc.multi
    -   1.4 /etc/rc.local
-   2 Custom hooks
    -   2.1 Example
-   3 init: Login
-   4 See also

init and boot scripts
---------------------

The main startup process is initiated by the program init, which spawns
all other processes. The purpose of init is to bring the system into a
usable state, using the boot scripts to do so. As previously mentioned,
initscripts uses BSD-style boot scripts. init reads the file
/etc/inittab; the default inittab begins with the following:

    /etc/inittab

    ...

    # Boot to console
    id:3:initdefault:
    # Boot to X11
    #id:5:initdefault:

    rc::sysinit:/etc/rc.sysinit
    rs:S1:wait:/etc/rc.single
    rm:2345:wait:/etc/rc.multi
    rh:06:wait:/etc/rc.shutdown
    su:S:wait:/sbin/sulogin

    ...

The first uncommented line defines the default system runlevel (3). When
the kernel calls init:

-   First, the main initialization script is run, /etc/rc.sysinit (a
    Bash script).
-   If started in single user mode (runlevel 1 or S), the script
    /etc/rc.single is run.
-   If in any other runlevel (2-5), /etc/rc.multi is run instead.
-   The last script to run is /etc/rc.local (via /etc/rc.multi), which
    is empty by default.

Note:You may want to read more about SysVinit.

> /etc/rc.sysinit

/etc/rc.sysinit is a large startup script that configures hardware, and
performs general initialization tasks. It can be identified by one of
its first tasks, printing the lines:

    Arch Linux
    https://www.archlinux.org

The tasks of rc.sysinit are:

1.  sources the /etc/rc.conf and /etc/rc.d/functions scripts.
2.  displays a welcome message.
3.  mounts various virtual file systems.
4.  make sure rootfs is mounted read-only (if needed).
5.  starts bootlogd.
6.  print deprecation warnings.
7.  configures the hardware clock.
8.  starts udev, loads modules from the MODULES array defined in
    rc.conf, and waits for udev to finish processing coldplug events.
9.  starts the loopback interface.
10. configures RAID, btrfs and encrypted filesystem mappings.
11. check partitions (fsck).
12. remount the rootfs in order to apply the options from /etc/fstab.
13. mounts local filesystems (networked drives are not mounted before a
    network profile is up).
14. start monitoring lvm groups.
15. activates swap areas.
16. configure timezone.
17. initialize the random seed.
18. removes various leftover/temporary files, such as /tmp/*.
19. sets the hostname, locale and system clock as defined in rc.conf.
20. configures the locale, console, and keyboard mappings.
21. sets the console font.
22. writes output from dmesg to /var/log/dmesg.log.

/etc/rc.sysinit is a script and not a place for settings. It sources
(i.e. reads and inherits variables and functions) rc.conf for settings
and /etc/rc.d/functions for the functions that produce its graphical
output (nice colors, alignments, switching 'busy' to 'done', etc.). This
file should not be edited as it is overwritten on upgrade. To add
customizations use the hooks as described below.

> /etc/rc.single

Single-user mode boots straight into the root user account and should
only be used if one cannot boot normally. This script ensures no daemons
are running except for the bare minimum: syslog-ng and udev. The
single-user mode is useful for system recovery where preventing remote
users from doing anything that might cause data loss or damage is
necessary. In single-user mode, users can continue with the standard
(multi-user) boot by entering 'exit' at the prompt.

> /etc/rc.multi

/etc/rc.multi is run on any multi-user (i.e. normal) runlevel (i.e. 2,
3, 4, and 5). Typically, users do not notice the transition from
rc.sysinit to rc.multi because rc.multi also uses /etc/rc.d/functions
for handling output. This script:

1.  runs sysctl to apply the settings in /etc/sysctl.d/, modifying
    kernel parameters at runtime; Arch has very few of these by default
    (mainly networking settings).
2.  starts the daemons, as per the DAEMONS array in rc.conf.
3.  runs /etc/rc.local to handle user customizations.

> /etc/rc.local

Warning:If you have installed both of systemd and initscripts and
/etc/rc.local is existent and systemd >= 197-4, system boot will not be
finished, remove or rename /etc/rc.local, or uninstall initscripts to
solve it.

/etc/rc.local is the local multi-user startup script. Empty by default,
it is a good place to put any last-minute commands the system should run
at the very end of the boot process. Most common system configuration
tasks (like loading modules, changing the console font, or setting up
devices) usually have a dedicated place where they are entered. To avoid
confusion, ensure that commands entered in rc.local are not better
suited elsewhere, such as /etc/profile.d.

When editing this file, keep in mind that it is run after the basic
setup (modules/daemons), as the root user, and whether or not X starts.
In this example, the rc.local script un-mutes ALSA sound settings:

    /etc/rc.local

    #!/bin/bash

    # /etc/rc.local: Local multi-user startup script.

    amixer sset 'Master Mono' 50% unmute &> /dev/null
    amixer sset 'Master' 50% unmute &> /dev/null
    amixer sset 'PCM' 75% unmute &> /dev/null

Custom hooks
------------

Hooks can be used to include custom code in various places in the rc.*
scripts.

  Hook Name              When hook is executed
  ---------------------- ------------------------------------------------------------------------------------------
  sysinit_start          At the beginning of rc.sysinit
  sysinit_udevlaunched   After udev has been launched in rc.sysinit
  sysinit_udevsettled    After uevents have settled in rc.sysinit
  sysinit_prefsck        Before fsck is run in rc.sysinit
  sysinit_postfsck       After fsck is run in rc.sysinit
  sysinit_premount       Before local filesystems are mounted, but after root is mounted read-write in rc.sysinit
  sysinit_end            At the end of rc.sysinit
  multi_start            At the beginning of rc.multi
  multi_end              At the end of rc.multi
  single_start           At the beginning of rc.single
  single_prekillall      Before all processes are being killed in rc.single
  single_postkillall     After all processes have been killed in rc.single
  single_udevlaunched    After udev has been launched in rc.single
  single_udevsettled     After uevents have settled in rc.single
  single_end             At the end of rc.single
  shutdown_start         At the beginning of rc.shutdown
  shutdown_prekillall    Before all processes are being killed in rc.shutdown
  shutdown_postkillall   After all processes have been killed in rc.shutdown
  shutdown_preumount     After last filesystem write (daemons have been killed), before filesystem unmount
  shutdown_postumount    After filesystems have been unmounted
  shutdown_poweroff      Directly before powering off in rc.shutdown

To define a hook function, create a file in /etc/rc.d/functions.d using:

    function_name() {
       ...
    }
    add_hook hook_name function_name

Files in /etc/rc.d/functions.d are sourced by /etc/rc.d/functions. You
can register multiple hook functions for the same hook, as well as
registering the same hook function for multiple hooks. Don't define
functions named add_hook or run_hook in these files, as they are defined
in /etc/rc.d/functions.

Example

Adding the following file disables the write-back cache on a hard drive
before any daemons are started (useful for drives containing MySQL
InnoDB files).

    /etc/rc.d/functions.d/hd_settings

    hd_settings() {
        /usr/bin/hdparm -W0 /dev/sdb
    }
    add_hook sysinit_udevsettled hd_settings
    add_hook single_udevsettled  hd_settings

First it defines the function hd_settings, and then registers it for the
single_udevsettled and sysinit_udevsettled hooks. The function will be
called immediately after uvents have settled in /etc/rc.d/rc.sysinit or
/etc/rc.d/rc.single.

init: Login
-----------

By default, after the Arch boot scripts are completed, the /sbin/agetty
program prompts users for a login name. After a login name is received,
/sbin/agetty calls /bin/login to prompt for the login password.

Finally, with a successful login, the /bin/login program starts the
user's default shell. The default shell and environment variables may be
globally defined within /etc/profile. All variables defined by shell
startup scripts within a user's home directory shall take precedence
over those globally defined under /etc. For instance, if a variable is
defined within both /etc/profile and ~/.bashrc, the one defined by
~/.bashrc shall prevail.

Other options include mingetty which allows for auto-login (agetty has
the option to auto-login since util-linux 2.20) and rungetty which
allows for auto-login and automatically running commands and programs,
e.g. the always useful htop.

The majority of users wishing to start an X server during the boot
process should install a display manager (see Display manager for
details).

See also
--------

-   Runlevels
-   Arch Boot Process
-   Linux / Unix Command: sysctl.conf
-   Search the forum for rc.local examples

Retrieved from
"https://wiki.archlinux.org/index.php?title=Initscripts&oldid=301300"

Category:

-   Boot process

-   This page was last modified on 24 February 2014, at 11:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
