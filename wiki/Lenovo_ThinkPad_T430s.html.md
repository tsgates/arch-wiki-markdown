Lenovo ThinkPad T430s
=====================

Contents
--------

-   1 Known issues
    -   1.1 Open issues
    -   1.2 Fixed
    -   1.3 Laptop Settings

Known issues
------------

The following are known problems and workarounds for the Lenovo Thinkpad
T430s, and likely also for the related models (X230, T430, T530).

> Open issues

-   The usual issue with laptop hard drives and disk head parking: see
    here
-   At least on one T430s, using QCad with SNA would reliably crash
    Xorg. A workaround is using UXA instead of SNA. (FS#31617)
-   Sometimes, switching the keyboard backlight on via Fn+Space doesn't
    work properly: at first the backlight just stays off, and when one
    presses the combination again, it goes to directly to 'high',
    skipping the 'low' mode.

> Fixed

-   Fixed: when opening/closing the lid, the screen would freeze. One
    could recover from this by suspending and waking up again.
    (FS#30690])
-   Backlight works out of the box again now.
-   The microphone button didn't work, it neither generated ACPI events
    nor keypresses. Works now (emits XF86AudioMicMute).
-   Fixed accurately setting the brightness levels with the Fn +
    brightness up/down shortcut keys. The problem comes from Intel
    graphics, and the solution can be found from here.

> Laptop Settings

Xbindkeys can be used to customize keybindings provided by this machine,
e.g. to shutdown monitor with the black button next to microphone
button, add following to ~/.xbindkeysrc, and then run xbindkeys

     # Close display
     "xset dpms force off"
        m:0x0 + c:156
        XF86Launch1

other options can be found from Lenovo ThinkPad T420#Volume up/down not
changing volume

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T430s&oldid=294535"

Category:

-   Lenovo

-   This page was last modified on 26 January 2014, at 14:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
