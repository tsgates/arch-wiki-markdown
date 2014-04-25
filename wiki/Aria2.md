Aria2
=====

From the project home page:

aria2 is a lightweight multi-protocol & multi-source command-line
download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink.
aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces.

Contents
--------

-   1 Installation
-   2 Execution
-   3 Configuration
    -   3.1 aria2.conf
    -   3.2 Example .bash_alias
    -   3.3 Example aria2.conf
        -   3.3.1 Option details
            -   3.3.1.1 Example input file #1
            -   3.3.1.2 Example input file #2
        -   3.3.2 Additional notes
    -   3.4 Example aria2.rapidshare
        -   3.4.1 Option details
        -   3.4.2 Additional notes
    -   3.5 Example aria2.bittorrent
        -   3.5.1 Option details
    -   3.6 Frontends
        -   3.6.1 Web UIs
        -   3.6.2 Other UIs
-   4 Tips and tricks
    -   4.1 Download the packages without installing them
    -   4.2 pacman XferCommand
    -   4.3 Custom minimal build
        -   4.3.1 Minimal PKGBUILD example
    -   4.4 aria2 sometimes stops downloading without exiting
-   5 See also

Installation
------------

Install aria2 from official repositories.

You may also want to install aria2-systemd to use aria2 as daemon.

Execution
---------

The executable name for the aria2 package is aria2c. This legacy naming
convention has been retained for backwards compatibility.

Configuration
-------------

> aria2.conf

aria2 looks to ~/.aria2/aria2.conf for a set of global configuration
options by default. This behavior can be modified with the --conf-path
switch:

-   Download aria2.example.rar using the options specified in the
    configuration file /file/aria2.rapidshare

    $ aria2c --conf-path=/file/aria2.rapidshare http://rapidshare.com/files/12345678/aria2.example.rar

If ~/.aria2/aria2.conf exists and the options specified in
/file/aria2.rapidshare are desired, the --no-conf switch must be
appended to the command:

-   Do not use the default configuration file and download
    aria2.example.rar using the options specified in the configuration
    file /file/aria2.rapidshare

    $ aria2c --no-conf --conf-path=/file/aria2.rapidshare http://rapidshare.com/files/12345678/aria2.example.rar

If ~/.aria2/aria2.conf does not yet exist and you wish to simplify the
management of configuration options:

    $ touch ~/.aria2/aria2.conf

> Example .bash_alias

    alias down='aria2c --conf-path=${HOME}/.aria2/aria2.conf'
    alias rapid='aria2c --conf-path=/file/aria2.rapidshare'

> Example aria2.conf

    continue
    dir=${HOME}/Desktop
    file-allocation=none
    input-file=${HOME}/.aria2/input.conf
    log-level=warn
    max-connection-per-server=4
    min-split-size=5M
    on-download-complete=exit

This is essentially the same as if running the following:

    $ aria2c dir=${HOME}/Desktop file-allocation=none input-file=${HOME}/.aria2/input.conf on-download-complete=exit log-level=warn FILE

Note:The example aria2.conf above may incorrectly use the
HOME variable. Some users have reported the curly brace syntax to explicitly create a separate {HOME}
subdirectory in the aria2 working directory. Such a directory may be
difficult to traverse as bash will consider it to be the $HOME
environment variable. For now, it is recommended to use absolute path
names in aria2.conf.

Option details

 continue 
    Continue downloading a partially downloaded file if a corresponding
    control file exists.
 dir=${HOME}/Desktop 
    Store the downloaded file(s) in ~/Desktop.
 file-allocation=none 
    Do not pre-allocate disk space before downloading begins. (Default:
    prealloc) 1
 input-file=${HOME}/.aria2/input.conf 
    Download a list of line, or TAB separated URIs found in
    ~/.aria2/input.conf
 log-level=warn 
    Set log level to output warnings and errors only. (Default: debug)
 max-connection-per-server=4 
    Set a maximum of four (4) connections to each server per file.
    (Default: 1)
 min-split-size=5M 
    Only split the file if the size is larger than 2*5MB = 10MB.
    (Default: 20M)
 on-download-complete=exit 
    Run the exit command and exit the shell once the download session is
    complete.

Example input file #1

-   Download aria2-1.10.0.tar.bz2 from two separate sources to ~/Desktop
    before merging as aria2-1.10.0.tar.bz2

    http://aria2.net/files/stable/aria2-1.10.0/aria2-1.10.0.tar.bz2    http://sourceforge.net/projects/aria2/files/stable/aria2-1.10.0/aria2-1.10.0.tar.bz2

Example input file #2

-   Download aria2-1.9.5.tar.bz2 and save to /file/old as
    aria2.old.tar.bz2  &
-   Download aria2-1.10.0.tar.bz2 and save to ~/Desktop as
    aria2.new.tar.bz2

    http://aria2.net/files/stable/aria2-1.9.5/aria2-1.9.5.tar.bz2
      dir=/file/old
      out=aria2.old.tar.bz2
    http://aria2.net/files/stable/aria2-1.10.0/aria2-1.10.0.tar.bz2
      out=aria2.new.tar.bz2

Additional notes

 1 --file-allocation=falloc 
    Recommended for newer file systems such as ext4 (with extents
    support), btrfs or xfs as it allocates large files (GB) almost
    instantly. Do not use falloc with legacy file systems such as ext3
    as prealloc consumes approximately the same amount of time as
    standard allocation would while locking the aria2 process from
    proceeding to download.

Tip:See aria2c -help#all and the aria2 man page for a complete list of
configuration options.

> Example aria2.rapidshare

    http-user=USER_NAME
    http-passwd=PASSWORD
    allow-overwrite=true
    dir=/file/Downloads
    file-allocation=falloc
    enable-http-pipelining=true
    input-file=/file/input.rapidshare
    log-level=error
    max-connection-per-server=2
    summary-interval=120

Option details

 http-user=USER_NAME 
    Set HTTP username as USER_NAME for password-protected logins. This
    affects all URIs.
 http-passwd=PASSWORD 
    Set HTTP password as PASSWORD for password-protected logins. This
    affects all URIs.
 allow-overwrite=true 
    Restart download if a corresponding control file does not exist.
    (Default: false)
 dir=/file/Downloads 
    Store the downloaded file(s) in /file/Downloads.
 file-allocation=falloc 
    Call posix_fallocate() to allocate disk space before downloading
    begins. (Default: prealloc)
 enable-http-pipelining=true 
    Enable HTTP/1.1 pipelining to overcome network latency and to reduce
    network load. (Default: false)
 input-file=/file/input.rapidshare 
    Download a list of single line of TAB separated URIs found in
    /file/input.rapidshare
 log-level=error 
    Set log level to output errors only. (Default: debug)
 max-connection-per-server=2 
    Set a maximum of two (2) connections to each server per file.
    (Default: 1)
 summary-interval=120 
    Output download progress summary every 120 seconds. (Default: 60) 3

Additional notes

-   Because aria2.rapidshare the contains a username and password, it is
    advisable to set permissions on the file to 600, or similar.

    $ cd /file
    $ chmod 600 /file/aria2.rapidshare
    $ ls -l
    total 128M
    -rw------- 1 arch users  167 Aug 20 00:00 aria2.rapidshare

 3 summary-interval=0 
    Supresses download progress summary output and may improve overall
    performance. Logs will continue to be output according to the value
    specified in the log-level option.

Tip:The example configuration file can also be applied to Hotfile,
DepositFiles, et.al.

Note:Command-line options always take precedence over options listed in
a configuration file.

> Example aria2.bittorrent

    bt-seed-unverified
    max-overall-upload-limit=1M
    max-upload-limit=128K
    seed-ratio=5.0
    seed-time=240

Option details

 bt-seed-unverified=false 
    Do not check the hash of the file(s) before seeding. (Default: true)
 max-overall-upload-limit=1M 
    Set maximum overall upload speed to 1MB/sec. (Default: 0)
 max-upload-limit=128K 
    Set maximum upload speed per torrent to 128K/sec. (Default: 0)
 seed-ratio=5.0 
    Seed completed torrents until share ratio reaches 5.0. (Default:
    1.0)
 seed-time=240 
    Seed completed torrents for 240 minutes.

Note:If both seed-ratio and seed-time are specified, seeding ends when
at least one of the conditions is satisfied.

> Frontends

Note:Settings implemented in frontends don't affect aria2's own
configuration, and it is uncertain whether the different UIs reuse aria2
configuration if a custom one has been made. Users should ensure their
desired parameters are effectively implemented within selected tools and
that they are stored persistently (uGet for example has its own aria2's
command line which sticks across reboots).

Web UIs

Note:These frontends need aria2c to be started with --enable-rpc in
order to work.

-   YaaW — Yet Another Aria2 Web Frontend in pure HTML/CSS/Javascirpt.

https://github.com/binux/yaaw || yaaw-git

-   Webui — Html frontend for aria2.

https://github.com/ziahamza/webui-aria2 ||

Other UIs

Note:These frontends don't need aria2c to be started with --enable-rpc
to function.

-   aria2fe — A GUI for the CLI-based aria2 download utility.

http://sourceforge.net/projects/aria2fe/ || aria2fe

-   Diana — Command line tool for aria2

https://github.com/baskerville/diana || diana-git

-   downloadm — A download accelerator/manager which uses aria2c as a
    backend.

http://sourceforge.net/projects/downloadm/ || downloadm

-   eatmonkey — Download manager for Xfce that works with aria2.

http://goodies.xfce.org/projects/applications/eatmonkey || eatmonkey

-   karia2 — QT4 interface for aria2 download mananger.

http://sourceforge.net/projects/karia2/ || karia2-svn

-   uGet — Feature-rich GTK+/CLI download manager which can use aria2 as
    a back-end by enabling a built-in plugin.

http://ugetdm.com || uget

-   yaner — GTK+ interface for aria2 download mananger.

http://iven.github.com/Yaner || yaner-git

It is convenient to append a monitor function based on diana in your
shell configuration file:

    da(){
    watch -ctn 1 "(echo -e '\033[32mGID\t\t Name\t\t\t\t\t\t\t%\tDown\tSize\tSpeed\tUp\tS/L\tTime\033[36m'; \
    diana list| cut -c -112; echo -e '\033[37m'; diana stats)"
    }

Tips and tricks
---------------

> Download the packages without installing them

Just use the command below:

     # pacman -Sp packages | aria2c -i -

pacman -Sp lists the urls of the packages on stdout, instead of
downloading them, then | pipes it to the next command. Finally, The -i
in aria2c -i - switch to aria2c means that the urls for files to be
downloaded should be read from the file specified, but if - is passed,
then read the urls from stdin.

> pacman XferCommand

aria2 can be used as the default download manager for the pacman package
manager. See the ArchWiki article Improve pacman performance for
additional details.

> Custom minimal build

Gains in application response can be gleaned by removing unused features
and protocols. Further gains can be accomplished by removing support for
external libraries with a custom build. The following example creates an
aria2c executable with HTTP/HTTPS, FTP download and asynchronous DNS
support only. See the Arch Build System page for further details.

Minimal PKGBUILD example

    pkgname=aria2
    pkgver=1.10.0
    pkgrel=100
    pkgdesc="Download utility that supports HTTP(S) and FTP"
    arch=('i686' 'x86_64')
    url="http://aria2.sourceforge.net/"
    license=('GPL')
    depends=('c-ares' 'gnutls' 'zlib' 'ca-certificates')
    source=(http://downloads.sourceforge.net/aria2/aria2-${pkgver}.tar.bz2)
    md5sums=('1386df9b2003f42695062a0e1232e488')

    build() {
      cd ${srcdir}/${pkgname}-${pkgver}

     ./configure --disable-bittorrent --disable-metalink \
     --disable-dependency-tracking --disable-xmltest --disable-nls \
     --without-sqlite3 --without-libxml2 --without-libexpat \
     --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt --prefix=/usr

     make
    }

    package() {
    	cd ${srcdir}/${pkgname}-${pkgver}
    	make DESTDIR=${pkgdir} install
    }

> aria2 sometimes stops downloading without exiting

You can use this little script to restart the download every 30 minutes:

    #!/bin/bash

    if [ ! -x /usr/bin/aria2c ]; then
            echo "aria2c is not installed"
            exit 1
    fi

    if [ ! -d ~/.torrentdl ]; then
            mkdir ~/.torrentdl
    fi

    while :; do
            for i in $@; do
                    MAGNET=false
    	        if [[ "$i" = magnet* ]]; then
    	                MAGNET=true
    	        elif [ ! -f "$i" ]; then
    	                echo "The file ('$i') is not given or does not exist"
    	                exit 1
    	        fi
    	        if ! aria2c --hash-check-only=true "$i" &> /dev/null; then
    	                aria2c "$i"
    	                sleep 30m && kill -9 $(pidof aria2c)
    	        else
    	                echo "Torrent is downloaded!"
    	        fi
            done
    done

See also
--------

-   aria2 wiki - Official site
-   aria2 usage examples - Official site
-   aria2c downloader through VPN tunnel - Unofficial site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aria2&oldid=302624"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
