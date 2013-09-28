Avant Window Navigator
======================

Summary

This article discusses how to install and use Avant Window Navigator
(AWN).

Related

GNOME

Avant Window Navigator (AWN) is a lightweight dock written in C. It has
support for launchers, task lists and third party applets.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Additional dependencies                                      |
|     -   1.2 Compositing                                                  |
|                                                                          |
| -   2 Usage                                                              |
| -   3 Configuration                                                      |
| -   4 Tips and tricks                                                    |
|     -   4.1 External applets                                             |
|         -   4.1.1 DockbarX                                               |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

-   Avant Window Navigator can be installed with the package
    avant-window-navigator, available in the official repositories.
-   To get additional applets to use with AWN you will need to install
    awn-extras-applets.

> Additional dependencies

The most of the applets require some additional packages, which are
listed in optdepends. Make sure that you installed them before enable an
applet:

  ------------------ ------------------------------------------------ ----------------------
  Applet name        Dependencies                                     Optional dependences
  animal-farm        fortune-mod                                      
  battery            upower                                           
  comics             python2-feedparser python2-rsvg                  
  cairo-clock        python2-rsvg                                     python2-dateutil
  calendar           python2-dateutil python2-gdata python2-vobject   
  cpufreq            gnome-applets                                    
  dialect            python-xklavier                                  
  feeds              python2-feedparser                               
  hardware-sensors   python2-rsvg                                     hddtemp lm_sensors
  media-control                                                       banshee
  media-player       gstreamer0.10-python                             
  mail               python2-feedparser                               
  slickswitcher      python2-wnck                                     python2-gconf
  stacks             python2-libgnome python2-gnomedesktop            
  thinkhdaps                                                          python2-pyinotify
  tomboy-applet      tomboy                                           
  volume-control     gstreamer0.10-python                             
  ------------------ ------------------------------------------------ ----------------------

> Compositing

To fully utilize AWN and it's themes, you will need a composite manager
like Compiz, Xcompmgr or Cairo Compmgr installed and configured
correctly. If you are running AWN in a desktop environment like GNOME,
Xfce or KDE, simply enable the composite manager or the desktop effects
in the system settings. The composite option in X is enabled by default.

Usage
-----

Run Awn in the background:

    $ avant-window-navigator &

To launch AWN at startup, check Start Awn automatically option in Dock
Preferences dialog (see below), or add the following command to the
autostart file: avant-window-navigator --startup &

Configuration
-------------

To configure AWN applets, themes and general settings, run:

    $ awn-settings

or right-click the dock and go to Dock Preferences.

Tips and tricks
---------------

> External applets

DockbarX

You may want to try DockbarX, a task manager applet with advanced
behaviour configuration and support for window previews. It is available
from the AUR: dockbarx.

See also
--------

-   AWN on Launchpad

Retrieved from
"https://wiki.archlinux.org/index.php?title=Avant_Window_Navigator&oldid=235592"

Categories:

-   Application launchers
-   Eye candy
