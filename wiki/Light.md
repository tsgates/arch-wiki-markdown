Light
=====

Light is a program used to easily control a screens
backlight-controllers. It is the successor of LightScript, and is also
its official C-port.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Installation                                                       |
| -   3 Usage                                                              |
| -   4 Bugs/Feedback                                                      |
+--------------------------------------------------------------------------+

Features
--------

Light is a bit heavier than LightScript, but still pretty minimal. It
features:

-   Written in ANSI-C89 for ũber-portability and speed!
-   Automatically finds the controller with the best resolution, and
    uses it to set the brightness.
-   Uses a minimum cap of 5% lightness as standard, which can be easily
    changed using the /etc/light/minlight file. (Some controllers will
    turn the screen pitchblack on 0%)
-   Is very forgiving on "bad systems", while still doing a lot of
    safety-checks. Also allows you to override the controller-detection
    and decide what controller you would like to use by the
    /etc/light/override-file.

Installation
------------

It is available on AUR where it goes by the name light, the only
runtime-dependency it has is glibc, and the only build-dependency it has
is git. For manual install, see http://haikarainen.se/light

Usage
-----

To see full usage, just type;

    $ light --help

Basic usage follows:

    // Set the brightness of the screen to 30%
    $ light 30

    // Increase brightness by 10% and suppress output
    $ light -aq 10

    // Print the current brightness in percent (unprecise)
    $ light -c

To override the default minimum-cap of 5%, just put an unsigned integer
into /etc/light/minlight.

To override the controller-detection and decide what controller to use,
put the controllers filename into /etc/light/override, for example if
the controller is "/sys/class/backlight/intel_backlight/", you put
"intel_backlight" (without quotes) into /etc/light/override.

Protip: To make light executable by users who aren't root (to replace
the auto-sudo lightscript has), issue the following commands as root
after it is installed:

    $ chown root /etc/light/light
    $ chmod a+xs /etc/light/light

Bugs/Feedback
-------------

Please give bugs/feedback directly on the AUR-page comments.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Light&oldid=235912"

Category:

-   Power management
