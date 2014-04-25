LinHES
======

LinHES (Linux Home Entertainment System) is a distribution heavily based
on Arch, centered around MythTV designed for Home Theater PCs (HTPCs)
use. The expressed goal of LinHES is to provide a HES-appliance feel to
your HTPC. Most if not all of the system configuration and operation can
be accomplished via your remote control. Users can go from a blank
system to a fully functional MythTV system in 15-20 minutes. LinHES
makes use of mythvantage for easy configuration and modification. There
is a service menu accessible right from the mythtv GUI where users can
configure most of the machine right from their couch via their remote
control.

-   Current stable release: R7.4 (9-Aug-2012)
-   Creator/lead developer: Cecil Watson
-   Package Maintainers/developers: Greg Frost, James Meyer, Nathan
    Harris

Contents
--------

-   1 Key Features
-   2 Divergence from the Arch Way
-   3 Brief History
    -   3.1 Version History of KM/LinHES
    -   3.2 R5.5/R6.x Differences Table and Equivalent Commands
-   4 Required Hardware
-   5 R6 Installation Walk-through (Brief)
-   6 External Links
    -   6.1 Distro General
    -   6.2 ISO Downloads
    -   6.3 Miscellaneous

Key Features
------------

-   Installation and setup are relatively trivial.
-   Major features aside from MythTV are preconfigured (SAMBA, sshd,
    x11vnc, webmin, lighttpd, lirc, etc.)
-   Comprehensive "Auto Upgrade" (along with backup scripts) makes
    upgrading a snap.
-   Live Frontend allows users to run a front-end on any machine live
    from the CD.
-   User support forums
-   Partial automation of Australian EPG setup
-   Native VDPAU support for both MythTV and MPlayer
-   Native support for many popular SDTV/HDTV capture hardware
-   Native XBMC support
-   Native support for a large number of remote controls
-   Hulu desktop option
-   Packages for Mythtv-0.22

Divergence from the Arch Way
----------------------------

LinHES is meant to be an appliance and is targeted at Linux neophytes.
As such, it is noteworthy to mention that although LinHES is based on
Arch, LinHES doesn't conform to the Arch Way. For example:

-   LinHES implements pacman's abilities more broadly philosophically.

Pacman under LinHES can and does modify package config files/other files
for the user without the user's need to do so manually as is the Arch
Way. Additionally, some LinHES packages will modify files owned by other
LinHES packages. Both of these examples represent a divergence from the
Arch Way that might not sit well with some experienced Arch users. On
its own, neither example represents a "bad" thing, but they should be
documented for the afore mentioned niche community.

Brief History
-------------

The predecessor to LinHES is Knoppmyth (KM). As its name implies, the
initial releases of Knoppmyth were based on Knoppix, but the latest
incarnations are not, although the brand-name "KnoppMyth" has been
retained. From the knoppmyth wiki:

"Knoppix itself is an adaptation of the Debian Linux distribution,
Knoppmyth therefore is another project that has spiralled off into its
own domain. These days it would be more correct to call KnoppMyth a
specialized and heavily customized Debian derivative, as there is very
little Knoppix left."

The first release of KM was on 09-Aug-2003 (R1) and was based on MythTV
0.10. The latest stable incarnation of KM is R5.5 which was released on
06-Jul-2008 and is based on MythTV 0.21.2. The first release of LinHES
(R6) went gold (stable) on the 26-Sept-2009, version R6.01.00 being
officially released.

Both LinHES and KM can be installed and function on almost any "modern"
computer. There are a set of components that constitute the so-called,
"Knoppmyth Reference Platform" which is nothing more than a set of
hardware that is known and certified to work out-of-the-box with KM. The
hardware specifications are completely open.

Development on KM has halted and all efforts are focusing on LinHES.
That said, KM R5.5 is still a very robust Mythtv-Distro.

> Version History of KM/LinHES

Since the first release in 2003, there have been about a dozen major and
minor versions of KM.

-   06-06-10 R6.03.00 is released (major diff is mythtv 0.23)

-   03-02-10 R6.02.00 (major diff is mythtv 0.22)

To upgrade an existing R6.01.00 box, see [this thread].

-   09-26-09 R6 goes gold, version R6.01.00 officially released

-   08-14-09 Pre-Release R6.00.09 of LinHES

-   7-6-08 Release 5.5 "Bone Marrow"

Uses a snapshot of Debian Unstable and the 2.6.23-chw-4 kernel

-   5-11-07 Release 5 Final 1 "Farewell days of my youth"

-   11-3-03 Release 4 "CoCo2"

Upgraded to MythTV 0.12

-   9-01-2003 Release 3 "Each of these my three babies"

The CD can now be use as a front-end

-   08-25-2003 Release 2 "Chicago, Chicago"

Updated to MythTV 0.11

-   08-08-2003 Release 1 "You better Belize it!"

Based on Knoppix 07-26-2003 and MythTV 0.10

> R5.5/R6.x Differences Table and Equivalent Commands

This section intends to capture the differences between R5.x and R6.x as
well as capture some equivalent shell commands for the user familiar
with the R5 series.

Startup Scripts It is noteworthy to mention that /etc/rc.local does NOT
get called at boot as it does under Arch. Instead, LinHES uses
/etc/runit/1.local for startup scripts.

  
 Core Components

  --------------------- ------------ ------------
  Component             R5 Uses...   R6 Uses...
  "The Brand"           Knoppmyth    LinHES
  Parent Linux Distro   Debian       Arch Linux
  Webserver             Apache2      Lighttpd
  --------------------- ------------ ------------

Miscellaneus Components/Shell Examples

  ------------------- ----------------------- ----------------------------------------------------------- ------------------------------------ -------------------------------------
  Component           R5 Uses...              R6 Uses...                                                  R5 Example                           R6 Example
  Adding a Daemon     update-rc.d             add_service.sh                                              # update-rc.d daemonname defaults    $ sudo add_service.sh daemonname
  Removing a Daemon   update-rc.d             remove_service.sh                                           # update-rc.d -f daemonname remove   $ sudo remove_service.sh daemonname
  Init System         sysv init               runit                                                       # /etc/init.d/webmin start           $ sudo sv start webmin
  Diskless Frontend   NFS root, shared /usr   pacman -S diskless-legacy ; config_diskless_frontend.bash   knoppmyth_diskless_frontend.bash     
  ------------------- ----------------------- ----------------------------------------------------------- ------------------------------------ -------------------------------------

Package Management/Shell Examples

  -------------------------------- ------------------------- ---------------------------- ------------------------------- -------------------------------
  Package Task                     R5 Uses...                R6 Uses...                   R5 Example                      R6 Example
  Update package list              dpkg and apt-get          pacman                       # apt-get update                $ sudo pacman -Sy
  Install a Package                dpkg and apt-get          pacman                       # apt-get install packagename   $ sudo pacman -S packagename
  Remove a Package                 dpkg and apt-get          pacman                       # apt-get remove packagename    $ sudo pacman -Rs packagename
  Location of repos                /etc/apt/sources.list     /etc/pacman.conf                                             
  Location of Package Cache        /var/cache/apt/archives   /data/var/cache/pacman/pkg                                   
  Upgrade All Installed Packages   dpkg and apt-get          pacman                       # apt-get dist-upgrade          $ sudo pacman -Syu
  Install from local pacakge       dpkg                      pacman                       # dpkg -i <file>                $ sudo pacman -U <file>
  -------------------------------- ------------------------- ---------------------------- ------------------------------- -------------------------------

Configuration Settings

  --------------------------------- -------------- ------------ ------------ --------------------------------------------
  Component or configuration file   R5 Uses...     R6 Uses...   R5 example   R6 Example
  /etc/fstab                        device names   UUID         /dev/sda1    UUID=a6b1c6b8-eebf-4e28-8020-!309cf441bfcc
  --------------------------------- -------------- ------------ ------------ --------------------------------------------

Required Hardware
-----------------

A LinHES system can use most modern and "semi-modern" hardware. Some
users report a fully functional system driven by an antiquated AMD
Athlon (800 MHz)/nforce2 CPU/MB. For HD-playback one will need a more
powerful CPU or a GPU capable of VDPAU such as an NVIDIA 8400GS, 9500GT,
or GF 210. For a complete table of NVIDIA cards and their VDPAU support,
see this table. Intel Atom-based PCs are also popular among LinHES users
for their low heat output and ultra low power consumption. Again, this
low-power CPU needs to be paired with a VDPAU compatible GPU or else
view HD content will not be possible. Most Atom MB/CPU combos are paired
with one, for example, see offerings by Intel and Zotac.

LinHES can also run in a virtual machine (verified to work in Virtual
Box v3.0.10) if would-be users would prefer to test drive it in a
sandbox.

R6 Installation Walk-through (Brief)
------------------------------------

Boot the LinHES CD or USB media.

-   Screen 1: Select the "Install or Upgrade" option. If upgrading, you
    will go directly to screen 10 and everything will be processed
    automatically based on your backups.

Warning: If upgrading from an R5.x box, make sure that you run the
mythbackup script before you attempt an install of R6.

-   Screen 2: Select a target file-system

-   Screen 3: Select the type of install (Full/auto or Upgrade). Also
    assign partition sizes for the OS, swap, and data partitions. The
    defaults should be fine. Users can also select which file-system
    format is used. Currently the default is for ext3, but other options
    such as ext4/RFS/XFS/JFS are also available.

-   Screen 4: Assign a host-name

Note: Make sure you are satisfied with the host-name you select since
you cannot easily change it after the installation due to a number of
other configuration files/mysql tables that will depend on it.

-   Screen 5: Setup the network options. Users may select from wired or
    wireless configurations with all the standard options such as
    dynamic IP/static IP, devices, mtu size, etc.

Note: For more of MTU sizes a.k.a jumbo frames, see the Jumbo Frames
article.

-   Screen 6: Setup host options. Choices here include system
    configuration (standalone/frontend/master backend/slave backend).
    Initial resolution (i.e. SDTV or HDTV) and remote configure are also
    on this screen. The setup GUI contains many options for remote
    controls that are preconfigured for you. Users also set the option
    to use or not use mythwelcome on this screen.

Note: Make sure you understand the architecture of mythtv networks. A
selection of standalone should only be made if this is and will be the
only mythtv box on your network. For more on this, see [insertlink this]
page on the official mythtv wiki.

-   Screen 7: Setup timezone/zipcode

-   Screen 8: Setup NFS options if media is stored on a remote NFS
    share. Also configure automatic updates

-   Screen 9: Setup user accounts and passwords

Warning: Make sure to create a non-mythtv account, assign a root
password and assign a mythtv password on this screen before you
continue. Under R6.02.00 and higher, the screen is lacking, passwords
and user creation shall be managed later through CLI.

-   Screen 10: Sanity check/"Are you sure you wish to continue?" screen.

This concludes the installation. The scripts will take over and in about
5 min you will reboot into your LinHES installation.

External Links
--------------

> Distro General

-   Homepage: http://www.linhes.org/
-   Wiki: http://www.linhes.org/
-   Forums: http://forum.linhes.org/
-   Bug Tracker: http://www.linhes.org/projects/linhes/issues
-   LinHES PKGBUILD Repository:
    http://www.linhes.org/projects/linhes/repository
    http://cgit.linhes.org/

> ISO Downloads

-   Direct: http://www.linhes.org/downloads/Current/
-   Torrent:
    http://linuxtracker.org/index.php?page=torrent-details&id=69c6f0bf37677f85d550a550f4fd324e2699e467

> Miscellaneous

-   Interview with Cecil Watson - Hour-long interview with Cecil Watson
    (04-Apr-2010) by Patrick Davila and Daniel Frey (MythTV Cast).
-   Interview with Cecil Watson - Another hour-long interview with Cecil
    Watson (18-Oct-2009) by Kevin Kittredge (A Geek and his Wife). This
    interview was recorded after R6 went stable.
-   Interview with Cecil Watson - Hour and a half-long interview with
    Cecil Watson (11-Feb-2009) by Dann Washko, Lincoln Fessende, Allan
    Metzler, Patrick Davila (The Linux Link Tech Show).
-   Interview with Cecil Watson - Written interview with Cecil Watson
    (20-Jan-2009) by Gareth J. Greenaway (SCALE). The interview was done
    in preparation for SCALE 2009; this is where Cecil disclosed the
    name change in R6.
-   Interview with Cecil Watson - Hour-long interview with Cecil Watson
    (07-Oct-2007), by Kevin Kittredge (A Geek and his Wife). Here you
    can hear about R6 while still in alpha/beta stages.
-   Interview with Cecil Watson - Half an hour-long interview with Cecil
    Watson (19-Jul-2006), starting at 28', by Dann Washko, Lincoln
    Fessende, Allan Metzler, Patrick Davila (The Linux Link Tech Show).
-   Interview with Cecil Watson - Quarter-long interview with Cecil
    Watson (30-Oct-2005), starting at 23', by Leo Laporte (The Tech Guy
    Labs). At the time, a re-mastered Knoppmix distribution was seen as
    a breakthrough innovation in the HTPC field.
-   KnoppMyth R5.5 Demo Install Video - Showcases the ease of
    installation of R5.5; note that the R6 installation process is very
    different from the R5.5 installation process!
-   KnoppMyth Changelog - Changelog for Knoppmyth.
-   tjc's KnoppMyth R5.5 Hints and Tips - Recommended read if you plan
    to install R5.5; note that this post hasn't been updated for the R6
    series!

Retrieved from
"https://wiki.archlinux.org/index.php?title=LinHES&oldid=304898"

Category:

-   Audio/Video

-   This page was last modified on 16 March 2014, at 09:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
