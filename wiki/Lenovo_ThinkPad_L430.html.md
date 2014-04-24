Lenovo ThinkPad L430
====================

  Summary help replacing me
  ---------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad L430 laptop.

Troubleshooting
---------------

> Trackpoint

There are some issues regarding the trackpoint on the ThinkPad L530 and
L430 series. See https://bugzilla.kernel.org/show_bug.cgi?id=33292

Warning:This is just a quick and dirty workaround. The following
solution will remove the two-finger-scroll functionality of the
touchpad. Scrolling is still possible by holding the trackpoint's center
button and pushing the trackpoint in the direction you wish to scroll.

Load the kernelmodule psmouse with the options proto=bare:

    # echo "options psmouse proto=bare" | sudo tee /etc/modprobe.d/trackpoint-elantech.conf 

Reload the kernelmodule, the trackpoint should now be usable:

    # sudo modprobe -rv psmouse && sudo modprobe -v psmouse 

Note:For more information see:
http://wiki.ubuntuusers.de/Trackpoint#Trackpoint-wird-nicht-erkannt-nur-ThinkPad-L430-530
(German)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_L430&oldid=286874"

Category:

-   Lenovo

-   This page was last modified on 7 December 2013, at 11:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
