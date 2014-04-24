Connman
=======

Related articles

-   Network configuration
-   Wireless network configuration

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Only WiFi plugin 
                           is described in #Usage   
                           section. (Discuss)       
  ------------------------ ------------------------ ------------------------

ConnMan is an alternative to NetworkManager and Wicd and was created by
Intel and the Moblin project for use with embedded devices. ConnMan is
designed to be light on resources making it ideal for netbooks, and
other mobile devices. It is modular in design takes advandage of the
dbus API and provides proper abstraction on top of wpa_supplicant.
ConnMan currently has plugins available for:

-   WiFi
-   Ethernet
-   Bluetooth (Through bluez)
-   WiMAX
-   VPN's (Through the connman-vpn.service)

It is typically used for wireless networking and is extremely fast at
resolving connections. After setup you may wish to check for yourself
with systemd-analyze blame to see the difference in performance compared
to other network managers.

Contents
--------

-   1 Installation
-   2 Configuring
-   3 Usage
    -   3.1 Desktop clients
    -   3.2 Using the command line client
        -   3.2.1 Connecting to an open access point
        -   3.2.2 Connecting to a protected access point
        -   3.2.3 Settings
        -   3.2.4 Hardware
-   4 Automatic switching between wired and wireless
-   5 See also

Installation
------------

Install connman from the official repositories.

Configuring
-----------

To control ConnMan as a regular user, add these lines to
/etc/dbus-1/system.d/connman.conf under the policy user="root" block.

Note:This is now implemented in the current releases of ConnMan

      <policy group="network">
           <allow send_destination="org.moblin.connman"/>
           <allow send_interface="org.moblin.connman.Agent"/>
           <allow send_interface="org.moblin.connman.Counter"/>
       </policy>

Usage
-----

First enable and start the connman.service using systemctl. If present,
disable and stop other networking services to prevent conflicts (e.g
netctl.service).

> Desktop clients

ConnMan only has two working panel applets and a dmenu client:

-   cmst — QT GUI for Connman.

https://github.com/andrew-bibb/cmst || cmst

-   EConnman — Enlightenment desktop panel applet.

http://www.enlightenment.org || econnman

-   ConnMan-UI — GTK+ client applet.

https://github.com/tbursztyka/connman-ui || connman-ui-git

-   connman_dmenu — Client/frontend for dmenu.

https://github.com/taylorchu/connman_dmenu || connman_dmenu-git

Currently the GTK client is not 100% stable however it is good enough
for day-to-day usage. To use it just add connman-ui-gtk to one of your
startup files, e.g: autostart for Openbox.

> Using the command line client

As of version 1.7 connman has a standard command line client connmanctl.

Connecting to an open access point

The commands in this section show how to run connmanctl in command mode.
It is also possible to run connmanctl in interactive mode. An example of
how to use connmanctl in interactive mode can be found in the next
section.

To scan the network connmanctl accepts simple names called technologies.
To scan for nearby WiFi networks:

    $ connmanctl scan wifi

To list the available networks found after a scan run:

Note:You will see something similar to this (not actual results):

    $ connmanctl services

    *AO MyNetwork               wifi_dc85de828967_68756773616d_managed_psk
        OtherNET                wifi_dc85de828967_38303944616e69656c73_managed_psk 
        AnotherOne              wifi_dc85de828967_3257495245363836_managed_wep
        FourthNetwork           wifi_dc85de828967_4d7572706879_managed_wep
        AnOpenNetwork           wifi_dc85de828967_4d6568657272696e_managed_none

To connect to an open network simple use the enter the second field
beginning with wifi_:

    $ connmanctl connect wifi_dc85de828967_4d6568657272696e_managed_none

You should now be connected to the network. Check using ip a or
connmanctl state.

Connecting to a protected access point

To connect to a protected access point connmanctl needs to be run in
interactive mode. For protected access points you will need to provide
some information to the connman daemon, at the very least a password or
a passphrase. In interactive mode we can register an agent to handle
these user requests. To start simply type:

    $ connmanctl

The prompt will change to "connmanctl>" to indicate you are now in
interactive mode. You then proceed almost as above, first scan for any
wifi technologies:

    connmanctl> scan wifi

To list services:

    connmanctl> services

Now you need to register the agent. The command is:

    connmanctl> agent on

You now need to connect to one of the protected services. To do this it
is very handy to have a terminal that allows cut and paste. If you were
connecting to OtherNET in the example above you would type:

    connmanctl> connect wifi_dc85de828967_38303944616e69656c73_managed_psk

The agent will then ask you to provide any information the daemon needs
to complete the connection. The information requested will vary
depending on the type of network you are connecting to. The agent will
also print additional data about the information it needs as shown in
the example below.

    Agent RequestInput wifi_dc85de828967_38303944616e69656c73_managed_psk
      Passphrase = [ Type=psk, Requirement=mandatory ]
      Passphrase?  

Provide the information requested, in this example the passphrase, and
then type:

    connmanctl> quit

If the information you provided is correct you should now be connected
to the protected access point.

Settings

Settings and profiles are automatically created for networks the user
connects to often. They contain feilds for the passphrase, essid and
other information. Profile settings are stored in directories under
/var/lib/connman/ by their service name. To view all network profiles
do:

Note:VPN settings can be found in /var/lib/connman-vpn/

    # cat /var/lib/connman/*/settings

Hardware

Various hardware interfaces are referred to as Technologies by
connmanctl. To interact with them one must refer to the technology by
type. Technologies can be toggled on/off with:

    $ connmanctl enable technology_type

and:

    $ connmanctl disable technology_type

Example:

    This will toggle wifi off
    $ connmanctl disable wifi 

Note:The field Type = tech_name provides the technology type used with
connmanctl commands

To list available technologies run:

    $ connmanctl technologies

To get just the types by their name one can use this one liner.

    $ connmanctl technologies | grep "Type" | awk '{print $NF}'

Automatic switching between wired and wireless
----------------------------------------------

Connman supports automatic switching of saved profiles with
PreferredTechnologies option. This works great, but can leave you with
both wireless and wired enabled at the same time. To circumvent this you
need to enable the SingleConnectedTechnology option. The result of the
new configuration file you need to add at /etc/connman/main.conf is:

    [General]
    PreferredTechnologies=ethernet,wifi
    SingleConnectedTechnology=true

And make sure to restart the connman.service.

For testing purposes it is recommended to watch the journal and plug the
network cable a few times to see the action.

See also
--------

For further detailed information on ConnMan refer to this documentation:
http://git.kernel.org/cgit/network/connman/connman.git/plain/doc/overview-api.txt?id=HEAD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Connman&oldid=305798"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 06:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
