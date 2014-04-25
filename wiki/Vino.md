Vino
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Vino is a VNC (Virtual Network Computing) server allowing remote
connection to your actual desktop. It is a default component of the
GNOME Desktop environment.

Installation
------------

Install the package vino, which is available in the official
repositories.

If you are running GNOME, you need to restart GNOME so that vino-server
is started automatically when enabling the remote desktop feature.

Configuration
-------------

You can configure vino via gnome-control-center.

Now you can connect remotely to your desktop via a VNC viewer like
TightVNC or Remmina. Remember to forward port 5900 if you are behind a
NAT device and to allow the connection through iptables.

If you are having problems regarding security and encryption you could
try:

    $ gsettings set org.gnome.Vino require-encryption false

If you use a standalone window manager like Openbox and it does not
work, you can start vino-server manually or add the command to the
window manager's autostart script

    # /usr/lib/vino/vino-server &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vino&oldid=305762"

Category:

-   Remote Desktop

-   This page was last modified on 20 March 2014, at 02:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
