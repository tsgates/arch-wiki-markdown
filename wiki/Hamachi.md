Hamachi
=======

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Needs to be      
                           updated for Help:Style   
                           compliance. (Discuss)    
  ------------------------ ------------------------ ------------------------

Hamachi is a proprietary (closed source) commercial VPN software. With
Hamachi you can organize two or more computers with an Internet
connection into their own virtual network for direct secure
communication.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Set Up Tun                                                   |
|     -   2.2 Hamachi 2 (beta)                                             |
|         -   2.2.1 Using the hamachi command line tool as a regular user  |
|         -   2.2.2 Automatically setting a custom nickname                |
|                                                                          |
| -   3 Running Hamachi                                                    |
|     -   3.1 Systemd                                                      |
|                                                                          |
| -   4 GUI                                                                |
| -   5 Troubleshooting                                                    |
|     -   5.1 Hamachi times out soon after launch                          |
|     -   5.2 If you have problems connecting to some hosts                |
|     -   5.3 /etc/init.d/logmein-hamachi is not found                     |
|     -   5.4 Error when trying to run hamachi-init                        |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Version 2 of the Linux Hamachi client exists and is currently in beta.
It is available from the labs page on the Hamachi website; however, the
vendor's tarball requires LSB and will not install correctly. You should
use the logmein-hamachi package from the AUR instead.

Configuration
-------------

> Set Up Tun

Being as section above can only be applied for init.scripts, in order to
install the module, as root run:

    # modprobe tun

Then add tun to the list of modules by using your favorite text editor
and Create

    /etc/modules-load.d/tun.conf 

    #Load tun module at boot.
    tun

> Hamachi 2 (beta)

Hamachi 2 is configured in
/var/lib/logmein-hamachi/h2-engine-override.cfg (create that file if it
doesn't exist). Unfortunately, it isn't easy to find a comprehensive
list of possible configuration options, so here are a few that you can
use.

Using the hamachi command line tool as a regular user

In order to use the hamachi command line tool as a regular user, add the
following line to the configuration file:

    Ipc.User YourUserNameHere

Automatically setting a custom nickname

Normally, Hamachi uses your system's hostname as the nickname that other
Hamachi users will see. If you want to automatically set a custom
nickname every time Hamachi starts, add the following line to the
configuration file:

    Setup.AutoNick YourNicknameHere

You can also manually set a nickname using the hamachi command line
tool:

    # hamachi set-nick YourNicknameHere

However, this needs to be done every time Hamachi is (re-)started, so if
you always want to use the same nickname, setting it automatically (as
explained above) is probably easier.

Running Hamachi
---------------

Start up the (matt) daemon

    $hamachi start

or, if you use systemd

    #systemctl start logmein-hamachi

Now you have a whole bunch of commands at your disposal. These are in no
particular order and are fairly self explanatory.

    $hamachi set-nick bob
    $hamachi login
    $hamachi create my-net secretpassword
    $hamachi go-online my-net
    $hamachi list
    $hamachi go-offline my-net

To get a list of all the commands, run:

    $hamachi ?

Note: Make sure you change the status of the channel(s) you are in to
"online" if you want to perform any network actions on computers in
there.

> Systemd

The logmein-hamachi AUR package also includes a nice little Systemd
daemon.

If you feel like it, you can set Hamachi to start at every boot with
Systemd:

    systemctl enable logmein-hamachi

To start the Hamachi Daemon immediately, use this command:

    systemctl start logmein-hamachi

Note:If for some reason, hamachi doesn't have a Systemd daemon, you can
use one from here.

GUI
---

Various GUI frontends for Hamachi are available in the AUR.

For Hamachi 1:

-   haguichi (Gtk2, mono)
-   ghamachi (Gtk2)
-   hamachi-gui (Gtk2)

For Hamachi 2 (beta):

-   quamachi (Qt4)
-   haguichi (Gtk2, mono)

Troubleshooting
---------------

> Hamachi times out soon after launch

If hamachi stops working after a short period of time it can be that the
client is timing out. Create ~/.hamachi/config and add the following to
it:

    KeepAlive 10

> If you have problems connecting to some hosts

Check if they are using Hamachi 2. If that is the case, then it is a
known issue with the Hamachi 2 client connecting to the Hamachi Linux
client.

> /etc/init.d/logmein-hamachi is not found

Replace that path with /etc/rc.d/logmein-hamachi.

> Error when trying to run hamachi-init

If there is an error while trying to load libstdc++.so.5, you want to
install it. This library can be found in the extra repository, so you
can install it by running pacman -S libstdc++5.

If you get an error while trying to load libcrypto.so.0.9.7, a temporary
solution is to create a link from /usr/lib/libcrypto.so.0.9.7 to
/usr/lib/libcrypto.so by running
ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.0.9.7.

See also
--------

-   Project home page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hamachi&oldid=253792"

Category:

-   Virtual Private Network
