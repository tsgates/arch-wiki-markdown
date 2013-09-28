DOSBox
======

DOSBox is an x86 PC DOS-emulator for running old DOS games or programs.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Tips                                                               |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install dosbox, available in the Official Repositories.

Configuration
-------------

No initial configuration is needed, however the official DOSBox Manual
refers to a configuration file named "dosbox.conf". By default that file
exists in your ~/.dosbox folder.

You can also make a new configuration file on a per-application basis by
copying dosbox.conf from ~/.dosbox to the directory where your DOS app
resides and modifying the settings accordingly. You can also create a a
config file automatically as follows:

To create the file, simply run dosbox without any parameters inside your
desired application's folder:

    $ dosbox

Then at the DOS prompt, type:

    Z:\> config -wc dosbox.conf

The configuration file "dosbox.conf" will then be saved in the current
directory. Go in a change whatever settings you need.

The configuration options are described in the official DosBox wiki:
http://www.dosbox.com/wiki/Dosbox.conf

Usage
-----

A simple way to run dosbox is to place your DOS game (or its setup
files) into a directory and then run dosbox with the directory path
appended. For example:

    $ dosbox ./game-folder/

You should now have a DOS prompt whose working directory is the one
specified above. From there, you can execute the desired program(s):

    C:\> SETUP.EXE

Tips
----

If dosbox traps your focus, use CTRL-F10 to free it.

See also
--------

For more information visit the official DOSBox site:
http://www.dosbox.com/

Abandonia - A large repository of old and abandoned DOS games
DosGames.com - A large repository of DOS games

Retrieved from
"https://wiki.archlinux.org/index.php?title=DOSBox&oldid=212729"

Categories:

-   Emulators
-   Gaming
