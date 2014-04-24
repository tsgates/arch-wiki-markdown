systemd/Services
================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Please don't add 
                           any new elements to this 
                           page. All services       
                           must/will be relocated   
                           on their dedicated       
                           corresponding main       
                           article. (Discuss)       
  ------------------------ ------------------------ ------------------------

Related articles

-   systemd
-   systemd/User
-   systemd FAQ
-   Daemons List

This page is useful to publish systemd service files that are missing in
the appropriate package in the official repositories or the AUR. These
files can be copied from other distributions or created by yourself.

Contents
--------

-   1 darkhttpd
-   2 screen
-   3 Static Ethernet network
-   4 Set network interface in promiscuous mode
-   5 tpfand
-   6 MPD socket activation
-   7 VideoLAN 2.0
-   8 Xvfb
-   9 Gitlab
-   10 Cisco AnyConnect VPN
-   11 redmine
-   12 Turn off the automatic screensaver
-   13 slock
-   14 xautolock
-   15 VDE2 interface
-   16 BitTorrent Sync
-   17 Crashplan PROe server
-   18 ncdc
-   19 XBMC Socket Activation
-   20 Squeezelite
-   21 freeswitch
-   22 See also

darkhttpd
---------

    /etc/systemd/system/darkhttpd.service

    [Unit]
    Description=Darkhttpd Webserver

    [Service]
    EnvironmentFile=/etc/conf.d/darkhttpd
    ExecStart=/usr/sbin/darkhttpd $DARKHTTPD_ROOT --daemon $DARKHTTPD_OPTS
    Type=forking

    [Install]
    WantedBy=multi-user.target

    /etc/systemd/system/darkhttpd.socket

    [Unit]
    Conflicts=darkhttpd.service

    [Socket]
    ListenStream=80
    Accept=no

    [Install]
    WantedBy=sockets.target

    /etc/conf.d/darkhttpd

    DARKHTTPD_ROOT="/srv/http"
    DARKHTTPD_OPTS="--uid nobody --gid nobody --chroot"

screen
------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with GNU Screen. 
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Autostarts screen for the specified user (e.g.
systemctl enable screen@florian).

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

    address=192.168.0.15
    netmask=24
    broadcast=192.168.0.255
    gateway=192.168.0.1

    /etc/systemd/system/network.service

    [Unit]
    Description=Network Connectivity for <interface>
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-<interface>.device 
    After=sys-subsystem-net-devices-<interface>.device 

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/etc/conf.d/network
    ExecStart=/usr/bin/ip link set dev <interface> up
    ExecStart=/usr/bin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev <interface>
    ExecStart=/usr/bin/ip route add default via ${gateway}
    ExecStop=/usr/bin/ip addr flush dev <interface>
    ExecStop=/usr/bin/ip link set dev <interface> down
    Execstop=/sbin/ip addr delete ${address}/${netmask} dev <interface>
    [Install]
    WantedBy=multi-user.target

To set static IP on enp3s0 interface you will need to create
/etc/conf.d/network@enp3s0 config file and run:

     # systemctl enable network@enp3s0.service

Set network interface in promiscuous mode
-----------------------------------------

    /etc/systemd/system/promiscuous@.service

    [Unit]
    Description=Set %i interface in promiscuous mode
    After=network.target

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/ip link set dev %i promisc on
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

If you want to enable promiscuous mode on interface eth0 run:

    # systemctl enable promiscuous@eth0.service

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

MPD socket activation
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with MPD.        
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If the following mpd.socket file is enabled while mpd.service (provided
by mpd) is disabled, systemd will not start mpd immediately, but it will
listen on the appropriate sockets. When an mpd client attempts to
connect on one of those sockets, systemd will start mpd.service and
transparently hand over control of those ports to the mpd process.

If you prefer to listen on different UNIX sockets or network ports (even
multiple sockets of each type), or if you prefer not to listen on
network ports at all, you should add/edit/remove the appropriate
"ListenStream=" lines in the [Socket] section of mpd.socket AND modify
the appropriate lines /etc/mpd.conf (see man 5 mpd.conf for more
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

Change the User= parameter.

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

Change the User= and Group= parameters:

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

Turn off the automatic screensaver
----------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Very hackish      
                           solution, you'd better   
                           use something like this  
                           (needs to be modified to 
                           work with XBMC).         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Arch Linux has a 10 minute screensaver set as standard. XBMC for CuBox
does not disable this when watching movies, and this is a rather hackish
workaround. Tested on the CuBox.

    /etc/systemd/system/screensaveroff.service

    [Unit]
    Description=Disables the screensaver in X
    After=graphical.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/bin/xset s off -d :0

    [Install]
    WantedBy=graphical.target

slock
-----

Locks the system with the help of slock. Very handy when closing the
laptop lid for example.

    /etc/systemd/system/screenlock.service

    [Unit]
    Description=Lock X session using slock
    Before=sleep.target
     
    [Service]
    User=<username>
    Environment=DISPLAY=:0
    ExecStart=/usr/bin/slock
     
    [Install]
    WantedBy=sleep.target

xautolock
---------

Automatically lock the screen after a timeout of 10 minutes.

    /etc/systemd/system/xautolock.service

    [Unit]
    Description=Lock the screen automatically after a timeout
     
    [Service]
    Type=simple
    User=<username>
    Environment=DISPLAY=:0
    ExecStart=/usr/bin/xautolock -time 10 -locker slock -detectsleep
     
    [Install]
    WantedBy=graphical.target

VDE2 interface
--------------

Create and activate a vde2 tap interface for use in the users user
group.

    /etc/systemd/system/vde2@.service

    [Unit]
    Description=Network Connectivity for %i
    Wants=network.target
    Before=network.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/bin/vde_switch -tap %i -daemon -mod 660 -group users
    ExecStart=/usr/bin/ip link set dev %i up
    ExecStop=/usr/bin/ip addr flush dev %i
    ExecStop=/usr/bin/ip link set dev %i down

    [Install]
    WantedBy=multi-user.target

BitTorrent Sync
---------------

Run BitTorrent Sync as user username:

    # systemctl start btsync@''username''

    /etc/systemd/system/btsync@.service

    [Unit]
    Description=BitTorrent Sync application

    [Service]
    Type=forking
    User=%i
    ExecStart=/usr/bin/btsync --config %h/.config/btsync/btsync.config
    PIDFile=%h/.config/btsync/btsync.pid

    [Install]
    WantedBy=multi-user.target

This assumes existence of the following files:

-   /usr/bin/btsync - the btsync executable or a symlink pointing to it.
-   /home/username/.config/btsync/btsync.config - the user's config
    file. Consult the official instructions for creating one.
-   /home/username/.config/btsync/btsync.pid - BitTorrent Sync creates
    $SYNC_HOME/sync.pid automatically, where $SYNC_HOME is specified by
    "storage_path" in the config file. Either point PIDFile to it, or
    symlink this file to it.

Crashplan PROe server
---------------------

    /etc/systemd/system/proserver.service

    [Unit]
    Description=CrashPlanPROe Backup Server
    After=network.target

    [Service]

    Type=forking

    ExecStart=/opt/proserver/bin/proserver start
    ExecStop=/opt/proserver/bin/proserver stop

    [Install]
    WantedBy=multi-user.target

ncdc
----

    /etc/systemd/system/ncdc@.service

    [Unit]
    Description=ncdc
    Requires=network.target local-fs.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    KillMode=none
    User=%I
    ExecStart=/usr/bin/tmux new-session -s dcpp -n ncdc -d ncdc
    ExecStop=/usr/bin/tmux send-keys -t dcpp:ncdc "/quit" C-m

    [Install]
    WantedBy=multi-user.target

XBMC Socket Activation
----------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with XBMC.       
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This can be used to start XBMC automatically when you start a remote
control app or connect to its html control port. Start listening with
systemctl start xbmc@user.socket (replace user with the user you want
XBMC to be started as). You might have to change the port in
xbmc@.socket.

    /etc/systemd/system/xbmc@.service

    [Unit]
    Description=Launch XBMC on main display

    [Service]
    Type=oneshot
    Environment=DISPLAY=:0.0
    Nice=-1
    ExecStart=/usr/bin/su %i /usr/bin/xbmc
    ExecStartPost=/usr/bin/bash -c "sleep 15 && systemctl start xbmc@%i.socket"

    [Install]
    WantedBy=multi-user.target

    /etc/systemd/system/xbmc@.socket

    [Unit]
    Conflicts=xbmc@%i.service

    [Socket]
    #ListenDatagram=9        # listen for WOL packets
    ListenStream=8082        # change this to XBMC's http control port

    [Install]
    WantedBy=sockets.target

Squeezelite
-----------

    /etc/conf.d/squeezelite

    server="<server>:<port>"   # amend as appropriate
    name="<device_name>"       # amend as appropriate
    mac="<your_mac_here>"      # amend as appropriate
    device="default"           # amend as appropriate
    logtype="all"
    loglevel="info"
    logfile="/var/log/squeezelite.log"

    /etc/systemd/system/squeezelite.service

    [Unit]
    Description=Squeezelite Service
    After=network.target

    [Service]
    Type=simple
    EnvironmentFile=/etc/conf.d/squeezelite
    ExecStart=/usr/bin/squeezelite -n ${name} -m ${mac} -d ${logtype}=${loglevel} -f ${logfile} -o ${device} -s ${server}
    RestartSec=5
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target

freeswitch
----------

    /etc/systemd/system/freeswitch.service

    [Unit]
    Description=freeswitch
    After=syslog.target network.target local-fs.target

    [Service]
    Type=forking
    PIDFile=/run/freeswitch/freeswitch.pid
    EnvironmentFile=/etc/conf.d/freeswitch
    PermissionsStartOnly=true
    ExecStartPre=/bin/mkdir -p /run/freeswitch
    ExecStartPre=/bin/chown freeswitch:freeswitch /run/freeswitch
    ExecStart=/usr/bin/freeswitch $FREESWITCH_OPTS
    TimeoutSec=45s
    Restart=always
    User=freeswitch
    Group=freeswitch
    UMask=0007

    [Install]
    WantedBy=multi-user.target

    /etc/conf.d/freeswitch

    # options to start freeswitch with
    # We default to -nonat, if you need nat, remove it
    FREESWITCH_OPTS="-nc"

See also
--------

-   Backing up local pacman database with systemd
-   systemd at gentoo wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd/Services&oldid=297412"

Categories:

-   Daemons and system services
-   Boot process

-   This page was last modified on 14 February 2014, at 08:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
