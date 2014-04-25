Weewx
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Need to update    
                           style to follow          
                           Help:Style. (Discuss)    
  ------------------------ ------------------------ ------------------------

Weewx is a free, open source, software program, written in Python, which
interacts with your weather station to produce graphs, reports, and HTML
pages.

Build and install
-----------------

These are my notes I took when I installed weewx. I may have easily left
something out.

    pacman -S python2 python2-configobj python2-cheetah python2-imaging
    ln -s /usr/bin/python2 /usr/local/bin/python
    ./setup.py build
    sudo ./setup.py install

Note that I have created a symlink so that "python" gives you python2
rather than python3. That's because weewx requires python2, but python3
is default on Arch. I don't like this approach, and I'm sure there must
a better way. See the installation notes under Python.

You will also need PyUSB. I couldn't find a package for Arch, but it's
easy enough to install from sourceforge.net/projects/pyusb. Make sure
you get the 1.0 version, not the legacy 0.4. It uses setup.py, and
installation instructions are included with the tarball.

After installation, weewx wouldn't run because I didn't have permissions
on the weewx installation or the usb device. The weewx installation by
default goes in /home/weewx and is owned by root. For the device, run
lsusb and look for a line like this:

    Bus 002 Device 002: ID 0fde:ca01  

The device name for this example is /dev/bus/usb/002/002; modify yours
to match the Bus and Device in the lsusb output.

I gave myself permissions like this:

    sudo usermod -a -G adm my_username
    sudo chgrp adm /dev/bus/usb/002/002
    sudo chgrp -R adm /home/weewx
    sudo chmod -R g+w /home/weewx

In retrospect it might have been easier just to chown all the files to
myself, since I ended up running the weewx daemon as me. You could also
create a weewx user to own the files and run the daemon, which would be
the more "unixy" way.

After this it was just a matter of following the configuration
instructions from the weewx docs, then running the daemon. You could
make a service for it but I just run it in a tmux window.

    cd /home/weewx
    ./bin/weewxd weewx.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Weewx&oldid=294999"

Category:

-   Applications

-   This page was last modified on 30 January 2014, at 09:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
