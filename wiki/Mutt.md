Mutt
====

Summary

A guide on configuring and using Mutt.

Related

fdm

msmtp

offlineimap

Mutt is a text-based mail client renowned for its powerful features.
Though over a decade old, Mutt remains the mail client of choice for a
great number of power-users. Unfortunately, a default Mutt install is
plagued by complex keybindings along with a daunting amount of
documentation. This guide will help the average user get Mutt up and
running, and begin customizing it to their particular needs.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Installing                                                         |
| -   3 Configuring                                                        |
|     -   3.1 IMAP                                                         |
|         -   3.1.1 Using native IMAP support                              |
|             -   3.1.1.1 imap_user                                        |
|             -   3.1.1.2 imap_pass                                        |
|             -   3.1.1.3 folder                                           |
|             -   3.1.1.4 spoolfile                                        |
|             -   3.1.1.5 mailboxes                                        |
|             -   3.1.1.6 Summary                                          |
|                                                                          |
|         -   3.1.2 External IMAP support                                  |
|                                                                          |
|     -   3.2 POP3                                                         |
|         -   3.2.1 Retrieving mail                                        |
|             -   3.2.1.1 More than one Email account with getmail         |
|                                                                          |
|         -   3.2.2 Sorting mail                                           |
|                                                                          |
|     -   3.3 Maildir                                                      |
|     -   3.4 SMTP                                                         |
|         -   3.4.1 Folders                                                |
|         -   3.4.2 Using native SMTP support                              |
|         -   3.4.3 External SMTP support                                  |
|         -   3.4.4 Sending mails from Mutt                                |
|                                                                          |
|     -   3.5 Multiple accounts                                            |
|     -   3.6 Passwords management                                         |
|                                                                          |
| -   4 Advanced features                                                  |
|     -   4.1 E-mail character encoding                                    |
|     -   4.2 Printing                                                     |
|     -   4.3 Custom mail headers                                          |
|     -   4.4 Signature block                                              |
|         -   4.4.1 Random signature                                       |
|                                                                          |
|     -   4.5 Viewing URLs & opening your favorite web browser             |
|     -   4.6 Viewing HTML                                                 |
|     -   4.7 Mutt and Vim                                                 |
|     -   4.8 Mutt and GNU nano                                            |
|     -   4.9 Mutt and Emacs                                               |
|     -   4.10 Colors                                                      |
|     -   4.11 Index Format                                                |
|     -   4.12 Contact management                                          |
|         -   4.12.1 Address aliases                                       |
|         -   4.12.2 Abook                                                 |
|                                                                          |
|     -   4.13 Request IMAP mail retrieval manually                        |
|     -   4.14 Avoiding slow index on large (IMAP) folders due to coloring |
|     -   4.15 Speed up folders switch                                     |
|     -   4.16 Use Mutt to send mail from command line                     |
|     -   4.17 Composing HTML e-mails                                      |
|     -   4.18 How to display another email while composing                |
|     -   4.19 Archive treated e-mails                                     |
|     -   4.20 Mutt-Sidebar                                                |
|     -   4.21 Migrating mails from one computer to another                |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Backspace does not work in Mutt                              |
|     -   5.2 Android's default MUA receives empty e-mail with attachment  |
|         "Unknown.txt"                                                    |
|     -   5.3 The change-folder function always prompt for the same        |
|         mailbox                                                          |
|     -   5.4 I cannot change folder when using Mutt read-only (Mutt -R)   |
|                                                                          |
| -   6 Documentation                                                      |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Overview
--------

Mutt focuses primarily on being a Mail User Agent (MUA), and was
originally written to view mail. Later implementations added for
retrieval, sending, and filtering mail are simplistic compared to other
mail applications and, as such, users may wish to use external
applications to extend Mutt's capabilities.

Nevertheless, the Arch Linux mutt package is compiled with IMAP, POP3
and SMTP support, removing the necessity for external applications.

This article covers using both native IMAP sending and retrieval, and a
setup depending on OfflineIMAP or getmail (POP3) to retrieve mail,
procmail to filter it in the case of POP3, and msmtp to send it.

Installing
----------

Install mutt, available in the Official Repositories.

Optionally install external helper applications for an IMAP setup, such
as offlineimap and msmtp.

Or (if using POP3) getmail or fdm and procmail.

Note:

-   If you just need the authentication methods LOGIN and PLAIN, these
    are satisfied with the dependency libsasl
-   If you want to (or have to) use CRAM-MD5, GSSAPI or DIGEST-MD5,
    install the package cyrus-sasl-gssapi
-   If you are using Gmail as your SMTP server, you may need to install
    the package cyrus-sasl

Configuring
-----------

This section covers IMAP, #POP3, #Maildir and #SMTP configuration.

Note that Mutt will recognize two locations for its configuration file;
~/.muttrc and ~/.mutt/muttrc. Either location will work. You should also
know some prerequisite for Mutt configuration. Its syntax is very close
the Bourne Shell. For example, you can get the content of another config
file:

    source /path/to/other/config/file

You can use variables and assign the result of shell commands to them.

    set editor=`echo \$EDITOR`

Here the $ gets escaped so that it does not get substituted by Mutt
before being passed to the shell. Also note the use of the backquotes,
as bash syntax $(...) does not work. Mutt has a lot of predefined
variables, but you can also set your own. User variable must begin with
"my"!

    set my_name = "John Doe"

> IMAP

Native and external setups

Using native IMAP support

The pacman version of Mutt is compiled with IMAP support. At the very
least you need to have 4 lines in your muttrc file to be able to access
your mail.

imap_user

    set imap_user=USERNAME

Continuing with the previous example, remember that Gmail requires your
full email address (this is not standard):

    set imap_user=your.username@gmail.com

imap_pass

If unset, the password will be prompted for.

    set imap_pass=SECRET

folder

Instead of a local directory which contains all your mail (and
directories), use your server (and the highest folder in the hierarchy,
if needed).

    set folder=imap[s]://imap.server.domain[:port]/[folder/]

You do not have to use a folder, but it might be convenient if you have
all your other folders inside your INBOX, for example. Whatever you set
here as your folder can be accessed later in Mutt with just an equal
sign (=) or a plus sign (+). Example:

    set folder=imaps://imap.gmail.com/

It should be noted that for several accounts, it is best practice to use
different folders -- e.g. for account-hook. If you have several Gmail
account, use

    set folder=imaps://username@imap.gmail.com/

instead, where your account is username@gmail.com. This way it will be
possible to distinguish the different folders. Otherwise it would lead
to authentication errors.

spoolfile

The spoolfile is the folder where your (unfiltered) e-mail arrives. Most
e-mail services conventionally names it INBOX. You can now use '=' or
'+' as a substitution for the full folder path that was configured
above. For example:

    set spoolfile=+INBOX

mailboxes

Any imap folders that should be checked regularly for new mail should be
listed here:

    mailboxes =INBOX =family
    mailboxes imaps://imap.gmail.com/INBOX imaps://imap.gmail.com/family

Alternatively, check for all subscribed IMAP folders (as if all were
added with a mailboxes line):

    set imap_check_subscribed

These two versions are equivalent if you want to subscribe to all
folders. So the second method is much more convenient, but the first one
gives you more flexibility. Also, newer Mutt versions are configured by
default to include a macro bound to the 'y' key which will allow you to
change to any of the folders listed under mailboxes.

If you do not set this variable, the spoolfile will be used by default.
This variable is also important for the sidebar.

Summary

Using these options, you will be able to start Mutt, enter your IMAP
password, and start reading your mail. Here is a muttrc snippet (for
Gmail) with some other lines you might consider adding for better IMAP
support.

    set folder      = imaps://imap.gmail.com/
    set imap_user   = your.username@gmail.com
    set imap_pass   = your-imap-password
    set spoolfile   = +INBOX
    mailboxes       = +INBOX

    # Store message headers locally to speed things up.
    # If hcache is a folder, Mutt will create sub cache folders for each account which may speeds things even more up.
    set header_cache = ~/.cache/mutt

    # Store messages locally to speed things up, like searching message bodies.
    # Can be the same folder as header_cache.
    # This will cost important disk usage according to your e-mail amount.
    set message_cachedir = "~/.cache/mutt"

    # Specify where to save and/or look for postponed messages.
    set postponed = +[Gmail]/Drafts

    # Allow Mutt to open new imap connection automatically.
    unset imap_passive

    # Keep IMAP connection alive by polling intermittently (time in seconds).
    set imap_keepalive = 300

    # How often to check for new mail (time in seconds).
    set mail_check = 120

External IMAP support

While IMAP-functionality is built into Mutt, it does not download mail
for offline-use. The OfflineIMAP article describes how to download your
emails to a local folder which can then be processed by Mutt.

Consider using applications such as spamassassin or imapfilter to sort
mail.

> POP3

Retrieving and sorting mail with external applications

Retrieving mail

Create the directory ~/.getmail/. Open the file ~/.getmail/getmailrc in
your favorite text editor.

Here is an example getmailrc used with a gmail account.

    [retriever]
    type = SimplePOP3SSLRetriever
    server = pop.gmail.com
    username = username@gmail.com
    port = 995
    password = password

    [destination]
    type = Maildir
    path = ~/mail/

You can tweak this to your POP3 service's specification.

Most people will like to add the following section to their getmailrc to
prevent all the mail on the server being downloaded every time getmail
is ran.

    [options]
    read_all = False

As you can see ~/.getmail/getmailrc contains sensitive information
(namely, email account passwords in plain text). You will want to change
access permissions to the directory so only the owner can see it:

    $ chmod 700 ~/.getmail

For this guide we will be storing our mail in the maildir format. The
two main mailbox formats are mbox and maildir. The main difference
between the two is that mbox is one file, with all of your mails and
their headers stored in it, whereas a maildir is a directory tree. Each
mail is its own file, which will often speed things up.

A maildir is just a folder with the folders cur, new and tmp in it.

       mkdir -p ~/mail/{cur,new,tmp}

Now, run getmail. If it works fine, you can create a cronjob for getmail
to run every n hours/minutes. Type crontab -e to edit cronjobs, and
enter the following:

     */10 * * * * /usr/bin/getmail

That will run getmail every 10 minutes.

Also, to quiet getmail down, we can reduce its verbosity to zero by
adding the following to getmailrc.

    [options]
    verbose = 0

More than one Email account with getmail

By default, when you run getmail the program searches for the file
getmailrc created as seen above. If you have more than one mail account
you would like to get mail from, then you can create such a file for
each email address, and then tell getmail to run using both of them.
Obviously if you have two accounts and two files you cannot have both of
them called getmailrc. What you do is give them two different names,
using myself as an example: I call one personal, and one university.
These two files contain content relevant to my personal mail, and my
university work mail respectively. Then to get getmail to work on these
two files, instead of searching for getmailrc(default), I use the
--rcfile switch like so: getmail --rcfile university --rcfile personal
This can work with more files if you have more email accounts, just make
sure each file is in the .getmail directory and make sure to alter the
cronjob to run the command with the --rcfile switches. E.g.

     */30 * * * * /usr/bin/getmail --rcfile university --rcfile personal

Obviously you can call your files whatever you want, providing you
include them in the cronjob or shell command, and they are in the
.getmail/ directory, getmail will fetch mail from those two accounts.

Sorting mail

Procmail is an extremely powerful sorting tool. For the purposes of this
wiki, we will do some primitive sorting to get started.

You must edit your getmailrc to pass retrieved mail to procmail:

    [destination]
    type = MDA_external
    path = /usr/bin/procmail

Now, open up .procmailrc in your favorite editor. The following will
sort all mail from the happy-kangaroos mailing list, and all mail from
your lovey-dovey friend in their own maildirs.

    MAILDIR=$HOME/mail
    DEFAULT=$MAILDIR/inbox/
    LOGFILE=$MAILDIR/log

    :0:
    * ^To: happy-kangaroos@nicehost.com
    happy-kangaroos/

    :0:
    * ^From: loveydovey@iheartyou.net
    lovey-dovey/

After you have saved your .procmailrc, run getmail and see if procmail
succeeds in sorting your mail into the appropriate directories.

Note:One easy to make mistake with .procmailrc is the permission.
procmail require it to have permission 644 and will not give meaningless
error message if you do not.

> Maildir

Maildir is a generic and standardized format. Almost every MUA is able
to handle Maildirs and Mutt's support is excellent. There are just a few
simple things that you need to do to get Mutt to use them. Open your
muttrc and add the following lines:

    set mbox_type=Maildir
    set folder=$HOME/mail
    set spoolfile=+/
    set header_cache=~/.cache/mutt

This is a minimal Configuration that enables you to access your Maildir
and checks for new local Mails in INBOX. This configuration also caches
the headers of the eMails to speed up directory-listings. It might not
be enabled in your build (but it sure is in the Arch-Package). Note that
this does not affect OfflineIMAP in any way. It always syncs the all
directories on a Server. spoolfile tells Mutt which local directories to
poll for new Mail. You might want to add more Spoolfiles (for example
the Directories of Mailing-Lists) and maybe other things. But this is
subject to the Mutt manual and beyond the scope of this document.

> SMTP

Whether you use POP or IMAP to receive mail you will probably still send
mail using SMTP.

Folders

There is basically only one important folder here: the one where all
your sent e-mails will be saved.

    record = +Sent

Gmail saves automatically sent e-mail to +[Gmail]/Sent, so we do not
want duplicates.

    unset record

Using native SMTP support

The pacman version of Mutt is also compiled with SMTP support. Just
check the online manual muttrc, or man muttrc for more information.

For example:

    set my_pass='mysecretpass'
    set my_user=myname

    set smtp_url=smtps://$my_user:$my_pass@smtp.domain.tld
    set ssl_force_tls = yes

Note that if your SMTP credentials are the same as your IMAP
credentials, then you can use those variables:

    set smtp_url=smtps://$imap_user:$imap_pass@smtp.domain.tld

You may need to tweak the security parameters. If you get an error like
SSL routines:SSL23_GET_SERVER_HELLO:unknown protocol, then your server
most probably uses the SMTP instead of SMTPS.

    set smtp_url=smtp://$imap_user:$imap_pass@smtp.domain.tld

There is other variable that you may need to set. For example for use of
STARTTLS:

    set ssl_starttls = yes

External SMTP support

An external SMTP agent such as msmtp, SSMTP or opensmtpd can also be
used. This section exclusively covers configuring Mutt for msmtp.

Edit Mutt's configuration file or create it if unpresent:

    muttrc

    set realname='Disgruntled Kangaroo'

    set sendmail="/usr/bin/msmtp"

    set edit_headers=yes
    set folder=~/mail
    set mbox=+mbox
    set spoolfile=+inbox
    set record=+sent
    set postponed=+drafts
    set mbox_type=Maildir

    mailboxes +inbox +lovey-dovey +happy-kangaroos

Sending mails from Mutt

Now, startup mutt:

You should see all the mail in ~/mail/inbox. Press m to compose mail; it
will use the editor defined by your EDITOR environment variable. If this
variable is not set, you can fix it before starting Mutt:

    $ export EDITOR=your-favorite-editor
    $ mutt

You should store the EDITOR value into your shell resource configuration
file (such as bashrc). You can also set the editor from Mutt's
configuration file:

    .muttrc

    set editor=your-favorite-editor

For testing purposes, address the letter to yourself. After you have
written the letter, save and exit the editor. You will return to Mutt,
which will now show information about your e-mail. Press y to send it.

> Multiple accounts

Now you should have a working configuration for one account at least.
You might wonder how to use several accounts, since we put everything
into a single file.

Well all you need is to write account-specific parameters to their
respective files and source them. All the IMAP/POP3/SMTP config for each
account should go to its respective folder.

Warning:When one account is setting a variable that is not specified for
other accounts, you must unset it for them, otherwise configuration will
overlap and you will most certainly experience unexpected behaviour.

Mutt can handle this thanks to one of its most powerful feature: hooks.
Basically a hook is a command that gets executed before a specific
action. There are several hook availables. For multiple accounts, you
must use account-hooks and folder-hooks.

-   Folder-hooks will run a command before switching folders. This is
    mostly useful to set the appropriate SMTP parameters when you are in
    a specific folder. For instance when you are in your work mailbox
    and you send a e-mail, it will automatically use your work account
    as sender.
-   Account-hooks will run a command everytime Mutt calls a function
    related to an account, like IMAP syncing. It does not require you to
    switch to any folder.

Hooks take two parameters:

    account-hook [!]regex command
    folder-hook [!]regex command

The regex is the folder to be matched (or not if preceded by the !). The
command tells what to do.

Let's give a full example:

    .muttrc

    ## General options
    set header_cache = "~/.cache/mutt"
    set imap_check_subscribed
    set imap_keepalive = 300
    unset imap_passive
    set mail_check = 60
    set mbox_type=Maildir

    ## ACCOUNT1
    source "~/.mutt/work"
    # Here we use the $folder variable that has just been set in the sourced file.
    # We must set it right now otherwise the 'folder' variable will change in the next sourced file.
    folder-hook $folder 'source ~/.mutt/work'

    ## ACCOUNT2
    source "~/.mutt/personal"
    folder-hook *user@gmail.com/ 'source ~/.mutt/personal'
    folder-hook *user@gmail.com/Family 'set realname="Bob"'

    .mutt/work

    ## Receive options.
    set imap_user=user@gmail.com
    set imap_pass=****
    set folder = imaps://user@imap.gmail.com/
    set spoolfile = +INBOX
    set postponed = +Drafts
    set record = +Sent

    ## Send options.
    set smtp_url=smtps://user:****@smtp.gmail.com
    set realname='User X'
    set from=user@gmail.com
    set hostname="gmail.com"
    set signature="John Doe"
    # Connection options
    set ssl_force_tls = yes
    unset ssl_starttls

    ## Hook -- IMPORTANT!
    account-hook $folder "set imap_user=user@gmail.com imap_pass=****"

Finally .mutt/personal should be similar to .mutt/work.

Now all your accounts are set, start Mutt. To switch from one account to
another, just change the folder (c key). Alternatively you can use the
sidebar.

To change folder for different mailboxes you have to type the complete
address -- for IMAP/POP3 folders, this may be quite inconvenient --
let's bind some key to it.

    ## Shortcuts
    macro index,pager <f2> '<sync-mailbox><enter-command>source ~/.mutt/personal<enter><change-folder>!<enter>'
    macro index,pager <f3> '<sync-mailbox><enter-command>source ~/.mutt/work<enter><change-folder>!<enter>'

With the above shortcuts (or with the sidebar) you will find that
changing folders (with c by default) is not contextual, i.e. it will not
list the folders of the current mailbox, but of the one used the last
time you changed folders. To make the behaviour more contextual, the
trick is to press = or + for current mailbox. You can automate this with
the following macro:

    macro index 'c' '<change-folder>?<change-dir><home>^K=<enter>'

> Passwords management

Keep in mind that writing your password in .muttrc is a security risk,
and it might be of your concern. The trivial way to keep your passwords
safe is not writing them in the config file. Mutt will then prompt for
it when needed. However, this is quiet combersome in the long run,
especiallly if you have several accounts.

Here follows a smart and convenient solution: all your passwords are
encrypted into one file and Mutt will prompt for a passphrase on startup
only. You can opt for a keyring tool (e.g. GPG, pwsafe) or an encryption
tool like ccrypt, which may be more simple and straightforward to use.
Since GPG is a Mutt dependency, we will use it here.

First create a pair of public/private keys:

    gpg --gen-key

If you do not understand this process have a look at
Wikipedia:Asymmetric cryptography.

Create a file in a secure environment since it will contain your
passwords for a couple of seconds:

    ~/.my-pwds

    set my_pw_personal = ****
    set my_pw_work = ****

Note:Remember that user defined variables must start with my

Now encrypt the file:

    gpg -e -r <your-name> ~/.my-pwds

Note that <your-name> must match the one you provided at the
gpg --gen-key step. Now you can wipe your file containing your passwords
in clear:

    shred -xu ~/.my-pwds

Back to your account dedicated files, e.g. .mutt/personal_config:

    set imap_pass=$my_pw_personal
    # Every time the password is needed, use $my_pw_personal variable.

And in your .muttrc, before you source any account dedicated file:

    source "gpg2 -dq ~/.my-pwds.gpg |"

-   The -q parameter makes gpg2 quiet which prevents gpg2 output messing
    with Mutt interface.
-   The pipe | at the end of a string is the Mutt syntax to tell that
    you want the result of what is preceeding.

Explanation: when Mutt starts, it will first source the result of the
password decryption, that's why it will prompt for a passphrase. Then
all passwords will be stored in memory in specific variables for the
time Mutt runs. Then when a folder-hook is called, is sets the imap_pass
variable to the variable holding the appropriate password. When
switching account, the imap_pass variable will be set to another
variable holding another password, etc.

If you use external tools like OfflineIMAP and msmtp, you need to set up
an agent (e.g. gpg-agent, see GnuPG#gpg-agent) to keep the passphrase
into cache and thus avoiding those tools always prompting for it.

Advanced features
-----------------

Guides to get you started with using & customizing Mutt :

-   My first Mutt (maintained by Bruno Postle)
-   The Woodnotes Guide to the Mutt Email Client (maintained by Randall
    Wood)
-   The Homely Mutt (by Steve Losh)

If you have any Mutt specific questions, feel free to ask in the irc
channel.

> E-mail character encoding

You may be concerned with sending e-mail in a decent character set
(charset for short) like UTF-8. Nowadays UTF-8 is highly recommended to
almost everyone.

When using Mutt there is two levels where the charset must be specified:

-   The text editor used to write the e-mail must save it in the desired
    encoding.
-   Mutt will then check the e-mail and determine which encoding is the
    more apropriate according to the priority you specified in the
    send_charset variable. Default: "us-ascii:iso-8859-1:utf-8".

So if you write an e-mail with characters allowed in ISO-8859-1 (like
'résumé'), but without characters specific to Unicode, then Mutt will
set the encoding to ISO-8859-1.

To avoid this behaviour, set the variable in your muttrc:

    set send_charset="us-ascii:utf-8"

or even

    set send_charset="utf-8"

The first compatible charset starting from the left will be used. Since
UTF-8 is a superset of US-ASCII it does not harm to leave it in front of
UTF-8, it may ensure old MUA will not get confused when seeing the
charset in the e-mail header.

> Printing

You can install muttprint from the AUR for a fancier printing quality.
In your muttrc file, insert:

    set print_command="/usr/bin/muttprint %s -p {PrinterName}"

> Custom mail headers

One of the greatest thing in Mutt is that you can have full control over
your mail header.

First, make your headers editable when you write e-mails:

    set edit_headers=yes

Mutt also features a special function my_hdr for customizing your
header. Yes, it is named just like a variable, but in fact it is a
function.

You can clear it completely, which you should do when switching accounts
with different headers, otherwise they will overlap:

    unmy_hdr *

Other variables have also an impact on the headers, so it is wise to
clear them before using my_hdr:

    unset use_from
    unset use_domain
    unset user_agent

Now, you can add any field you want -- even non-standard one -- to your
header using the following syntax:

    my_hdr <FIELD>: <VALUE>

Note that <VALUE> can be the result of a command.

Example:

    ## Extra info.
    my_hdr X-Info: Keep It Simple, Stupid.

    ## OS Info.
    my_hdr X-Operating-System: `uname -s`, kernel `uname -r`

    ## This header only appears to MS Outlook users
    my_hdr X-Message-Flag: WARNING!! Outlook sucks

    ## Custom Mail-User-Agent ID.
    my_hdr User-Agent: Every email client sucks, this one just sucks less.

> Signature block

Create a .signature in your home directory. Your signature will be
appended at the end of your email. Alternatively you can specify a file
in your Mutt configuration:

    set signature="path/to/sig/file"

Random signature

You can use fortune to add a random signature to Mutt.

    $ pacman -S fortune-mod

Create a fortune file and then add the following line to your .muttrc:

    set signature="fortune pathtofortunefile|"

Note the pipe at the end. It tells Mutt that the specified string is not
a file, but a command.

> Viewing URLs & opening your favorite web browser

Your should start by creating a .mutt directory in $HOME if not done
yet. There, create a file named macros. Insert the following:

     macro pager \cb <pipe-entry>'urlview'<enter> 'Follow links with urlview'

Then install urlview from the AUR.

Create a .urlview in $HOME and insert the following:

    REGEXP (((http|https|ftp|gopher)|mailto)[.:][^ >"\t]*|www\.[-a-z0-9.]+)[^ .,;\t>">\):]
    COMMAND <your-browser> %s 

When you read an email on the pager, hitting ctrl+b will list all the
urls from the email. Navigate up or down with arrow keys and hit enter
on the desired url. Your browser will start and go to the selected site.

Some browser will require additional arguments to work properly. For
example, Luakit will close on Mutt exit. You need to fork it to
background, using the -n parameter:

    COMMAND luakit -n %s 2>/dev/null

The 2>/dev/null is to make it quiet, i.e. to prevent useless message
printing where you do not want them to.

-   Note - If you have some problems with urlview due to Mutt's url
    encoding you can try extract_url.pl

-   Note - If you would like to see a short contextual preview of the
    content around each URL, try urlscan. The macro in your muttrc is
    the same as for urlview (except for the 'urlscan' command). There is
    no additional configuration required other than ensuring $BROWSER is
    set.

> Viewing HTML

It is possible to pass the html body to an external HTML program and
then dump it, keeping email viewing uniform and unobtrusive. Two
programs are described here: lynx and w3m.

Install lynx or w3m:

    pacman -S lynx

or

    pacman -S w3m

If ~/.mutt/mailcap does not exist you will need to create it and save
the following to it.

    text/html; lynx -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput

or, in case of w3m,

    text/html; w3m -I %{charset} -T text/html; copiousoutput;

Edit muttrc and add the following,

    set mailcap_path 	= ~/.mutt/mailcap

To automatically open HTML messages in lynx, add this additional line to
the muttrc:

    auto_view text/html

The beauty of this is, instead of seeing an html body as source or being
opened by a separate program, in this case lynx, you see the formatted
content directly, and any url links within the email can be displayed
with Ctrl+b.

If you receive many emails with multiple or alternate encodings Mutt may
default to treating every email as html. To avoid this, add the
following variable to your ~/.muttrc to have Mutt default to text when
available and use w3m/lynx only when no text version is availble in the
email:

    alternative_order text/plain text/html

> Mutt and Vim

-   To limit the width of text to 72 characters, edit your .vimrc file
    and add:

    au BufRead /tmp/mutt-* set tw=72

-   Another choice is to use Vim's mail filetype plugin to enable other
    mail-centric options besides 72 character width. Edit
    ~/.vim/filetype.vim, creating it if unpresent, and add:

     
    augroup filetypedetect
      " Mail
      autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
    augroup END

-   To set a different tmp directory, e.g. ~/.tmp, add a line to your
    muttrc as follows:

    set tmpdir="~/.tmp"

-   To reformat a modified text see the Vim context help

    :h 10.7

> Mutt and GNU nano

nano is another nice console editor to use with Mutt.

To limit the width of text to 72 characters, edit your .nanorc file and
add:

     set fill 72

Also, in muttrc file, you can specify the line to start editing so that
you will skip the mail header:

     set editor="nano +7"

> Mutt and Emacs

Emacs has a mail and a message major mode. To switch to mail-mode
automatically when Emacs is called from Mutt, you can add the following
to your .emacs:

    .emacs

    ;; Mutt support.
    (setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))

If you usually run Emacs daemon, you may want Mutt to connect to it. Add
this to your .muttrc:

    .muttrc

    set editor="emacsclient -a \"\" -t"

> Colors

Append sample color definitions to your .muttrc file:

    $ cat /usr/share/doc/mutt/samples/colors.linux >> ~/.muttrc

Then adjust to your liking. The actual color each of these settings will
produce depends on the colors set in your ~/.Xresources file.

Alternatively, you can source any file you want containing colors (and
thus act as a theme file):

    source ~/.mutt/colors.zenburn

A nice theme example:

    ## Theme kindly inspired from                                                                                                                                             
    ## http://nongeekshandbook.blogspot.ie/2009/03/mutt-color-configuration.html                                                                                              

    ## Colours for items in the index                                                                                                                                         
    color index brightcyan black ~N
    color index brightred black ~O
    color index brightyellow black ~F
    color index black green ~T
    color index brightred black ~D
    mono index bold ~N
    mono index bold ~F
    mono index bold ~T
    mono index bold ~D

    ## Highlights inside the body of a message.                                                                                                                               

    ## URLs                                                                                                                                                                    
    color body brightgreen black "(http|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
    color body brightgreen black "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"
    mono body bold "(http|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
    mono body bold "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"

    ## Email addresses.                                                                                                                                                       
    color body brightgreen black "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"

    ## Header                                                                                                                                                                 
    color header green black "^from:"
    color header green black "^to:"
    color header green black "^cc:"
    color header green black "^date:"
    color header yellow black "^newsgroups:"
    color header yellow black "^reply-to:"
    color header brightcyan black "^subject:"
    color header red black "^x-spam-rule:"
    color header green black "^x-mailer:"
    color header yellow black "^message-id:"
    color header yellow black "^Organization:"
    color header yellow black "^Organisation:"
    color header yellow black "^User-Agent:"
    color header yellow black "^message-id: .*pine"
    color header yellow black "^X-Fnord:"
    color header yellow black "^X-WebTV-Stationery:"

    color header red black "^x-spam-rule:"
    color header green black "^x-mailer:"
    color header yellow black "^message-id:"
    color header yellow black "^Organization:"
    color header yellow black "^Organisation:"
    color header yellow black "^User-Agent:"
    color header yellow black "^message-id: .*pine"
    color header yellow black "^X-Fnord:"
    color header yellow black "^X-WebTV-Stationery:"
    color header yellow black "^X-Message-Flag:"
    color header yellow black "^X-Spam-Status:"
    color header yellow black "^X-SpamProbe:"
    color header red black "^X-SpamProbe: SPAM"

    ## Coloring quoted text - coloring the first 7 levels:                                                                                                                    
    color quoted cyan black
    color quoted1 yellow black
    color quoted2 red black
    color quoted3 green black
    color quoted4 cyan black
    color quoted5 yellow black
    color quoted6 red black
    color quoted7 green black

    ## Default color definitions                                                                                                                                              
    #color hdrdefault white green                                                                                                                                             
    color signature brightmagenta black
    color indicator black cyan
    color attachment black green
    color error red black
    color message white black
    color search brightwhite magenta
    color status brightyellow blue
    color tree brightblue black
    color normal white black
    color tilde green black
    color bold brightyellow black
    #color underline magenta black                                                                                                                                            
    color markers brightcyan black

    ## Colour definitions when on a mono screen                                                                                                                               
    mono bold bold
    mono underline underline
    mono indicator reverse

> Index Format

Here follows a quick example to put in your .muttrc to customize the
Index Format, i.e. the columns displayed in the folder view.

    set date_format="%y-%m-%d %T"
    set index_format="%2C | %Z [%d] %-30.30F (%-4.4c) %s"

See the Mutt Reference, man 3 strftime and man 3 printf for more
details.

> Contact management

Address aliases

Aliases is the way Mutt manages contacts. An alias is nickname
[longname] <address>.

-   The nickname is what you will type in Mutt to get your contact
    address. One word only, and should be easy to remember.
-   The longname is optional. It may be several words.
-   An <address> must be in a valid form (i.e. with an @).

It is quite simple indeed. Add this to .muttrc:

    set alias_file = "~/.mutt/aliases"
    set sort_alias = alias
    set reverse_alias = yes
    source $alias_file

Explanation:

-   alias_file is the file where the information is getting stored when
    you add an alias from within Mutt.
-   sort_alias specifies which field to use to sort the alias list when
    displayed in Mutt. Possible values: alias, address.
-   reverse_alias sorts in reverse order if set to yes.
-   source $alias_file tells Mutt to read aliases on startup. Needed for
    auto-completion.

Now all you have to do when prompted To: is writing the alias instead of
the full address. The beauty of it is that you can auto-complete the
alias using Tab. Autocompleting a wrong or an empty string will display
the full list. You can select the alias as usual, or by typing its index
number.

There is two ways to create aliases:

-   From Mutt, press a when an e-mail of the targetted person if
    selected.
-   Edit the alias_file manually. The syntax is really simple:

    alias nickname Long Name <my-friend@domain.tld>

Abook

abook is a stand-alone program dedicated to contact management. It uses
a very simple text-based interface and contacts are stored in a plain
text, human-readable database. Besides the desired contact properties
are extensible (birthday, address, fax, and do on).

Abook is specifically designed to be interfaced with Mutt, so that it
can serve as a full, more featured replacement of Mutt internal aliases.
If you want to use Abook instead of aliases, remove the aliases
configuration in .muttrc and add this:

    muttrc

    ## Abook
    set query_command= "abook --mutt-query '%s'"
    macro index,pager  a "<pipe-message>abook --add-email-quiet<return>" "Add this sender to Abook"
    bind editor        <Tab> complete-query

See the man pages abook and abookrc for more details and a full
configuration sample.

> Request IMAP mail retrieval manually

If you do not want to wait for the next automatic IMAP fetching (or if
you did not enable it), you might want to fetch mails manually. There is
a mutt command imap-fetch-mail for that. Alternatively, you could bind
it to a key:

    bind index "^" imap-fetch-mail

> Avoiding slow index on large (IMAP) folders due to coloring

Index highlighting by regex is nice, but can lead to slow folder viewing
if your regex checks the body of the message.

Use folder-hook for only highlighting in for example the inbox (if you
manage to empty your mailbox effiently):

    folder-hook . 'uncolor index "~b \"Hi Joe\" ~R !~T !~F !~p !~P"'
    folder-hook ""!"" 'color index brightyellow black "~b \"Hi Joe\" ~N !~T !~F !~p !~P"'

> Speed up folders switch

Add this to your .muttrc:

    set sleep_time = 0

> Use Mutt to send mail from command line

Man pages will show all available commands and how to use them, but here
are a couple of examples. You could use Mutt to send alerts, logs or
some other system information, triggered by login through .bash_profile,
or as a regular cron job.

Send a message:

    mutt -s "Subject" somejoeorjane@someserver.com < /var/log/somelog

Send a message with attachment:

    mutt -s "Subject" somejoeorjane@someserver.com -a somefile < /tmp/sometext.txt

> Composing HTML e-mails

Since Mutt has nothing of a WYSIWIG client, HTML is quite
straightforward, and you can do much more than with all WYSIWIG mail
clients around since you edit the source code directly. Simply write
your mail using HTML syntax. For example:

    This is normal text<br>
    <b>This is bold text</b>

Now before sending the mail, use the edit-type command (default shortcut
Ctrl+t), and replace text/plain by text/html.

Note:HTML e-mails are regarded by many people as useless, cumbersome,
and subject to reading issues. Mutt can read HTML mails with a text
browser like w3m or lynx, but it has clearly no advantage over a
plain-text e-mail. You should avoid writing HTML e-mails when possible.

> How to display another email while composing

A common complaint with Mutt is that when composing a new mail (or
reply), you cannot open another mail (i.e. for checking with another
correspondent) without closing the current mail (postponing). The
following describes a solution:

First, fire up Mutt as usual. Then, launch another terminal window. Now
start a new Mutt with

    mutt -R

This starts Mutt in read-only mode, and you can browse other emails at
your convenience. It is strongly recommended to always launch a second
Mutt in read-only mode, as conflicts will easily arise otherwise.

Now, this solution calls for a bit of typing, so we would like to
automate this. The following works with Awesome, in other WM's or DE's
similar solutions are probably available: just google how to add a key
binding, and make the desired key execute

    $TERM -e mutt -R 

where $TERM is your terminal.

As for Awesome: edit your rc.lua, and add the following on one of the
first lines, after terminal = "yourTerminal" etc.

    mailview = terminal .. " -e mutt -R"

This automatically uses your preferred terminal, ".." is concatenation
in Lua. Note the space before -e.

Then add the following inside --{{{ Key bindings

    awful.key({ modkey,           }, "m", function() awful.util.spawn(mailview) end),

Omit the final comma if this is the last line. You can, of course use
another key than "m". Now, save&quit, and check your syntax with

    awesome -k

If this is good, restart awesome and give it a try!

Now, a usage example: Launch Mutt as usual. Start a new mail, and then
press "Mod4"+"m". This opens your mailbox in a new terminal, and you can
browse around and read other emails. Now, a neat bonus: exit this
read-only-Mutt with "q", and the terminal window it created disappears!

> Archive treated e-mails

When you read an e-mail, you have four choices: Answer it, Flag it,
Archive it or Delete it. If you have this in mind, you can keep your
inbox slim and fit with this macro (set up for Gmail):

    macro index \' "<tag-pattern>~R !~D !~F<enter>\
    <tag-prefix><save-message>+[Gmail]/All <enter>" \
    "Archive"

> Mutt-Sidebar

The vanilla Mutt does not feature a sidebar unlike most MUAs. If you
miss it, you can install mutt-sidebar from the AUR which features a
patch for a list of folders on the left side of the Mutt window.

For a while there has been several different patches for the sidebar.
Since the late 2000's, it seems like the main patch is maintained at
Lunar Linux. See the documentation there. Note that the patch also
updates the muttrc man page, so have a look at the sidebar_* sections.

You can choose to display the sidebar on startup, or to prompt it
manually with a key:

    set sidebar_visible = yes
    macro index b '<enter-command>toggle sidebar_visible<enter><refresh>'
    macro pager b '<enter-command>toggle sidebar_visible<enter><redraw-screen>'

You also probabaly need some shortcuts to navigate in the bar:

    # Ctrl-n, Ctrl-p to select next, previous folder.
    # Ctrl-o to open selected folder.
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open

Note:You must set the mailboxes variables or the imap_check_subscribed
to tell the sidebar which folder should be displayed. See the mailboxes
section.

If you use the imap_check_subscribed option to list all your folders,
they will appear in an uncontrollable order in the sidebar. Fix it with

    set sidebar_sort = yes

Note that with the mailboxes option, folders appear in the order they
were set to mailboxes if you do not use the sidebar_sort option.

If you have trouble with truncated names, set the option

    set sidebar_shortpath = yes

Finally, you may want to add a separator between different mailboxes.
The sidebar patch does not currently provide any kind of separator
option. A simple (and dirty) workaround is to add a fake folder to the
list of folders:

    mailboxes "+-- My mailbox -----------"

The dashes are not required, they are here just for fancy output. It
will also work if you used the imap_check_subscribed option. If you
chose to sort the folders, the separator will not appear in the correct
place, so an even more dirty workaround is to add an 'A' in front of the
name. Note that punctuation is ignored during sorting.

    mailboxes "+A-- My mailbox -----------"

> Migrating mails from one computer to another

In case you are transfering your mails to a new machine (copy&paste),
you probably need to delete the header cache (a file or folder like
~/.cache/mutt if you followed the above configuration) to make Mutt able
to read your migrated E-Mails. Otherwise Mutt may freeze.

Note that if you had a folder created for you header cache, all
mailboxes will have their own cache file, so you can delete caches
individually without having to remove everything.

Troubleshooting
---------------

> Backspace does not work in Mutt

This is a common problem with some xterm-like terminals. Two solutions:

-   Either rebind the key in .muttrc

    bind index,pager ^? previous-page

Note that ^? is one single character representing backspace in Caret
notation. To type in Emacs, use Ctrl+q Backspace, in Vim
Ctrl+v Backspace.

-   Or fix your terminal:

    $ infocmp > termbs.src

Edit termbs.src and change kbs=^H to kbs=\177, then:

    $ tic -x termbs.src

> Android's default MUA receives empty e-mail with attachment "Unknown.txt"

This is because Mutt adds 'Content-Disposition' line to every e-mail
header. This line is actually correct, the issue comes from Android 2
MUA misinterpreting it. This bug seems to be fixed in the Android 4 MUA.
There is a patched version for Android available in the AUR. Installing
mutt-android-patch will fix the issue.

> The change-folder function always prompt for the same mailbox

This is not a bug, this is actually an intended behaviour. See the
multiple accounts section for a workaround.

> I cannot change folder when using Mutt read-only (Mutt -R)

This is certainly because you are use are using macros like this one:

    macro index,pager <f2> '<sync-mailbox><enter-command>source ~/.mutt/personal<enter><change-folder>!<enter>'

This macro tells Mutt to sync (which is a write operation) before
switching. Either use the sidebar or set another macro:

    macro index,pager <f3> '<enter-command>source ~/.mutt/personal<enter><change-folder>!<enter>'

Documentation
-------------

Newcomers may find it quite hard to find help for Mutt. Actually most of
the topics are covered in the official documentation. We urge you to
read it.

-   The official manual. The stock mutt package for Arch Linux also
    installs the HTML and plain text manual at /usr/share/doc/mutt/.
-   The mutt and muttrc man pages.

See also
--------

-   The official Mutt website
-   The Mutt wiki
-   Brisbin's great guide on how to setup different IMAP accounts with
    Mutt, offlineimap, msmtp
-   A Quick Guide to Mutt
-   Documentation on Configuring Getmail with rcfiles
-   Steve Losh on Mutt, offlineimap, msmtp, notmuch (gmail focussed)
-   muttrc builder

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mutt&oldid=255970"

Category:

-   Email Client
