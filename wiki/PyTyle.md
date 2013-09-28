PyTyle
======

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

PyTyle is a tiling manager that works with EWMH-compliant window
managers (like Openbox and KWin) to provide functions for tiling
windows. Both Xmonad and Musca have influenced the feature set.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Execution                                                          |
| -   3 Configuration                                                      |
| -   4 Gaps between terminals                                             |
+--------------------------------------------------------------------------+

Installation
------------

PyTyle is currently not available from the Arch official repositories.

-   PyTyle — An automatic tiler that is compatible with Openbox
    Multihead

http://pytyle.com/ || pytyle

-   PyTyle2 — Auto/manual on-demand tiling manager that fits in any EWMH
    compatible window manager.

http://pytyle.com/ || pytyle2-hg

-   PyTyle3 — An automatic tiler that is compatible with Openbox
    Multihead with faster action and lower memory footprint.

http://pytyle.com/ || pytyle3-git

Note:Any can be installed on the same system, although only one can be
run at the same time.

Execution
---------

After installation, PyTyle can be run simply by entering this into the
terminal:

    pytyle

Alternatively, if you want to run PyTyle2 or PyTyle3, you would run

    pytyle2

or

    pytyle3

After that, simply press Alt + A(default keybind).

Configuration
-------------

-   PyTyle2

After you have started PyTyle for the first time, a new configuration
directory should appear in your $XDG_CONFIG_HOME directory (usually
~/.config/) called pytyle2. Inside this directory is config.ini. All of
the configuration options are stored there.

Warning: The options haven't really been documented yet, so your guess
will have to do at the moment.

-   PyTyle3

You need to create pytyle3 directory in your $XDG_CONFIG_HOME directory
and the configs in /etc/xdg/pytyle3/ can be a base of your custom
configuration. All these configuration are in Python2, it is easy to
understand and to edit. But if you make any gramma error or something
like that, it will cause pytyle3 fail to start with a backtrace.

Gaps between terminals
----------------------

Depending on your window manager, some gaps may appear between the
windows when a terminal is launched. This is due to the imposed size of
some terminal emulators. Using Urxvt, install the patched package
rxvt-unicode-noinc from the AUR. Using Terminator, disable the "Window
Geometry Hint" checkbox in the main options.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PyTyle&oldid=235332"

Category:

-   Tiling WMs
