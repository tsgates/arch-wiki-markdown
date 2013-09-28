Epson AcuLaser C900
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Everything deprecated:

See:
http://sourceforge.net/projects/alc900-cups/forums/forum/423970/topic/3173254

For now use the cvs version, in future releases the open source project
will support archlinux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
|     -   2.1 Files needed                                                 |
|     -   2.2 Installation                                                 |
|                                                                          |
| -   3 Configuration                                                      |
+--------------------------------------------------------------------------+

Introduction
============

Finally this printer is working in Archlinux.

Epson officially provides Linux driver through their avasys.jp page.
Although there's a nice Distribution chooser there are only .rpm
packages. Nevertheless we need them all except for the src package (they
are mirrored by the opensource project).

The epson driver seems to be GPL'ed so there's an open source project.
Don't waste your time, the installscript does not work and seems to be
complicated. We also need this driver. Oh AND we need the
libstdc++-libc6.2-2.so.3 from there. Easy going, isn't it?

Installation
============

Files needed
------------

Ok, let's start. You need:

1.  Cups + foomatic
2.  libstdc++-libc6.2-2.so.3
3.  alc900-cups-1.0.i386.tar.gz
4.  pipsplus-0.1b-1.i386.rpm
5.  pipsplus-epson-laser-0.1b-1.i386.rpm
6.  pipsplus-epson-alc900-0.1b-1.i386.rpm
7.  pipsplus-gtk-0.1b-1.i386.rpm
8.  rpmextract from extra.

Installation
------------

First copy libstdc++-libc6.2-2.so.3 to /usr/lib

Put all the .rpm files in one directory and do

    rpmextract.sh *.rpm

You should get a usr/ directory with some subfolders. You need these in
your file System. As root:

    cp -r usr /

I did not figure out how to actually print with this setup so I had to
use the open source driver. Extract your alc900-cups-1.0.i386.tar.gz

  
 Search for the file called 'Epson-AcuLaser_C900-alc900.ppd' and copy it
to /etc/cups/ppd/ (not sure if this is needed but so it will be found by
plugging in the printer). Because the install.sh does not work on
Archlinux we need to copy the files manually into the filesystem.

At first the foomatic filters. As root:

    cp -r foomatic /usr/share/

Next all the binaries. Copy all the .sh scripts and all the alc900.*
files that do not end with .c plus the files usleep, pipe, alc900 to
/usr/bin.

To start the pips system we have to copy pipsplus to /etc/rc.d/

    cp pipsplus /etc/rc.d/

To run it on every boot you should insert pipsplus in the daemons array
in /etc/rc.conf

Configuration
=============

Hopefully now it will work. Just start pipsplus

    /etc/rc.d/pipsplus start

It has to say Starting AcuLaser C900 (alc900.daemon ) otherwise it will
not work.

Make sure cups read all the new files by restarting it

    /etc/rc.d/cupsd restart

(don't know whether this is needed either...)

Now plug in your printer and go to your cups config and add a new
printer. If the printer is connected through usb and it does not show up
just select LPT1 and change it later.

You should not choose a printer model but tell him the path to
Epson-AcuLaser_C900-alc900.ppd

My device URI for my printer connected through usb is
'usb://EPSON/AL-C900' even though it is not recommended on the website
of the open source driver to use this. But actually this does work for
me.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Epson_AcuLaser_C900&oldid=196836"

Category:

-   Printers
