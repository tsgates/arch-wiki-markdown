Gnome Color Chooser
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

GNOME's color schemes are editable easily via the ~/.gtkrc-2.0 file, but
the GNOME color chooser makes this process easier and graphical.

Contents
--------

-   1 Installation
-   2 Tips and Tricks
    -   2.1 Global
        -   2.1.1 Default Normal
        -   2.1.2 Default Entry Fields
    -   2.2 Buttons
        -   2.2.1 Buttons
        -   2.2.2 Comboboxes
    -   2.3 Panel
        -   2.3.1 Panel
        -   2.3.2 Start Menu
    -   2.4 Desktop
    -   2.5 Specific
        -   2.5.1 Window Decoration
        -   2.5.2 Scrollbars
        -   2.5.3 Progress Bars
        -   2.5.4 Tooltips
        -   2.5.5 Links
    -   2.6 Icons
    -   2.7 Engines

Installation
------------

Install gnome-color-chooser from the AUR.

Tips and Tricks
---------------

This should be an outline of what each of the fields affect, determined
by trial-and-error. Know that this affects the local user's setup and
thus this will likely override the related default configurations set by
files earlier in the preference list (i.e. /usr/share/ or /etc/).

> Global

     These affect all programs (hence global) that use the current coloring scheme via the GTK interface.

Default Normal

These affect standard items that are click and choose or are entirely
static.

normal: foreground = standard text; i.e. font color of "Default
Configuration"

normal: background = area surrounding standard text; i.e. background
color surrounding all the buttons and standard text

hover: foreground = text of selectable items when hovering; i.e. font
color of visible drop down menu item, date and time font color during
hover

hover: background = background of selectable items when hovering; i.e.
drop down menus prior to clicking

selected: foreground = Unknown

selected: background = color of items indicating currently active area;
i.e. scrollbars, tab covers

active: forground = text of selectable items that are available (as
opposed to the selected item); i.e. not currently selected tabs

active: background = background of selectable items that are available
(as opposed to the selected item); i.e. not currently selected tabs

disabled: foreground = text of not selectable items; i.e. typically
grayed out selectable items

disabled: background = background of not selectable items; i.e.
typically grayed out selectable items

Default Entry Fields

These affect areas that require user input.

normal: foreground = fonts/items placed in user input fields; i.e. color
of checks in checkboxes, text color in drop-down menu widgets

normal: background = area of the entry field; i.e. background color
contained in text boxes, check boxes, etc.

hover: foreground = text of selectable input items when hovering; i.e.
drop down menu font items during selection

hover: background = Unknown

selected: foreground = text of currently user-selected item(s); i.e.
font of currently selected file in a browser window

selected: background = background of currently user-selected item(s);
i.e. highlight of currently selected file in a browser window

active: forground = text of selectable items that are available (as
opposed to the selected item); i.e. not currently items in a browser
window

active: background = background of selectable items that are available
(as opposed to the selected item); i.e. not currently selected items in
a browser window

disabled: foreground = text of unavailable user input fields; i.e.
unchangeable text box font

disabled: background = background of unavailable user input fields; i.e.
unchangeable text box background

> Buttons

These affect the button widgets that are used, such as the standard
"Close" and "Apply" buttons as well drop down lists.

Buttons

The buttons akin to "Close" and "Apply", the "Go" and "Search" buttons
on the left of this page

Comboboxes

The visible drop-down menu item.

> Panel

These affect the items in panels that are used by the system (note, not
just gnome-panel, but any panels that use the .gtkrc-2.0 file)

Panel

These affect standard panel, such as the gnome-panel

Start Menu

These affect the Main GNOME Menu, and imaginably other primary menus

> Desktop

These affect the items on the desktop (i.e. the "Computer" icon)

> Specific

Window Decoration

These affect the coloring of the window title bars when using the GTK
window decorator

Scrollbars

These affect the scrollbars used in the GTK applications, such as to the
right of this text.

Progress Bars

Purportedly, these affect the progress bars used in GTK applications,
though none come to mind. Likely requires the GTK window decorator.

Tooltips

Likely requires the GTK window decorator, changes the tooltop colors.

Links

Likely requires the GTK window decorator, imaginably changes link
colors.

> Icons

Allow you to change icon sizes, as of the time of this writing.

> Engines

Advanced: (presumably) Allows you to select "engines" for each subset.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gnome_Color_Chooser&oldid=279712"

Category:

-   Eye candy

-   This page was last modified on 25 October 2013, at 16:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
