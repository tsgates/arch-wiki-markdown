Cursor Themes
=============

There are many cursor themes available besides the default black
pointer. This guide will instruct you on where to get them, installing
them, and configuring them.

Contents
--------

-   1 Getting mouse cursor themes
-   2 Installing mouse cursor themes
-   3 Note on cursor themes not working with awesome window manager
-   4 Choosing and configuring cursor themes
    -   4.1 Using the XDG Icon theme specification
    -   4.2 With Gnome 3.8
    -   4.3 Using X resources
-   5 See also

Getting mouse cursor themes
---------------------------

First, check which themes you already have installed:

    ls /usr/share/icons/*

Search for directories with the cursors subdirectory.

    find /usr/share/icons -type d -iname "*cursors*"

Also, check the official Arch repositories for cursor themes: search
"xcursor-".

Note: The xcursor-themes package comes with the 'redglass' and
'whiteglass' themes in /usr/share/icons.

Some themes available through AUR.

Here are links to where else you may download cursor:

-   KDE Look
-   Customize.org

Installing mouse cursor themes
------------------------------

This manual installation method is only required if you are not using
pacman to install themes like described above.

Extract the cursor theme package:

    $ tar -zxvf foobar-cursor-theme-package-foo.tar.gz

or

    $ tar -jxvf foobar-cursor-theme-package-foo.tar.bz2

Make a directory for the cursor theme:

Example: FooBar-AweSoMe-Cursors-v2.98beta

User-specific installation:

    $ mkdir -p ~/.icons/foobar/cursors

System-wide installation:

    # mkdir -p /usr/share/icons/foobar/cursors

Note: To simplify the name of the theme, the name being used is 'foobar'
instead of 'FooBar-AweSoMe-Cursors-v2.98beta' when creating the dir(s)
above.

Copy cursor files into the appropriate directory:

User-specific installation:

    $ cp -a FooBar-AweSoMe-Cursors-v2.98beta/cursors/* ~/.icons/foobar/cursors/

System-wide installation:

    # cp -a FooBar-AweSoMe-Cursors-v2.98beta/cursors/* /usr/share/icons/foobar/cursors/

If the package includes index.theme file check if there is an "Inherits"
line inside. If yes, check whether the inherited theme also exists under
this name in your system (rename if needed).

Copy index.theme file into the appropriate directory:

User-specific installation:

    $ cp -a FooBar-AweSoMe-Cursors-v2.98beta/index.theme ~/.icons/foobar/index.theme

System-wide installation:

    # cp -a FooBar-AweSoMe-Cursors-v2.98beta/index.theme /usr/share/icons/foobar/index.theme

If the package does not have index.theme or if it does not include an
"Inherits" line, you do not have to copy this file.

Create links to missing cursors:

Applications may keep using the default cursors when a theme lacks some
cursors. If you experience this, it can be corrected by adding links to
the missing cursors. For example:

    $ cd ~/.icons/foobar/cursors/
    $ ln -s right_ptr arrow
    $ ln -s cross crosshair
    $ ln -s right_ptr draft_large
    $ ln -s right_ptr draft_small
    $ ln -s cross plus
    $ ln -s left_ptr top_left_arrow
    $ ln -s cross tcross
    $ ln -s hand hand1
    $ ln -s hand hand2
    $ ln -s left_side left_tee
    $ ln -s left_ptr ul_angle
    $ ln -s left_ptr ur_angle
    $ ln -s left_ptr_watch 08e8e1c95fe2fc01f976f1e063a24ccd

If the above links do not resolve the problem, look in
/usr/share/icons/whiteglass/cursors for additional cursors your theme
may be missing, and create links for them as well.

Note on cursor themes not working with awesome window manager
-------------------------------------------------------------

Xcursor does not work correctly with awesome window manager. You may
notice all of the themed cursors work except the default cursor.

For more information see this link
http://awesome.naquadah.org/wiki/FAQ#How_to_change_the_cursor_theme.3F

Choosing and configuring cursor themes
--------------------------------------

If you use some desktop environment like Gnome, you can use its GUIs to
choose cursor themes. Alternatively you can use lxappearance to manage
and apply cursor themes.

> Using the XDG Icon theme specification

Note:This method will set both the X11 and Wayland cursor theme.

You can create a symlink "default" in ~/.icons, which points to your
installed cursor theme:

    $ ln -s /usr/share/icons/foobar/ ~/.icons/default

If you rather want to change the cursor globally (e.g. used by graphical
login managers like kdm, gdm, ...), or if you experience problems with
above method (for example in Firefox), create the
/usr/share/icons/default/ directory (only if needed):

    # mkdir -p /usr/share/icons/default  (only if needed)

Edit or create the /usr/share/icons/default/index.theme file and add the
following:

    [icon theme] 
    Inherits=foobar

Or if you have/want your cursor themes in ~/.icons only. Create the
~/.icons/default/ directory:

    $ mkdir -p ~/.icons/default

And create the ~/.icons/default/index.theme file with the same contents
as above /usr/share/icons/default/index.theme.

> With Gnome 3.8

To change the cursor theme with Gnome 3.8, run the following command:

    gsettings set org.gnome.desktop.interface cursor-theme foobar

Or alternatively, use the dconf-editor to change the given key manually
to the name of the theme.

That will change the theme of the user, but not the one used in GDM. To
change the cursor theme in the greeter create the file
/etc/dconf/db/gdm.d/10-cursor-settings with content:

     [org/gnome/desktop/interface]
     cursor-theme='foobar'

And run as root the following command:

    dconf update

> Using X resources

To locally name a cursor theme, add to your ~/.Xresources:

    Xcursor.theme: foobar

To have the cursor theme properly loaded it will need to be called by
your window manager. If it does not, you can force it to load prior your
window manager by putting the following command in ~/.xinitrc or
.xprofile (depending on your setup):

    $ xrdb ~/.Xresources &

You can optionally add this line to ~/.Xresources if your cursor theme
supports multiple sizes:

    Xcursor.size:  16       !  32, 48 or 64 may also be good values

If you do not know about supported cursor sizes just start X without
this setting and let it choose the cursor size automatically.

Refer to your window manager documentation for details.

See also
--------

For more information about cursors in X (supported directories, formats,
compatibility, etc.) refer to the manual page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cursor_Themes&oldid=294221"

Category:

-   X Server

-   This page was last modified on 24 January 2014, at 08:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
