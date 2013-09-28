Perl Background Rotation
========================

  
 PLEASE NOTE THAT THIS IS AN OLDER DUPLICATE OF THIS PAGE. I'm tired to
maintaining two copies of this data in two completely different wiki
markups so this set of pages will receive infrequent updates.

About
-----

This page describes a set of perl scripts Charles Mauch wrote to rotate
his desktop wallpapers. Eventually these scripts evolved to incorporate
other (non-standard) wallpaper switcher features, so this page was setup
to document the mess that ensued. If you wish to make a comment on this
script, email [Charles] or discuss it in this thread on the bbs.

If you come up with a use for any of these scripts, feel free to add
your experiences/screenshots here.

Table of Contents
-----------------

1.  Introduction : What this does.
2.  Installation : Getting the basics handled.
3.  Using Extensions : Optional feature setup.
4.  Script Extras : Related Software
5.  Tips and Tricks : Fun for the whole family!
6.  Hacking : How to create your own extensions
7.  Code : Code walkthrough and some design notes
8.  FAQ : Frequently Asked Questions
9.  Screenshot Gallery : If you use these scripts, show off!
10. Resources : A comprehensive wallpaper list.

Basic Features
--------------

A brief overview.

1.  This script picks different categories of backgrounds depending on
    the time of the day. For example, during the morning I (Charles)
    like my backgrounds to be bright and cheerful, and as the day
    progresses I like the mood to become more technical/geeky and most
    importantly ... unobtrusive while I work. After work ends, the
    backgrounds start to include "racier" or distracting photos. But by
    early morning it's back to landscapes and anime. This is by far my
    favorite feature.
2.  When this script picks an new background image to display, it checks
    the selected photo's for a match to any of the previous 5
    backgrounds which were displayed. It repeats this process for each
    display. In addition, the randomization function favors new files
    over old files. This seems to work really well at keeping older
    photos in circulation without repeating them so often you get burned
    out. The list of 5 previously displayed backgrounds is maintained to
    keep newer photos (which appear more often) from "flip-flopping" or
    showing up within a few hours of each other.
3.  If the perfect background appears and you want to keep it displayed
    for a few hours, you can freeze the randomization process with a
    simple keybinding in your windowmanager. You can also easily process
    a new wallpaper from nautilus using a (provided) script.
4.  Tiled backgrounds are fully supported and look great. See
    http://tr1tium.com/propaganda/Propaganda/ for great tiles.

Optional Features
-----------------

1.  This script can make an attempt at reading the mean "color" of a
    selected background image and then creates a new color scheme based
    on that base color. If a photo is too white or dark to return a
    visible palate, the script will pick a color from a pre-defined list
    of generic colors. Please note that this particular piece of code is
    being constantly updated as I learn more about color selection.
2.  This script can easily slurp up a variety of configuration files,
    and spit out new color configurations. In the event that a
    particular photo looks horrible with the the automatically chosen
    color (or cropping pattern), you can override those functions by
    adding some metadata into the wallpaper's filename. Out of the box,
    the following software is themable with this script: Conky
    Configuration Files, Openbox Styles, and yes - Gtk2 Themes (gtkrc
    files).
3.  A border area around the screen can be created for transparent
    panels and conky's display area. The sizes of both this top and
    right frame is configurable.
4.  This script can create a preview "photo collage" of the next photo
    to be displayed as your wallpaper. It's a neat effect, which I
    created for no other reason than my conky stats did not extend all
    the way down the screen and I had a hole to fill.
5.  This script can create an additional photo for urxvt (or Eterm)
    backgrounds based on either the modified or original image. This
    photo gives the appearance of transparency but with a blurred and
    shaded background. This can drastically improve the readability of
    so called transparent terminals. A similar effect can be achieved in
    Beryl or other compositing Window managers. But the same effect can
    be achieved without the benefit of XGL or buggy X extensions and
    beta video drivers.

A few thoughts before plunging in
---------------------------------

I think that most people simply throw their wallpapers into a directory
somewhere to rot. Or maybe they do not even go that far and they simply
use firefox to set their background. There is nothing wrong with this
approach, but for years I've been collecting wallpapers and sorting
through them, occasionally trading them - much as a 10 year old kid
might do with baseball cards. I *love* finding that perfect new
wallpaper, maybe cleaning it up a little - and storing it away in it's
proper place in my filesystem hierarchy. Hey, different strokes and all
that.

If you are a member of the background dumpground group mentioned above,
this script probably wont excite you much. I have enough wallpapers now
that I like to rotate them out every 20 minutes or so.

If you think that such an approach in non-productive or jarring; you are
(1) probably right, and (2) you might want to stop here. I can pretty
much guarantee that if you find a radical change in colors and
appearance on your desktop annoying, this script will get old REAL
fast. :)

> On Wallpaper organization

Like I mentioned, I have a hierarchy and categorization scheme I use
with my own collection. This script assumes an easier system than what I
use, but it will still require some explanation to the conventions I
(and possibly this script) expect as a result.

You will need to establish a directory structure of Wallpaper
"categories" for this script to be even remotely useful. The only rules
of thumb here are that each "category" should contain at least several
images. The script will recurse though ALL subdirectories per category,
so keep that in mind before starting. The script default assumes a
directory of ~/.backgrounds. Of course this can be overridden to
whatever you like.

The default layout should look something like this (this is not set in
stone, you can easily override this in the configuration).

    ~/.backgrounds/Early           - for prime hacking hours - 0:00 until 05:00am
    ~/.backgrounds/Food/Breakfast  - it's time to eat! display food!
    ~/.backgrounds/Morning         - Sunrises and coffee mugs
    ~/.backgrounds/Work/Arriving   - Corporate logos
    ~/.backgrounds/Work/Hacking    - Minimalistic themes
    ~/.backgrounds/Food/Lunch      - Photos of gourmet luncheon!
    ~/.backgrounds/Afternoon       - More minimalistic hacking themes
    ~/.backgrounds/Evening         - NSFW!

Again, this is only a suggested layout. You can drill down to an hourly
category scheme if you need that level of control.

> On photo naming conventions

With wallpapers, it seems like the more like a piece of obscured source
code the filename appears to be, the better web-admins and gallery
providers like it. I insist on descriptive names though. I tend to
separate words with periods (the unix way). If you have spaces in your
filenames, odd things can and probably will happen. I tend to do a lot
of space-stripping, so I suggest you at least remove spaces if you can.
Other than that, this script should be able to handle whatever filenames
you throw at it.

I do have some naming conventions that this script can make use of
though:

1.  A filename prefixed by Tile_, this indicates the photo is a tile and
    should never be resized or cropped. If the file is not large enough
    to to fill the screen, it is tiled across it. Propaganda photos are
    perfect examples of this kind of image.
2.  A filename prefixed by Right_, Left_, or Center_ indicates a
    cropping preference. In order ensure photos fit correctly on the
    resized photo area that this script optionally creates, some hefty
    cropping and chopping of the original image can happen. If you find
    that your wallpaper is getting massacred by this process, try using
    one of these prefixes to reduce the carnage.
3.  If you find that a particular photo's color scheme looks odd, you
    can manually specify a "base color" upon which to generate a new
    color scheme. Simply add _#XXXXXX_ into the filename. Note the
    underscore before and after the hexadecmial color. This chosen color
    will then be read and applied to the theme - completely overriding
    the autodetection mechanism. On some images, this can REALLY make
    things look sharp, or conversely ... horrible. Experiment.

Next: Installation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Perl_Background_Rotation&oldid=238338"

Category:

-   Perl Background Rotation
