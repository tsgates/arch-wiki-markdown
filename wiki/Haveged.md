Haveged
=======

The haveged project is an attempt to provide an easy-to-use,
unpredictable random number generator based upon an adaptation of the
HAVEGE algorithm. Haveged was created to remedy low-entropy conditions
in the Linux random device that can occur under some workloads,
especially on headless servers.[1]

List available entropy
----------------------

If you're not sure, whether you need haveged, run:

    # cat /proc/sys/kernel/random/entropy_avail

This command shows you how much entropy your server has collected. If it
is rather low (<1000), you should probably install haveged. Otherwise
cryptographic applications will block until there is enough entropy
available, which eg. could result in slow wlan speed, if your server is
a Software access point.

You should use this command again to verify how much haveged boosted
your entropy pool after the installation.

Installation
------------

Install the haveged package from the official repositories.

Service
-------

The package provides haveged.service, see systemd for details.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Haveged&oldid=303737"

Category:

-   Security

-   This page was last modified on 9 March 2014, at 09:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
