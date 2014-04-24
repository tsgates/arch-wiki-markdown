Amateur Radio
=============

  
 Amateur radio enthusiasts (sometimes called ham radio operators or
"hams") have been at the forefront of experimentation and development
since the earliest days of radio. A wide variety of communication modes
are used on a vast range of frequencies that span the electromagnetic
spectrum. This page lists software related to amateur radio that can be
found in the AUR. Some of it is stand-alone while the various digital
communication applications require interfacing to radio hardware and
possibly the computer soundcard. Interface hardware can be purchased
from vendors or home-built.

Warning:International treaties require that users of amateur radio
frequencies have a government-issued license. This only affects you if
you have a transmitter and an antenna, receiving amateur radio or just
downloading amateur radio software isn't illegal.

Contents
--------

-   1 General information
-   2 Software list
    -   2.1 AX.25
    -   2.2 WSJT
    -   2.3 WSPR
    -   2.4 Xastir
    -   2.5 Analysis tools
    -   2.6 Logging
    -   2.7 Tools
    -   2.8 Morse code training
    -   2.9 Other

General information
-------------------

Many of the following programs will need to access a serial port to key
the transmitter (eg. /dev/ttyS0). This requires that the user belong to
the uucp group. To add the user to the uucp group issue the following
command as root:

    # gpasswd -a username uucp

then logoff and logon.

Software list
-------------

-   Hamlib — provides an interface between hardware and radio control
    programs. It is a software layer to facilitate the control of radios
    and other hardware (eg. for logging, digital modes) and is not a
    stand-alone application.

http://sourceforge.net/apps/mediawiki/hamlib/ || hamlib

-   Soundmodem — was written by Tom Sailer (HB9JNX/AE4WA) to allow a
    standard PC soundcard to act as a packet radio modem for use with
    the various AX.25 communication modes. The data rate can be as high
    as 9600 baud depending on the hardware and application. Soundmodem
    can be used as a KISS modem on the serial port or as an AX.25
    network device. To use soundmodem as an MKISS network device, the
    kernel must be re-built with MKISS modules. More information is in
    the Xastir wiki

Run soundmodem as root:

    # soundmodem

If you have configured soundmodem as a KISS modem, you will need to
change permissions to make it user-readable:

    # chmod 666 /dev/soundmodem0

http://www.baycom.org/~tom/ham/soundmodem/ || soundmodem

-   Grig — simple control program based on Hamlib

http://groundstation.sourceforge.net/grig/ || grig

-   gMFSK — is a user interface that supports a multitude of digital
    modes. It uses hamlib and xlog for logging

http://gmfsk.connect.fi || gmfsk

-   lysdr — highly customizable radio interface

https://github.com/gordonjcp/lysdr || lysdr-git

-   linrad — Software defined radio by SM5BSZ

http://www.sm5bsz.com/linuxdsp/linrad.htm || linrad

-   quisk — Software defined radio by N2ADR

http://james.ahlstrom.name/quisk/ || quisk

-   owx — command-line utility for programming Wouxun radios

http://owx.chmurka.net || owx

-   twcw — extension for cwirc

http://wa0eir.home.mchsi.com/twcw.html || not packaged? search in AUR

-   fldigi — popular GUI developed by W1HKJ for a variety of digital
    communication modes

http://w1hkj.com/Fldigi.html || fldigi

-   libfap — APRS packet parser

http://pakettiradio.net/libfap/ || libfap

-   aprx — lightweight APRS digipeater and i-Gate interface

http://wiki.ham.fi/Aprx.en || aprx-svn

-   xdx — network client

http://www.qsl.net/pg4i/linux/xdx.html || xdx

-   d-rats – D-STAR communication tool
-   qsstv – Slow-scan television
-   linpsk – PSK31
-   psk31lx – PSK31 using Pulseaudio
-   twpsk – Soundcard based program for PSK31
-   xpsk31 – PSK31 using a GUI rendered by GTK+

> AX.25

AX.25 — data link layer protocol that is used extensively in packet
radio networks. It supports connected operation (eg.
keyboard-to-keyboard contacts, access to local bulletin board systems,
and DX clusters) as well as connectionless operation (eg. APRS). The
Linux kernel includes native support for AX.25 networking. Please refer
to this guide for more information. The following software is available
in the AUR:

-   ax25-apps
-   ax25-tools
-   libax25
-   node

http://www.ax25.net/ || present in stock kernel

> WSJT

WSJT (Weak Signal Communication by K1JT) — offers offers a rich variety
of features, including specific digital protocols optimized for meteor
scatter, ionospheric scatter, and EME (moonbounce) at VHF/UHF, as well
as HF skywave propagation. WSJT was developed by Nobel Prize winning
physicist Joe Taylor, who has the amateur radio callsign K1JT. The
program can decode fraction-of-a-second signals reflected from ionized
meteor trails and steady signals 10 dB below the audible threshold.  
 WSJT is in ongoing, active development by a team of programmers led by
K1JT. WSJT (and the related program WSPR) has the option of being
configured with

    $ ./configure --enable-g95

or

    $ ./configure --enable-gfortran

If you build with one and experience problems, edit PKGBUILD to try the
other.  
 WSJT requires access to the serial port; see the note in the
Interfacing section above about the uucp group.

http://www.physics.princeton.edu/pulsar/K1JT/ || wsjt-svn

> WSPR

WSPR (Weak Signal Propagation Reporter, pronounced whisper) — enables
the probing of propagation paths on the amateur radio bands using low
power transmissions. It was introduced in 2008 by K1JT following the
success and widespread adoption of WSJT by the amateur radio community.
Stations with Internet access can automatically upload their reception
reports to a central database called WSPRnet, which includes a mapping
facility

http://physics.princeton.edu/pulsar/K1JT/wspr.html || wspr-svn

> Xastir

Xastir — stands for X Amateur Station and Information Reporting. It
works with APRS, an amateur radio-based system for real time tactical
digital communications. Xastir is an open-source program that provides
full-featured, client-side access to APRS. It is currently in a state of
active development.  
Xastir is highly flexible and there are a wide variety of ways it can be
configured. For example, it can be evaluated without radio hardware if
an Internet connection is available. The wiki at xastir.org is very
thorough and gives excellent information on its range of capabilities
and setup.  
An optional speech feature can be enabled with the festival package; you
will also need a speaker package such as festival-en or
festival-english. If you want this option, festival must be installed on
your system before building xastir. Launch festival before the xastir
program is started for speech to function properly:

    $ festival --server

or you can write a simple script to automate the sequential starting
process. There may be problems if other programs such as a media player
are accessing sound simultaneously.  
The PKGBUILD automatically downloads an 850 kB bundle of .wav files and
places them here: /usr/share/xastir/sounds/.  
These are audio alarm recordings of a North American English speaker
that do not require the presence of festival to render. The audio play
command `play' in the configure menu may not work; try `aplay' instead.

http://www.xastir.org || xastir

> Analysis tools

-   fl_moxgen – Moxon antenna designer
-   geoid – Geodetic calculator
-   gpredict – Real-time satellite tracking and orbit prediction
    application
-   hamsolar – Small desktop display of the current solar indices
-   splat – rf signal propagation, loss, and terrain analysis
-   sunclock – Useful for predicting grayline propagation paths
-   xnec2c – Electromagnetic antenna modeler

> Logging

-   cqrlog – a popular Linux logging program
-   fdlog – a Field Day Logger with networked nodes
-   klog – a Ham radio logging program for Linux / KDE.
-   qle – QSO Logger and log Editor for amateur radio operators written
    in Perl
-   tlf – a console mode networked logging and contest program
-   trustedqsl – QSL application for ARRL's Logbook of the World
-   tucnak2 – a multiplatform VHF/HF contest logbook
-   xlog – a logging program for amateur radio operators.
-   yfklog – a general purpose ham radio logbook for *nix operating
    systems.
-   yfktest – a logbook program for ham radio contests.

> Tools

-   callsign – a small program for finding information about a ham radio
    based on his callsign
-   cty – package contains databases of entities (countries), prefixes
    and callsigns that are used by amateur radio logging software.
-   dxcc – a small program for determining ARRL DXCC entity of a ham
    radio callsign
-   tqsllib – Trusted QSL library (supports ARRL Logbook of the World)

> Morse code training

-   aldo
-   cutecw
-   ebook2cw
-   gtkmmorse
-   kochmorse
-   qrq
-   unixcw

> Other

-   cwirc – Send and receive Morse code messages via IRC

Retrieved from
"https://wiki.archlinux.org/index.php?title=Amateur_Radio&oldid=281242"

Category:

-   Telephony and Voice

-   This page was last modified on 3 November 2013, at 16:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
