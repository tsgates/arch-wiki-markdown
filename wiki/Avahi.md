Avahi
=====

Avahi is a free Zero Configuration Networking (Zeroconf) implementation,
including a system for multicast DNS/DNS-SD service discovery. It allows
programs to publish and discover services and hosts running on a local
network with no specific configuration. For example you can plug into a
network and instantly find printers to print to, files to look at and
people to talk to. It is licensed under the GNU Lesser General Public
License (LGPL). (Source: Wikipedia:Avahi (software))

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Enable Avahi daemon under sysvinit system                    |
|     -   1.2 Enable Avahi daemon under native systemd system              |
|                                                                          |
| -   2 Using Avahi                                                        |
|     -   2.1 Obtaining IPv4LL IP address                                  |
|     -   2.2 Hostname resolution                                          |
|     -   2.3 File sharing                                                 |
|         -   2.3.1 NFS                                                    |
|         -   2.3.2 Samba                                                  |
|         -   2.3.3 GShare                                                 |
|         -   2.3.4 Vsftpd                                                 |
|         -   2.3.5 Giver                                                  |
|                                                                          |
|     -   2.4 Link-Local (Bonjour/Zeroconf) chat                           |
|         -   2.4.1 Gajim                                                  |
|         -   2.4.2 Pidgin                                                 |
|         -   2.4.3 Kopete                                                 |
|         -   2.4.4 Telepathy                                              |
|                                                                          |
|     -   2.5 Airprint from Mobile Devices                                 |
|     -   2.6 Firewall                                                     |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install avahi and nss-mdns, available in the official repositories.

    # pacman -S avahi nss-mdns

> Enable Avahi daemon under sysvinit system

After installing Avahi you will need to restart the dbus daemon before
you can start avahi-daemon.

Note:avahi-daemon depends on dbus daemon, so it should be added after
dbus in the DAEMONS array in rc.conf file

> Enable Avahi daemon under native systemd system

You can enable Avahi Daemon at startup with the following command:

    # systemctl enable avahi-daemon.service

Using Avahi
-----------

> Obtaining IPv4LL IP address

By default, if you are getting IP using DHCP, you are using dhcpcd
package. It can attempt to obtain an IPv4LL address if it failed to get
one via DHCP. By default this option is disabled. To enable it, comment
noipv4ll string:

    /etc/dhcpcd.conf

    ...
    #noipv4ll
    ...

Alternatively, run avahi-autoipd, included in avahi package:

    # avahi-autoipd -D

> Hostname resolution

Avahi also allows you to access computers using their hostnames. Note:
you must install nss-mdns for this to work.

Suppose you have machines with names maple, fig and oak, all running
avahi. Avahi can be set up so that you do not have to manage a
/etc/hosts file for each computer. Instead you can simply use
maple.local to access whatever services maple has. However by default,
.local querying is disabled in Arch Linux. To enable it edit the file
/etc/nsswitch.conf and change the line:

    hosts: files dns

to

    hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4

Some users have noticed a slowdown in DNS querying; it was attributed to
this change. (Reference: Ubuntu Bug 94940). Using the following line
instead (omit mdns4) solves the problem.

    hosts: files mdns4_minimal [NOTFOUND=return] dns

Avahi includes several utilities which help you discover the services
running on a network. For example, run

    avahi-browse -alr

to discover services in your network.

The avahi-discover (Avahi Zeroconf Browser) shows the various services
on your network. You can also browse SSH and VNC Servers using bssh and
bvnc respectively.

There's a good list of software with Avahi support at their website:
http://avahi.org/wiki/Avah4users

Note:avahi-discover needs pygtk and python-dbus to be installed.

> File sharing

NFS

If you have an NFS share set up, you can use Avahi to be able to
automount them in Zeroconf-enabled browsers (such as Konqueror on KDE
and Finder on Mac OS X). Create a .service file in /etc/avahi/services
with the following:

    /etc/avahi/services/nfs_Zephyrus_Music.service

     <?xml version="1.0" standalone='no'?>
     <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
     <service-group>
       <name replace-wildcards="yes">NFS Music Share on %h</name>
       <service>
         <type>_nfs._tcp</type>
         <port>2049</port>
         <txt-record>path=/data/shared/Music</txt-record>
       </service>
     </service-group>

The port is correct if you have insecure as an option in your
/etc/exports; otherwise, it needs to be changed (note that insecure is
needed for OS X clients). The path is the path to your export, or a
subdirectory of it. For some reason the automount functionality has been
removed from Leopard, however a script is available. This was based upon
this post.

Samba

Note:samba package from extra repository build without an avahi suuport.

    /etc/avahi/services/smb.service

     <?xml version="1.0" standalone='no'?>
     <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
     <service-group>
        <name replace-wildcards="yes">Samba Shares on %h</name>
        <service>
            <type>_smb._tcp</type>
            <port>139</port>
        </service>
     </service-group>

Note:If you are trying to connect with OS X Lion the port needs to be
445, not 139.

GShare

You can grab gshare from the Arch User Repository and have shared files
between the LAN, with no configuration, no hours in samba hacking, no
nothing - it just works.

Vsftpd

Sourced from ubuntuforums.org. If you would rather use a regular ftp
service, install vsftpd and avahi. Change the settings of vsftpd
according to what is shown on the ubuntuforums page or according to your
own personal preferences (See 'man vsftpd.conf).

Create a ftp.service file in /etc/avahi/services and paste in that file

    <?xml version="1.0" standalone='no'?>
       <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
       <service-group>
       <name>FTP file sharing</name>
       <service>
       <type>_ftp._tcp</type>
       <port>21</port>
       </service>
       </service-group>

When you are done, (re)start avahi-daemon and vsftpd in your /etc/rc.d
directory.

    /etc/rc.d/avahi-daemon restart
    /etc/rc.d/vsftpd restart

After that you should be able to browse through the ftp server from
another computer in your network. The steps shown in this section are
created so that the ftp server is 'advertised' by avahi to the local
Zeroconf network.

Unless you are using GNOME or KDE, you might not be able to log in to
the ftp server directly through your file manager, and so you will have
to use a ftp client pointed to the IP address of the server or the
hostname of the machine (as shown in this section).

Giver

Giver is a mono program that allows simple file-sharing between two
desktops when both are running Giver. All you need to do is click and
drag the file to the name or picture of the person you wish to send the
file to.

A package is on the AUR.

Note that this depends on gnome-sharp, which has heavy GNOME
dependencies.

> Link-Local (Bonjour/Zeroconf) chat

Avahi can be used for bonjour protocol support under linux. The
following chat clients support link-local chat.

Gajim

Gajim is a Jabber/XMPP instant messenger client written in PyGTK. In the
accounts setup just enable "Local" account.

Pidgin

Pidgin is an instant messaging client that supports quite a few commonly
used IM protocols. In addition to these, it supports Bonjour.

Just select 'Bonjour' as the protocol type when you add an account, and
enter a username. The first and last name you enter in the 'Advanced'
tab will be what the other person (whom you are chatting with) sees, and
'local alias' under 'User Options' in the 'Basic' tab will be what you
see of your own name (you could try putting in something like I, me or
myself).

Once this is done, other Pidgin (iChat) users who are on the local
network will see you and be able to chat with you. To implement
file-sharing, you just send and receive files like you would do with a
regular IM session.

Kopete

Kopete is the KDE equivalent of Pidgin. It supports the
Bonjour/Link-local XMPP protocol. One need to create an account in
Kopete, by simply entering the desired name.

Telepathy

Telpathy is a communication framework which supports different protocols
using plugins. The telepathy-salut plugin provides support for
Bonjour/Link-Local XMPP protocol. Empathy is a GNOME front-end to
Telepathy. Officially, KDE does not support Telepathy, but work is going
on which will eventually replace Kopete. KDE Telepathy is available in
extra.

> Airprint from Mobile Devices

Avahi along with CUPS also provides the capability to print to just
about any printer from airprint compatible mobile devices. In order to
enable print capability from your device, simply create an avahi service
file for your printer in /etc/avahi/services and restart avahi. An
example of a generic services file for an HP-Laserjet printer would be
similar to the following with the name, rp, ty, adminurl and note fields
changed. Save the file as /etc/avahi/services/youFileName.service:

     <?xml version="1.0" standalone='no'?>
     <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
     <service-group>
       <name>yourPrnterName</name>
       <service>
         <type>_ipp._tcp</type>
         <subtype>_universal._sub._ipp._tcp</subtype>
         <port>631</port>
         <txt-record>txtver=1</txt-record>
         <txt-record>qtotal=1</txt-record>
         <txt-record>rp=printers/yourPrnterName</txt-record>
         <txt-record>ty=yourPrnterName</txt-record>
         <txt-record>adminurl=http://198.168.7.15:631/printers/yourPrnterName</txt-record>
         <txt-record>note=Office Laserjet 4100n</txt-record>
         <txt-record>priority=0</txt-record>
         <txt-record>product=virtual Printer</txt-record>
         <txt-record>printer-state=3</txt-record>
         <txt-record>printer-type=0x801046</txt-record>
         <txt-record>Transparent=T</txt-record>
         <txt-record>Binary=T</txt-record>
         <txt-record>Fax=F</txt-record>
         <txt-record>Color=T</txt-record>
         <txt-record>Duplex=T</txt-record>
         <txt-record>Staple=F</txt-record>
         <txt-record>Copies=T</txt-record>
         <txt-record>Collate=F</txt-record>
         <txt-record>Punch=F</txt-record>
         <txt-record>Bind=F</txt-record>
         <txt-record>Sort=F</txt-record>
         <txt-record>Scan=F</txt-record>
         <txt-record>pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf</txt-record>
         <txt-record>URF=W8,SRGB24,CP1,RS600</txt-record>
       </service>
     </service-group>

Alternatively,
https://raw.github.com/tjfontaine/airprint-generate/master/airprint-generate.py
can be used to generate Avahi service files. It depends on python2 and
pycups. The script can be run using:

    # python2 airprint-generate.py -d /etc/avahi/services

> Firewall

Be sure to open UDP port 5353 if you're using iptables:

     # iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT

If you're following the more-than-useful Simple Stateful Firewall format
for your firewall:

     # iptables -A UDP -p udp -m udp --dport 5353 -j ACCEPT

See also
--------

-   Avahi - Official project website
-   Wikipedia entry
-   Bonjour for Windows - Enable Zeroconf on Windows
-   http://www.zeroconf.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Avahi&oldid=254983"

Category:

-   Networking
