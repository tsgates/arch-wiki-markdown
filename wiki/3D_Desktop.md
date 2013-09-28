3D Desktop
==========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:3d-desktop has not been in development for some time. Latest
version is from mid 2005. Compiz or KDE's Kwin are probably a better
idea at this point.

3D Desktop is an older piece of eye-candy similar in functionality to
the Cube plugin in Compiz. Simply put it is a pager which remains in the
background until needed and allows the user to switch between desktops
while viewing them in 3D. While not as robust as Compiz it provides the
same sort of functionality to people using otherwise lightweight
window-managers such as Fluxbox. In the same vein as the Xcompmgr
alternative to composite management in *box WMs, 3ddesk offers a nice
slice of eye-candy to those who do not wish to run Compiz.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Troubleshooting                                                    |
| -   5 Additional Resources                                               |
+--------------------------------------------------------------------------+

Prerequisites
-------------

The following need to be installed before 3D Desktop

-   Xorg

You should have most other dependencies once these are installed and if
you are using Fluxbox. Otherwise other dependencies will need to be
installed by pacman as well.

Installation
------------

3ddesktop can be found on the AUR.

Configuration
-------------

After installation running:

    $ 3ddeskd&

will set the daemon running in the background. Further invocation of:

    $ 3ddesk

results in the screen 'zooming out' to reveal all of the virtual
desktops, though unconfigured they will appear grey rectangles until
'zoomed in' on and subsquently zoomed out from once more. You can add
3ddeskd to Daemons in /etc/rc.conf if you like but just using the 3ddesk
command will start the daemon in the background.

In /etc/3ddesktop/3ddesktop.conf you will find instructions on
configuring the pager's various basic functions, which I find most
useful when tied to a hotkey of some kind. A great deal about 3ddesk can
be tweaked, including the background used, the frequency of desktop
acquisition(which fixes the grey rectangle problem), the mode, the
zoomspeed and others. An arbitrary number of views can be defined as
well, carrying out any number of tasks that the program offers.

For Fluxbox users adding the line

     Mod4 z :exec 3ddesk

to .fluxbox/keys, for instance, will enable the WindowsKey-Z combination
to execute 3ddesk.

Troubleshooting
---------------

For information on some of the problems refer to the FAQ. Some hardware
has been known to have issues capturing desktops so it is good to
consult the FAQ for any help it might give.

Most important is telling 3ddesk specifically which Window-Manager you
are using. In the configuration file, in every view you use in that WM
specify that manager with the line:

    wm fluxbox

Additional Resources
--------------------

-   Xcompmgr
-   Compiz
-   3DDesk Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=3D_Desktop&oldid=206337"

Category:

-   Eye candy
