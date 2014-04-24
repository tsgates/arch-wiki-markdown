CrashPlan
=========

CrashPlan is a backup program that backs up data to remote servers,
other computers, or hard drives. Backing up to the cloud servers
requires a monthly subscription.

Contents
--------

-   1 Installation
-   2 Basic Usage
-   3 Troubleshooting
    -   3.1 Ignoring invalid environment 'export LC_ALL=en_US.utf8'
    -   3.2 Waiting for connection
    -   3.3 Waiting for Backup
-   4 See also

Installation
------------

Install crashplan from the AUR. There is also crashplan-pro and
crashplan-pro-e available which are the paid enterprise packages.

Basic Usage
-----------

CrashPlan can be entirely configured through its graphical user
interface. You can access it by:

    $ CrashPlanDesktop

Once configured you can control the CrashPlan service as follows:

    # systemctl {enable,disable,restart,stop} crashplan.service

Troubleshooting
---------------

> Ignoring invalid environment 'export LC_ALL=en_US.utf8'

Should your journal logs show this locale error, add the following line
to your ~/.bash_profile:

    export LC_ALL=en_US.UTF-8

> Waiting for connection

On some systems it can happen that CrashPlan does not wait until an
internet connection is established. If using NetworkManager, you can
install networkmanager-dispatcher-crashplan-systemd which will
automatically restart the CrashPlan service once a connection is
successfully established.

> Waiting for Backup

If the backup is stuck on «Waiting for Backup» even after you engage it
manually, it might be that CrashPlan cannot access the tempdir or it is
mounted as noexec. It uses the default Java tmp dir which is normally
/tmp. You can either remove the noexec mount option (not recommended) or
change the tmpdir CrashPlan is using.

To change the tmpdir CrashPlan uses, open /opt/crashplan/bin/run.conf
and insert -Djava.io.tmpdir=/new-tempdir to SRV_JAVA_OPTS, for example:

    SRV_JAVA_OPTS="-Djava.io.tmpdir=/var/tmp/crashplan -Dfile.encoding=UTF-8 …

Make sure to create the new tmpdir and verify CrashPlan's user has
access to it.

    $ mdir /var/tmp/crashplan

Restart CrashPlan

    $ systemctl restart crashplan

See also
--------

-   Backup Programs
-   CrashPlan home page
-   Wikipedia:CrashPlan

Retrieved from
"https://wiki.archlinux.org/index.php?title=CrashPlan&oldid=287714"

Categories:

-   Data compression and archiving
-   System recovery

-   This page was last modified on 12 December 2013, at 12:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
