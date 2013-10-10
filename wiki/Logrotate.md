Logrotate
=========

> Summary

An introduction to the popular log maintenance utility.

> Related

Cron

> Resources

Logrotate on Gentoo Linux Wiki

From https://fedorahosted.org/logrotate/:

The logrotate utility is designed to simplify the administration of log
files on a system which generates a lot of log files. Logrotate allows
for the automatic rotation compression, removal and mailing of log
files. Logrotate can be set to handle a log file daily, weekly, monthly
or when the log file gets to a certain size.

By default, logrotate's rotation consists of renaming existing log files
with a numerical suffix, then recreating the original empty log file.
For example, /var/log/syslog.log is renamed /var/log/syslog.log.1. If
/var/log/syslog.log.1 already exists from a previous rotation, it is
first renamed /var/log/syslog.log.2. (The number of backlogs to keep can
be configured.)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Troubleshooting                                                    |
|     -   3.1 logs not being rotated                                       |
|     -   3.2 exim log not rotated                                         |
+--------------------------------------------------------------------------+

Installation
------------

logrotate is available in [core] and is installed as a member of the
base group.

    # pacman -S logrotate

Typically, logrotate is run via a cron job; /etc/cron.daily/logrotate is
included in the package.

Configuration
-------------

The primary configuration file for logrotate is /etc/logrotate.conf;
additional configuration files are included from the /etc/logrotate.d
directory.

Troubleshooting
---------------

> logs not being rotated

If you find that your logs aren't being rotated via the cronjob, one
reason for that can be wrong user and group ownership. Both need to be
root. To fix this either do:

    # chown root:root /etc/logrotate.conf
    # chown -R root:root /etc/logrotate.d

or, set the su variable to the user and group you desire in
/etc/logrotate.conf.

> exim log not rotated

If you have set the olddir variable in /etc/logrotate.conf, you will get
a message such as:

error: failed to rename /var/log/exim/mainlog to /var/log/old/mainlog.1: Permission denied

To fix this, add the user exim to the group log. Then change the group
of the olddir, usually /var/log/old, to log instead of the default root.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logrotate&oldid=235504"

Categories:

-   Daemons and system services
-   Data compression and archiving
