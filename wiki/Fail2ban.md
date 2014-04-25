Fail2ban
========

Warning:Using an IP blacklist will stop trivial attacks but it relies on
an additional daemon and successful logging (the partition containing
/var can become full, especially if an attacker is pounding on the
server). Additionally, if the attacker knows your IP address, they can
send packets with a spoofed source header and get you locked out of the
server. SSH keys provide an elegant solution to the problem of brute
forcing without these problems.

Fail2ban scans various textual log files and bans IP that makes too many
password failures by updating firewall rules to reject the IP address,
similar to Sshguard.

Warning:For correct function it is essential that the tool parses the IP
addresses in the log correctly. You should always test the log filters
work as intended per application you want to protect.

Contents
--------

-   1 Installation
    -   1.1 systemd
-   2 Hardening
    -   2.1 Capabilities
    -   2.2 Filesystem Access
-   3 SSH jail
-   4 See also

Installation
------------

Install fail2ban from the official repositories.

If you want Fail2ban to send an email when someone has been banned, you
have to configure SSMTP (for example).

> systemd

Use the service unit fail2ban.service, refer to systemd for
instructions.

Hardening
---------

Currently, fail2ban requires to run as root, therefore you may wish to
consider some additional hardening on the process with systemd.
Ref:systemd for Administrators, Part XII

> Capabilities

For added security consider limiting fail2ban capabilities by specifying
CapabilityBoundingSet in the drop-in configuration file for the provided
fail2ban.service:

    /etc/systemd/system/fail2ban.service.d/capabilities.conf

    [Service]
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

Fail2Ban from version 0.9 can also read directly from the systemd
journal by setting backend = systemd.

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
"https://wiki.archlinux.org/index.php?title=Fail2ban&oldid=305539"

Category:

-   Secure Shell

-   This page was last modified on 18 March 2014, at 23:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
