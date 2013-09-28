Hylafax
=======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
| -   2 Hints and tips                                                     |
|     -   2.1 FaxDispatch                                                  |
|     -   2.2 Pagesize                                                     |
|     -   2.3 No dialtone error or if you are a laptop user                |
|     -   2.4 For laptop users it might be helpfull to deactivate the      |
|         dialtone check                                                   |
|     -   2.5 Automatic fax printing                                       |
|     -   2.6 Disabling MTA actions                                        |
|     -   2.7 Enable automatic printing of notifications                   |
|     -   2.8 Useful commands                                              |
|                                                                          |
| -   3 Apps for hylafax                                                   |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Setup
-----

    # pacman -S hylafax

It could be that you need a MTA installed like postfix

-   After installation please run faxsetup as root. Answer the questions
    and modify to your needs.

-   Run faxaddmodem as root. It asks you for the device, leave out the
    /dev prefix; only enter eg. modem, ttyS0 or such things.

-   Answer the other questions, important ones could be the ringtones,
    max pages, permissions on files or your the name that should be
    shown.

-   With systemd, you need to set up the daemon. In
    /usr/lib/systemd/system, there is a file named faxgetty@.service.
    Assuming your modem is on ttyS0,

    cp /usr/lib/systemd/system/faxgetty@.service /usr/lib/systemd/faxgetty@ttyS0.service
    systemctl enable faxgetty@ttyS0.service
    systemctl start faxgetty@ttyS0.service

-   You will probably need to start 3 daemons at boot; faxgetty@ttyS0,
    hfaxd, and faxq. See Daemons#Starting_on_boot. To start manually,
    see Daemons#Starting_manually.

Your received faxes will be saved in /var/spool/hylafax/rcvq/ and
deleted after 30 days. Your sent faxes will be saved in
/var/spool/hylafax/sendq/

Hints and tips
--------------

> FaxDispatch

You can create a FaxDispatch file that will allow you to convert
incoming faxes to pdf or other and direct where these are sent. Examples
are all over the Internet, but be aware that FaxDispatch does NOT go
into /etc, but rather into /var/spool/hylafax/etc.

A simple FaxDispatch that converts to pdf and sends the fax to a
particular address would be

    FILETYPE=pdf
    SENDTO=myaddress@myemail.whatever

> Pagesize

Hylafax defaults are made for North America settings. Pagesize of send
faxes can be adjusted in /usr/lib/fax/pagesizes for A4 default setup
please change the file to that:

    ---snip
    Japanese Legal          JP-LEG  12141   17196   11200    15300  900     400
    #
    #default        NA-LET  10200   13200    9240    12400  472     345
    default         A4      9920    14030   9240    13200   472     345
    ---snap

> No dialtone error or if you are a laptop user

If you need a special number to get the Dialtone add this to:

    /var/spool/hylafax/etc/config.<yourdevicename>

Uncomment the ModemDialCmd line, and change ATDT%s to ATDT<yournumber>%s

> For laptop users it might be helpfull to deactivate the dialtone check

Uncomment the ModemDialCmd line, and change ATDT%s to ATX3DT%s

> Automatic fax printing

Add this to /var/spool/hylafax/bin/faxrcvd at the end

    /usr/bin/tiff2ps -a -h 11.1082 -w 7.8543 $FILE | /usr/bin/lpr -P <yourprintername>

This setup is for A4 pagesize, adjust -h and -w to your needs if you
need an other size.

> Disabling MTA actions

Normally hylafax uses a MTA to receive faxes, if you do not need that
change, your /var/spool/hylafax/bin/faxrcvd

Change NOTIFY_FAXMASTER=always to never

> Enable automatic printing of notifications

If you want notifications to be printed out and not mailed, change your
/var/spool/hylafax/bin/notify

-   Change NOTIFY_FAXMASTER=never to always and at the end of that file

-   Comment this line :

        ) || 2>&1 $SENDMAIL -f$FROMADDR -oi -t

-   Add this as next line:

        ) || 2>&1 lpr -P <yourprinter> -p

Remember to add your changed file to pacmans NoUpgrade list else your
changes might get lost on update.

> Useful commands

    faxstat (shows you the status of hylafax)
    faxstat -s (shows you the send status)
    faxstat -r (shows received faxes)
    faxalter -a now <jobid> (forces send retry now)
    faxrm <jobid> (deletes fax from sendqueue)

For more options please read the manpages of each program

Apps for hylafax
----------------

GNU/Linux Apps:

-   kfax is a nice app to view the received tiff files.
-   KDE has a printer to send your document to fax, change it to use the
    hylafax backend.

Windows Apps:

-   WFHC is a nice hylafax client for windows. Get it here:
    http://www.uli-eckhardt.de/whfc/
-   SuSEfax is also a nice client for windows. Get it here:
    ftp://ftp.suse.com/pub/suse/discontinued/i386/SuSEFax_WIN32

See also
--------

faxq - HylaFAX queue manager process. man hfaxd.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hylafax&oldid=253024"

Category:

-   Telephony and Voice
