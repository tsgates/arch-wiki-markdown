TeamSpeak
=========

  Summary
  -------------------------------------------------------------------------------------------------------
  An introduction to TeamSpeak, covering installation and basic configuration of the client and server.

From Wikipedia, the free encyclopedia:

TeamSpeak is a proprietary Voice over IP software that allows computer
users to speak on a chat channel with fellow computer users, much like a
telephone conference call.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Install client                                               |
|     -   1.2 Install server                                               |
|                                                                          |
| -   2 Configuration/Startup                                              |
|     -   2.1 Client                                                       |
|     -   2.2 Server                                                       |
|         -   2.2.1 Configuration                                          |
|         -   2.2.2 First startup                                          |
|         -   2.2.3 Regular startup                                        |
|                                                                          |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Install client

Install teamspeak3, available in the Arch User Repository.

> Install server

Install teamspeak3-server, available in the Arch User Repository.

Configuration/Startup
---------------------

> Client

I do not use the Linux client, please feel free to expand this article
at this point.

> Server

Configuration

-   You can configure the TeamSpeak server via
    /etc/conf.d/teamspeak3-server if you are using Initscripts. You can
    find all necessary explanations inside this file. If you are using
    Systemd please check
    /usr/share/doc/teamspeak3-server/server_quickstart.txt for all
    available command line parameters.

-   If you possess a license file please copy it to
    /var/lib/teamspeak3-server/licensekey.dat.

First startup

At the first startup TeamSpeak creates the SQLite database at
/var/lib/teamspeak3-server/ts3server.sqlitedb and the first logfiles. At
the same moment TeamSpeak creates the ServerQuery administration account
(the superuser of all servers) and the first virtual server including a
privilege key for the server administrator of this virtual server. The
ServerQuery account is displayed only once on standard output. If you
have already started your server and missed it you have to delete
/var/lib/teamspeak3-server/ts3server.sqlitedb and clear
/var/log/teamspeak3-server/ of all logfiles as described below.

Warning:These steps delete your current configured TeamSpeak servers,
your users, permissions and all settings.

-   Stop teamspeak3-server (see Daemon).

-   Remove /var/lib/teamspeak3-server/ts3server.sqlitedb:

    rm /var/lib/teamspeak3-server/ts3server.sqlitedb

-   Clear /var/log/teamspeak3-server/:

    rm /var/log/teamspeak3-server/*.log

-   Now you can run the server (as root):

    su -s /bin/bash -l -c "/usr/bin/teamspeak3-server logpath=/var/log/teamspeak3-server/ dbsqlpath=/usr/share/teamspeak3-server/sql/" teamspeak

-   You should see an output similar to this:

    Example output

    ------------------------------------------------------------------
                            I M P O R T A N T                           
    ------------------------------------------------------------------
                   Server Query Admin Acccount created                 
               loginname= "serveradmin", password= "password"
    ------------------------------------------------------------------

Note:Write down the password for the ServerQuery administrator!

-   You will also find the privilege key of the first virtual server in
    this output which can be used to gain administrative rights on this
    virtual server. But the key is also written to the logfile at
    /var/log/teamspeak3-server/ and you can see it in
      journalctl _SYSTEMD_UNIT=teamspeak3-server.service 

-   You can stop the server with this:

    kill `pidof -o %PPID /usr/bin/teamspeak3-server`

Regular startup

Simply start teamspeak3-server (see Daemon).

External links
--------------

-   Official documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=TeamSpeak&oldid=252730"

Category:

-   Sound
