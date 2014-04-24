Suspending to RAM with hibernate-script
=======================================

Related articles

-   Suspend to RAM
-   Suspending to Disk with hibernate-script
-   pm-utils
-   Laptop

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           hibernate-script.        
                           Notes: Move to page      
                           matching package name;   
                           use "uswsusp" instead of 
                           "s2ram" to refer to      
                           Uswsusp. (Discuss)       
  ------------------------ ------------------------ ------------------------

In this article we will explain how to accomplish a successful
suspension to RAM using hibernate-script.

Contents
--------

-   1 Different methods of suspending to RAM
-   2 The hibernate-script and suspension to RAM
    -   2.1 Sound
-   3 Automatic suspend and wakeup
    -   3.1 Automatic suspend, the hard way
    -   3.2 Controlling wakeup

Different methods of suspending to RAM

There is an application, called s2ram, which contains a "whitelist" of
known laptop models and, according to what has been reported by other
owners of these laptops, tries to do the right things for that specific
laptop. The whitelisted laptops can therefore use s2ram to suspend to
RAM "out of the box". Non-whitelisted laptops need to try different
command line options of s2ram in order to determine - by trial and error
- the appropriate "tricks" needed to make suspend and resume work. Your
experience, if reported to the s2ram developers, will contribute to
whitelist your machine in the next release of s2ram.

However, s2ram is not the only resource: the hibernate-script, which is
commonly used to accomplish Suspend to Disk , supports also suspension
to RAM and proposes some further tricks which could convince your
machine to suspend to RAM and resume properly. Moreover, the
hibernate-script can automatize other useful operations which you could
want/need to do before suspension or after resuming from suspension to
RAM.

Thus, the first part of this article will be devoted to s2ram. The
second will discuss the use of the hibernate-script in suspension to
RAM. In particular, we will see how the hibernate-script can be used to
suspend to RAM your system just with the s2ram, but providing some
additional tweakings. Finally, we will mention the possibility to
suspend the machine both to RAM and to disk.

The hibernate-script and suspension to RAM
==========================================

The hibernate-script, developed in the field of the tuxonice project for
suspend-to-disk method, can be used also to suspend your machine to RAM.
Actually, you can also try to do this directly, performing the required
operations before calling the ACPI S3 state. However, the s2ram seems to
be the leading method nowadays and, through the named whitelist, should
assure in the future that virtually any laptop can suspend to RAM
without too much hassle. So, the actually best way to use the power of
the hibernate-script for suspension to RAM is to use it to call s2ram.

You can edit /etc/hibernate/hibernate.conf to select ususpend-ram.conf
as the default action called by:

    # hibernate

Just put the following as the first uncommented line:

     TryMethod ususpend-ram.conf

However, may be that you want to use the hibernate-script primarily to
suspend to disk. In that case you should resort to the ram-specific
configuration file from the command line:

    # hibernate -F /etc/hibernate/ususpend-ram.conf

Now you should configure the script. Please note that the options that
you put in /etc/hibernate/common.conf will be used anytime you call
hibernate (that is also for suspension to disk). On the contrary, the
options in /etc/hibernate/ususpend-ram.conf will be used only when you
suspend to RAM with the s2ram method.

The hibernate-script options are exhaustively described in the man page
hibernate.conf.

First of all, may be that some module is preventing you from
accomplishing a proper suspension cycle. In this case, list it in the
UnloadModules: it will be unloaded before suspension and reloaded after
resuming. Note that the hibernation script already does this for some
blacklisted modules, whose list is /etc/hibernate/blacklisted-modules.

If you discover that a module is guilty, you should report this to the
suspend-devel@lists.sourceforge.net, so that the bad behaviour of the
module can be fixed.

May be also that your display is the guilty and that the tricks provided
by s2ram are not enough. The hibernate-script has some further tricks:

The relevant block of options is the following:

    ### vbetool
    #EnableVbetool yes
    #RestoreVbeStateFrom /var/lib/vbetool/vbestate
    #VbetoolPost yes
    # RestoreVCSAData yes

    ### xhacks
    #SwitchToTextMode yes
    #UseDummyXServer yes
    #DummyXServerConfig xorg-dummy.conf

However, most of these tricks are already attempted by s2ram and you
should not duplicate the effort. Only three tricks in this section are
specific to the script. The first is to uncomment both the following two
lines:

    EnableVbetool yes
    RestoreVbeStateFrom /var/lib/vbetool/vbestate

Please note that, while s2ram uses an internal vbetool component, the
hibernate-script relies on the vbetool package in the extra repo, so you
should install it. Basically, this combination of options do something
similar to the --vbe_save s2ram option, but, instead of restoring the
state saved immediately before suspension, it restores a state manually
saved by the user in the file /var/lib/vbetool/vbestate (or any other
file you have chosen). You can try to save the state in a peculiar safe
situation, like immediately after booting, or before any switching from
X to console and back. You can save the state with the following
command:

    # vbetool vbestate save > /var/lib/vbetool/vbestate

The second peculiar trick (very often required!) is to uncomment the
following line:

    SwitchToTextMode yes

The script will switch from X to console before suspension and back to X
after a successful resuming.

Finally, the UseDummyXServer trick uses a second XServer, with a minimal
safe configuration only during the suspension cycle, restoring the full
fledged X server only after a complete resume. This can be useful with
cards with problematic proprietary drivers: the dummy xserver will use
the standard vesa driver instead. Anyway, this last trick should be
seldom useful nowadays, because also proprietary drivers seem to support
suspension without too many problems.

The hibernate-script gives you many other useful possibilities (such as
restarting services, unmounting partitions, ejecting pccards, and so
on). Read about them in the man pages.

Sound
-----

If you do not explicitly restore the volume level, ALSA may have the
sound channels muted after resuming. If this happens, you can edit
/etc/suspend.conf by adding

    RestartServices alsa

Automatic suspend and wakeup
============================

Once you have suspend to RAM working, you will probably want it to
happend automatically e.g., when you close the laptop lid.

There are several ways to do this. The easiest is to use a high-level
power management tool such as KDE's PowerDevil. Another is to create
your own ACPI event handler scripts.

Automatic suspend, the hard way
-------------------------------

ACPI events are managed by configuration files in /etc/acpi/events/.
(The laptop-mode-tools package contains some examples). A default
configuration file called 'anything' is provided by the acpid package,
which runs /etc/acpi/handler.sh on every event.

An simple event configuration file to manage the opening and closing of
a laptop lid (that could be called /etc/acpi/events/lid) looks like
this:

    event=button[ /]lid
    action=/etc/acpi/actions/lid_handler.sh %e

The first line specifies the names of the events applicable to this file
with a regexp. You can get the names of events by enabling event logging
in acpid and looking at /var/log/acpid.

The second line specifies an executable to be run when an applicable
event occurs. The %e is a variable containing arguments that the event
provides. It's a good idea to provide them to the program.

It's customary to put handling programs in /etc/acpi/actions/. A
possible implementation of lid_handler.sh in the previous example could
be:

    #!/bin/sh
    # check if the lid is open or closed, using the /proc file
    if grep closed /proc/acpi/button/lid/LID/state >/dev/null ; then
        # if the lid is now closed, save the network state and suspend to RAM
        netcfg all-suspend
        pm-suspend
    else
        # if the lid is now open, restore the network state.
        # (if we are running, a wakeup has already occured!)
        netcfg all-resume
    fi

The same example, adapted for wicd instead of netcfg:

    #!/bin/sh
    # check if the lid is open or closed, using the /proc file
    if grep closed /proc/acpi/button/lid/LID/state >/dev/null ; then
        # if the lid is now closed, save the network state and suspend to RAM
        /usr/lib/wicd/suspend.py
        pm-suspend
    else
        # if the lid is now open, restore the network state.
        # (if we are running, a wakeup has already occured!)
        /usr/lib/wicd/autoconnect.py
    fi

Remember to make it executable. With some basic knowledge of shell
scripting, you have a lot of possibilities.

Controlling wakeup
------------------

The ACPI events that trigger wakeup are controlled through the procfile
/proc/acpi/wakeup. An example output is:

    root@hex in /proc/acpi $ cat wakeup
    Device  S-state   Status   Sysfs node
    LID       S3    *enabled
    PBTN      S4    *enabled
    MBTN      S5     enabled
    PCI0      S3     disabled  no-bus:pci0000:00
    USB0      S0     disabled  pci:0000:00:1d.0
    USB1      S0     disabled  pci:0000:00:1d.1
    USB2      S0     disabled  pci:0000:00:1d.2
    USB3      S0     disabled  pci:0000:00:1d.3
    EHCI      S0     disabled  pci:0000:00:1d.7
    AZAL      S3     disabled  pci:0000:00:1b.0
    PCIE      S4     disabled  pci:0000:00:1e.0
    RP01      S4     disabled  pci:0000:00:1c.0
    RP02      S3     disabled
    RP03      S3     disabled
    RP04      S3     disabled  pci:0000:00:1c.3
    RP05      S3     disabled
    RP06      S3     disabled

To toggle whether an event will trigger a wakeup, pipe its name into the
/proc/acpi/wakeup. (Note that every name in the file must have 4
letters, so if it is shorter e.g. LID, it needs be prepended with
spaces). So to prevent opening the laptop lid from triggering a wakeup,
you could do:

    root@hex in /proc/acpi $ echo " LID" > wakeup
    root@hex in /proc/acpi $ cat wakeup
    Device  S-state   Status   Sysfs node
    LID       S3    *disabled
    PBTN      S4    *disabled
    MBTN      S5     disabled
    PCI0      S3     disabled  no-bus:pci0000:00
    ...

Another thing to note is that the PBTN and MBTN events were also toggle
with the LID event. Sometimes events are linked, so that all of them
will be enable and disabled in unison. Checking the 'dmesg' command can
confirm this:

    root@hex in /proc/acpi $ dmesg
    ...
    ACPI: 'PBTN' and 'LID' have the same GPE, can't disable/enable one separately
    ACPI: 'MBTN' and 'LID' have the same GPE, can't disable/enable one separately

This may not actually affect the other events. On a Dell Inspiron 6400,
for example, the power button always triggers a wake up. Your mileage
may vary.

None of this will persist between boots, so you might want to add the
echo command to /etc/rc.local so it is executed on every boot:

    # disable the laptop lid switch
    echo " LID" > /proc/acpi/wakeup

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suspending_to_RAM_with_hibernate-script&oldid=290719"

Category:

-   Power management

-   This page was last modified on 29 December 2013, at 03:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
