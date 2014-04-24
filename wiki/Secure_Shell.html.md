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

Contents
--------

-   1 OpenSSH
    -   1.1 Installing OpenSSH
    -   1.2 Configuring SSH
        -   1.2.1 Client
        -   1.2.2 Daemon
    -   1.3 Managing the sshd daemon
    -   1.4 Connecting to the server
    -   1.5 Protecting SSH
        -   1.5.1 Protecting against brute force attacks
        -   1.5.2 Deny root login
-   2 Other SSH clients and servers
    -   2.1 Dropbear
    -   2.2 SSH alternative: Mobile Shell - responsive, survives
        disconnects
-   3 Tips and tricks
    -   3.1 Encrypted SOCKS tunnel
        -   3.1.1 Step 1: start the connection
        -   3.1.2 Step 2: configure your browser (or other programs)
    -   3.2 X11 forwarding
    -   3.3 Forwarding other ports
    -   3.4 Speeding up SSH
    -   3.5 Mounting a remote filesystem with SSHFS
    -   3.6 Keep alive
    -   3.7 Saving connection data in ssh config
    -   3.8 Autossh - automatically restarts SSH sessions and tunnels
        -   3.8.1 Run Autossh automatically at boot via systemd
-   4 Changing SSH port number with socket activation (sshd.socket)
-   5 Troubleshooting
    -   5.1 SSH connection left hanging after poweroff/reboot
    -   5.2 Connection refused or timeout problem
        -   5.2.1 Is your router doing port forwarding?
        -   5.2.2 Is SSH running and listening?
        -   5.2.3 Are there firewall rules blocking the connection?
        -   5.2.4 Is the traffic even getting to your computer?
        -   5.2.5 Your ISP or a third party blocking default port?
            -   5.2.5.1 Diagnosis via Wireshark
            -   5.2.5.2 Possible solution
        -   5.2.6 Read from socket failed: connection reset by peer
    -   5.3 "[your shell]: No such file or directory" /
        ssh_exchange_identification problem
    -   5.4 "Terminal unknown" or "Error opening terminal" error message
        -   5.4.1 Workaround by setting the $TERM variable
        -   5.4.2 Solution using terminfo file
-   6 See also
-   7 Links & references

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

It is not longer needed to explicitly set Protocol 2, it is commented
out in the default configuration file. That means Protocol 1 will not be
used as long as it is not explicitly enabled. (source:
http://www.openssh.org/txt/release-5.4)

Daemon

The SSH daemon configuration file can be found and edited in
/etc/ssh/sshd_config.

To allow access only for some users add this line:

    AllowUsers    user1 user2

To allow access only for some groups:

    AllowGroups   group1 group2

To disable root login over SSH, change the PermitRootLogin line into
this:

    PermitRootLogin no

To add a nice welcome message edit the file /etc/issue and change the
Banner line into this:

    Banner /etc/issue

> Tip:

-   You may want to change the default port from 22 to any higher port
    (see security through obscurity). Even though the port ssh is
    running on could be detected by using a port-scanner like nmap,
    changing it will reduce the number of log entries caused by
    automated authentication attempts. To help select a port review the
    list of TCP and UDP port numbers. You can also find port information
    locally in /etc/services. Select an alternative port that is not
    already assigned to a common service to prevent conflicts.
-   Disabling password logins entirely will greatly increase security,
    see SSH Keys for more information.

> Managing the sshd daemon

The SSH daemon comes with different systemd unit files.

You can start the daemon for immediate usage and/or enable it for next
startup as follows:

    # systemctl start sshd
    # systemctl enable sshd.service

See SystemD#Using_units

Warning:Systemd is an asynchronous starting process. If you bind the SSH
daemon to a specific IP address ListenAddress 192.168.1.100 it may fail
to load during boot since the default sshd.service unit file has no
dependency on network interfaces being enabled. When binding to an IP
address, you will need to add After=network.target to a custom
sshd.service unit file. See Systemd#Editing provided unit files.

Alternatively to the service used above, the SSH daemon supports socket
activation. Using it implies that systemd listens on the SSH socket and
will only start the daemon process for an incoming connection:

    # systemctl start sshd.socket
    # systemctl enable sshd.socket 

If you use a different port than the default 22 with socket activation,
you have to set "ListenStream" in the unit file. Copy
/lib/systemd/system/sshd.socket to /etc/systemd/system/sshd.socket to
keep your unit file from being overwritten on upgrades. In
/etc/systemd/system/sshd.socket change "ListenStream" the appropriate
port.

Warning:Using sshd.socket effectively negates the ListenAddress setting,
so using the default sshd.socket will allow connections over any
address. To achieve the effect of setting ListenAddress, you must create
a custom unit file and modify ListenStream (ie.
ListenStream=192.168.1.100:22 is equivalent to
ListenAddress 192.168.1.100). You must also add FreeBind=true under
[Socket] or else setting the IP address will have the same drawback as
setting ListenAddress: the socket will fail to start if the network is
not up in time.

> Connecting to the server

To connect to a server, run:

    $ ssh -p port user@server-address

> Protecting SSH

Allowing remote log-on through SSH is good for administrative purposes,
but can pose a threat to your server's security. Often the target of
brute force attacks, SSH access needs to be limited properly to prevent
third parties gaining access to your server.

-   Use non-standard account names and passwords
-   Only allow incoming SSH connections from trusted locations
-   Use fail2ban or sshguard to monitor for brute force attacks, and ban
    brute forcing IPs accordingly

Protecting against brute force attacks

Brute forcing is a simple concept: One continuously tries to log in to a
webpage or server log-in prompt like SSH with a high number of random
username and password combinations. You can protect yourself from brute
force attacks by using an automated script that blocks anybody trying to
brute force their way in, for example fail2ban or sshguard.

Deny root login

It is generally considered bad practice to allow the user root to log in
over SSH: The root account will exist on nearly any Linux system and
grants full access to the system, once login has been achieved. Sudo
provides root rights for actions requiring these and is the more secure
solution, third parties would have to find a username present on the
system, the matching password and the matching password for sudo to get
root rights on your system. More barriers to be breached before full
access to the system is reached.

Configure SSH to deny remote logins with the root user by editing
/etc/ssh/sshd_config and look for this section:

    # Authentication:

    #LoginGraceTime 2m
    #PermitRootLogin yes
    #StrictModes yes
    #MaxAuthTries 6
    #MaxSessions 10

Now simply change #PermitRootLogin yes to no, and uncomment the line:

    PermitRootLogin no

Next, restart the SSH daemon:

    # systemctl restart sshd

You will now be unable to log in through SSH under root, but will still
be able to log in with your normal user and use su - or sudo to do
system administration.

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

For running X applications as other user on the SSH server you need to
xauth add the authentication line taken from xauth list of the SSH
logged in user.

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

    Host examplehost.com
      ControlMaster auto
      ControlPersist yes
      ControlPath ~/.ssh/socket-%r@%h:%p

See the ssh_config(5) manual page for full description of these options.

Another option to improve speed is to enable compression with the -C
flag. A permanent solution is to add this line under the proper host in
/etc/ssh/ssh_config:

    Compression yes

Login time can be shortened by using the -4 flag, which bypasses IPv6
lookup. This can be made permanent by adding this line under the proper
host in /etc/ssh/ssh_config:

    AddressFamily inet

Changing the ciphers used by SSH to less cpu-demanding ones can improve
speed. In this aspect, the best choices are arcfour and blowfish-cbc.

Warning:Please do not do this unless you know what you are doing;
arcfour has a number of known weaknesses.

To use alternative ciphers, run SSH with the -c flag:

    $ ssh -c arcfour,blowfish-cbc user@server-address

To use them permanently, add this line under the proper host in
/etc/ssh/ssh_config:

    Ciphers arcfour,blowfish-cbc

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
servers you regularly connect to, you can use the personal ~/.ssh/config
or the global /etc/ssh/ssh_config files as shown in the following
example:

    ~/.ssh/config

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

When a session or tunnel cannot be kept alive, for example due to bad
network conditions causing client disconnections, you can use Autossh to
automatically restart them. Autossh can be installed from the official
repositories.

Usage examples:

    $ autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" username@example.com

Combined with sshfs:

    $ sshfs -o reconnect,compression=yes,transform_symlinks,ServerAliveInterval=45,ServerAliveCountMax=2,ssh_command='autossh -M 0' username@example.com: /mnt/example 

Connecting through a SOCKS-proxy set by Proxy_settings:

    $ autossh -M 0 -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2" -NCD 8080 username@example.com 

With the -f option autossh can be made to run as a background process.
Running it this way however means the passprase cannot be entered
interactively.

The session will end once you type exit in the session, or the autossh
process receives a SIGTERM, SIGINT of SIGKILL signal.

Run Autossh automatically at boot via systemd

If you want to automatically start autossh, it is now easy to get
systemd to manage this for you. For example, you could create a systemd
unit file like this:

    [Unit]
    Description=AutoSSH service for port 2222
    After=network.target

    [Service]
    Environment="AUTOSSH_GATETIME=0"
    ExecStart=/usr/bin/autossh -M 0 -NL 2222:localhost:2222 -o TCPKeepAlive=yes foo@bar.com

    [Install]
    WantedBy=multi-user.target

Here AUTOSSH_GATETIME=0 is an environment variable specifying how long
ssh must be up before autossh considers it a successful connection,
setting it to 0 autossh also ignores the first run failure of ssh. This
may be useful when running autossh at boot. Other environment variables
are available on the manpage. Of course, you can make this unit more
complex if necessary (see the systemd documentation for details), and
obviously you can use your own options for autossh, but note that the -f
implying AUTOSSH_GATETIME=0 does not work with systemd.

Then place this in, for example, /etc/systemd/system/autossh.service.
Afterwards, you can then enable your autossh tunnels with, e.g.:

    $ systemctl start autossh

(or whatever you called the service file)

If this works OK for you, you can make this permanent by running

    $ systemctl enable autossh

That way autossh will start automatically at boot.

It is also easy to maintain several autossh processes, to keep several
tunnels alive. Just create multiple .service files with different names.

Changing SSH port number with socket activation (sshd.socket)
-------------------------------------------------------------

Create file /etc/systemd/system/sshd.socket.d/port.conf with:

    [Socket]
    # Disable default port
    ListenStream=
    # Set new port
    ListenStream=12345

Systemd will automatically listen on the new port after a reload:

    systemctl daemon-reload

Troubleshooting
---------------

> SSH connection left hanging after poweroff/reboot

SSH connection hangs after poweroff or reboot if systemd stop network
before sshd. To fix that problem, comment and change the After
statement:

    /usr/lib/systemd/system/systemd-user-sessions.service

    #After=remote-fs.target
    After=network.target

> Connection refused or timeout problem

Is your router doing port forwarding?

SKIP THIS STEP IF YOU ARE NOT BEHIND A NAT MODEM/ROUTER (eg, a VPS or
otherwise publicly addressed host). Most home and small businesses will
have a NAT modem/router.

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

Iptables may be blocking connections on port 22. Check this with:

    # iptables -nvL

and look for rules that might be dropping packets on the INPUT chain.
Then, if necessary, unblock the port with a command like:

    # iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

For more help configuring firewalls, see firewalls.

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

Install Wireshark with the wireshark-cli package, available in the
official repositories.

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
entries.

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
-   SFTP chroot

Links & references
------------------

-   A Cure for the Common SSH Login Attack
-   Defending against brute force ssh attacks
-   OpenSSH key management, Part 1 and Part 2 on IBM developerWorks

Retrieved from
"https://wiki.archlinux.org/index.php?title=Secure_Shell&oldid=305895"

Category:

-   Secure Shell

-   This page was last modified on 20 March 2014, at 16:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
