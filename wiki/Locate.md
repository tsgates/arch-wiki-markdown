locate
======

locate is a common Unix tool for quickly finding files by name. It
offers speed improvements over the find tool by searching a
pre-constructed database file, rather than the filesystem directly. The
downside of this approach is that changes made since the construction of
the database file cannot be detected by locate. This problem is
minimised by regular, typically scheduled use of the updatedb command,
which (as the name suggests) updates the database.

Installation
------------

Although in other distros locate and updatedb are in the findutils
package, they are no longer present in Arch's package. To use it,
install the mlocate package. mlocate is a newer implementation of the
tool, but is used in exactly the same way.

Before locate can be used, the database will need to be created. To do
this, simply run updatedb as root.

> Keeping the database up-to-date

When mlocate is installed, a script is automatically placed in
/etc/cron.daily (so that cron runs it daily) that will update the
database. You can also manually run updatedb at any time.

To save time, the updatedb can be (and by default is) configured to
ignore certain filesystems and paths by editing /etc/updatedb.conf.
man updatedb.conf will tell you about the semantics of this file. It is
worth noting that among the paths ignored in the default configuration
(i.e. those in the "PRUNEPATHS" string) are /media and /mnt, so locate
may not discover files on external devices.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Locate&oldid=251761"

Categories:

-   Command shells
-   File systems

-   This page was last modified on 24 March 2013, at 06:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
