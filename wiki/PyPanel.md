PyPanel
=======

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: No explanation   
                           of what it does          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Launchers                                                    |
|                                                                          |
| -   3 Tips and tricks                                                    |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install pypanel, available in the Official Repositories.

Configuration
-------------

Although pypanel is lightweight, it still has a lot of features that can
be configured in the .pypanelrc file. This file is created in your home
directory the first time pypanel is run.

To run pypanel simply type:

    $ pypanel

To start pypanel automatically see xinitrc or Autostart applications.

Now that we have a default configuration file in our home directory we
can edit the behavior of pypanel. The ~/.pypanelrc file is actually a
Python script, and therefore requires correct Python syntax and
formatting. The file is well commented, so rather than duplicating it,
here are some suggestions:

    BG_COLOR        = "0xfaebd7"    # Panel background and tint (Antique White)
    TASK_COLOR      = "0xffffff"    # Normal task name color
    DESKTOP_COLOR   = "0xffffff"    # Desktop name color
    CLOCK_COLOR     = "0xffffff"    # Clock text color

    TASK_SHADOW_COLOR      = "0x000000"
    FOCUSED_SHADOW_COLOR   = "0x000000"
    SHADED_SHADOW_COLOR    = "0x000000"
    MINIMIZED_SHADOW_COLOR = "0x000000" 
    DESKTOP_SHADOW_COLOR   = "0x000000"
    CLOCK_SHADOW_COLOR     = "0x000000"

    SHADE           = 64

    ABOVE           = 1             # Panel is always above other apps
    APPICONS        = 1             # Show application icons
    AUTOHIDE        = 0             # Autohide uses the CLOCK_DELAY timer above
    SHADOWS         = 1             # Show text shadows
    SHOWLINES       = 0             # Show object separation lines
    SHOWBORDER      = 1             # Show a border around the panel

Many other settings can be changed. These examples only illustrate some
of the visual options available. Mouse clicks and other behavior can be
also adjusted according preference. Read the comments and experiment.

> Launchers

If you wish to add Launchers to PyPanel, you will have to enable the
launcher in the Panel Layout section.

     # Panel Layout:
     # ...
     DESKTOP    = 1
     TASKS      = 3
     TRAY       = 4
     CLOCK      = 5
     LAUNCHER   = 2

And then add your launch commands in the LAUNCH_LIST section. The first
part is the command to run, the second part is a full path to the icon
to display.

     LAUNCH_LIST  = [
                ("firefox", "/usr/lib/firefox-3.0.1/icons/mozicon16.xpm"),
                ("thunar", "/usr/share/icons/oxygen/16x16/apps/system-file-manager.png"),
                ("urxvt -bg black -fg grey", "/usr/share/icons/oxygen/16x16/apps/terminal.png"),
                ]

Take a look around /usr/share/icons for icons to use for your
applications.

Tips and tricks
---------------

If you want to make the mouse click act more traditionally, find the
following lines in .pypanelrc:

    #-------------------------------------
    def taskButtonEvent(pp, button, task):
    #-------------------------------------
       """ Button event handler for the panel's tasks """
       
       if button == 1:
           pp.taskFocus(task)
       

and then, add the last line once again, so that it looks like this:

    #-------------------------------------
    def taskButtonEvent(pp, button, task):
    #-------------------------------------
       """ Button event handler for the panel's tasks """
       
       if button == 1:
           pp.taskFocus(task)
           pp.taskFocus(task)

If pypanel yields an error about non-existing .Xauthority file, create
it:

    $ touch ~/.Xauthority

See also
--------

-   PyPanel SourceForge page

Retrieved from
"https://wiki.archlinux.org/index.php?title=PyPanel&oldid=205188"

Categories:

-   Application launchers
-   Eye candy
