Boxee-source
============

This is the official wiki for the boxee-source aur package; it should
contain reasonably up to date information on its status and on
workarounds to get things running in specific environments. Please feel
free to add useful information in this regard to this page, and if you
do, remember to credit yourself in the contributors section below.

Contents
--------

-   1 About boxee-source
-   2 Repository
-   3 Staff
    -   3.1 Active Project Maintainers
    -   3.2 Former Maintainers
    -   3.3 Contributors/External Help
-   4 Workarounds
    -   4.1 Issues Compiling
        -   4.1.1 NVIDIA (binary)
    -   4.2 Issues Running
        -   4.2.1 ATI
-   5 Quick Start Guide
-   6 Boxee Beta
-   7 Known Issues
    -   7.1 64bit flash support (hulu/monty python etc)
-   8 IRC
-   9 Debugging
-   10 LIRC Remote Controls

About boxee-source
------------------

The Boxee media center @ http://www.boxee.tv/ is mostly open source -
and a very featureful media center on Linux. Unfortunately, the
sourcecode does not compile properly against archlinux or 64bit, and
even worse, there is no functioning 'make install' to easily seperate
the unused chunks of xbmc and sourcecode from the actual package. To
remedy this, a small group of us have been working hard to maintain our
own patchset and installation script (built against the official ubuntu
releases' file structure) that allows the latest boxee to compile in
archlinux on both 32 and 64bit.

Repository
----------

If you want to skip compiling from source, you can add this repo :

     [studioidefix]
     Server = http://studioidefix.googlecode.com/hg/repo/x86_64
     

or for 32bit users :

     [studioidefix]
     Server = http://studioidefix.googlecode.com/hg/repo/i686
     

Staff
-----

> Active Project Maintainers

-   Prurigro (prurigro at gmail dot com) - Contributor/Maintainer,
    Patches, PKGBUILD & 32bit Testing
-   Anish (anish.7 at gmail dot com) - Patches, PKGBUILD & 32bit Testing

> Former Maintainers

-   Paulingham (paul.ingham at beefeatingmonkeys dot com) - 64bit
    Patches, 64bit PKGBUILD & 64bit Testing

> Contributors/External Help

-   sdnick484
-   jaydonoghue
-   jpf
-   vrtladept
-   adamruss

Workarounds
-----------

> Issues Compiling

NVIDIA (binary)

If you are using the nvidia binary driver, then compiling boxee-source
will give you the following error: "configure: error: cannot compute
sizeof (size_t)". To get around this error, you must compile the package
as root:

-   'makepkg' -> 'sudo makepkg --asroot'
-   'yaourt' -> 'sudo yaourt -S boxee-source'

As of pacman 3.3, this should no longer be required

> Issues Running

ATI

An up to date xorg/ati installation reportedly breaks boxee, and the
only known fix right now is to downgrade libgl and ati-dri to 7.4.4.

For those using up to date ATI Catalyst drivers and having video
playback issues, changing the render method in your
.boxee/UserData/guisetting.xml file may help.

    In the <videoplayer> section, change the value of <rendermethod> to 1 or 2.

Quick Start Guide
-----------------

This assumes i686 architecture. If you are using 64bit, I cannot help
you.

1. install yaourt, it's much easier. Follow the guide HERE:
https://wiki.archlinux.org/index.php/Yaourt

2. yaourt -S boxee-source OR if you have nvidia binary it MUST be sudo
yaourt -S boxee-source. Maybe it'll even install all the dependencies
for you! That'd be nice, wouldn't it?

3. To save you what may have been hours looking in vain for the command
to start the fracking program, it is

/opt/boxee/run-boxee-desktop

4. Also, if you receive errors related to the following files, you can
fix it with symbolic links, whatever they might be:

sudo ln -s /usr/lib/libgssapi.so.2 /usr/lib/libgssapi_krb5.so.2

and

sudo ln -s /usr/lib/libnspr4.so /usr/lib/libnspr4.so.0d

5. If you get a segmentation fault, uh...

You could try removing the libgl driver? I replaced mine with nvidia and
didn't get this error anymore. But possibly the error was unrelated to
libgl. Maybe I wrote a crappy xorg. Or something.

6. Consult the boxee source page on the AUR if you have further
problems. Maybe you need to download some extra libraries or something?
Who knows?

7. Please, someone, make this guide better!

Boxee Beta
----------

The current AUR files provide a 100% working beta for 32 & 64 bit
machines, although the PKGBUILD may need to be modified to add 'x86_64'
to the arch variable.

There are a couple of issues with updating the PKGBUILD to beta as of
now

1. There is no source release, only a .deb is available.

2. This one's the showstopper, downloads need a signin and a unique
download url give out to those who signed up for early access (as of
25th Dec 2009).

3. There are some dependency issues with libtiff

WIP to get it running on Arch. There's a 64 bit version available as
well, so it might work just as well on 64bit too.

Known Issues
------------

> 64bit flash support (hulu/monty python etc)

The flash player provided with boxee is released only in binary format.
After a great deal of work and waiting, boxee-source finally supports
flash content in 32bit, however; to support 64bit we need to wait for
the boxee team to release 64bit binaries, and sadly there has not been
much talk in this direction.

However, it is possible to install a 32-bit chroot Arch environment as
per the Arch64_FAQ, make sure to enter the environment you set up using
linux32 chroot /opt/arch32, and install the appropriate binaries (xorg,
nvidia drivers if necessary, yaourt, and Firefox and flash for Hulu)
build a 32-bit Boxee-source in the chroot, and run from the 64-bit
command line using schroot -p -- /opt/boxee/run-boxee-desktop. Seems to
work great on my amd64 box. I've successfully watched video content in
32-bit Boxee using this method.

If anyone can figure out how to get lirc working with this setup, that
would be wonderful.

IRC
---

A small warning to all that the room is empty more often than not, but
when its not you can find us @ #boxee-source on irc.freenode.net

Debugging
---------

Basic boxee debugging can be done by editing or creating
~/.boxee/UserData/advancedsettings.xml

to include the following code:

    <advancedsettings>
    <loglevel>0</loglevel>
    </advancedsettings>
     

after starting boxee, your log will be located at

Linux: /tmp/<username>-boxee.log

Please be kind and use pastebin.com/pastie.org for the debug log, do not
paste it in the comments.

LIRC Remote Controls
--------------------

As described in this Boxee Forum Post, it is possible to get LIRC remote
controls working in Boxee. You simply need to create a
~/.boxee/UserData/Lircmap.xml file. This translates LIRC button presses
to XBMC key-presses. The syntax is described in more detail on the XBMC
Wiki.

Here is an example for a Medion X10 RF remote:

    <!-- This file contains the mapping of LIRC keys to XBMC keys used in Keymap.xml  -->

    <lircmap>
    	<remote device="Medion_X10">
    		<pause>pause</pause>
    		<stop>stop</stop>
    		<forward>seek_forward</forward>
    		<reverse>seek_backward</reverse>
    		<left>cursor_left</left>
    		<right>cursor_right</right>
    		<up>cursor_up</up>
    		<down>cursor_down</down>
    		<select>ok</select>
    		<pageplus>channel_up</pageplus>
    		<pageminus>channel_down</pageminus>
    		<back>back</back>
    		<menu>table</menu>
    		<title>play</title>
    		<info>info</info>
    		<skipplus>track_next</skipplus>
    		<skipminus>track_previous</skipminus>
    		<display>text</display>
    		<start>start</start>
    		<record>record</record>
    		<volumeplus>volume_up</volumeplus>
    		<volumeminus>volume_down</volumeminus>
    		<mute>mute</mute>
    		<myvideo>red</myvideo>
    		<mymusic>yellow</mymusic>
    		<mypictures>green</mypictures>
    		<mytv>blue</mytv>
    		<one>1</one>
    		<two>2</two>
    		<three>3</three>
    		<four>4</four>
    		<five>5</five>
    		<six>6</six>
    		<seven>7</seven>
    		<eight>8</eight>
    		<nine>9</nine>
    		<zero>0</zero>
    	</remote>
    </lircmap>

Retrieved from
"https://wiki.archlinux.org/index.php?title=Boxee-source&oldid=266497"

Category:

-   Audio/Video

-   This page was last modified on 16 July 2013, at 09:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
