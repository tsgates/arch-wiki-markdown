SpeedTouch ADSL Modem
=====================

  
 This article will hopefully enable you to connect to the internet using
your SpeedTouch modem. If you did not already know, the process is not
exactly easy, and this guide is here to help you.

Obviously, this has been built using my own experience (with a
SpeedTouch 330) and knowledge from elsewhere. If you feel anything
should be contributed, feel free to add or edit any information you see
fit.

If you are like me, you will probably want to connect when you first
finish installing Arch Linux. This means you will require another
internet-connected computer, or a Windows installation to proceed with
downloading the necessary files.

Contents
--------

-   1 The Files...
-   2 Installing everything...
-   3 Initial Configuration
-   4 Further Configuration
-   5 Further Information

The Files...
------------

The kernel driver that is used by the SpeedTouch modem will not work
without some firmware. To find out which firmware you need, run the
following command:

    awk '/4061/ { print $5 }' /proc/bus/usb/devices

Which should give you the revision number of your modem. If your modem
is revision 0 or 2 you will need the KQD6_3.012 file. If your modem is
revision 4, then you will require the ZZZL_3.012 file. Both of these
files can be located in this tarball here.

You will, later, need the firmware-extractor too, which can be found
here.

Finally you should check this page to find out the VPI/VCI numbers for
your country or ISP.

Now you have everything, save a copy of this guide too (in text helps),
and copy everything to a USB flash drive, floppy disk (if it fits), or a
USB external hard drive, so you can use them while offline.

NOTE: Unzip isn't supported in a basic Arch Linux installation, you
should unzip any .zip files using another computer or operating system
first.

Installing everything...
------------------------

Boot into your Arch Linux installation. You should now copy everything
to your home directory. Mount the drive, cp, etc, you'll know what to
do.

I assume a speedtouch folder has been created in your home directory
containing these files, and that you are currently in that folder.

You should also change to root user for the time of installing and
configuring your modem:

    su
    [password]

Now in that folder, you should have firmware-extractor, and your choice
of firmware depending on your modem (KQD6_3.012 or ZZZL_3.012). You will
need to split the firmware with the following command:

For revision 0 or 2:

    chmod +x firmware-extractor && firmware-extractor KQD6_3.012

For revision 4:

    chmod +x firmware-extractor && firmware-extractor ZZZL_3.012

If all went well, you should now have two new files in your directory:
speedtch-1.bin and speedtch-2.bin.

Now (as root remember), copy the firmware to the right place:

    cp speedtch* /lib/firmware

Now your firmware is installed! Continue to 'Initial Configuration' for
more information.

Initial Configuration
---------------------

We need to create a secrets file, containing the username and password
you usually dial with. This could either be pap-secrets or chap-secrets.
Not knowing, we will create both, as it does no harm.

Create a file (I used nano) with the following text, making sure you
amend it with your information:

    "username@isp" "*" "password"

(This line needs to be in exactly the same layout as above, just change
what is in the first and last set of quotation marks.)

Save it as secrets in your speedtouch folder. Now you will need to place
it in the correct places:

    install -m 600 secrets /etc/ppp/chap-secrets &&
    install -m 600 secrets /etc/ppp/pap-secrets

Next, we need a ppp configuration file. For PPP over ATM, use this
template. Remember to change your username, and your VPI/VCI numbers!

    noipdefault
    defaultroute
    user 'username@isp'
    noauth
    updetach
    usepeerdns
    plugin pppoatm.so
    0.00 # Change these!

    ### If the firmware loads but pppd won't
    ### connect, uncomment this option to make
    ### pppd be more verbose in the system log 

    # debug

    ### For more details (and more options)
    ### Read man pppd

Save and call the file speedtch. Now install it to the correct place:

    install -m 600 speedtch /etc/ppp/peers

Create a final symlink:

    cp /etc/resolv.conf /etc/ppp
    ln -sf /etc/ppp/resolv.conf /etc/resolv.conf

And your connection setup is done!

You can now connect using:

    pppd call speedtch

Refer to 'Further Configuration' for more Arch-specific information.

Further Configuration
---------------------

We will need to set up the connection to start on boot. This involves
creating some scripts.

This is the method I used. It works for me, and should work for you.
Some alternative methods could probably be used. But I do not know them!

Anyway, create a file called start_internet with the following content:

    #!/bin/sh
    # Speedtouch connection script

    count=0
    while [[ $((count++)) -lt 40 ]]
    do
      sync=$(dmesg | grep 'ADSL line is up')
      if [ ! -z "$sync" ]
      then
        pppd call speedtch
        exit 0
      fi
      sleep 1
    done
    echo "The SpeedTouch firmware did not load"
    exit 1

Now install this to the /usr/bin directory:

    chmod +x start_internet &&
    cp start_internet /usr/bin/

Now we will create another script. Save this as speedtouch:

    #!/bin/bash 

    . /etc/rc.conf
    . /etc/rc.d/functions

    case "$1" in
      start)
        stat_busy "Starting SpeedTouch Connection"
        start_internet &>/dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          add_daemon speedtch
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping SpeedTouch Connection"
        poff speedtch &>/dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon speedtch
          stat_done
        fi
        ;;
      restart)
        $0 stop
        sleep 1
        $0 start
        ;;
      *)
        echo "usage: $0 {start|stop|restart}"  
    esac
    exit 0

Install this in the directory /etc/rc.d:

    chmod +x speedtouch &&
    cp speedtouch /etc/rc.d/

Now edit your rc.conf:

    nano /etc/rc.conf

In the daemons line, add speedtouch after network. Eg:

    DAEMONS=(syslog-ng network speedtch firestarter netfs crond alsa hal fam)

Right. All configuration files are there. Delete anything you do not
need from your home directory (scripts etc.), double check everything is
in place, and reboot.

As it starts up, your modem should automatically sync, and you should
automatically be connected.

Now, any connection management can be used with /etc/rc.d/speedtouch:

    /etc/rc.d/speedtouch start
    /etc/rc.d/speedtouch stop
    /etc/rc.d/speedtouch restart

Further Information
-------------------

A lot of this guide used information from http://www.linux-usb.org.
Visit there for more information.

This guide doesn't use PPPoE. I will add this when I have more time.

Any comments or questions, try the discussion page.

Hope you found this helpful and feel free to improve it!

Retrieved from
"https://wiki.archlinux.org/index.php?title=SpeedTouch_ADSL_Modem&oldid=302552"

Category:

-   Modems

-   This page was last modified on 28 February 2014, at 23:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
