OfflineIMAP
===========

OfflineIMAP is a Python utility to sync mail from IMAP servers. It does
not work with the POP3 protocol or mbox, and is usually paired with a
MUA such as Mutt.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Configuring                                                        |
|     -   2.1 Minimal                                                      |
|                                                                          |
| -   3 Usage                                                              |
| -   4 Miscellaneous                                                      |
|     -   4.1 Running offlineimap in the background                        |
|         -   4.1.1 systemd Service                                        |
|         -   4.1.2 cron job                                               |
|                                                                          |
|     -   4.2 Automatic mutt mailbox generation                            |
|     -   4.3 Gmail configuration                                          |
|     -   4.4 Not having to enter the password all the time                |
|         -   4.4.1 .netrc                                                 |
|         -   4.4.2 Gnome Keyring                                          |
|         -   4.4.3 python-keyring                                         |
|         -   4.4.4 Emacs EasyPG                                           |
|                                                                          |
|     -   4.5 Kerberos authentication                                      |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Overriding UI and autorefresh settings                       |
|     -   5.2 netrc authentication                                         |
|     -   5.3 Folder could not be created                                  |
|     -   5.4 SSL fingerprint does not match                               |
|                                                                          |
| -   6 External links                                                     |
+--------------------------------------------------------------------------+

Installing
----------

Install the offlineimap package with pacman:

    # pacman -S offlineimap

Warning:Some users have reported sporadic issues with OfflineIMAP
exhibiting random crashes and hangups requiring intermittent application
restarts. Users looking for an alternative application for two-way IMAP
synchronization, are advised to check Isync, written in C.

Configuring
-----------

Offlineimap is distributed with two default configuration files, which
are both located in /usr/share/offlineimap/. offlineimap.conf contains
every setting and is thorougly documented. Alternatively,
offlineimap.conf.minimal is not commented and only contains a small
number of settings (see: Minimal).

Copy one of the default configuration files to ~/.offlineimaprc.

Note:Writing a comment after an option/value on the same line is invalid
syntax, hence take care that comments are placed on their own separate
line.

> Minimal

The following file is a commented version of offlineimap.conf.minimal.

    ~/.offlineimaprc

    [general]
    # List of accounts to be synced, separated by a comma.
    accounts = main

    [Account main]
    # Identifier for the local repository; e.g. the maildir to be synced via IMAP.
    localrepository = main-local
    # Identifier for the remote repository; i.e. the actual IMAP, usually non-local.
    remoterepository = main-remote
    # Status cache. Default is plain, which eventually becomes huge and slow.
    status_backend = sqlite

    [Repository main-local]
    # Currently, offlineimap only supports maildir and IMAP for local repositories.
    type = Maildir
    # Where should the mail be placed?
    localfolders = ~/Maildir

    [Repository main-remote]
    # Remote repos can be IMAP or Gmail, the latter being a preconfigured IMAP.
    type = IMAP
    remotehost = host.domain.tld
    remoteuser = username

Usage
-----

Before running offlineimap, create any parent directories that were
allocated to local repositories:

    $ mkdir ~/Maildir

Now, run the program:

    $ offlineimap

Mail accounts will now be synced. If anything goes wrong, take a closer
look at the error messages. OfflineIMAP is usually very verbose about
problems; partly because the developers didn't bother with taking away
tracebacks from the final product.

Miscellaneous
-------------

Various settings and improvements

> Running offlineimap in the background

Most other mail transfer agents assume that the user will be using the
tool as a daemon by making the program sync periodically by default. In
offlineimap, there are a few settings that control backgrounded tasks.

Confusingly, they are spread thin all-over the configuration file:

    ~/.offlineimaprc

    # In the general section
    [general]
    # Controls how many accounts may be synced simultaneously
    maxsyncaccounts = 1

    # In the account identifier
    [Account main]
    # Minutes between syncs
    autorefresh = 5
    # Number of quick-syncs between autorefreshes. Quick-syncs do not update if the
    # only changes were to IMAP flags
    quick = 10

    # In the remote repository identifier
    [Repository main-remote]
    # Instead of closing the connection once a sync is complete, offlineimap will
    # send empty data to the server to hold the connection open. A value of 60
    # attempts to hold the connection for a minute between syncs (both quick and
    # autorefresh).This setting has no effect if autorefresh and holdconnectionopen
    # are not both set.
    keepalive = 60
    # OfflineIMAP normally closes IMAP server connections between refreshes if
    # the global option autorefresh is specified.  If you wish it to keep the
    # connection open, set this to true. This setting has no effect if autorefresh
    is not set.
    holdconnectionopen = yes

systemd Service

Writing a systemd service for offlineimap is trivial, just be sure to
run it as the correct user by replacing the User=UserToRunAs with your
user. (e.g. User=wgiokas)

    offlineimap-user.service

    [Unit]
    Description=Start offlineimap as a daemon
    Requires=network.target
    After=network.target

    [Service]
    User=UserToRunAs
    ExecStart=/usr/bin/offlineimap

    [Install]
    WantedBy=multi-user.target

cron job

1. Configure background jobs as shown in #Running offlineimap in the
background.

2. Use a log-friendly user interface:

    ~/.offlineimaprc

    [general]
    # This will suppress anything but errors
    ui = quiet

3. Write a wrapper script for daemonizing programs, or use the one shown
below:

    /usr/local/bin/start_daemon

    #!/bin/sh

    set -efu

    ionice_class=
    ionice_priority=
    nice=

    while getopts c:p:n: f; do
    	case $f in
    	c) ionice_class=$OPTARG;;
    	p) ionice_priority=$OPTARG;;
    	n) nice=$OPTARG;;
    	*) exit 2;;
    	esac
    done
    shift $((OPTIND - 1))

    cmd=$*
    io=

    if pgrep -u "$(id -u)" -xf -- "$cmd" >/dev/null 2>&1; then
    	exit 0
    fi

    if type ionice >/dev/null 2>&1; then
    	[ -n "$ionice_class" ]    && { io=1; cmd="-c $ionice_class $cmd"; }
    	[ -n "$ionice_priority" ] && { io=1; cmd="-n $ionice_priority $cmd"; }
    	[ -n "$io" ] && cmd="ionice $cmd"
    fi

    if type nice >/dev/null 2>&1; then
    	[ -n "$nice" ] && cmd="nice -n $nice $cmd"
    fi

    exec $cmd

4. Finally, add a crontab entry:

    $ crontab -e

The line should specify the interpreter for correct pgrep -xf results:

    */5 * * * * exec /usr/local/bin/start_daemon -n19 -c2 -p7 python2 /usr/bin/offlineimap

The wrapper script is needed because offlineimap has the tendency to
sporadically crash, even more so when facing connection problems.

> Automatic mutt mailbox generation

Mutt cannot be simply pointed to an IMAP or maildir directory and be
expected to guess which subdirectories happen to be the mailboxes, yet
offlineimap can generate a muttrc fragment containing the mailboxes that
it syncs.

    ~/.offlineimaprc

    [mbnames]
    enabled = yes
    filename = ~/.mutt/mailboxes
    header = "mailboxes "
    peritem = "+%(accountname)s/%(foldername)s"
    sep = " "
    footer = "\n"

Then add source ~/.mutt/mailboxes to ~/.mutt/muttrc.

> Gmail configuration

This remote repository is configured specifically for Gmail support,
substituting folder names in uppercase for lowercase, among other small
additions. Keep in mind that this configuration does not sync the All
Mail folder, since it is usually unnecessary and skipping it prevents
bandwidth costs:

    ~/.offlineimaprc

    [Repository gmail-remote]
    type = Gmail
    remoteuser = user@gmail.com
    remotepass = password
    nametrans = lambda foldername: re.sub ('^\[gmail\]', 'bak',
                                   re.sub ('sent_mail', 'sent',
                                   re.sub ('starred', 'flagged',
                                   re.sub (' ', '_', foldername.lower()))))
    folderfilter = lambda foldername: foldername not in '[Gmail]/All Mail'
    # Necessary as of OfflineIMAP 6.5.4
    sslcacertfile = /etc/ssl/certs/ca-certificates.crt

Note:If you have Gmail set to another language, the folder names may
appear translated too, e.g. "verzonden_berichten" instead of
"sent_mail".

Note:After version 6.3.5, offlineimap also creates remote folders to
match your local ones. Thus you may need a nametrans rule for your local
repository too that reverses the effects of this nametrans rule.

Note:As of 1 October 2012 gmail SSL certificate fingerprint is not
always the same. This prevents from using cert_fingerprint and makes the
sslcacertfile way a better solution for the SSL verification (see
OfflineIMAP#SSL fingerprint does not match).

> Not having to enter the password all the time

.netrc

Add the following lines to your ~/.netrc:

       machine hostname.tld
       login [your username]
       password [your password]

Don't forget to give the file appropriate rights like 600 or 700:

      chmod 600 ~/.netrc

Gnome Keyring

http://www.clasohm.com/blog/one-entry?entry_id=90957 gives an example of
how to use gnome-keyring to store the password.

python-keyring

There's a general solution that should work for any keyring. Install
python-keyring from AUR, then change your ~/.offlineimaprc to say
something like:

    [general]
    pythonfile = /home/user/offlineimap.py
    …
    [Repository RemoteEmail]
    remoteuser = username@host.net
    remotepasseval = keyring.get_password("offlineimap","username@host.net")
    …

and somewhere in ~/offlineimap.py add import keyring. Now all you have
to do is set your password, like so:

    $ python2 
    >>> import keyring
    >>> keyring.set_password("offlineimap","username@host.net", "MYPASSWORD")

and it'll grab the password from your (kwallet/gnome-) keyring instead
of having to keep it in plaintext or enter it each time.

Emacs EasyPG

See http://www.emacswiki.org/emacs/OfflineIMAP#toc2

> Kerberos authentication

Install python2-kerberos from AUR and do not specify remotepass in your
.offlineimaprc. OfflineImap figure out the reset all if have a valid
Kerberos TGT. If you have 'maxconnections', it will fail for some
connection. Comment 'maxconnections' out will solve this problem.

Troubleshooting
---------------

> Overriding UI and autorefresh settings

For the sake of troubleshooting, it is sometimes convenient to launch
offlineimap with a more verbose UI, no background syncs and perhaps even
a debug level:

    $ offlineimap [ -o ] [ -d <debug_type> ] [ -u <ui> ]

-o 
    Disable autorefresh, keepalive, etc.

-d <debug_type> 
    Where <debug_type> is one of imap, maildir or thread. Debugging imap
    and maildir are, by far, the most useful.

-u <ui> 
    Where <ui> is one of CURSES.BLINKENLIGHTS, TTY.TTYUI,
    NONINTERACTIVE.BASIC, NONINTERACTIVE.QUIET or MACHINE.MACHINEUI.
    TTY.TTYUI is sufficient for debugging purposes.

Note:More recent versions use the following for <ui>: blinkenlights,
ttyui, basic, quiet or machineui.

> netrc authentication

There are some bugs in the current offlineimap which makes it impossible
to read the authentication data from ~/.netrc if there are multiple
Accounts per remote machine. ( see Mail Archive ) But they are fixed in
the GIT package offlineimap-git (note that is AUR package is flagged as
out of date; see the current GitHub external link below). Using the
package you can collect all passwords in ~/.netrc. And do not forget to
set it's access rights:

    chmod 600 ~/.netrc

An example netrc file would be

    ~/.netrc

    machine mail.myhost.de
        login mr_smith
        password secret

> Folder could not be created

In version 6.5.3, offlineimap gained the ability to create folders in
the remote repository, as described here.

This can lead to errors of the following form when using nametrans on
the remote repository:

    ERROR: Creating folder bar on repository foo-remote
      Folder 'bar'[foo-remote] could not be created. Server responded: ('NO', ['[ALREADYEXISTS] Duplicate folder name bar (Failure)'])

The solution is to provide an inverse nametrans lambda for the local
repository, e.g.

    ~/.offlineimaprc

    [Repository foo-local]
    nametrans = lambda foldername: foldername.replace('bar', 'BAR')

    [Repository foo-remote]
    nametrans = lambda foldername: foldername.replace('BAR', 'bar')

-   For working out the correct inverse mapping. the output of
    offlineimap --info should help.
-   After updating the mapping, it may be necessary to remove all of the
    folders under $HOME/.offlineimap/ for the affected accounts.

> SSL fingerprint does not match

     ERROR: Server SSL fingerprint 'keykeykey' for hostname 'example.com' does not match configured fingerprint. Please verify and set 'cert_fingerprint' accordingly if not set yet.

To solve this, add to ~/.offlineimaprc (in the same section as
ssl = yes) one of the following:

-   either add cert_fingerprint, with the certificate fingerprint of the
    remote server. This checks whether the remote server certificate
    matches the given fingerprint.

     cert_fingerprint = keykeykey

-   or add sslcacertfile with the path to the system CA certificates
    file. Needs ca-certificates installed. This validates the remote ssl
    certificate chain against the Certification Authorities in that
    file.

     sslcacertfile = /etc/ssl/certs/ca-certificates.crt

External links
--------------

-   Official OfflineIMAP mailing list
-   Gnus, Dovecot, OfflineIMAP, search: a HOWTO
    -   This setup worked for me, only difference being I had to add
        mail_location = maildir:~/Maildir to /etc/dovecot/dovecot.conf.
        Also, I used the Gmail configuration above. --Unhammer 09:24, 22
        October 2010 (EDT)

-   Mutt + Gmail + Offlineimap
    -   An outline of brisbin's simple gmail/mutt setup using cron to
        keep offlineimap syncing.

-   Current OfflineIMAP maintainer's fork on GitHub
    -   Note that a strict build of this on current Arch will fail due
        to python references unless they are replaced with python2

Retrieved from
"https://wiki.archlinux.org/index.php?title=OfflineIMAP&oldid=249857"

Category:

-   Email Client
