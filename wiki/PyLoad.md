pyLoad
======

pyLoad is a fast, lightweight and full featured download manager for
many One-Click-Hoster, container formats like DLC, video sites or just
plain http/ftp links (supported hosts). It aims for low hardware
requirements and platform independence to be runnable on all kind of
systems (desktop pc, netbook, NAS, router). Despite its strict
restriction it is packed full of features just like webinterface,
captcha recognition, unrar and much more.

pyLoad is divided into core and clients, to make it easily remote
accessible. Currently there are (screenshots):

-   a webinterface;
-   a command line interface;
-   a GUI written in Qt;
-   and an Android client.

Contents
--------

-   1 Installation
    -   1.1 Headless servers
    -   1.2 Requirements
-   2 Configuration
    -   2.1 Optional
    -   2.2 Scripts
-   3 Running
    -   3.1 Essential
    -   3.2 Interfacing with pyLoadCore
-   4 Daemon
-   5 Alternatives

Installation
------------

Install pyload from the AUR for the stable version or pyload-nightly for
a development build of the new pyload 0.5 version.

> Headless servers

On headless servers, you will want to use giflib-nox11 instead of
giflib, before you install pyload. Otherwise this package will pull X11
dependencies.

> Requirements

Required dependencies are handled by the AUR package's PKGBUILD.
Nevertheless, some optional dependencies aren't:

-   Ability to establish a secure connection to core or webinterface:
    openssl python2-pyopenssl.

-   For ClickNLoad and at least ZippyShare (maybe other hosters too)
    support: js.

Configuration
-------------

Run Setup Assistant:

    # pyLoadCore -s

Note:This command must be run as the same user that will run pyload. For
example if you run pyload as a daemon using the systemd service, either
run this command as user pyload or change
/etc/systemd/system/pyload.service to another user. If you choose to run
this command as user pyload you will have to edit /etc/passwd to modify
pyload's shell from /bin/false to /bin/bash.

The Setup Assistant gives you a jump start, by providing a basic but
working setup. Being a basic setup, there are more options and you
should at least look at them, since some sections are untouched by the
Assistant, like the permissions section.

Tip:Most (if not all) of the options can be changed with pyLoadGui or
with the the web interface.

> Optional

However, if you prefer to edit the pyload.conf yourself and you went
with the default conf directory, you can change the settings by editing
~/.pyload/pyload.conf. Use your favorite editor to edit, eg.:

    # nano ~/.pyload/pyload.conf

You can get aquainted with most of the configuration options on that
page. Do note that it is outdated, in a sense, since the
/opt/pyload/module/config/ files it refers to do not match what's still
on that page.

While also editable with the web interface, you can change the plugins
configuration by editing ~/.pyload/plugins.conf.

Extraction passwords are stored in ~/.pyload/unrar_passwords.txt. To add
passwords either edit the file or:

    # echo 'password' >> ~/.pyload/unrar_passwords.txt

> Scripts

For more info on this,

    cat /opt/pyload/scripts/Readme.txt

and visit pyload.org forums.

If you are interested in running userscripts, before running, you need
to either

    # chmod 777 /opt/pyload/scripts/

or

    # chown user you defined in pyload.conf / permissions settings /opt/pyload/scripts/

in order for pyLoadCore to create the necessary folders.

Running
-------

> Essential

    # pyLoadCore

      to run pyload without having the terminal stay running use
     
    # pyLoadCore --daemon

> Interfacing with pyLoadCore

    # pyLoadCli

    # pyLoadGui

Or, as stated above, with the web interface. If the default settings are
true, then:

    http://localhost:8000

Daemon
------

Tip:Don't forget to change $USER and $GROUP

    /etc/systemd/system/pyload.service

    [Unit]
    Description=Downloadtool for One-Click-Hoster written in python.
    After=network.target

    [Service]
    ExecStart=/usr/bin/pyLoadCore
    User=$USER
    Group=$GROUP

    [Install]
    WantedBy=multi-user.target

To start pyload start pyload service.

To have it started automatically on boot, enable pyload service.

Alternatives
------------

Tucan Manager available in the official repositories through the tucan
package.

uGet available in the official repositories through the uget package
(GTK).

JDownloader through jdownloader package.

plowshare available in AUR (CLI).

TuxLoad available in AUR (CLI).

FreeRapid Downloader available in AUR (Java).

Retrieved from
"https://wiki.archlinux.org/index.php?title=PyLoad&oldid=302652"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
