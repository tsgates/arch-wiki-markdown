Gift
====

From http://gift.sourceforge.net/about.mhtml:

"GiFT is a collection of various software components geared towards
improving the overall usability of a multitude of peer-to-peer
file-sharing networks. This goal is accomplished by unifying the
components such that a user of the software may choose any of the
available interfaces to access any of the available networks. The
central application, giftd, uses a plugin-based architecture capable of
using multiple networks simultaneously through a single user interface."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Troubleshooting                                                    |
| -   4 External resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Install GiFT, plugins, and GUI (optional).

    # pacman -S gift gift-fasttrack gift-gnutella gift-openft

The GUI's are all Arch packages: Giftoxic (Gtk), Apollon (Qt), and
Giftcurs (console).

    # pacman -S giftoxic
    # pacman -S apollon
    # pacman -S giftcurs

If you find no errors, gift should have been properly installed. If you
want Ares, I believe the only for Arch is to compile it from source.
Anyone else know a pkg for it, lemme know.

Configuration
-------------

1.  Run

        $ gift-setup

    as a normal user, and if there are multiple users this has to be
    done multiple times - one by each user.

2.  The program will run a bunch of questions and they all really do not
    matter except the Plugin one (easily the most important) and some of
    the ports should correspond.
3.  Once you get to the port question enter this and exactly this:

        Gnutella:FastTrack:OpenFT

    If that has been done illegally, it won't work.

4.  GiFT should now work and it's time to start out GiFT GUI/CLI:
    -   For Apollon, run

            apollon

        and if that fails to connect, try running

            giftd

        to get GiFT running first.

    -   For Giftoxic, simply run

            toxic

        and it will execute both giftd and giftoxic

    -   For giftcurs, simply run

            rungift

        and it will execute both giftd and giftoxic.

And, there you have it. If everything was done properly you should have
GiFT connecting. There have been some problems with Fasttrack and all
that, but you will have to read up because I dunno them.

Troubleshooting
---------------

If you run into this error:

    $ giftd
    *** ERROR: Your setup is incomplete ***

You will need to run gift-setup and be sure that you read absolutely
every configuration option (no, really). Some default configuration
values are considered illegal, and will raise this error message. If you
suspect that you have configured giFT properly, consult the conf files
in /home/joe/.giFT/ for diagnostic purposes.

If you are still having problems you should consult the QUICKSTART guide
available from the standard giFT distribution.

Then it means you didn't read the gift-setup instructions properly. And
it can be easily fixed by the first question to not equal zero, I
believe.

External resources
------------------

-   For any questions, e-mail at dauoalagio@gmail.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gift&oldid=205770"

Category:

-   Internet Applications
