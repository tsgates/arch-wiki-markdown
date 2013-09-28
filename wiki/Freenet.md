Freenet
=======

Freenet is a free and open source software that aims to provide
anonymity and freedom of speech through a decentralized peer-to-peer
network. Freenet enables its users to share files anonymously, publish
freesites without fear of censorship and more. Data is encrypted and
routed through multiple nodes making almost impossible to identify who
requested the information and what its content is.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation and Setup                                             |
| -   2 Configuration                                                      |
|     -   2.1 Wizard                                                       |
|     -   2.2 Manual Configuration                                         |
+--------------------------------------------------------------------------+

Installation and Setup
----------------------

You can install freenet from the the AUR.

Then, add freenet to your /etc/rc.conf

    DAEMONS=(... network freenet ...)

Finally, you can either restart your computer or start the daemon
manually:

    # /etc/rc.d/freenet start

Configuration
-------------

You can either let the wizard guide you through the configuration or get
your hands dirty by configuring freenet manually. You might want to read
about TrueCrypt or EncFS to protect the data you will be sharing before
continuing.

> Wizard

You need to visit freenet's web interface at http://127.0.0.1:8888/ and
make sure you carefully follow the instructions. Using the private mode
of your browser while accessing freenet is a good habit to take.

> Manual Configuration

The Freenet wiki will be useful if you decide to configure things by
hand. Manual configuration is done by editing

    /opt/freenet/freenet.ini

and

    /opt/freenet/wrapper.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Freenet&oldid=198282"

Category:

-   Networking
