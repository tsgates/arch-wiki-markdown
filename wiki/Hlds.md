Hlds
====

This page describes how to install Valves HLDS (Half-Life Dedicated
Server) for installing and running a game server for classic Half-Life 1
games.

Installation
------------

First, install hlds from the AUR. Before configuring the server, we need
to add an user with restricted rights which will be only used for HLDS:

    $ useradd hlds

And then assign the permissions to the program directory:

    $ chown -R hlds:hlds /opt/hlds

Now we change the user, switch the directory to /opt/hlds and begin
download the game files, in this example for Counter-Strike 1.6, by
executing this command (where username and password is your steam one):

    $ su hlds && cd /opt/hlds
    $ ./steam -command update -game cstrike -dir . -username <username> -password <password>

Configuration
-------------

Of couse you can define the server settings in the game directory
itself, for example by editing /opt/hlds/cstrike/server.cfg.
Alternatively you could set the startup parameters in /etc/conf.d/hlds:

    /etc/conf.d/hlds

    user=hlds # this setting won't work yet
    workingdir=/opt/hlds # this setting won't work yet
    params="-game cstrike -autoupdate +maxplayers 20 +port 27019 +map de_aztec"

Be sure you open or forwarded the port, e.g. 27019 UDP+TCP correctly!

Start the server
----------------

Starting the server is easy!

    $ systemctl start hlds

To enable autostart, issue following command:

    $ systemctl enable hlds

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hlds&oldid=247502"

Category:

-   Gaming
