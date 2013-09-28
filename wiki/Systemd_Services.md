systemd/Services
================

Summary

Related

systemd

This page is useful to publish systemd service files that are missing in
the appropriate package in the repositories. These files can be copied
from other distributions or created by yourself.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Change name of wireless interface                                  |
| -   2 dropbear                                                           |
| -   3 IPv6 (Hurricane Electric)                                          |
| -   4 Logmein Hamachi                                                    |
| -   5 Filesystem mounts                                                  |
| -   6 screen                                                             |
| -   7 Static Ethernet network                                            |
| -   8 Set network interface in promiscuous mode                          |
| -   9 shellinaboxd                                                       |
| -   10 tmux                                                              |
| -   11 tpfand                                                            |
| -   12 truecrypt volume setup                                            |
| -   13 truecrypt (mount encrypted fs)                                    |
| -   14 truecrypt (unmount encrypted fs)                                  |
| -   15 MPD Socket Activation                                             |
| -   16 VideoLAN 2.0                                                      |
| -   17 Xvfb                                                              |
| -   18 Nexus                                                             |
| -   19 Gitlab                                                            |
| -   20 Cisco AnyConnect VPN                                              |
| -   21 Emacs Daemon                                                      |
| -   22 Monkey http server deamon                                         |
| -   23 VirtualBox virtual machines                                       |
| -   24 redmine                                                           |
| -   25 See also                                                          |
+--------------------------------------------------------------------------+

Change name of wireless interface
---------------------------------

For those rare occasions where this is necessary.

    /etc/iftab

    wlan* mac [mac-address]

Replace [mac-address] with the one corresponding to the networking
hardware.

    /etc/systemd/system/fix-wireless-interface.service

    [Unit]
    Description=Changes the wireless interface eth1 to the proper wlan*
    Wants=network.target
    Before=network.target
     
    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/ifrename -c /etc/iftab
     
    [Install]
    WantedBy=multi-user.target

dropbear
--------

    /etc/systemd/system/dropbear.service


    [Unit]
    Description=Dropbear SSH server

    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/dropbear -p 22 -d /etc/dropbear/dropbear_dss_host_key -w -P /var/run/dropbear.pid
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

IPv6 (Hurricane Electric)
-------------------------

    /etc/systemd/system/he-ipv6.service


    [Unit]
    Description=he.net IPv6 tunnel
    After=network.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/sbin/ip tunnel add he-ipv6 mode sit remote 209.51.161.14 local <local IPv4> ttl 255
    ExecStart=/sbin/ip link set he-ipv6 up mtu 1480
    ExecStart=/sbin/ip addr add <local IPv6>/64 dev he-ipv6
    ExecStart=/sbin/ip -6 route add ::/0 dev he-ipv6
    ExecStop=/sbin/ip -6 route del ::/0 dev he-ipv6
    ExecStop=/sbin/ip link set he-ipv6 down
    ExecStop=/sbin/ip tunnel del he-ipv6

    [Install]
    WantedBy=multi-user.target

Logmein Hamachi
---------------

    /etc/systemd/system/logmein-hamachi.service

    [Unit]
    Description=LogMeIn Hamachi daemon
    After=local-fs.target network.target

    [Service]
    ExecStart=/opt/logmein-hamachi/bin/hamachid
    Type=forking

    [Install]
    WantedBy=multi-user.target

Filesystem mounts
-----------------

See: Systemd#Filesystem_mounts

screen
------

Autostarts screen for the specified user. (e.g. `systemctl enable
screen@florian.service`)

    /etc/systemd/system/screen@.service

    [Unit]
    Description=screen
    After=network.target

    [Service]
    Type=forking
    User=%i
    ExecStart=/usr/bin/screen -dmS autoscreen
    ExecStop=/usr/bin/screen -S autoscreen -X quit

    [Install]
    WantedBy=multi-user.target

Static Ethernet network
-----------------------

This is a custom service file for static Ethernet configurations.

    /etc/conf.d/network

    interface=eth0
    address=192.168.0.1
    netmask=24
    broadcast=192.168.0.255
    gateway=192.168.0.254

    /etc/systemd/system/network.service

    [Unit]
    Description=Network Connectivity
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-${interface}.device 
    After=sys-subsystem-net-devices-${interface}.device 


    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/etc/conf.d/network
    ExecStart=/sbin/ip link set dev ${interface} up
    ExecStart=/sbin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev ${interface}
    ExecStart=/sbin/ip route add default via ${gateway}

    ExecStop=/sbin/ip addr flush dev ${interface}
    ExecStop=/sbin/ip link set dev ${interface} down

    [Install]
    WantedBy=multi-user.target

Set network interface in promiscuous mode
-----------------------------------------

    /etc/systemd/system/promiscuous@.service

    [Unit]
    Description=Set %i interface in promiscuous mode

    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/ip link set dev %i promisc on
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

If you want to enable promiscuous mode on interface eth0 run:

     # systemctl enable promiscuous@eth0.service

shellinaboxd
------------

[1]: "Shell In A Box implements a web server that can export arbitrary
command line tools to a web based terminal emulator."

    /etc/systemd/system/shellinabox.service (do not name it shellinaboxd.service if you installed it from AUR) 

    [Unit]
    Description=Serve a login-terminal over http on  port 4200.
    Required=sshd.service
    After=sshd.service

    [Service]
    User=root
    Type=forking
    ExecStart=/usr/bin/shellinaboxd -s/:SSH -b -p 4200 -c /tmp --css=/usr/share/doc/shellinabox/white-on-black.css
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-abort

    [Install]
    WantedBy=multi-user.target

tmux
----

Starts tmux for specified user (eg. tmux@main-user.service)

    /etc/systemd/system/tmux@.service

    [Unit]
    Description=Start tmux in detached session

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    KillMode=none
    User=%I
    ExecStart=/usr/bin/tmux new-session -s %u -d
    ExecStop=/usr/bin/tmux kill-session -t %u

    [Install]
    WantedBy=multi-user.target

tpfand
------

    /etc/systemd/system/tpfand.service

    [Unit]
    Description=ThinkPad Fan Control

    [Service]
    Type=forking
    PIDFile=/var/run/tpfand.pid
    ExecStart=/usr/sbin/tpfand

    [Install]
    WantedBy=multi-user.target

truecrypt volume setup
----------------------

This service employ truecrypt as a mapper only and requires you to
create an entry in fstab to mount the mapped & unencrypted device to
your desired mountpoint like for instance so:

    /etc/fstab

    /dev/mapper/truecrypt1  /home/          ext4 defaults        0       2

The 2 means your fs will be fscked regularly.

    /usr/lib/systemd/system/truecrypt@.service

    [Unit]
    Description=Truecrypt Setup for %I
    DefaultDependencies=no
    Conflicts=umount.target
    Before=umount.target
    After=systemd-readahead-collect.service systemd-readahead-replay.service

    [Service]
    RemainAfterExit=yes
    StandardInput=tty-force
    ExecStart=/usr/bin/truecrypt --filesystem=none %I
    ExecStop=/usr/bin/truecrypt --filesystem=none -d %I

    [Install]
    WantedBy=cryptsetup.target

If your encrypted volume is /dev/sda2, you would enable the service with
this command:

    # systemctl enable truecrypt@dev-sda2.service

Note:Although it works, this service should stil be considered
experimental, there might be better solutions to use truecrypt with
systemd. If you use mpd or any other programme that needs to access the
encrypted filesystem, put it into the line starting with Before=. Cheers
to dgbaley27 for basically writing this! Improvements welcome!

Note:This way of doing it (specifically the use of tty-force) is not
recommended according to this thread, which suggests an alternative
approach similar to that taken for LUKS.

Note:There are 2 issues possibly arising from this approach: one is a
possible timeout when the password is not entered within 90 seconds; and
the second is the side-by-side compatibility of mounting more than one
device in this way. The first can be resolved by slightly modifying each
of the two files: first, add the option x-systemd.device-timeout=0 to
the corresponding fstab mount line; and second, add the line
Type=oneshot to the Service section of the truecrypt-service file in
order to prevent timeout there. Now you can take as long as you want to
enter the PW and the boot process will wait for you. For the second
issue, if you have problems mounting more than one device during startup
(e.g. with the two password prompts interfering) and/or want to avoid
entering multiple passwords, you could consider securing the second and
further devices by a keyfile located on the first encrypted device.

truecrypt (mount encrypted fs)
------------------------------

    /etc/systemd/system/multi-user.target/truecrypt-mount.service

    [Unit]
    Description=Mount Truecrypt-encrypted filesystems
    ConditionFileIsExecutable=/usr/bin/truecrypt
    #Requires=truecrypt-unmount.service
    #Before=mpd.service
     
    [Service]
    Type=oneshot
    ExecStart=/usr/bin/truecrypt -t /dev/sdXY /MOUNTPOINT
    StandardInput=tty-force
    RemainAfterExit=yes
     
    [Install]
    WantedBy=multi-user.target
    #Also=truecrypt-unmount.service

Note:Gleaned from bpont on the forums. If you use mpd and have your
music dir in ~, uncomment Before=mpd.service, which takes care that mpd
is started after this script. If you also use truecrypt-unmount.service
(see next service) uncomment the Requires=truecrypt-unmount.service and
Also=truecrypt-unmount.service so it gets installed and activated by
systemd automatically when using this script.

truecrypt (unmount encrypted fs)
--------------------------------

    /etc/systemd/system/multi-user/truecrypt-unmount.service

    [Unit]
    Description=Truecrypt unmount on shutdown, poweroff, reboot, system halt
    Before=local-fs-pre.target
    #Before=mpd.service
    ConditionPathExistsGlob=/media/truecrypt*
    DefaultDependencies=no

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/truecrypt -d
    TimeoutSec=5
    StandardInput=tty

    [Install]
    WantedBy=shutdown.target reboot.target halt.target poweroff.target

Note:I don't know if this works yet. It may be necessary to replace
TimeoutSec=5 with ExecStart=sleep 5. If you use mpd, make sure to
uncomment Before=mpd.service to make sure this service is executed after
mpd is closed down (different order during the shutdown of processes
than during start up!). Script gleaned from tladuke on the forums.

MPD Socket Activation
---------------------

If the following mpd.socket file is enabled while mpd.service (provided
by mpd) is disabled, systemd will not start mpd immediately, but it will
listen on the appropriate sockets. When an mpd client attempts to
connect on one of those sockets, systemd will start mpd.service and
transparently hand over control of those ports to the mpd process.

If you prefer to listen on different UNIX sockets or network ports (even
multiple sockets of each type), or if you prefer not to listen on
network ports at all, you should add/edit/remove the appropriate
"ListenStream=" lines in the [Socket] section of mpd.socket AND modify
the appropriate lines /etc/mpd.conf (see "man 5 mpd.conf" for more
details).

If you use different (even multiple) network or local sockets, or prefer
not to use network sockets at all, simply add, change, or remove lines
beginning with "ListenStream=" in the [Socket] section.

    /usr/lib/systemd/system/mpd.socket

    [Unit]
    Description=Music Player Daemon Sockets

    [Socket]
    ListenStream=/var/run/mpd/socket
    ListenStream=6600

    [Install]
    WantedBy=sockets.target

VideoLAN 2.0
------------

Change the User parameter.

    /etc/systemd/system/vlc.service

    [Unit]
    Description=VideoOnLAN Service
    After=network.target

    [Service]
    Type=forking
    User=nobody
    ExecStart=/usr/bin/cvlc --intf=lua --lua-intf=http --daemon --http-port 8090
    Restart=on-abort

    [Install]
    WantedBy=multi-user.target

Xvfb
----

Change the User/Group parameters.

    /etc/systemd/system/xinit.service

    [Unit]
    Description=xinit with xvfb
    After=network.target

    [Service]
    User=bitlbee
    Group=bitlbee
    ExecStart=/usr/bin/xvfb-run bash %h/.xinitrc

    [Install]
    WantedBy=multi-user.target

Nexus
-----

This is for Sonatype's Nexus OSS Artifact Repository. nexus is in the
AUR.

    /etc/systemd/system/nexus.service

    [Unit]
    Description=Nexus OSS Artifact Repository

    [Service]
    Type=forking
    EnvironmentFile=-/etc/conf.d/nexus
    ExecStart=/opt/nexus/bin/nexus start
    ExecStop=/opt/nexus/bin/nexus stop
    ExecReload=/opt/nexus/bin/nexus restart
    PIDFile=/opt/nexus/run/nexus.pid

    [Install]
    WantedBy=multi-user.target

Gitlab
------

    /etc/systemd/system/gitlab.service

    [Unit]
    Description=Self Hosted Git Management
    Requires=postgresql.service redis.service
    After=postgresql.service redis.service
    Wants=postfix.service gitlab-worker.service

    [Service]
    Type=forking
    User=gitlab
    WorkingDirectory=/home/gitlab/gitlab
    ExecStart=/home/gitlab/gitlab/script/rails server -d -e production
    PIDFile=/home/gitlab/gitlab/tmp/pids/server.pid

    [Install]
    WantedBy=multi-user.target

    /etc/systemd/system/gitlab-worker.service

    [Unit]
    Description=Gitlab Resque Worker
    Requires=redis.service
    After=redis.service
    Wants=postfix.service postgresql.service

    [Service]
    Type=forking
    User=gitlab
    WorkingDirectory=/home/gitlab/gitlab
    ExecStart=/bin/bash -c '. ~/.bashrc; . ./resque.sh'
    ExecStopPost=/usr/bin/rm /home/gitlab/gitlab/tmp/pids/resque_worker.pid
    PIDFile=/home/gitlab/gitlab/tmp/pids/resque_worker.pid

Cisco AnyConnect VPN
--------------------

    /etc/systemd/system/ciscovpn.service

    [Unit]
    Description=Cisco AnyConnect Secure Mobility Client Agent
    Requires=network.target remote-fs.target
    After=network.target remote-fs.target

    [Service]
    Type=forking
    PIDFile=/var/run/vpnagentd.pid
    ExecStart=/opt/cisco/anyconnect/bin/vpnagentd
    ExecStop=/usr/bin/killall /opt/cisco/anyconnect/bin/vpnagentd
    Restart=on-abort

    [Install]
    # one may want to use multi-user.target instead
    WantedBy=graphical.target

Emacs Daemon
------------

    /etc/systemd/system/emacs@.service

    [Unit]
    Description=Emacs: the extensible, self-documenting text editor

    [Service]
    Type=forking
    ExecStart=/usr/bin/emacs --daemon --chdir %h
    ExecStop=/usr/bin/emacsclient --eval "(progn (setq kill-emacs-hook 'nil) (kill-emacs))"
    Restart=always
    User=%i

    [Install]
    WantedBy=multi-user.target

Then, to enable the unit for your user:

    # systemctl enable emacs@<username>
    # systemctl start emacs@<username>

Source: EmacsWiki.

Monkey http server deamon
-------------------------

    /etc/systemd/system/monkey.service

    [Unit]
    Description=Monkey http server deamon
    After=network.target

    [Service]
    Type=forking
    ExecStart=/YOUR/PATH/TO/monkey/bin/monkey -D
    ExecStop=/bin/kill $MAINPID
    ExecReload=/bin/kill $MAINPID ; /YOUR/PATH/TO/monkey/bin/monkey -D
    PIDFile=/YOUR/PATH/TO/monkey/monkey.pid.80

    [Install]
    WantedBy=multi-user.target

Note:Replace /YOUR/PATH/TO entries with the path to monkey on your
system

Note:PIDFile= entry should point to pidfile location specified in your
monkey config file. The configured port number should be appended to the
filename

Note:Gist available at: github.

VirtualBox virtual machines
---------------------------

    /etc/systemd/system/vboxvmservice@.service

    [Unit]
    Description=VBox Virtual Machine %i Service
    Requires=systemd-modules-load.service
    After=systemd-modules-load.service

    [Service]
    User=user
    Group=vboxusers
    ExecStart=/usr/bin/VBoxHeadless -s %i
    ExecStop=/usr/bin/VBoxManage controlvm %i savestate

    [Install]
    WantedBy=multi-user.target

Note:Each virtual machine has its own service. Replace user with a user
that is a member of the vboxusers group.

systemctl enable vboxvmservice@<vm name>.service

systemctl start vboxvmservice@<vm name>.service

Note:As of VirtualBox 4.2 there is another way to get virtual machines
going:
http://lifeofageekadmin.com/how-to-set-your-virtualbox-vm-to-automatically-startup/
Please edit the VirtualBox page if you figure it out.

redmine
-------

    /etc/systemd/system/redmine.service

    [Unit]
    Description=Redmine server
    After=syslog.target
    After=network.target

    [Service]
    Type=simple
    User=redmine2
    Group=redmine2
    Environment=GEM_HOME=/home/redmine2/.gem/
    ExecStart=/usr/bin/ruby /usr/share/webapps/redmine/script/rails server webrick -e production

    # Give a reasonable amount of time for the server to start up/shut down
    TimeoutSec=300

    [Install]
    WantedBy=multi-user.target

See also
--------

-   Backing up Local Pacman database with Systemd
-   systemd
-   systemd at gentoo wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd/Services&oldid=253015"

Categories:

-   Daemons and system services
-   Boot process
