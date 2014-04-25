LightScript
===========

LightScript is a script used to control a screens backlight brightness,
it is lightweight, zlib-licensed and written by Fredrik Haikarainen.

Warning:LightScript has now officially been deprecated, and replaced by
its successor, and C-port, Light.

Contents
--------

-   1 Features
-   2 Installation
-   3 Usage
-   4 Bugs/Feedback

Features
--------

LightScript is a "light" (read minimal) script that does one thing and
does that thing well; Sets the screen brightness based off a value given
in percent. It has the following features:

-   Automatically finds the controller with the best resolution, and
    uses it to set the brightness.
-   If sudo is installed, it attempts to use it. Since the script needs
    root, I thought it would be nice to skip the "sudo"-part when using
    it.
-   Uses a minimum cap of 5% lightness as standard, which can be easily
    changed using the /etc/lightscript/minlight file. (Some controllers
    will turn the screen pitchblack on 0%)
-   Is very forgiving on "bad systems", while still doing a lot of
    safety-checks.

Installation
------------

It is available on AUR where it goes by the name lightscript, the only
dependency it needs is bash (which you should already have installed
really). An optional dependency is sudo, which it will automatically try
to use if it can find it (so you wont have to type "sudo light x"
everytime). All dependencies are available in the official repos.

Usage
-----

LightScript takes 1 argument and 1 argument only: The brightness you
would like, given in percent (without the %). Example:

    light 30

to use 30% brightness. Remember the script needs either root or writable
permissions on backlight controllers, although if you have sudo
installed it will attempt to use this automatically(you do not need to
invoke it).

A new feature in 0.3.6 is operators for dynamic brightness-changes, that
means you can now type:

    light 5+

to increase brightness with 5% instead of setting a fixed value.

  
 The script has a minimum cap of 5% brightness since some controllers
will turn the screen pitchblack on 0%, override this in
/etc/lightscript/minlight.

Bugs/Feedback
-------------

Please give bugs/feedback either directly on the AUR-page comments, or
via mail to fredrik dot haikarainen at gmail dot com.

Retrieved from
"https://wiki.archlinux.org/index.php?title=LightScript&oldid=235904"

Categories:

-   Power management
-   Scripts

-   This page was last modified on 18 November 2012, at 15:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
