Keyboard Shortcuts
==================

This article provides a list of (not commonly known) default keyboard
shortcuts and provides information about user customization.

Contents
--------

-   1 Standard shortcuts
    -   1.1 Kernel
    -   1.2 Terminal
        -   1.2.1 Virtual console
        -   1.2.2 Readline
    -   1.3 X11
-   2 User customization
    -   2.1 Readline
    -   2.2 X11
    -   2.3 Firefox
    -   2.4 Key binding for X-selection-paste
-   3 Tips and tricks
-   4 See also

Standard shortcuts
------------------

> Kernel

These are low level shortcuts that are considered to be used for
debugging. Whenever possible, it is recommended to use these instead of
doing a hard shutdown (holding power button to shutdown the
motherboard).

Must be activated first with echo "1" > /proc/sys/kernel/sysrq or if you
wish to have it enabled during boot, edit /etc/sysctl.d/99-sysctl.conf
and set kernel.sysrq = 1

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
  --------------------- -----------------------------------------------------------------------------------------
  Ctrl+Alt+Del          Reboots Computer (specified by the symlink /usr/lib/systemd/system/ctrl-alt-del.target)
  Alt+F1, F2, F3, ...   Switch to n-th virtual console
  Alt+ ←                Switch to previous virtual console
  Alt+ →                Switch to next virtual console
  Scroll Lock           When Scroll Lock is activated, input/output is locked
  Shift+PgUp/PgDown     Scrolls console buffer up/down
  Ctrl+c                Kills current task
  Ctrl+d                Inserts an EOF
  Ctrl+z                Pauses current Task

Readline

GNU readline is a commonly used library for line-editing; it is used for
example by Bash, FTP, and many more (see the details of readline package
under "Required By" for more examples). readline is also customizable
(see man page for details).

Keyboard Shortcut

Description

Ctrl+l

Clear the screen

Cursor Movement

Ctrl+b

Move cursor one character to the left

Ctrl+f

Move cursor one character to the right

Alt+b

Move cursor one word to the left

Alt+f

Move cursor one word to the right

Ctrl+a

Move cursor to start of the line

Ctrl+e

Move cursor to end of the line

Copy & Paste

Ctrl+u

Cut everything from line start to cursor

Ctrl+k

Cut everything from the cursor to end of the line

Alt+d

Cut the current word after the cursor

Ctrl+w

Cut the current word before the cursor

Ctrl+y

Paste the previous cut text

Alt+y

Paste the second latest cut text

Alt+Ctrl+y

Paste the first argument of the previous command

Alt+./_

Paste the last argument of the previous command

> History

Ctrl+p

Move to the previous line

Alt+n

Move to the next line

Ctrl+s

Search

Ctrl+r

Reverse search

Ctrl+j

End search

Ctrl+g

Abort search (restores original line)

Alt+r

Restores all changes made to line

> Completion

Tab

Auto-complete a name

Alt+?

List all possible completions

Alt+*

Insert all possible completions

> X11

  -------------------------------------------------------------------------------------
  Keyboard Shortcut          Description
  -------------------------- ----------------------------------------------------------
  Ctrl+Alt+F1, F2, F3, ...   Switch to n-th virtual console

  Shift+Insert               Copy selected text to clipboard, or paste from clipboard
   Mouse Button 3            
  -------------------------------------------------------------------------------------

User customization
------------------

> Readline

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Readline.   
                           Notes: This section      
                           duplicates content of    
                           the main article.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This example adds keys that allow (in vi-mode) to search backward
through the history for the string of characters between the start of
the current line and the point. This is a non-incremental search.

    .inputrc

    set editing-mode vi
    set keymap vi-insert
    "\C-r": history-search-backward
    "\C-e": history-search-forward

> X11

See Keyboard Configuration in Xorg#Frequently used XKB options for some
common shortcuts, that are disabled by default.

> Firefox

Use the customizable-shortcuts add-on.

> Key binding for X-selection-paste

Users who prefer to work rather with the keyboard than the mouse may
benefit from a key binding to the paste operation of the middle mouse
button. This is especially useful in a keyboard-centered environment. A
workflow example is:

1.  In Firefox, select a string you want to google for (with the mouse).
2.  Hit Ctrl+k to enter the "Google search" field.
3.  Hit F12 to paste the buffer, instead of moving the mouse pointer to
    the field and center-click to paste.

Note:Shift+Insert has a similar yet different functionality, see #X11:
Shift+Insert inserts the clipboard buffer, not the x-selection-paste
buffer. In some applications, these two buffers are mirrored.

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

> References:

-   Pasting X selection (not clipboard) contents with keyboard
-   xvkbd home page

XMonad Window Manager In the xmonad window manager there is a built-in
function to paste the x-selection-buffer content. In order to bind that
function to a key-stroke (here Insert key) the following configuration
can be used:

    xmonad.hs

    import XMonad.Util.Paste
    ...
      -- X-selection-paste buffer
      , ((0,                     xK_Insert), pasteSelection) ]

Tips and tricks
---------------

-   If you like a keyboard-centered workflow, you might also appreciate
    a tiling window manager.

See also
--------

-   Linux Newbie Administrator Guide - Shortcuts and Commands
-   The Linux keyboard and console HOWTO

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keyboard_Shortcuts&oldid=301745"

Categories:

-   Keyboards
-   X Server
-   Accessibility

-   This page was last modified on 24 February 2014, at 15:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
