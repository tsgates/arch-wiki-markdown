Cmus
====

cmus (C* MUsic Player) is a small, fast and powerful console audio
player which supports most major audio formats. Various features include
gapless playback, ReplayGain support, MP3 and Ogg streaming, live
filtering, instant startup, customizable key-bindings, and vi-style
default key-bindings.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Using cmus with alsa
-   3 Usage
    -   3.1 Starting Cmus
    -   3.2 Adding Music
    -   3.3 Playing Tracks
    -   3.4 Keybindings
    -   3.5 Remote Control
-   4 Tabs
    -   4.1 Library tab (1)
    -   4.2 Sorted library tab (2)
    -   4.3 Playlist tab (3)
    -   4.4 Play Queue tab (4)
    -   4.5 Browser (5)
    -   4.6 Filters tab (6)
    -   4.7 Settings tab (7)
-   5 Links

Installation
============

Install cmus, available in the Official repositories.

Alternatively, there is also a development version available in the AUR
called cmus-git.

Configuration
=============

To configure cmus start it and switch to the configuration tab by
pressing 7. Now you can see a list of default keybindings. Select a
field in the list with the arrow keys and pressEnter to edit the values.
You can also remove bindings with D or del. To edit unbound commands and
option variables scroll down in the list to the relevant section.
Variables can also be toggled instead of edited with space. Cmus allows
changing the color of nearly every interface element. You can prefix
colors with "light" to make them appear brighter and set attributes for
some text elements.

Using cmus with alsa
--------------------

When using cmus with Advanced Linux Sound Architecture the default
configuration does not allow playing music. To fix it change three
variables, set dsp.alsa.device to default , set mixer.alsa.channel to
Master and set mixer.alsa.device to  default.

Usage
=====

Cmus comes with a great reference manual.

    $ man cmus 
    $ man cmus-tutorial
    $ man cmus-remote

Starting Cmus
-------------

To start cmus, type:

    $ cmus

When you first launch cmus it will open to the album/artist tab.

Adding Music
------------

Press 5 to switch to the file-browser tab so we can add some music. Now,
use the arrow keys (up, down), Enter and Backspace to navigate to where
you have audio files stored. Alternatively, you may use the vim bindings
(k, j) to navigate up and down through your music.

To add music to your cmus library, use the arrow keys to highlight a
file or folder, and press a. When you press a cmus will move you to the
next line down (so that it is easy to add a bunch of files/folders in a
row) and start adding the file/folder you pressed a in to your library.
This may take a bit if you added a folder with a lot of music in it. As
files are added, you will see the second time in the bottom right go up.
This is the total duration of all the music in the cmus library.

Note:cmus does not move, duplicate or change your files. It just
remembers where they are and caches the metadata (duration, artist,
etc.)

Note:Cmus automatically saves your settings, library and everything when
you quit.

Playing Tracks
--------------

Press 1 to go to the simple library view. Use the (up and down arrow
keys (or k, j) to select a track you'd like to hear, and press Enter to
play it. Here's some keys to control play:

Press c to pause/unpause

Press right/left (or h, l) arrow keys to seek by 10 seconds

Press </> seek by one minute

Keybindings
-----------

See the configuration section on how to change keybindings.

Remote Control
--------------

Cmus can be controlled externally through a unix-socket with
cmus-remote. This makes it easy to control playback through an external
application or key-binding.

One such usage of this feature is to control playback in Cmus with the
XF86 keyboard events. The following script when run will start Cmus in
an xterm terminal if it isn't running, otherwise it will will toggle
play/pause:

    #!/bin/sh
    #
    # Author: Dennis Hodapp
    # Filename: cplay
    # Requires: cmus
    #
    # Tests if cmus is running and starts it if it isn't.
    # Else it toggles play/pause.
    # This command will break if you rename it to
    # something containing "cmus".

    TERMINAL=/usr/bin/xterm
    SHELL=/bin/sh

    if ! ps aux | grep -w "cmus$" | grep -v grep > /dev/null ; then
      $TERMINAL -e $SHELL -c cmus & > /dev/null
    else
      cmus-remote -u
    fi

To use the previous script in Openbox, copy the code above into a file
~/bin/cplay. Make the file executable using chmod +x ~/bin/cplay. Next
edit ~/.config/openbox/rc.xml and change the following key-bindings to
look like this:

Note:Make sure there are no conflicting keybindings in rc.xml

    ~/.config/openbox/rc.xml

      <keyboard>
        <keybind key="XF86AudioPlay">
          <action name="Execute">
            <command>cplay</command>
          </action>
        </keybind>
        <keybind key="XF86AudioNext">
          <action name="Execute">
            <command>cmus-remote -n</command>
          </action>
        </keybind>
        <keybind key="XF86AudioPrev">
          <action name="Execute">
            <command>cmus-remote -r</command>
          </action>
        </keybind>
      </keyboard>

Now when you use the XF86AudioPlay key on your keyboard, cmus will open
up. If it's opened already it will then start playing. Using the
XF86AudioNext and XF86AudioPrev keys will change tracks.

Tabs
====

There are 7 tabs in cmus. Press keys 1-7 to change active tab.

Library tab (1)
---------------

Display all tracks in so-called library. Tracks are sorted artist/album
tree. Artist sorting is done alphabetically. Albums are sorted by year.

Sorted library tab (2)
----------------------

Displays same content as view, but as a simple list which is
automatically sorted by user criteria.

Playlist tab (3)
----------------

Displays editable playlist with optional sorting.

Play Queue tab (4)
------------------

Displays queue of tracks which are played next. These tracks are played
before anything else (i.e. the playlist or library).

Browser (5)
-----------

Directory browser. In this tab, music can be added to either the
library, playlist or queue from the filesystem.

Filters tab (6)
---------------

Lists user defined filters.

Settings tab (7)
----------------

Change settings. See configuration for further information.

Links
=====

1.  Git Repository
2.  Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cmus&oldid=301598"

Category:

-   Player

-   This page was last modified on 24 February 2014, at 11:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
