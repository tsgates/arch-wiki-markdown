Logitech G300
=============

How to make G300 work correctly
-------------------------------

This Wiki page will show you how to get your G00 mouse working as
desired.

G300 is recognized as both mouse and keyboard by system, you could check
by execute:

    xinput list | grep G300

We have to disable the G300 keyboard to make it work correctly.

Here's the code:

    #!/bin/sh
    DEVICE_ID=$(xinput list |  grep "Logitech Gaming Mouse G300" | grep keyboard | sed 's/.*id=\([0-9]*\).*/\1/')

    if xinput -list-props $DEVICE_ID | grep "Device Enabled" | grep "1$" > /dev/null
    then
            xinput set-int-prop $DEVICE_ID "Device Enabled" 8 0
    fi

Simply execute the code above to see if it's working.

And you could put it into your xinitrc.d to make it load automatically.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_G300&oldid=259533"

Category:

-   Mice

-   This page was last modified on 29 May 2013, at 20:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
