Nessus
======

Nessus is a proprietary vulnerability scanner available free of charge
for personal use. There are over 40,000 plugins covering a large range
of both local and remote flaws.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Post-installation setup                                            |
| -   3 Usage                                                              |
| -   4 Removal                                                            |
+--------------------------------------------------------------------------+

Installation
------------

Download and extract the nessus tarball available in the AUR.

Go to http://tenable.com/products/nessus/nessus-download-agreement,
agree to the license, and download the package:

-   32-bit: Nessus-5.2.0-fc16.i386.rpm
-   64-bit: Nessus-5.2.0-fc16.x86_64.rpm

Move the RPM file into the nessus directory (i.e. the directory you
extracted the tarball's contents to).

Then, build and install the package as usual.

Post-installation setup
-----------------------

Create an SSL certificate for the Nessus web interface:

    # /opt/nessus/sbin/nessus-mkcert

Register your email at
http://www.tenable.com/products/nessus/nessus-plugins/obtain-an-activation-code
and wait for your key to be emailed to you. Then, download all the
plugins from the feed with:

    # /opt/nessus/bin/nessus-fetch --register <your key here>

Note:If you are behind a proxy, you need to modify
/opt/nessus/etc/nessus/nessus-fetch.rc.

Create a Nessus admin user (unrelated to Unix-style users):

    # /opt/nessus/sbin/nessus-adduser

Usage
-----

The nessus package provides a nessusd.service unit file, see systemd for
details.

Access the web interface at https://localhost:8834 and/or use the
commandline interface (/opt/nessus/bin/nessuscmd). In most browsers, you
will need to manually accept the SSL certificate you created for the
server.

Removal
-------

The package can be removed with pacman, but files created by Nessus,
such as the plugin database it downloads, must be removed manually:

Note:This will delete your Nessus configuration files.

    # rm -r /opt/nessus

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nessus&oldid=255560"

Categories:

-   Networking
-   Security
