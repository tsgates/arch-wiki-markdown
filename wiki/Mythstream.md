Mythstream
==========

  
 Mythstream is an unofficial plugin for MythTV which enables internet
audio/video streams. This is a short howto on getting mythstream to work
on Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Installation                                                       |
| -   3 Editing MythTV's menu files                                        |
| -   4 Wiki links                                                         |
| -   5 External links                                                     |
+--------------------------------------------------------------------------+

Requirements
============

MythTV v. 0.20, Mythstream v. 0.18, runtime versions of wget, perl and
the perl modules XML::Simple, XML::DOM, XML::XQL. XML::Simple
(perl-xml-simple) and XML::DOM (perl-xml-dom) are available from the
perlcpan repository: PerlCPAN_Repository. PKGBUILDs for XML::XQL
(perl-xml-xql), fftw2 compiled with single precision (fftw2single) and
mythstream have been submitted to AUR/unsupported. Obviously You will be
needing Mythtv from extra too.

Installation
============

Either enable the perlcpan repo in your /etc/pacman.conf or download and
install manually. Build and install the packages from AUR, perhaps with
Aurbuild.

With perlcpan enabled in /etc/pacman.conf and using aurbuild for
PKGBUILDS from AUR:

    pacman -S perl-xml-simple perl-xml-dom
    aurbuild -b perl-xml-xql fftw2single mythstream

Editing MythTV's menu files
===========================

From MythTV v. 0.20 and up, support for Mythstream menu entries has been
added to MythTV's menu xml files. However, in some cases you might need
to add the entries yourself.

In /usr/share/mythtv/themes/blue/theme.xml,

    <buttondef name="STREAM">
     <image>stream.png</image>
     <offset>60,30</offset>
    </buttondef>

In /usr/share/mythtv/themes/MythCenter[-wide]/theme.xml,

    <buttondef name="STREAM">
     <image>ui/button_off.png</image>
     <watermarkimage>watermark/stream.png</watermarkimage>
     <offset>0,0</offset>
    </buttondef>

In /usr/share/mythtv/mainmenu.xml,

    <button>
     <type>MYTHSTREAM</type>
     <text>Mythstream</text>
     <action>PLUGIN mythstream</action>
    </button>

  

Wiki links
==========

PerlCPAN_Repository  
 MythTV_Walkthrough  
 MythTV_HOWTO  

External links
==============

Mythstream  
 MythTV

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mythstream&oldid=197899"

Category:

-   Audio/Video
