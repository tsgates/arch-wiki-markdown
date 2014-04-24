Suspending to Disk with hibernate-script
========================================

Related articles

-   Suspending to RAM with hibernate-script
-   pm-utils
-   Laptop

  ------------------------ ------------------------ ------------------------
  [Tango-go-next.png]      This article or section  [Tango-go-next.png]
                           is a candidate for       
                           moving to                
                           hibernate-script.        
                           Notes: Move to page      
                           matching package name.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

"Hibernating" or suspending to disk writes all the running processes to
the disk (typically to the swap partition), then completely powers down
the machine. This resembles suspending to RAM, but while a machine
suspended to RAM still requires a small charge from a battery or power
source, a hibernated machine does not and can remain hibernated
indefinitely. This advantage comes at the cost of additional time needed
to hibernate and to resume, since disks (especially HDD swap partitions)
write and read slower than RAM.

This guide focuses on hibernate-script (see the pm-utils page for the
alternative), a frontend used with the uswsusp ("userspace suspension")
and TuxOnIce (formerly known as suspend2) hibernate backends. Uswsusp
generally works without requiring a patched kernel but should be used
with initrd/initramfs. Tuxonice requires a modified kernel, but works
without initrd/initramfs and also allows suspending to a swap file if a
user does not have, or does not want to use, a swap partition.

Contents
--------

-   1 Installation
-   2 Backend setup
    -   2.1 Direct Run
    -   2.2 Setting the suspend method
-   3 Hibernate tricks with the hibernate.script
    -   3.1 Editing /etc/hibernate/common.conf
    -   3.2 NVIDIA specific settings
    -   3.3 Suspending with fglrx
    -   3.4 Dropping disk caches
    -   3.5 Specific settings for TuxOnIce
-   4 Combining suspend to disk with suspend to RAM
-   5 Take action based on events
    -   5.1 After pressing power button
    -   5.2 After closing lid

Installation
------------

You can install hibernate-script from the AUR.

Backend setup
-------------

There is a dedicated pages which covers the installing and configuring
of these backend:

-   Tuxonice method: Tuxonice
-   Uswsusp method: Uswsusp

> Direct Run

you can suspend to disk with the method with the following command.

Using uswsusp:

    # hibernate -F /etc/hibernate/ususpend-disk.conf

Using TuxOnIce:

    # hibernate -F /etc/hibernate/tuxonice.conf

> Setting the suspend method

Preferred suspend/hibernation method of hibernate-script can be set in
the file /etc/hibernate/hibernate.conf. If you list several methods, the
first one will be used. Note that hibernate can also be used with
Suspend to RAM or vanilla uswsusp).

For Uswsusp use:

    TryMethod ususpend-disk.conf

For TuxOnIce use:

    TryMethod tuxonice.conf

Hibernate tricks with the hibernate.script
------------------------------------------

This is a brief overview of the hibernate script. If you want to tweak
it further, examine the common.conf and suspend2.conf files further and
read the excellent and exhaustive man pages for hibernate and
hibernate.conf.

> Editing /etc/hibernate/common.conf

The options in this file are used with any hibernation method (actually,
the file is sourced by the configuration files of each method) and also
by Suspend to RAM when accomplished with the hibernate-script. This file
is complex and well commented. The man page hibernate.conf describes
adequately all the options. Here, we can only stress the most commonly
useful parts.

Uncomment the lines for any filesystems that have the potential to
change while your computer is suspended (for example shared partitions
with windows like vfat or ntfs ones). They will be remounted upon
resume. Otherwise you would risk corrupting the filesystems.

    ### filesystems
    # Unmount /nfsshare /windows /mnt/sambaserver
    # UnmountFSTypes smbfs nfs
    # UnmountGraceTime 1
    # Mount /windows

If you do not explicitly restore the volume levels, ALSA may have the
sound channels muted after resuming. If this happens, look for:

    ### services

in /etc/hibernate/common.conf and change the line just below to:

    RestartServices alsa

The alsa service will be stopped before suspension and restarted after
resuming: the sound channels and volumes will be as before. You may want
to restart other problematic services here.

A common issue is that some drivers do not support suspension, that is
they do not work properly after a suspension cycle or even they prevent
the system from suspending or resuming properly. In these cases (which
should be reported - at least for modules in the vanilla kernel - to the
suspend-devel@lists.sourceforge.net mailing list, so that they can be
fixed upstream) you can unload the module before suspension and reload
it after resuming: the hibernate-script can automatize this routine with
the LoadModules and UnloadModules options. Actually, the
hibernate-script already unloads some problematic modules, listed in
/etc/hibernate/blacklisted-modules, so you can also add the modules in
that file.

To re-connect to networks after rebooting, you may want to add:

    OnSuspend 25 netcfg2 -a
    OnResume 20 netcfg-auto-wireless <your-network-interface>

This will disconnect from all networks, then should automatically choose
the correct one. If you use another way to connect to a network (such as
netcfg2 <profile-name> then of-course, put that there instead.

One 'gotcha' to watch out for is the priority level you put on your
user-commands, this won't work:

    OnSuspend 5 netcfg -a

You'll need to set the priority as 05 instead. Its normally best to use
something within the range of 20-50 for your user scripts.

If you need/want to eject all PcCards before suspending and reinsert
them after resuming, change the EjectCards setting in common.conf:

    ### pcmcia
    EjectCards yes

This is necessary on some laptops, if the pccards stop working after
resume.

Finally, the most problematic aspect is constituted by the video card:
its status needs often to be restored after resuming. In other cases, it
is necessary to switch from X to the console. The following options in
/etc/hibernate/common.conf will probably fix these issues (whose symptom
could be a frozen machine or only a black display after resuming):

    ### vbetool
    #EnableVbetool yes
    #RestoreVbeStateFrom /var/lib/vbetool/vbestate
    #VbetoolPost yes
    # RestoreVCSAData yes

    ### xhacks
    #SwitchToTextMode yes
    #UseDummyXServer yes
    #DummyXServerConfig xorg-dummy.conf

You can uncomment one or many of them in order to see if the problem is
solved. In order to use the first block of options, you need to install
the vbetool package from the extra repository. Each of the option is
documented in man hibernate.conf. Please note that it is very important
to try all the different combinations of these options before than
anything else, becaause the problems with the display are the most
common source of troubles in a suspension cycle.

> NVIDIA specific settings

If you have an NVIDIA graphics card and use a driver version >177, you
need to add the following line to /etc/hibernate/tuxonice.conf:

    ProcSetting extra_pages_allowance 7500

A value lower than 7500 might also work on certain systems, though 7500
should be a working default. Setting this option should allow you to
hibernate and resume without any additional X hacks. You will also need
to comment out the nvidia module in /etc/hibernate/blacklisted-modules
for this to work.

The suggested value for extra_pages_allowance for driver versions <177
is 0:

    ProcSetting extra_pages_allowance 0

This setting has also been reported to help with the binary ATI driver.

If you have an AGP Nvidia card and are using the binary driver, you
might also have to add the following line to your /etc/X11/xorg.conf:

    Option "NvAGP" "1"

> Suspending with fglrx

Following addition to /etc/hibernate/suspend2.conf is required:

    # For fglrx
    ProcSetting extra_pages_allowance 20000

> Dropping disk caches

From: drop_caches introduction

As a way to speed up suspending, you can free the memory used for disk
caches so there will be less to write to the disk. Just add something
like this to the common.conf:

    OnSuspend 00 sync; echo 3 > /proc/sys/vm/drop_caches

> Specific settings for TuxOnIce

Specific settings for TuxOnIce are in /etc/hibernate/tuxonice.conf. Make
sure that the following lines are uncommented and appropriately
configured:

    UseTuxOnIce   yes
    Compressor    lzo

There are a number of additional settings and tweaks which you can set
in /etc/hibernate/tuxonice.conf and /etc/hibernate/common.conf, more
information about these can be found on the TuxOnIce website and on the
Suspend to Disk page of this wiki.

You can abort a suspend cycle if you press the escape key. If you press
a capital R, you will force the system to reboot after hibernation.

If all goes well, you should be able to resume using the same GRUB menu
selection. If you make that option the default for GRUB, you will always
default to resuming if a resume image is available. It is recommended
that you test the suspend/hibernate from a text console first and then
once you have confirmed that it works try it from within X.

Warning:Never use a different kernel to resume than you used to suspend!
If pacman updates your kernel, do not suspend before you have rebooted
properly.

You can make this practice safer adding the hibernate-cleanup daemon to
your DAEMONS array in /etc/rc.conf. This script will make sure that any
stale image is deleted from your swap partition at boot time. This
should make your system safe also in the case that you have chosen the
mistaken kernel at the GRUB prompt. The hibernate-cleanup service is
included in the hibernate-script package.

Combining suspend to disk with suspend to RAM
---------------------------------------------

If your motherboard or laptop supports Suspend to RAM, you can combine
it with suspend2. This will result in the following behavior:

-   When you call hibernate, your system will suspend to disk and after
    that suspend to RAM instead of powering down.
-   When you turn your system back on, it will resume directly from RAM
    (which only takes a few seconds)
-   If your battery fails in the meantime (and the image in your memory
    is therefore lost), you will be able to resumes from disk.

This can be done both with uswsusp and with tuxonice.

With uswsusp, you should use s2both. You can also call s2both from the
hibernate script (with all its richness of options), resorting to the
ususpend-both.conf method. Please note that s2both works only if s2ram
(see Suspend to RAM) works in your system. There is no way to force it
to work if your laptop model is not whitelisted in s2ram. See Suspend to
RAM for instructions about how to whitelist your laptop in the local
copy of s2ram and how to report that your laptop suspend to ram properly
so that it is whitelisted in the next uswsusp release.

To do it with tuxonice, edit /etc/hibernate/suspend2.conf:

    ## Powerdown method - 3 for suspend-to-RAM, 4 for ACPI S4 sleep, 5 for poweroff
    PowerdownMethod 3

For this to work, your computer must be able to use suspend to RAM also
without s2ram.

Take action based on events
---------------------------

Tuning hibernate-script for context sensitive modal operation. You need
to have acpid installed.

> After pressing power button

Edit the following file /etc/acpi/events/power

    # This is called when the user presses the power button
    event=button/power (PWR.||PBTN)
    # To Hibernate uncomment the following line
    #action=hibernate 
    # To Suspend uncomment the following line
    #action=suspend

> After closing lid

Edit the following file /etc/acpi/events/lid

    # This is called when the user closes the lid
    event=button/lid
    # To Hibernate uncomment the following line
    #action=hibernate 
    # To Suspend uncomment the following line
    #action=suspend

You can also install lidsleep which includes the file altered to use
pm-utils and suspend to RAM.

Alternatively you can edit /etc/acpi/actions/lm_lid.sh this is the file
that is executed when the lid state is changed

Example:

    #!/bin/bash
    # lid button pressed/released event handler
    #laptop mode helps minimized hdd activity
    test -x /usr/sbin/laptop_mode && /usr/sbin/laptop_mode auto
    # get the -xauth variable so we can access the display
    XAUTH="$( ps -C X f | sed -n 's/.*-auth \(.*\)/\1/p' )"
    if [[ -z $XAUTH ]]; then
      # if XAUTH is blank try another way to get it 
      XAUTH="$( ps -C xinit f | sed -n 's/.*-auth \(.*\)serverauth.*/\1Xauthority/p' )"
    fi
    #Find out if the lid is open or closed
    if grep -q open /proc/acpi/button/lid/LID/state; then
      # the screen is on, forces it to be on
      ACTION="on"
      XAUTHORITY=$XAUTH /usr/bin/xset -display :0.0 dpms force $ACTION
    else
      # screen is off, forces off
      ACTION="off"
      XAUTHORITY=$XAUTH /usr/bin/xset -display :0.0 dpms force $ACTION
      # script waits for 10 minutes
      sleep 10m
      # checks to make sure screen is still closed
      if grep -q closed /proc/acpi/button/lid/LID/state; then
        # if it is, then it suspends to disk
        s2disk
      else
        # or it turns it back on
        XAUTHORITY=$XAUTH /usr/bin/xset -display :0.0 dpms force on
      fi
    fi

The script turns the monitor off or on. But if the screen is left shut
for 10 minutes, it will suspend to the disk automatically.  man sleep
for more info on the sleep command.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suspending_to_Disk_with_hibernate-script&oldid=290385"

Category:

-   Power management

-   This page was last modified on 26 December 2013, at 02:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
