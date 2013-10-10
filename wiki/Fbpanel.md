Fbpanel
=======

> Summary

fbpanel is a lightweight NETWM compliant desktop panel. This article
describes the installation and configuration of fbpanel.

Official Site

fbpanel.sourceforge.net

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Starting                                                           |
| -   3 Configuration                                                      |
|     -   3.1 wincmd plugin (show desktop button)                          |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

Install the fbpanel package from the official repositories.

Starting
--------

If you want to start fbpanel with your X session, add the following line
to your .xinitrc, before the line where you start your window manager.

    fbpanel &

Configuration
-------------

You can find the configuration file in ~/.config/fbpanel

If it doesn't exist, copy over the default configuration file:

    # mkdir ~/.config/fbpanel
    # cp /usr/share/fbpanel/default ~/.config/fbpanel

> wincmd plugin (show desktop button)

This plugin is enabled by default, but it might not show up because it
cannot find an existing icon. In that case, change the icon path to one
that points to an existing icon. You can also use an image as its icon.
In that case, replace the "icon" key with "image".

    Plugin {
       type = wincmd
       config {
           image = ~/images/my_image.png
           tooltip = Left click to iconify all windows. Middle click to shade them.
       }
    }

See also
--------

-   Official Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fbpanel&oldid=246120"

Categories:

-   Application launchers
-   Status monitoring and notification
