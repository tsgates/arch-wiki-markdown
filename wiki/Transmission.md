Transmission
============

Transmission is a light-weight and cross-platform BitTorrent client. It
is the default BitTorrent client in many Linux distributions.

Contents
--------

-   1 Installation
-   2 Configuring the GUI version
-   3 Transmission-daemon and CLI
    -   3.1 Starting and stopping the daemon
        -   3.1.1 Autostart at boot
        -   3.1.2 Run only while connected to network
            -   3.1.2.1 Netctl
            -   3.1.2.2 Wicd
            -   3.1.2.3 NetworkManager
    -   3.2 Choosing a user
    -   3.3 Configuring the daemon
-   4 See also

Installation
------------

There are several options in official repositories:

-   transmission-cli - daemon, with CLI, and web client
    (http://localhost:9091) interfaces.
-   transmission-remote-cli - Curses interface for the daemon.
-   transmission-gtk - GTK3 package.
-   transmission-qt - Qt5 package.

Note:The GTK client cannot connect to the daemon, so users wishing to
use the daemon will need to consider using the Qt package for a GUI or
the remote-cli package for a curses-based GUI.

Configuring the GUI version
---------------------------

Both GUI versions, transmission-gtk and transmission-qt, can function
autonomously without a formal back-end daemon.

GUI versions are configured to work out-of-the-box, but the user may
wish to change some of the settings. The default path to the GUI
configuration files is ~/.config/transmission.

A guide to configuration options can be found on the Transmission web
site: https://trac.transmissionbt.com/wiki/EditConfigFiles#Options.

Transmission-daemon and CLI
---------------------------

The commands for transmission-cli are:

transmission-daemon: starts the daemon.

transmission-remote: invokes the CLI for the daemon, whether local or
remote, followed by the command you want the daemon to execute.

transmission-remote-cli: (requires transmission-remote-cli) starts the
curses interface for the daemon, whether local or remote.

transmission-cli: starts a non-daemonized local instance of
transmission, for manually downloading a torrent.

transmission-show: returns information on a given torrent file.

transmission-create: creates a new torrent.

transmission-edit: add, delete, or replace a tracker's announce URL.

> Starting and stopping the daemon

As explained in #Choosing a user, the transmission daemon can be run:

-   As the user transmission, by running as root:

        # transmission-daemon

    The daemon can then be stopped with:

        # killall transmission-daemon

-   As your own user, by running under your user name:

        $ transmission-daemon

    The daemon can then be stopped with:

        $ killall transmission-daemon

-   Starting (and stopping) the transmission service with systemctl will
    use the user set in #Choosing a user. Note that the name for the
    systemd service is transmission, not transmission-daemon.

Starting the daemon will create an initial transmission configuration
file. See #Configuring the daemon.

An alternative option to stop the transmission daemon is to use the
transmission-remote command:

    $ transmission-remote --exit

Autostart at boot

Enable the transmission daemon to run at system start, using systemd.

Note that the name for the systemd service is transmission, not
transmission-daemon.

Run only while connected to network

Netctl

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Todo (Discuss)   
  ------------------------ ------------------------ ------------------------

Wicd

Create a start script in folder /etc/wicd/scripts/postconnect, and a
stop script in folder /etc/wicd/scripts/predisconnect. Remember to make
them executable. For example:

    /etc/wicd/scripts/postconnect/transmission

    #!/bin/bash

    /usr/bin/transmission-daemon

    /etc/wicd/scripts/predisconnect/transmission

    #!/bin/bash

    killall transmission-daemon

NetworkManager

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Todo (Discuss)   
  ------------------------ ------------------------ ------------------------

> Choosing a user

Choose how you want to run transmission:

-   As a separate user, transmission by default (recommended for
    increased security).

By default, transmission creates a user and a group transmission, with
its home files at /var/lib/transmission/, and runs as this "user". This
is a security precaution, so transmission, and its downloads, have no
access to files outside of /var/lib/transmission/. Configuration,
operation, and access to downloads needs to be done with "root"
privileges (e.g. by using sudo).

-   Under the user's own user name.

To set this up, override the provided service file and specify your
username:

    /etc/systemd/system/transmission.service.d/transmission.conf

    [Service]
    User=your_username

> Configuring the daemon

Create an initial configuration file by starting the daemon.

-   If running Transmission under the username transmission, the
    configuration file will be located at
    /var/lib/transmission/.config/transmission-daemon/settings.json.

-   If running Transmission under your own username, the configuration
    file will be located at ~/.config/transmission-daemon/settings.json.

One can customize the daemon by using a Transmission client or using the
included web interface accessible via http://localhost:9091 in a
supported browser.

A guide to configuration options can be found on the Transmission web
site: https://trac.transmissionbt.com/wiki/EditConfigFiles#Options

Note:If you want to edit the configuration manually using a text editor,
stop the daemon first; otherwise, it would overwrite its configuration
file when it closes.

A recommendation for those running under username transmission is to
create a shared download directory with the correct permissions to allow
access to both the transmission user and system users, and then to
update the configuration file accordingly. For example:

    # mkdir /mnt/data/torrents
    # chown -R facade:transmission /mnt/data/torrents
    # chmod -R 775 /mnt/data/torrents

Now /mnt/data/torrents will be accessible for the system user facade and
for the transmission group to which the transmission user belongs.
Making the target directory world read/writable is highly discouraged
(i.e. do not chmod the directory to 777). Instead, give individual
users/groups appropriate permissions to the appropriate directories.

Note:If /mnt/data/torrents is located on a removable device, e.g. with
an /etc/fstab entry with the option nofail, Transmission will complain
that it cannot find your files. To remedy this, you can add
RequiresMountsFor=/mnt/data/torrents to
/etc/systemd/system/transmission.service.d/transmission.conf.

See also
--------

-   Transmission wiki
-   HeadlessUsage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Transmission&oldid=302665"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
