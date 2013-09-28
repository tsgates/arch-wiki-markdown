9vx
===

9vx is an implementation of the simple x86 virtual machine vx32
specifically designed for running real Plan9 on other host systems.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 A short tutorial                                                   |
| -   3 Problems                                                           |
|     -   3.1 Installing Plan9 on a disk image                             |
|     -   3.2 Putting the Plan9 root file system in an insecure directory  |
|                                                                          |
| -   4 Alternatives                                                       |
+--------------------------------------------------------------------------+

Installation
------------

A minimal recent build of 9vx can be found in the AUR.

A short tutorial
----------------

After installing 9vx:

-   Extract a Plan9 root file system (ISOs from official plan9, 9atom or
    9front all should work) into your directory of choice
    "/path/to/plan9" (9vx defaults to the directory /usr/local/plan9vx)
-   make sure that /opt/vx32/bin is in your PATH
-   invoke "9vx -r /path/to/plan9 -u glenda" to start as user Glenda, a
    local system administrator user account which can be used for
    installing programs and changing system settings. If you run the
    official Plan9 root file system, you will here also get a small
    tutorial about how to use rio and acme.
-   invoke "9vx -r /path/to/plan9" to start as your user (at first run,
    write /sys/lib/newuser at the rc prompt to set up your environment).

Problems
--------

Running Plan9 from a directory can be very handy, especially since you
easily can move files into your virtual system from your host system. It
does however come with a cost, which is related to user permissions. You
will most likely run into issues where directories can not be created
since the virtual Plan9 system lacks write permissions.

> Installing Plan9 on a disk image

One alternative to overcome this is to install a Plan9 according to
these instructions.

> Putting the Plan9 root file system in an insecure directory

A simpler but less secure way to solve the issue can be to utilize

    chmod -R 777 /path/to/plan9/root/

This way, both user and glenda will be able to write to the plan9 root
system and add directories.

Alternatives
------------

Recent advances in 9front and possibly 9atom makes those distributions
possible to install and boot under virtualbox. Things that may be needed
to make them work:

     * Use the PIIX3 IDE controller
     * install support for USB v2.

Also, for the CWFS of 9front, you need to make a disk image of at least
12 GiB.

Retrieved from
"https://wiki.archlinux.org/index.php?title=9vx&oldid=198018"

Category:

-   Emulators
