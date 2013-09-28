Evolution
=========

Evolution is a GNOME mail client it supports IMAP, Microsoft Exchange
Server and Novell GroupWise. It also has a calender function that
supports vcal,csv, google calendar and many more. You can also organise
your contacts, tasks and memos with Evolution. The beautiful thing about
evolution is that it's easy to use and integrates with the gnome
environment. You can see your calendar, tasks and location in the GNOME
panel along with the weather and date. Just add the clock to your gnome
panel.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 IMAP Setup                                                         |
| -   3 Alternative IMAP Setup                                             |
|     -   3.1 Offlineimap setup                                            |
|     -   3.2 First offlineimap sync and automated sync-ing                |
|     -   3.3 Evolution setup for offlineimap's maildir                    |
|                                                                          |
| -   4 GMAIL Setup                                                        |
|     -   4.1 Receiving Mail                                               |
|     -   4.2 Sending Mail                                                 |
|                                                                          |
| -   5 Gmail Calendar                                                     |
| -   6 Tudelft webmail (Exchange)                                         |
| -   7 Using Evolution Outside Of Gnome                                   |
| -   8 Troubleshooting                                                    |
| -   9 References                                                         |
+--------------------------------------------------------------------------+

Installation
------------

Evolution is available from the standard repositories:

    # pacman -S evolution

Support for exchange servers:

    # pacman -S evolution-ews

Support for web calendars (like Google calendar):

    # pacman -S evolution-data-server

IMAP Setup
----------

This is the setup for a standard IMAP mail address. Go to Edit ->
Preferences -> Mail Accounts. Add a mail account insert your Name and
real email adress. Then click 'forward' here you are going to select the
server type, this is IMAP. Now fill in the textbox server, for the
server adress and username. For the rest of the options just follow the
wizard. It is very easy, if you get stuck read this guide [1].

Unfortunately, Evolution currently (version 2.26) suffers from a serious
IMAP issue, as reported in [2]. It appears this issue has existed for at
least the past 3 years prior to this version, and it shows no signs of
being dealt with soon. This bug especially affects to the point of
unuseability those with slow connections. The next section shows an
alternative IMAP connectivity method which works better.

Alternative IMAP Setup
----------------------

An alternative to letting Evolution connect directly to the IMAP server
is to sync the IMAP server to your PC. This costs as much hard-disc
space as you have mail, though it is possible to limit the folders
synced in this manner (see below). An additional benefit (primary
inspiration for this app) is that you have a full copy of your email,
including attachments, on your PC for retrieval, even if on the move
without an internet connection.

To set this up, you will need to install offlineimap ([3]). It is
currently in the AUR, as well as in community, so just run the
following:-

    #pacman -S offlineimap

> Offlineimap setup

offlineimap takes its settings from the file ~/.offlineimaprc, which you
will need to create. Most users will be able to use the .offlineimaprc
below, for the most common case of a Gmail account. The settings for a
general account are identical, except remotehost, ssl, and remoteport
need to be set appropriately (see the comments below). See the official
README for more information.

    [general]
    accounts = MyAccount
    # Set this to the number of accounts you have.
    maxsyncaccounts = 1
    # You can set ui = TTY.TTYUI for interactive password entry if needed.
    # Setting it within this file (see below) is easier.
    ui = Noninteractive.Basic

    [Account MyAccount]
    # Each account should have a local and remote repository
    localrepository = MyLocal
    remoterepository = MyGmail
    # Specifies how often to do a repeated sync (if running without crond)
    autorefresh = 10

    [Repository MyLocal]
    type = Maildir
    localfolders = /home/path/to/your/maildir
    # This needs to be specified so the MailDir uses a folder structure
    # suitable to Evolution
    sep = /

    [Repository MyGmail]
    # Example for a gmail account
    type = Gmail
    # If using some other IMAP server, uncomment and set the following:-
    #remotehost = imap.gmail.com
    #ssl = yes
    #remoteport = 993
    # Specify the Gmail user name and password.
    remoteuser = yourname@gmail.com
    remotepass = yourpassword
    # realdelete is Gmail specific, setting to no ensures that deleting
    # a message sends it to 'All Mail' instead of the trash.
    realdelete = no
    # Use 1 here first, increase it if your connection (and the server's)
    # supports it.
    maxconnections = 1
    # This translates folder names such that everything (including your Inbox)
    # appears in the same folder (named root).
    nametrans = lambda foldername: re.sub('^Sent$', 'root/Sent',
     re.sub('^(\[G.*ail\]|INBOX)', 'root', foldername))
    # This excludes some folders from being synced. You will almost
    # certainly want to exclude 'All Mail', 'Trash', and 'Starred', at
    # least. Note that offlineimap does NOT honor subscription details.
    folderfilter = lambda foldername: foldername not in ['[Gmail]/All Mail',
     '[Gmail]/Trash','[Gmail]/Spam','[Gmail]/Starred']

WARNING: Please note that any space indenting a line of code in
.offlineimaprc would be considered as appending that line to the
previous line. In other words, always make sure there is no space before
any lines in your config file.

Acknowledgement: This config file was done by referring both to the
official example as well as to the config file in an article on
http://www.linux.com (no longer available).

> First offlineimap sync and automated sync-ing

Once you have completed your offlineimap setup, you should perform your
first sync by running with your normal user account

    $offlineimap

Assuming you've set your password and all other settings correctly,
offlineimap will begin to sync the requested repositories. This may take
a long while, depending on connection speed and size of your mail
account, so you should preferably find a fast connection to do this. You
can run offlineimap using another interface by specifying

    $offlineimap -u TTY.TTYUI

This allows interactive entry of passwords.

Once you've completed your first sync, you'll want to set up automatic
syncing. This can be done using crond, or just by running offlineimap on
startup. The disadvantage of running offlineimap on startup (with
autorefresh set) is that if for any reason an error appears, your mail
will just stop syncing from that point onwards. So, running through
crond requires you to add the following line to your crontab.

    */10 * * * * /path/to/scripts/runofflineimap >/dev/null 2>&1

For those unfamiliar with crontab and/or vi, just run

    $crontab -e

Press 'i' to start input, type in the line above, press Esc to escape
back to the prompt, and type ':wq' to save and quit.
/path/to/scripts/runofflineimap should run offlineimap itself (with -o
for a single run). Here is an example script for that:-

    #!/bin/sh
    # Run offlineimap through cron to fetch email periodically
    ps aux | grep "\/usr\/bin\/offlineimap"
    if [ $? -eq "0" ]; then
            logger -i -t offlineimap "Another instance of offlineimap running. Exiting."
            exit 0;
    else
            logger -i -t offlineimap "Starting offlineimap..."
            offlineimap -u Noninteractive.Quiet -o
            logger -i -t offlineimap "Done offlineimap..."
    	exit 0;
    fi

You should now have an automatically synced local copy of your IMAP
server. Error messages (if any) will be shown in /var/log/cron.d or one
of its variants.

> Evolution setup for offlineimap's maildir

This is really quite simple, use Evolution's Account Assistant and
select the Server Type "Maildir-format mail directories", under the
Receiving Email section. Select also the path to your maildir (the
'root' folder if you're using a modified version of the .offlineimaprc
above). You can change your 'Checking for New Mail' option to something
very short, even 1 minute, since this only checks your local copy and
not the server-side copy. SMTP settings are according to normal usage
(does not go through offlineimap).

GMAIL Setup
-----------

To setup a GMail account, go to Edit -> Preferences -> Mail Accounts and
enter your mail account details.

> Receiving Mail

-   Server Type: POP
-   Server: pop.gmail.com
-   Username: <username>@gmail.com
-   Use Secure Connecetion: SSL encryption
-   Authenthication Type: Password

Optionally fill in automatically check for new mail every ** minutes.
The rest is user specific.

> Sending Mail

-   Server type: SMTP
-   Server: smtp.gmail.com
-   Port: 587
-   Server requires authentication: Checked
-   Use Secure Connection: TSL
-   Fill in Username: <username>@gmail.com
-   Authentication: PLAIN or Login

You are now finished with configuring evolution for gmail. Just hit
Send/ Receive in the main screen and wait for new mail. If it still
didn't work, go to this link [4]

Gmail Calendar
--------------

You can use your gmail calendar in evolution here's how:

Go to your calendar in your browser. Click on manage calendars -> the
click on the calendar you want to add -> In the Private URL section copy
the URL of ICAL (green button).

Now go to Evolution. Click on file -> new -> calendar . In the 'new
calendar dialog box' select type: On The Web. You can fill in your own
calendar name Then Copy the URL to the URL field

Now you will see your google calendar in your calendar view in Evolution
by the name you gave it in the Name field.

Variant2 (with evolution-webcal):

From Evolution click on -> new -> calendar . In the 'new calendar dialog
box' select type: Google. You can fill in your own calendar name. Insert
your username (not the email). Click the button "Get List" and choose
the calendar you want to use.

Tudelft webmail (Exchange)
--------------------------

This is the setup for your tudelft webmail for evolution. It might also
work for other webmail based email accounts.

Go to Edit -> Preferences -> Mail Accounts and make a mail account. For
your Email Adress: <netid>@gmail.com . Be carefull your
<netid>@student.tudelft.nl must be like this example:
E.M.devries@student.tudelft.nl

Receiving mail: Server type: Microsoft Exchange Username: <netid> this
is just your netid like this example: edevries OWA URL:
https://webmail.tudelft.nl -> now click 'Authenticate' and fill in your
password. The mailbox will be filled in automaticlly

Click Forward: The receiving options are already correct, you can select
the option to automaticlly receive email every x minutes.

Click Forward: Now just fill in the name of the mailbox and you are
done.

Using Evolution Outside Of Gnome
--------------------------------

In order to use Evolution outside of Gnome desktop you must export
gnome-keyring:

    #!/bin/bash
    eval \`gnome-keyring-daemon\`
    export GNOME_KEYRING_PID
    export GNOME_KEYRING_SOCKET
    exit

Run the above script before starting Evolution. Reboot or remove the
appropriate files in your /tmp directory prior to running.

Troubleshooting
---------------

If after some system upgrade one gets no accounts in Evolution then all
is not lost. First, we can see if we got our account files in
~/.evolution/, if so, then the only solution is to just make a new
account in Evolution with the same parameters. (I only lost the
signatures

References
----------

Gnome Evolution Guide

Tudelft Evolution 2.24 Setup

Retrieved from
"https://wiki.archlinux.org/index.php?title=Evolution&oldid=244571"

Category:

-   Email Client
