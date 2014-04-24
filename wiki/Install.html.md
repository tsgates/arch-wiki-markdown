Perl Background Rotation/Install
================================

  

This document describes how to get a basic configuration running.
Configuration of extensions, and troubleshooting is covered in other
documents.

1.  Introduction : What this does
2.  Installation : Getting the basics handled.
3.  Using Extensions : Optional feature setup.
4.  Script Extras : Related Software
5.  Tips and Tricks : Fun for the whole family!
6.  Hacking : How to create your own extensions
7.  Code : Code walkthrough and some design notes
8.  FAQ : Frequently Asked Questions
9.  Screenshot Gallery : If you use these scripts, show off!
10. Resources : A comprehensive wallpaper list.

Downloading
-----------

Grab the current tarball or older versions

Individual files can be browsed via googlecode's subversion interface

Installing
----------

First of all, you need to make sure you have perl and imagemagick
installed.

    pacman -S imagemagick

or if your on a debian box (I have several)

    apt-get install imagemagick

This script includes a number of perl modules (embedded). If you want to
use more recent versions of these modules, see the Code Walkthrough for
information on getting a non-embedded version of this script running.

> Where to place the files

In the tarball, there are several included files. You should place them
in the following locations.

-   wallie should be placed somewhere in your path. /usr/local/bin or
    your personal ~/bin directory (if it exists) work great.
-   extras/screenshot and extras/schemer should also be placed somewhere
    in your path.
-   If you plan on using the urxvt extension, place urxvt-theme and in
    your bin folder or in /usr/lib/urxvt/perl/.
-   Now copy wallrc into your home home directory as .wallrc
-   Two images are supplied in the tarball

1.  1.  blank.png
    2.  backtile.jpg. These should both be copied into to root of your
        background directory (defaults to ~/.backgrounds/). blank.png is
        a 1x1 transparent pixel which is read, stretched and otherwise
        mangled during the compositing process. backtile.png is a tiled
        image which is repeated across the conky and panel areas in
        order to give some texture. If you have a better tile, use it
        (and email it to me!)

> the .wallrc config file

The configuration file should be mostly self-explanatory. But here are
some things to be aware of.

-   The configuration file is basically a set of perl hash declarations.
    It is therefore VERY sensitive to weird punctuation. If you find you
    settings aren't taking hold, or the script is failing to load, make
    sure you don't have any mis-placed quotes and you are not missing
    any trailing semicolons.
-   Where you are given an option to fill in a pathname, you can use any
    variable perl normally has access to. For example, your home
    directory can be represented by $ENV{'HOME'}. If you find yourself
    repeating values, you can define your own (in perl format) and
    substitute them.
-   When a value is a number, you can surround it in quotes or not (you
    choice). All strings MUST be surrounded by double quotes.
-   Be sure to enable at least one display. For most people, this means
    changing $display->{'0.0'}{'enable' } = 0; to
    $display->{'0.0'}{'enable' }           = 1;

Testing and Running
-------------------

To begin with, I suggest setting debug to a value of 2 in your
configuration file. When your ready, simply type "wallie" to start the
wallpaper daemon. The daemon will check your configuration and make sure
your settings are mostly sane and fork itself.

At this point, I suggest opening another xterm and typing

    tail -f ~/.wall.log

which will "watch" the wallie log file. Once you have tested for a
working configuration, set debug back to 0 and this file wont be created
unless there is a catastrophic error of some kind.

Now, type

    wallie --help

If the daemon is correctly running, it will respond with an index of
commands you can give it. Example output:

    Possible options are:
     status, toggle, schemedata, scheme, next, photo, photodir, current, 
     version, or die:

To tell it to render the next set of images, execute

    wallie --next

In a few minutes you should have a new wallpaper.

If you want to test a particular photo, try

    wallie --photo:0.0:/full/path/to/image.png

where 0.0 is your X display you have defined in .wallrc. Then execute

    wallie --next

to render it.

> starting the daemon automatically

You should probably add wallie to your .xinitrc or some other startup
process. You need not worry about starting multiple copies, as the
daemon will not start itself twice.

> cron / fcron setup

Once you have things running how you like - you may want to setup a cron
job in order to automate things. Note that setting up a cron job is
entirely optional. If you prefer, you can run things manually, or via
some hotkey in you r window manager.

To setup a cron job:

    crontab -e

    */20 * * * wallie --next

If your using fcron (which I highly encourage), you can tweak a bit
more.

    fcrontab -e

    @lavg5(0.6),nice(10) 20 wallie --next

This will only run the command if the 5 minute system load average is
low, and when it is run, it will run at a lower priority that it would
normally. Swapping out wallpapers and rendering the new background can
really hit slower cpus hard - so nice is especially important on these
machines in order to set a cpu usage value. I've spent a lot of time
tweaking the script so it does not use massive amounts of memory and
cpu, but you need to realize that if you make use of any of the optional
image manipulation features, every 20 minutes your machine is going to
basically perform several photo rendering operations. On ANY cpu that
can create a bit of a load.

On an Athlon XP 2800, the render process (niced at 10), takes about five
seconds to complete (every possible option enabled, for three monitors).
It seems to eat anywhere from 5 to 15 megs of ram to read all the images
- do it's thing, and finish. It may act differently on slower systems.
Let me know.

> Window Manager setup

A couple of times a day, this script will generate a desktop so
mind-blowingly awesome, I don't want it to go away :) If you find
yourself in a similar conundrum, you can .... with a flick of the key
.... shut down the wallpaper randomization process. Once this "lock" has
been placed, no more backgrounds will be generated even with your cron
daemon ceaselessly hammering upon it.

In Openbox, I setup a keybinding to do this by editing
~/.config/openbox/rc.xml

  

    <keybind key="XF86HomePage">
      <action name="execute"><execute>wallie --toggle</execute></action>
    </keybind>

This binds the "homepage" button on my logitech keyboard to lock the
randomization process. Executing wallie --toggle again manually (or by
hitting the home button) releases this lock. Note that all this does is
call wallie --toggle.

Another button I bind is the browser button, which I use as a sort of
"change the wallpaper NOW dangit!" button.

    <keybind key="XF86WWW">
      <action name="execute"><execute>wallie --next</execute></action>
    </keybind>

All this does is run the script right away. If your crazy, you could
give this process a negative nice number with the help of sudo, and give
your cpu a heart-attack. :)

Setting up keybinding in your own window manager of choice should be
easier, but the above I think demonstrates a worst-case
"really-hard-to-configure" scenario. :)

Prev: Introduction | Next: Using Extensions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Perl_Background_Rotation/Install&oldid=197796"

Category:

-   Perl Background Rotation

-   This page was last modified on 23 April 2012, at 16:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
