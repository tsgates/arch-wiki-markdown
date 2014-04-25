Parental Control
================

  Summary help replacing me
  -----------------------------------------------------------------------------------------------------------
  Some tools and methods for parental control, protecting and limiting children's activity on the computer.

Contents
--------

-   1 Timekpr
-   2 Timeoutd
-   3 Logkeys
-   4 Whitelist with Tinyproxy and Firehol
-   5 OpenDNS Parental Control

Timekpr
-------

Homepage: https://launchpad.net/timekpr

Package: timekpr

This program will control the computer usage of your user accounts. You
can limit their daily usage based on a timed access duration and
configure periods of day when they can log in. The program consist of a
daemon which supervises the time allowed for any user, and a client in
the traybar, that warns the users about their time running out.
Administration is done in a graphical GTK GUI.

Timeoutd
--------

Package: timeoutd

A lightweight alternative to timekpr is timeoutd. It scans /var/run/utmp
every minute and checks /etc/timeouts for an entry which matches a
restricted user. Restrictions can be done on idle time, login time,
maximum time, and time of day.

Logkeys
-------

Homepage: http://code.google.com/p/logkeys/

Package: logkeys-svn (The -svn version is recommended. It is stable and
includes the latest patch that allows logkeys to work in Archlinux)

This program logs every keypress into a logfile for later inspection. It
runs as daemon. The logfile by default resides in /var/log, but it is
recommended to move it to an encrypted partition as it will contain
every password ever entered in the system. For supervision purposes I
recommend using the --no-func-keys option. Also there is some keymaps in
the logkeys-keymap-svn package, use them with the --keymap option, this
is necessary to log the keys properly if you use a localized non US
keyboard.

Whitelist with Tinyproxy and Firehol
------------------------------------

The following description will enable you to filter any user's access to
the internet with a whitelist of url-s using firehol and tinyproxy (or
tinyproxy-git).

/etc/tinyproxy/tinyproxy.conf consists of the following changes:

    FilterURLs On
    FilterDefaultDeny Yes
    Filter "/etc/tinyproxy/whitelist"

/etc/tinyproxy/whitelist should hold the url's that will be only allowed
accessed by selected users. A silly example:

    (www|wiki|static).archlinux.org
    google.com

/etc/firehol/firehol.conf should contain the following line:

    transparent_proxy "80 443" 8888 "nobody root bin myaccount"

where myaccount is my account that should no be filtered by Tinyproxy.

OpenDNS Parental Control
------------------------

OpenDNS provides free DNS services that can be used as alternative to
your ISP's default servers. What's more, they provide blacklist
filtering capabilities by registering. Different levels of filtering is
possible. Read more about it on their home page.

If you have dynamic IP address, it is a good idea to keep it updated on
OpenDNS. Just use community/ddclient and edit
/etc/ddclient/ddclient.conf like this:

    # OpenDNS.com account-configuration
    use=web, web=myip.dnsomatic.com
    server=updates.opendns.com
    protocol=dyndns2
    login=myopendns@email.address
    password=myopendnspassword
    myhostname

Retrieved from
"https://wiki.archlinux.org/index.php?title=Parental_Control&oldid=306004"

Category:

-   Security

-   This page was last modified on 20 March 2014, at 17:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
