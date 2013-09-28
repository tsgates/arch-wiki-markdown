Pactor
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Possible slogan: All our mirrors are belong to you.                |
| -   2 Description                                                        |
| -   3 But aren't torrents going to add a delay? Who wants to wait to     |
|     start downloading!                                                   |
| -   4 Community                                                          |
|     -   4.1 Mailing List                                                 |
|     -   4.2 IRC                                                          |
|                                                                          |
| -   5 Dev Notes                                                          |
| -   6 Currently being worked on, write what you're doing to avoid        |
|     duplicating work                                                     |
| -   7 Things to do later                                                 |
| -   8 Decided for now                                                    |
| -   9 References                                                         |
+--------------------------------------------------------------------------+

Possible slogan: All our mirrors are belong to you.
---------------------------------------------------

Description
-----------

Pactor is a pacman fork to add support for torrents and webseeds.

The vision is to get the resulting code merged back into pacman.

For now, all that we're going to use are a modified pacman, some glue,
and deluge.

Hopefully it will be backwards compatible so that wrappers like yaourt
will be able to use it as a drop in replacement.

Immediate benefits include:

    * Parallel file downloading.
    * No worries for broken mirrors (lots of web seeds, who needs /etc/mirrorlist and rankmirrrors)
    * Enhanced security, torrents verify that the user gets exactly what they asked for (would we still need package signing?).
    * The users can donate their own bandwidth to the community.
    * Spread resource usage through out mirrors, not just a couple "main" mirrors.
    * Tired of your 1337 connection maxing out your mirror's bandwidth? Get ready to set some bandwidth limiting on your side. :p

Maybe sometime in the distant future when we find out that the answer is
42:

    * Add support to close pacman when downloading, and then resume pacman when downloads are finished.

But aren't torrents going to add a delay? Who wants to wait to start downloading!
---------------------------------------------------------------------------------

Some people have asked this question. The answer to this questions is
webseeds. Webseeds are a non-standard addition to torrents to support
any http mirror with that file as a potential host. That's right, all
our mirrors are belong to you now. We will be using the getright
implementation of webseeds. A lot of clients support this, even though
this is non-standard, it is desirable, especially in our case. Back to
the delay question. As you have probably already figured out, since we
will be using http servers as mirrors, there will essentially be minimal
delay to start. And downloading from multiple mirrors is now possible
also!

This is a simplified look at how the pacman download will look like.

    * Pacman requests torrent from server. (there will be minimal delay, as you're downloading from the http server at this point)
    * Add torrent to a torrent client, poll until client has finished all required packages.
    * (In theory, if done correctly, you should be setting your bandwidth limits immediately at this point :P)
    * (no delay because webseeds can be used without a delay) (seeds from dht + public trackers can join in at later times)
    * Continue with unmodified pacman operations.

Community
---------

> Mailing List

The Parabola GNU/Linux project; obsessed with software freedom and
decentralizing the internet, has provided a mailing list:
http://list.parabolagnulinux.org/listinfo.cgi/pactor-parabolagnulinux.org

> IRC

Join us in #pactor on freenode.

Dev Notes
---------

We will be using a deluge daemon (assumed running for now)

The server that will host the torrents for now will be
pkgbuild.com/~td123/torrent/package.pkg.tar.xz.torrent

Handle the following case.

* * * * *

Deluge daemon is running.

sudo pacman -Sx swi-prolog

if torrent file is found on central server

    * Deluge downloads said file from webseeds + user seeds
    * pacman polls at a constant rate to get status info (percent complete).

else download

Once complete, start Xfercommand and continue with normal pacman
operations.

* * * * *

To run the deluge server use: sudo /etc/rc.d/deluged start

Currently being worked on, write what you're doing to avoid duplicating work
----------------------------------------------------------------------------

    * Add a flag -x to pacman which enables torrent mode (use of torrents). - td123
    * NEED TO FIRST ADD SUPPORT TO GENERATE TORRENTS FROM SYMLINKS. Set up test repo/mirror with rsync + torrents for testing. - td123
    * create server scripts to walk a tree and create torrents for each package and also create scripts to cleanup old torrents. -td123
    * Make a torrent repo layout and add initial torrents for testing, initially will only support web-seeds and dht - td123
    * Figure out how deluge-console + deluge daemon work together. -lordheavy

Things to do later
------------------

    * Read lots of docs on the rpc protocol for the deluge daemon.
    * We need to pick a json library for c.
    * We need to pick a library to send rpc messages to deluge.

Decided for now
---------------

    * Wrap around deluge-console and process info from it. Removes the need for external libs.

References
----------

    * rpc specs for deluge: http://dev.deluge-torrent.org/wiki/Development/DelugeRPC
    * rpc docs: http://deluge-torrent.org/docs/1.2/core/rpc.html
    * deluge git browser: http://git.deluge-torrent.org/deluge/tree/

possible public trackers in addition to DHT and webseeds

    * http://publicbt.com/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pactor&oldid=225361"

Category:

-   Package management
