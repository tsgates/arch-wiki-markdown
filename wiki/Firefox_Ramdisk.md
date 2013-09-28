Firefox Ramdisk
===============

Assuming that there is memory to spare, caching all, or part of
Firefox's profile to RAM using tmpfs offers significant advantages. Even
though opting for the partial route is an improvement by itself, the
latter can make Firefox even more responsive compared to its stock
configuration. Benefits include, among others:

-   reduced disk read/writes
-   heightened responsive feel
-   many operations within Firefox, such as quick search and history
    queries, are nearly instantaneous

Both of previously mentioned options make use of tmpfs.

Because data placed therein cannot survive a shutdown, a script used
when moving the whole profile to RAM overcomes this limitation by
syncing back to disk prior system shut down, whereas only relocating the
cache is a quick, less inclusive solution.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Method 1: Use RAM-only cache                                       |
| -   2 Method 2: Use PKG from the AUR                                     |
| -   3 Method 3: Build your own system                                    |
|     -   3.1 Relocating only the cache to RAM                             |
|     -   3.2 Relocating the entire profile to RAM                         |
|         -   3.2.1 Before you start                                       |
|         -   3.2.2 The script                                             |
|         -   3.2.3 Automation                                             |
|             -   3.2.3.1 cron job                                         |
|             -   3.2.3.2 Sync at login/logout                             |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Method 1: Use RAM-only cache
----------------------------

Firefox can be configured to use only RAM as cache storage.
Configuration files, bookmarks, extensions etc. will be written to
harddisk/SSD as usual. For this

-   open about:config in the address bar
-   set browser.cache.disk.enable to "false" (double click the line)
-   set browser.cache.memory.enable to "true" (double click the line)
-   set browser.cache.memory.max_entry_size to the ammount of KB you'd
    like to spare, to -1 for automatic cache size selection

Main disadvantages of this method are that your tabs won't survive a
browser crash, and that you need to configure the settings each user
individually. On the other hand on a personal system it probably is the
easiest method to implement.

Method 2: Use PKG from the AUR
------------------------------

Relocate the browser profile to tmpfs filesystem, including /tmp for
improvements in application response as the the entire profile is now
stored in RAM. Another benefit is a reduction in disk read and write
operations, of which SSDs benefit the most.

Use an active management script for maximal reliability and ease of use.
Several are available from the AUR.

-   profile-sync-daemon - refer to the Profile-sync-daemon wiki article
    for additional info on it;
-   firefox-tmpfs-daemon
-   firefox-sync

Method 3: Build your own system
-------------------------------

> Relocating only the cache to RAM

Adapted from this forum post

After entering about:config into the address bar, create a new string by
right-clicking in the bottom half, selecting New, followed by String.
Assign its value:

    browser.cache.disk.parent_directory

Now, double-click the newly created string and direct it towards the RAM
directory:

    /dev/shm/firefox-cache

Upon restarting Firefox, it will start using /dev/shm/firefox-cache as
the cache directory. Do mind that the directory and its contents will
not be saved after a reboot using this method.

Alternative way: in /etc/fstab

     tmpfs     /home/<user>/.mozilla/firefox/default/Cache tmpfs mode=1777,noatime 0 0

> Relocating the entire profile to RAM

Before you start

Before potentially compromising Firefox's profile, be sure to make a
backup for quick restoration. Replace xyz.default as appropriate and use
tar to make a backup:

    $ tar zcvfp ~/firefox_profile_backup.tar.gz ~/.mozilla/firefox/xyz.default

The script

Adapted from verot.net's Speed up Firefox with tmpfs

The script will first move Firefox's profile to a new static location,
make a sub-directory in /dev/shm, softlink to it and later populate it
with the contents of the profile. As before, replace the bold sections
to suit. The only value that absolutely needs to be altered is, again,
xyz.default.

Be sure that rsync is installed and save the script to
~/bin/firefox-sync, for example:

    firefox-sync

    #!/bin/sh

    static=main
    link=xyz.default
    volatile=/dev/shm/firefox-$USER

    IFS=
    set -efu

    cd ~/.mozilla/firefox

    if [ ! -r $volatile ]; then
    	mkdir -m0700 $volatile
    fi

    if [ "$(readlink $link)" != "$volatile" ]; then
    	mv $link $static
    	ln -s $volatile $link
    fi

    if [ -e $link/.unpacked ]; then
    	rsync -av --delete --exclude .unpacked ./$link/ ./$static/
    else
    	rsync -av ./$static/ ./$link/
    	touch $link/.unpacked
    fi

Close Firefox, make the script executable and test it:

    $ killall firefox firefox-bin
    $ chmod +x ~/bin/firefox-sync
    $ ~/bin/firefox-sync

Run Firefox again to gauge the results. The second time the script runs,
it will then preserve the RAM profile by copying it back to disk.

Automation

Seeing that forgetting to sync the profile can lead to disastrous
results, automating the process seems like a logical course of action.

cron job

Manipulate the user's cron table using crontab:

    $ crontab -e

Add a line to start the script every 30 minutes,

    */30 * * * * ~/bin/firefox-sync

or add the following to do so every 2 hours:

    0 */2 * * * ~/bin/firefox-sync

Sync at login/logout

Deeming bash is being used, add the script to the login/logout files:

    $ echo '~/bin/firefox-sync' | tee -a ~/.bash_logout ~/.bash_login >/dev/null

Note: You may wish to use ~/.bash_profile instead of ~/.bash_login as
bash will only read the first of these if both exist and are readable.

See also
--------

-   Fstab#tmpfs

Retrieved from
"https://wiki.archlinux.org/index.php?title=Firefox_Ramdisk&oldid=238382"

Categories:

-   Scripts
-   Web Browser
