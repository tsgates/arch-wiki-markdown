Vncserver
=========

Summary

Vncserver is a remote display daemon that allows users to run totally
parallel sessions on a machine which can be accessed from anywhere. All
applications running under the server continue to run, even when the
user disconnects.

Related

x11vnc - Another flavor of VNC which allows connections to the root (:0)
desktop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running Vncserver                                                  |
|     -   2.1 First Time Setup                                             |
|         -   2.1.1 Create Environment and Password Files                  |
|         -   2.1.2 Edit the xstartup File                                 |
|         -   2.1.3 Permissions                                            |
|                                                                          |
| -   3 Running vncserver                                                  |
| -   4 Connecting to vncserver                                            |
|     -   4.1 Passwordless Authentication                                  |
|     -   4.2 Example GUI-based Clients                                    |
|                                                                          |
| -   5 Securing VNC Server by SSH Tunnels                                 |
|     -   5.1 On the Server                                                |
|     -   5.2 On the Client                                                |
|     -   5.3 Connecting to a VNC Server from Android device over SSH      |
|                                                                          |
| -   6 Starting and Stopping VNC Server at Bootup and Shutdown            |
+--------------------------------------------------------------------------+

Installation
------------

Vncserver is provided by tigervnc and tightvnc both of which can be
installed from the official repositories.

Running Vncserver
-----------------

> First Time Setup

Create Environment and Password Files

Vncserver will create its initial environment file and user password
file the first time it is run:

    $ vncserver

    You will require a password to access your desktops.

    Password:
    Verify:

    New 'mars:1 (facade)' desktop is mars:1

    Creating default startup script /home/facade/.vnc/xstartup
    Starting applications specified in /home/facade/.vnc/xstartup
    Log file is /home/facade/.vnc/mars:1.log

The default port on which vncserver runs is :1 which corresponds to the
the TCP port on which the server is running (where 5900+n = port
number). In this case, it is running on 5900+1=5901. Running vncserver a
second time will create a second instance running on the next highest,
free port, i.e :2 or 5902.

Note:Linux systems can have as many VNC servers as physical memory
allows -- all of which running in parallel to each other.

Shutdown the vncserver by using the -kill switch:

    $ vncserver -kill :1

Edit the xstartup File

Vncserver sources ~/.vnc/xstartup which functions like an .xinitrc file.
At a minimum, users should define a DE to start if a graphical
environment is desired. For example, starting xfce4:

    #!/bin/sh
    export XKL_XMODMAP_DISABLE=1
    exec startxfce4

Note:The XKL_XMODMAP_DISABLE line is known to correct problems
associated with "scrambled" keystrokes when typing in terminals under
some virtualized DEs.

Note:As of 31-Oct-2012, usage of the command "exec ck-launch-session
..." in ~/.vnc/xstartup is deprecated since Arch has dropped consolekit.

Permissions

It is good practice to secure ~/.vnc just like ~/.ssh although this is
not a requirement. Execute the following to do so:

    $ chmod 700 ~/.vnc

Running vncserver
-----------------

Vncserver offers flexibility via switches. The below example starts
vncserver in a specific resolution, allowing multiple users to
view/control simultaneously, and sets the dpi on the virtual server to
96:

    $ vncserver -geometry 1440x900 -alwaysshared -dpi 96 :1

Note:One need not use a standard monitor resolution for vncserver;
1440x900 can be replaced with something odd like 1429x882 or 1900x200
etc.

For a complete list of options, pass the -badoption switch to vncserver.

    $ vncserver -badoption

Connecting to vncserver
-----------------------

Any number of clients can connect to a vncserver. A simple example is
given below where vncserver is running on 10.1.10.2 on port 5901 (:1) in
shorthand notation:

    $ vncviewer 10.1.10.2:1

> Passwordless Authentication

The -passwd switch allows one to define the location of the server's
~/.vnc/passwd file. It is expected that the user has access to this file
on the server through ssh or through physical access. In either case,
place that file on the client's filesystem in a safe location, i.e. one
that has read access ONLY to the expected user.

    $ vncviewer -passwd /path/to/server-passwd-file

> Example GUI-based Clients

-   extra/gtk-vnc
-   extra/kdenetwork-krdc
-   extra/rdesktop
-   extra/vinagre
-   community/remmina
-   community/vncviewer-jar

Securing VNC Server by SSH Tunnels
----------------------------------

> On the Server

One wishing access to vncserver from outside the protection of a LAN
should be concerned about plain text passwords and unencrypted traffic
to/from the viewer and server. Vncserver is easily secured by ssh
tunneling. Additionally, one need not open up another port to the
outside using this method since the traffic is literally tunneled
through the SSH port which the user already has open to the WAN. It is
highly recommended to use the -localhost switch when running vncserver
in this scenario. This switch only allows connections from the localhost
-- and by analogy only by users physically ssh'ed and authenticated on
the box!

    $ vncserver -geometry 1440x900 -alwaysshared -dpi 96 -localhost :1

> On the Client

With the server now only accepting connection from the localhost,
connect to the box via ssh using the -L switch to enable tunnels. For
example:

    $ ssh IP_OF_TARGET_MACHINE -L 8900/localhost/5901

This forwards the server port 5901 to the client box on port 8900. Once
connected via SSH, leave that xterm or shell window open; it is acting
as a secured tunnel to/from server. To connect via vnc, open a second
xterm and connect not to the remote IP address, but to the localhost of
the client thus using the secured tunnel:

    $ vncviewer localhost:8900

From the ssh man page: -L [bind_address:] port:host:hostport

Specifies that the given port on the local (client) host is to be
forwarded to the given host and port on the remote side. This works by
allocating a socket to listen to port on the local side, optionally
bound to the specified bind_address. Whenever a connection is made to
this port, the connection is forwarded over the secure channel, and a
connection is made to host port hostport from the remote machine. Port
forwardings can also be specified in the configuration file. IPv6
addresses can be specified with an alternative syntax:

[bind_address/] port/host/ hostport or by enclosing the address in
square brackets. Only the superuser can forward privileged ports. By
default, the local port is bound in accordance with the GatewayPorts
setting. However, an explicit bind_address may be used to bind the
connection to a specific address. The bind_address of ``localhost''
indicates that the listening port be bound for local use only, while an
empty address or `*' indicates that the port should be available from
all interfaces.

> Connecting to a VNC Server from Android device over SSH

To connect to a VNC Server over SSH using your Android device you need:

    1. SSH server running on the machine you want to connect to.
    2. VNC server running on the machine you want to connect to. (You run server with -localhost flag as mentioned above)
    3. SSH client on your Android device (ConnectBot is a popular choice and will be used in this guide as an example).
    4. VNC client on your Android device (androidVNC).

Also, if you don't have static IP, you might want to consider some
dynamic DNS service.

In ConnectBot, type in your IP and connect to the desired machine. Tap
the options key, select Port Forwards and add a new port:

    Nickname: vnc
    Type: Local
    Source port: 5901
    Destination: 127.0.0.1:5901 (it didn't work for me when I typed in 192.168.x.xxx here, I had to use 127.0.0.1)

Save that.

In androidVNC:

    Nickname: nickname
    Password: the password you used to set up your VNC server
    Address: 127.0.0.1 (we are in local after connecting through SSH)
    Port: 5901

Connect.

Starting and Stopping VNC Server at Bootup and Shutdown
-------------------------------------------------------

You can find this file in /usr/lib/systemd/system/vncserver.service

    /etc/systemd/system/vncserver@:1.service

    # The vncserver service unit file
    #
    # 1. Copy this file to /etc/systemd/system/vncserver@:x.service
    #  Note that x is the port number on which the vncserver will run.  The default is 1 which 
    #  corresponds to port 5901.  For a 2nd instance, use x=2 which corresponds to port 5902.
    # 2. Edit User=
    #   ("User=foo")
    # 3. Edit  and vncserver parameters appropriately
    #   ("/usr/bin/vncserver %i -arg1 -arg2 -argn")
    # 4. Run `systemctl --system daemon-reload`
    # 5. Run `systemctl enable vncserver@:<display>.service`
    #
    # DO NOT RUN THIS SERVICE if your local area network is untrusted! 
    #
    # See the wiki page for more on security
    # https://wiki.archlinux.org/index.php/Vncserver

    [Unit]
    Description=Remote desktop service (VNC)
    After=syslog.target network.target

    [Service]
    Type=forking
    User=

    # Clean any existing files in /tmp/.X11-unix environment
    ExecStartPre=-/usr/bin/vncserver -kill %i
    ExecStart=/usr/bin/vncserver %i
    ExecStop=/usr/bin/vncserver -kill %i

    [Install]
    WantedBy=multi-user.target

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vncserver&oldid=254508"

Categories:

-   Security
-   Virtual Network Computing
