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
Gnome Desktop Environment.

How to Install on Arch
----------------------

To install Vino type the following:

    # pacman -S vino

If you are running gnome you need to restart gnome so that the
vino-server is started automatically when enabling the remote desktop
feature.

You can then configure vino via the following command :

    # vino-preferences

Now you can connect remotely to your desktop via a VNC viewer like
TightVNC. Remember to forward Port 5900 if you are behind a NAT and to
allow the connection through iptables.

If you use some standalone wm like openbox and it doesn't work , you can
start the vino-server manually or add the command to the wm autostart
script

    # /usr/lib/vino/vino-server &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vino&oldid=240583"

Category:

-   Virtual Network Computing
