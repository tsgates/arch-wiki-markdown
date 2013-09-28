Archup
======

Note:archup is a dead project, you can use aarchup instead, a fork of
archup.

archup is a small C application which informs the user when
system-updates for Archlinux are available. It's licenced under the
GPLv3. In contrast to other update notifiers archup is intended to be
lightweight and just do what it should: notify about possible updates.

archup uses GTk+ and libnotify to show a desktop notification if updates
are available. It follows the unix-philosophy of "just doing one thing,
but doing it well". It just notifies about new updates but the
packagedatabase has to be updated by the user (better said a cronjob).
With a cronjob archup can be used to regulary check for new updates and
get a desktop notification if there are some.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 From the AUR                                                 |
|     -   1.2 Manually                                                     |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Hourly                                                       |
|     -   2.2 Other intervals                                              |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> From the AUR

Install archup from the AUR.

> Manually

Get a working-copy of archup:

    git clone git://git.sv.gnu.org/archup.git

Change to the directory of the downloaded source and then follow the
commands below:

    $ autoconf
    $ ./configure
    $ make
    $ make install

This installs the binary to /usr/bin/archup and the other files to
/usr/share/doc/archup.

Configuration
-------------

archup can simply be invoked by executing it from the commandline. But
you surely want to automate this task and let archup continouisly be run
with a cronjob.

> Hourly

The most simple setup is for a single user system where you want to
check once an hour for updates. In this case just copy the
/usr/share/doc/archup/cronhourly.example to /etc/cron.hourly/archup.sh

    # cp /usr/share/doc/archup/cronhourly.example /etc/cron.hourly/archup.sh

and make it executable with

    # chmod 755 /etc/cron.hourly/archup.sh

Do not forget to open this file with a text editor of your choice and
change the username of the arch_user value with your username.

Now every hour your package database will get updated and after that
archup will be executed. If there are updates archup shows a desktop
notification, if there are no updates nothing will happen. The desktop
notification will automatically disappear after 60min or if you simply
click on it.

> Other intervals

If you want to execute archup at other intervals than hourly you are
free to do so simply by setting up a custom cronjob (read man cron for
more on this).

Some hints on this:

-   you can adjust the timeout value, before the notification will
    disappear with the --timeout option of archup.
-   you should take care that the packagedatabase gets updated by
    executing /usr/bin/pacman -Sy before archup gets executed.
-   if you wanna start a graphical application from a cronjob you
    propably have to set the DISPLAY and XAUTHORITY values. The best is
    taking a look at /usr/share/doc/archup/cronhourly.example and get
    your inspiration there.

    cronhourly.example

    #!/bin/bash
     
    arch_user=rorschach
     
    if [ -z "$(pgrep pacman)" ];then
            /usr/bin/pacman -Sy > /dev/null
    fi

    XAUTHORITY=/home/$arch_user/.Xauthority DISPLAY=:0.0 /usr/bin/archup --uid $(id -u $arch_user)

Note:Make sure to replace "arch_user" with the specific user.

Troubleshooting
---------------

If you want to use notify-osd, be aware that notify-osd doesn't respect
libnotify timeouts and thus the notifications will disappear in the
regular notify-osd interval and not in the one you tell archup. But
there's a patch for notify-osd which fixes this.

See also
--------

-   archup homepage
-   aarchup a fork of archup
-   Thread in archlinux forum about archup
-   Screenshots: KDE, Gnome (with notify-osd), Gnome (low urgency),
    Gnome (normal urgency), Gnome (critical urgency)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Archup&oldid=238333"

Category:

-   Package management
