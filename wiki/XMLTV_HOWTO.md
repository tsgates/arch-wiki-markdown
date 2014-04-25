XMLTV HOWTO
===========

Contents
--------

-   1 What does XMLTV actually *do* ?
-   2 Why XMLTV is so problematic?
-   3 What about the DVB-T EPG ?
-   4 Compilation
    -   4.1 Make a package
    -   4.2 Compile by hand
-   5 Configuring XMLTV
-   6 Checking XMLTV actually works

What does XMLTV actually *do* ?
-------------------------------

Any good PVR system needs to know when to record. Systems like VideoPlus
in the UK, where numbers encode start and stop times, have made
programming easier, but it's much easier to just look at an EPG and
click on the programme you want to record.

However, there is no central system for acquiring TV programme data, at
present, so that's where XMLTV comes in. XMLTV's job is to take program
data off the internet and convert it to a standard format for PVRs like
MythTV and FreeVO.

Why XMLTV is so problematic?
----------------------------

The problem with XMLTV is it is grabbing data from places that weren't
really designed to supply it. It kind of "screen scrapes" - it looks at
a web page containing TV information like this and tries to rip the text
off it and convert it into an easy to use format. Things can go wrong
with this ; if the website decides it's going to reformat its text, then
it will cease to work properly or indeed at all.

What about the DVB-T EPG ?
--------------------------

DVB-T, aka Freeview here, has programme guide information embedded in
it ; any UK Freeview set top box has an EPG. It seems to be problematic
getting this to work in MythTV, as it is currently "in development".
When it does work, this will make it much easier as XMLTV can be
abandoned, for DVB-T anyway (still needed for analogue, which is sound
and video only)

One downside of the DVB-T EPG is that it only goes 7 days into the
future, whereas XMLTV does 14 days. This is useful if you want to record
when you are on holiday.

Compilation
-----------

If your grabber isn't available in the package in community, you have to
try and compile xmltv yourself. You can choose between two ways of
obtaining a self compiled xmltv installation. You can use ABS and edit
the PKGBUILD to make a package or compile it by hand.

> Make a package

Refer to the wiki page about the Arch Build System (ABS) on how to use
it. Copy the directory xmltv to your build directory. Now you have to
check, why your grabber isn't available. Extract the source and run
Makefile.PL:

    makepkg -e
    cd src/"PKGNAME"
    perl Makefile.PL

You will be prompted for every grabber. The script will tell you, which
grabber isn't supported and why. You will have to install additional
dependencies then. For the grabber "tv_grab_eu_epgdata" for example you
will have to install perl-datetime-format-strptime from AUR. Add these
dependencies in the PKGBUILD and run makepkg.

> Compile by hand

You first need to obtain the current version of XMLTV ; this can be
downloaded from Sourceforge http://sourceforge.net/projects/xmltv ; the
current version as I write is 0.5.45

After having downloaded it, create a working directory somewhere and
untar the source into it.

    cd /aux/arch/mythtv
    tar xjvf /home/paulr/Desktop/xmltv-0.5.45.tar.bz2 
    cd xmltv-0.5.45

this will create a directory xmltv-0.5.45 in the saved directory with
the source code in it, then change to it. Now, we're going to install
some basic dependencies. In spite of the long list, there's not actually
very much code downloaded here.

    su
    pacman -S perl-archive-zip perl-date-manip perl-html-tableextract perl-http-cache-transparent perl-io-stringy perl-term-progressbar perl-unicode-string perl-www-mechanize perl-xml-twig perl-xml-writer libxml2 perl-xml-libxml
    (Ctrl+D)

and next, we will attempt to compile the program

    perl Makefile.PL

This should produce a listing that looks like this.

    XMLTV.pm library and the filter programs such as tv_grep and tv_sort
    are installed by default; here you choose grabbers for different
    countries and front-ends for managing listings.
    Grabber for Brazil (tv_grab_br)                                    [yes]
    Grabber for Brazil NET Cable (tv_grab_br_net)                      [yes]
    Grabber for Switzerland (tv_grab_ch_bluewin)                       [yes]
    Alternative grabber for Britain (tv_grab_uk_rt)                    [yes]
    Fast alternative grabber for the UK (tv_grab_uk_bleb)              [yes]

.... and so on. Find your country in the list and hopefully it will be
marked "yes". If not, try installing perl-tk-tablematrix using Pacman,
break with Ctrl+C and run the perl command above again. If it still
doesn't work, try installing perl-soap-lite from AUR. If you need the
grabber for "epgdata.com" (tv_grab_eu_epgdata), you will have to install
perl-datetime-format-strptime.

Fortunately for me, it has found the tv_grab_uk_rt grabber for the UK
that I am going to use. Make a note of its name, because I will refer to
mine (tv_grab_uk_rt) throughout ; whereas you may need, for example,
tv_grab_br

It now asks "Do you want to continue with this configuration ?" ; you
actually do not need all those grabbers, but what the heck, just press
RETURN for yes.

Now compile and install the program with

    make
    su (then enter your password)
    make install
    (Press Ctrl+D to get back to non superuser mode)

Configuring XMLTV
-----------------

Next we need to configure XMLTV. To do this run

    tv_grab_uk_rt --configure

Now, for this grabber, you can individually select whether or not you
want each channel. To select every channel (it's quicker to edit the
configuration file in a text editor), type:

    all

And it will configure itself to download every single channel it can.

Checking XMLTV actually works
-----------------------------

To check it, simply run it.

    tv_grab_uk_rt

If all is well, it should churn out reams and reams of channel programme
data. It should look like this

    <programme start="20070330035500 +0100" stop="20070330042000 +0100" channel="abc1.disney.com">
       <title>8 Simple Rules for Dating My Teenage Daughter</title>
       <sub-title>Rory's Got a Girlfriend</sub-title>
       <desc lang="en">Sitcom in which a father has his hands full when his wife returns to work and he is left to supervise their teenage daughters. Paul has to face the fact that his son wants to start dating girls, and Kerry envies her sister.</desc>
       <credits>
         <actor>John Ritter</actor>
         <actor>Katey Sagal</actor>

except there'll be pages of it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XMLTV_HOWTO&oldid=258180"

Category:

-   Audio/Video

-   This page was last modified on 22 May 2013, at 00:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
