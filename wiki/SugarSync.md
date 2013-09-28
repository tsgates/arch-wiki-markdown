SugarSync
=========

SugarSync is a file sync and online backup tool similar to Dropbox.
Unfortunately, there is no native Linux client available. However, it
works well through wine.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running the file manager                                           |
| -   3 Quick start guide                                                  |
| -   4 An update window popped up                                         |
+--------------------------------------------------------------------------+

Installation
------------

First, install wine in order to run win32 applications:

    # sudo pacman -S wine wine_gecko lib32-mpg123 lib32-libxml2 lib32-openal lib32-libpng

You will also need this package from the [multilib] repository:

    # sudo pacman -S lib32-libldap

Once the packages are installed, as a regular user run winecfg (win32)

    # WINEARCH=win32 winecfg

You can keep the default options. Get the SugarSync executable from the
SugarSync website and run it through wine:

    # wine SugarSyncSetup.exe

Follow the instructions while keeping the default options. When done,
uncheck the box "Run SugarSync" and click finish.

Running the file manager
------------------------

After installation, you should find the SugarSync icon on your desktop
or in the start-up menu. They are just links that invoke the following
command:

    # env WINEPREFIX=$HOME"/.wine" wine C:\\windows\\command\\start.exe /Unix $HOME/.wine/dosdevices/c:/users/Public/Desktop/SugarSync\ Manager.lnk

If the installation went right, the "SugarSync Login" window just show.
If not, look if you followed the installation instructions correctly.

Quick start guide
-----------------

Follow the Windows instructions in the official Quick start guide.

An update window popped up
--------------------------

In the case where an update window pops up, you can accept or cancel the
installation, as you wish. There is nothing more to do than waiting for
the download and update to finish.

Retrieved from
"https://wiki.archlinux.org/index.php?title=SugarSync&oldid=228615"

Category:

-   Networking
