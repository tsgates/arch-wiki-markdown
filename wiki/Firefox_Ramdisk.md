Firefox Ramdisk
===============

Assuming that there is memory to spare, placing Firefox's cache or
complete profile to RAM offers significant advantages. Even though
opting for the partial route is an improvement by itself, the latter can
make Firefox even more responsive compared to its stock configuration.
Benefits include, among others:

-   reduced drive read/writes;
-   heightened responsive feel;
-   many operations within Firefox, such as quick search and history
    queries, are nearly instantaneous.

To do so we can make use of a tmpfs.

Because data placed therein cannot survive a shutdown, a script
responsible for syncing back to drive prior to system shutdown is
necessary if persistence is desired (whick is likely in the case of
profile relocation). On the other hand, only relocating the cache is a
quick, less inclusive solution that will slightly speeds up experience
while emptying Firefox cache on every reboot.

Note:Cache is stored separately from Firefox default profiles' folder
(/home/$USER/.mozilla/firefox/): it is found by default in
/home/$USER/.cache/mozilla/firefox/<profile>. This is similar to what
Chromium and other browsers do. Therefore, sections 2 and 3.2 don't deal
with cache relocating and syncing but only with profile adjustments. See
the note at Profile-sync-daemon#Benefits_of_psd for more details.
Anything-sync-daemon may be used to achieve the same thing as Option 2
for cache folders.

Contents
--------

-   1 Relocate cache only to RAM
-   2 Place entire profile in RAM
-   3 Manual method
    -   3.1 Relocating only the cache to RAM
    -   3.2 Relocating the entire profile to RAM
        -   3.2.1 Before you start
        -   3.2.2 The script
        -   3.2.3 Automation
            -   3.2.3.1 cron job
            -   3.2.3.2 Sync at login/logout
-   4 See also

Relocate cache only to RAM
--------------------------

When a page is loaded, it can be cached so it doesn't need to be
downloaded to be redisplayed. For e-mail and news, messages and
attachments are cached as well. Firefox can be configured to use only
RAM as cache storage. Configuration files, bookmarks, extensions etc.
will be written to drive as usual. For this:

-   open about:config in the address bar
-   set browser.cache.disk.enable to "false" (double click the line)
-   verify that browser.cache.memory.enable is set to "true" (default
    value)
-   set browser.cache.memory.max_entry_size to the amount of KB you'd
    like to spare, or to -1 for automatic cache size selection.

Main disadvantages of this method are that the content of currently
browsed webpages is lost if browser crashes or after a reboot, and that
the settings need to be configured for each user individually.

A workaround for the first drawback is to use anything-sync-daemon or
similar periodically-syncing script so that cache gets copied over to
the drive on a regular basis.

  

Place entire profile in RAM
---------------------------

Relocate the browser profile to tmpfs so as to globally improve
browser's responsiveness. Another benefit is a reduction in drive I/O
operations, of which SSDs benefit the most.

Use an active management script for maximal reliability and ease of use.
Several are available from the AUR.

-   profile-sync-daemon - refer to the Profile-sync-daemon wiki article
    for additional info on it;
-   firefox-sync

Manual method
-------------

> Relocating only the cache to RAM

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This sections    
                           mentions the             
                           /home/<user>/.mozilla/fi 
                           refox/default/Cache      
                           folder, which doesn't    
                           exist as of 2014.02 and  
                           has been superseded by   
                           /home/$USER/.cache/mozil 
                           la/firefox/<profile>.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

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
"https://wiki.archlinux.org/index.php?title=Firefox_Ramdisk&oldid=296227"

Categories:

-   Scripts
-   Web Browser

-   This page was last modified on 4 February 2014, at 20:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
