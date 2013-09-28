I2P
===

From the I2P homepage:

I2P is an anonymizing network, offering a simple layer that
identity-sensitive applications can use to securely communicate. All
data is wrapped with several layers of encryption, and the network is
both distributed and dynamic, with no trusted parties.

Many applications are available that interface with I2P, including mail,
peer-peer, IRC chat, and others.

Installation
------------

I2P is available in the AUR, with i2p providing compilation from source,
and i2p-bin providing a precompiled binary.

Usage
-----

First, invoke the i2prouter daemon:

SysV

    /etc/rc.d/i2prouter start

(add i2prouter to the DAEMONS array in your /etc/rc.conf to start at
boot)

systemd

    systemctl start i2prouter.service

(issue systemctl enable i2prouter.service to start at boot)

This will launch the daemon under the system user 'i2p'. Next, open your
browser of choice and visit the I2P welcome page at

    127.0.0.1:7657/home

From here you can navigate to I2Ps configuration and statistics pages,
and links to "Eepsites of Interest" (eepsites being sites available only
through the I2P network, similar to how .onion sites are only available
through the Tor network). Also, be aware that eepsites are unavailable
until the daemon has bootstrapped to the network, which can take several
minutes.

To enable the use of outproxies, use the following browser settings:

    HTTP  127.0.0.1 4444
    HTTPS 127.0.0.1 4445

External Links
--------------

-   I2P Homepage
-   I2P FAQ
-   Homepage mirror
-   I2P Wikipedia entry

Retrieved from
"https://wiki.archlinux.org/index.php?title=I2P&oldid=219620"

Category:

-   Networking
