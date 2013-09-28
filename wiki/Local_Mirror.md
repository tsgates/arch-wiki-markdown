Local Mirror
============

Warning: If you want to create an official mirror see this page.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 STOP                                                               |
|     -   1.1 Alternatives:                                                |
|                                                                          |
| -   2 Local Mirror                                                       |
|     -   2.1 Things to keep in mind:                                      |
|     -   2.2 Server Configuration                                         |
|         -   2.2.1 Building Rsync Command                                 |
|         -   2.2.2 Example Script                                         |
|         -   2.2.3 Another mirror script using lftp                       |
|         -   2.2.4 Partial mirroring                                      |
|         -   2.2.5 Serving                                                |
|                                                                          |
|     -   2.3 Client Configuration                                         |
+--------------------------------------------------------------------------+

STOP
----

Warning:It is generally frowned upon to create a local mirror due the
bandwidth that is required. One of the alternatives will likely fulfill
your needs. Please look at the alternatives below.

Alternatives:

-   Network Shared Pacman Cache

Local Mirror
------------

> Things to keep in mind:

-   Bandwidth is not free for the mirrors. They must pay for all the
    data they serve you
    -   This still applies although you pay your ISP

-   There are many packages that will be downloaded that you will likely
    never use
-   Mirror operators will much prefer you to download only the packages
    you need
-   Really please look at the alternatives above

If you are absolutely certain that a local mirror is the only sensible
solution, then follow the pointers below.

> Server Configuration

Building Rsync Command

-   Use the rsync arguments from DeveloperWiki:NewMirrors
-   Select a server from the above article
-   Exclude folder/files you do not want by including
    --exclude-from="/path/to/exclude.txt" in the rsync arguments.
    Example contents might include:

    iso

    #Exclude i686 Packages
    */os/i686
    pool/*/*-i686.pkg.tar.xz
    pool/*/*-i686.pkg.tar.gz

    #Exclude x86_64 Packages
    */os/x86_64
    pool/*/*-x86_64.pkg.tar.xz
    pool/*/*-x86_64.pkg.tar.gz

-   All packages reside in the pool directory. Symlinks are then created
    from pool to core/extra/testing/etc..
    -   As of 9/21/2010 this migration is not yet complete.
        -   There may be actual packages, instead of symlinks, in
            ${repo}/os/${arch}

-   Exclude any top-level directories that you do not need

Example:
rsync $rsync_arguments --exclude="/path/to/exclude.txt" rsync://example.com/ /path/to/destination

Example Script

Warning:DO NOT USE THIS SCRIPT UNLESS YOU HAVE READ WARNINGS AT THE
START OF THIS ARTICLE

Warning:Only use this script to sync Core/Extra/Community! If you need
Testing, gnome-unstable or any other repo, use rsync --exclude instead!

Yes, this script is partially broken ON PURPOSE to avoid people doing
copy-and-paste to create their own mirror. It should be easy to fix if
you REALLY want a mirror.

    #!/bin/bash

    #################################################################################################
    ### It is generally frowned upon to create a local mirror due the bandwidth that is required.
    ### One of the alternatives will likely fulfill your needs.
    ### REMEMBER:
    ###   * Bandwidth is not free for the mirrors. They must pay for all the data they serve you
    ###       => This still applies although you pay your ISP 
    ###       => There are many packages that will be downloaded that you will likely never use
    ###       => Mirror operators will much prefer you to download only the packages you need
    ###   * Really please look at the alternatives on this page:
    ###       https://wiki.archlinux.org/index.php?title=Local_Mirror
    ### If you are ABSOLUTELY CERTAIN that a local mirror is the only sensible solution, then this
    ### script will get you on your way to creating it. 
    #################################################################################################

    # Configuration
    SOURCE='rsync://mirror.example.com/archlinux'
    DEST='/srv/mirrors/archlinux'
    BW_LIMIT='500'
    REPOS='core extra'
    RSYNC_OPTS="-rtlHq --delete-after --delay-updates --copy-links --safe-links --max-delete=1000 --bwlimit=${BW_LIMIT} --delete-excluded --exclude=.*"
    LCK_FLE='/var/run/repo-sync.lck'

    # Make sure only 1 instance runs
    if [ -e "$LCK_FLE" ] ; then
    	OTHER_PID=`/bin/cat $LCK_FLE`
    	echo "Another instance already running: $OTHER_PID"
    	exit 1
    fi
    echo $$ > "$LCK_FLE"

    for REPO in $REPOS ; do
    	echo "Syncing $REPO"
    	/usr/bin/rsync $RSYNC_OPTS ${SOURCE}/${REPO} ${DEST}
    done

    # Cleanup
    /bin/rm -f "$LCK_FLE"

    exit 0

Another mirror script using lftp

lftp can mirror via several different protocols: ftp, http, etc. It also
restarts on error, and can run in the background. Put this into your
$PATH for an easy way to mirror that continues if you log out.

    #!/usr/bin/lftp -f
    lcd /local/path/to/your/mirror
    open ftp.archlinux.org (or whatever your favorite mirror is)
    # Use 'cd' to change into the proper directory on the mirror, if necessary.
    mirror -cve -X *i686* core &
    mirror -cve -X *i686* extra &
    mirror -cve -X *i686* community &
    mirror -cve -X *i686* multilib &
    lcd pool
    cd pool
    mirror -cve -X *i686* community &
    mirror -cve -X *i686* packages &

if you want to see the current status of the mirror. open lftp on
terminal and type 'attach <PID>'

Partial mirroring

Mirroring only some repositories is definitely not easy, due to the
centralization of most packages in `pool/`. See this blog post for an
attempt at writing a script for this task.

Serving

-   HTTP (LAN)
    -   LAMP
    -   Lighttpd

-   FTP (LAN)
    -   vsftpd

-   Physical Media
    -   Flash Drive
    -   External HD

> Client Configuration

-   Add the proper Server= variable in /etc/pacman.d/mirrorlist
-   For physical media (such as flash drive) the following can be used:
    Server = file:///mnt/media/repo/$repo/os/$arch (where
    /mnt/media/repo is directory where local mirror located)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Local_Mirror&oldid=238834"

Category:

-   Package management
