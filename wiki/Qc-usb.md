Qc-usb
======

This guide will help you retrieve the qc-usb drivers for your Quickcam.

Downloading and installing
--------------------------

This module is in AUR. As I write, the dependency linux-headers has been
left out of the PKGBUILD, so you'll need to install it manually.

Finding the module
------------------

The module is called c-qcam. Load it with modprobe or add it to MODULES
in /etc/rc.conf. Udev should autoload it on reboot, though.

NOTE: If you have a Logitech Quickcam Messenger webcam, you need the
qc-usb-messenger package, also in [community].

Retrieved from
"https://wiki.archlinux.org/index.php?title=Qc-usb&oldid=205030"

Category:

-   Other hardware

-   This page was last modified on 13 June 2012, at 08:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
