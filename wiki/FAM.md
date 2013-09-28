FAM
===

The File Alteration Monitor (FAM) daemon is used by desktop environments
such as GNOME and Xfce to monitor and report changes to the filesystem.
FAM is also used by the Samba server daemon. Note that KDE no longer
uses FAM, they have moved to the kernel-based inotify which requires no
special configuration.

Warning:FAM is obsolete; use Gamin instead, if possible. Gamin is a
re-implementation of the FAM specification. It is newer and more
actively maintained, and also simpler to configure.

Installation
------------

FAM has been removed from the official repository as it is considered
deprecated. You can install FAM from Arch User Repository (AUR).

Configuration
-------------

A fam.service unit is provided, see systemd for details.

See also
--------

See the Wikipedia article on this subject for more information: File
alteration monitor

-   FAM, Gamin, inotify

Retrieved from
"https://wiki.archlinux.org/index.php?title=FAM&oldid=240577"

Category:

-   File systems
