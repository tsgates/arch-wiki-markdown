Ntop
====

Ntop is a network traffic probe based on libcap, that offers RMON-like
network traffic statistics accessible via a web browser.

Contents
--------

-   1 Installation and configuration
-   2 Tips and tricks
    -   2.1 Web interface
    -   2.2 Group and user
-   3 Troubleshooting
    -   3.1 **ERROR** RRD: Disabled - unable to create base directory
        (err 13, /var/lib/ntop/rrd)
    -   3.2 Please enable make sure that the ntop html/ directory is
        properly installed

Installation and configuration
------------------------------

Install ntop from the official repositories. The first run of ntop, you
must set the admin password:

    # ntop

Next, you need to edit the configuration file (/etc/conf.d/ntop) to
adapt on your needs. Below is an example configuration, with the focus
on the host to get as much as information from the hosts connections:

    /etc/conf.d/ntop

    # Parameters to be passed to ntop.
    NTOP_ARGS="-K -W 2323 -i enp1s0,wlp2s0 -M -s -4 -6 -s -u ntop -c -r 30 --w3c -t 3 -a /var/log/ntop/http.log -O /var/log/ntop/ -q --skip-version-check 0"

    # Location of the log file.
    NTOP_LOG="/var/log/ntop/ntop.log"

Start the ntop systemd service and if you want to start ntop at boot,
enable it.

Tips and tricks
---------------

> Web interface

To access ntop's web interface, enter http://127.0.0.1:3000/ into your
web browser. To make changes to the server, you will need to enter your
username (default = admin) and password.

If ntop is not just used locally on your machine, but network wide by
multiple users, you'd be better off by allowing SSL connections (https)
only.

    # ntop -w 4223

Additional paramethers are allowed. Now direct our browser to
https://127.0.0.1:4223/.

You can also provide ntop with your own SSL certificate. Simply put it
in ntop's config directory and name it ntop-cert.pem

    # cd /etc/ntop/
    # openssl req -x509 -nodes -days 365 
      \-subj '/C=US/L=Portland/CN=swim' 
      \-newkey rsa:1024 -keyout ntop-cert.pem -out ntop-cert.pem

> Group and user

In order that the -u parameter is able to work properly and to secure
your ntop setup a bit more, you should create an own group and user for
it.

    # useradd -M -s /usr/bin/false ntop
    # passwd -l ntop

Note:The passwd command here is optional, but recommended, as it will
render the system more secure regarding your sshd.

Troubleshooting
---------------

> **ERROR** RRD: Disabled - unable to create base directory (err 13, /var/lib/ntop/rrd)

Directory /var/lib/ntop/rrd/ may not exist. Create it and make sure it
belongs to user nobody.

> Please enable make sure that the ntop html/ directory is properly installed

If you receive this warning while trying to access the web interface,
edit /etc/conf.d/ntop to include your IP and restart the daemon. For
example:

    NTOP_ARGS="-i enp1s0 -w 127.0.0.1:3000"

This is the IP you will use to access the web interface.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ntop&oldid=287700"

Category:

-   Networking

-   This page was last modified on 12 December 2013, at 10:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
