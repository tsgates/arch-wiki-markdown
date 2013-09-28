Blueman
=======

This is a collection of tips and information regarding blueman, a GTK+
bluetooth manager. The information here was originally collated from the
AUR thread at https://aur.archlinux.org/packages.php?ID=13870.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Blueman and pulseaudio                                             |
| -   3 Troubleshooting                                                    |
|     -   3.1 Blueman and Thunar                                           |
|     -   3.2 NOW obsolete! >> Workaround for a Bug with obex and gvfs     |
|     -   3.3 Workaround a bug with network manager in bluetooth           |
|         networking                                                       |
|     -   3.4 Can't receive files                                          |
|                                                                          |
| -   4 Discussion Threads on problems                                     |
+--------------------------------------------------------------------------+

Installation
------------

    # pacman -S blueman

Be sure to add the bluetooth daemon to rc.conf and start blueman with
blueman-applet.

Blueman and pulseaudio
----------------------

Users who want to use pulseaudio with a bluetooth headset may want to
activate the pulseaudio plugin of Blueman. This automatically loads
pulseaudio bluetooth module after audio device is connected and plays
all audio through the bluetooth headset.

  

Troubleshooting
---------------

> Blueman and Thunar

As long as you have gvfs-obexftp installed, you can use thunar from
blueman to browse files remotely. Open up the blueman services
configuration window and replace

     nautilus --browse obex://

with

     thunar obex://

> NOW obsolete! >> Workaround for a Bug with obex and gvfs

To browse mobile phone via nautilus with blueman you need a patched
gvfs. Install gvfs-rar from AUR:
https://aur.archlinux.org/packages.php?ID=23861

obex-data-server package is broken for now and needs to rebuild with:

    $ ./configure --prefix=/usr --sysconfdir=/etc

Just grab it from ABS and rebuild.

  
 >>For me now with actual obex-data-server and standard gvfs all is
working fine (Yes obex-browsing too) the only thing is delete files on
remote storage do not work.

> Workaround a bug with network manager in bluetooth networking

Some distributions show all bluetooth interfaces as net.80203, which can
cause strange behaviour in network manager, for example NM trying to get
dhcp address for an incoming connection.

This is for versions <= 1.01, versions 1.02 and up will include this
patch.

Put this in /etc/hal/fdi/information/bnep.fdi:

    <?xml version="1.0" encoding="UTF-8"?>

    <deviceinfo version="0.2">
     <device>
       <match key="info.category" string="net.80203">
         <match key="net.interface" contains="bnep">
             <merge key="info.category" type="string">net.bluetooth</merge>
             <merge key="info.product" type="string">Bluetooth Interface</merge>
             <merge key="info.capabilities" type="strlist">net, net.bluetooth</merge>
             <merge key="net.bluetooth.mac_address" type="copy_property">net.80203.mac_address</merge>
             <remove key="net.80203.mac_address"/>
         </match>
       </match>
     </device>
    </deviceinfo>

> Can't receive files

You have to edit /etc/conf.d/bluetooth file and uncomment this line:

    #SDPD_ENABLE="true"

Discussion Threads on problems
------------------------------

https://bbs.archlinux.org/viewtopic.php?id=65889

Retrieved from
"https://wiki.archlinux.org/index.php?title=Blueman&oldid=238281"

Category:

-   Bluetooth
