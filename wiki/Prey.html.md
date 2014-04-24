Prey
====

Prey is a set of bash scripts that helps you track your computer when it
is stolen.

This guide shows you how to install Prey.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Modules
    -   2.2 GUI config
    -   2.3 Standalone Mode
    -   2.4 Troubleshooting
        -   2.4.1 Beeping
    -   2.5 Bugs

Installation
------------

Install prey-tracker from the AUR.

Configuration
-------------

Add your device using the control panel on Prey's website.

Note:The 'Add new device' button in the control panel links to Prey's
download page for whatever reason. You can add a new device here:
https://panel.preyproject.com/devices/new

Edit /usr/share/prey/config and add your device key and API key, both of
which are listed in Prey's control panel.

Run /usr/share/prey/prey.sh as root to ensure that the configuration is
correct.

Note:The old version of prey-tracker ( < 0.5.9-3) was in
/usr/share/prey-tracker/ folder, now (>0.5.10-2) it is in
/usr/share/prey/.

Enable systemd service prey-tracker to automatically start Prey at boot
# systemctl enable prey-tracker.timer

> Modules

To enable/disable modules, you must change the executable permissions
for the the "run" files in prey's respective modules/core
subdirectories. Adding executable permissions to a module will enable
it, while removing permissions will disable the module.

> GUI config

You can use a GUI to configure prey using the prey-config script:

    # /usr/share/prey/platform/linux/prey-config.py

Note that if this doesn't work you are missing a dependency, not sure if
Python alone suffices.

> Standalone Mode

The GUI can be used to configure standalone mode.

Alternatively,/usr/share/prey/config can be edited to change post_method
to email and edit the SMTP settings.

Note that in Standalone Mode, all modules in /usr/share/prey/modules run
by default. To disable them, remove executable permissions on the
module's run file (located within the module's core subdirectory). For
example, the following command disables the alarm module:

    # chmod -x /usr/share/prey/modules/alarm/core/run

> Troubleshooting

To troubleshoot, run

    # /usr/share/prey/prey.sh --check

Ensure you have enabled systemd service prey-tracker.service and
prey-tracker.timer to start Prey at boot.

If you're not receiving webcam images in you reports, install xawtv from
the official repositories.

Beeping

If scrot is installed, prey will use it to take a screenshot if the
session module is enabled. Unfortunately, scrot emits an annoying beep
everytime it is run. To disable beeping, append xset -b to the beginning
of /usr/share/prey/modules/session/core/run.

> Bugs

There seems to be a bug in version 0.5.3 which gives an error if the
SMTP password is set when using "email" post_method, which returns an
error, but works fine when executed normally without the --check option.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Prey&oldid=264847"

Categories:

-   Networking
-   Security

-   This page was last modified on 1 July 2013, at 16:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
