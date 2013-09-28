DenyHosts
=========

Warning:Using an IP blacklist will stop trivial attacks but it relies on
an additional daemon and successful logging (the partition containing
/var can become full). Additionally, if the attacker knows your IP
address, they can send packets with a spoofed source header and get you
locked out of the server. SSH keys provide an elegant solution to the
problem of brute forcing without these problems.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:As of July 2011, DenyHosts is no longer available in the official
repositories. Useful alternatives are fail2ban and sshguard.

DenyHosts can be used in general to protect your server or home computer
from SSH brute force Attacks. Its principle is rather simple. It parses
the /var/log/auth.log for incorrect login tries and similar in order to
disable hosts with too many attempts.

The following sections will describe how to set up DenyHosts properly on
Arch Linux and will give hints about how to configure it for a local or
a remote system (as a virtual server).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Remote System                                                |
|                                                                          |
| -   3 Starting DenyHosts                                                 |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Simple as it is, you can install DenyHosts using pacman, with the
following command:

    # pacman -S denyhosts

Configuration
-------------

First of all, the configuration file is located in:
/etc/denyhosts/denyhosts.cfg

There you can set the most configuration options. Please consider, that
DenyHosts also saves the hosts found in the auth.log in a separate
directory, which is scanned every time you start the program. Therefore,
just deleting the auth.log won't be of any help. The standard directory
used in the denyhosts configuration is:/var/lib/denyhosts

For a fresh installation, I recommend to delete the former
authentication logfile (or rotate it)

    # /etc/rc.d/syslog-ng stop
    # cp /var/log/auth.log /var/log/auth.log.old
    # echo "" > /var/log/auth.log
    # /etc/rc.d/syslog-ng start

Furthermore, I recommend to use a separate file for denying SSH.
Therefore, create a own file, as in the following example:

    # touch /etc/hosts.evil

Afterwards, you will have to change the configuration file (as mentioned
above)

    # vi /etc/denyhosts/denyhosts.cfg

Find the line where the hosts.deny file is a standard entry, and edit it
to your newly created hosts.evil file:

    /etc/denyhosts/denyhosts.cfg

    .....
    HOSTS_DENY = /etc/hosts.evil
    .....

Also, edit the BLOCK_SERVICE value and leave it blank, as recommended by
the DenyHosts FAQ:

    /etc/denyhosts/denyhosts.cfg

    .....
    BLOCK_SERVICE = 
    .....

Within these steps, DenyHosts will save all hosts which are denied to
this file. For a proper configuration, I will set up the /etc/hosts.deny
as a "standard", means denying everything EXCEPT the values in
hosts.allow:

    /etc/hosts.deny

    #
    # /etc/hosts.deny
    #

    ALL: ALL: DENY

    # End of file

The hosts.allow will also be adjusted, to allow the connect from any ssh
client, except the ones in our newly created hosts.evil

    /etc/hosts.allow

    #
    # /etc/hosts.allow
    #
    sshd: ALL EXCEPT /etc/hosts.evil
    # End of file

> Remote System

If you configure DenyHosts on a remote system, where you do not have
direct access, I recommend to set an option in DenyHosts to purge values
after a certain period of time (in example: 1 week) Therefore, you need
to edit your denyhosts.cfg once again, just in case you lock out
yourself one day.

    PURGE_DENY = 1w

Note: You can also add your own IP to /etc/hosts.allow. This file is
parsed before /etc/hosts.deny and prevents you from locking yourself
out. This only works if you always login from the same (set of) IP
address(es).

Starting DenyHosts
------------------

Simple as it is, the Arch Linux package ships with a rc script for
DenyHosts.

    # /etc/rc.d/denyhosts start

To start DenyHosts on every system startup, edit your /etc/rc.conf file,
and add denyhosts. Note that the "..." are placeholders for other
daemons started, and were chosen to point out the important entry only.

    /etc/rc.conf

    .....
    DAEMONS=(... ... ... ... denyhosts ... ... ... ...)

See also
--------

-   DenyHosts project page
-   fail2ban
-   sshguard

Retrieved from
"https://wiki.archlinux.org/index.php?title=DenyHosts&oldid=239026"

Categories:

-   Networking
-   Security
-   Secure Shell
