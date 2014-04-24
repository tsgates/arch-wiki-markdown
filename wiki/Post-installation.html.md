Beginners' guide/Post-installation
==================================

Tip:This is part of a multi-page article for The Beginners' Guide. Click
here if you would rather read the guide in its entirety.

Contents
--------

-   1 Post-installation
    -   1.1 User management
    -   1.2 Package management
    -   1.3 Service management
    -   1.4 Sound
    -   1.5 Graphical User Interface
        -   1.5.1 Install X
        -   1.5.2 Install a video driver
        -   1.5.3 Install input drivers
        -   1.5.4 Configure X
        -   1.5.5 Test X
            -   1.5.5.1 Troubleshooting
        -   1.5.6 Fonts
        -   1.5.7 Choose and install a graphical interface
-   2 Appendix

Post-installation
-----------------

Your new Arch Linux base system is now a functional GNU/Linux
environment ready to be built into whatever you wish or require for your
purposes. If you are new to Linux, it might be useful to take a look at
the Core utilities included with your new system.

> User management

Add any user accounts you require besides root, as described in User
management. It is not good practice to use the root account for regular
use, or expose it via SSH on a server. The root account should only be
used for administrative tasks.

A typical desktop system example: adding a new user named archie and
specifying Bash as the login shell:

    # useradd -m -s /bin/bash archie

This command will automtically create a group called archie with the
same GID as the UID of the user archie and makes this the default group
for archie on login.

Other scenarios are possible, see Users and groups for more details and
potential security risks.

> Package management

Pacman is the Arch Linux package manager. See pacman and FAQ#Package
Management for answers regarding installing, updating, and managing
packages.

Because of The Arch Way#Code-correctness over convenience it is
imperative to keep up to date with changes in Arch Linux that require
manual intervention before upgrading your system. Subscribe to the
arch-announce mailing list or check the front page Arch news every time
before you update. Alternatively, you may find it useful to subscribe to
this RSS feed or follow @archlinux on Twitter.

If you installed Arch Linux x86_64, you may want to enable the
[multilib] repository if you plan on using 32-bit applications.

See Official repositories for details about the purpose of each
repository.

> Service management

Arch Linux uses systemd as init, which is a system and service manager
for Linux. For maintaining your Arch Linux installation, it is a good
idea to learn the basics about it. Interaction with systemd is done
through the systemctl command. Read systemd#Basic systemctl usage for
more information.

> Sound

ALSA usually works out-of-the-box. It just needs to be unmuted. Install
alsa-utils (which contains alsamixer) and follow these instructions.

ALSA is included with the kernel and it is recommended. If it does not
work, OSS is a viable alternative. If you have advanced audio
requirements, take a look at Sound system for an overview of various
articles.

> Graphical User Interface

Install X

The X Window System (commonly X11, or X) is a networking and display
protocol which provides windowing on bitmap displays. It provides the
standard toolkit and protocol to build graphical user interfaces (GUIs).

To install the base Xorg packages:

    # pacman -S xorg-server xorg-server-utils xorg-xinit

Install mesa for 3D support:

    # pacman -S mesa

Install a video driver

Note:If you installed Arch as a VirtualBox guest, you do not need to
install a video driver. See Arch Linux guests for installing and setting
up Guest Additions, and jump to the configuration part below.

The Linux kernel includes open-source video drivers and support for
hardware accelerated framebuffers. However, userland support is required
for OpenGL and 2D acceleration in X11.

If you do not know which video chipset is available on your machine,
run:

    $ lspci | grep VGA

For a complete list of open-source video drivers, search the package
database:

    $ pacman -Ss xf86-video | less

The vesa driver is a generic mode-setting driver that will work with
almost every GPU, but will not provide any 2D or 3D acceleration. If a
better driver cannot be found or fails to load, Xorg will fall back to
vesa. To install it:

    # pacman -S xf86-video-vesa

In order for video acceleration to work, and often to expose all the
modes that the GPU can set, a proper video driver is required. See
Xorg#Driver installation for a table of most frequently used video
drivers.

Install input drivers

Udev should be capable of detecting your hardware without problems. The
evdev driver (xf86-input-evdev) is the modern hot-plugging input driver
for almost all devices, so in most cases, installing input drivers is
not needed. At this point, evdev has already been installed as a
dependency of the xorg-server package.

Laptop users (or users with a tactile screen) will need the
xf86-input-synaptics package for the touchpad/touchscreen to work:

    # pacman -S xf86-input-synaptics

For instructions on fine tuning or troubleshooting touchpad issues, see
the Touchpad Synaptics article.

Configure X

Warning:Proprietary drivers usually require a reboot after installation.
See NVIDIA or AMD Catalyst for details.

Xorg features auto-detection and therefore can function without an
xorg.conf. If you still wish to manually configure X Server, please see
the Xorg wiki page.

You may need to configure keyboard layout if you do not use a standard
US keyboard.

Note:The XkbLayout key may differ from the keymap code you used with the
loadkeys command. A list of many keyboard layouts and variants can be
found in /usr/share/X11/xkb/rules/base.lst (after the line beginning
with ! layout). For instance, the layout gb corresponds to "English
(UK)", whereas for the console it was loadkeys uk.

Test X

Tip:These steps are optional. Test if you are installing Arch Linux for
the first time, or if you are installing on new and unfamiliar hardware.

Note:If your input devices are not working during this test, install the
needed driver from the xorg-drivers group, and try again. For a complete
list of available input drivers, invoke a pacman search (press Q to
exit):

    $ pacman -Ss xf86-input | less

You only need xf86-input-keyboard or xf86-input-mouse if you plan on
disabling hot-plugging, otherwise, evdev will act as the input driver
(recommended).

Install the default environment:

    # pacman -S xorg-twm xorg-xclock xterm

If Xorg was installed before creating the non-root user, there will be a
template .xinitrc file in your home directory that needs to be either
deleted or commented out. Simply deleting it will cause X to run with
the default environment installed above.

    $ rm ~/.xinitrc

Note:X must always be run on the same tty where the login occurred, to
preserve the logind session. This is handled by the default
/etc/X11/xinit/xserverrc.

To start the (test) Xorg session, run:

    $ startx

A few movable windows should show up, and your mouse should work. Once
you are satisfied that X installation was a success, you may exit out of
X by issuing the exit command into the prompts until you return to the
console.

    $ exit

If the screen goes black, you may still attempt to switch to a different
virtual console (e.g. Ctrl+Alt+F2), and blindly log in as root. You can
do this by typing "root" (press Enter after typing it) and entering the
root password (again, press Enter after typing it).

You may also attempt to kill the X server with:

    # pkill X

If this does not work, reboot blindly with:

    # reboot

Troubleshooting

If a problem occurs, look for errors in Xorg.0.log. Be on the lookout
for any lines beginning with (EE) which represent errors, and also (WW)
which are warnings that could indicate other issues.

    $ grep EE /var/log/Xorg.0.log

If you are still having trouble after consulting the Xorg article and
need assistance via the Arch Linux forums or the IRC channel, be sure to
install and use wgetpaste by providing the links from:

    # pacman -S wgetpaste
    $ wgetpaste ~/.xinitrc
    $ wgetpaste /etc/X11/xorg.conf
    $ wgetpaste /var/log/Xorg.0.log

Note:Please provide all pertinent information (hardware, driver
information, etc) when asking for assistance.

Fonts

You may wish to install a set of TrueType fonts, as only unscalable
bitmap fonts are included by default. However, if you use a full
featured Desktop environment like KDE , this step may not be necessary.
DejaVu is a set of high quality, general-purpose fonts with good Unicode
coverage:

    # pacman -S ttf-dejavu

Refer to Font Configuration for how to configure font rendering and
Fonts for font suggestions and installation instructions.

Choose and install a graphical interface

The X Window System provides the basic framework for building a
graphical user interface (GUI).

Note:Choosing your DE or WM is a very subjective and personal decision.
Choose the best environment for your needs. You can also build your own
DE with just a WM and the applications of your choice.

-   Window Managers (WM) control the placement and appearance of
    application windows in conjunction with the X Window System.

-   Desktop Environments (DE) work atop and in conjunction with X, to
    provide a completely functional and dynamic GUI. A DE typically
    provides a window manager, icons, applets, windows, toolbars,
    folders, wallpapers, a suite of applications and abilities like drag
    and drop.

Instead of starting X manually with startx from xorg-xinit, see Display
manager for instructions on using a display manager, or see Start X at
Login for using an existing virtual terminal as an equivalent to a
display manager.

Appendix
--------

For a list of applications that may be of interest, see List of
Applications.

See General recommendations for post-installation tutorials like setting
up a touchpad or font rendering.

Beginners' guide

* * * * *

Preparation >> Installation >> Post-installation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Beginners%27_guide/Post-installation&oldid=302428"

Categories:

-   Getting and installing Arch
-   About Arch

-   This page was last modified on 28 February 2014, at 16:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
