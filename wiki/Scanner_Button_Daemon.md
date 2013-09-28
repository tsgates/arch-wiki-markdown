Scanner Button Daemon
=====================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 What is scanbd good for                                      |
|     -   1.2 How does it work                                             |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Sane configuration                                           |
|     -   2.2 scanbd configuration                                         |
+--------------------------------------------------------------------------+

Introduction
------------

> What is scanbd good for

The majority of the desktop scanners are more or less "passive" devices,
say they can be queried from a suitable application but they don't do
anything themselves.

scanbd tries to solve the problem with managing such scanners to make
use of the scanner-buttons they have (only when the buttons are
supported by sane).

> How does it work

scanbd (the scanner button daemon) opens and polls the scanner and
therefore locks the device. So no other application can access the
device directly (open the /dev/..., or via libusb, etc).

To solve this, a second daemon is used (in the so called "manager-mode"
of scanbd): scanbm is configured as a "proxy" to access the scanner and,
if another application tries to use the scanner, the polling daemon is
ordered to disable polling for the time the other scan-application wants
to use the scanner.

To make this happen, scanbm is configured instead of saned as the
network scanning daemon. If a scan request arrives to scanbm on the
sane-port, scanbm stops the polling by sending a dbus-signal to the
polling scanbd-daemon. Then it starts the real saned which scans and
sends the data back to the requesting application. Afterwards the
scanbd-manager scanbm restarts the polling by sending another
dbus-signal to scanbd.

Due to the above, the set up of the scanbd requires changes in default
configuration of sane and also definition of own action scripts
(defining what should be done when a button on the scanner is pressed).

There are also alternatives to scanbd, eg. scanbuttond, however these
seem to be unmaintained nowadays.

Installation
------------

As of version 1.3, scanbd is fully compatible with systemd service
activation and does not require inet neither xinetd to start scanbm
(manager mode of scanbd), though these remain as an alternative (not
described here).

There is an AUR package, which can be installed e.g. with yaourt:

    $ yaourt -S scanbd

> Sane configuration

Since scanbd and saned are running on the same machine as the scanner is
connected to, we need to have two sets of saned configurations - one in
the default location (/etc/sane.d/), which would redirect local
applications to a network socket, that systemd is listening on, and
another one (e.g. /etc/scandb/sane.d/), which will be actually used by
sane backend to access the attached scanner.

First, copy all config files from /etc/sane.d/ to /etc/scandb/sane.d/
(these will be needed later):

    $ sudo cp /etc/sane.d/* /etc/scanbd/sane.d/

Modify /etc/sane.d/dll.conf so that it includes only the "net" directive
(either delete the other directives (printers), or comment them with #
symbol):

    sudo cat /etc/sane.d/dll.conf
    net

Modify the net-backend configuration file (see scanbd's README.txt for
more complicated setups):

    $ sudo cat /etc/sane.d/net.conf
    connect_timeout = 3
    localhost # scanbm is listening on localhost

Now the desktop applications (which use libsane) are forced (by the
above dll.conf) to use the net-backend only. This prevents them from
using the locally attached scanners directly (and blocking them).

Whenever there is a connection to the standard sane network socket,
systemd starts scanbm ("manager mode" of scanbd), which in turn tells
(the already running) scanbd to stop polling the scanner and then it
starts saned with the alternative configuration directory.

The last step is to modify the alternative configuration of sane in
/etc/scandb/sane.d/dll.conf: just make sure that the "net" directive is
commented and the corresponding scanner-backends are uncommented:

    $ sudo cat /etc/scanbd/sane.d/dll.conf
    #net
    pixma
    epson2
    #... whatever other scanner backend needed ...

Now it's time to enable and start the systemd units of scanbm:

    $ sudo systemctl enable scanbd.service
    $ sudo systemctl start scanbd.service
    $ sudo systemctl start scanbm.socket

You can check /var/log/everything to see if the scanbd service and
scanbm socket were started. To increase debugging verbosity, change
"debug-level = 7" in /etc/scanbd/scanbd.conf and restart the scanbd
service.

> scanbd configuration

If you are lucky, your scanner might work almost out of the box and you
would only want to modify the action scripts, which define what is done
when a particular button is pressed.

scanbm listens to scanner's status and on the basis of messages
received, it decides what to do. The standard behaviour is defined in
/etc/scanbd/scanbd.conf. E.g. the action scan:

    action scan {
            filter = "^scan.*"
            numerical-trigger {
                   from-value = 1
                   to-value   = 0
                   }
            desc   = "Scan to file"
            script = "test.script"
           }

Whenever the message from the scanner includes word "scan" (see reg-exp
for more details on filters) and the value changes from 1 to 0, then it
runs script /etc/scanbd/test.script.

/etc/scanbd/test.script does not do anything but sends a message to
syslog:

    $ cat /etc/scanbd/test.script
    #!/bin/bash
    # look in scanbd.conf for environment variables

    logger -t "scanbd: $0" "Begin of $SCANBD_ACTION for device $SCANBD_DEVICE"

    # printout all env-variables
    /usr/bin/printenv > /tmp/scanbd.script.env

    logger -t "scanbd: $0" "End   of $SCANBD_ACTION for device $SCANBD_DEVICE"

There are a few other scripts available in /etc/scanbd/ that actually do
something - have a look yourself.

Also, /etc/scanbd/scanbd.conf has "include" directives at the end, which
refer to preconfigured button definitions of a few printers.

    $ cat /etc/scanbd/scanbd.conf | grep include\(
    # include("scanner.d/myscanner.conf")
    # include("/my/long/path/myscanner.conf")
    include(scanner.d/avision.conf)
    include(scanner.d/fujitsu.conf)
    include(scanner.d/hp.conf)
    include(scanner.d/pixma.conf)
    include(scanner.d/snapscan.conf)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Scanner_Button_Daemon&oldid=250989"

Category:

-   Imaging
