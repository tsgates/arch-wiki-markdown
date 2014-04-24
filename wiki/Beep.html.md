Beep
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Beep is an advanced PC speaker beeping program. It is useful for
situations where no sound card and/or speakers are available, and simple
audio notification is desired.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Tips and Tricks
-   4 See also

Installation
------------

Command-line interface to this feature can be installed with Pacman.

    # pacman -S beep

Configuration
-------------

By default, only root can run the beep command, but other users can be
allowed to run it by changing the permissions of the beep command.

    # chmod 4755 /usr/bin/beep

You should also unmute the Beep channel using alsamixer.

    $ alsamixer

you may need to press F6 and select your card. scroll to the Beep
channel using the arrow keys and press M to unmute the channel. notice
that the "MM" label below the channel will change to "00". you can also
use ↑ to increase the volume of the channel.

press Esc to close alsamixer.

you can also save your settings to ALSA Mixer to make it permanent:

    # alsactl -f /var/lib/alsa/asound.state store

Tips and Tricks
---------------

While many people are happy with the traditional beep sound, some may
like to change its properties a bit. The following example plays slighly
higher and shorter sound and repeats it two times.

    # beep -f 5000 -l 50 -r 2

See also
--------

-   Advanced Linux Sound Architecture

Retrieved from
"https://wiki.archlinux.org/index.php?title=Beep&oldid=273840"

Category:

-   Audio/Video

-   This page was last modified on 1 September 2013, at 11:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
