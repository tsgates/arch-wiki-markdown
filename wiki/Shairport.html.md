Shairport
=========

Shairport is a utility for emulating the functionality of an AirPort
Express on a linux box. However, since it has been created by
reverse-engineering Apple's key used in its AirPort Express, be advised
that the functionality may be removed at Apple's discretion.

Installation
------------

Shairport is available in the AUR through three different packages:

-   shairport
-   shairport-git
-   shairport-git-sysdcompat

The third package provides ready made systemd scripts and hence comes
recommended. It is recommended to install the package
perl-io-socket-inet6 when installing either of the first two packages.
This prevents the daemon from giving warnings about the unavailability
of inet6 and compatibility with iTunes. However, the third package is
based on abrasive/shairport, which no longer uses Perl, and therefore
does NOT require perl-io-socket-inet6.

Configuration
-------------

The configuration is managed by the perl script /usr/bin/shairport.pl.
For novice users, the defaults should be left as is, unless they wish to
set a password for the AirPlay server. In this case, they should change
line 56 from my $password = ''; to my $password = '<yourpassword>';
where <yourpassword> is to be replaced by the password of your choice.

If you have not used the shairport-git-sysdcompat package, then you will
need to create the systemd service file on your own. The one used by the
sysdcompat package is:

    [Unit]
    Description=Shairport Airtunes emulator
    Requires=avahi-daemon.service

    [Service]
    Type=forking
    PIDFile=/var/run/shairport.pid
    ExecStart=/usr/bin/shairport.pl -d --writepid=/var/run/shairport.pid -a %i

    [Install]
    WantedBy=multi-user.target

If you are manually creating the file, remember to run
systemctl daemon-reload after writing the file. For starting the
service, simply issue the command:

    # systemctl start shairport@<nameofserver>.service

where <nameofserver> can be any name of your choice. While it has not
been tested, it would be good if the name avoided any special
characters. For automatically starting the service at launch, issue the
command:

    # systemctl enable shairport@<nameofserver>.service

The result should be an AirPort station by the name <nameofserver> which
should be able to accept output from any Apple product.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Shairport&oldid=282291"

Category:

-   Streaming

-   This page was last modified on 11 November 2013, at 04:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
