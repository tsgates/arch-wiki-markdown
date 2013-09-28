GVFS
====

GVFS is the virtual filesystem for the GNOME desktop, which allows
mounting local and remote filesystems as a user along with trash
support. It is also used by file managers like Thunar.

Installation
------------

The gvfs package needs to be installed, along with polkit-gnome for the
polkit rules.

GVFS without root password
--------------------------

In file managers (e.g. Thunar), when you try to mount a drive, you might
see that you need to enter the root password to continue every single
time you want to mount and unmount a drive. This can be bypassed by
setting a polkit rule.

In the directory /usr/share/polkit-1/rules.d, create this file named
10-drives.rules:

    polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.udisks2.") == 0){ 
           return polkit.Result.YES;
       }
    }
    );

Drives will now mount without any intervention from you. If you need to
specify which users can perform this action or other restrictions, there
is info in man polkit.

Retrieved from
"https://wiki.archlinux.org/index.php?title=GVFS&oldid=244909"

Category:

-   File systems
