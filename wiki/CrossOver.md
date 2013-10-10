CrossOver
=========

> Summary

Configuring and installing CrossOver on Archlinux.

> Related

Wine

CrossOver is the paid, commercialized version of Wine which provides
more comprehensive end-user support. It includes scripts, patches, a
GUI, and third-party software which may never be accepted in the Wine
Project. This combination makes running Windows programs considerably
easier for those aren't so tech-savvy.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Multi-user       
                           installs, other desktop  
                           environments, older      
                           versions (if             
                           applicable). (Discuss)   
  ------------------------ ------------------------ ------------------------

Installing Crossover Linux
--------------------------

Tested with trial install-crossover-11.2.1.bin

-   Ensure python-dbus-common, pygtk and python2-dbus are installed.

-   Run # ln -sf /usr/bin/python2 /usr/bin/python

-   Finally $ ./install-crossover-*.bin for single user.

Using CrossOver
---------------

Assuming it was installed as user, Crossover binaries should be located
in ~/cxoffice.

Some desktop environments like KDE may have automatically placed menu
entries as part of the installation process.

Installed programs should be located under a new menu entry called
Window Applications.

Tip: If you get a registration failure, try:
# /opt/cxoffice/bin/cxregister. Registration should then complete and be
valid for all users on the system.

Retrieved from
"https://wiki.archlinux.org/index.php?title=CrossOver&oldid=253519"

Categories:

-   Wine
-   Gaming
