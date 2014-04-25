Password Recovery
=================

This guide will show you how to recover a forgotten root password. A
several methods are available that can help you accomplish this.

Contents
--------

-   1 Using a LiveCD
    -   1.1 Change Root
-   2 Using GRUB to Invoke Bash
-   3 Countermeasures
-   4 Resources

Using a LiveCD
--------------

With a LiveCD a couple methods are available: change root and use the
passwd command, or erase the password field entry. Any Linux capable
LiveCD can be used, albeit to change root it must match your installed
architecture type.

> Change Root

1.  Boot the LiveCD, and change root.
2.  Use the passwd command to reset your root password.
3.  Exit change root.
4.  Reboot, and remember your password.

Using GRUB to Invoke Bash
-------------------------

1. Select the appropriate boot entry in the GRUB menu and press e to
edit the line.

2. Select the kernel line and press e again to edit it.

3. Append init=/bin/bash at the end of line.

4. Press b to boot (this change is only temporary and will not be saved
to your menu.lst). After booting you will be at the bash prompt.

5. Your root file system should be mounted as readonly so remount it as
read/write:

    # mount -n -o remount,rw /

6. Use the passwd command to create a new root password.

7. Reboot and do not lose your password again!

Note:Some keyboards may not be loaded properly by the init system with
this method and you will not be able to type anything at the bash
prompt. If this is the case, you will have to use another method.

Countermeasures
---------------

An attacker could use the methods mentioned above to break into your
system. No matter how secure the operating system is or how good
passwords are, having physical access amounts to loading an alternate OS
and exposing your data, unless you use full disk encryption.

Resources
---------

-   this guide for an example.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Password_Recovery&oldid=265906"

Categories:

-   System recovery
-   Security

-   This page was last modified on 11 July 2013, at 22:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
