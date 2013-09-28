Applixware
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Applixware is a free for non-commercial use office suite. It looks
rather dated, but I like using it as an alternative for LibreOffice, so
I wrote this how-to for installing it.

Installing
----------

Get version 6 from
http://www.vistasource.com/dl/applixware6-lnx-homeuser.tar.gz

Note:version 6.1 will be available soon.

Decompress it to /opt/applix.

In /usr/lib, symlink libstdc++-libc6.2-2.so.3 to libstdc++.so.6:

    # cd /usr/lib
    # ln -s libstdc++.so.6  libstdc++-libc6.2-2.so.3

From within /opt/applix, run ./install as root

    # ./install

Put this on your /etc/rc.local:

    /opt/applix/axdata/axnlmgrd -c /opt/applix/axlocal/axlicensedat -l /tmp/axnlmlog &

Run it with /opt/applix/applix. Enjoy.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Applixware&oldid=206127"

Category:

-   Office
