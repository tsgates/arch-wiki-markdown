Daemons List
============

Here is a list of daemons. Note that any package can provide a daemon,
so this list will never be complete. Please feel free to add any missing
daemons here, in alphabetical order. You may have packages that include
other daemons from the AUR. These files will likely be located in
/usr/lib/systemd/system/.

The Package column contains a link to ArchWiki page for each daemon (or
link to the package if no such page exists). The initscripts column
contains the name of the script for initscripts and the systemd column
contains the name of the systemd service file. Note that there may be
daemons specific to either initscripts or systemd, with the respective
column empty. The Description column provides short description,
preferably of the daemon (not of the package).

Package

initscripts

systemd

Description

acpid

acpid

acpid.service

A daemon for delivering ACPI power management events with netlink
support.

alsa

alsa

always on – alsa-store.service, alsa-restore.service

Saves the state of a sound card (e.g. volume) on shutdown and restores
it on startup.

at

atd

atd.service

Runs jobs queued for later execution.

Autofs

autofs

autofs.service

Automounting of removable media or network shares when they are inserted
or accessed.

Avahi

avahi-daemon

avahi-daemon.service

Allows programs to automatically find local network services.

avahi-dnsconfd

avahi-dnsconfd.service

Multicast/unicast DNS-SD framework.

Bitlbee

bitlbee

bitlbee.service

Brings instant messaging (XMPP, MSN, Yahoo!, AIM, ICQ, Twitter) to IRC.

Bluetooth

bluetooth

bluetooth.service

Bluetooth protocol stack, framework, subsystem.

Chrony

chrony

chrony.service

Lightweight NTP client and server.

CDemu

cdemud

cdemu-daemon.service

CD/DVD-ROM device emulator.

ClamAV

clamav

clamd.service   
freshclamd.service

Anti-virus toolkit for Unix.

Connman

connmand

connman.service

Wireless LAN network manager.

Cpupower

cpupower

cpupower.service

Sets cpufreq governor and other parameters on startup.

craftbukkit

not yet implemented

CraftBukkit Minecraft server.

Cron

crond

cronie.service (if using cronie) or dcron.service (if using dcron)

Daemon to schedule and time events. The daemon name crond is used by at
least two packages, cronie and dcron.

CUPS

cupsd

cups.service

The CUPS Printing System daemon.

D-Bus

dbus

always on – dbus.service

Freedesktop.org message bus system.

dante

sockd

sockd.service

A circuit-level SOCKS client/server.

Deluge

deluged

deluged.service

Cross-platform and full-featured BitTorrent client - main daemon.

deluge-web

deluge-web.service

Cross-platform and full-featured BitTorrent client - web interface
daemon.

Dhcpcd

dhcpcd

dhcpcd@.service

DHCP daemon.

Dovecot

dovecot

dovecot.service

IMAP and POP3 server.

Dropbox

dropboxd

dropbox@.service

Cross-platform file synchronisation with version control.

fail2ban

fail2ban

fail2ban.service

Fail2ban scans log files and bans IP addresses that show malicious
activity.

Fan Speed Control

fancontrol

fancontrol.service

Fan control daemon (part of lm_sensors)

Fbsplash

fbsplash

not yet implemented

Graphical boot splash screen for the user.

FluidSynth

fluidsynth

fluidsynth.service

Software synthesizer.

ftpd

ftpd.service

inetutils FTP daemon.

GDM

gdm

gdm.service

GNOME Display Manager.

Git

git-daemon

git-daemon.socket

Git daemon.

gpm

gpm

gpm.service

Console mouse support.

hddtemp

hddtemp

hddtemp.service

Hard drive temperature monitor daemon.

healthd

healthd.service

A daemon which can be used to alert you in the event of a hardware
health monitoring alarm (part of lm_sensors).

apache

httpd

httpd.service

Apache HTTP Server (Web Server).

i8kmon

i8kmon.service

Monitor the CPU temperature and fan status on Dell Inspiron laptops.

ifplugd

ifplugd@.service

Start/stop network on network cable plugged in/out.

iptables

iptables

iptables.service

Load firewall rules for IPv4.

ip6tables

ip6tables.service

Load firewall rules for IPv6.

irqbalance

irqbalance.service

Irqbalance is the Linux utility tasked with making sure that interrupts
from your hardware devices are handled in as efficient a manner as
possible.

KDE

kdm

kdm.service

KDE Display Manager.

krb5

krb5-kadmind

krb5-kadmind.service

Kerberos 5 administration server.

krb5-kdc

krb5-kdc.service

Kerberos 5 KDC.

krb5-kpropd

krb5-kpropd.service

Kerberos 5 propagation server.

Laptop Mode Tools

laptop-mode

laptop-mode.service

Laptop power saving tools.

lighttpd

lighttpd

lighttpd.service

Lighttpd HTTP Server (Web Server).

libvirt

libvirt

libvirtd.service

libvirt is a virtualization API and a daemon for managing virtual
machines (VMs).

lxdm

lxdm

lxdm.service

LXDE Display Manager.

mdadm

mdadm.service

MD Administration (Linux software RAID).

miniDLNA

minidlna

minidlna.service

simple DLNA/UPnP media server.

 ?

ModemManager.service

Makes mobile broadband (3G) modem available to NetworkManager.

mpd

mpd

mpd.service

Music Player Daemon.

MySQL

mysqld

mysqld.service

MySQL database server.

MythTV

mythbackend

mythbackend.service

Back-end for the MythTV digital video recording/home theater software.

BIND

named

named.service

The Berkeley Internet Name Daemon (BIND) DNS server.

netctl

netctl@.service

Manually activate specific profile.

netctl-ifplugd@.service

Automatically start/stop netctl profiles depending on whether the cable
is plugged in or not.

netctl-auto@.service

Automatically start/stop netctl wireless profiles depending on which
access points are in range.

network

dhcpcd@.service

Brings up the network connections (dynamic Ethernet).

NetworkManager

networkmanager

NetworkManager.service   
NetworkManager-wait-online.service

NetworkManager daemon, provides configuration and detection for
automatic network connections.

Nginx

nginx

nginx.service

Nginx HTTP Server and IMAP/POP3 proxy server (Web Server).

nscd

nscd.service

Name service caching daemon.

ntpd

ntpd

ntpd.service

Network Time Protocol daemon (client and server).

Ntop

ntop

ntop.service

Ntop is a network traffic probe based on libcap.

OpenNTPD

openntpd

openntpd.service

Alternative Network Time Protocol daemon (client and server).

osspd

osspd.service

OSS Userspace Bridge.

OpenVPN

openvpn

openvpn@.service

One for each VPN configuration file saved like
/etc/openvpn/<profile-name>.conf

OSS

oss

oss.service

Open Sound System. Alternative to ALSA.

Pdnsd

pdnsd

pdnsd.service

Proxy DNS server with permanent caching.

php-fpm

php-fpm

php-fpm.service

FastCGI Process Manager for PHP.

PostgreSQL

postgresql

postgresql.service

PostgreSQL database server.

Postfix

postfix

postfix.service

Mail server, which is an alternative to using sendmail.

Postgrey

postgrey

postgrey.service

Greylisting service, used with Postfix

powernowd

powernowd

not yet implemented

To adjust speed of CPU depending on system load.

PPTP Server

pptpd

pptpd.service

A Virtual Private Network (VPN) server using the Point-to-Point
Tunneling Protocol (PPTP).

pppd

pppd

ppp@.service

A daemon which implements the Point-to-Point Protocol for dial-up
networking.

preload

preload

preload.service

Makes applications run faster by prefetching binaries and shared
objects.

Prosody

prosody

prosody.service

XMPP server.

Profile-sync-daemon

psd

psd.service

Manages your browser's profile in tmpfs and periodically syncs it back
to your physical disk.

pure-ftpd

pure-ftpd.service

A fast, production quality, standards-compliant FTP server.

Readahead

readahead?

systemd-readahead-collect.service

systemd-readahead-done.service

systemd-readahead-drop.service

systemd-readahead-replay.service

Readahead for faster boot.

rfkill

rfkill

rfkill-block@.service   
rfkill-unblock@.service

(Un)blocks radio devices.

Rsync

rsyncd

rsyncd.service

rsync daemon.

Rsyslog

rsyslogd

rsyslog.service

Alternative system logger.

samba

samba

smbd.service  
nmbd.service  
winbindd.service

File and print services for Microsoft Windows clients.

Sane

saned

saned@.service

SANE network daemon.

saslauthd

saslauthd.service

SASL authentication daemon.

Lm sensors

sensord

sensord.service

Sensor information logging daemon.

sensors

lm_sensors.service

Initialize hardware monitoring sensors (load necessary kernel modules).

SLiM

slim

slim.service

Simple Login Manager.

SMART

smartd

smartd.service

Self-Monitoring, Analysis, and Reporting Technology (S.M.A.R.T.) Hard
Disk Monitoring.

smbnetfs

smbnetfs

smbnetfs.service

Automatically mount Samba/Microsoft network shares.

snmpd

snmpd

snmpd.service

A suite of applications used to implement SNMP

soundmodem

not yet implemented

Multiplatform Soundcard Packet Radio Modem

spamassassin

spamd

spamassassin.service

e-mail spam filtering service.

openssh

sshd

sshd.service

OpenSSH (secure shell) daemon.

stunnel

stunnel.service

Allows encrypting arbitrary TCP connections inside SSL.

svnserve

svnserve.service

Subversion server.

syslog-ng

syslog-ng

syslog-ng.service

System logger next generation.

Timidity

timidity++

timidity.service

Software synthesizer for MIDI.

Tor

tor

tor.service

Onion routing for anonymous communication.

Transmission

transmissiond

transmission.service

BitTorrent Daemon.

Ufw

ufw

ufw.service

Uncomplicated FireWall.

VirtualBox

vboxservice

vboxservice.service

VirtualBox Guest Service.

vnStat

vnstat

vnstat.service

Lightweight network traffic monitor.

Very Secure FTP Daemon

vsftpd

vsftpd.service (permanent)

vsftpd.socket (on-demand)

vsftpd-ssl.service (permanent)

vsftpd-ssl.socket (on-demand)

FTP server.

wicd

wicd

wicd.service

A lightweight alternative to NetworkManager.

x11vnc

x11vnc

x11vnc.service

VNC remote desktop daemon.

XDM

xdm

xdm.service

X display manager.

xdm-archlinux

xdm-archlinux

xdm-archlinux.service

X display manager with Arch Linux theme.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Daemons_List&oldid=299504"

Categories:

-   Boot process
-   Daemons and system services

-   This page was last modified on 21 February 2014, at 22:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
