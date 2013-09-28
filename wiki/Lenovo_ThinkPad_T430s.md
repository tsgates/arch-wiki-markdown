Lenovo ThinkPad T430s
=====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Known issues                                                       |
|     -   1.1 Microphone mute button                                       |
|     -   1.2 Backlight                                                    |
|     -   1.3 Other issues                                                 |
+--------------------------------------------------------------------------+

Known issues
------------

The following are known problems and workarounds for the Lenovo Thinkpad
T430s, and likely also for the related models (X230, T430, T530).

> Microphone mute button

The microphone button doesn't work. It doesn't generate any events
whatsoever, neither ACPI events nor keypresses.

> Backlight

Work out of box now.

> Other issues

-   The usual issue with laptop hard drives and disk head parking: see
    here
-   Fixed: when opening/closing the lid, the screen would freeze. One
    could recover from this by suspending and waking up again. (issue)
-   At least on one T430s, using QCad with SNA would reliably crash
    Xorg. A workaround is using UXA instead of SNA. (issue)
-   Sometimes, switching the keyboard backlight on via Fn+Space doesn't
    work properly: at first the backlight just stays off, and when one
    presses the combination again, it goes to directly to 'high',
    skipping the 'low' mode.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T430s&oldid=254312"

Category:

-   Lenovo
