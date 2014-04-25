Keyboard without cursor keys
============================

The original UNIX terminals does not have the eight movement keys:

Up, Down, Left, Right, Top(HOME), Bottom(END), Page-UP, Page-DOWN.

Today there are still such keyboard in use for its compact size and
touch-type efficiency, e.g. Happy Hacking keyboard, Das Keyboard and KBC
POKER (KBC POKER II too). Even if you do not use one of these keyboard,
you may still wish to use Linux without using these eight movement keys,
to avoid moving fingers from touch-key positions during editing.

Contents
--------

-   1 The EMACS cursor movement shortcut keys
    -   1.1 readline
    -   1.2 gtk
    -   1.3 Firefox
    -   1.4 Chromium
    -   1.5 xTerm
    -   1.6 gnome-terminal

The EMACS cursor movement shortcut keys
---------------------------------------

EMACS keybinding supports the following movement keys:

Single character movement:

Ctrl+b/f/p/n: Left, Right, Up, Down

Word movement:

Alt+b/f: Move left a word/ Move right a word

Delete character:

Ctrl+h/d: delete the charater to the left/ delete the character to the
right.

Paragraph movement:

Ctrl+a/e: move to the begining (HOME)/ move to the end(END)

> readline

It is easy to get by without 8 keys on console. Emacs mode is supposed
by readline(3), thus by bash, mysql, python and many others also already
support them without any special configuration.

readline in addition supports Ctrl+u, which deletes from the current
cursor position to the begining of paragraph. This combination does
nothing on its own in Emacs, and it simply delete the whole line in
gtk's EMACS keybinding mode, irregarding to the current cursor position.

> gtk

By enabling GTK key bindings, these key-bindings would work on all GTK
applications. This include Firefox.

> Firefox

Firefox would use EMACS keybindings if gtk is configured so. Many EMACS
keybindings conflict with existing Firefox keybindings. Since emacs
movement keybindings are used more frequently, we should make sure they
take priority.

Some keys already do, like Ctrl+w would be taken as "delete previous
word" in an HTML TEXTAREA, and it would be taken as "Close current tab"
if the user is not editing text in an TEXTAREA.

Some keys are not.

Alt+d, meaning "deleting the current word from the cursor", would
activate addressbar in Firefox, like Ctrl+L or F6 does. Remapping this
keybinding requires an addon extension. The most popular keybinding
editor addon for Firefox, "Customizable Shortcuts", does not offer
remapping of Alt+d, instead, Keyconfig [1] do.

In emacs mode, the up-arrow and down-arrow replacements are Ctrl+p, in
Firefox meaning "print the current page", and Ctrl+n, "Open the new
browser window". They both can be disabled with Keyconfig mentioned
above. A better solution is to make these keys cursor movement keys if
the user is editing text, and browser function keys otherwise, like how
Ctrl+w was treated. However such a solution has not been made possible
yet.

> Chromium

All emacs-style shortcut keys defined in gtk's EMACS mode are usable in
Chromium, if user is editing text; and in other cases, these shortcut
keys function as browser shortcut keys. For example, Ctrl+p moves cursor
one line up during editing, and in other occassions calls up "print
webpage" dialogue.

> xTerm

xTerm by default ignores alt key. Alt key (or meta key) is not needed
for the emacs-style replacements for the 8 cursor-keys, but are used in
emacs-style cursor movement shortcuts, like word-delete.

Alt key is essentially ESCAPE key. Alt-something emits Escape key
followed by that something. To enable alt-keys in xTerm put the
following in ~/.Xresources:

       XTerm*metaSendsEscape: true

> gnome-terminal

gnome-terminal by default use alt-key to activate menu items. To let alt
key emit Escape sequence, as console application would expect, go to
Edit > Keyboard Shortcuts..., and uncheck "Enable menu access keys".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keyboard_without_cursor_keys&oldid=295149"

Category:

-   Keyboards

-   This page was last modified on 31 January 2014, at 13:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
