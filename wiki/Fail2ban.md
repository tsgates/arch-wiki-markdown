Fail2ban
========

Warning:Using an IP blacklist will stop trivial attacks but it relies on
an additional daemon and successful logging (the partition containing
/var can become full, especially if an attacker is pounding on the
server). Additionally, if the attacker knows your IP address, they can
send packets with a spoofed source header and get you locked out of the
server. SSH keys provide an elegant solution to the problem of brute
forcing without these problems.

Fail2ban scans log files like /var/log/pwdfail or
/var/log/apache/error_log and bans IP that makes too many password
failures. It updates firewall rules to reject the IP address.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 systemd                                                      |
|                                                                          |
| -   2 Hardening                                                          |
|     -   2.1 Capabilities                                                 |
|     -   2.2 Filesystem Access                                            |
|                                                                          |
| -   3 SSH jail                                                           |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

First, install python2-pyinotify so that Fail2ban can detect
modification to the log files:

    # pacman -S python2-pyinotify

Then, install fail2ban:

    # pacman -S fail2ban

If you want Fail2ban to send an email when someone has been banned, you
have to configure SSMTP (for example). You will also have to install
whois to get some information about the attacker.

    # pacman -S whois

> systemd

Use the service unit fail2ban.service, consult systemd for instructions

Please note that this currently requires syslog-ng logging. This is
because a pure systemd journalctl does not log to /var/log/auth.log
which is parsed by the service in default.

Hardening
---------

Currently, fail2ban requires to run as root, therefore you may wish to
consider some additional hardening on the process with systemd.
Ref:systemd for Administrators, Part XII

> Capabilities

For added security consider limiting fail2ban capabilities by adding
CapabilityBoundingSet under [Service] section of the systemd service
file, e.g.:

    CapabilityBoundingSet=CAP_DAC_READ_SEARCH CAP_NET_ADMIN CAP_NET_RAW

In the example above, CAP_DAC_READ_SEARCH will allow fail2ban full read
access, and CAP_NET_ADMIN and CAP_NET_RAW allow setting of firewall
rules with iptables. Additional capabilities may be required, depending
on your fail2ban configuration. See man capabilities for more info.

> Filesystem Access

Also considering limiting file system read and write access, by using
ReadOnlyDirectories and ReadWriteDirectories, again under the under
[Service] section. For example:

    ReadOnlyDirectories=/
    ReadWriteDirectories=/var/run/fail2ban /var/spool/postfix/maildrop

In the example above, this limits the file system to read-only, except
for /var/run/fail2ban for pid and socket files, and
/var/spool/postfix/maildrop for postfix sendmail. Again, this will be
dependent on you system configuration and fail2ban configuration. Note
that adding /var/log is necessary if you want fail2ban to log its
activity.

SSH jail
--------

Edit /etc/fail2ban/jail.conf and modify the ssh-iptables section to
enable it and configure the action.

If your firewall is iptables:

    [ssh-iptables]
    enabled  = true
    filter   = sshd
    action   = iptables[name=SSH, port=ssh, protocol=tcp]                                         
               sendmail-whois[name=SSH, dest=your@mail.org, sender=fail2ban@mail.com]
    logpath  = /var/log/auth.log                                                                    
    maxretry = 5

If your firewall is shorewall:

    [ssh-shorewall]
    enabled  = true
    filter   = sshd
    action   = shorewall
               sendmail-whois[name=SSH, dest=your@mail.org, sender=fail2ban@mail.com]
    logpath  = /var/log/auth.log                                                                    
    maxretry = 5

Note:You can set BLACKLISTNEWONLY to No in /etc/shorewall/shorewall.conf
otherwise the rule added to ban an IP address will affect only new
connections.

Also do not forget to add/change:

    LogLevel VERBOSE

in your /etc/ssh/sshd_config. Else, password failures are not logged
correctly.

See also
--------

-   sshguard

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fail2ban&oldid=244932"

Category:

-   Secure Shell
