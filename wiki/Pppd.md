pppd
====

ppp (Paul's PPP Package) is an open source package which implements the
point-to-point protocol (PPP) on Linux and Solaris systems. It is
implemented as single pppd daemon and acts as backend for xl2tpd, pptpd
and netctl. 3G, L2TP and PPPoE connections are internally based on PPP
protocol and therefore can be managed by ppp.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 PPPoE
    -   2.2 Starting pppd with Arch
-   3 Tips and tricks
    -   3.1 Do an auto redial
    -   3.2 ISP auto-disconnect after 24h
    -   3.3 ISP auto-disconnect after 24h using a Systemd timer
-   4 Troubleshooting
    -   4.1 Default route
    -   4.2 Masquerading seems to be working fine but some sites don't
        work.
    -   4.3 pppd cannot load kernel module ppp_generic

Installation
------------

Install ppp, available in the official repositories.

Make sure that your kernel is compiled with PPPoE support (present in
default kernel):

    $ zgrep CONFIG_PPPOE /proc/config.gz

    CONFIG_PPPOE=m

Configuration
-------------

> PPPoE

Create the connection configuration file:

    /etc/ppp/peers/your_provider

    plugin rp-pppoe.so
    # rp_pppoe_ac 'your ac name'
    # rp_pppoe_service 'your service name'
      
    # network interface
    eth0
    # login name
    name "someloginname"
    usepeerdns
    persist
    # Uncomment this if you want to enable dial on demand
    #demand
    #idle 180
    defaultroute
    hide-password
    noauth

If you want usepeerdns to work, you have to edit your /etc/ppp/ip-up and
add a command that copies /etc/ppp/resolv.conf to /etc/resolv.conf.

Edit /etc/ppp/pap-secrets:

Put a line like this in /etc/ppp/pap-secrets or /etc/ppp/chap-secrets as
required by the authentication method used by your ISP. It's OK to write
these two files at the same time, pppd will automatically use the
appropriate one.

    someloginname * yourpassword

You can now start the link using the command

    # pppd call your_provider

Alternatively, you can use this

    # pon your_provider

To see whether your pppoe connection is started correctly, check
/var/log/errors.log first and then check /var/log/everything.log. On a
successful connection, you should see something like the following in
the everything.log:

    # tail /var/log/everything.log 

    Aug  9 00:18:08 localhost pppd[2268]: Using interface ppp0
    Aug  9 00:18:08 localhost pppd[2268]: Connect: ppp0 <--> eth0
    Aug  9 00:18:11 localhost pppd[2268]: CHAP authentication succeeded
    Aug  9 00:18:11 localhost pppd[2268]: CHAP authentication succeeded
    Aug  9 00:18:11 localhost pppd[2268]: peer from calling number 00:06:29:AF:4F:E0 authorized
    Aug  9 00:18:11 localhost pppd[2268]: Cannot determine ethernet address for proxy ARP
    Aug  9 00:18:11 localhost pppd[2268]: local  IP address 10.6.2.137
    Aug  9 00:18:11 localhost pppd[2268]: remote IP address 10.6.1.1
    Aug  9 00:18:11 localhost pppd[2268]: primary   DNS address 10.6.1.1
    Aug  9 00:18:11 localhost pppd[2268]: secondary DNS address 210.21.196.6

By default the configuration in /etc/ppp/peers/provider is treated as
the default, so if you want to make "your_provider" the default, you can
create a link like this

    # ln -s /etc/ppp/peers/your_provider /etc/ppp/peers/provider

Now you can start the link by simply running

    # pon

To close a connection, use this

    # poff your_provider

> Starting pppd with Arch

-   Configure the ppp_generic module to load on boot. See Kernel
    Modules#Loading for more information.
-   Configure to autostart on boot the service
    ppp@your_provider.service, where your_provider is your configuration
    file. See Daemons for more information.

Tips and tricks
---------------

> Do an auto redial

If pppd is running, you can force a connection reset by sending the
SIGHUP signal to the process

    # export PPPD_PID=$(pidof pppd)
    # kill -s HUP $PPPD_PID 

And you have redialed the connection.

Make sure you have persist option enabled in your
/etc/ppp/peers/provider tab. Additionally you might want to set
holdoff 0 to reconnect without waiting.

> ISP auto-disconnect after 24h

Note:If you aren't running your computer always on (running 24/7) then
you can skip this step.

If you use a flat-rate always-on connection on a computer, some
providers restart your connection after 24h. That makes sure that the IP
is rotated every 24h. To compensate, you can use an dynamic DNS service
in combination with inadyn (available on AUR) to compensate for the
rotating IP address. But to avoid disconnects when you don't need it,
you might try to restart the connection using a cron job at a time of
day you know no one will be using the connection (ex. 4 AM).

As root, do the following:

Create a bash script similar to this and give it a name (ex
pppd_redial.sh):

    #!/bin/bash

    message="Restarting the PPP connection @:" $(date)
    pppd_id=$(pidof pppd)

    kill -s HUP $pppd_id
    echo $message

Give it execute permissions and put it on a path visible to root.

Then create a cron job using crontab -e. Check that your EDITOR env
variable is set if the command fails. So add anywhere in the file,

    0 4 * * * /bin/bash /root/pppd_redial.sh

Confirm that crond is up and running. If it isn't just enable it with,

    # systemctl enable cronie.service
    # systemctl start cronie.service

Save and exit. Your PPPoE connection will now restart every day at 4AM.

> ISP auto-disconnect after 24h using a Systemd timer

An alternative way to force a reconnect is using a Systemd timer and the
poff script (in particular its -r option). Simply create a .service and
.timer file with the same name:

    ppp-redial.timer

    [Unit]
    Description=Reconnect PPP connections daily

    [Timer]
    OnCalendar=*-*-* 05:00:00

    [Install]
    WantedBy=multi-user.target

    ppp-redial.service

    [Unit]
    Description=Reconnect PPP connections

    [Service]
    Type=simple
    ExecStart=/usr/bin/poff -r

Now just enable and start the timer and Systemd will cause a restart at
the specified time.

Troubleshooting
---------------

> Default route

If you have a preconfigured default route before the pppd is started,
the default route is kept, so take a look in /var/log/errors.log and if
you have something like:

    pppd[nnnn]: not replacing existing default route via xx.xx.xx.xx

and xx.xx.xx.xx is not the correct route for you

-   Create a new script /etc/ppp/ip-pre-up

    $ chmod +x /etc/ppp/ip-pre-up

with this content:

    #!/bin/sh
    /usr/bin/route del default

-   Restart your pppd service.

> Masquerading seems to be working fine but some sites don't work.

The MTU under pppoe is 1492 bytes. Most sites use an MTU of 1500. So
your connection sends an ICMP 3:4 (fragmentation needed) packet, asking
for a smaller MTU, but some sites have their firewall blocking that.

Using PMTU clamping can solve that:

    iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

Now, for some reason, just trying to save the resulting iptables
configuration with iptables-save and restoring it later, does not work.
It has to be executed after the other iptables configuration had been
loaded. So, here is a systemd unit to solve it:

    pmtu-clamping.service

    [Unit]
    Description=PMTU clamping for pppoe
    Requires=iptables.service
    After=iptables.service

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

    [Install]
    WantedBy=multi-user.target

> pppd cannot load kernel module ppp_generic

Symptom: When starting PPTP Client, the pppd process cannot locate the
appropriate module.

     Couldn't open the /dev/ppp device: No such device or address
     Please load the ppp_generic kernel module.

Solution: Edit the /etc/modprobe.d/modules.conf file and change

     alias char-major-108 ppp 

to

     alias char-major-108 ppp_generic

If there is no alias included add

     alias char-major-108 ppp_generic

and reboot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pppd&oldid=289836"

Category:

-   Networking

-   This page was last modified on 22 December 2013, at 01:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
