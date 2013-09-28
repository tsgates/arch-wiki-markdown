Tftpd server
============

The Trivial File Transfer Protocol (TFTP) provides a minimalistic means
for transferring files. It is generally used as a part of PXE booting or
for updating configuration and firmware on devices which have limited
memory such as routers and printers.

This article describes how to set up a tftpd server under Arch Linux
using the tftp-hpa package.

Installation
------------

Install the package tftp-hpa which can be found in the official
repositories.

Configuration
-------------

Create a copy of the tftpd.service unit, and modify ExecStart with the
appropriate directory to use as the tftp root.

    # vim /etc/systemd/system/tftpd.service

    [Unit]
    Description=hpa's original TFTP daemon

    [Service]
    ExecStart=/usr/sbin/in.tftpd -s /srv/tftp/
    StandardInput=socket
    StandardOutput=inherit
    StandardError=journal

Systemd#Replacing_provided_unit_files talks in more detail about
customizing unit files.

Run
---

Start tftpd:

    # systemctl start tftpd.socket tftpd.service

To start tftpd on boot:

    # systemctl enable tftpd.socket

See Systemd#Using_units for more information on manipulating services.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tftpd_server&oldid=246516"

Category:

-   File Transfer Protocol
