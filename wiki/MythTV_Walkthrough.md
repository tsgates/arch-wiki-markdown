MythTV Walkthrough
==================

Contents
--------

-   1 About this document
    -   1.1 What is MythTV ?
    -   1.2 Why two entries in the Wiki ?
    -   1.3 Localisation and Hardware variations
    -   1.4 Getting the DVB EPG to work with MythTV (todo)
    -   1.5 My personal information
    -   1.6 My Hardware
    -   1.7 My Location
    -   1.8 Much easier for DVB-T
-   2 Setting up the hardware
    -   2.1 Checking it exists
    -   2.2 Putting in the module
    -   2.3 Checking it works
-   3 Getting the first digital signal
    -   3.1 What transmitter do I use ?
    -   3.2 What is the ukXXXX file ?
    -   3.3 How do I find it ?
    -   3.4 What is channels.conf ?
    -   3.5 Generating the channels.conf
-   4 Getting the first picture
    -   4.1 Install and run Mplayer
    -   4.2 Making Mplayer work with DVB-T
-   5 Installing XMLTV
    -   5.1 Installing XMLTV
    -   5.2 You can have it all, but you do not want to
-   6 Installing MythTV
    -   6.1 Installing MySQL
    -   6.2 Installing MythTV
    -   6.3 Creating the Database
-   7 Setting up MythTV
    -   7.1 Select your preferred language
    -   7.2 Section 1. General
    -   7.3 Section 2. Capture Cards
    -   7.4 Section 3. Video Sources
    -   7.5 Section 4. Input Connections
    -   7.6 Section 5. Channel Editor
    -   7.7 First run of MythTV
    -   7.8 It might not be working.
-   8 Linking XMLTV and MythTV
    -   8.1 The shotgun wedding
    -   8.2 What you are trying to do, technically
    -   8.3 Using MythTV
    -   8.4 Using XMLTVDruid
    -   8.5 Doing it by MySQL Script or similar
    -   8.6 Checking that it's worked
    -   8.7 Running mythfilldatabase
    -   8.8 Now go and play
-   9 Extras
    -   9.1 The Font sizes and the Theme
    -   9.2 Setting up the Icons
    -   9.3 Segmentation Fault
    -   9.4 Using the remote control
-   10 MythTV-Setup Crashing
    -   10.1 How to fix it

About this document
===================

What is MythTV ?
----------------

MythTV is a Linux based Personal Video Recorder. It acts as an
intelligent combined television and video recorder. There are many
plugins for it which expand its basic functionality.

MythTV is unusual in that it is split into two. The "back end" and the
"front end". The back end receives and records the video, the front end
shows it and controls the back end. This allows you to separate the two.

Why two entries in the Wiki ?
-----------------------------

There already exists a wiki entry for installing mythtv. However, it
does lack detail for the less experienced user. I wanted to write a
"from beginning to end" installation guide for mythtv ; to do that would
require editing the original MythTV HOWTO pretty drastically, and would
lose its advantage of brevity and simplicity. I would recommend reading
both guides.

The downside to my approach is that the instructions are 'specific' for
my hardware and my location. What I do will only work if you live near
me and have my hardware, but I hope to give enough pointers to make the
document helpful for anyone who wishes to install MythTV anywhere.

The document is deliberately quite systematic ; do something, check
that's worked, then go on to the next step. If you can't figure it out
from the instructions it should help you understand where to look for
the right answers, and what part of the set up is being problematic.

Localisation and Hardware variations
------------------------------------

Getting the DVB EPG to work with MythTV (todo)
----------------------------------------------

MythTV can cope with a wide variety of hardware. There are two main
things that change from system to system which require significant
setting up.

Firstly, the video capture card. There are many of these and they are
often subtly different. MythTV does a pretty good job of detecting and
configuring hardware.

Secondly, the location. MythTV has an Electronic Program Guide (EPG)
built in, so that programmes can be recorded and viewed easily. There is
a common way of setting this up using a program called XMLTV, which
extracts data from web sites or other data providers. Some devices (for
example DVB-T cards) also require transmitter information.

Some digital systems can use the EPG which is part of the signal. This
now works in Arch Linux, and is described below.

My personal information
-----------------------

This guide is written 'as I do it'. However, this is for my hardware in
my location and yours is almost certainly different. I will offer
suggestions for alternatives where appropriate. It is always worth
reading installation guides for other machines ; the process of
installation does not vary significantly. If you have a common video
capture card, you can find help in most cases ..... somewhere. The
MythTV website is a good place to start.

My Hardware
-----------

I'm running Arch Linux 0.8 (Voodoo) with an NVIDIA card. The "important"
piece of hardware though is my DVB-T capture card. DVB-T is known in the
UK as "Freeview" ; it is digital television transmitted down the
'standard' aerial.

Other alternatives are the old analogue system, DVB-S (satellite) and
DVB-C (cable),

The capture card I am using is a Hauppauge WinTV "NOVA" model, which
fits internally in one of the PCI expansion slots. It is highly
recommended for DVB-T reception and it is pretty cheap.

My Location
-----------

I live in Norfolk in England and my nearest transmitter is in
Tacolneston. Fortunately, this is about 5 miles away which means I can
"get away with" an indoor aerial. Normally, DVB=T requires an outdoor
aerial. It is rather like FM radio ; you either get a good signal or
none at all.

Much easier for DVB-T
---------------------

Thanks to what I think is a new release, or me getting more comfy with
MythTV, or a bit of both, it is now much easier to install DVB-T MythTV.

However, I have left much of the document intact as it may be useful for
Analogue users, or anyone for whom the short cut doesn't work, or just
if you want to know how it all works.

It then becomes a much simpler setup. You do not have to scan for
channels or get transmitter information (MythTV does this for you), or
set up mplayer (though this is a good simple test of whether your card
is actually working or not). You do not have to install XMLTV, nor do
you have to link it to the SQL Database with the Perl scripts. For the
DVB-T you now just need to :

-   Set up the hardware
-   Install MythTV and MySQL
-   Run through the setup of MythTV

There is a downside. The EPG is only updated for 7 days, wherease the
Radio Times XML Grabber does a fortnight. This can be useful if you are
away more than 7 days. However, for simplicity I recomment you stick
with the DVB-T system.

Setting up the hardware
=======================

Fortunately, my hardware is autodetected by the Arch 0.8 Kernel, or
almost completely. It does not install the cx88_dvb module which is
required for my system.

Checking it exists
------------------

if you do either

    lspci

or

    lsusb

it will list all the devices connected to the PCI bus or the USB bus
respectively. You should see something which roughly describes your
hardware. In my case, lspci produces

    02:01.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
    02:01.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
    02:01.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)

you can also look at the boot log by typing

    dmesg | less

this shows what the system is doing as it 'boots up' ; somewhere you
will hopefully see text which describes your card. In my case, a part of
the log is

    Linux video capture interface: v2.00
    cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded
    CORE cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18,autodetected]
    TV tuner 4 at 0x1fe, Radio tuner -1 at 0x1fe

there is a great deal more descriptive information, but this is very
hardware specific.

Putting in the module
---------------------

To force the Kernel to load the cx88_dvb module I changed my rc.conf
file so the "MODULES" line reads as follows

    MODULES=(r8169 cx88_dvb)

This will force the kernel to load the module at start up. The r8169
module is my network card and is likely to be different on your system.

You can reboot it ; if you do not want to, load it yourself just this
once, with

    modprobe cx88_dvb

Checking it works
-----------------

The simplest way to check it works initially and that the system has
recognised it, is to check for the existence of the video device(s) in
linux.

    ls /dev/v4l

checks for analogue devices and

    ls /dev/dvb

checks for digital devices. In both cases you should see a list of
device links (like a directory listing). If these are present then linux
has probably recognised the card and it might work.

The next stage is to try and see if it is picking up any signal.

Getting the first digital signal
================================

This is no longer required for DVB Setup. However it's very useful if
there are problems getting it to work, as it's much simpler than MythTV,
and if this part works you know the card is working correctly.

This part is very specific to DVB-T. For a standard analogue card, you
have to do very little ; for DVB-C and DVB-S I do not know.

The first thing to do is to install linux-dvb-apps.

    pacman -S linuxtv-dvb-apps

What transmitter do I use ?
---------------------------

Each transmitter transmits DVB-T signals on a different frequency. You
need to find a file which describes your local transmitter frequencies.

The simplest way in the UK is to use the WolfBane website at
http://www.wolfbane.com. If you click on "UK digital TV reception
predictor" you can enter your postal code (what we call the "zip code")
and it will tell you what transmitters are available.

The next stage is to find the "ukxxxx" file.

What is the ukXXXX file ?
-------------------------

The ukxxxx file is the file that describes how your transmitter
transmits DVB-T data. For my transmitter, Tacolneston, it looks like
this :-

    # UK Tacolneston
    # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
    T 730166670 8MHz 3/4 NONE QAM16 2k 1/32 NONE

I have no idea what it means either, if it's any consolation. Not that
it matters much, as long as it works.

How do I find it ?
------------------

If you have installed linuxtv-dvb-apps (i.e. you're following the
instructions) you should find a listing of these in the
/usr/share/dvb/dvb-t/. If your transmitter is not listed there (or you
haven't installed linuxtv-dvb-apps), see if it's listed on their
website: http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/

If you still can't find your transmitter, have a look on the web. I
googled for things like "DVB-T Transmitter MythTV Tacolneston" and the
like and found a gentleman called Adam Bower had already done the work
for me. Thanks, Adam.

What is channels.conf ?
-----------------------

Having acquired your transmitter information (in my case, in the file
uk-Tacolneston) you now query your local transmitter to see what
channels it has to offer. These contain things like channel details and
the tuning frequencies and go in a file commonly called "channels.conf".
Once you have this, it should be easy to get your system watching
television using mplayer.

Generating the channels.conf
----------------------------

You may be able to find a channels.conf for your transmitter already. If
you can't, to create our channels.conf we use a program called 'scan'
(part of the linux-dvb-apps we installed earlier)

    scan uk-Tacolneston > channels.conf

This should print out reams of gobbledegook, hopefully without error
messages. If there are error messages, check your signal strength (do
you need a better aerial ?) and your frequencies, which may be wrong.

If you open channels.conf in an editor it should look something like
this (lines truncated slightly here !)

    Five:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2 (etc)
    Five Life:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC (etc)
    Five US:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1 (etc)

except there will be more of it (one line for each channel). The first
things on each line should be recognisable as the channels available on
your local service. The names are often truncated.

Getting the first picture
=========================

This is no longer required for DVB Setup, but as before, it's useful for
solving problems, because if MythTV doesn't work and this does, you know
it's the setup of MythTV that's the problem

This part is again only applicable to DVB-T transmissions. The next part
is to check the card is working by - watching some television. It is no
longer required for DVB-T if you are using the DVB-T EPG, but I have
left it in, as it is useful if you can't get your card working, or if
you want it to run with mplayer or xine.

Install and run Mplayer
-----------------------

My preferred viewer is mplayer (though you can do this with xine as well
- the process is identical, where I say mplayer you put xine !). To view
the television in mplayer, firstly install it once and run it.

    pacman -S mplayer
    mplayer

It is run once to create the .mplayer subdirectory in your home
directory, which you will copy your channels.conf file into next.

Making Mplayer work with DVB-T
------------------------------

To make mplayer work with DVB you have to tell it about the channels it
can read. The simplest way of doing this is to copy the channels.conf
file into your .mplayer directory

    cp /aux/arch/channels.conf /home/paulr/.mplayer/

(Your command may vary depending on your login name and the directory
you put the channels.conf file)

You should now be able to watch TV. Look at one of the channels in your
channels.conf file. I shall choose the TV channel BBC1. The line from
channels.conf looks like this.

    BBC ONE:810000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4 (etc).

to watch BBC1, you use the name of the channel - the line as far as the
first colon. In this case

    mplayer dvb://"BBC ONE"

Replace BBC ONE with the channel you wish to watch. With a bit of luck,
if everything has worked, that should open a window and start playing
the channel in glorious LinuxColour ; in this case , BBC1.

If not ... search the internet checking error messages :) If the
previous stage worked (getting the uk-xxxxx and channels.conf) it's a
bit puzzling that it doesn't work.

If you've got this far you can be pretty sure you will get MythTV to
work properly - eventually. There's a bit more setting up to be done
yet. It is not that difficult to get MythTV working, recording, display
video, and so on. The hard bit - in my experience anyway - is getting
the EPG working.

But it *is* worth it. MythTV watching is a whole new way of looking at
television ; it's a whole new way of thinking about television. Without
DRM.

"I think this is getting needlessly messianic." (Fook, Hitch Hikers
Guide to the Galaxy)

Installing XMLTV
================

This is no longer required for DVB Setup as the TV guide data is
piggybacked onto the TV signal

Installing XMLTV
----------------

Read the XMLTV HOWTO for instructions on how to Install XMLTV. This used
to be part of this document, I put it in it's own Wiki page.

You can have it all, but you do not want to
-------------------------------------------

If you let it run through to the very very end it will take a long time.
Normally you do not want to do this ; you want just the channels that
there are on your system. On the tv_grab_uk_rt listings there are 271
channels, but DVB-T Freeview only has about 50 odd.

We will cut this down later and make the tv grabber run faster.

Installing MythTV
=================

Installing MySQL
----------------

To start with, we install MySQL, the open source database. This is used
to store information for mythtv. These three lines install it, start it
running, and set the password to 'root' (change as you wish). You will
need to use 'su -' to get into superuser mode first.

    su -
    pacman -S mysql
    /etc/rc.d/mysqld start
    mysqladmin -u root password root

You should also edit your /etc/rc.conf file to start it up
automatically, by adding mysqld to the list of daemons. The daemons line
should now look something like (exact contents may vary)

    DAEMONS=(syslog-ng network netfs crond gdm cupsd hal alsa openntpd mysqld)

To check it works okay, enter

    mysql -u root -p

and when it asks you for the password, type in whatever you set the
password to above (in this case, root). It should start up the command
line interface to MySQL. To exit, type Ctrl+D.

Installing MythTV
-----------------

Installing MythTV is easy. This command will install the MythTv program
and the themes that go with it.

    pacman -S mythtv myththemes

Creating the Database
---------------------

Finally, we need to initialise the SQL Database that MythTV uses. There
is a script to do this.

    mysql -u root -p < /usr/share/mythtv/mc.sql

Again, you will need to enter the root password.

Setting up MythTV
=================

Press Ctrl+D to leave superuser mode. Type the following command to set
up mythtv.

    mythtv-setup

Select your preferred language
------------------------------

Select the preferred language (in my case, English(British)) and press
Return to go to the next screen.

Section 1. General
------------------

-   "host specific backend setup" : allows you to use a specified
    directory to store your recordings.
-   "Global Backend setup" : I had to set the TV format to "PAL" and the
    Channel Frequency Table to "Europe-West" ; these may vary depending
    upon which country you are in.

For all the other pages, you can simply leave the defaults as they are.
You can always change them later.

Section 2. Capture Cards
------------------------

This is where you specify your capture card. Select "New Capture Card"
and change the type to whatever your card type is. For my WinTV NOVA, it
is "DVB DTV Capture Card (v3.x)".

Mythtv should hopefully identify what your capture card is. Select
Finish to store the new capture card, and then press ESC to return to
the setup menu.

Section 3. Video Sources
------------------------

Select "New Video Source" and enter a name (like DVB Card, for example).

Then change the entry "XMLTV Listings Grabber" until it matches the name
of the grabber you set up in the XMLTV section, or if you are using
DVB-T "Direct" set it to "Transmitted Guide Only (EIT)". This tells
MythTV to use the TV data encoded in the DVB-T stream.

If you are using XMLTV, it will now configure this in the background.
Again, we can skip this configuration for the time being. When you click
on finish, the bar goes to 50% and stops. You will need to Alt-TAB to
find the terminal window again. As before, you can select "all", because
we will fix it all properly later.

Then press ESC to return to the main menu.

Section 4. Input Connections
----------------------------

Select the Video Source you just created, and bring up the 'Connect
Source to Input' Dialog.

Give it an appropriate name ; in the UK it is known as "Freeview". For
the Video Source, select the Capture Card

For DVB-T cards like mine, run the Scanner (Full) option. If it crashes
- mine keels over sometimes, sometimes it works, there appears to be no
pattern, then try again two or three times, and eventually it will scan
to the end.

If this doesn't work, try the "taskset" trick and the end of the
document.

If you get really stuck, tab down to and select "Scan for Channels",
then TAB to "Scan Type" and switch this to "channels.conf". We are going
to use the channels.conf we created earlier to configure mythtv. When
you click on "finish" for this, it will display "Adding ....." for all
the channels you found before.

If you do not have a DVB card, but use something like an analogue card,
you may need to scan for channels and label them yourself.

Click on Finish twice, then ESC to return to the main setup menu.

Section 5. Channel Editor
-------------------------

You can look at this, but we are going to configure it in a minute.

First run of MythTV
-------------------

Start up the Myth BackEnd (this is the bit that does all the recording
and so on) as follows.

    su -
    /etc/rc.d/mythbackend start
    (Press Ctrl+D)

When it's working you can put mythbackend in your DAEMONS line as we did
for MySQL above. You may get an authentication error, which I think is
something to do with QT, which I believe can be ignored. Now run the
front end by typing

    mythfrontend

If you go to "Watch TV" you can (errmmm....) Watch TV, you can change
channel with your up and down keys, and it all works quite nicely.

You can also simply run

    mythtv

This is just a "TV Watching" application with no other facilities.

It might not be working.
------------------------

If you are using XMLTV, it's only about half there. The TV playing now
works fine. What doesn't exist is the EPG - it doesn't tell you what is
on the channel, and if you look at the EPG in the Recording section
there's no data. What we have to do now is to make the XMLTV Data work
with MythTV.

If you are using the Transmitted Guide (EIT) option then if you watch TV
for a little while, it seems to fill up the EPG in the background.

Linking XMLTV and MythTV
========================

This is no longer required for DVB Setup - in fact it'll completely
screw up the system if you are using the transmitted guide

The shotgun wedding
-------------------

There is a problem to fix. We have to get the XMLTV data and the MythTV
working together.

If you look at the channels.conf file, which says what channels are on
MythTV, it looks like this :

    Five:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2 (etc)
    Five Life:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC (etc)
    Five US:730166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1 (etc)

If you look at the XMLTV file DVB Card.xmltv it looks like this :

    channel channel5.co.uk
    channel life.channel5.co.uk
    channel us.channel5.co.uk

The problem is getting the two to work together. We have to tell MythTV
that the channel5.co.uk matches up to the channel called "Five", the
life.channel5.co.uk matches up to the channel called "Five Life" and so
on.

This is one of those quite difficult computing problem. To a human
brain, it is pretty obvious. To a computer, that sort of pattern
matching is really quite difficult.

What you are trying to do, technically
--------------------------------------

run the following

    mysql -u root -p 
    (then enter the password)
    (then enter these commands into the MySQL client)
    use mythconverg;
    select name,xmltvid from channel;

this will query the MythTV database and show the names of the channels,
and the name of the associate xmltv channel. It will now look like :

    +----------------+---------+
    | name           | xmltvid |
    +----------------+---------+
    | Five           |         | 
    | Five Life      |         | 
    | Five US        |         | 

but with many more channels. We need to get the channel data from the
above table in there, so that for the name row the xmltvid value is
channel5.co.uk. That way MythTV knows where to look. There are also
columns which allow you to set the icons, which at present I am not
doing.

Using MythTV
------------

You can do this using the Channel Editor section of MythTV. This is not
difficult, but very slow and boring.

Using XMLTVDruid
----------------

In AUR there is a program called XMLTV Druid which provides a better GUI
for doing this. I haven't tried it. I'm not even sure if it does this
'marriage' of XMLTV and MythTV.

Doing it by MySQL Script or similar
-----------------------------------

My method of doing it involves using a text file containing the channel
name and the xmltv channels together, which when run creates two files ;
an SQL file which sets up the data in the MythTV database, thus doing
the "shotgun marriage", and also creates a replacement "DVB Card.xmltv"
which doesn't require *all* the channels to be checked, only the ones we
are actually using.

That's why I suggested not bothering with selecting the channels in use
earlier ; we are going to replace them now.

This is my control file, the name of the file should be mythtv.config.
On the left hand side is the name of the channel from channels.conf ; on
the right hand side is the channel source from XMLTV.

    #
    # XMLTV Matchup Source File
    #
    Five:channel5.co.uk
    Five Life:life.channel5.co.uk
    Five US:us.channel5.co.uk
    QVC:qvcuk.com
    abc1:abc1.disney.com
    bid tv:bid-up.tv
    TCM:sky-three.sky.com
    UKTV Style:uk-style.flextech.telewest.co.uk
    UKTV Gold:uk-style.flextech.telewest.co.uk
    price-drop tv:price-drop.tv
    Eurosport UK:british.eurosport.com
    BBC ONE:east.bbc1.bbc.co.uk
    BBC NEWS 24:news-24.bbc.co.uk
    CBBC Channel:cbbc.bbc.co.uk
    BBC TWO:east.bbc2.bbc.co.uk
    ITV1:anglia.tv.co.uk
    ITV2:itv2.itv.co.uk
    ITV3:itv3.itv.co.uk
    CITV:citv.itv.co.uk
    Channel 4:channel4.com
    E4:e4.channel4.com
    More 4:more4.channel4.com
    Film4+1:plus-1.filmfour.channel4.com
    ITV4:itv4.itv.co.uk
    BBC Parliament:parliament.bbc.co.uk
    CBeebies:cbeebies.bbc.co.uk
    E4+1:plus-1.e4.channel4.com
    UKTV History:ukhistory.tv
    SKY THREE:sky-three.sky.com
    Sky Spts News:news.sports.sky.com
    Sky News:sky-news.sky.com
    Ideal World:idealworld.tv
    f tn:ftn.tv
    Film4:filmfour.channel4.com

The only changes a UK user will need to make are to BBC1, BBC2 and
ITV1 ; in this file they are set up for the eastern region (BBC East and
Anglia Television) ; in different parts of the country different sources
are required.

This is the perl script that takes that file and generates an SQL file
match.sql and also outputs a replacement DVB Card.xmltv file.

    open(my $src,"<mythtv.config") or die($!);
    open(my $sql,">match.sql") or die($!);
    print $sql "USE mythconverg;\n";
    while (readline($src))
    {
    if (/(.*):(.*)/)
      {
      my $mch  = trim($1);
      my $mxm = trim($2);
      print "channel $mxm\n";
      print $sql "UPDATE channel SET xmltvid='$mxm' WHERE name='$mch';\n";
      }
    }
    close($src);
    close($sql);

    # Perl trim function to remove whitespace from the start and end of the string
    sub trim($)
    {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
    }

Save this file as match.pl, then run the command :

    perl match.pl >DVB.xmltv

Then you have to copy the new DVB file into the correct place. The name
of the file you copy it to will depend on what you names you used in
mythtv-setup, but it will be in /home/(user)/.mythtv and end in
".xmltv".

    cp DVB.xmltv /home/paulr/.mythtv/DVB\ Card.xmltv

Then you have to run the SQL script to insert the data into the SQL
Database.

    mysql -u root -p <match.sql

Checking that it's worked
-------------------------

The simplest check is to repeat the query on the MythTV database ; if it
has worked then many, but probably not all, of your IDs should be
matched up.

    mysql -u root -p 
    (then enter the password)
    (then enter these commands into the MySQL client)
    use mythconverg;
    select name,xmltvid from channel;

should now look like :

    mysql> select name,xmltvid from channel;
    +----------------+----------------------------------+
    | name           | xmltvid                          |
    +----------------+----------------------------------+
    | Five           | channel5.co.uk                   | 
    | Five Life      | life.channel5.co.uk              | 
    | Five US        | us.channel5.co.uk                | 
    | QVC            | qvcuk.com                        | 
    | abc1           | abc1.disney.com                  | 

there will be some gaps, as a guide is not available for every channel.

Running mythfilldatabase
------------------------

All you now have to do is to get mythtv to fill the database. It will
run the xmltv command, read in the data, and use it to populate the EPG.
Fortunately there is a command to do this for you.

This can take some time. Some channels may fail because of the
'screenscraping' of the

    mythfilldatabase

Now go and play
---------------

Now, when you run mythfrontend, it should display the program
information and the EPG should be completed in the recording section for
those channels you put in your mythtv.config files.

For me it's about a third of the 90 or so, but this is most of the main
channels. There are channels which are Teletext, channels which are
Radio, and channels which are Pr0n, so they're no great loss.

Extras
======

The Font sizes and the Theme
----------------------------

On my MythTV, on a 1280x1024 display, the Fonts are large and make the
EPG look terrible. By going in through Utilities/Setup > Setup >
Appearance you can change the look to something better, and also change
the theme.

I quite like

-   Fonts = small
-   Theme = mythcenter

but this is purely a matter of personal taste.

Setting up the Icons
--------------------

I have seen some installations that require you to manually install the
icons into the database for each channel. However, the tv_grab_uk_rt
grabber seems to download and install them automagically.

Segmentation Fault
------------------

For some as yet unknown reason, mythtvfrontend throws a Segfault when
you exit it. This is a known bug and doesn't affect its operation at all
at any other time.

Using the remote control
------------------------

To be done.

MythTV-Setup Crashing
=====================

How to fix it
-------------

I had a *lot* of problems with mythtv-setup crashing continually. A bit
of searching revealed the solution. It appears to be related to real
multitasking vs. simulated multitasking ; it's only a problem for people
with multiple CPU cores. Running mythtv-setup as a 'one core only' app
appears to work.

You need to download schedutils from the AUR, and build it as a package,
then install it. This provides you with the "taskset" program.

Then you can run it by typing

    taskset -c 0 mythtv-setup

and it should ... hopefully ... work. I understand this is a known bug
connected with QT reentrancy and is being fixed in MythTV 0.21

Retrieved from
"https://wiki.archlinux.org/index.php?title=MythTV_Walkthrough&oldid=197901"

Category:

-   Audio/Video

-   This page was last modified on 23 April 2012, at 16:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
