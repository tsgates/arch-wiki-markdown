Extra Keyboard Keys
===================

> Summary

A general overview of how to assign actions to extra keyboard keys.

> Related

Xorg

Xmodmap

Extra Keyboard Keys in Xorg

Extra Keyboard Keys in Console

Many keyboards include some "special keys" (also called hotkeys, such as
HP Quickplay), which are supposed to execute an application or print
special characters (not included in the standard national keymaps). The
lack of specification for these extra keys makes it impossible for the
kernel to know what to do with them and that is why we need to map the
keys to actions. There are 3 ways of doing that:

-   The most portable way using low level tools, such as acpid. Not all
    keys are supported, but configuration in uniform way is possible for
    keyboard keys, power adapter connection and even headphone jack
    (un)plugging events.
-   The universal way using Xorg utilities (and eventually your desktop
    environment tools)
-   The quicker way using a third-party program to do everything in GUI,
    such as the Gnome Control Center or Keytouch

Before starting you need to learn some vocabulary:

A scancode is the lowest identification number for a key. If a key does
not have a scancode then we cannot do anything because it means that the
kernel does not see it.

A keycode is the second level of identification for a key, a keycode
corresponds to a function.

A symbol is the third level of identification for a key, it is the way
Xorg refers to keys.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Step 1: Check for keycodes                                         |
|     -   1.1 Using xev                                                    |
|     -   1.2 Using showkey                                                |
|     -   1.3 2.6 kernels                                                  |
|     -   1.4 Check for scancodes                                          |
|                                                                          |
| -   2 Step 2: Map keycodes                                               |
|     -   2.1 In Console                                                   |
|     -   2.2 In Xorg                                                      |
|                                                                          |
| -   3 Laptops                                                            |
|     -   3.1 Asus M series                                                |
+--------------------------------------------------------------------------+

Step 1: Check for keycodes
--------------------------

Most of your keys should already have a keycode, or at least a scancode.
Keys without a scancode are not recognized by the kernel.

> Using xev

Use the graphical X program "xev" (without having to switch to a console
environment). Install the xev program:

    # pacman -S xorg-xev

With the following line you can start xev and directly grep the
important parts:

    $ xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'

In the example below I pressed the "a", "r", "c" and "h" keys and two of
the media keys on my Dell keyboard. This gives me the following output:

    38 a
    27 r
    54 c
    43 h
    153 NoSymbol
    144 NoSymbol

This means that the "a", "r", "c" and "h" keys have the keycodes 38, 27,
54 and 43 and are properly bound while the media keys with the keycodes
153 and 144 have no function yet, which is indicated by "NoSymbol". If
you press a key and nothing appears in the terminal, this means that the
kernel does not see that key or that it is not mapped.

> Using showkey

The universal way to know if a key has a keycode is to use the kernel
showkey program. showkey waits for a key to be pressed and if none is
during 10 seconds it quits, note that this is the only way to exit the
program. To execute showkey you need to be in a real console, it means
not in a graphical environment so switch using Ctrl+Alt+F1 (Ctrl+Alt+F7
returns to the graphical environment).

    # showkey

and try to push your hotkeys. If a keycode appears the key is mapped, if
not it can mean either that the kernel does not see the key or that the
key is not mapped.

> 2.6 kernels

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

If all your keys have a keycode you can go directly to the second step.
If not keep reading below:

> Check for scancodes

If a key does not have a keycode you can know if it has a scancode by
looking at the kernel log using the dmesg command:

    $ dmesg|tail -5

If when you press the key something like that appears:

    atkbd.c: Unknown key pressed (translated set 2, code 0xf1 on isa0060/serio0).
    atkbd.c: Use 'setkeycodes e071 <keycode>' to make it known.

then your key has a scancode which can be mapped to a keycode. See Map
scancodes to keycodes.

If nothing new appears in dmesg then your key does not have a scancode,
which means that it is not recognized by the kernel and cannot be used.

Step 2: Map keycodes
--------------------

> In Console

See the dedicated article: Extra Keyboard Keys in Console.

When in console, hotkeys can be used to print sequences of characters,
including escape sequences. Thus, printing the sequence of characters
constituting a command followed by the escape sequence for a new will
execute the command.

> In Xorg

See the dedicated article: Extra Keyboard Keys in Xorg.

Laptops
-------

> Asus M series

In order to have control over the light sensor and the multimedia keys
on your Asus machine, you should use the following command:

    # echo 0 > /sys/devices/platform/asus-laptop

To have it run on boot:

    /etc/rc.local

    echo 0 > /sys/devices/platform/asus-laptop/ls_switch

Note that this may work for other Asus notebook models. See the detailed
article: lineak.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys&oldid=251457"

Category:

-   Keyboards
