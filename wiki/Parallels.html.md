Parallels
=========

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Instructions do  
                           not comply to            
                           Help:Style. (Discuss)    
  ------------------------ ------------------------ ------------------------

This article is about running Arch as guest operation system on
Parallels.

Contents
--------

-   1 Overview
-   2 Installation of Arch as guest.
-   3 Configuring Xorg
-   4 Parallels Tools
    -   4.1 Overview
    -   4.2 Installation
    -   4.3 configuration
    -   4.4 Using the Tools
        -   4.4.1 Sharing Folders
        -   4.4.2 Dynamic Display Resolution
-   5 Appendix A: Alternatives to Parallels

Overview
--------

Parallels is a software, which allows you to setup virtual machines and
run different operation systems without need to reboot your computer. A
more complete description on virtualisation can be found on Wikipedia.
At the moment of writing Parallels is released in version 6. The current
kernel version is 2.6.36 and 2.6.37 is considered stable.

Installation of Arch as guest.
------------------------------

Parallels supports Linux guests out of the box. For Arch you can chose
"other linux - kernel 2.6". There is not much to say on installation -
the steps are the same, as if you would install Arch on a real machine.

Configuring Xorg
----------------

Follow the instructions at Xorg. The xf86-video-vesa video driver works
great with Xorg running inside Parallels:

    # pacman -S xf86-video-vesa

Parallels Tools
---------------

> Overview

To improve the interoperability between the host and the guest operation
systems, Parallels provides you a package with kernel modules and
userspace tools called "Parallels Tools". Here is the list of features.

> Installation

Choose "install Parallels Tools" from the "Virtual Machine" menu.
Parallels Tools are located on a cd-image, which was connected to you
virtual machine. You have to mount it first:

    # mount /dev/sr0 /mnt/cdrom

The installation-script expects to find your init-scripts in
/etc/init.d/. The installation will fail, if the directory is not
present. To fix it, create the directory:

    # mkdir /etc/init.d

    # export def_sysconfdir=/etc/init.d

The installation-script expects to find /etc/X11/xorg.conf too. Your
xorg configuration will be fixed to work with Parallels Tools. The
installation will fail, if xorg.conf is not present. Create it:

    # touch /etc/X11/xorg.conf

The installation script expects gcc, make and kernel headers to be
installed:

    #pacman -S gcc make linux-headers

After the installation you can move xorg.conf to /etc/X11/xorg.conf.d/
and call it something like 10-parallels.conf if you want. It is be
probably a more appropriate location, but you do not have to - it will
work as it is now too.

Then you can run the installer-script and follow the instructions:

    # cd /mnt/cdrom

    # ./install

> configuration

Move scripts in /etc/init.d to /usr/lib/systemd/scripts

Create parallels-tools service:

/usr/lib/systemd/system/parallels-tools.service

    [Unit]
    Description=Parallels Tools

    [Service]
    Type=oneshot
    ExecStart=/usr/lib/systemd/scripts/prltoolsd start
    ExecStop=/usr/lib/systemd/scripts/prltoolsd stop
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

> Using the Tools

Sharing Folders

you can specify which folders on your hosts system you would like to
share with your guests under "virtual machine > configuration >
sharing". Then you mount a shared folder like this:

    # mount -t prl_fs name_of_share /mnt/name_of_share

Dynamic Display Resolution

a very helpful tool is prlcc. It changes the resolution of your display
(in the guest operation system - not the host) automatically, when your
change the size of the window. If this tool is not running the content
of the window gets stretched or shrunken. prlcc usually gets started
automatically and runs in the background. If not, just run following:

    $ prlcc &

Appendix A: Alternatives to Parallels
-------------------------------------

Parallels is a popular virtualization solution for the mac platform, but
it is not the only one. There is a competitive product from VMware
called VMware Fusion and of course the free and awesome VirtualBox from
Oracle (former Sun Microsystems). For Windwos VMware provides a free
product called VMware Player, which lets you run (but not create, as far
as i know) virtual machines.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Parallels&oldid=296872"

Category:

-   Virtualization

-   This page was last modified on 11 February 2014, at 20:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
