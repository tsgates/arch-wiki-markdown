XBMC
====

XBMC (formerly "Xbox Media Center") is a free, open source (GPL)
multimedia player that originally ran on the first-generation XBox, (not
the newer Xbox 360), and now runs on computers running Linux, Mac OS X,
Windows, and iOS. XBMC can be used to play/view the most popular video,
audio, and picture formats, and many more lesser-known formats,
including:

-   Video - DVD-Video, VCD/SVCD, MPEG-1/2/4, DivX, XviD, Matroska
-   Audio - MP3, AAC.
-   Picture - JPG, GIF, PNG.

These can all be played directly from a CD/DVD, or from the hard-drive.
XBMC can also play multimedia from a computer over a local network
(LAN), or play media streams directly from the Internet. For more
information, see the XBMC FAQ.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Autostarting at boot                                         |
|     -   2.2 Enabling shutdown, restart, hibernate and suspend            |
|     -   2.3 Using a Remote                                               |
|         -   2.3.1 MCE Remote with Lirc and Systemd                       |
|                                                                          |
|     -   2.4 Fullscreen mode stretches XBMC accross multiple displays     |
|     -   2.5 Slowing down CD/DVD drive speed                              |
|                                                                          |
| -   3 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Note:These instructions assume you have a working X installation. If you
have not done this yet, please consult
Beginners_Guide#Graphical_User_Interface.

The stable version of XBMC is available in the community repo:

    # pacman -Syu xbmc

The SVN (testing) version of XBMC can be downloaded from the AUR
(XBMC-git), e.g. using yaourt:

    # yaourt -Syua xbmc-git

Warning:This is not the recommended way of using XBMC, as svn versions
are always on the bleeding edge of development and thus can break
sometimes. If you want a stable media center experience, go with the
stable releases.

If you plan to use the pvr extensions of xbmc you will need to install
the addons separately.

    # pacman -S xbmc-pvr-addons

Configuration
-------------

> Autostarting at boot

To use XBMC on HTPC you may want to start XBMC automatically on boot.
Since version 11.0-11 xbmc package includes the xbmc group, user, and
service file necessary to do this.

To make XBMC start at system boot you should simply enable the service:

    # systemctl enable xbmc

> Enabling shutdown, restart, hibernate and suspend

Since version 12 XBMC supports power management via systemd logind
daemon. To enable it you should have polkit and upower installed on your
system.

    # pacman -S polkit upower

Add the following rule file which will allow users added to power group
shutdown, restart, hibernate and suspend computer.

    /etc/polkit-1/rules.d/10-xbmc.rules

    polkit.addRule(function(action, subject) {
        if(action.id.match("org.freedesktop.login1.") && subject.isInGroup("power")) {
            return polkit.Result.YES;
        }
    });

    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks") == 0 && subject.isInGroup("storage")) {
            return polkit.Result.YES;
        }
    });

> Using a Remote

As XBMC is geared toward being a remote-controlled media center, if your
computer has an IR receiver, you will probably want to set up a remote
using LIRC. Once you are sure your remote is working properly (tested
with $ irw), add lircd to your DAEMONS Array and you'll be ready to
create an Lircmap.xml file for it.

Using your favorite text editor, you'll need to go in and create an XML
file at ~/.xbmc/userdata/Lircmap.xml (note the capital 'L'). Lircmap.xml
format is as follows:

    <lircmap>
      <remote device="devicename">
          <XBMC_button>LIRC_button</XBMC_button>
          ...
      </remote>
    </lircmap>

-   Device Name is whatever LIRC calls your remote. This is set using
    the Name directive in lircd.conf and can be viewed by running $ irw
    and pressing a few buttons on the remote. IRW will report the name
    of the button pressed and the name of the remote will appear on the
    end of the line.

-   XBMC_button is the name of the button as defined in keymap.xml.

-   LIRC_button is the name as defined in lircd.conf. If you
    automatically generated your lircd.conf using # irrecord, these are
    the names you selected for your button then. Refer back to LIRC for
    more information.

-   You may want to check out the very thorough Lircmap.xml page over at
    the XBMC Wiki for more help and information on this subject.

MCE Remote with Lirc and Systemd

Install lirc-utils and link the mce config:

    pacman -S lirc-utils
    ln -s /usr/share/lirc/remotes/mceusb/lircd.conf.mceusb /etc/lirc/lircd.conf

Then, make sure the remote is using the lirc protocol.

    cat /sys/class/rc/rc0/protocols # [lirc] should be selected
    echo lirc > /sys/class/rc/rc0/protocols # manually set lirc

A udev rule can be added to make lirc the default. A write rule doesn't
seem to work, so a simple RUN command can be executed instead.

    /etc/udev/rules.d/99-lirc.rules

    KERNEL=="rc*", SUBSYSTEM=="rc", ATTR{protocols}=="*lirc*", RUN+="/bin/sh -c 'echo lirc > $sys$devpath/protocols'"

Next, specify the lirc device. This varies with kernel version. As of
3.6.1 /dev/lirc0 should work with the default driver.

    /etc/conf.d/lircd.conf

    #
    # Parameters for lirc daemon
    #

    LIRC_DEVICE="/dev/lirc0"
    LIRC_DRIVER="default"
    LIRC_EXTRAOPTS=""
    LIRC_CONFIGFILE=""

The default service file for lirc ignores this conf file. So we need to
create a custom one.

    /etc/systemd/system/lirc.service

    [Unit]
    Description=Linux Infrared Remote Control

    [Service]
    EnvironmentFile=/etc/conf.d/lircd.conf
    ExecStartPre=/usr/bin/ln -sf /run/lirc/lircd /dev/lircd
    ExecStart=/usr/sbin/lircd --pidfile=/run/lirc/lircd.pid --device=${LIRC_DEVICE} --driver=${LIRC_DRIVER}
    Type=forking
    PIDFile=/run/lirc/lircd.pid

    [Install]
    WantedBy=multi-user.target

Finally, enable and start the lirc service.

    systemctl enable lirc
    systemctl start lirc

This should give a fully working mce remote.

> Fullscreen mode stretches XBMC accross multiple displays

If you have got a multi-monitor setup and don't want XBMC to stretch
accross all screens, you can restrict the fullscreen mode to one
display, by setting the environment variable SDL_VIDEO_FULLSCREEN_HEAD
to the number of the desired target display. For example if you want
XBMC to show up on display 0 you can add the following line to your
Bashrc:

    SDL_VIDEO_FULLSCREEN_HEAD=0

Note:Mouse corsor will be hold inside screen with XBMC.

> Slowing down CD/DVD drive speed

The eject program from the util-linux package does a nice job for this,
but its setting is cleared as soon as the media is changed.

This udev-rule reduces the speed permanently:

    /etc/udev/rules.d/dvd-speed.rules

    KERNEL=="sr0", ACTION=="change", ENV{DISK_MEDIA_CHANGE}=="1", RUN+="/usr/bin/eject -x 2 /dev/sr0"

Replace sr0 with the device name of your optical drive. Replace -x 2
with -x 4 if you prefer 4x-speed instead of 2x-speed.

After creating the file, reload the udev rules with

    udevadm control --reload

Resources
---------

-   XBMC Wiki: An excellent resource with much information about Arch
    Linux specifically (upon which the original version of this article
    was largely based).

Retrieved from
"https://wiki.archlinux.org/index.php?title=XBMC&oldid=255796"

Category:

-   Player
