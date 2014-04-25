Improve pacman performance
==========================

Contents
--------

-   1 Improving database access speeds
-   2 Improving download speeds
    -   2.1 Using Powerpill
    -   2.2 Using powerpill-light (deprecated)
    -   2.3 Using wget
    -   2.4 Using aria2
        -   2.4.1 Installation
        -   2.4.2 Configuration
        -   2.4.3 Option Details
        -   2.4.4 Additional notes
    -   2.5 pacget (aria2) mirror script
    -   2.6 Using other applications
-   3 Choosing the fastest mirror
-   4 Sharing packages over your LAN

Improving database access speeds
--------------------------------

Pacman stores all package information in a collection of small files,
one for each package. Improving database access speeds reduces the time
taken in database-related tasks, e.g. searching packages and resolving
package dependencies. The safest and easiest method is to run as root:

    # pacman-optimize

This will attempt to put all the small files together in one (physical)
location on the hard disk so that the hard disk head does not have to
move so much when accessing all the packages. This method is safe, but
is not foolproof. It depends on your filesystem, disk usage and empty
space fragmentation. Another more aggressive option would be to first
remove uninstalled packages from cache and to remove unused repositories
before database optimization:

    # pacman -Sc && pacman-optimize

Improving download speeds
-------------------------

Note:If your download speeds have been reduced to a crawl, ensure you
are using one of the many mirrors and not ftp.archlinux.org, which is
throttled since March 2007.

Pacman's speed in downloading packages can be improved by using a
different application to download packages instead of Pacman's built-in
file downloader.

In all cases, make sure you have the latest Pacman before doing any
modifications.

    # pacman -Syu

> Using Powerpill

Powerpill is a full wrapper for Pacman that uses parallel and segmented
downloads to speed up the download process. Normally Pacman will
download one package at a time, waiting for it to complete before
beginning the next download. Powerpill takes a different approach: it
tries to download as many packages as possible at once.

The Powerpill wiki page provides basic configuration and usage examples
along with package and upstream links.

> Using powerpill-light (deprecated)

pacman2aria2 provides a script named "powerpill-light", which was a
stopgap created after the deprecation of the original powerpill written
in Perl. Now that Powerpill has been re-released, powerpill-light is
deprecated.

> Using wget

This is also very handy if you need more powerful proxy settings than
pacman's built-in capabilities.

To use wget, first install it with pacman -S wget and then modify
/etc/pacman.conf by uncommenting the following line in the [options]
section:

    XferCommand = /usr/bin/wget -c --passive-ftp -c %u

Instead of uncommenting the wget parameters in /etc/pacman.conf, you can
also modify the wget configuration file directly (the system-wide file
is /etc/wgetrc, per user files are $HOME/.wgetrc.

> Using aria2

aria2 is a lightweight download utility with support for resumable and
segmented HTTP/HTTPS and FTP downloads. aria2 allows for multiple and
simultaneous HTTP/HTTPS and FTP connections to an Arch mirror, which
should result in an increase in download speeds for both file and
package retrieval.

Note:Using aria2c in Pacman's XferCommand will not result in parallel
downloads of multiple packages. Pacman invokes the XferCommand with a
single package at a time and waits for it to complete before invoking
the next. To download multiple packages in parallel, see the powerpill
section above.

Installation

Download and install aria2 and its dependencies:

    # pacman -S aria2

Configuration

Edit /etc/pacman.conf by adding the following line to the [options]
section:

    XferCommand = /usr/bin/aria2c --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 -x2 --max-file-not-found=5 -k5M --no-conf -Rtrue --summary-interval=60 -t5 -d / -o %o %u

Option Details

 /usr/bin/aria2c 
    The full PATH to the aria2 executable.
 --allow-overwrite=true 
    Restart download if a corresponding control file does not exist.
    (Default: false)
 -c, --continue 
    Continue downloading a partially downloaded file if a corresponding
    control file exists.
 --file-allocation=none 
    Do not pre-allocate file space before download begins. (Default:
    prealloc) 1
 --log-level=error 
    Set log level to output errors only. (Default: debug)
 -m2, --max-tries=2 
    Make 2 maximum attempts to download specified file(s) per mirror.
    (Default: 5)
 -x2, --max-connection-per-server=2 
    Set a maximum of 2 connections to each mirror per file. (Default: 1)
 --max-file-not-found=5 
    Force download to fail if a single byte is not received within 5
    attempts. (Default: 0)
 -k5M, --min-split-size=5M 
    Only split the file if the size is larger than 2;5MB = 10MB.
    (Default: 20M)
 --no-conf 
    Disable loading an aria2.conf file if it exists. (Default:
    ~/.aria2/aria2.conf)
 -Rtrue, --remote-time=true 
    Apply timestamps of the remote file(s) and apply them to the local
    file(s). (Default: false)
 --summary-interval=60 
    Output download progress summary every 60 seconds. (Default: 60) 2
 -t5, --timeout=5 
    Set a 5 second timeout per mirror after a connection is established.
    (Default: 60)
 -d, --dir 
    The directory to store the downloaded file(s) as specified by
    pacman.
 -o, --out 
    The output file name(s) of the downloaded file(s).
 %o 
    Variable which represents the local filename(s) as specified by
    pacman.
 %u 
    Variable which represents the download URL as specified by pacman.

Additional notes

 1 --file-allocation=falloc 
    Recommended for newer file systems such as ext4 (with extents
    support), btrfs or xfs as it allocates large files (GB) almost
    instantly. Do not use falloc with legacy file systems such as ext3
    as prealloc consumes approximately the same amount of time as
    standard allocation would while locking the aria2 process from
    proceeding to download.

 2 --summary-interval=0 
    Supresses download progress summary output and may improve overall
    performance. Logs will continue to be output according to the value
    specified in the log-level option.

 3 XferCommand = /usr/bin/printf 'Downloading ' && echo %u | awk -F/ '{printf $NF}' && printf '...' && /usr/bin/aria2c -q --allow-overwrite=true -c --file-allocation=none --log-level=error -m2 --max-connection-per-server=2 --max-file-not-found=5 --min-split-size=5M --no-conf --remote-time=true --summary-interval=0 -t5 -d / -o %o %u && echo ' Complete!' 
    Using this XferCommand gives less useful, but much more readable,
    output.

> pacget (aria2) mirror script

This script will greatly improve the download speed for broadband users.
It uses the servers in /etc/pacman.d/mirrorlist as mirrors in aria2.
What happens is that aria2 downloads a single package from multiple
servers simultaneously which gives a huge boost in download speed.

Note:You have to put 'exec' before /usr/bin/pacget in the XferCommand.
This is needed so that when you terminate pacget or aria2 (with process
id used by pacget), pacman would also terminate. This would prevent
inconvenience because Pacman would not persist downloading a file when
you tell it not to.

Warning:You may experience some problems if the mirrors used are
out-of-sync or are simply not up-to-date. Just use the Reflector script
to generate a list of up-to-date and fast mirrors. Also,
ftp.archlinux.org resolves to two IPs. You may want to choose only one
of them and hard code ftp.archlinux.org and the chosen IP address to
/etc/hosts.

    /usr/bin/pacget

    #!/bin/bash

    msg() {
      echo ""
      echo -e "   \033[1;34m->\033[1;0m \033[1;1m${1}\033[1;0m" >&2
    }

    error() {
      echo -e "\033[1;31m==> ERROR:\033[1;0m \033[1;1m$1\033[1;0m" >&2
    }

    CONF=/etc/pacget.conf
    STATS=/etc/pacget.stats
    ARIA2=$(which aria2c 2> /dev/null)

    # ----- do some checks first -----
    if [ ! -x "$ARIA2" ]; then
      error "aria2c was not found or isn't executable."
      exit 1
    fi

    if [ $# -ne 2 ]; then
      error "Incorrect number of arguments"
      exit 1
    fi

    filename=$(basename $1)
    server=${1%/$filename}
    arch=$(grep ^Architecture /etc/pacman.conf | cut -d '=' -f2 | sed 's/ //g')
    if [[ $arch = "auto" ]]; then
      arch=$(uname -m)
    fi
    # Determine which repo is being used
    repo=$(awk -F'/' '$(NF-2)~/^(community|core|extra|testing|comunity-testing|multilib)$/{print $(NF-2)}' <<< $server)
    [ -z $repo ] && repo="custom"

    # For db files, or when using a custom repo (which most likely doesn't have any mirror),
    # use only the URL passed by pacman; Otherwise, extract the list of servers (from the include file of the repo) to download from
    url=$1
    if ! [[ $filename = *.db || $repo = "custom" ]]; then
      mirrorlist=$(awk -F' *= *' '$0~"^\\["r"\\]",/Include *= */{l=$2} END{print l}' r=$repo /etc/pacman.conf)
      if [ -n mirrorlist ]; then
        num_conn=$(grep ^split $CONF | cut -d'=' -f2)
        url=$(sed -r '/^Server *= */!d; s/Server *= *//; s/\$repo'"/$repo/"'; s/\$arch'"/$arch/; s/$/\/$filename/" $mirrorlist | head -n $(($num_conn *2)) )
      fi
    fi

    msg "Downloading $filename"
    cd /var/cache/pacman/pkg/

    touch $STATS

    $ARIA2 --conf-path=$CONF --max-tries=1 --max-file-not-found=5 \
      --uri-selector=adaptive --server-stat-if=$STATS --server-stat-of=$STATS \
      --allow-overwrite=true --remote-time=true --log-level=error --summary-interval=0 \
      $url --out=${filename}.pacget && [ ! -f ${filename}.pacget.aria2 ] && mv ${filename}.pacget $2 && chmod 644 $2

    exit $?

    /etc/pacget.conf

    # The log file
    log=/var/log/pacget.log
    # Number of servers to download from
    split=5
    # Minimum file size that justifies a split, i.e. concurrent download (default 20M)
    min-split-size=1M
    # Maximum download speed (0 = unrestricted)
    max-download-limit=0
    # Minimum download speed (0 = do not care)
    lowest-speed-limit=0
    # Server timeout period
    timeout=5
    # 'none' or 'falloc'
    file-allocation=none

Save this script as /usr/bin/pacget.

    # chmod 755 /usr/bin/pacget

This makes the script an executable

In /etc/pacman.conf, in the [options] section, the following needs to be
added:

    XferCommand = exec /usr/bin/pacget %u %o

Note:If you use ftp.archlinux.org as the first server listed in your
include files (/etc/pacman.d/*), some problems may occur when the
mirrors you are using have not yet synced. To make great use of this
script, choose a mirror (that syncs in a timely manner) that is more
appropriate for you, then put that on top of the server lists. This is
to prevent downloading only from ftp.archlinux.org when the mirrors have
not yet synced. The rankmirrors script can be useful in this case.

> Using other applications

There are other downloading applications that you can use with Pacman.
Here they are, and their associated XferCommand settings:

-   snarf: XferCommand = /usr/bin/snarf -N %u
-   lftp: XferCommand = /usr/bin/lftp -c pget %u
-   axel: XferCommand = /usr/bin/axel -n 2 -v -a -o %o %u

Choosing the fastest mirror
---------------------------

When downloading packages pacman uses the mirrors in the order they are
in /etc/pacman.d/mirrorlist. The mirror which is at the top of the list
by default however may not be the fastest for you. To select a faster
mirror, see Mirrors.

Sharing packages over your LAN
------------------------------

If you happen to run several Arch boxes on your LAN, you can share
packages so that you can greatly decrease your download times. Keep in
mind you should not share between different architectures (i.e. i686 and
x86_64) or you'll get into troubles.

See Pacman_Tips#Network_shared_pacman_cache.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Improve_pacman_performance&oldid=300792"

Category:

-   Package management

-   This page was last modified on 23 February 2014, at 16:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
