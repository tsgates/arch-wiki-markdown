Rdesktop
========

[rdesktop] is a free, open source client for Microsoft's proprietary RDP
protocol released under the GNU General Public License. Use rdesktop to
connect to Windows 2000/XP/Vista/Win7 RDP server to remotely
administrate the Windows box.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Installation                                                       |
| -   3 Usage                                                              |
| -   4 Automatic Scaling of Geometry                                      |
| -   5 remote desktop using netbios names instead of using IP address     |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Features
--------

As of July 2008, rdesktop implements a large subset of the RDP 5
protocol, including:

-   Bitmap caching
-   File system, audio, serial port and printer port redirection
-   Mappings for most international keyboards
-   Stream compression and encryption
-   Automatic authentication
-   Smartcard support
-   RemoteApp like support called "seamless" mode via SeamlessRDP

Still unimplemented are:

-   Remote Assistance requests
-   USB device redirection

Support for the additional features available in RDP 5.1 and RDP 6
(including multi-head display spanning and window composition) also have
not yet been implemented.

Installation
------------

The packages for rdesktop are available in the extra repo; to install
simply use pacman as you would any other package

    # pacman -S rdesktop

Usage
-----

For a complete listing of options see the rdesktop man page. Here is a
typical line

    $ rdesktop -g 1440x900 -P -z -x l -r sound:off -u windowsuser 98.180.102.33:3389

Reading form left to right:

  -------------------- ----------------------------------------------------------------------------------
  -g 1440x900          Sets the resolution of the display to 1440x900
  -P                   Enables bitmap caching/speeds up xfers.
  -z                   Enables RDP datastream compression
  -x l                 Uses the "lan" quality experience level, see the man page for additional options
  -r sound:off         Redirects sound generated on the server to null
  -u windowsuser       This defines the username to use when logging into the Windows box
  98.180.102.33:3389   This is the IP address and port number of the target machine
  -------------------- ----------------------------------------------------------------------------------

Automatic Scaling of Geometry
-----------------------------

In order to automatically scale the geometry to fit the screen, pass

    -g $(xrandr -q | awk '/Screen 0/ {print int($8/1.28) $9 int($10/1.2)}' | sed 's/,//g')

to the rdesktop command lines.

Another options is to use is to use the "-g" flag

     $ rdesktop -g 100% -P -z 98.180.102.33:3389

remote desktop using netbios names instead of using IP address
--------------------------------------------------------------

If you don't know the IP address of a windows computer in a network, you
have to enable wins support. To do so, you have to install samba.
Enabaling wins in samba is surprisingly easy: just edit the
/etc/samba/smb.conf and add the following line to it, or uncomment the
appropriate line:

wins support = yes

then you have to install winbind and edit the /etc/nsswitch.conf and add
the "wins" to the list of hosts.

restart smbd and nmbd services and test your success by pinging a
windows netbios host.

See also
--------

-   xrdp a daemon creating an RDP interface to the X server

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rdesktop&oldid=248106"

Category:

-   Remote Desktop Protocol
