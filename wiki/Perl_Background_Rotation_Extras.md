Perl Background Rotation/Extras
===============================

  

These are some other sort-of related tools. If you come up with
something that makes use of the main wallpaper script, please add it
below.

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

Nautilus Integration
--------------------

I find myself surfing through my wallpaper collection with nautilus on
ocassion. It's nice to be able to rightclick on an image that has struck
my fancy and make it my desktop through nautilus's rightclick action. I
created a very simple script which you can place in
~/.gnome2/nautilus-scripts/. After you've done this, you should be able
to rightclick on any image, move down to "Scripts" and select "Queue
Desktop 0.0".

If you wish to enqueue photos for another display, Symlink "Queue
Desktop 0.0" to "Queue Desktop 0.1". The script will determine the
display to enqueue to based on the script filename.

If you wish to simply pick a random image from a directory, right
clicking on a directory in nautilus works great too.

Note: The default action of this script is only to set the next
wallpaper name to render. If you want to chose a photo and render it in
one swoop, you should be able to easily modify the supplied script to do
so by adding "; wallie --next" to the end of the system command(s) in
the script.

Screenshot Grabber
------------------

screenshot is a script that was originally based upon the info.pl
screenshot grabber which evolved on the bbs. I eventually ripped out
parts I had no use for, and added functions specific to my desktop. It
may or may not work with your system, and will probably require you to
edit parts of it to get it working as expected. However, it does take
advantage of the settings provided by the wallpaper script. It doesn't
hurt to take a look at it anyway.

Getting color theme info
------------------------

If you plan on writing your own project and need to grab the current
color palate, there are two interfaces you can use. The first is easier,
but not as "correct". :)

Of course, it may make more sense to simply write and extension too.

    wallie --schemedata:0.0
    SCHEME:877c80:5e5759:fffafc:fff5f8:877f7c:5e5957:fffbfa:fff7f5:877c86:5e575e:fffaff:fff5fe:7e877c:585e57:fbfffa:f6fff5

You can also run:

     wallie --scheme:0.0
     Basic Colors
    	Base      : 877c80
    	Dark      : 5e5759
    	Pale      : fffafc
    	Less Pale : fff5f8
     Cool Colors
    	Base      : 877f7c
    	Dark      : 5e5957
    	Pale      : fffbfa
    	Less Pale : fff7f5
     Warm Colors
    	Base      : 877c86
    	Dark      : 5e575e
    	Pale      : fffaff
    	Less Pale : fff5fe
     Complementary Colors
    	Base      : 7e877c
    	Dark      : 585e57
    	Pale      : fbfffa
    	Less Pale : f6fff5

As you can see this second option generates a more human readable output
(but is far less script friendly).

Prev: Using Extensions | Next: Tips and Tricks

Retrieved from
"https://wiki.archlinux.org/index.php?title=Perl_Background_Rotation/Extras&oldid=225282"

Category:

-   Perl Background Rotation
