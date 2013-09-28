Adjusting typematic delay and rate
==================================

The 'typematic delay' indicates the amount of time, typically in
miliseconds, a key needs to be pressed in order for the repeating
process to begin. After the repeating process has been triggered, the
character will be repeated with a frequency (usually given in Hz
governed by the 'typematic rate'.

This article describes tuning of the automatic key repeating process.

Tuning the typematic behavior in the tty
----------------------------------------

Using the 'kbdrate' command:

    # kbdrate [ -d delay ] [ -r rate ]

If you wanted to set an typematic delay of 200ms and a repeating rate of
30Hz then you would issue:

    # kbdrate -d 200 -r 30

Issuing the command without arguments:

    # kbdrate

will return the typematic values to their respective defaults; a delay
of 250ms and a rate of 11Hz.

Tuning the typematic behavior in X
----------------------------------

See also: Xorg

Using the 'xset' command:

    $ xset r rate delay [rate]

If you wanted to set an typematic delay of 200ms and a repeating rate of
30Hz, then you would include this command in your ~/.xinitrc:

    $ xset r rate 200 30

Issuing the command without specifying the delay and rate:

    xset r rate

will return the typematic values to their respective defaults; a delay
of 660ms and a rate of 25Hz.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adjusting_typematic_delay_and_rate&oldid=202708"

Category:

-   Keyboards
