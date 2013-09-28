/dev/shm
========

Settings
--------

Alter /etc/fstab's entry for /dev/shm and apply settings with mount -a,
or reboot:

    none   /dev/shm        tmpfs   defaults,size=768M,noexec,nodev,nosuid        0       0

size
    Accepts 'k', 'm' or 'g' and their capitalized versions as units. The
    size parameter also accepts a suffix % to limit this tmpfs instance
    to that percentage of your physical RAM. The default is 50%.
noexec,nodev,nosuid
    Universal options for most file-systems affecting permissions. See:
    man mount

See also
--------

-   See Wikipedia:Shared memory for background.

Retrieved from
"https://wiki.archlinux.org/index.php?title=/dev/shm&oldid=225453"

Categories:

-   Kernel
-   File systems
