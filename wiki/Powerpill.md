Powerpill
=========

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Using Reflector                                                    |
| -   5 Using Rsync                                                        |
| -   6 Basic Usage                                                        |
|     -   6.1 System Updating                                              |
|     -   6.2 Installation of packages                                     |
|                                                                          |
| -   7 External resources                                                 |
+--------------------------------------------------------------------------+

Introduction
------------

Powerpill is a Pacman wrapper that uses parallel and segmented
downloading to try to speed up downloads for Pacman. Internally it uses
Aria2 and Reflector to achieve this. Powerpill can also use Rsync for
official mirrors that support it. This can be efficient for users who
already use full bandwidth when downloading from a single mirror.
Pacserve is also supported via the configuration file and will be used
before downloading from external mirrors. Example: One wants to update
and issues a pacman -Syu which returns a list of 20 packages that are
available for update totally 200 megs. If the user downloads them via
pacman, they will come down one-at-a-time. If the user downloads them
via powerpill, they will come down simultaneously in many cases several
times faster (depending on one's connection speed, the availability of
packages on servers, and speed from server/load, etc.)

A test of pacman vs. powerpill on one system revealed a 4x speed up in
the above scenario where the pacman downloads averages 300 kB/sec and
the powerpill downloads averaged 1.2 MB/sec.

Installation
------------

You can get it from AUR powerpill or directly from Xyne's repos.

Configuration
-------------

Powerpill has a single configure file /etc/powerpill/powerpill.json you
can edit to your liking. Refer to the powerpill.json man page for
details.

Using Reflector
---------------

By default, Powerpill is configured to use Reflector to retrieve the
current list of mirrors from the Arch Linux server's web API and use
them for parallel downloads. This is to make sure that there are enough
servers in the list for significant speed improvements.

  

Using Rsync
-----------

Rsync support is available for some mirrors. When enabled, database
synchronizations (pacman -Sy) and other operations may be much faster
because a single connection is used. The rsync protocol itself also
speeds up update checks and sometimes file transfers.

To find a suitable mirror with rsync support, use reflector:

     reflector -p rsync

Select the mirror nearest you (you may wish to use reflector's "-c"
option to limit results to your country) and then update
powerpill.json's rsync server field. After that, all official database
and packages will be downloaded form the rsync server whenever possible.

Basic Usage
-----------

For most operations, powerpill works just like pacman since it is a
wrapper script for pacman.

> System Updating

To update your system (sync and update installed packages) using
powerpill, simply pass the -Syu options to it as you would with pacman:

    # powerpill -Syu

> Installation of packages

To install a package and its deps, simply use powerpill with the -S
option as you would with pacman:

    # powerpill -S package

You may also install multiple packages with it the same way you would
with pacman:

    # powerpill -S package1 package2 package3

External resources
------------------

-   Powerpill - the official project page
-   powerpill reborn - powerpill is back :)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Powerpill&oldid=239937"

Category:

-   Package management
