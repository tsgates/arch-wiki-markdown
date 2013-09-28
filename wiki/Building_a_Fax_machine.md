Building a Fax machine
======================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Many style       
                           problems. (Discuss)      
  ------------------------ ------------------------ ------------------------

Following steps illustrating the setup of fax machine on a Linux box and
send faxes direct on application with "Print" command. Its features are
similar to running Symantic WinFax on MS Windows box. The complete steps
are divided into 3 parts, namely;

  
 Part-1

Installation of efax-gtk package

http://efax-gtk.sourceforge.net

efax-gtk is the front-end of efax

http://www.cce.com/efax/

  

Part-2

Setup of fax machine on a Linux box,

Arch Linux

Version 86-64 2007-08-2

Gnome Desktop

  

Part-3

Setup of a Virtual fax printer, allowing to send fax direct on
application with the "Print" command.

  

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Part-1                                                             |
| -   2 Part-2                                                             |
| -   3 Part-3                                                             |
| -   4 Testing                                                            |
+--------------------------------------------------------------------------+

Part-1
======

Installing efax-gtk

package:- efax-gtk-3.0.12-1 in the AUR

https://aur.archlinux.org/packages.php?ID=6884

It needs following dependencies

glibc

gtk2

libsigc++2.0

  
 Other packages required

cups 1.3.6-1

libcups 1.3.6-1

libgnomecups 0.2.3-1

  

To check whether the aforementioned dependencies are already running on
the Arch Linux box;

$ pacman -Qs glibc

    local/glibc 2.7-7 (base)
    GNU C Library
    local/nss-mdns 0.10-1
    glibc plugin providing host name resolution via mDNS

  
 $ pacman -Qs gtk2

    local/gtk-sharp-2 2.10.2-1
    gtk2 bindings for C#
    local/gtk2 2.12.8-1
    The GTK+ Toolkit (v2)

  
 $ pacman -Qs libsigc++

    local/libsigc++2.0 2.1.1-1
    Libsigc++ implements a full callback system for use in widget libraries - V2

They are already running on the Arch Linux box.

  
 $ sudo nano /etc/makepkg.conf

set PKGDEST as;

    PKGDEST=/home/user/efax-gtk

  
 Creating the prebuild package

$ cd /home/user

$ wget https://aur.archlinux.org/packages/efax-gtk/efax-gtk.tar.gz

  

$ tar zxpf efax-gtk.tar.gz

$ cd efax-gtk

$ ls

    PKGBUILD

  
 $ makepkg

    ==> ERROR: efax-gtk is not available for the 'x86_64' architecture.
    Note that many packages may need a line added to their PKGBUILD
    such as arch=('x86_64').

  
 $ cat PKGBUILD

    pkgname=efax-gtk
    pkgver=3.0.12
    pkgrel=1
    pkgdesc="Efax-gtk is a GUI front end for the efax fax program"
    url="http://efax-gtk.sourceforge.net"
    license="GPL"
    depends=('gtk2' 'glibc' 'libsigc++2.0')
    makedepends=(pkgconfig)
    source=(http://mesh.dl.sourceforge.net/sourceforge/efax-gtk/$pkgname-$pkgver.src.tgz)
    build() {
    #   mkdir -p $startdir/pkg/var/spool/fax
      cd $startdir/src/$pkgname-$pkgver
     ./configure --prefix=/usr --sysconfdir=/etc --with-spooldir=/var/spool/fax
     make || return 1
     make DESTDIR=$startdir/pkg install
    }
    md5sums=('837a212ea4e5e86cba32ea558c2e8c8a'

  
 add;

    arch=('x86_64')

between the lines;

    pkgver=3.0.12
    and
    pkgrel=1

  
 $ cat PREBUILD

    pkgname=efax-gtk
    pkgver=3.0.12
    arch=('x86_64')
    pkgrel=1
    pkgdesc="Efax-gtk is a GUI front end for the efax fax program"
    url="http://efax-gtk.sourceforge.net"
    license="GPL"
    depends=('gtk2' 'glibc' 'libsigc++2.0')
    makedepends=(pkgconfig)
    source=(http://mesh.dl.sourceforge.net/sourceforge/efax-gtk/$pkgname-$pkgver.src.tgz)
    build() {
    #   mkdir -p $startdir/pkg/var/spool/fax
      cd $startdir/src/$pkgname-$pkgver
     ./configure --prefix=/usr --sysconfdir=/etc --with-spooldir=/var/spool/fax
     make || return 1
     make DESTDIR=$startdir/pkg install
    }
    md5sums=('837a212ea4e5e86cba32ea558c2e8c8a'

  
 $ makepkg

    .....
    .....
    ==> Tidying install...
     -> Removing info/doc files...
     -> Compressing man pages...
     -> Stripping debugging symbols from binaries and libraries...
    ==> Creating package...
     -> Generating .PKGINFO file...
     -> Compressing package...
    ==> Leaving fakeroot environment.
    ==> Finished making: efax-gtk (Sat Mar 22 21:32:49 HKT 2008)

  
 $ sudo pacman -U efax-gtk-3.0.12-1-x86_64.pkg.tar.gz

    Password: 
    loading package data...
    checking dependencies...
    (1/1) checking for file conflicts  [#################################################] 100%
    (1/1) installing efax-gtk          [#################################################] 100%

  

$ which efax-gtk

    /usr/bin/efax-gtk

  
 On GNOME desktop

Applications --> Office --> Efax-gtk

starts "efax-gtk: Conditions, Notices and Disclaimers" window

--> Accept

start "efax-gtk" window

    Socket running on port 9900

  

Part-2
======

Applications --> Office --> efax-gtk

starts "efax-gtk"

  
 Make following change;

File --> Settings

--> Identity

    Name:   Your name
    Number: Your fax/tel line number

--> Modem Change;

    Serial Device:ttyS1

as;

    ttyS0

--> Receive

    [check] Popup dialog when fax received by modem

leaving others as DEFAULT --> OK

  
 Clicking "Standby"

    [Inactive] changed to [Standing by to receive calls]

  
 On the windown box displaying;

    Socket running on port 9900
    efax-0.9a:14:07:41 opened /dev/ttySO
    efax-0.9a:14:07:43
    efax-0.9a: 13:29:34 using V2.210-
    V90_2M DLSROCKWELLAC/K56 in class 2
    efax-0.9a: 13:29:34 waiting for activity

  
 Efax-gtk can now send and receive faxes.

  

Part-3
======

Setup "Print Fax" command allowing to send fax on application with
"Print" command.

  
 Perform following steps;

1.  On a browser, type localhost:631 on URL-box
2.  Click "Administration" tag and select "Add Printer".
3.  On "Add new printer" page, fill in the first line ("Name") with Fax,
    leaving other two lines blank. --> Continue
4.  On "Device for Fax" page, highlight "Internet Printing Protocol
    (ipp)" (actually, it doesn't matter what you select). --> Continue
5.  On "Device URI for Fax" page, replace "ipp:" with
    "socket://localhost:9900". --> Continue
6.  On "Maker/Manufacturer for Fax" highlight "Raw" --> Continue
7.  On "Model/Driver for Fax" page highlight "Raw Quene (en)" --> Add
    Printer
8.  On "Enter username and password for "CUPS" at http://localhost:631"
    window

    Username: root
    Password: root password --> OK

9. "Set Printer Options"

    Fax: Banners
    Starting Banner: none
    Ending Banner: none
    --> Set printer Options
    Fax: Policies
    Error Policy: stop-printer
    Operation Policy: default
    --> Set printer Options (clicking either one can work)

  
 Then following notice displayed

    The fax printer has been configured successfully.

  

Testing
=======

Start OpenOffice Writer

Typing few lines on it.

File --> Print --> Select "Fax" --> OK

Starts "efax-gtk: print job received on socket" window automatically.

    Enter "Tel number:" --> Send fax

  
 Fax sent.

Enjoy !!!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Building_a_Fax_machine&oldid=206065"

Category:

-   Other hardware
