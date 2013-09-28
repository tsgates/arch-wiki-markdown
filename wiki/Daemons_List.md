Daemons List
============

Here is a list of daemons. Note that any package can provide a daemon,
so this list will never be complete. Please feel free to add any missing
daemons here, in alphabetical order. You may have packages that include
other daemons from the AUR. These files will likely be located in
/usr/lib/systemd/system/.

For each daemon the name of the script (for initscripts) and of the
service (for systemd) is given.

+--------------------------+--------------------------+--------------------------+
| initscripts              | systemd                  | Description              |
+==========================+==========================+==========================+
| acpid                    | acpid.service            | A daemon for delivering  |
|                          |                          | ACPI power management    |
|                          |                          | events with netlink      |
|                          |                          | support.                 |
+--------------------------+--------------------------+--------------------------+
| alsa                     | always on –              | An alternative           |
|                          | alsa-store.service,      | implementation of Linux  |
|                          | alsa-restore.service     | sound support.           |
+--------------------------+--------------------------+--------------------------+
| atd                      | atd.service              | Run jobs queued for      |
|                          |                          | later execution.         |
+--------------------------+--------------------------+--------------------------+
| autofs                   | autofs.service           | A package that provides  |
|                          |                          | support for automounting |
|                          |                          | removable media or       |
|                          |                          | network shares when they |
|                          |                          | are inserted or          |
|                          |                          | accessed.                |
+--------------------------+--------------------------+--------------------------+
| avahi-daemon             | avahi-daemon.service     | Allows programs to       |
|                          |                          | automatically find local |
|                          |                          | network services.        |
+--------------------------+--------------------------+--------------------------+
| avahi-dnsconfd           | avahi-dnsconfd.service   | Multicast/unicast DNS-SD |
|                          |                          | framework.               |
+--------------------------+--------------------------+--------------------------+
| bitlbee                  | bitlbee.service          | Brings instant messaging |
|                          |                          | (XMPP, MSN, Yahoo!, AIM, |
|                          |                          | ICQ, Twitter) to IRC.    |
+--------------------------+--------------------------+--------------------------+
| bluetooth                | bluetooth.service        | Bluetooth protocol       |
|                          |                          | stack, framework,        |
|                          |                          | subsystem.               |
+--------------------------+--------------------------+--------------------------+
| cdemud                   | cdemu-daemon.service     | CD/DVD-ROM device        |
|                          |                          | emulator.                |
+--------------------------+--------------------------+--------------------------+
| connmand                 | connman.service          | Wireless LAN network     |
|                          |                          | manager.                 |
+--------------------------+--------------------------+--------------------------+
| chrony                   | chrony.service           | Lightweight NTP client   |
|                          |                          | and server.              |
+--------------------------+--------------------------+--------------------------+
| clamav                   | clamd.service            | Anti-virus toolkit for   |
|                          | freshclamd.service       | Unix.                    |
+--------------------------+--------------------------+--------------------------+
| cpupower                 | cpupower.service         | Linux kernel tool to     |
|                          |                          | examine and tune power   |
|                          |                          | saving related features  |
|                          |                          | of processor.            |
+--------------------------+--------------------------+--------------------------+
| craftbukkit              | not yet implemented      | CraftBukkit Minecraft    |
|                          |                          | server                   |
+--------------------------+--------------------------+--------------------------+
| crond                    | cronie.service (if using | Daemon to schedule and   |
|                          | cronie) or dcron.service | time events. The daemon  |
|                          | (if using dcron)         | name crond is used by at |
|                          |                          | least two packages,      |
|                          |                          | cronie and dcron.        |
+--------------------------+--------------------------+--------------------------+
| cupsd                    | cups.service             | The CUPS Printing System |
|                          |                          | daemon.                  |
+--------------------------+--------------------------+--------------------------+
| dbus                     | always on – dbus.service | Freedesktop.org message  |
|                          |                          | bus system.              |
+--------------------------+--------------------------+--------------------------+
| dcron                    | dcron.service            | Daemon to schedule and   |
|                          |                          | time events. The daemon  |
|                          |                          | name crond is used by at |
|                          |                          | least two packages,      |
|                          |                          | cronie and dcron. cronie |
|                          |                          | is the default cron      |
|                          |                          | implementation for Arch. |
+--------------------------+--------------------------+--------------------------+
| sockd                    | sockd.service            | A circuit-level SOCKS    |
|                          |                          | client/server.           |
+--------------------------+--------------------------+--------------------------+
| deluged                  | deluged.service          | Cross-platform and       |
|                          |                          | full-featured BitTorrent |
|                          |                          | client.                  |
+--------------------------+--------------------------+--------------------------+
| deluge-web               | deluge-web.service       | A BitTorrent client with |
|                          |                          | multiple user interfaces |
|                          |                          | in a client/server       |
|                          |                          | model.                   |
+--------------------------+--------------------------+--------------------------+
| dhcpcd                   | dhcpcd@.service          | DHCP daemon. Insert the  |
|                          |                          | network interface after  |
|                          |                          | @                        |
|                          |                          | ('dhcpcd@eth0.service'). |
+--------------------------+--------------------------+--------------------------+
| dovecot                  | dovecot.service          | IMAP and POP3 server.    |
+--------------------------+--------------------------+--------------------------+
| dropboxd                 | not yet implemented      | Cross-platform file      |
|                          |                          | synchronisation with     |
|                          |                          | version control.         |
+--------------------------+--------------------------+--------------------------+
| fail2ban                 | fail2ban.service         | Fail2ban scans log files |
|                          |                          | and bans IPs that show   |
|                          |                          | the malicious signs.     |
+--------------------------+--------------------------+--------------------------+
| fam                      | deprecated               | File Alteration Monitor. |
|                          |                          | (deprecated)             |
+--------------------------+--------------------------+--------------------------+
| fancontrol               | fancontrol.service       | Fan control daemon (part |
|                          |                          | of lm_sensors)           |
+--------------------------+--------------------------+--------------------------+
| fbsplash                 | not yet implemented      | Graphical boot splash    |
|                          |                          | screen for the user.     |
+--------------------------+--------------------------+--------------------------+
| fluidsynth               | fluidsynth.service       | Software synthesizer     |
+--------------------------+--------------------------+--------------------------+
| ftpd                     | ftpd.service             | Inetutils ftp daemon     |
+--------------------------+--------------------------+--------------------------+
| gdm                      | gdm.service              | Gnome Display Manager    |
|                          |                          | (Login Screen)           |
+--------------------------+--------------------------+--------------------------+
| git-daemon               | git-daemon.socket        | GIT daemon               |
+--------------------------+--------------------------+--------------------------+
| gpm                      | gpm.service              | Console mouse support.   |
+--------------------------+--------------------------+--------------------------+
| hal                      | obsolete                 | Hardware Abstraction     |
|                          |                          | Layer. (Deprecated)      |
+--------------------------+--------------------------+--------------------------+
| hddtemp                  | hddtemp.service          | Hard drive temperature   |
|                          |                          | monitor daemon           |
+--------------------------+--------------------------+--------------------------+
| healthd                  | healthd.service          | A daemon which can be    |
|                          |                          | used to alert you in the |
|                          |                          | event of a hardware      |
|                          |                          | health monitoring alarm  |
|                          |                          | (part of lm_sensors).    |
+--------------------------+--------------------------+--------------------------+
| httpd                    | httpd.service            | Apache HTTP Server (Web  |
|                          |                          | Server)                  |
+--------------------------+--------------------------+--------------------------+
| hwclock                  |                          | Not a daemon as such,    |
|                          |                          | but on shutdown, updates |
|                          |                          | hwclock to compensate    |
|                          |                          | for drift. Only run this |
|                          |                          | daemon if ntpd is not    |
|                          |                          | running as both daemons  |
|                          |                          | adjust the hardware      |
|                          |                          | clock.                   |
+--------------------------+--------------------------+--------------------------+
| i8kmon                   | i8kmon.service           | Monitor the cpu          |
|                          |                          | temperature and fan      |
|                          |                          | status on Dell Inspiron  |
|                          |                          | laptops.                 |
+--------------------------+--------------------------+--------------------------+
| ifplugd                  | ifplugd@<interface>.serv | Start/stop network on    |
|                          | ice,                     | network cable plugged    |
|                          | ie: ifplugd@eth0.service | in/out.                  |
+--------------------------+--------------------------+--------------------------+
| iptables                 | iptables.service         | Load firewall rules.     |
+--------------------------+--------------------------+--------------------------+
| ip6tables                | ip6tables.service        | Load firewall rules for  |
|                          |                          | ipv6.                    |
+--------------------------+--------------------------+--------------------------+
| irqbalance               | irqbalance.service       | Irqbalance is the Linux  |
|                          |                          | utility tasked with      |
|                          |                          | making sure that         |
|                          |                          | interrupts from your     |
|                          |                          | hardware devices are     |
|                          |                          | handled in as efficient  |
|                          |                          | a manner as possible.    |
+--------------------------+--------------------------+--------------------------+
| kdm                      | kdm.service              | KDE Display Manager      |
|                          |                          | (Graphical Login)        |
+--------------------------+--------------------------+--------------------------+
| krb5-kadmind             | krb5-kadmind.service     | Kerberos 5               |
|                          |                          | administration server    |
+--------------------------+--------------------------+--------------------------+
| krb5-kdc                 | krb5-kdc.service         | Kerberos 5 KDC           |
+--------------------------+--------------------------+--------------------------+
| krb5-kpropd              | krb5-kpropd.service      | Kerberos 5 propagation   |
|                          |                          | server                   |
+--------------------------+--------------------------+--------------------------+
| laptop-mode              | laptop-mode.service      | Laptop Power Saving      |
|                          |                          | Tools                    |
+--------------------------+--------------------------+--------------------------+
| lighttpd                 | lighttpd.service         | Lighttpd HTTP Server     |
|                          |                          | (Web Server).            |
+--------------------------+--------------------------+--------------------------+
| libvirt                  | libvirtd.service         | libvirt is a             |
|                          |                          | virtualization API and a |
|                          |                          | daemon for managing      |
|                          |                          | virtual machines (VMs).  |
+--------------------------+--------------------------+--------------------------+
| lxdm                     | lxdm.service             | LXDE Display Manager     |
|                          |                          | (Graphical Login)        |
+--------------------------+--------------------------+--------------------------+
| mdadm                    | mdadm.service            | MD Administration (Linux |
|                          |                          | Software RAID).          |
+--------------------------+--------------------------+--------------------------+
| miniDLNA                 | minidlna.service         | simple DLNA/UPnP media   |
|                          |                          | server                   |
+--------------------------+--------------------------+--------------------------+
| ?                        | ModemManager.service     | Makes Mobile broadband   |
|                          |                          | (3G) modem available to  |
|                          |                          | NetworkManager           |
+--------------------------+--------------------------+--------------------------+
| mpd                      | mpd.service              | Music Player Daemon.     |
+--------------------------+--------------------------+--------------------------+
| mysqld                   | mysqld.service           | MySQL database server.   |
+--------------------------+--------------------------+--------------------------+
| mythbackend              | mythbackend.service      | Backend for the MythTV   |
|                          |                          | digital video            |
|                          |                          | recording/home theater   |
|                          |                          | software.                |
+--------------------------+--------------------------+--------------------------+
| named                    | named.service            | The Berkeley Internet    |
|                          |                          | Name Daemon (BIND) DNS   |
|                          |                          | server.                  |
+--------------------------+--------------------------+--------------------------+
| netfs                    | unused, handled          | Mounts network file      |
|                          | automatically, see       | systems.                 |
|                          | remote-fs.target to      |                          |
|                          | manually execute scripts |                          |
+--------------------------+--------------------------+--------------------------+
| net-auto-wired           | net-auto-wired.service   | Netcfg replacement for   |
|                          |                          | network - connects to    |
|                          |                          | wired network            |
+--------------------------+--------------------------+--------------------------+
| net-auto-wireless        | net-auto-wireless.servic | Netcfg replacement for   |
|                          | e                        | network - connects to    |
|                          |                          | wireless network         |
+--------------------------+--------------------------+--------------------------+
| net-profiles             | netcfg.service           | Netcfg replacement for   |
|                          | netcfg@<profile-name>.se | network - connects to    |
|                          | rvice                    | profiles                 |
+--------------------------+--------------------------+--------------------------+
| network                  | (dynamic Ethernet)       | To bring up the network  |
|                          | dhcpcd@<interface>.servi | connections.             |
|                          | ce                       |                          |
+--------------------------+--------------------------+--------------------------+
| networkmanager           | NetworkManager.service   | Replaces network, and    |
|                          | NetworkManager-wait-onli | provides configuration   |
|                          | ne.service               | and detection for        |
|                          |                          | automatic network        |
|                          |                          | connections.             |
+--------------------------+--------------------------+--------------------------+
| nginx                    | nginx.service            | Nginx HTTP Server and    |
|                          |                          | IMAP/POP3 proxy server   |
|                          |                          | (Web Server)             |
+--------------------------+--------------------------+--------------------------+
| nscd                     | nscd.service             | Name service cache       |
|                          |                          | daemon                   |
+--------------------------+--------------------------+--------------------------+
| ntpd                     | ntpd.service             | Network Time Protocol    |
|                          |                          | daemon (client and       |
|                          |                          | server).                 |
+--------------------------+--------------------------+--------------------------+
| Ntop                     | ntop.service             | Ntop is a network        |
|                          |                          | traffic probe based on   |
|                          |                          | libcap.                  |
+--------------------------+--------------------------+--------------------------+
| openntpd                 | openntpd.service         | alternate Network Time   |
|                          |                          | Protocol daemon (client  |
|                          |                          | and server).             |
+--------------------------+--------------------------+--------------------------+
| osspd                    | osspd.service            | OSS Userspace Bridge.    |
+--------------------------+--------------------------+--------------------------+
| openvpn                  | openvpn@<profile-name>.s | One for each vpn conf    |
|                          | ervice                   | file saved like          |
|                          |                          | /etc/openvpn/<profile-na |
|                          |                          | me>.conf                 |
+--------------------------+--------------------------+--------------------------+
| pdnsd                    | pdnsd.service            | Proxy DNS server with    |
|                          |                          | permanent caching.       |
+--------------------------+--------------------------+--------------------------+
| php-fpm                  | php-fpm.service          | FastCGI Process Manager  |
|                          |                          | for PHP                  |
+--------------------------+--------------------------+--------------------------+
| oss                      | oss.service              | Open Sound System.       |
|                          |                          | Alternative to ALSA.     |
+--------------------------+--------------------------+--------------------------+
| postgresql               | postgresql.service       | PostgreSQL database      |
|                          |                          | server.                  |
+--------------------------+--------------------------+--------------------------+
| postfix                  | postfix.service          |                          |
+--------------------------+--------------------------+--------------------------+
| powernowd                | not yet implemented      | To adjust speed of CPU   |
|                          |                          | depending on system      |
|                          |                          | load. See also CPU       |
|                          |                          | Frequency Scaling        |
+--------------------------+--------------------------+--------------------------+
| pptpd                    | pptpd.service            | A Virtual Private        |
|                          |                          | Network (VPN) server     |
|                          |                          | using the Point-to-Point |
|                          |                          | Tunneling Protocol       |
|                          |                          | (PPTP).                  |
+--------------------------+--------------------------+--------------------------+
| prosody                  | prosody.service          | XMPP server.             |
+--------------------------+--------------------------+--------------------------+
| Pppd                     | ppp@provider.service     | A daemon which           |
|                          |                          | implements the           |
|                          |                          | Point-to-Point Protocol  |
|                          |                          | for dial-up networking.  |
+--------------------------+--------------------------+--------------------------+
| preload                  | preload.service          | Makes applications run   |
|                          |                          | faster by prefetching    |
|                          |                          | binaries and shared      |
|                          |                          | objects.                 |
+--------------------------+--------------------------+--------------------------+
| psd                      | psd.service              | Manages your browser's   |
|                          |                          | profile in tmpfs and     |
|                          |                          | periodically sync it     |
|                          |                          | back to your physical    |
|                          |                          | disk.                    |
+--------------------------+--------------------------+--------------------------+
| pure-ftpd                | pure-ftpd.service        | A fast, production       |
|                          |                          | quality,                 |
|                          |                          | standards-conformant FTP |
|                          |                          | server.                  |
+--------------------------+--------------------------+--------------------------+
| readahead                | systemd-readahead-collec | Readahead for faster     |
|                          | t.service                | boot                     |
|                          | systemd-readahead-done.s |                          |
|                          | ervice                   |                          |
|                          |                          |                          |
|                          | systemd-readahead-drop.s |                          |
|                          | ervice                   |                          |
|                          |                          |                          |
|                          | systemd-readahead-replay |                          |
|                          | .service                 |                          |
+--------------------------+--------------------------+--------------------------+
| rfkill                   | rfkill-block@.service    | (Un)block radio devices. |
|                          | rfkill-unblock@.service  | A block@all or           |
|                          |                          | unblock@all instance     |
|                          |                          | (not to be enabled       |
|                          |                          | simultaneously) is       |
|                          |                          | started before any       |
|                          |                          | unblock@device or        |
|                          |                          | block@device,            |
|                          |                          | respectively.            |
+--------------------------+--------------------------+--------------------------+
| rsyncd                   | rsyncd.service           | Rsync daemon.            |
+--------------------------+--------------------------+--------------------------+
| rsyslogd                 | rsyslog.service          | The latest version of a  |
|                          |                          | system logger.           |
+--------------------------+--------------------------+--------------------------+
| samba                    | smbd.service             | File and print services  |
|                          | nmbd.service             | for Microsoft Windows    |
|                          |                          | clients.                 |
|                          | winbindd.service         |                          |
+--------------------------+--------------------------+--------------------------+
| saned                    | saned@.service           | To share the scanner     |
|                          |                          | system over network.     |
+--------------------------+--------------------------+--------------------------+
| saslauthd                | saslauthd.service        | SASL authentication      |
|                          |                          | daemon                   |
+--------------------------+--------------------------+--------------------------+
| sensord                  | sensord.service          | Sensor information       |
|                          |                          | logging daemon (part of  |
|                          |                          | lm_sensors)              |
+--------------------------+--------------------------+--------------------------+
| sensors                  | lm_sensors.service       | Hardware (temperature,   |
|                          |                          | fans etc) monitoring.    |
+--------------------------+--------------------------+--------------------------+
| slim                     | slim.service             | Simple Login Manager     |
+--------------------------+--------------------------+--------------------------+
| smartd                   | smartd.service           | Self-Monitoring,         |
|                          |                          | Analysis, and Reporting  |
|                          |                          | Technology (S.M.A.R.T)   |
|                          |                          | Hard Disk Monitoring     |
+--------------------------+--------------------------+--------------------------+
| smbnetfs                 | smbnetfs.service         | To automatically mount   |
|                          |                          | Samba/Microsoft network  |
|                          |                          | shares.                  |
+--------------------------+--------------------------+--------------------------+
| snmpd                    | snmpd.service            | A suite of applications  |
|                          |                          | used to implement SNMP   |
+--------------------------+--------------------------+--------------------------+
| soundmodem               | not yet implemented      | Multiplatform Soundcard  |
|                          |                          | Packet Radio Modem       |
+--------------------------+--------------------------+--------------------------+
| spamd                    | spamassassin.service     | e-mail spam filtering    |
|                          |                          | service.                 |
+--------------------------+--------------------------+--------------------------+
| sshd                     | sshd.service (permanent) | OpenSSH (secure shell)   |
|                          | sshd.socket (on-demand)  | daemon.                  |
+--------------------------+--------------------------+--------------------------+
| stunnel                  | stunnel.service          | Allows encrypting        |
|                          |                          | arbitrary TCP            |
|                          |                          | connections inside SSL.  |
+--------------------------+--------------------------+--------------------------+
| svnserve                 | svnserve.service         | Subversion server        |
+--------------------------+--------------------------+--------------------------+
| syslogd                  | deprecated               | This was the older and   |
|                          |                          | basic system logger.     |
+--------------------------+--------------------------+--------------------------+
| syslog-ng                | syslog-ng.service        | System logger next       |
|                          |                          | generation.              |
+--------------------------+--------------------------+--------------------------+
| timidity++               | timidity.service         | Software synthesizer for |
|                          |                          | MIDI.                    |
+--------------------------+--------------------------+--------------------------+
| tor                      | tor.service              | Onion routing for        |
|                          |                          | anonymous communication. |
+--------------------------+--------------------------+--------------------------+
| transmissiond            | transmission.service     | Bit Torrent Daemon.      |
+--------------------------+--------------------------+--------------------------+
| ufw                      | ufw.service              | Uncomplicated FireWall.  |
+--------------------------+--------------------------+--------------------------+
| vboxservice              | vboxservice.service      | VirtualBox Guest Service |
+--------------------------+--------------------------+--------------------------+
| vnStat                   | vnstat.service           | Lightweight network      |
|                          |                          | traffic monitor          |
+--------------------------+--------------------------+--------------------------+
| vsftpd                   | vsftpd.service           | FTP server.              |
|                          | (permanent)              |                          |
|                          | vsftpd.socket            |                          |
|                          | (on-demand)              |                          |
|                          |                          |                          |
|                          | vsftpd-ssl.service       |                          |
|                          | (permanent)              |                          |
|                          |                          |                          |
|                          | vsftpd-ssl.socket        |                          |
|                          | (on-demand)              |                          |
+--------------------------+--------------------------+--------------------------+
| wicd                     | wicd.service             | Combine with dbus to     |
|                          |                          | replace network, a       |
|                          |                          | lightweight alternative  |
|                          |                          | to NetworkManager.       |
+--------------------------+--------------------------+--------------------------+
| x11vnc                   | x11vnc.service           | VNC remote desktop       |
|                          |                          | daemon                   |
+--------------------------+--------------------------+--------------------------+
| xdm                      | xdm.service              | X display manager        |
+--------------------------+--------------------------+--------------------------+
| xdm-archlinux            | xdm-archlinux.service    | X display manager with   |
|                          |                          | Arch Linux theme         |
+--------------------------+--------------------------+--------------------------+

Retrieved from
"https://wiki.archlinux.org/index.php?title=Daemons_List&oldid=255228"

Categories:

-   Boot process
-   Daemons and system services
