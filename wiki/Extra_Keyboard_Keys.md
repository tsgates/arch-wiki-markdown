Extra Keyboard Keys
===================

Related articles

-   Extra Keyboard Keys in Xorg
-   Extra Keyboard Keys in Console
-   Keyboard Configuration in Xorg
-   Keyboard Configuration in Console
-   Map scancodes to keycodes
-   Xmodmap

Many keyboards include some special keys (also called hotkeys or
multimedia keys), which are supposed to execute an application or print
special characters (not included in the standard national keymaps). udev
contains a large database of mappings specific to individual keyboards,
so common keyboards usually work out of the box. If you have very recent
or uncommon piece of hardware, you may need to adjust the mapping
manually.

Prerequisite for modifying the key mapping is knowing how the keys are
identified on the system. There are multiple levels:

-   A scancode is the lowest identification number for a key, it is the
    value that a keyboard sends to a computer.
-   A keycode is the second level of identification for a key, a keycode
    corresponds to a function.
-   A keysym is the third level of identification for a key, it
    corresponds to a symbol. It may depend on whether the Shift key or
    another modifier key was also pressed.

Scancodes are mapped to keycodes, which are then mapped to keysyms
depending on used keyboard layout. Most of your keys should already have
a keycode, or at least a scancode. Keys without a scancode are not
recognized by the kernel.

In Xorg, some keysyms (e.g. XF86AudioPlay, XF86AudioRaiseVolume etc.)
can be mapped to actions (i.e. launching an external application). See
Extra Keyboard Keys in Xorg#Map keysyms to actions for details.

In Linux console, some keysyms (e.g. F1 to F246) can be mapped to
certain actions (e.g. switch to other console or print some sequence of
characters). See Extra Keyboard Keys in Console for details.

Contents
--------

-   1 Identifying key codes
    -   1.1 Scancodes
        -   1.1.1 Using showkey
        -   1.1.2 Using dmesg
    -   1.2 Keycodes
        -   1.2.1 In console
        -   1.2.2 In Xorg
        -   1.2.3 2.6 kernels
-   2 Mapping scancodes to keycodes
-   3 Mapping keycodes to keysyms
    -   3.1 In console
    -   3.2 In Xorg
-   4 Laptops
    -   4.1 Asus M series
    -   4.2 Asus N56VJ (or possibly others)
-   5 See also

Identifying key codes
---------------------

> Scancodes

Using showkey

The universal way to get a scancode is to use the showkey utility.
showkey waits for a key to be pressed and if none is during 10 seconds
it quits, which is the only way to exit the program. To execute showkey
you need to be in a virtual console, not in a graphical environment. Run
the following command

    # showkey --scancodes

and try to push keyboard keys, you should see scancodes being printed to
the output.

Using dmesg

Note:This method does not provide scancodes for all keys, it only
identifies the unknown keys.

You can get the scancode of a key by pressing the desired key and
looking the output of dmesg command. For example, if you get:

    Unknown key pressed (translated set 2, code 0xa0 on isa0060/serio0

then the scancode you need is 0xa0.

> Keycodes

Warning:Note that the keycodes are different for Linux console and Xorg.
Use the appropriate tool to determine the desired value.

In console

The keycodes for virtual console are reported by the showkey utility.
showkey waits for a key to be pressed and if none is during 10 seconds
it quits, which is the only way to exit the program. To execute showkey
you need to be in a virtual console, not in a graphical environment. Run
the following command

    # showkey --keycodes

and try to push keyboard keys, you should see keycodes being printed to
the output.

In Xorg

The keycodes used by Xorg are reported by a utility called xev, which is
provided by the xorg-xev package. Of course to execute xev, you need to
be in a graphical environment, not in the console.

With the following command you can start xev and show only the relevant
parts:

    $ xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'

Here is an example output:

    38 a
    27 r
    54 c
    43 h
    153 NoSymbol
    144 NoSymbol

In the example the keys a, r, c, h and two other multimedia keys were
pressed. The former four keys with keycodes 38, 27, 54 and 43 are
properly mapped, while the multimedia keys with keycodes 153 and 144 are
not. The NoSymbol indicates that no keysyms are assigned to those keys.

If you press a key and nothing appears in the terminal, it means that
either the key does not have a scancode, the scancode is not mapped to a
keycode, or some other process is capturing the keypress. If you suspect
that a process listening to X server is capturing the keypress, you can
try running xev from a clean X session:

    $ xinit /usr/bin/xterm -- :1

2.6 kernels

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Now we have 3.x  
                           kernel, is it still      
                           relevant? (Discuss)      
  ------------------------ ------------------------ ------------------------

According to the keymap man page:

Note:In 2.6 kernels raw mode, or scancode mode, is not very raw at all.
Scan codes are first translated to key codes, and when scancodes are
desired the key codes are translated back...there is no guarantee at all
that the final result corresponds to what the keyboard hardware did
send. To change behavior back to the old raw mode, add the parameter
atkbd.softraw=0 to your kernel while booting. This can be removed for
later boots when the old raw functionality is not required.

This is relevant if the keymaps obtained from showkey and the ones set
by setkeycodes differ from the ones obtained by xev in X. Keep this in
mind when translating the keymaps into keysyms using xmodmap (See Extra
Keyboard Keys in Xorg).

Mapping scancodes to keycodes
-----------------------------

See the main article: Map scancodes to keycodes.

Mapping keycodes to keysyms
---------------------------

> In console

See the main article: Extra Keyboard Keys in Console.

> In Xorg

See the main article: xmodmap.

Laptops
-------

> Asus M series

In order to have control over the light sensor and the multimedia keys
on your Asus machine, you should use the following command:

    # echo 1 > /sys/devices/platform/asus_laptop/ls_switch

To have it run on boot create a Systemd tmpfile:

    /etc/tmpfiles.d/local.conf

    w /sys/devices/platform/asus_laptop/ls_switch - - - - 1

Note:This may work also for other Asus notebook models.

> Asus N56VJ (or possibly others)

if most of your special keys don't work, try loading the asus-nb-wmi
kernel module with

    # modprobe asus-nb-wmi

then check xev again. if you combine this with the acpi_osi="!Windows
2012" boot option, you may get weird results in xev, so try not using
it. If this did fix things, make sure to make the module load at boot
with methods described here

See also
--------

-   How to retrieve scancodes by Marvin Raaijmakers
-   Enabling Keyboard Multimedia Keys - guide on LinuxQuestions wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys&oldid=305811"

Category:

-   Keyboards

-   This page was last modified on 20 March 2014, at 08:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
