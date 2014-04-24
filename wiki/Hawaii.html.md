hawaii
======

Related articles

-   Desktop environment
-   Display manager
-   Window manager
-   Qt

From phoronix.com

"...the Hawaii Desktop is looking to be the very first Wayland-friendly
desktop environment for Linux. The Hawaii desktop is the product of the
Maui OS team, a Linux distribution that's trying to avoid traditional
packages and instead provide a minimal image with the Linux kernel,
systemd, ConnMan, and other core components, while being powered by a
Wayland desktop."

Note:The hawaii desktop environment, has not reached its stable 1.0
release. The latest version is 0.2.0. It may not work properly on your
system.

Contents
--------

-   1 Installation
-   2 Run hawaii
    -   2.1 Without login manager
-   3 External Links

Installation
------------

Ensure wayland and weston are installed from the official repositories.

Install hawaii-meta-git from the AUR.

Alternatively, you can use the upstream binary package for hawaii. Click
on the tab labeled "Arch Linux" and follow the instructions.

http://www.maui-project.org/download/

Note:If you use this binary package, then the hawaii binary will be
stored in /opt/hawaii-git/bin/hawaii

Note:The current upstream binary package only supports the x86_64
architecture.

Run hawaii
----------

> Without login manager

To run hawaii without a login manager, simply add exec hawaii to the
startup script of your choice.

Note:Do not start hawaii by adding it to ~/.xinitrc. Xinit is commonly
used to start Xorg, but hawaii uses Wayland, which is a newer graphical
protocal.

External Links
--------------

-   http://www.maui-project.org/ Maui Linux OS website
-   https://github.com/mauios/hawaii Hawaii's github page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hawaii&oldid=301372"

Category:

-   Desktop environments

-   This page was last modified on 24 February 2014, at 11:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
