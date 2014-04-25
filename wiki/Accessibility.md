Accessibility
=============

There are many different methods of providing accessibility to users
that suffer from a physical or visual handicap. However, unless a
desktop environment is used, the configuration might require some
tinkering until one gets it right.

Contents
--------

-   1 Desktop Environments
-   2 Physical Assistance
    -   2.1 Operating the Keyboard
        -   2.1.1 Console
            -   2.1.1.1 Sticky Keys
        -   2.1.2 Independent of Graphical Environment
    -   2.2 Operating the Mouse
        -   2.2.1 Independent of Graphical Environment
            -   2.2.1.1 Button Mapping
-   3 Visual Assistance
    -   3.1 Text To Speech
    -   3.2 Console & Virtual Terminal Emulators
-   4 Issues

Desktop Environments
--------------------

Most modern desktop environments ship with an extensive set of features,
among which one can find a tool to configure the accessibility options
with. Generally, these options can be found listed under those of
'accessibility', or under those of the corresponding input device (e.g.
'keyboard' and 'mouse').

Note:When using the configuration tools of a desktop environment, be
weary of possible conflicts with settings of
desktop-environment-independent tools.

Physical Assistance
-------------------

For speech recognition, see Text to speech.

> Operating the Keyboard

For Braille, see Arch Linux for the blind.

Console

Sticky Keys

In order to enable Sticky Keys in a TTY, you require to know the exact
keycodes of the keys to be used. These can be found by a tool like
xorg-xev or xkeycaps. Alternatively, you can inspect the output of
dumpkeys, provided that the current keymap is correct.

For example, a Logitech Ultra-X will provide the following keycodes for
the modifier keys:

    LCtrl = 29
    LShift = 42
    LAlt = 56
    RShift = 54
    RCtrl = 97

Next, use dumpkeys to determine the range of the keycodes:

    # dumpkeys | head -1
    keymaps 0-63

Continue by creating a new file with a suitable name, e.g. "stickyKeys",
and use your favourite editor to combine the previously-found
information with the desired key function.

In case of the keycodes found earlier, you would get:

    keymaps 0-63
    keycode 29 = SCtrl
    keycode 42 = SShift
    keycode 56 = SAlt
    keycode 54 = SShift
    keycode 97 = SCtrl

Here, the letter "S" in front of a modifier key denotes that we want the
sticky version of that key.

Note:The following step will change you key mapping in all TTYs. Ensure
the correctness of your keycodes, for else you might loose the ability
to use certain important keys.

Load your new mapping by running the following command:

    # loadkeys ./stickyKeys

If you are satisfied by the results, then move the file to a suitable
directory, and ensure that it will be loaded on boot either by placing
the above command in /etc/rc.local (old method), or by using a systemd
service file (preferred method).

In case of systemd, an example service file might look like:

    [Unit]
    Description="load custom keymap (sticky keys)"
     
    [Service]
    Type=oneshot
    ExecStart=/usr/bin/loadkeys /path/to/stickyKeys
    StandardInput=tty
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target emergency.target rescue.target

Finally, move this file, e.g. "loadkeys.service", to
/usr/lib/systemd/system/ and enable it by running:

    # systemdctl enable loadkeys

Independent of Graphical Environment

One method of enabling desktop environment-independent accessibility
function is by passing it through X, given that it is build with XKB
support. This can be done by setting parameters for the X server, as
specified in its man page:

    [+-]accessx [ timeout [ timeout_mask [ feedback [ options_mask ] ] ] ]
                  enables(+) or disables(-) AccessX key sequences (Sticky Keys).

    -ardelay milliseconds
                  sets the autorepeat delay (length of time in milliseconds  that
                  a key must be depressed before autorepeat starts).

    -arinterval milliseconds
                  sets  the  autorepeat  interval (length of time in milliseconds
                  that should elapse between autorepeat-generated keystrokes).

These parameters must be placed in the file ~/.xserverrc, which you may
need to create.

For example, to enable Sticky Keys without timeout and without audible
or visible feedback, the following can be used:

    if [ -z "$XDG_VTNR" ]; then
      exec /usr/bin/X -nolisten tcp "$@" +accessx 0 0x1e 0 0xcef
    else
      exec /usr/bin/X -nolisten tcp "$@" vt$XDG_VTNR +accessx 0 0x1e 0 0xcef
    fi

Note that once X has started, e.g. by executing startx, it still
requires you to press the shift key 5 times to enable Sticky Keys.
Unfortunately, this is needed each time X starts. Alternatively, a
script can be used to automate this process.

Similar to most implementations, Sticky Keys can be disabled by pressing
a modifier key and any other key at the same time.

> Operating the Mouse

Independent of Graphical Environment

Button Mapping

By using xmodmap, you can map functions to mouse buttons independent of
your graphical environment. For this, you need to know which physical
button on your mouse is read as which number, which can be found by a
tool such as xorg-xev. Generally, the physical buttons of left, middle,
and right are read as the first, second, and third button, respectively.

Once you have acquired these, continue by creating a configuration file
on a suitable location, e.g. ~/.mousekeys. Next, open the file with your
favourite editor, and write the keyword pointer = followed by an
enumeration of the previously-found number of mouse buttons.

For example, a three button mouse with a scroll wheel is able to provide
five physical actions: left, middle, and right click, as well as scroll
up and scroll down. This can be mapped to the same functions by using
the following line in the configuration file:

    pointer = 1 2 3 4 5

Here, the location will tell the action required to perform an internal
mouse-button function. For example, a mapping for left-handed people
(left- and right button switched) might look like

    pointer = 3 2 1 4 5

When you are done, you can test and inspect your mapping by running
xmodmap:

    $ xmodmap ~/.mousekeys
    $ xmodmap -pp

Once satisfied, you can enable it on start by placing the first line in
~/.xinitrc.

Visual Assistance
-----------------

As with physical assistance, most modern desktop environments ship with
an extensive set of features to tweak the visual aspects of your system.
Generally, these options can be found listed under those of
'accessibility' or 'visual assistance'. Alternatively, useful options
might be found in the settings of the individual applications.

> Text To Speech

See Text to speech.

> Console & Virtual Terminal Emulators

-   Edit /etc/vconsole.conf.
-   Edit ~/.Xresources.

Issues
------

-   Configuration of input devices is not recognized by software that
    circumvents the software layer, e.g. wine, virtualbox, and qemu.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Accessibility&oldid=303536"

Category:

-   Accessibility

-   This page was last modified on 8 March 2014, at 01:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
