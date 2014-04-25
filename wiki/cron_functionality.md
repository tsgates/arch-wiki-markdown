systemd/cron functionality
==========================

Related articles

-   systemd
-   systemd/User
-   systemd/Services
-   systemd FAQ
-   cron

Systemd is capable of taking on a significant subset of the
functionality of Cron through built in support for calendar time events
(from systemd version 197) as well as monotonic time events.

Contents
--------

-   1 Introduction
-   2 Hourly, daily, weekly, monthly and yearly events
    -   2.1 Hourly events
    -   2.2 Daily events
    -   2.3 Weekly events
    -   2.4 Monthly events
    -   2.5 Yearly events
    -   2.6 Adding events
    -   2.7 Some important default Arch Linux cronjobs
        -   2.7.1 logrotate
        -   2.7.2 man-db
        -   2.7.3 shadow
    -   2.8 Enable and start the timers
-   3 Starting events according to the calendar
-   4 Custom/example service files
    -   4.1 Reflector
    -   4.2 pkgstats
    -   4.3 Update mlocate database
    -   4.4 The modprobed_db service
    -   4.5 The hosts-update service
-   5 See also

Introduction
------------

While Cron has been a stalwart on the Linux landscape for years, it
still provides no way to detect job failures, establish job
dependencies, or allocate processes to cgroups. If you require any of
this functionality, systemd provides a good structure to set up job
scheduling. While doing so is slightly more cumbersome than relying on
dcron or cronie, the benefits are not insignificant:

-   Last status and logging outputs can be got through journalctl. This
    enables proper debugging
-   Systemd has a lot of options which are useful for setting the
    environment for the job to be done properly (eg
    IOSchedulingPriority, Nice or JobTimeoutSec)
-   These jobs can be made to depend on other systemd units if required

Hourly, daily, weekly, monthly and yearly events
------------------------------------------------

One strategy which can be used for recreating this functionality is
through timers which call in targets. All services which need to be run
hourly can be called in as dependencies of these targets. The strategy
mentioned here has been detailed first in this blogpost.

Note:There is an AUR package systemd-cron which uses a slightly
different strategy to do what is being done here. If you wish to use
this package, then the following scripts might need to be modified and
their locations changed for them to work properly.

First, the creation of a few directories is required:

    # mkdir /etc/systemd/system/timer-{hourly,daily,weekly,monthly,yearly}.target.wants

The following files will need to be created in the paths specified in
order for this to work.

> Hourly events

    /etc/systemd/system/timer-hourly.timer

    [Unit]
    Description=Hourly Timer

    [Timer]
    OnBootSec=5min
    OnUnitActiveSec=1h
    Unit=timer-hourly.target

    [Install]
    WantedBy=basic.target

    /etc/systemd/system/timer-hourly.target

    [Unit]
    Description=Hourly Timer Target
    StopWhenUnneeded=yes

> Daily events

    /etc/systemd/system/timer-daily.timer

    [Unit]
    Description=Daily Timer

    [Timer]
    OnBootSec=10min
    OnUnitActiveSec=1d
    Unit=timer-daily.target

    [Install]
    WantedBy=basic.target

    /etc/systemd/system/timer-daily.target

    [Unit]
    Description=Daily Timer Target
    StopWhenUnneeded=yes

Systemd does not currently reschedule timers based on the last time they
were run if the system is rebooted in between, i.e. it does not
implement an anacron replacement. However, anacron can be used in
conjunction with Systemd by updating the anacron timestamps through an
hourly Systemd timer.

> Weekly events

    /etc/systemd/system/timer-weekly.timer

    [Unit]
    Description=Weekly Timer

    [Timer]
    OnBootSec=15min
    OnCalendar=weekly
    Unit=timer-weekly.target

    [Install]
    WantedBy=basic.target

    /etc/systemd/system/timer-weekly.target

    [Unit]
    Description=Weekly Timer Target
    StopWhenUnneeded=yes

> Monthly events

    /etc/systemd/system/timer-monthly.timer

    [Unit]
    Description=Monthly Timer

    [Timer]
    OnBootSec=45min
    OnCalendar=monthly
    Unit=timer-monthly.target

    [Install]
    WantedBy=basic.target

    /etc/systemd/system/timer-monthly.target

    [Unit]
    Description=Monthly Timer Target
    StopWhenUnneeded=yes

> Yearly events

    /etc/systemd/system/timer-yearly.timer

    [Unit]
    Description=Yearly Timer

    [Timer]
    OnBootSec=90min
    OnCalendar=yearly
    Unit=timer-yearly.target

    [Install]
    WantedBy=basic.target

    /etc/systemd/system/timer-yearly.target

    [Unit]
    Description=Yearly Timer Target
    StopWhenUnneeded=yes

> Adding events

Adding events to these targets is as easy as dropping them into the
correct wants folder. So if you wish for a particular job to take place
daily, create a systemd service file and drop it into the relevant
folder.

For example, if you wish to run foo.service daily (which runs program
bar), you would create the following file:

    /etc/systemd/system/timer-daily.target.wants/foo.service

    [Unit]
    Description=Starts program bar

    [Service]
    User=                                          # Add a user if you wish the service to be executes as a particular user, else delete this line
    Type=                                          # Simple by default, change it if you know what you are doing, else delete this line
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    ExecStart=/usr/bin/bar --option1 --option2     # More than one ExecStart can be used if required

> Some important default Arch Linux cronjobs

If you wish to completely migrate away from cron to systemd, then it is
prudent to have these services up and running for your system to remain
workable.

logrotate

This service runs logrotate, which rotates, compresses and mails system
logs. It relies upon package logrotate which by default provides a cron
job for this task (/etc/cron.daily/updatedb). See man logrotate for
details.

    /etc/systemd/system/timer-daily.target.wants/logrotate.service

    [Unit]
    Description=Rotate Logs

    [Service]
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    ExecStart=/usr/bin/logrotate /etc/logrotate.conf

man-db

This service runs mandb, which creates or updates the manual page index
caches. It relies upon package man-db which by default provides a cron
job for this task (/etc/cron.daily/man-db). See man mandb for details.

    /etc/systemd/system/timer-daily.target.wants/man-db-update.service

    [Unit]
    Description=Update man-db

    [Service]
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    ExecStart=/usr/bin/mandb --quiet

shadow

This service runs pwck and grpck, which together verify integrity of
password and group files (/etc/{passwd,shadow,group,gshadow} ). Those
tools are provided by the shadow package, which by default provides a
cron job for this task (/etc/cron.daily/shadow). See man shadow,
man pwck and man grpck for details.

    /etc/systemd/system/timer-daily.target.wants/verify-shadow.service

    [Unit]
    Description=Verify integrity of password and group files

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/pwck -r
    ExecStart=/usr/bin/grpck -r

> Enable and start the timers

    # systemctl enable timer-{hourly,daily,weekly,monthly,yearly}.timer 
    # systemctl start timer-{hourly,daily,weekly,monthly,yearly}.timer

Starting events according to the calendar
-----------------------------------------

If you wish to start a service according to a calendar event and not a
monotonic interval (i.e. you wish to replace the functionality of
crontab), you will need to create a new timer and link your service file
to that. An example would be:

    /etc/systemd/system/foo.timer

    [Unit]
    Description=foo timer

    [Timer]
    OnCalendar=Mon-Thu *-9-28 *:30:00 # To add a time of your choosing here, please refer to systemd.time manual page for the correct format
    Unit=foo.service

    [Install]
    WantedBy=basic.target

The service file may be created the same way as the events for monotonic
clocks. However, take care to put them in the /etc/systemd/system/
folder.

Custom/example service files
----------------------------

Note:These example scripts assume that you have created the hourly,
daily and weekly timers as described above.

> Reflector

This service file may be used to update pacman's mirrorlist daily using
the reflector script.

    /etc/systemd/system/timer-daily.target.wants/reflector.service

    [Unit]
    Description=Update the mirrorlist

    [Service]
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    Type=oneshot
    ExecStart=/usr/bin/reflector --protocol http --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist

Note:Reflector's options should be tweaked according to users' criteria.
Use case examples may be found in this forum post by Moderator/TU Xyne.

> pkgstats

If you have pkgstats installed, this service will be necessary in order
to send data back to the Arch servers.

Tip:It should be noted that the user nobody, which is being used here,
is already present on all Arch systems. The use of this user is
recommended for all services which can function in a completely
unprivileged environment.

    /etc/systemd/system/timer-weekly.target.wants/pkgstats.service

    [Unit]
    Description=Run pkgstats

    [Service]
    User=nobody
    ExecStart=/usr/bin/pkgstats -q

> Update mlocate database

This service runs updatedb, which updates the mlocate database. The
package mlocate provides by default a cron job for this task
(/etc/cron.daily/updatedb). See man 8 updatedb for details.

    /etc/systemd/system/timer-daily.target.wants/mlocate-update.service

    [Unit]
    Description=Update mlocate database

    [Service]
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    ExecStart=/usr/bin/updatedb -f proc

> The modprobed_db service

This service is of great use to people who compile their own kernels
because it reduces compilation time by a significant amount. Refer to
the Modprobed_db page for further details.

    /etc/systemd/system/timer-daily.target.wants/modprobed_db.service

    [Unit]
    Description=Run modprobed_db

    [Service]
    User=enter user here
    ExecStart=/usr/bin/modprobed_db store

> The hosts-update service

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: missing package  
                           requirements, is it      
                           hosts-update? (Discuss)  
  ------------------------ ------------------------ ------------------------

Updates /etc/hosts with the mvps blocklist.

    /etc/systemd/system/timer-daily.target.wants/hosts-update.service

    [Unit]
    Description=Update hosts file
    After=network.target

    [Service]
    Nice=19
    IOSchedulingClass=2
    IOSchedulingPriority=7
    ExecStart=/usr/bin/hosts-update

    [Install]
    WantedBy=timer-daily.target

See also
--------

-   https://fedoraproject.org/wiki/Features/SystemdCalendarTimers -
    systemd calendar timers on the Fedora Project wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd/cron_functionality&oldid=303601"

Categories:

-   Daemons and system services
-   Boot process

-   This page was last modified on 8 March 2014, at 14:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
