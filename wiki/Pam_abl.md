Pam abl
=======

> Summary

Using pam_abl to increase sshd security

> Related

SSH

Using SSH Keys

A Cure for the Common SSH Login Attack

Pam_abl provides another layer of security against brute-force SSH
password guessing. It allows you to set a maximum number of unsuccessful
login attempts within a given time period, after which a host and/or
user is blacklisted. Once a host/user is blacklisted, all authentication
attempts will fail even if the correct password is given. Hosts/users
which stop attempting to login for a specified period of time will be
removed from the blacklist.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Add pam_abl to the PAM auth stack                            |
|     -   2.2 Create pam_abl.conf                                          |
|     -   2.3 Create the blacklist databases                               |
|                                                                          |
| -   3 Managing the blacklist databases                                   |
|     -   3.1 Check blacklisted hosts/users                                |
|     -   3.2 Manually removed a host or user from the blacklist           |
|     -   3.3 Manually add a host or user to the blacklist                 |
|     -   3.4 Other pam_abl commands                                       |
|                                                                          |
| -   4 Known Issues                                                       |
+--------------------------------------------------------------------------+

Installation
------------

Install the pam_abl PKGBUILD from the AUR using Makepkg.

Configuration
-------------

> Add pam_abl to the PAM auth stack

Open /etc/pam.d/sshd as root in your editor of choice. Add the following
line above all other lines:

    auth            required        pam_abl.so config=/etc/security/pam_abl.conf

Assuming you haven't made any other modifications, your /etc/pam.d/sshd
should now look like this:

    #%PAM-1.0
    auth            required        pam_abl.so config=/etc/security/pam_abl.conf
    auth            include         system-login
    account         include         system-login
    password        include         system-login
    session         include         system-login

> Create pam_abl.conf

Create /etc/security/pam_abl.conf as root using your editor of choice.

Note:As of pam_abl 0.4.3, an extra line is required in pam_abl.conf to
specify db_home. Auxiliary database files are now created in that
directory.

A sample /etc/security/pam_abl.conf is as follows:

    # /etc/security/pam_abl.conf
    db_home=/var/lib/abl/
    host_db=/var/lib/abl/hosts.db
    host_purge=7d
    host_rule=*:10/1h
    user_db=/var/lib/abl/users.db
    user_purge=7d
    user_rule=!root:10/1h

The paths given in host_db and user_db specify where the blacklists
should be stored. Typical paths are /var/lib/abl/hosts.db and
/var/lib/abl/users.db, respectively.

The values given in host_purge and user_purge specify the time period
before hosts/users are removed from the blacklist. Values are specifed
as <number><suffix> where suffix can be any of s, m, h, or d for units
of seconds, minutes, hours or days, respectively.

The rules specified in host_rule and user_rule are specified as
<user>:<attempts>/<time period>. <user> is a list of user names
separated by |s. The special user name * matches all users, and
prefixing a user by a ! matches all users except the one named.
<attempts> is the number of attempts allowed before a user/host is
blacklisted, and <time period> specifies the period in which the
attempts must occur. The same time suffixes as described above also
apply to <time period>.

For example, the rule *:10/1h specifies that for any user, ten failed
login attempts within an hour will get the host blacklisted. The rule
!root:10/1h specifies that for any user except root, ten failed login
attempts within an hour will get the user blacklisted, regardless of the
host the attempts are coming from.

Warning:Whether or not to include root in the user_rule must be
carefully considered. Not including root has obvious security
implications. On the other hand, including root gives hackers the
ability to block anyone from logging in as root by making repeated
failed attempts.

Multiple conditions can be given to the same set of users using comma
separation:

    user_rule=!root:10/1h,20/1d

Multiple rules can be specified using space separation:

    user_rule=!root:10/1h root:25/1h

If you only want pam_abl to blacklist one of users or hosts, simply omit
the appropriate lines from /etc/security/pam_abl.conf.

> Create the blacklist databases

As root, create the directory for the database (assuming you specified
the recommended path above):

    # mkdir /var/lib/abl

As root, run the pam_abl utility to initialize the databases:

    # pam_abl

That's it! Pam_abl should now be working. Since PAM is not a daemon,
nothing needs to be restarted for these changes to take effect. It's
strongly recommended to verify that pam_abl is working by purposely
getting a remote host blacklisted. Don't worry though! For directions on
how to manually remove a host or user from the blacklist, see below.

Managing the blacklist databases
--------------------------------

> Check blacklisted hosts/users

As root, simply run:

    # pam_abl

Note:As pam_abl does not run as a daemon, it performs "lazy purging" of
the blacklist. In other words, it does not remove users/hosts from the
blacklist until an authentication attempt occurs. This does not affect
functionality, although it will frequently cause extra failures to show
up when running the above command. To force a purge, run:

    # pam_abl -p

> Manually removed a host or user from the blacklist

As root, simply run:

    # pam_abl -w -U <user>

or

    # pam_abl -w -H <host>

Using * as a wildcard to match multiple hosts/users is allowed in both
of the above commands.

> Manually add a host or user to the blacklist

As root, simply run:

    # pam_abl -f -U <user>

or

    # pam_abl -f -H <host>

> Other pam_abl commands

Like virtually all linux utilities, a manpage is available to see all
options:

    $ man pam_abl

Known Issues
------------

The current version (0.5.0) of pam_abl has a problem that can affect its
ability to blacklist under specific conditions.

Due to the way sshd operates and the way pam modules are passed
information, failure of a given attempt is not logged until either a
second attempt is made or the connection is closed. This means that long
as the attacker only makes one attempt per connection, and never closes
any connections, no failures are ever logged.

In practice, the sshd_config settings "MaxStartups" (default 10) and to
a lesser degree "LoginGraceTime" (default 120s) limit the viability of
this approach, but it still could be used to squeeze out more attempts
then you specify.

In the meantime, the workaround is to set "MaxAuthTries" to 1 (or expect
that an additional "MaxStartups" number of attempts could be made above
and beyond what you specify in your pam_abl config).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pam_abl&oldid=247143"

Categories:

-   Secure Shell
-   Security
