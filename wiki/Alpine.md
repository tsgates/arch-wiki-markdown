Alpine
======

Alpine is based on pine, a text-based E-mail and newsclient that was
originally released by the university of Washington in 1991. It is an
easier to use alternative to mutt, a more lightweight approach to the
mail reader concept.

Right now, this article is just a quick and dirty guide for configuring
Alpine to use a remote mailserver with IMAP.

As of August 26 2008 the development of Alpine seems to have ended.
Another fork called re-alpine has been made to continue the project.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration for use with IMAP                                    |
|     -   2.1 Saving the password                                          |
|                                                                          |
| -   3 Setting up other IMAP folders                                      |
| -   4 Setting up a proper return address                                 |
| -   5 Built in help                                                      |
| -   6 What else can you configure?                                       |
| -   7 External links                                                     |
| -   8 Printing from alpine                                               |
+--------------------------------------------------------------------------+

Installation
------------

Alpine is a package in Extra with some light dependencies, libldap,
heimdal>=1.2, and gettext but you can grab them all with:

    pacman -S re-alpine

You might also want to grab something to check your spelling, like:

    pacman -S aspell

Configuration for use with IMAP
-------------------------------

Alpine can be configured directly from the config file in your home
folder called ".pinerc", but it's usually easier to use the in program
configuration tools (which are pretty comprehensive anyway). You can
also create a system wide pinerc file if you want to, but that's beyond
the scope of this page.

To start alpine call up a console or a terminal emulator and type, you
guessed it:

    alpine

You will see the main menu for alpine, you can select various sub-menus
by moving your cursor with the arrow keys. You should also note that a
list of handy commands is given at the bottom of the screen including
"?" for built in help (see below).

To get to the configuration options we want to type "S" for "setup" and
then "C" for "config" (or you can select these by using the arrow keys
and return). At the top of your screen you will see various lines you
can edit by pressing "C", for "change value" (I've pasted an example in
below), you'll probably want to fill in your name, the name of your
mailserver in "User Domain" (although you might have to override this
later, more on that later), your SMTP server for sending mail and, if
you want to, the location of things like your saved message folder and
postponed message folder.

Some notes on setting up your SMTP server, as you can see below I've
specified my mailserver and which port to connect to, you also need to
specify your username on that server (probably your e-mail address) and
if you are using some method of encryption ssl or tls note the format:

    mailserver.org:portnumber/user=username/ssl (or tls)

Also note the format for where I've told Alpine to keep my saved and
postponed messages, since I want them stored on the mailserver, and not
locally, I've added an entry with form:

    {mailserver.org:portnumber/user=username/ssl}/path/to/folder

You need to put the full entry you've specified for your SMTP Server
into "{}" before the path name to the folder on the mailserver.

    Personal Name                     = Jim Bob
    User Domain                       = mailserver.org
    SMTP Server (for sending)         = mailserver.org:465/user=jimbob123/ssl
    NNTP Server (for news)            = <No Value Set>
    Inbox Path                        = <No Value Set: using "inbox">
    Incoming Archive Folders          = <No Value Set>
    Pruned Folders                    = <No Value Set>
    Default Fcc (File carbon copy)    = {mailserver.org:465/user=jimbob123/ssl}~/mail/sent-mail
    Default Saved Message Folder      = <No Value Set: using "saved-messages">
    Postponed Folder                  = {mailserver.org:465/user=jimbob123/ssl}~/mail/drafts
    Read Message Folder               = <No Value Set>
    Form Letter Folder                = <No Value Set>
    Trash Folder                      = <No Value Set: using "Trash">
    Literal Signature                 = <No Value Set>
    Signature File                    = <No Value Set: using ".signature">
    Feature List                      =

In this day and age, you probably want to set alpine up receive e-mails
from another server using IMAP or POP, to do this we need to enable some
things, in particular, check the boxes in the section "Folder
Preferences" for "Enable Incoming Folders Collection" and "Enable
Incoming Folders Checking". There's a bunch of other fun stuff to
configure, but you can come back to that later.

Now from the main menu type "L" to open "Folder List", then select
"Incoming Folders". Now you'll probably see your default inbox, which
I'm assuming you'll want to leave alone in case you receive local mail.
To add another folder to receive mail from a remote server type "A" to
add a folder.

Alpine prompts you for "name of server to contain folder", enter your
mailserver with the format:

    "mailserver.org:993/user=jimbob123/ssl"

where mailserver.org is the name of your mailserver, 993 should be
replaced by the proper port to connect to, jimbob123 should be replaced
by your username (probably your e-mail address) and ssl should be
replaced by tls if you are using tls instead of ssl.

Now it will prompt you for the name of the folder on you mailserver to
use, it's probably "INBOX" and if it isn't hopefully you can find out
from your mail provider what it is.

Then it will ask you for a nickname, type whatever you want to call the
folder. At this point you might get prompted for your password on the
mailserver, enter it and you should be able to read e-mail!

> Saving the password

The default version of alpine (re-alpine) in the pacman repository is
compiled with the --without-passfile making it impossible to store the
password. Install (or compile from source) re-alpine-passfile from AUR,
then touch ~/.pine-passfile. Restart alpine, enter imap password, send a
main to enter smtp-password. The next time alpine is started there is no
need to re-enter the password.

Setting up other IMAP folders
-----------------------------

Great, now you can read your INBOX, but what about the REST of your IMAP
folders? We'll fix that know:

Type "E" to exit setup and make sure that you save the changes. This
should put you back at the main menu type "S" again to bring up the
setup menu, but this time pick "L" for collectionLists.

Enter your mailserver info below using the format you should be getting
used to by now:

  

    Nickname  : My Mailserver
    Server    : mailserver.org:993/user=jimbob123/ssl
    Path      : ~/mail/
    View      :

  

       Fill in the fields above to add a Folder Collection to your
       COLLECTION LIST screen.
       Use the "^G" command to get help specific to each item, and
       use "^X" when finished.

Note that "Path" is the path on the remote server and you DON'T have to
write:

    {mailserver.org:993/user=jimbob123/ssl}~/mail/

You only need to give the local path on the mailserver (in this case
~/mail/)

Setting up a proper return address
----------------------------------

if you've followed the steps above you can read and write e-mails, but
you're probably not specifying your return address correctly, in fact,
you will specify you return address properly if and only if the user
name on the host computer which is run alpine is the same as your e-mail
address on the mail server. In order to fix this we edit the
configuration again (type "M" for main menu, type "S" for setup, and "C"
for configuration). Then find "Customized Headers" (either use the
"Whereis" command to search, or page down a few pages to find this) and
change the value to

    From:  Jim Bob <jimbob123@mailserver.org>

Of course, replace Jim Bob with your name and put your proper e-mail
address in the <>. While this works, the behavior of alpine with respect
to this field is somewhat complex if you want now more use:

Built in help
-------------

to see built-in help files on just about anything you can type "?", if
you have an item highlighted, this will give you help on that item.

What else can you configure?
----------------------------

Almost anything, in particular you can specify which colors to use,
(from the main menu "S" for set up "K" for colors ... should be natural
for KDE users), a browser to open external links (this is in the
"Config" setup that we've previously been modifying"), an alternate text
editor to use, different folder views, etc.

Pressing "W" allows you to quickly search for options. Messages can be
listed in localtime by enabling the option "Convert Dates to Localtime".
Toggling options can be done using the enter key.

External links
--------------

Official Alpine Page this page includes links to un-official Alpine
pages that have some handy tutorials (argue better than the one I've
provided here), hit "C" to open the config menu.

Printing from alpine
--------------------

"See also: CUPS"

printing from Alpine directly to lpr does not work with special
characters like German Umlauts in the Mail to be printed. The a2ps
program does help:

    pacman -S a2ps

You can then edit ~/.pinerc:

    # Your default printer selection
    printer=<YOURPRINTER> [] a2ps -q --center-title --footer -P<YOURPRINTER>

    # List of special print commands
    personal-print-command=<YOURPRINTER> [] a2ps -q --center-title --footer -P<YOURPRINTER>

    # Which category default print command is in
    personal-print-category=3

Replace <YOURPRINTER> with the name of your printer. Note that these
settings can also be applied in the setup UI of Alpine. See the manpage
of a2ps for more configuration options.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Alpine&oldid=239071"

Category:

-   Email Client
