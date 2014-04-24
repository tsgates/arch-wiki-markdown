DeveloperWiki:Python2.6 Rebuild
===============================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is created with the intention to organize, as well as
possible, binaries which be rebuilt in [community] for the python-2.6
upgrade.

Tips from Allan:

-   Not all packages need rebuilt
-   The packages which need rebuilt are:
    -   packages that link to libpython2.5.so
    -   packages with headers in /usr/include/python2.5
    -   packages which add their path to the python system path
    -   packages which need rebuilt beacause above rebuilds

Tips from angvp:

-   Packages which uses gstreamer0.10-python will break if the file
    pygst.pyc still exist under /usr/lib/python2.5/site-packages/ delete
    it

Contents
--------

-   1 List of python packages in community (by category)
    -   1.1 daemons
    -   1.2 devel
    -   1.3 editors
    -   1.4 games
    -   1.5 lib
    -   1.6 modules
    -   1.7 multimedia
    -   1.8 network
    -   1.9 system
    -   1.10 x11
-   2 List of python packages in community (by maintainer)
    -   2.1 abhidg
    -   2.2 Allan
    -   2.3 angvp
    -   2.4 bardo
    -   2.5 BaSh
    -   2.6 codemac
    -   2.7 Dragonlord
    -   2.8 dsa
    -   2.9 dtw
    -   2.10 elasticdog
    -   2.11 gcarrier
    -   2.12 gummibaerchen
    -   2.13 hdoria
    -   2.14 ornitorrincos
    -   2.15 phrakture
    -   2.16 Pierre
    -   2.17 pressh
    -   2.18 Romashka
    -   2.19 sergej
    -   2.20 Snowman
    -   2.21 swiergot
    -   2.22 voidnull

List of python packages in community (by category)
--------------------------------------------------

daemons

-   lastfmsubmitd 0.35-1 – codemac

devel

-   beautiful-soup 3.0.7a-1 – dsa
-   cherrypy 3.1.0-1 – dsa might need patch
-   eclipse-pydev 1.3.22-1 – dsa
-   epydoc 3.0-1 – dsa
-   gazpacho 0.7.2-1 – dsa
-   gnome-python-docs 2.24.0-1 – dsa Redundant?
-   ipython 0.9-1 – dsa
-   jython 2.2.1-2 – gcarrier
-   omniorb 4.1.3-1 – voidnull
-   pida 0.5.1-3 – Allan
-   psyco 1.6-1 – dsa
-   pychecker 0.8.18-1 – sergej
-   pydb 1.22-2 – Snowman
-   python-docs 2.5.2-1 – sergej

editors

-   emacs-python-mode 1.0-4 – sergej

games

-   solarwolf 1.5-3 – Allan

lib

-   adns-python 1.2.1-1 – sergej
-   libgmail 0.1.10-1 – swiergot missing dep... (GopherError)
-   panda3d 1.5.3-2 – ornitorrincos
-   pycddb 0.1.3-2 – sergej
-   pyclamav 0.4.1-1 – Pierre
-   pycups 1.9.42-1 – BaSh
-   pydns 2.3.1-1 – Pierre
-   pyenchant 1.4.2-1 – Allan
-   pyglet 1.1.2-1 – dsa
-   pygoocanvas 0.12.0-3 – dsa
-   pyid3lib 0.5.1-3 – sergej
-   pykde 3.16.1-1 – dsa
-   pymsn 0.3.3-1 – sergej
-   pyopenssl 0.7-1 – sergej
-   pyrtf 0.45-1 – sergej
-   pysdl_mixer 0.0.3-2 – sergej
-   pysol-sound-server 3.01-4 – Snowman
-   pyspf 1.6-1 – Pierre
-   pystatgrab 0.5-1 – Dragonlord
-   python-boto 1.3a-1 – elasticdog
-   python-bsddb 4.7.2-1 – dsa
-   python-chardet 1.0.1-1 – sergej
-   python-clientform 0.2.9-1 – dsa
-   python-configobj 4.5.3-1 – angvp
-   python-constraint 1.1-2 – dsa
-   python-cssutils 0.9.5.1-1 – BaSh
-   python-dateutil 1.4-2 – phrakture
-   python-distutils-extra 1.91.2-1 – abhidg
-   python-dnspython 1.4.0-2 – sergej
-   python-flup 1.0.1-1 – elasticdog
-   python-fuse 20071117-1 – swiergot
-   python-galago 0.5.0-1 – sergej
-   python-galago-gtk 0.5.0-1 – sergej
-   python-gammu 0.27-1 – bardo
-   python-genshi 0.5.1-1 – sergej
-   python-geotypes 0.7.0-1 – gcarrier
-   python-geotypes-svn 876-1 – dtw
-   python-gnupginterface 0.3.2-2 – elasticdog
-   python-ldap 2.3.5-1 – sergej
-   python-lxml 2.1.2-1 – dsa
-   python-m2crypto 0.16-2 – sergej
-   python-matplotlib 0.98.3-2 – dsa might need patch...
-   python-mechanize 0.1.7b-1 – dsa missing dep... (GopherError)
-   python-mpdclient2 0.11.1-3 – codemac
-   python-musicbrainz2 0.4.1-1 – hdoria
-   python-nose 0.10.3-1 – dsa might need patch...
-   python-notify 0.1.1-3 – hdoria Updated by angvp + BaSh
-   python-numarray 1.5.2-2 – dsa
-   python-numpy 1.2.0-1 – dsa
-   python-openbabel 2.2.0-1 – BaSh
-   python-paramiko 1.7.4-1 – dsa might need patch...
-   python-pexpect 2.3-1 – elasticdog
-   python-pigment 0.3.8-1 – BaSh
-   python-psycopg1 1.1.21-2 – dsa
-   python-psycopg2 2.0.7-1 – dsa
-   python-pyalsaaudio 0.3-1 – Allan
-   python-pybluez 0.15-1 – sergej
-   python-pychart 1.39-3 – dsa
-   python-pychm 0.8.4-2 – Romashka
-   python-pymedia 1.3.7.3-6 – voidnull
-   python-pyparallel 0.1-2 – dsa
-   python-pypdf 1.10-1 – dsa might need patch
-   python-pyro 3.8beta-1 – dsa
-   python-pyserial 2.2-2 – dsa
-   python-pytz 2008c-1 – dsa might need patch
-   python-pyx 0.10-2 – dsa
-   python-pyxmpp 1.0.0-3 – sergej
-   python-reportlab 2.2-1 – dsa
-   python-scipy 0.6.0-2 – dsa not compatible with python 2.6
-   python-sexy 0.1.9-3 – Allan
-   python-simplejson 2.0.1-1 – Allan
-   python-sphinx 0.4.3-1 – dsa
-   python-sqlalchemy 0.4.6-1 – pressh might need patch
-   python-urwid 0.9.8.2-1 – sergej might need patch
-   python-vorbissimple 0.0.2-1 – sergej
-   tagpy 0.94.5-7 – BaSh
-   xmpppy 0.4.1-1 – sergej might need patch
-   zsi 2.0-2 – abhidg

modules

-   python-pygresql 3.8.1-3 – voidnull

multimedia

-   imdbpy 3.6-1 – gcarrier
-   mmpython 0.4.10-1 – gcarrier
-   pympc 20050330-3 – sergej
-   tango-generator 3.2.3-1 – gcarrier

network

-   courier-pythonfilter 1.4-2 – Pierre
-   ipcheck 0.237-1 – codemac
-   moinmoin 1.7.2-1 – sergej
-   python-certtool 0.1-4 – hdoria
-   python-gnutls 1.1.6-2 – hdoria
-   urlgrabber 3.1.0-1 – gcarrier

system

-   iotop 0.2.1-1 – Dragonlord

x11

-   ccsm 0.7.8-1 – pressh
-   compizconfig-python 0.7.8-1 – pressh
-   glipper 1.0-7 - sergej
-   pypanel 2.4-3 – codemac
-   python-xlib 0.13-3 – codemac
-   wammu 0.29-1 – bardo might only need python-gammu rebuild
-   guake 0.3.1-1 – angvp Updated by angvp and BaSh

List of python packages in community (by maintainer)
----------------------------------------------------

abhidg

-   python-distutils-extra 1.91.2-1
-   zsi 2.0-2

Allan

-   pida 0.5.1-3
-   pyenchant 1.4.2-1
-   python-pyalsaaudio 0.3-1
-   python-sexy 0.1.9-3
-   python-simplejson 2.0.1-1
-   solarwolf 1.5-3

angvp

-   python-configobj 4.5.3-2
-   guake 0.3.1 Updated by angvp and BaSh

bardo

-   python-gammu 0.27-1
-   wammu 0.29-1

BaSh

-   elisa 0.5.16-1
-   elisa-plugins 0.5.16-1
-   pycups 1.9.42-1
-   python-cssutils 0.9.5.1-1
-   python-openbabel 2.2.0-1
-   python-pigment 0.3.8-1
-   screenlets 0.1.2-1
-   system-config-printer 1.0.9-1
-   tagpy 0.94.5-7

codemac

-   ipcheck 0.237-1
-   lastfmsubmitd 0.35-1
-   pypanel 2.4-3
-   python-mpdclient2 0.11.1-3
-   python-xlib 0.13-3

Dragonlord

-   iotop 0.2.1-1
-   pystatgrab 0.5-1

dsa

-   beautiful-soup 3.0.7a-1
-   cherrypy 3.1.0-1
-   eclipse-pydev 1.3.22-1
-   epydoc 3.0-1
-   gazpacho 0.7.2-1
-   gnome-python-docs 2.24.0-1
-   ipython 0.9-1
-   psyco 1.6-1
-   pyglet 1.1.2-1
-   pygoocanvas 0.12.0-3
-   pykde 3.16.1-1
-   python-bsddb 4.7.2-1
-   python-clientform 0.2.9-1
-   python-constraint 1.1-2
-   python-lxml 2.1.2-1
-   python-matplotlib 0.98.3-2
-   python-mechanize 0.1.7b-1
-   python-nose 0.10.3-1
-   python-numarray 1.5.2-2
-   python-numpy 1.2.0-1
-   python-paramiko 1.7.4-1
-   python-psycopg1 1.1.21-2
-   python-psycopg2 2.0.7-1
-   python-pychart 1.39-3
-   python-pyparallel 0.1-2
-   python-pypdf 1.10-1
-   python-pyro 3.8beta-1
-   python-pyserial 2.2-2
-   python-pytz 2008c-1
-   python-pyx 0.10-2
-   python-reportlab 2.2-1
-   python-scipy 0.6.0-2
-   python-sphinx 0.4.3-1

dtw

-   python-geotypes-svn 876-1

elasticdog

-   duplicity
-   python-boto 1.3a-1
-   python-flup 1.0.1-1
-   python-gnupginterface 0.3.2-2
-   python-pexpect 2.3-1

gcarrier

-   imdbpy 3.6-1
-   jython 2.2.1-2
-   mmpython 0.4.10-1
-   python-geotypes 0.7.0-1
-   tango-generator 3.2.3-1
-   urlgrabber 3.1.0-1

gummibaerchen

hdoria

-   python-certtool 0.1-4
-   python-gnutls 1.1.6-2
-   python-musicbrainz2 0.4.1-1
-   python-notify 0.1.1-3 Updated by angvp and BaSh

ornitorrincos

-   panda3d 1.5.3-2

phrakture

-   python-dateutil 1.4-2

Pierre

-   courier-pythonfilter 1.4-2
-   pyclamav 0.4.1-1
-   pydns 2.3.1-1
-   pyspf 1.6-1

pressh

-   ccsm 0.7.8-1
-   compizconfig-python 0.7.8-1
-   python-sqlalchemy 0.4.6-1

Romashka

-   python-pychm 0.8.4-2

sergej

-   adns-python 1.2.1-1
-   emacs-python-mode 1.0-4
-   moinmoin 1.7.2-1
-   pycddb 0.1.3-2
-   pychecker 0.8.18-1
-   pyid3lib 0.5.1-3
-   pympc 20050330-3
-   pymsn 0.3.3-1
-   pyopenssl 0.7-1
-   pyrtf 0.45-1
-   pysdl_mixer 0.0.3-2
-   python-chardet 1.0.1-1
-   python-dnspython 1.4.0-2
-   python-docs 2.5.2-1
-   python-galago 0.5.0-1
-   python-galago-gtk 0.5.0-1
-   python-genshi 0.5.1-1
-   python-ldap 2.3.1-2
-   python-m2crypto 0.16-2
-   python-pybluez 0.15-1
-   python-pyxmpp 1.0.0-3
-   python-urwid 0.9.8.2-1
-   python-vorbissimple 0.0.2-1
-   xmpppy 0.4.1-1

Snowman

-   pydb 1.22-2
-   pysol-sound-server 3.01-4

swiergot

-   libgmail 0.1.10-1
-   python-fuse 20071117-1

voidnull

-   omniorb 4.1.3-1
-   python-pygresql 3.8.1-3
-   python-pymedia 1.3.7.3-6

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Python2.6_Rebuild&oldid=206244"

Categories:

-   DeveloperWiki
-   Arch development

-   This page was last modified on 13 June 2012, at 12:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
