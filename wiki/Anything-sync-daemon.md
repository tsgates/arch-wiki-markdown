Anything-sync-daemon
====================

Summary help replacing me

Anything-sync-daemon (asd) is a is a diminutive pseudo-daemon designed
to manage target directories in tmpfs and to periodically sync them back
to your physical disc (HDD/SSD). This is accomplished via a symlinking
step and an innovative use of rsync to maintain back-up and
synchronization between the two. One of the major design goals of asd is
a completely transparent user experience.

> Related

Profile-sync-daemon

Contents
--------

-   1 Asd or Psd?
-   2 Benefits of Asd
-   3 Setup and Installation
    -   3.1 Edit /etc/asd.conf
    -   3.2 Using asd
        -   3.2.1 Systemd
    -   3.3 Debug Mode
    -   3.4 Sync at More Frequent Intervals (Optional)
-   4 Support

Asd or Psd?
-----------

Note:If syncing browser profiles is desired, it is recommended NOT to
use asd for this purpose. Instead, use psd which has built in sanity
checks for unique situations specific to running a browser profile in
tmpfs. Anything-sync-daemon does not have these checks; under certain
circumstances, browser profile data can be lost. You have been warned.

Benefits of Asd
---------------

Running this daemon is beneficial for two reasons:

1.  Reduced wear to physical discs
2.  Speed

Since the target directories are relocated into tmpfs, the corresponding
onslaught of I/O associated with system usage of them is also redirected
from the physical disc to RAM, thus reducing wear to the physical disc
and also improving speed and responsiveness. The access time of RAM is
on the order of nanoseconds while the access time of physical discs is
on the order of milliseconds. This is a difference of six orders of
magnitude or 1,000,000 times faster.

Setup and Installation
----------------------

Anything-sync-daemon is available for download from the AUR. Build it
and install like any other package.

> Edit /etc/asd.conf

User managed settings are defined in /etc/asd.conf which is included in
the package. At a minimum, define the target directory/directories to be
managed by asd.

Example:

    WHATTOSYNC=('/var/lib/monitorix' '/srv/http' '/foo/bar')

Optionally redefine the location of your distro's tmpfs. Do this by
uncommenting and redefining the VOLATILE variable. Note that for Arch
Linux, the default value of "/dev/shm" should work just fine. Be sure to
read the warning about using software such as bleachbit with asd since
bleachbit likes to remove files stored in /tmp. This is why a value of
/dev/shm is better.

Optionally redefine the permissions of the link in tmpfs. The default is
700 to protect privacy of users.

> Using asd

Do not call /usr/bin/anything-sync-daemon directly (except to view debug
mode). The initial synchronization will occur when the daemon starts.
Additionally, cron (if running on your system) will call it to sync or
update once per hour. Finally, asd will sync back a final time when it
is called to stop.

Systemd

The provided daemon file should be used to interact with asd
(/usr/lib/systemd/system/asd.service):

    # systemctl [option] asd.service

Available options:

    start  Turn on daemon; make symlinks and actively manage targets in tmpfs.
    stop  Turn off daemon; remove symlinks and rotate tmpfs data back to disc.
    enable  Autostart daemon when system comes up.
    disable  Remove daemon from the list of autostart daemons.

> Debug Mode

The debug option can be called to show users exactly what asd will do
based on the /etc/asd.conf entered. Call it like so:

    $ anything-sync-daemon debug

> Sync at More Frequent Intervals (Optional)

Note:This step is NOT required. asd will update once per hour on its
own.

Users wishing to have syncs occur more frequently can simply add a line
to the root crontab to call the sync function of asd like so:

    # crontab -e

Example syncing targets once every ten minutes:

     */10 * * * *     /usr/bin/anything-sync-daemon resync &> /dev/null

Support
-------

Post in the discussion thread with comments or concerns.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Anything-sync-daemon&oldid=264000"

Category:

-   Scripts

-   This page was last modified on 23 June 2013, at 20:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
