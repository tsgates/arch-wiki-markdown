Touchegg
========

Touchegg is a multitouch gesture program, that runs as a user in the
background, and adds multitouch support to window managers.

installation
------------

Base package: touchegg in AUR.

GUI configuration, Touchegg-GCE [1]: touchegg-gce-git in AUR

configuration
-------------

The configuration file is found in $HOME/.config/touchegg/touchegg.conf.

It is a basic XML file that defines various gestures. Please note that
at this time TAP_AND_HOLD, PINCH, and ROTATE, do not appear to work.

The list of triggers can be found here

The list of actions can be found here

Gnome Shell

Very basic so far. This should give you basic functionality. Hopefully
we can update this for complete application support.

edit $HOME/.config/touchegg/touchegg.conf add this:

    <gesture type="DRAG" fingers="1" direction="ALL">
                <action type="DRAG_AND_DROP">BUTTON=1</action>
            </gesture>

and then edit this entry:

    <gesture type="DRAG" fingers="2" direction="ALL">
                <action type="SCROLL">SPEED=7:INVERTED=true</action>
            </gesture>

then have touchegg start on login: 1. hit alt-f2 2. type
gnome-session-properties 3. hit add 4. In the box labeled "Command" type
touchegg. Fill in "Name" and "Label" as you choose. 5. Hit OK

Retrieved from
"https://wiki.archlinux.org/index.php?title=Touchegg&oldid=304567"

Category:

-   Applications

-   This page was last modified on 15 March 2014, at 03:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
