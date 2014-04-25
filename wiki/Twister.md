Twister
=======

Twister is an experimental peer-to-peer microblogging software. It's in
very alpha state!

Contents
--------

-   1 Installation
-   2 Setup
-   3 Gui Interface
-   4 JSON/CLI Interface
    -   4.1 Creating Users
    -   4.2 Creating and Viewing Posts
    -   4.3 Private Messages
    -   4.4 Profile Management
    -   4.5 Help

Installation
------------

The twister-core-git package and the twister-html-git html interface are
available in the AUR.

Setup
-----

Start the daemon with

    # systemctl start twister

Enable the daemon to start on system boot

    # systemctl enable twister

This will by default load both the twister-core daemon, and the
twister-html gui.

Then try to access: http://127.0.0.1:28332/home.html.

Switch to the network tab and wait for the complete download of the
blockchain. Go to the 'setup account' tab and create a new user. Wait
for your registration to be finished. Edit your profile. Your profile
will be set in a new block, so wait for the 'save' button to appear.

Gui Interface
-------------

The twister-html aur package contains a web based gui interface, which
can be accessed at http://127.0.0.1:28332/home.html. This interface
allows full configuration of Twister, and can be used to create and read
posts.

JSON/CLI Interface
------------------

Twisterd comes with a command line based utility, that can be used run
and configure twister. However, this interface is an overlay on the
JSON-RPC interface, and therefore is mostly useful for debugging and
development. See the following page for the full documentation of this
interface http://twister.net.co/?page_id=58. A brief summary of this
interface is as follows.

> Creating Users

The following command creates a new username on Twister

    # twisterd createwalletuser myname

The following command propagates the user to the network

    # twisterd sendnewusertransaction myname

> Creating and Viewing Posts

    # twisterd newpostmsg myname 1 "hello world"

    # twisterd getposts 5 '[{"username":"myname"},{"username":"myfriend"}]'

> Private Messages

    # twisterd newdirectmsg myname 2 myfriend "secret message"

    # twisterd getdirectmsgs myname 10 '[{"username":"myfriend"}]'

> Profile Management

    # twisterd dhtput myname profile s '{"fullname":"My Name","bio":"just another user","location":"nowhere","url":"twister.net.co"}' myname 1

    # twisterd dhtget myfriend profile s

> Help

    # twisterd help

Retrieved from
"https://wiki.archlinux.org/index.php?title=Twister&oldid=302710"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 09:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
