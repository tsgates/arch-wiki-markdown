Tor
===

Related articles

-   Gnunet
-   I2P
-   Freenet

Tor is an open source implementation of 2nd generation onion routing
that provides free access to an anonymous proxy network. Its primary
goal is to enable online anonymity by protecting against traffic
analysis attacks.

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Configuration
-   4 Running Tor in a Chroot
-   5 Usage
-   6 Web browsing
    -   6.1 Firefox
    -   6.2 Chromium
    -   6.3 Luakit
-   7 HTTP proxy
    -   7.1 Firefox
    -   7.2 Polipo
    -   7.3 Privoxy
-   8 Instant messaging
    -   8.1 Pidgin
-   9 Irssi
-   10 Pacman
-   11 Running a Tor server
    -   11.1 Running a Tor bridge
        -   11.1.1 Configuration
        -   11.1.2 Troubleshooting
    -   11.2 Running a "Middleman" relay
        -   11.2.1 Configuration
    -   11.3 Running a Tor exit node
        -   11.3.1 Configuration
-   12 TorDNS
    -   12.1 Using TorDNS for all DNS queries
-   13 Torify
-   14 Transparent Torification
-   15 Troubleshooting
    -   15.1 Problem with user value
    -   15.2 Daemon fails on restart
-   16 See also

Introduction
------------

Users of the Tor network run an onion proxy on their machine. This
software connects out to Tor, periodically negotiating a virtual circuit
through the Tor network. Tor employs cryptography in a layered manner
(hence the 'onion' analogy), ensuring perfect forward secrecy between
routers. At the same time, the onion proxy software presents a SOCKS
interface to its clients. SOCKS-aware applications may be pointed at
Tor, which then multiplexes the traffic through a Tor virtual circuit.

Warning:Tor by itself is not all you need to maintain your anonymity.
There are several major pitfalls to watch out for (see: Want Tor to
really work?).

Through this process the onion proxy manages networking traffic for
end-user anonymity. It keeps a user anonymous by encrypting traffic,
sending it through other nodes of the Tor network, and decrypting it at
the last node to receive your traffic before forwarding it to the server
you specified. One trade off that has to be made for the anonymity Tor
provides is that it can be considerably slower than a regular direct
connection, due to the large amount of traffic re-routing. Additionally,
although Tor provides protection against traffic analysis it cannot
prevent traffic confirmation at the boundaries of the Tor network (i.e.
the traffic entering and exiting the network).

See the Wikipedia article on this subject for more information: Tor
(anonymity network)

Installation
------------

Install tor, available in the official repositories.

Additionally, there is a Qt frontend for Tor in package vidalia. In
addition to controlling the Tor process, Vidalia allows you to view and
configure the status of Tor, monitor bandwidth usage, and view, filter,
and search log messages.

Configuration
-------------

To get a better understanding of Tor review the /etc/tor/torrc
configuration file. The configuration options are explained in man tor
and the Tor website. The default configuration should work fine for most
Tor users.

You can set custom file descriptor ulimits for Tor in /etc/conf.d/tor
using the TOR_MAX_FD variable. This sets a limit on the maximum number
of open files.

By default Tor logs to stdout with a log-level of "notice". If system
logging is enabled in the torrc configuration file, it will default to
/usr/local/var/log/tor/.

The "RunAsDaemon" setting conflicts with the default runtype of "simple"
in the service file. You should not need to enable it. systemd handles
the daemonization of tor. If you do enable it for whatever reason, you
will need to override the service file to change the runtype to
"Type=forking" so systemd allows tor to fork itself.

Running Tor in a Chroot
-----------------------

For security purposes, it may be desirable to run Tor in a chroot. The
following script will create an appropriate chroot in /opt/torchroot:

    ~/torchroot-setup.sh

    #!/bin/bash
    export TORCHROOT=/opt/torchroot

    mkdir -p $TORCHROOT
    mkdir -p $TORCHROOT/etc/tor
    mkdir -p $TORCHROOT/dev
    mkdir -p $TORCHROOT/usr/bin
    mkdir -p $TORCHROOT/usr/lib
    mkdir -p $TORCHROOT/usr/share/tor
    mkdir -p $TORCHROOT/var/lib

    ln -s /usr/lib  $TORCHROOT/lib
    cp /etc/hosts           $TORCHROOT/etc/
    cp /etc/host.conf       $TORCHROOT/etc/
    cp /etc/localtime       $TORCHROOT/etc/
    cp /etc/nsswitch.conf   $TORCHROOT/etc/
    cp /etc/resolv.conf     $TORCHROOT/etc/
    cp /etc/tor/torrc       $TORCHROOT/etc/tor/

    cp /usr/bin/tor         $TORCHROOT/usr/bin/
    cp /usr/share/tor/geoip* $TORCHROOT/usr/share/tor/
    cp /lib/libnss* /lib/libnsl* /lib/ld-linux.so* /lib/libresolv* /lib/libgcc_s.so* $TORCHROOT/usr/lib/
    cp $(ldd /usr/bin/tor | awk '{print $3}'|grep --color=never "^/") $TORCHROOT/usr/lib/
    cp -r /var/lib/tor      $TORCHROOT/var/lib/
    chown -R tor:tor $TORCHROOT/var/lib/tor

    sh -c "grep --color=never ^tor /etc/passwd > $TORCHROOT/etc/passwd"
    sh -c "grep --color=never ^tor /etc/group > $TORCHROOT/etc/group"

    mknod -m 644 $TORCHROOT/dev/random c 1 8
    mknod -m 644 $TORCHROOT/dev/urandom c 1 9
    mknod -m 666 $TORCHROOT/dev/null c 1 3

    if [[ "$(uname -m)" == "x86_64" ]]; then
      cp /usr/lib/ld-linux-x86-64.so* $TORCHROOT/usr/lib/.
      ln -sr /usr/lib64 $TORCHROOT/lib64
      ln -s $TORCHROOT/usr/lib ${TORCHROOT}/usr/lib64
    fi

After running the script as root, Tor can be launched in the chroot with
the command: # chroot --userspec=tor:tor /opt/torchroot /usr/bin/tor

Usage
-----

Start/enable tor.service using systemd.

Alternatively, you can launch it from the vidalia interface.

To use a program over tor, configure it to use 127.0.0.1 or localhost as
a SOCKS5 proxy, with port 9050 (plain tor with standard settings) or
port 9051 (configuration with vidalia, standard settings). To check if
Tor is functioning properly visit the Tor, Harvard or Xenobite.eu
websites.

Web browsing
------------

The Tor Project currently only supports web browsing with tor through
the Tor Browser Bundle, which can be downloaded from the AUR. It is
built with a patched version of the Firefox extended support releases.
Tor can also be used with regular Firefox, Chromium and other browsers,
but this is not recommended by the Tor Project.

Tip:For makepkg to verify the signature on the AUR source tarball
download for TBB, signing keys from the Tor Project (currently
0x63FEE659) must be downloaded from the keyservers and added to the user
gpg keyring with:

    $ gpg --recv-keys 0x63FEE659

> Firefox

In Preferences > Advanced > Network tab > Settings manually set Firefox
to use the SOCKS proxy localhost with port 9050. Then you must type
about:config into the address bar and void your warranty. Change
network.proxy.socks_remote_dns to true and restart the browser. This
channels all DNS requests through TOR's socks proxy.

> Chromium

You can simply run:

    $ chromium --proxy-server="socks://localhost:9050"

Just as with Firefox, you can setup a fast switch for example through
Proxy SwitchySharp.

Once installed enter in its configuration page. Under the tab Proxy
Profiles add a new profile Tor, if ticked untick the option Use the same
proxy server for all protocols, then add localhost as SOCKS Host, 9050
to the respective port and select SOCKS v5.

Optionally you can enable the quick switch under the General tab to be
able to switch beetween normal navigation and Tor network just by
left-clicking on the Proxy SwitchySharp's icon.

> Luakit

You can simply run:

    $ torify luakit

HTTP proxy
----------

Tor can be used with an HTTP proxy like Polipo or Privoxy, however the
Tor dev team recommends using the SOCKS5 library since browsers directly
support it.

> Firefox

The FoxyProxy add-on allows you to specify multiple proxies for
different URLs or for all your browsing. After restarting Firefox
manually set Firefox to port 8118 on localhost, which is where Polipo or
Privoxy are running. These settings can be access under Add > Standard
proxy type. Select a proxy label (e.g Tor) and enter the port and host
into the HTTP Proxy and SSL Proxy fields. To check if Tor is functioning
properly visit the Tor Check website and toggle Tor.

> Polipo

The Tor Project has created a custom Polipo configuration file to
prevent potential problems with Polipo as well to provide better
anonymity.

Keep in mind that Polipo is not required if you can use a SOCKS 5 proxy,
which Tor starts automatically on port 9050. If you want to use Chromium
with Tor, you do not need the Polipo package (see: #Chromium).

> Privoxy

You can also use this setup in other applications like messaging (e.g.
Jabber, IRC). Applications that support HTTP proxies you can connect to
Privoxy (i.e. 127.0.0.1:8118). To use SOCKS proxy directly, you can
point your application at Tor (i.e. 127.0.0.1:9050). A problem with this
method though is that applications doing DNS resolves by themselves may
leak information. Consider using Socks4A (e.g. with Privoxy) instead.

Instant messaging
-----------------

In order to use an IM client with tor, we do not need an http proxy like
polipo/privoxy. We will be using tor's daemon directly which listens to
port 9050 by default.

> Pidgin

You can set up Pidgin to use Tor globally, or per account. To use Tor
globally, go to Tools -> Preferences -> Proxy. To use Tor for specific
accounts, go to Accounts > Manage Accounts, select the desired account,
click Modify, then go to the Proxy tab. The proxy settings are as
follows:

    Proxy type 	SOCKS5
    Host 	        127.0.0.1
    Port 	        9150

Note that some time in 2013 the Port has changed from 9050 to 9150 if
you use the Tor Browser Bundle. Try the other value if you receive a
"Connection refused" message.

Irssi
-----

Freenode does not recommend that you use Privoxy with Irssi. Instead
they recommend using the mapaddress approach and running torify irssi to
start it up. Therefore, add the following to /etc/tor/torrc:

    mapaddress  10.40.40.40 p4fsi4ockecnea7l.onion

Freenode requires charybdis and ircd-seven's SASL mechanism for
identifying to nickserv during connection. Download cap_sasl.pl, which
enables SASL in Irssi, from the Freenode website (i.e.
http://www.freenode.net/sasl/cap_sasl.pl) and save it to
~/.irssi/scripts/cap_sasl.pl

Then install perl-crypt-openssl-bignum, perl-crypt-blowfish and then
perl-crypt-dh from the AUR.

Alternatively, you can install the modules using perl:

    $ perl -MCPAN -e 'install Crypt::OpenSSL::Bignum Crypt::DH Crypt::Blowfish'

Start irssi

    $ torify irssi

Load the script that will employ the SASL mechanism.

    /script load cap_sasl.pl

Set your identification to nickserv, which will be read when connecting.
Supported mechanisms are PLAIN and DH-BLOWFISH.

    /sasl set network username password mechanism

Connect to Freenode:

    /connect -network network 10.40.40.40

For more information check Accessing freenode Via Tor and the SASL
README at freenode.net or the IRC/SILC Wiki article at torproject.org.

If you are receiving errors check the Cannot Connect to Freenode IRC
using Irssi & Tor thread on the Arch Linux forums.

Pacman
------

Pacman download operations (repository DBs, packages, and public keys)
can be done using the Tor network. Though relatively extreme, this
measure is useful to prevent an adversary (most likely at one's LAN or
the mirror) from knowing a subset of the packages you have installed, at
the cost of longer latency, lower throughput, possible suspicion, and
possible failure (if Tor is being filtered via the current connection).

Warning:It would be arguably simpler for an adversary, specifically one
who desires to indiscriminately disseminate malware, to perform his/her
activity by deploying malicious Tor exit node(s). Always use signed
packages and verify new public keys by out-of-band means.

    /etc/pacman.conf

    ...
    XferCommand = /usr/bin/curl --socks5-hostname localhost:9050 -C - -f %u > %o
    ...

Running a Tor server
--------------------

The Tor network is reliant on people contributing bandwidth. There are
several ways to contribute to the network.

> Running a Tor bridge

This involves making your machine an 'entry node' for people who are
having trouble connecting to Tor through traditional methods.

Configuration

According to https://www.torproject.org/docs/bridges , make your torrc
be just these four lines:

       SocksPort 0
       ORPort 443
       BridgeRelay 1
       Exitpolicy reject *:*

Troubleshooting

If you get "Could not bind to 0.0.0.0:443: Permission denied" errors on
startup, you will need to pick a higher ORPort (e.g. 8080), or perhaps
forward the port in your router.

> Running a "Middleman" relay

This means that your machine will contribute bandwidth to the 'internal'
part of the network, acting as neither an entry nor exit point, merely
forwarding bits to and from other Tor nodes/relays.

Configuration

You should at least share 20KiB/s:

    Nickname tornickname
    ORPort 9001
    BandwidthRate 20 KB            # Throttle traffic to 20KB/s
    BandwidthBurst 50 KB           # But allow bursts up to 50KB/s

Run Tor as middleman ( a relay):

    ExitPolicy reject *:*

> Running a Tor exit node

Any requests from a Tor user to the regular internet obviously need to
exit the network somewhere, and exit nodes provide this vital service.
To the accessed host, the request will appear as having originated from
your machine. This means that running an exit node is generally
considered more legally onerous than running other forms of Tor relays.
Before becoming an exit relay, you may want to read Tips for Running an
Exit Node With Minimal Harrasment.

Configuration

Using the torrc, you can configure which services you wish to allow
through your exit node. Allow all traffic:

    ExitPolicy accept	*:*

Allow only irc ports 6660-6667 to exit from node:

    ExitPolicy accept *:6660-6667,reject *:* # Allow irc ports but no more

By default, Tor will block certain ports. You can use the torrc to
overide this.

    ExitPolicy accept *:119        # Accept nntp as well as default exit policy

TorDNS
------

The Tor 0.2.x series provides a built-in DNS forwarder. To enable it add
the following lines to the Tor configuration file and restart the
daemon:

    /etc/tor/torrc

    DNSPort 9053
    AutomapHostsOnResolve 1
    AutomapHostsSuffixes .exit,.onion

This will allow Tor to accept DNS requests (listening on port 9053 in
this example) like a regular DNS server, and resolve the domain via the
Tor network. A downside is that it's only able to resolve DNS queries
for A-records; MX and NS queries are never answered. For more
information see this Debian-based introduction.

DNS queries can also be performed through a command line interface by
using tor-resolve. For example:

    $ tor-resolve archlinux.org
    66.211.214.131

> Using TorDNS for all DNS queries

It is possible to configure your system, if so desired, to use TorDNS
for all queries your system makes, regardless of whether or not you
eventually use Tor to connect to your final destination. To do this,
configure your system to use 127.0.0.1 as its DNS server and edit the
'DNSPort' line in /etc/tor/torrc to show:

    DNSPort 53

Alternatively, you can use a local caching DNS server, such as dnsmasq
or pdnsd, which will also compensate for TorDNS being a little slower
than traditional DNS servers. The following instructions will show how
to set up dnsmasq for this purpose.

Change the tor setting to listen for the DNS request in port 9053 and
install dnsmasq.

Modify its configuration file so that it contains:

    /etc/dnsmasq.conf

    no-resolv
    server=127.0.0.1#9053
    listen-address=127.0.0.1

These configurations set dnsmasq to listen only for requests from the
local computer, and to use TorDNS at its sole upstream provider. It is
now neccessary to edit /etc/resolv.conf so that your system will query
only the dnsmasq server.

    /etc/resolv.conf

    nameserver 127.0.0.1

Start the dnsmasq daemon.

Finally if you use dhcpd you would need to change its settings to that
it does not alter the resolv configuration file. Just add this line in
the configuration file:

    /etc/dhcpcd.conf

    nohook resolv.conf

If you already have an nohook line, just add resolv.conf separated with
a comma.

Torify
------

torify will allow you use an application via the Tor network without the
need to make configuration changes to the application involved. From the
man page:

torify is a simple wrapper that calls tsocks with a tor specific
configuration file. tsocks itself is a wrapper between the tsocks
library and the application that you would like to run socksified

Usage example:

    $ torify elinks checkip.dyndns.org
    $ torify wget -qO- https://check.torproject.org/ | grep -i congratulations

Torify will not, however, perform DNS lookups through the Tor network. A
workaround is to use it in conjunction with tor-resolve (described
above). In this case, the procedure for the first of the above examples
would look like this:

    $ tor-resolve checkip.dyndns.org

    208.78.69.70

    $ torify elinks 208.78.69.70

Transparent Torification
------------------------

In some cases it is more secure and often easier to transparently torify
an entire system instead of configuring individual applications to use
Tor's socks port, not to mention preventing DNS leaks. Transparent
torification can be done with iptables in such a way that all outbound
packets are redirected through Tor's TransPort, except the Tor traffic
itself. Once in place, applications do not need to be configured to use
Tor, though Tor's SocksPort will still work. This also works for DNS via
Tor's DNSPort, but realize that Tor only supports TCP, thus UDP packets
other than DNS cannot be sent through Tor and therefore must be blocked
entirely to prevent leaks. Using iptables to transparently torify a
system affords comparatively strong leak protection, but it is not a
substitute for virtualized torification applications such as Whonix, or
TorVM[1]. Transparent torification also will not protect against
fingerprinting attacks on its own, so it is recommended to use it in
conjunction with the Tor Browser(AUR: tor-browser-en) or to use an
amnesic solution like Tails instead. Applications can still learn your
computer's hostname, MAC address, serial number, timezone, etc. and
those with root privileges can disable the firewall entirely. In other
words, transparent torification with iptables protects against
accidental connections and DNS leaks by misconfigured software, it is
not sufficient to protect against malware or software with serious
security vulnerabilities.

To enable transparent torification, use the following file for
iptables-restore and ip6tables-restore (internally used by systemd's
iptables.service and ip6tables.service).

    /etc/iptables/iptables.rules

    #This file uses the nat table to force outgoing connections through the TransPort or DNSPort, and blocks anything it cannot torrify.
    #Note: Now using --ipv6 and --ipv4 for protocol specific changes. iptables-restore and ip6tables-restore can now use the same file.
    #       Where --ipv6 or --ipv4 is explicitly defined, ip*tables-restore will ignore the rule if it is not for the correct protocol.
    #Note: ip6tables does not support --reject-with
    #Make sure your torrc contains the following lines:
    #       SocksPort 9050
    #       DNSPort 5353
    #       TransPort 9040
    #See iptables(8)

    *nat
    :PREROUTING ACCEPT [6:2126]
    :INPUT ACCEPT [0:0]
    :OUTPUT ACCEPT [17:6239]
    :POSTROUTING ACCEPT [6:408]
    -A PREROUTING ! -i lo -p udp -m udp --dport 53 -j REDIRECT --to-ports 5353
    -A PREROUTING ! -i lo -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040
    -A OUTPUT -o lo -j RETURN
    --ipv4 -A OUTPUT -d 192.168.0.0/16 -j RETURN
    -A OUTPUT -m owner --uid-owner "tor" -j RETURN
    -A OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports 5353
    -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040
    COMMIT

    *filter
    :INPUT DROP [0:0]
    :FORWARD DROP [0:0]
    :OUTPUT DROP [0:0]
    -A INPUT -i lo -j ACCEPT
    -A INPUT -p icmp -j ACCEPT
    -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    --ipv4 -A INPUT -p tcp -j REJECT --reject-with tcp-reset
    --ipv4 -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
    --ipv4 -A INPUT -j REJECT --reject-with icmp-proto-unreachable
    --ipv6 -A INPUT -j REJECT
    --ipv4 -A OUTPUT -d 127.0.0.0/8 -j ACCEPT
    --ipv4 -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
    --ipv6 -A OUTPUT -d ::1/8 -j ACCEPT
    -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    -A OUTPUT -m owner --uid-owner "tor" -j ACCEPT
    --ipv4 -A OUTPUT -j REJECT --reject-with icmp-port-unreachable
    --ipv6 -A OUTPUT -j REJECT
    COMMIT

This file also works for ip6tables-restore, so you may symlink it:

    ln -s /etc/iptables/iptables.rules /etc/iptables/ip6tables.rules

Then make sure Tor is running, and start iptables and ip6tables:

    systemctl {enable,start} tor iptables ip6tables

You may want to add Requires=iptables.service and
Requires=ip6tables.service to whatever systemd unit logs your user in
(most likely a display manager), to prevent any user processes from
being started before the firewall up. See systemd.

  

Troubleshooting
---------------

> Problem with user value

If the tor daemon failed to start, then run the following command as
root (or use sudo)

    # tor

If you get the following error

    May 23 00:27:24.624 [warn] Error setting groups to gid 43: "Operation not permitted".
    May 23 00:27:24.624 [warn] If you set the "User" option, you must start Tor as root.
    May 23 00:27:24.624 [warn] Failed to parse/validate config: Problem with User value. See logs for details.
    May 23 00:27:24.624 [err] Reading config failed--see warnings above.

Then it means that the problem is with the User value, which likely
means that one or more files or directories in your /var/lib/tor
directory is not owned by tor. This can be determined by using the
following find command:

    find /var/lib/tor/ ! -user tor

Any files or directories listed in the output from this command needs to
have its ownership changed. This can be done individually for each file
like so:

    chown tor:tor /var/lib/tor/filename

Or to change everything listed by the above find example, modify the
command to this:

    find /var/lib/tor/ ! -user tor -exec chown tor:tor {} \;

Tor should now start up correctly.

Still if you cannot start the tor service, run the service using root
(this will switch back to the tor user). To do this, change the user
name in the /etc/tor/torrc file:

    User tor

Now modify the systemd's tor service file
/usr/lib/systemd/system/tor.service as follows

    [Service]
    User=root
    Group=root
    Type=simple

The process will be run as tor user. For this purpose change user and
group ID to tor and also make it writable:

    # chown -R tor:tor /var/lib/tor/
    # chmod -R 755 /var/lib/tor

Now save changes and run the daemon:

    # systemctl --system daemon-reload
    # systemctl start tor.service

> Daemon fails on restart

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: rc.d? (Discuss)  
  ------------------------ ------------------------ ------------------------

If after issuing a daemon restart you have log entries similar to

    Interrupt: we have stopped accepting new connections, and will shut down in 30 seconds. Interrupt again to exit now

and the daemon fails to start back up, a simple workaround is to open
/etc/rc.d/tor in your favourite editor and increase the time waited
between the shutting down and starting up again of the daemon. For
example:

    /etc/rc.d/tor

        ;;
      restart)
        $0 stop
        sleep 35
        $0 start
        ;;

This will allow Tor to shutdown cleanly, and restart after a safe period
of time. Remember that this file may be overwritten by upgrades.

See also
--------

-   Running the Tor client on Linux/BSD/Unix
-   Unix-based Tor Articles
-   Software commonly integrated with Tor
-   How to set up a Tor Hidden Service

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tor&oldid=305565"

Categories:

-   Internet applications
-   Proxy servers

-   This page was last modified on 19 March 2014, at 08:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
