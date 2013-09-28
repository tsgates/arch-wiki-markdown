Keyboard Shortcuts
==================

  Summary
  -----------------------------------------------------
  Default keyboard shortcuts and user customizations.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Standard Shortcuts                                                 |
|     -   1.1 Kernel                                                       |
|     -   1.2 Terminal                                                     |
|         -   1.2.1 Virtual console                                        |
|         -   1.2.2 Readline                                               |
|                                                                          |
|     -   1.3 X11                                                          |
|     -   1.4 Links                                                        |
|                                                                          |
| -   2 User Customization                                                 |
|     -   2.1 Readline                                                     |
|     -   2.2 X11                                                          |
|         -   2.2.1 Modifying the Keyboard Layout                          |
|         -   2.2.2 Key Binding for X-Selection-Paste                      |
|                                                                          |
|     -   2.3 Firefox                                                      |
|                                                                          |
| -   3 Tips                                                               |
+--------------------------------------------------------------------------+

Standard Shortcuts
------------------

> Kernel

These are low level shortcuts that are considered to be used for
debugging. Whenever possible, it is recommended to use these instead of
doing a hard shutdown (holding power button to shutdown the
motherboard).

Must be activated first with echo "1" > /proc/sys/kernel/sysrq or if you
wish to have it enabled during boot, edit /etc/sysctl.conf and set
kernel.sysrq = 1

A common idiom to remember this is "Reboot Even If System Utterly
Broken" (also referred to as "REISUB").

  Keyboard Shortcut        Description
  ------------------------ -----------------------------------------------------------------------
  Alt+SysRq+R+ Unraw       Take control of keyboard back from X.
  Alt+SysRq+E+ Terminate   Send SIGTERM to all processes, allowing them to terminate gracefully.
  Alt+SysRq+I+ Kill        Send SIGKILL to all processes, forcing them to terminate immediately.
  Alt+SysRq+S+ Sync        Flush data to disk.
  Alt+SysRq+U+ Unmount     Unmount and remount all filesystems read-only.
  Alt+SysRq+B+ Reboot      Reboot

See Magic SysRq key - Wikipedia for more details.

> Terminal

Virtual console

  Keyboard Shortcut     Description
  --------------------- -------------------------------------------------------
  Ctrl+Alt+Del          Reboots Computer (specified in /etc/inittab)
  Alt+F1, F2, F3, ...   Switch to n-th virtual console
  Alt+←                 Switch to previous virtual console
  Alt+→                 Switch to next virtual console
  Scroll Lock           When Scroll Lock is activated, input/output is locked
  ⇑ Shift+PgUp/PgDown   Scrolls console buffer up/down
  Ctrl+C                Kills current task
  Ctrl+D                Inserts an EOF
  Ctrl+Z                Pauses current Task

Readline

GNU readline is a commonly used library for line-editing, it is used for
example by bash, ftp and many more (see Arch Package details under
"Required By" for more examples). readline is also customizable (see
manpage for details).

Keyboard Shortcut

Description

Ctrl+L

Clear the screen

Cursor Movement

Ctrl+B

Move cursor one character to the left

Ctrl+F

Move cursor one character to the right

Alt+B

Move cursor one word to the left

Alt+F

Move cursor one word to the right

Ctrl+A

Move cursor to start of the line

Ctrl+E

Move cursor to end of the line

Copy & Paste

Ctrl+U

Cut everything from line start to cursor

Ctrl+K

Cut everything from the cursor to end of the line

Alt+D

Cut the current word after the cursor

Ctrl+W

Cut the current word before the cursor

Ctrl+Y

Paste the previous cut text

Alt+Y

Paste the second latest cut text

Alt+Ctrl+Y

Paste the first argument of the previous command

Alt+.or_

Paste the last argument of the previous command

History

Ctrl+P

Move to the previous line

Altl+N

Move to the next line

Ctrl+S

Search

Ctrl+R

Reverse search

Ctrl+J

End search

Ctrl+G

Abort search (restores original line)

Alt+R

Restores all changes made to line

Completion

Tab

Auto-complete a name

Altl+?

List all possible completions

Alt+*

Insert all possible completions

> X11

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Keyboard Shortcut          Description
  -------------------------- ------------------------------------------------------------------------------------------------------------------------------------
  Ctrl+Alt+F1, F2, F3, ...   Switch to n-th virtual console

  Ctrl+Alt++/-               Switch to higher/lower available resolutions

  Ctrl+Alt+Backspace         Kills X-server (This may not work for recent updates.)

  Ctrl+⇑ Shift+Num Lock      Toggles keyboard mouse; uses numpad, mouse click is done by 5, use /, *, and -to switch the click to left, middle, and right click

  Shift+Insert               Copy selected text to clipboard, or paste from clipboard
   Mouse Button 3            
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

xkeyboard-config disable keyboard mouse by default after the version
2.0.1.To enable it, changing the following line in
/usr/share/X11/xkb/symbols/pc:

    key <NMLK> { [ Num_Lock ] }; 

back to as it was in version 2.0.1:

    key <NMLK> { [ Num_Lock, Pointer_EnableKeys ] }; 

> Links

-   Linux Newbie Administrator Guide - Shortcuts and Commands
-   The Linux keyboard and console HOWTO

User Customization
------------------

> Readline

This example adds keys that allow (in vi-mode) to search backward
through the history for the string of characters between the start of
the current line and the point. This is a non-incremental search.

    .inputrc

    set editing-mode vi
    set keymap vi-insert
    "\C-r": history-search-backward
    "\C-e": history-search-forward

> X11

Modifying the Keyboard Layout

This example changes the CapsLock key to only activate caps lock when
the Shift key is also pressed

    .xinitrc

    xmodmap -e 'keycode  66 = NoSymbol Caps_Lock Caps_Lock'

The keycode of the CapsLock key can be found in the output of
xmodmap -pk

Key Binding for X-Selection-Paste

Users who prefer to work rather with the keyboard than the mouse may
benefit from a key binding to the paste operation of the middle mouse
button. This is especially useful in a keyboard-centered environment. A
workflow example is:

1.  In Firefox, select a string you want to google for (with the mouse).
2.  Hit Ctrl+k to enter the "Google search" field.
3.  Hit F12 to paste the buffer, instead of moving the mouse pointer to
    the field and center-click to paste.

The method suggested here uses three packages available in the official
repositories:

-   xsel to give access to the x-selection-buffer content.
-   xbindkeys to bind a key-stroke to an action.
-   xvkbd to pass the buffer string to the application by emulating
    keyboard input.

This example binds the x-selection-paste operation to the F12 key:

    .xbindkeysrc

    "xvkbd -no-jump-pointer -xsendevent -text "\D1`xsel`" 2>/dev/null"
        F12

The "\D1" code prefixes a 100 ms pause to inserting the selection buffer
(see the xvkbd home page).

Note:Depending on your X configuration, you may need to drop the
-xsendevent argument to xvkbd.

The key codes for keys other than F12 can be determined using
xbindkeys -k.

See Also:

-   Pasting X selection (not clipboard) contents with keyboard
-   xvkbd home page

> Firefox

Use the customizable-shortcuts add-on.

Tips
----

-   If you like a keyboard-centered workflow, you might also appreciate
    a tiling window manager, like Xmonad.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keyboard_Shortcuts&oldid=255540"

Categories:

-   Keyboards
-   X Server
-   Accessibility
