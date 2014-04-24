Extra Keyboard Keys in Console
==============================

Related articles

-   Extra Keyboard Keys
-   Extra Keyboard Keys in Xorg
-   Map scancodes to keycodes

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

Contents
--------

-   1 Creating a custom keymap
-   2 Adding directives
    -   2.1 Other examples
-   3 Saving changes

Creating a custom keymap
------------------------

First, create a keymap file. This keymap file can be anywhere, but one
method is to mimic the directory hierarchy in /usr/local:

    # mkdir -p /usr/local/share/kbd/keymaps
    # vim /usr/local/share/kbd/keymaps/personal.map

As a side note, it is worth noting that such a personal keymap is useful
also to redefine the behaviour of keys already treated by the default
keymap: when loaded with loadkeys, the directives in the default keymap
will be replaced when they conflict with the new directives and
conserved otherwise. This way, only changes to the keymap must be
specified in the personal keymap.

Tip:You can also edit an existing keymap located in the
/usr/share/kbd/keymaps/ directory tree. Keymaps have an .map.gz
extension, for example us.map.gz is an American keymap. Just copy the
keymap to /usr/local/share/kbd/keymaps/personal.map.gz and gunzip it.

Adding directives
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

> Other examples

-   To make the Right Alt key same as Left Alt key (for Emacs), use the
    following line in your keymap. It will include the file
    /usr/share/kbd/keymaps/i386/include/linux-with-two-alt-keys.inc,
    check it for details.

    include "linux-with-two-alt-keys"

-   To swap CapsLock with Escape (for Vim), remap the respective
    keycodes:

    keycode 1 = Caps_Lock
    keycode 58 = Escape

-   To make CapsLock another Control key, remap the respective keycode:

    keycode 58 = Control

-   To swap CapsLock with Left Control key, remap the respective
    keycodes:

    keycode 29 = Caps_Lock
    keycode 58 = Control

Saving changes
--------------

In order to make use of the personal keymap, it must be loaded with
loadkeys:

    $ loadkeys /usr/local/share/kbd/keymaps/personal.map

However this keymap only active for the current session. In order to
load the keymap at boot, specify the full path to the file in KEYMAP
variable in /etc/vconsole.conf. The file does not have to be gzipped as
the official keymaps provided by kbd.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys_in_Console&oldid=287572"

Category:

-   Keyboards

-   This page was last modified on 11 December 2013, at 00:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
