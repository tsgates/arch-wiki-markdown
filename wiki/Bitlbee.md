Bitlbee
=======

Bitlbee is a "console-based IRC to IM chatting gateway, including
ICQ/MSN/Jabber". It allows the user to interact with popular chat
networks XMPP/Jabber (including Google Talk), MSN Messenger, Yahoo!
Messenger, AIM and ICQ, the Twitter microblogging network (plus all
other Twitter API compatible services like identi.ca and status.net),
and social networking chat networks like Facebook and StudiVZ within
their IRC client.

The users' buddies appear as normal IRC users in a channel and
conversations use the private message facility of IRC.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Daemon                                                       |
|                                                                          |
| -   3 Connect to channel                                                 |
| -   4 Google Chat                                                        |
|     -   4.1 Troubleshooting                                              |
|                                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install bitlbee, available in the Official Repositories. Alternatively,
install the development version, bitlbee-bzr, available in the Arch User
Repository.

Configuration
-------------

Various settings can be set using the /etc/bitlbee/bitlbee.conf
configuration file.

> Daemon

To run Bitlbee as a daemon uncomment the Runmode line and change it to
the following.

    RunMode = ForkDaemon

It is recommended to run the Bitlbee daemon without root permission.
Uncomment the following line so Bitlbee can run as the "bitlbee" user,
which was created when the package was installed.

    User = bitlbee

Ensure that the configuration directory is writeable with the user you
configured:

    # chown -R bitlbee:bitlbee /var/lib/bitlbee

Then start the bitlbee daemon.

    systemctl start bitlbee

You can also enable the bitlbee daemon to run on startup like so:

    systemctl enable bitlbee

(Note: just starting the server does not log you into any of your chat
accounts)

Connect to channel
------------------

Once Bitlbee is running connect to localhost using a IRC client. Then
join the channel named &bitlbee. After joining the channel type Help and
then Enter for further information.

Google Chat
-----------

In the control channel, &bitlbee, issue the following command after
replacing <username> and <password> with your information:

    <@user> account add jabber <username>@gmail.com <password> talk.google.com:5223:ssl

Appending the command with talk.google.com:5223:ssl is not strictly
necessary, but it is recommended to enable extra security.

If you have enabled Google Authenticator make sure to create an
application specific password (see: Google Accounts Help).

To verify that the account was added check the account list:

    <@user> account list 
    <@root> 0. JABBER, username@gmail.com (connected) 
    <@root> End of account list

You can change the server value of your gmail account with the following
command:

    account 0 set server talk.google.com

To log into your Google account issue the following:

    <@user> account 0 on
    <@root> JABBER(username@gmail.com) - Logging in: Connecting 
    <@root> JABBER(username@gmail.com) - Logging in: Connected 
    <@root> JABBER(username@gmail.com) - Logging in: Requesting Authentication Method
    <@root> JABBER(username@gmail.com) - Logging in: Authenticating 
    <@root> JABBER(username@gmail.com) - Logged in

> Troubleshooting

If you get errors like the following:

    <@user> account 0 on 
    <@root> JABBER(username@gmail.com) - Logging in: Connecting
    <@root> JABBER(username@gmail.com) - Logging in: Connected
    <@root> JABBER(username@gmail.com) - Logging in: Requesting Authentication Method
    <@root> JABBER(username@gmail.com) - Logging in: Authenticating
    <@root> JABBER(username@gmail.com) - Login error: Error 403: Unknown error
    <@root> JABBER(username@gmail.com) - Signing off...

Switching the domain from "gmail.com" to "googlemail.com" may help. This
seems to be the case for some European countries, especially Germany
where Google doesn't own the trademark for the name Gmail [1].

The easiest way to change your account settings is to simply delete the
account you created and add it again.

    account 0 del
    account add jabber username@googlemail.com mypasswd

or just use the `set` switch for the `account` command

    account list   # find the id for your gtalk account, in this case I'll use '0'
    account 0 set  # list all the possible settings for this account
    account 0 set username foo@gmail.com        # change your username
    account 0 set password somethingverysecret  # change your passphrase

See Also
--------

-   Screen Irssi Bitlbee
-   Bitlbee Wiki
-   Introduction to Bitlbee by Bradley Marshall
-   Quickstart Guide by Elizabeth Krumbach
-   HOWTO: Connect to Google Talk with Bitlbee at Thinkhole Labs
-   HOWTO: Connect to Facebook chat with Bitlee on the Bitlbee Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bitlbee&oldid=242505"

Category:

-   Internet Relay Chat
