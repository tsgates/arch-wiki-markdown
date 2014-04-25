Modprobed-db
============

Summary help replacing me

Describes the installation and usage of modprobe db.

> Related

Kernels

Linux-ck

modprobed-db keeps a running list of ALL modules ever probed on a system
and allow for easy recall. This is very useful for users wishing to
build a minimal kernel via a make localmodconfig which simply takes
every module currently probed and switches everything BUT them off in
the .config for a kernel resulting in smaller kernel packages and
reduced compilation times.

Contents
--------

-   1 Installation and Setup
-   2 Usage
    -   2.1 Data Collection
    -   2.2 Data Recall
        -   2.2.1 Using the Official Arch kernel PKGBUILD
        -   2.2.2 Using Some Kernels in the AUR
-   3 Recommendations
-   4 Suggested Modules
-   5 Benefits of modprobed-db with make localmodconfig in custom
    kernels

Installation and Setup
----------------------

1.  Download, build, and install modprobed-db.
2.  Run /usr/bin/modprobed-db which will create
    $XDG_CONFIG_HOME/modprobed-db.conf if one does not already exist.
    Optionally add some modules to ignore to the IGNORE array. Some
    common ones are included by default.

Usage
-----

> Data Collection

The most convenient method to use modprobed-db is to simply add a
crontab entry invoking /usr/bin/modprobed-db store at some regular
interval.

Example running the script once every 20 minutes:

    $ crontab -e
    */20 * * * *   /usr/bin/modprobed-db store &> /dev/null

Another way is to use systemd's built-in timer functionality. Refer to
systemd/cron functionality#Custom/Example service files to do the same.

> Data Recall

As mentioned earlier, this script is meant to be used in concert with
the make localmodconfig step of compiling a kernel. After the database
has been adequately populated, simply invoke
/usr/bin/modprobed-db recall prior to compiling a kernel to load all
modules followed by the make localmodconfig to do the magic.

Note:Since /usr/bin/modprobe requires root privileges,
/usr/bin/modprobed-db needs to be called as root or via sudo when users
wish to recall the database.

Using the Official Arch kernel PKGBUILD

The official Arch kernel's PKGBUILD does not have native support for
this, but it is easily modified as follows:

     ...
      # get kernel version
      make prepare

      /usr/bin/modprobed-db recall         <---- insert this line
      make localmodconfig              <---- insert this line

      # load configuration
      # Configure the kernel. Replace the line below with one of your choice.
      #make menuconfig # CLI menu for configuration
      #make nconfig # new CLI menu for configuration
      #make xconfig # X-based configuration
      #make oldconfig # using old config from previous kernel version
      # ... or manually edit .config
     ...

Using Some Kernels in the AUR

Several kernel packages in the AUR have native support for modprobed-db
in their PKGBUILD files. For example:

-   kernel-netbook
-   linux-bfs
-   linux-bridge-pl
-   linux-ck-pax
-   linux-ck
-   linux-ck-systemtap
-   linux-ideapad
-   linux-lqx
-   linux-pf
-   linux-pksm
-   linux-rifs
-   linux-routes
-   linux-uksm-ck
-   linux-uksm

Find which other packages use it:

    cd /scratch
    git clone --depth 1 http://pkgbuild.com/git/aur-mirror.git
    find /scratch/aur-mirror -iname "PKGBUILD" -print0 | xargs -0 grep "modprobed-db recall" | sort

Note:The server pkgbuild.com is rather slow and the git clone can take a
while.

Alternatively, download the .tar.xz snapshot (around 90 MB) by following
this link and then clicking on the latest commit message.

Recommendations
---------------

It is recommended that users install the package and then "use" the
system for a good amount of time to allow the database to grow based on
usage and capture everything the system needs before building a kernel
with a make localmodconfig. Some suggested actions to allow appropriate
modules to load and get cataloged:

-   Insert every kind of removable media (USB, DVD, CD, etc.)
-   Use every device on the machine (wifi, network, USB stuff like
    cameras, ipods, etc.)
-   Mount every kind of filesystem one might typically use including
    ext2/3/4, fat, vfat, CIFS shares, NFS shares, etc.
-   Use as many applications (that one would normally use) as possible
    in order to capture modules on which they depend. For example, IP
    blocking/filtering software like pgl-cli.
-   Users who plan to mount iso image file should do so (this will make
    sure to capture the loop and isofs modules).
-   Users requiring encryption software such as truecrypt should make
    sure to load it, and mount some encrypted containers to ensure that
    the needed crypto modules are in the db.

Suggested Modules
-----------------

-   cifs
-   ext2
-   ext3
-   ext4
-   fat
-   isofs
-   loop
-   vfat

Benefits of modprobed-db with make localmodconfig in custom kernels
-------------------------------------------------------------------

1.  Reduced kernel footprint on FS
2.  Reduced compilation time

Comparisons using version 3.8.8-1 of the Arch kernel (from ABS):

Note: The /var/log/modprobed.db on the test machine contains 209 lines;
YMMV based on specific usage and needs.

  --------------------------- -------------- --------------------- -------------- ---------------------- ------------------
  Machine CPU                 # of threads   make localmodconfig   # of Modules   Modules' Size on HDD   Compilation Time
  Intel i7-3770K @ 4.50 GHz   8              No                    3,025          129 MB                 7 min 37 sec
  Intel i7-3770K @ 4.50 GHz   8              Yes                   230            18 MB                  1 min 13 sec
  Intel Q9550 @ 3.40 GHz      4              No                    3,025          129 MB                 14 min 21 sec
  Intel Q9550 @ 3.40 GHz      4              Yes                   230            18 MB                  2 min 20 sec
  Intel E5200 @ 3.33 GHz      2              No                    3,025          129 MB                 34 min 35 sec
  Intel E5200 @ 3.33 GHz      2              Yes                   230            18 MB                  5 min 46 sec
  --------------------------- -------------- --------------------- -------------- ---------------------- ------------------

-   13x less modules built
-   7x less space
-   6x less compilation time

Number of modules found by:

    find /scratch/linux-3.8 -name '*.ko' | wc -l

Size on HDD found by:

    find /scratch/linux-3.8 -name '*.ko' -print0 | xargs -0 du -ch

Compilation time found by entering a preconfigured linux-3.8.8 (using
stock Arch config):

    $ time make -jx modules

Note:The Arch standard is to gzip each module; the numbers shown in the
table above are not gzip'ed but the savings ratio will be unaffected by
this.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Modprobed-db&oldid=284075"

Category:

-   Kernel

-   This page was last modified on 22 November 2013, at 13:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
