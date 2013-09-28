Secure Shell
============

Secure Shell (SSH) is a network protocol that allows data to be
exchanged over a secure channel between two computers. Encryption
provides confidentiality and integrity of data. SSH uses public-key
cryptography to authenticate the remote computer and allow the remote
computer to authenticate the user, if necessary.

SSH is typically used to log into a remote machine and execute commands,
but it also supports tunneling, forwarding arbitrary TCP ports and X11
connections; file transfer can be accomplished using the associated SFTP
or SCP protocols.

An SSH server, by default, listens on the standard TCP port 22. An SSH
client program is typically used for establishing connections to an sshd
daemon accepting remote connections. Both are commonly present on most
modern operating systems, including Mac OS X, GNU/Linux, Solaris and
OpenVMS. Proprietary, freeware and open source versions of various
levels of complexity and completeness exist.

(Source: Wikipedia:Secure Shell)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 OpenSSH                                                            |
|     -   1.1 Installing OpenSSH                                           |
|     -   1.2 Configuring SSH                                              |
|         -   1.2.1 Client                                                 |
|         -   1.2.2 Daemon                                                 |
|                                                                          |
|     -   1.3 Managing the sshd daemon                                     |
|     -   1.4 Connecting to the server                                     |
|                                                                          |
| -   2 Other SSH clients and servers                                      |
|     -   2.1 Dropbear                                                     |
|     -   2.2 SSH alternative: Mobile Shell - responsive, survives         |
|         disconnects                                                      |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Encrypted SOCKS tunnel                                       |
|         -   3.1.1 Step 1: start the connection                           |
|         -   3.1.2 Step 2: configure your browser (or other programs)     |
|                                                                          |
|     -   3.2 X11 forwarding                                               |
|     -   3.3 Forwarding other ports                                       |
|     -   3.4 Speeding up SSH                                              |
|     -   3.5 Mounting a remote filesystem with SSHFS                      |
|     -   3.6 Keep alive                                                   |
|     -   3.7 Saving connection data in ssh config                         |
|     -   3.8 Autossh - automatically restarts SSH sessions and tunnels    |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Connection refused or timeout problem                        |
|         -   4.1.1 Is your router doing port forwarding?                  |
|         -   4.1.2 Is SSH running and listening?                          |
|         -   4.1.3 Are there firewall rules blocking the connection?      |
|         -   4.1.4 Is the traffic even getting to your computer?          |
|         -   4.1.5 Your ISP or a third party blocking default port?       |
|             -   4.1.5.1 Diagnosis via Wireshark                          |
|             -   4.1.5.2 Possible solution                                |
|                                                                          |
|         -   4.1.6 Read from socket failed: connection reset by peer      |
|                                                                          |
|     -   4.2 "[your shell]: No such file or directory" /                  |
|         ssh_exchange_identification problem                              |
|     -   4.3 "Terminal unknown" or "Error opening terminal" error message |
|         -   4.3.1 Workaround by setting the $TERM variable               |
|         -   4.3.2 Solution using terminfo file                           |
|                                                                          |
| -   5 See also                                                           |
| -   6 Links & references                                                 |
+--------------------------------------------------------------------------+

OpenSSH
-------

OpenSSH (OpenBSD Secure Shell) is a set of computer programs providing
encrypted communication sessions over a computer network using the ssh
protocol. It was created as an open source alternative to the
proprietary Secure Shell software suite offered by SSH Communications
Security. OpenSSH is developed as part of the OpenBSD project, which is
led by Theo de Raadt.

OpenSSH is occasionally confused with the similarly-named OpenSSL;
however, the projects have different purposes and are developed by
different teams, the similar name is drawn only from similar goals.

> Installing OpenSSH

Install openssh from the official repositories.

> Configuring SSH

Client

The SSH client configuration file is /etc/ssh/ssh_config or
~/.ssh/config.

An example configuration:

    /etc/ssh/ssh_config

    #	$OpenBSD: ssh_config,v 1.26 2010/01/11 01:39:46 dtucker Exp $

    # This is the ssh client system-wide configuration file.  See
    # ssh_config(5) for more information.  This file provides defaults for
    # users, and the values can be changed in per-user configuration files
    # or on the command line.

    # Configuration data is parsed as follows:
    #  1. command line options
    #  2. user-specific file
    #  3. system-wide file
    # Any configuration value is only changed the first time it is set.
    # Thus, host-specific definitions should be at the beginning of the
    # configuration file, and defaults at the end.

    # Site-wide defaults for some commonly used options.  For a comprehensive
    # list of available options, their meanings and defaults, please see the
    # ssh_config(5) man page.

    # Host *
    #   ForwardAgent no
    #   ForwardX11 no
    #   RhostsRSAAuthentication no
    #   RSAAuthentication yes
    #   PasswordAuthentication yes
    #   HostbasedAuthentication no
    #   GSSAPIAuthentication no
    #   GSSAPIDelegateCredentials no
    #   BatchMode no
    #   CheckHostIP yes
    #   AddressFamily any
    #   ConnectTimeout 0
    #   StrictHostKeyChecking ask
    #   IdentityFile ~/.ssh/identity
    #   IdentityFile ~/.ssh/id_rsa
    #   IdentityFile ~/.ssh/id_dsa
    #   Port 22
    #   Protocol 2,1
    #   Cipher 3des
    #   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
    #   MACs hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160
    #   EscapeChar ~
    #   Tunnel no
    #   TunnelDevice any:any
    #   PermitLocalCommand no
    #   VisualHostKey no
    #   ProxyCommand ssh -q -W %h:%p gateway.example.com

It is recommended to change the Protocol line into this:

    Protocol 2

That means that only Protocol 2 will be used, since Protocol 1 is
considered somewhat insecure.

Daemon

The SSH daemon configuration file can be found and edited in
/etc/ssh/sshd_config.

An example configuration:

    /etc/ssh/sshd_config

    #	$OpenBSD: sshd_config,v 1.82 2010/09/06 17:10:19 naddy Exp $

    # This is the sshd server system-wide configuration file.  See
    # sshd_config(5) for more information.

    # This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

    # The strategy used for options in the default sshd_config shipped with
    # OpenSSH is to specify options with their default value where
    # possible, but leave them commented.  Uncommented options change a
    # default value.

    #Port 22
    #AddressFamily any
    #ListenAddress 0.0.0.0
    #ListenAddress ::

    # The default requires explicit activation of protocol 1
    #Protocol 2

    # HostKey for protocol version 1
    #HostKey /etc/ssh/ssh_host_key
    # HostKeys for protocol version 2
    #HostKey /etc/ssh/ssh_host_rsa_key
    #HostKey /etc/ssh/ssh_host_dsa_key
    #HostKey /etc/ssh/ssh_host_ecdsa_key

    # Lifetime and size of ephemeral version 1 server key
    #KeyRegenerationInterval 1h
    #ServerKeyBits 1024

    # Logging
    # obsoletes QuietMode and FascistLogging
    #SyslogFacility AUTH
    #LogLevel INFO

    # Authentication:

    #LoginGraceTime 2m
    #PermitRootLogin yes
    #StrictModes yes
    #MaxAuthTries 6
    #MaxSessions 10

    #RSAAuthentication yes
    #PubkeyAuthentication yes
    #AuthorizedKeysFile	.ssh/authorized_keys

    # For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
    #RhostsRSAAuthentication no
    # similar for protocol version 2
    #HostbasedAuthentication no
    # Change to yes if you do not trust ~/.ssh/known_hosts for
    # RhostsRSAAuthentication and HostbasedAuthentication
    #IgnoreUserKnownHosts no
    # Don't read the user's ~/.rhosts and ~/.shosts files
    #IgnoreRhosts yes

    # To disable tunneled clear text passwords, change to no here!
    #PasswordAuthentication yes
    #PermitEmptyPasswords no

    # Change to no to disable s/key passwords
    ChallengeResponseAuthentication no

    # Kerberos options
    #KerberosAuthentication no
    #KerberosOrLocalPasswd yes
    #KerberosTicketCleanup yes
    #KerberosGetAFSToken no

    # GSSAPI options
    #GSSAPIAuthentication no
    #GSSAPICleanupCredentials yes

    # Set this to 'yes' to enable PAM authentication, account processing, 
    # and session processing. If this is enabled, PAM authentication will 
    # be allowed through the ChallengeResponseAuthentication and
    # PasswordAuthentication.  Depending on your PAM configuration,
    # PAM authentication via ChallengeResponseAuthentication may bypass
    # the setting of "PermitRootLogin without-password".
    # If you just want the PAM account and session checks to run without
    # PAM authentication, then enable this but set PasswordAuthentication
    # and ChallengeResponseAuthentication to 'no'.
    UsePAM yes

    #AllowAgentForwarding yes
    #AllowTcpForwarding yes
    #GatewayPorts no
    #X11Forwarding no
    #X11DisplayOffset 10
    #X11UseLocalhost yes
    #PrintMotd yes
    #PrintLastLog yes
    #TCPKeepAlive yes
    #UseLogin no
    #UsePrivilegeSeparation yes
    #PermitUserEnvironment no
    #Compression delayed
    #ClientAliveInterval 0
    #ClientAliveCountMax 3
    #UseDNS yes
    #PidFile /var/run/sshd.pid
    #MaxStartups 10
    #PermitTunnel no
    #ChrootDirectory none

    # no default banner path
    #Banner none

    # override default of no subsystems
    Subsystem	sftp	/usr/lib/ssh/sftp-server

    # Example of overriding settings on a per-user basis
    #Match User anoncvs
    #	X11Forwarding no
    #	AllowTcpForwarding no
    #	ForceCommand cvs server

To allow access only for some users add this line:

    AllowUsers    user1 user2

To disable root login over SSH, change the PermitRootLogin line into
this:

    PermitRootLogin no

To add a nice welcome message edit the file /etc/issue and change the
Banner line into this:

    Banner /etc/issue

Tip: You may want to change the default port from 22 to any higher port
(see security through obscurity).

Even though the port ssh is running on could be detected by using a
port-scanner like nmap, changing it will reduce the number of log
entries caused by automated authentication attempts. To help select a
port review the list of TCP and UDP port numbers.

Tip:Disabling password logins entirely will greatly increase security,
see SSH Keys for more information.

> Managing the sshd daemon

You can start the sshd daemon with the following command:

    # systemctl start sshd

You can enable the sshd daemon at startup with the following command:

    # systemctl enable sshd.service

Warning:Systemd is an asynchronous starting process. If you bind the SSH
daemon to a specific IP address ListenAddress 192.168.1.100 it may fail
to load during boot since the default sshd.service unit file has no
dependency on network interfaces being enabled. When binding to an IP
address, you will need to add After=network.target to a custom
sshd.service unit file. See Systemd#Replacing provided unit files.

Or you can enable SSH Daemon socket so the daemon is started on the
first incoming connection:

    # systemctl enable sshd.socket

If you use a different port than the default 22, you have to set
"ListenStream" in the unit file. Copy /lib/systemd/system/sshd.socket to
/etc/systemd/system/sshd.socket to keep your unit file from being
overwritten on upgrades. In /etc/systemd/system/sshd.socket change
"ListenStream" the appropriate port.

> Connecting to the server

To connect to a server, run:

    $ ssh -p port user@server-address

Other SSH clients and servers
-----------------------------

Apart from OpenSSH, there are many SSH clients and servers avaliable.

> Dropbear

Dropbear is a SSH-2 client and server. dropbear is available in the AUR.

The commandline ssh client is named dbclient.

> SSH alternative: Mobile Shell - responsive, survives disconnects

From the Mosh website:

Remote terminal application that allows roaming, supports intermittent
connectivity, and provides intelligent local echo and line editing of
user keystrokes. Mosh is a replacement for SSH. It's more robust and
responsive, especially over Wi-Fi, cellular, and long-distance links.

Install mosh from the official repositories or the latest revision
mosh-git in the AUR.

Tips and tricks
---------------

> Encrypted SOCKS tunnel

This is highly useful for laptop users connected to various unsafe
wireless connections. The only thing you need is an SSH server running
at a somewhat secure location, like your home or at work. It might be
useful to use a dynamic DNS service like DynDNS so you do not have to
remember your IP-address.

Step 1: start the connection

You only have to execute this single command to start the connection:

    $ ssh -TND 4711 user@host

where "user" is your username at the SSH server running at the "host".
It will ask for your password, and then you're connected! The "N" flag
disables the interactive prompt, and the "D" flag specifies the local
port on which to listen on (you can choose any port number if you want).
The "T" flag disables pseudo-tty allocation.

It's nice to add the verbose "-v" flag, because then you can verify that
it's actually connected from that output.

Step 2: configure your browser (or other programs)

The above step is completely useless if you do not configure your web
browser (or other programs) to use this newly created socks tunnel.
Since the current version of SSH supports both SOCKS4 and SOCKS5, you
can use either of them.

-   For Firefox: Edit → Preferences → Advanced → Network → Connection →
    Setting:

Check the "Manual proxy configuration" radio button, and enter
"localhost" in the "SOCKS host" text field, and then enter your port
number in the next text field (I used 4711 above).

Firefox does not automatically make DNS requests through the socks
tunnel. This potential privacy concern can be mitigated by the following
steps:

1.  Type about:config into the Firefox location bar.
2.  Search for network.proxy.socks_remote_dns
3.  Set the value to true.
4.  Restart the browser.

-   For Chromium: You can set the SOCKS settings as environment
    variables or as command line options. I recommend to add one of the
    following functions to your .bashrc:

    function secure_chromium {
        port=4711
        export SOCKS_SERVER=localhost:$port
        export SOCKS_VERSION=5
        chromium &
        exit
    }

OR

    function secure_chromium {
        port=4711
        chromium --proxy-server="socks://localhost:$port" &
        exit
    }

Now open a terminal and just do:

    $ secure_chromium

Enjoy your secure tunnel!

> X11 forwarding

To run graphical programs through a SSH connection you can enable X11
forwarding. An option needs to be set in the configuration files on the
server and client (here "client" means your (desktop) machine your X11
Server runs on, and you will run X applications on the "server").

Install xorg-xauth from the official repositories onto the server.

-   Enable the AllowTcpForwarding option in sshd_config on the server.
-   Enable the X11Forwarding option in sshd_config on the server.
-   Set the X11DisplayOffset option in sshd_config on the server to 10.
-   Enable the X11UseLocalhost option in sshd_config on the server.

Also:

-   Enable the ForwardX11 option in ssh_config on the client.
-   Enable the ForwardX11Trusted if gui is drawing badly.

You need to restart the ssh daemon on the server for these changes to
take effect, of course.

To use the forwarding, log on to your server through ssh:

    $ ssh -X -p port user@server-address

If you receive errors trying to run graphical applications try trusted
forwarding instead:

    $ ssh -Y -p port user@server-address

You can now start any X program on the remote server, the output will be
forwarded to your local session:

    $ xclock

  
 If you get "Cannot open display" errors try the following command as
the non root user:

    $ xhost +

the above command will allow anybody to forward X11 applications. To
restrict forwarding to a particular host type:

    $ xhost +hostname

where hostname is the name of the particular host you want to forward
to. Type "man xhost" for more details.

Be careful with some applications as they check for a running instance
on the local machine. Firefox is an example. Either close running
Firefox or use the following start parameter to start a remote instance
on the local machine

    $ firefox -no-remote

If you get "X11 forwarding request failed on channel 0" when you connect
(and the server /var/log/errors.log shows "Failed to allocate
internet-domain X11 display socket"), try to either

-   Enable the AddressFamily any option in sshd_config on the server, or
-   Set the AddressFamily option in sshd_config on the server to inet.

Setting it to inet may fix problems with Ubuntu clients on IPv4.

> Forwarding other ports

In addition to SSH's built-in support for X11, it can also be used to
securely tunnel any TCP connection, by use of local forwarding or remote
forwarding.

Local forwarding opens a port on the local machine, connections to which
will be forwarded to the remote host and from there on to a given
destination. Very often, the forwarding destination will be the same as
the remote host, thus providing a secure shell and, e.g. a secure VNC
connection, to the same machine. Local forwarding is accomplished by
means of the -L switch and it's accompanying forwarding specification in
the form of <tunnel port>:<destination address>:<destination port>.

Thus:

    $ ssh -L 1000:mail.google.com:25 192.168.0.100

will use SSH to login to and open a shell on 192.168.0.100, and will
also create a tunnel from the local machine's TCP port 1000 to
mail.google.com on port 25. Once established, connections to
localhost:1000 will connect to the Gmail SMTP port. To Google, it will
appear that any such connection (though not necessarily the data
conveyed over the connection) originated from 192.168.0.100, and such
data will be secure as between the local machine and 192.168.0.100, but
not between 192.168.0.100, unless other measures are taken.

Similarly:

    $ ssh -L 2000:192.168.0.100:6001 192.168.0.100

will allow connections to localhost:2000 which will be transparently
sent to the remote host on port 6001. The preceding example is useful
for VNC connections using the vncserver utility--part of the tightvnc
package--which, though very useful, is explicit about its lack of
security.

Remote forwarding allows the remote host to connect to an arbitrary host
via the SSH tunnel and the local machine, providing a functional
reversal of local forwarding, and is useful for situations where, e.g.,
the remote host has limited connectivity due to firewalling. It is
enabled with the -R switch and a forwarding specification in the form of
<tunnel port>:<destination address>:<destination port>.

Thus:

    $ ssh -R 3000:irc.freenode.net:6667 192.168.0.200

will bring up a shell on 192.168.0.200, and connections from
192.168.0.200 to itself on port 3000 (remotely speaking, localhost:3000)
will be sent over the tunnel to the local machine and then on to
irc.freenode.net on port 6667, thus, in this example, allowing the use
of IRC programs on the remote host to be used, even if port 6667 would
normally be blocked to it.

Both local and remote forwarding can be used to provide a secure
"gateway," allowing other computers to take advantage of an SSH tunnel,
without actually running SSH or the SSH daemon by providing a
bind-address for the start of the tunnel as part of the forwarding
specification, e.g.
<tunnel address>:<tunnel port>:<destination address>:<destination port>.
The <tunnel address> can be any address on the machine at the start of
the tunnel, localhost, * (or blank), which, respectively, allow
connections via the given address, via the loopback interface, or via
any interface. By default, forwarding is limited to connections from the
machine at the "beginning" of the tunnel, i.e. the <tunnel address> is
set to localhost. Local forwarding requires no additional configuration,
however remote forwarding is limited by the remote server's SSH daemon
configuration. See the GatewayPorts option in sshd_config(5) for more
information.

> Speeding up SSH

You can make all sessions to the same host use a single connection,
which will greatly speed up subsequent logins, by adding these lines
under the proper host in /etc/ssh/ssh_config:

    ControlMaster auto
    ControlPath ~/.ssh/socket-%r@%h:%p

Changing the ciphers used by SSH to less cpu-demanding ones can improve
speed. In this aspect, the best choices are arcfour and blowfish-cbc.
Please do not do this unless you know what you are doing; arcfour has a
number of known weaknesses. To use them, run SSH with the "c" flag, like
this:

    $ ssh -c arcfour,blowfish-cbc user@server-address

To use them permanently, add this line under the proper host in
/etc/ssh/ssh_config:

    Ciphers arcfour,blowfish-cbc

Another option to improve speed is to enable compression with the "C"
flag. A permanent solution is to add this line under the proper host in
/etc/ssh/ssh_config:

    Compression yes

Login time can be shorten by using the "4" flag, which bypasses IPv6
lookup. This can be made permanent by adding this line under the proper
host in /etc/ssh/ssh_config:

    AddressFamily inet

Another way of making these changes permanent is to create an alias in
~/.bashrc:

    alias ssh='ssh -C4c arcfour,blowfish-cbc'

> Mounting a remote filesystem with SSHFS

Please refer to the Sshfs article to use sshfs to mount a remote system
- accessible via SSH - to a local folder, so you will be able to do any
operation on the mounted files with any tool (copy, rename, edit with
vim, etc.). Using sshfs instead of shfs is generally preferred as a new
version of shfs hasn't been released since 2004.

> Keep alive

Your ssh session will automatically log out if it is idle. To keep the
connection active (alive) add this to ~/.ssh/config or to
/etc/ssh/ssh_config on the client.

    ServerAliveInterval 120

This will send a "keep alive" signal to the server every 120 seconds.

Conversely, to keep incoming connections alive, you can set

    ClientAliveInterval 120

(or some other number greater than 0) in /etc/ssh/sshd_config on the
server.

> Saving connection data in ssh config

Whenever you want to connect to a ssh server, you usually have to type
at least its address and the username. To save that typing work for
servers you regularly connect to, you can use the personal
$HOME/.ssh/config or the global /etc/ssh/ssh_config files as shown in
the following example:

    $HOME/.ssh/config

    Host myserver
        HostName 123.123.123.123
        Port 12345
        User bob
    Host other_server
        HostName test.something.org
        User alice
        CheckHostIP no
        Cipher blowfish

Now you can simply connect to the server by using the name you
specified:

    $ ssh myserver

To see a complete list of the possible options, check out ssh_config's
manpage on your system or the ssh_config documentation on the official
website.

> Autossh - automatically restarts SSH sessions and tunnels

When a ssh session or tunnel cannot be kept alive, because for example
bad network conditions cause the sshd client to disconnect, you can use
Autossh to automatically restart them. Autossh can be installed from the
official repositories.

Usage examples:

    $ autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" username@example.com

Combined with sshfs:

    $ sshfs -o reconnect,compression=yes,transform_symlinks,ServerAliveInterval=45,ServerAliveCountMax=2,ssh_command='autossh -M 0' username@example.com: /mnt/example 

Connecting through a SOCKS-proxy set by Proxy_settings:

    $ autossh -M 0 "ServerAliveInterval 45" -o "ServerAliveCountMax 2" -NCD 8080 username@example.com 

With the -f option autossh can be made to run as a background process.
Running it this way however means the passprase cannot be entered
interactively.

The session will end once you type exit in the session, or the autossh
process receives a SIGTERM, SIGINT of SIGKILL signal.

If you want to automatically start autossh, it is now easy to get
systemd to manage this for you. For example, you could create a systemd
unit file like this:

    [Unit]
    Description=AutoSSH service for port 2222
    After=network.target

    [Service]
    ExecStart=/usr/bin/autossh -M 0 2222:localhost:2222 foo@bar.com

Then place this in, for example,
/etc/systemd/system/system/autossh.service. Of course, you can make this
unit more complex if necessary (see the systemd documentation for
details), and obviously you can use your own options for autossh.

You can then enable your autossh tunnels with, e.g.:

    $ systemctl start autossh

(or whatever you called the service file)

It is also easy to maintain several autossh processes, to keep several
tunnels alive. Just create multiple .service files with different names.

Troubleshooting
---------------

> Connection refused or timeout problem

Is your router doing port forwarding?

The first thing is to make sure that your router knows to forward any
incoming ssh connection to your machine. Your external IP is given to
you by your ISP, and it is associated with any requests coming out of
your router. So your router needs to know that any incoming ssh
connection to your external IP needs to be forwarded to your machine
running sshd.

Find your internal network address.

    ip a

Find your interface device and look for the inet field. Then access your
router's configuration web interface, using your router's IP (find this
on the web). Tell your router to forward it to your inet IP. Go to [1]
for more instructions on how to do so for your particular router.

Is SSH running and listening?

    $ ss -tnlp

If the above command do not show SSH port is open, SSH is NOT running.
Check /var/log/messages for errors etc.

Are there firewall rules blocking the connection?

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: rc.d is          
                           deprecated with systemd  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Flush your iptables rules to make sure they are not interfering:

    # rc.d stop iptables

or:

    # iptables -P INPUT ACCEPT
    # iptables -P OUTPUT ACCEPT
    # iptables -F INPUT
    # iptables -F OUTPUT

Is the traffic even getting to your computer?

Start a traffic dump on the computer you're having problems with:

    # tcpdump -lnn -i any port ssh and tcp-syn

This should show some basic information, then wait for any matching
traffic to happen before displaying it. Try your connection now. If you
do not see any output when you attempt to connect, then something
outside of your computer is blocking the traffic (e. g., hardware
firewall, NAT router etc.).

Your ISP or a third party blocking default port?

Note:Try this step if you KNOW you aren't running any firewalls and you
know you have configured the router for DMZ or have forwarded the port
to your computer and it still doesn't work. Here you will find
diagnostic steps and a possible solution.

In some cases, your ISP might block the default port (SSH port 22) so
whatever you try (opening ports, hardening the stack, defending against
flood attacks, et al) ends up useless. To confirm this, create a server
on all interfaces (0.0.0.0) and connect remotely.

If you get an error message comparable to this:

    ssh: connect to host www.inet.hr port 22: Connection refused

That means the port ISN'T being blocked by the ISP, but the server
doesn't run SSH on that port (See security through obscurity).

However, if you get an error message comparable to this:

    ssh: connect to host 111.222.333.444 port 22: Operation timed out 

That means that something is rejecting your TCP traffic on port 22.
Basically that port is stealth, either by your firewall or 3rd party
intervetion (like an ISP blocking and/or rejecting incoming traffic on
port 22). If you know you aren't running any firewall on your computer,
and you know that Gremlins aren't growing in your routers and switches,
then your ISP is blocking the traffic.

To double check, you can run Wireshark on your server and listen to
traffic on port 22. Since Wireshark is a Layer 2 Packet Sniffing
utility, and TCP/UDP are Layer 3 and above (See IP Network stack), if
you don't receive anything while connecting remotely, a third party is
most likely to be blocking the traffic on that port to your server.

Diagnosis via Wireshark

First install Wireshark using pacman.

    pacman -Sy wireshark-cli 

And then run it using,

    tshark -f "tcp port 22" -i NET_IF

where NET_IF is the network interface for a WAN connection (see ip a to
check). If you aren't receiving any packets while trying to connect
remotely, you can be very sure that your ISP is blocking the incoming
traffic on port 22.

Possible solution

The solution is just to use some other port that the ISP isn't blocking.
Open the /etc/ssh/sshd_config and configure the file to use different
ports. For example, add:

    Port 22
    Port 1234

Also make sure that other "Port" configuration lines in the file are
commented out. Just commenting "Port 22" and putting "Port 1234" won't
solve the issue because then sshd will only listen on port 1234. Use
both lines to run the SSH server on both ports.

Restart the server systemctl restart sshd.service and you're almost
done. You still have to configure your client(s) to use the other port
instead of the default port. There are numerous solutions to that
problem, but let's cover two of them here.

Read from socket failed: connection reset by peer

Recent versions of openssh sometimes fail with the above error message,
due to a bug involving elliptic curve cryptography. In that case add the
following line to ~/.ssh/config:

    HostKeyAlgorithms ssh-rsa-cert-v01@openssh.com,ssh-dss-cert-v01@openssh.com,ssh-rsa-cert-v00@openssh.com,ssh-dss-cert-v00@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa,ssh-dss

With openssh 5.9, the above fix doesn't work. Instead, put the following
lines in ~/.ssh/config:

    Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc 
    MACs hmac-md5,hmac-sha1,hmac-ripemd160

See also the discussion on the openssh bug forum.

> "[your shell]: No such file or directory" / ssh_exchange_identification problem

One possible cause for this is the need of certain SSH clients to find
an absolute path (one returned by whereis -b [your shell], for instance)
in $SHELL, even if the shell's binary is located in one of the $PATH
entries. Another reason can be that the user is no member of the network
group.

> "Terminal unknown" or "Error opening terminal" error message

With ssh it is possible to receive errors like "Terminal unknown" upon
logging in. Starting ncurses applications like nano fails with the
message "Error opening terminal". There are two methods to this problem,
a quick one using the $TERM variable and a profound one using the
terminfo file.

Workaround by setting the $TERM variable

After connecting to the remote server set the $TERM variable to "xterm"
with the following command.

TERM=xterm

This method is a workaround and should be used on ssh servers you do
seldomly connect to, because it can have unwanted side effects. Also you
have to repeat the command after every connection, or alternatively set
it in ~.bashrc .

Solution using terminfo file

A profound solution is transferring the terminfo file of the terminal on
your client computer to the ssh server. In this example we cover how to
setup the terminfo file for the "rxvt-unicode-256color" terminal. Create
the directory containing the terminfo files on the ssh server, while you
are logged in to the server issue this command:

 mkdir -p ~/.terminfo/r/

Now copy the terminfo file of your terminal to the new directory.
Replace "rxvt-unicode-256color" with your client's terminal in the
following command and ssh-server with the relevant user and server
adress.

$ scp  /usr/share/terminfo/r/rxvt-unicode-256color ssh-server:~/.terminfo/r/

After logging in and out from the ssh server the problem should be
fixed.

See also
--------

-   SSH Keys
-   Pam abl
-   fail2ban
-   sshguard
-   Sshfs
-   Syslog-ng : To send ssh log data to another file

Links & references
------------------

-   A Cure for the Common SSH Login Attack
-   Defending against brute force ssh attacks
-   OpenSSH key management, Part 1 and Part 2 on IBM developerWorks

Retrieved from
"https://wiki.archlinux.org/index.php?title=Secure_Shell&oldid=253472"

Category:

-   Secure Shell
