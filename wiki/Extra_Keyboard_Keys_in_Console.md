Extra Keyboard Keys in Console
==============================

> Summary

A general overview of how to assign actions to extra keyboard keys.

> Related

Xorg

Xmodmap

Extra Keyboard Keys

Extra Keyboard Keys in Xorg

When using the console, you can use hotkeys to print a specific
character. Moreover we can also print a sequence of characters and some
escape sequences. Thus, if we print the sequence of characters
constituting a command and afterwards an escape character for a new
line, that command will be executed!

One method of doing this is editing the keymap. However, the keymap is a
sensitive file, and since it will be rewritten anytime the package it
belongs to is updated, editing this file is discouraged. It is better to
integrate the existing keymap with a personal keymap. The loadkeys
utility can do this.

Creating a custom keymap
------------------------

First, create a keymap file. This keymap file can be anywhere, but one
method is to mimic the directory hierarchy in /usr/local:

    # mkdir -p /usr/local/share/kbd/keymaps
    # vim /usr/local/share/kbd/keymaps/personal.map

As a side note, it is worth noting that such a personal keymap is useful
also to redefine the behavior of keys already treated by the default
keymap: when loaded with loadkeys, the directives in the default keymap
will be replaced when they conflict with the new directives and
conserved otherwise. This way, only changes to the keymap must be
specified in the personal keymap.

Adding Directives
-----------------

Two kinds of directives are required in this personal keymap. First of
all, the keycode directives, which matches the format seen in the
default keymaps. These directives associate a keycode with a keysym.
Keysyms represent keyboard actions. The actions available include
outputting character codes or character sequences, switching consoles or
keymaps, booting the machine, and many other actions. A complete list
can be obtained with

    # dumpkeys -l

Most keysyms are them are intuitive. For example, to set key 112 to
output an 'e', the directive will be:

    keycode 112  = e

To set key 112 to output a euro symbol, the directive will be:

    keycode 112 = euro

Some keysym are not immediately connected to a keyboard actions. In
particular, the keysyms prefixed by a capital F and one to three digits
(F1-F246) constituting a number greater than 30 are always free. This is
useful directing a hotkey to output a sequence of characters and other
actions:

    keycode 112 = F70

Then, F70 can be bound to output a specific string:

    string F70 = "Hello"

When key 112 is pressed, it will output the contents of F70. In order to
execute a printed command in a terminal, a newline escape character must
be appended to the end of the command string. For example, to enter a
system into hibernation, the following keymap is added:

    string F70 = "sudo /usr/sbin/hibernate\n"

Saving changes
--------------

In order to make use of the personal keymap, it must be loaded with
'loadkeys':

    $ loadkeys /usr/local/share/kbd/keymaps/personal.map

However this keymap only active for the current session. In order to
load the keymap at boot it is necessary to add the following to
/etc/rc.local:

    loadkeys -q /usr/local/share/kbd/keymaps/personal.map&

Note that this line must be preceded by all occurrences of 'setkeycodes'
since the keymap may use the keycodes set by 'setkeycodes'.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys_in_Console&oldid=222861"

Category:

-   Keyboards
