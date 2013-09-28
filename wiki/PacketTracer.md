PacketTracer
============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Numerous         
                           violations of Help:Style 
                           and other formatting     
                           problems. (Discuss)      
  ------------------------ ------------------------ ------------------------

The easy way
------------

You can just download the generic version (when you are logged in) and
install it like any other program.

Or you can use the AUR package packettracer:

Requirements:

You should have installed the package group base-devel before (pacman -S
base-devel).

-   Download PacketTracer533_Generic_Fedora.tar.gz (you can find this
    package with google)
-   Download
    https://aur.archlinux.org/packages/pa/packettracer/packettracer.tar.gz:

    wget https://aur.archlinux.org/packages/pa/packettracer/packettracer.tar.gz

-   Extract packettracer.tar.gz and go into that directory:

    tar -xzf packettracer.tar.gz
    cd packettracer

-   Put PacketTracer533_Generic_Fedora.tar.gz into that directory.
-   Run makepkg as a normal user:

    makepkg

-   The Package is now build and you could install it for your platform
    (as root):

    pacman -U packettracer-5.3.3-1-i686.pkg.tar.xz

or

    pacman -U packettracer-5.3.3-1-amd64.pkg.tar.xz

-   Done.

The hard (old) way
------------------

PacketTracer is an application from Cisco that allows network
simulations and training using Cisco/Linksys products (like
routers/switches/wireless hardware).

I used to run it under Wine but the Linux version is now available;
unfortunately it is only for Ubuntu/Debian and Fedora/Red Hat.

But of course it can be installed on Arch (what can't you do with
Arch? :)) with a little work.

- Run the installer. While it displays the license agreement, DO NOT DO
ANYTHING! Go to another terminal and run

    find /tmp -iname *.deb

- Grab the .deb file, put it somewhere (like ~/tmp) and issue this
command:

    bsdtar -xf PacketTracer-5.0-u.i386.deb data.tar.gz

- Decompress the data.tar.gz file, it will create a folder usr within
the currently directory, and within usr/local there is a folder
'PacketTracer5'. Move it to /usr/local/.

- To run:

    /usr/local/PacketTracer5/bin/PacketTracer5 

Enjoy :)

Looks ugly, but you can fix this and make it grab your system theme by
symlinking the Qt libraries in /usr/local/PacketTracer5/lib/ to the ones
in /usr/lib, e.g.

    libQt3Support.so.4.3.3 -> /usr/lib/libQt3Support.so.4
    libQtCore.so.4.3.3 -> /usr/lib/libQtCore.so.4.3.3
    libQtGui.so.4.3.3 -> /usr/lib/libQtGui.so.4.3.3
    libQtNetwork.so.4.3.3 -> /usr/lib/libQtNetwork.so.4
    libQtSql.so.4.3.3 -> /usr/lib/libQtSql.so.4
    libQtXml.so.4.3.3 -> /usr/lib/libQtXml.so.4

Retrieved from
"https://wiki.archlinux.org/index.php?title=PacketTracer&oldid=233388"

Category:

-   Networking
