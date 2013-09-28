SABnzbd
=======

SABnzbd is an Open Source Binary Newsreader written in Python.

It's totally free, incredibly easy to use, and works practically
everywhere. SABnzbd makes Usenet as simple and streamlined as possible
by automating everything we can. All you have to do is add an .nzb.
SABnzbd takes over from there, where it will be automatically
downloaded, verified, repaired, extracted and filed away with zero human
interaction.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Global configuration                                         |
|     -   2.2 Local configuration                                          |
|         -   2.2.1 Running as user without systemd user instance          |
|                                                                          |
|     -   2.3 Initial setup                                                |
|     -   2.4 enabling https                                               |
|     -   2.5 using a custom port                                          |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 systemd times out when starting SABnzbd with https enabled   |
|     -   3.2 SABnzbd redirects to localhost on remote access when only    |
|         https is enabled                                                 |
|     -   3.3 SABnzbd shows error 503 when trying to access the WEB        |
|         Interface                                                        |
|                                                                          |
| -   4 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install sabnzbd from the Arch User Repository.

Configuration
-------------

SABnzbd is able to run globally (settings apply to all users) and
locally (per user settings). The way of setting up SABnzbd depends on
the way it is intended to be used. A local configuration may prove more
useful on a desktop system than on a system that is used by several
people simultaneously.

> Global configuration

SABnzbd is controlled by the sabnzbd daemon.

> Local configuration

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

SABnzbd does not need to be run globally as a daemon and can rather work
per user. The usual method to configure SABnzbd globally is because the
listed files and folders in the default configuration file point to
directories owned by sabnzbd (the /opt/sabnzbd directory).

A less used (but perhaps more sensible) method is to make SABnzbd work
with files and directories owned by a normal user. Running SABnzbd as a
normal user has the benefits of:

-   A single directory ~/.sabnzbd.ini (or any other directory under
    /home/username) that will contain all the SABnzbd configuration
    files.
-   Easier to avoid unforeseen read/write permission errors.

In this case, we will use ~/.sabnzbd.ini/sabnzbd.ini and not start
sabnzbd.service as a daemon for the whole system and all users. We will
NOT use the /usr/lib/systemd/system/sabnzbd.service which is intended to
start the sabnzbd.service for all users. If you already enabled it, just
disable it first:

     # systemctl disable sabnzbd.service

If you used to start SABnzbd inside your ~/.xinitrc, comment or delete
the line

    sabnzbd -d

Then, edit a new file /etc/systemd/user/sabnzbd.service

    /etc/systemd/user/sabnzbd.service

    [Unit]
    Description = SABnzbd binary newsreader

    [Service]
    EnvironmentFile = /etc/conf.d/sabnzbd_systemd
    ExecStart = /bin/sh/ -c "python2 ${SABNZBD_DIR}/SABnzbd.py ${SABNZBD_ARGS} --pid /tmp"
    ExecStop = /usr/bin/curl -f "${SABNZBD_PROTOCOL}://${SABNZBD_USPW}${SABNZBD_IP}:${SABNZBD_PORT}/sabnzbd/api?mode=shutdown&apikey=${SABNZBD_KEY}"
    Type = forking
    PIDFile = /tmp/sabnzbd-8080.pid

    [Install]
    WantedBy = default.target

Then, change this line in /etc/conf.d/sabnzbd_systemd

    /etc/conf.d/sabnzbd_systemd

    SABNZBD_ARGS=-f ${HOME}/.sabnzbd.ini -s ${SABNZBD_IP}:${SABNZBD_PORT} -d

Then, add this line if not already to .xinitrc

    ~/.xinitrc

    #run systemd as user intsance
    systemd --user &

Now, enable and start sabnzbd.service as per user

    $ systemctl --user enable sabnzbd
    $ systemctl --user start sabnzbd

Check the SABnzbd status and see if sabnzbd.service is correctly enabled
and started

    $ systemctl --user status sabnzbd

Running as user without systemd user instance

If you dont like the local configuration option, you may run sabnzbd as
a user by doing this instead:

    $ cp /usr/lib/systemd/system/sabnzbd.service /etc/systemd/system/sabnzbd.service

Then edit :

    /etc/systemd/system/sabnzbd.service

    [Unit]
    Description = SABnzbd binary newsreader

    [Service]
    ExecStart = /bin/sh/ -c "python2 /opt/sabnzbd/SABnzbd.py -l0 -f /home/m/.sabnzbd/sabnzbd.ini -d --pid /tmp"
    Type = forking
    PIDFile = /tmp/sabnzbd-8080.pid
    User = desired_user_name
    Group = desired_group_name
    [Install]
    WantedBy = default.target

> Initial setup

It is recommended to run through the initial setup wizard after starting
the service by going to 127.0.0.1:8080 in your favourite web-browser.
This initial setup should be enough to get SABnzbd working correctly for
regular users. Users wanting HTTPS access are recommended to read
further on in #enabling https.

Sabnzbd can be further configured through the web-interface or in
/opt/sabnzbd/sabznbd.ini.

Tip:By default, sabnzbd will only allow access from the same computer.
Change the host line in sabnzbd.ini to 0.0.0.0 to be able to access the
initial setup from another computer.

> enabling https

enabling https is a threefold process.

For global configuration:

-   edit /opt/sabnzbd/sabnzbd.ini and set enable_https to 1

-   copy /usr/lib/systemd/system/sabnzbd.service to /etc/systemd/system/
    then edit it and set PIDFile to /run/sabnzbd/sabnzbd-9090.pid

-   reload systemd with # systemctl --system daemon-reload

For local configuration:

-   edit /opt/sabnzbd/sabnzbd.ini and set enable_https to 1

-   then edit /etc/systemd/user/sabnzbd.service and set PIDFile to
    /tmp/sabnzbd-9090.pid

-   reload systemd with $ systemctl --user daemon-reload

You should now be able to start sabnzbd with SSL support.

> using a custom port

Using a custom port is similar to using https.

For global configuration:

-   edit /opt/sabnzbd/sabnzbd.ini and set port in [misc] section to the
    port you wish to use.

-   copy /usr/lib/systemd/system/sabnzbd.service to /etc/systemd/system/
    then edit it and set PIDFile to /run/sabnzbd/sabnzbd-yourport.pid
    where yourport is the same as set in the first step.

-   edit /etc/conf.d/sabnzbd_systemd and set SABNZBD_PORT to the port
    set in the first step.

-   reload systemd with # systemctl --system daemon-reload

For local configuration:

-   edit /opt/sabnzbd/sabnzbd.ini and set port in [misc] section to the
    port you wish to use.

-   then edit /etc/systemd/user/sabnzbd.service and set PIDFile to
    /tmp/sabnzbd-yourport.pid where yourport is the same as set in the
    first step.

-   edit /etc/conf.d/sabnzbd_systemd and set SABNZBD_PORT to the port
    set in the first step.

-   reload systemd with $ systemctl --user daemon-reload

You should now be able to start sabnzbd with a custom port.

Troubleshooting
---------------

> systemd times out when starting SABnzbd with https enabled

When faced with the following:

    [user@host ~]$ sudo systemctl start sabnzbd.service
    Job failed. See system journal and 'systemctl status' for details.

    [user@host ~]$ sudo systemctl status sabnzbd.service
    sabnzbd.service - SABnzbd binary newsreader
    	  Loaded: loaded (/usr/lib/systemd/system/sabnzbd.service; disabled)
    	  Active: failed (Result: timeout) since Tue, 25 Sep 2012 20:10:47 +0200; 9s ago
    	  CGroup: name=systemd:/system/sabnzbd.service

It's likely that you've forgotten to edit sabnzbd.service to reflect the
proper PID file as mentioned in enabling https.

> SABnzbd redirects to localhost on remote access when only https is enabled

This strange issue seems to appear, when you have no https port
configured (so it will use the configured http port for http) and your
/etc/conf.d/sabnzbd[_systemd] says

    SABNZBD_PROTOCOL=https

instead of:

    SABNZBD_PROTOCOL=http

You might need to restart your clientside browser.

  

> SABnzbd shows error 503 when trying to access the WEB Interface

Simply go to /etc/systemd/system/multi-user.target.wants/ and edit
"sabnzbd.service". Something like this might appear :

    ExecStart=/bin/sh -c "python2 /opt/sabnzbd/SABnzbd.py -l0"

Simply remove "-l0" and restart the daemon
(sudo systemctl restart sabnzbd.service).

It should be working great now :).

  

External Links
--------------

-   SABnzbd homepage
-   SABnzbd wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=SABnzbd&oldid=254603"

Category:

-   Internet Applications
