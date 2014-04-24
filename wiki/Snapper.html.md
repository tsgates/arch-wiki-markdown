Snapper
=======

Related articles

-   Btrfs
-   mkinitcpio-btrfs
-   Btrfs - Tips and tricks

Snapper is a tool created by openSUSE's Arvin Schnell that helps with
managing snapshots of Btrfs subvolumes and LVM volumes. It can create
and compare snapshots, revert between snapshots, and supports automatic
snapshots timelines.

Contents
--------

-   1 Installation
-   2 Create a new configuration
-   3 Automatic timeline snapshots
-   4 Tips and Tricks
    -   4.1 Pre-post snapshots with pacman
-   5 Troubleshooting
-   6 Caveats
    -   6.1 Snapshots of root filesystem
    -   6.2 updatedb

Installation
------------

The stable version snapper can be installed from the official
repositories.

The development version snapper-git is available on the AUR.

Create a new configuration
--------------------------

To create a new configuration use the snapper create-config command.

Example for a subvolume mounted as /

    # snapper -c root create-config /

This will

-   create a config file in /etc/snapper/configs/root based on the
    default template from /etc/snapper/config-templates
-   create a subvolume .snapshots in the root of the subvolume
    (/.snapshots in this case)
-   add "root" to SNAPPER_CONFIGS in /etc/conf.d/snapper

At this point, the configuration is active. If your cron deamon is
running, snapper will start taking snapshots every hour. It is advised
to review the configuration file and set the desired amount of snapshots
to be kept.

Note:For informations on all settings in the config file see
man snapper-configs.

Automatic timeline snapshots
----------------------------

Snapper can create a snapshot timeline with a configurable number of
snapshots kept per hour/day/month/year.

The implementation works as follows:

-   By default a snapshot gets created once an hour (cron.hourly)
-   Once a day the "old and unwanted" snapshots get cleaned up by the
    timeline cleanup algorithm (cron.daily)

When creating a new configuration with snapper create-config as shown
above, this feature is enabled by default. To disable it, edit the
configuration file and set

    TIMELINE_CREATE="no"

The default settings will keep 10 hourly, 10 daily, 10 monthly and 10
yearly snapshots. You may want to change this, especially on busy
subvolumes like /. See #Caveats.

Here is an example for a configuration with only 7 days of snapshots, no
monthly, no yearly ones:

    /etc/snapper/configs/root

    # limits for timeline cleanup
    TIMELINE_MIN_AGE="1800"
    TIMELINE_LIMIT_HOURLY="5"
    TIMELINE_LIMIT_DAILY="7"
    TIMELINE_LIMIT_MONTHLY="0"
    TIMELINE_LIMIT_YEARLY="0"

The snapper -c root list output after some weeks:

    # snapper -c root list

    Type   | #    | Pre # | Date                     | User | Cleanup  | Description | Userdata
    -------+------+-------+--------------------------+------+----------+-------------+---------
    single | 0    |       |                          | root |          | current     |                                                                            
    single | 3053 |       | Tue Oct 22 00:01:02 2013 | root | timeline | timeline    |                                                                            
    single | 3077 |       | Wed Oct 23 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3101 |       | Thu Oct 24 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3125 |       | Fri Oct 25 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3149 |       | Sat Oct 26 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3173 |       | Sun Oct 27 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3197 |       | Sun Oct 27 23:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3198 |       | Mon Oct 28 00:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3199 |       | Mon Oct 28 01:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3200 |       | Mon Oct 28 02:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3201 |       | Mon Oct 28 03:01:02 2013 | root | timeline | timeline    |                                                                            
    single | 3202 |       | Mon Oct 28 04:01:01 2013 | root | timeline | timeline    |                                                                            
    single | 3203 |       | Mon Oct 28 05:01:02 2013 | root | timeline | timeline    |         
    single | 3204 |       | Mon Oct 28 06:01:01 2013 | root | timeline | timeline    |         
    single | 3205 |       | Mon Oct 28 07:01:02 2013 | root | timeline | timeline    |         
    single | 3206 |       | Mon Oct 28 08:01:01 2013 | root | timeline | timeline    |         
    single | 3207 |       | Mon Oct 28 09:01:01 2013 | root | timeline | timeline    |         
    single | 3208 |       | Mon Oct 28 10:01:01 2013 | root | timeline | timeline    |         
    single | 3209 |       | Mon Oct 28 11:01:01 2013 | root | timeline | timeline    |         
    single | 3210 |       | Mon Oct 28 12:01:01 2013 | root | timeline | timeline    |         
    single | 3211 |       | Mon Oct 28 13:01:01 2013 | root | timeline | timeline    |         
    single | 3212 |       | Mon Oct 28 14:01:01 2013 | root | timeline | timeline    |         
    single | 3213 |       | Mon Oct 28 15:01:01 2013 | root | timeline | timeline    |         
    single | 3214 |       | Mon Oct 28 16:01:01 2013 | root | timeline | timeline    |         
    single | 3215 |       | Mon Oct 28 17:01:01 2013 | root | timeline | timeline    |         
    single | 3216 |       | Mon Oct 28 18:01:01 2013 | root | timeline | timeline    |         
    single | 3217 |       | Mon Oct 28 19:01:01 2013 | root | timeline | timeline    |         
    single | 3218 |       | Mon Oct 28 20:01:01 2013 | root | timeline | timeline    |

Tips and Tricks
---------------

> Pre-post snapshots with pacman

Snapper can create snapshots "tagged" as pre or post snapshots. This is
handy when it comes to system upgrades. Using NUMBER_CLEANUP="yes" those
can get cleaned up after a configurable number of snapshots using the
number cleanup algorithm - see man snapper and man snapper-configs for
details.

To use this feature with pacman, you will need some wrapper script. User
erikw created one for this purpose called snp.

Download it, adjust the logfile location to your liking, put it
somewhere in your $PATH (e.g. /usr/local/bin/) and make it executable.
Usage example:

    # snp pacman -Syu

If you like, you can create an alias, similar to plain pacman aliases:

    alias sysupgrade='snp pacman -Syu'

Then you can do system upgrades with pre-post snapshots using

    # sysupgrade

Troubleshooting
---------------

Snapper writes all activity to /var/log/snapper.log - check this file
first if you think something goes wrong.

If you have issues with hourly/daily/weekly snapshots, the most common
cause for this so far has been that the cronie service (or whatever cron
daemon you're using) wasn't running.

Caveats
-------

> Snapshots of root filesystem

Many snapshots on a large timeframe of a busy filesystem (like /, where
many system updates happen over time) can cause serious slowdowns. You
can prevent it by:

-   Create subvolumes for things that are not worth to be snapshotted,
    like /var/cache/pacman/pkg and /var/abs.
-   Edit the default settings for hourly/daily/monthy/yearly snapshots
    when using #Automatic timeline snapshots.

> updatedb

By default, updatedb will also index the .snapshots directory created by
snapper, which can cause serious slowdown and excessive memory usage if
you have many snapshots. You can prevent updatedb from indexing over it
by editing:

    /etc/updatedb.conf

    PRUNENAMES = ".snapshots"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snapper&oldid=292091"

Category:

-   File systems

-   This page was last modified on 8 January 2014, at 20:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
