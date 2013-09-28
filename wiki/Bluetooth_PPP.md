Bluetooth PPP
=============

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

I forget how to pair devices, so this article is woefully lacking!!!

I'm no expert, but this page is to help people who want to setup a TCP
connection from a Palm Pilot or other bluetooth device to their Arch
Linux box. This is useful for browsing the Internet and/or performing a
Hotsync operation.

I have no idea what really works, but this system is working for me
right now!

Hardware:

           bluetooth dongle
           Palm T5

Packages Installed:

           bluez-utils
           bluez-libs

Modules Loaded:

           hci_usb
           rfcomm
           l2cap
           sco

Daemons Running:

           dbus
           hcid
           sdpd

Devices Loaded:

           hci0 (bring it up with hciconfig hci0 up)

Extra Settings Needed:

           # echo 1 > /proc/sys/net/ipv4/ip_forward

PPP Settings:

     $ cat /etc/ppp/peers/palm
     noauth          # we require no authentication
     local           # local connection
     asyncmap 0      # charmap
     idle 1000       # disconnection after 1000 idle seconds
     noipx           # disable novell ipx
     passive         # the client (palm) initiates the connection
     silent          # no info needed
     192.168.10.191:192.168.10.192  # Server:client ip address
     ms-dns 192.168.10.191

Command to run to start the dial-up networking server:

     # dund --nodetach --listen --persist --msdun call palm

Command to run to start the dial-up networking server in daemon mode

     # dund --listen --persist --msdun call palm

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_PPP&oldid=205981"

Category:

-   Bluetooth
