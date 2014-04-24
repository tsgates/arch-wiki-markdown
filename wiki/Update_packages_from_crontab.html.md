Update packages from crontab
============================

Do not try this at home!
------------------------

Warning:Doing automatic updates from cron is strongly discouraged. It is
likely to leave your machine in a broken and unbootable state. If this
breaks your machine, do not hold anyone but yourself responsible. You
have been warned.

So, proceed only if you have balls of steel or you were intending to
crash your machine anyway. If so, you might as well do it the "right
way".

1.  First, you (obviously!) need to install cron itself. Do that first.
2.  It is highly recommended to also install a mail transfer agent, such
    as Postfix, to send you notifications if pacman fails.
3.  Run as root: crontab -e
4.  Copy-paste this to your crontab:

    MAILTO=your@email
    LOGFILE=/var/log/cron-pacman.log

    # 1. minute (0-59)
    # |   2. hour (0-23)
    # |   |   3. day of month (1-31)
    # |   |   |   4. month (1-12)
    # |   |   |   |   5. day of week (0-7: 0 or 7 is Sun, or use names)
    # |   |   |   |   |   6. commandline
    # |   |   |   |   |   |
    #min hr  dom mon dow command
    00   13   *   *   *  . /etc/profile && (echo; date; yes |pacman -Syuq) &>>$LOGFILE || (echo 'pacman failed!'; tail $LOGFILE; false)

If you want to automatically reboot your computer upon a successful
upgrade, append '&& reboot' to the above line.

Do try this at home!
--------------------

Instead of using `pacman -Syuq` above, use `pacman -Syuwq`. The '-w'
will cause pacman to "retrieve all packages from the server, but do not
install/upgrade anything." While you will still have to manually update
your system, you won't have to wait (as long) for packages to download
while doing so.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Update_packages_from_crontab&oldid=240550"

Category:

-   Package management

-   This page was last modified on 16 December 2012, at 10:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
