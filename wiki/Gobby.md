Gobby
=====

From the project web page:

Gobby is a free collaborative editor supporting multiple documents in
one session and a multi-user chat. It uses GTK+ 2.6 as its windowing
toolkit and thus integrates nicely into the GNOME desktop environment.

Installation
------------

Gobby .4 is in the community repo as package gobby.

The newer development version .5 (0.4.94-1 at the time of writing) is
available in AUR as package gobby-dev

Usage
-----

To start the server portion, run

    /usr/bin/infinoted-0.5 --security-policy=no-tls

The server only needs to be running on one machine.

Then, run the gobby client and connect to the server via IP or
localhost.

If you’d rather have encryption, TLS is available. Use:

    infinoted --create-key --create-certificate -k key.pem  -c cert.pem

The keys creation is automatic, and you can launch the server just
using:

    infinoted -k key.pem  -c cert.pem

See alse
--------

-   infinoted wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gobby&oldid=252040"

Category:

-   Office
