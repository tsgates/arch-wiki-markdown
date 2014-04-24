Vncserver
=========

Related articles

-   x11vnc

Vncserver is a remote display daemon that allows users several remote
functionalities including:

1.  Direct control of the local X session(s) (i.e. X running on the
    physical monitor).
2.  Parallel X sessions that run in the background (i.e. not on the
    physical monitor but virtually) on a machine. All applications
    running under the server may continue to run, even when the user
    disconnects.

  

Contents
--------

-   1 Installation
-   2 Running Vncserver
    -   2.1 First time setup
        -   2.1.1 Create environment and password files
        -   2.1.2 Edit the xstartup File
        -   2.1.3 Permissions
    -   2.2 Starting the server
-   3 Running vncserver on physical display (5900 Port)
    -   3.1 Using TigerVNC's x0vncserver (Recommended)
    -   3.2 Using x11vnc (Recommended)
    -   3.3 Using a dirty hack (Not recommended)
        -   3.3.1 Basic configuration
        -   3.3.2 Patching xorg-server
-   4 Connecting to vncserver
    -   4.1 Passwordless authentication
    -   4.2 Example GUI-based clients
-   5 Securing VNC server by SSH tunnels
    -   5.1 On the server
    -   5.2 On the client
    -   5.3 Connecting to a VNC Server from Android device over SSH
-   6 Tips and Tricks
    -   6.1 Starting and Stopping VNC Server at Bootup and Shutdown
    -   6.2 Copying clipboard contents from the remote machine to the
        local
    -   6.3 Fix for no mouse cursor

Installation
------------

Vncserver is provided by tigervnc and also by tightvnc in the AUR.

Running Vncserver
-----------------

> First time setup

Create environment and password files

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

Note: The XKL_XMODMAP_DISABLE line is known to correct problems
associated with "scrambled" keystrokes when typing in terminals under
some virtualized DEs.

Permissions

It is good practice to secure ~/.vnc just like ~/.ssh although this is
not a requirement. Execute the following to do so:

    $ chmod 700 ~/.vnc

> Starting the server

Vncserver offers flexibility via switches. The below example starts
vncserver in a specific resolution, allowing multiple users to
view/control simultaneously, and sets the dpi on the virtual server to
96:

    $ vncserver -geometry 1440x900 -alwaysshared -dpi 96 :1

Note:One need not use a standard monitor resolution for vncserver;
1440x900 can be replaced with something odd like 1429x882 or 1900x200
etc.

For a complete list of options, pass the -help switch to vncserver.

    $ vncserver -help

Running vncserver on physical display (5900 Port)
-------------------------------------------------

> Using TigerVNC's x0vncserver (Recommended)

TigerVNC provides the x0vncserver binary which has similar functionality
to x11vnc e.g.

    x0vncserver -display :0 -passwordfile ~/.vnc/passwd

For more see

    man x0vncserver

> Using x11vnc (Recommended)

Use the x11vnc package if remote control of the physical display is
desired. For more, see X11vnc.

> Using a dirty hack (Not recommended)

Basic configuration

Install xorg-server and tigervnc, and and load "vnc" in Xorg
configuration.

e.g. /etc/X11/xorg.conf.d/10-vnc.conf:

    Section "Module"
      Load "vnc"
    EndSection

    Section "Screen"
      Identifier "Screen0"
      Option "SecurityTypes" "None"
    EndSection

For password authentication, after running vncpasswd command, replace
"Screen" section with below.

    Section "Screen"
      Identifier "Screen0"
      Option "SecurityTypes" "VncAuth"
      Option "UserPasswdVerifier" "VncAuth"
      Option "PasswordFile" "/root/.vnc/passwd"
    EndSection

Patching xorg-server

Unfortunately there is a bug with xorg-server package.(15/11/2013)
Luckily fedora has got a patch for this.

[http://pkgs.fedoraproject.org/cgit/xorg-x11-server.git/plain/0001-include-export-key_is_down-and-friends.patch?h=f19&id=06e94667faa0cd1f9f32cf54e9e447ef50fde635
]

Run abs command, place the patch file and edit the PKGBUILD.

PKGBUILD example:

    source = vnc.patch
    sha256sums = '1bbbe70236dc70b5e35572f2197d163637100f8c58d0038bdc240df075eb5726'
    prepare() {
      cd "${pkgbase}-${pkgver}"
      # patch for vnc module
      patch -Np1 -i ../vnc.patch

Patch (in case the link dies)

    +++ b/include/input.h
    @@ -244,12 +244,12 @@  typedef struct _InputAttributes {
     #define KEY_POSTED 2
     #define BUTTON_POSTED 2

    -extern void set_key_down(DeviceIntPtr
    diff --git a/include/input.h b/include/input.h
    index 350daba..2d5e531 100644
    --- a/include/input.h
    +++ b/include/input.h
    @@ -244,12 +244,12 @@  typedef struct _InputAttributes {
     #define KEY_POSTED 2
     #define BUTTON_POSTED 2

    -extern void set_key_down(DeviceIntPtr pDev, int key_code, int type);
    -extern void set_key_up(DeviceIntPtr pDev, int key_code, int type);
    -extern int key_is_down(DeviceIntPtr pDev, int key_code, int type);
    -extern void set_button_down(DeviceIntPtr pDev, int button, int type);
    -extern void set_button_up(DeviceIntPtr pDev, int button, int type);
    -extern int button_is_down(DeviceIntPtr pDev, int button, int type);
    +extern _X_EXPORT void set_key_down(DeviceIntPtr pDev, int key_code, int type);
    +extern _X_EXPORT void set_key_up(DeviceIntPtr pDev, int key_code, int type);
    +extern _X_EXPORT int key_is_down(DeviceIntPtr pDev, int key_code, int type);
    +extern _X_EXPORT void set_button_down(DeviceIntPtr pDev, int button, int type);
    +extern _X_EXPORT void set_button_up(DeviceIntPtr pDev, int button, int type);
    +extern _X_EXPORT int button_is_down(DeviceIntPtr pDev, int button, int type);

    extern void InitCoreDevices(void);
    extern void InitXTestDevices(void);

Connecting to vncserver
-----------------------

Any number of clients can connect to a vncserver. A simple example is
given below where vncserver is running on 10.1.10.2 on port 5901 (:1) in
shorthand notation:

    $ vncviewer 10.1.10.2:1

> Passwordless authentication

The -passwd switch allows one to define the location of the server's
~/.vnc/passwd file. It is expected that the user has access to this file
on the server through SSH or through physical access. In either case,
place that file on the client's file system in a safe location, i.e. one
that has read access ONLY to the expected user.

    $ vncviewer -passwd /path/to/server-passwd-file

> Example GUI-based clients

-   gtk-vnc
-   kdenetwork-krdc
-   rdesktop
-   vinagre
-   remmina
-   vncviewer-jar

Securing VNC server by SSH tunnels
----------------------------------

> On the server

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

> On the client

With the server now only accepting connection from the localhost,
connect to the box via ssh using the -L switch to enable tunnels. For
example:

    $ ssh IP_OF_TARGET_MACHINE -L 8900/localhost/5901

This forwards the server port 5901 to the client box on port 8900. Once
connected via SSH, leave that xterm or shell window open; it is acting
as a secured tunnel to/from server. To connect via vnc, open a second
xterm and connect not to the remote IP address, but to the localhost of
the client thus using the secured tunnel:

    $ vncviewer localhost::8900

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

To connect to a VNC Server over SSH using an Android device:

    1. SSH server running on the machine to connect to.
    2. VNC server running on the machine to connect to. (Run server with -localhost flag as mentioned above)
    3. SSH client on the Android device (ConnectBot is a popular choice and will be used in this guide as an example).
    4. VNC client on the Android device (androidVNC).

Consider some dynamic DNS service for targets that do not have static IP
addresses.

In ConnectBot, type in the IP and connect to the desired machine. Tap
the options key, select Port Forwards and add a new port:

    Nickname: vnc
    Type: Local
    Source port: 5901
    Destination: 127.0.0.1:5901 (it did not work for me when I typed in 192.168.x.xxx here, I had to use 127.0.0.1)

Save that.

In androidVNC:

    Nickname: nickname
    Password: the password used to set up the VNC server
    Address: 127.0.0.1 (we are in local after connecting through SSH)
    Port: 5901

Connect.

Tips and Tricks
---------------

> Starting and Stopping VNC Server at Bootup and Shutdown

Find this file at /usr/lib/systemd/system/vncserver.service

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

> Copying clipboard contents from the remote machine to the local

If copying from the remote machine to the local machine does not work,
run autocutsel on the server, as mentioned below [reference]:

    $ autocutsel -fork

Now press F8 to display the VNC menu popup, and select
Clipboard: local -> remote option.

One can put the above command in ~/.vnc/xstartup to have it run
automatically when vncserver is started.

> Fix for no mouse cursor

If no mouse cursor is visible when using x0vncserver, start vncviewer as
follows:

    $ vncviewer DotWhenNoCursor=1 <server>

Or put DotWhenNoCursor=1 in the tigervnc configuration file, which is at
~/.vnc/default.tigervnc by default.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vncserver&oldid=306063"

Categories:

-   Security
-   Remote Desktop

-   This page was last modified on 20 March 2014, at 17:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
