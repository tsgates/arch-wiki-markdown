ThinkPad: Mute button
=====================

Contents
--------

-   1 Problem:
    -   1.1 Nothing works
    -   1.2 External Audio still on
-   2 Solution:
    -   2.1 Older IBM ThinkPads
    -   2.2 Nothing works:
    -   2.3 External Audio still on:
    -   2.4 External Audio still on (and you use XFCE):

Problem:
--------

Mute button does not work properly on most ThinkPads and IdeaPads with a
newer kernel. Two different scenarios occur:

> Nothing works

The Button does not react at all: no led flash (some ThinkPads have an
LED, indicating the Mute-State) and no effect on Speakers Volume. It
only mutes, if you first press the mute button and afterwards the
Vol-Down-Key.

> External Audio still on

Pressing the button causes the speakers to mute (LED also works), but
external audio is still on.

Solution:
---------

> Older IBM ThinkPads

First try this: "http://www.thinkwiki.org/wiki/Mute_button"

> Nothing works:

Edit your /etc/modprobe.d/modprobe.conf and add the following line:   

    options thinkpad_acpi enabled=0 # enables Mute-Button on ThinkPads with IdeaPad-Firmware 

reboot, and go on:  

> External Audio still on:

Install tpb from the AUR and create an file "/root/.tpbrc":

    #tpb-Settings: 
    CALLBACK "/root/tp-key-handler" 
    OSD off 

Now create the file "/root/tp-key-handler":

    #!/bin/bash
    echo $1 $2
    if [ $1 = mute ]; then
    	if [ $2 = on ]; then
    		mset="off";
    	else
    		mset="on";
    	fi
    	sudo -u USERNAME amixer sset Master $mset; # I had to sudo to me, because I use PulseAudio
    fi

you'll have too add execute-rights to /root/tp-key-handler:

    chmod +x /root/tp-key-handler 

Since tpb needs root-privileges as well as X, you may start it by adding
"sudo tpb" in the .xinitrc and editing your sudo-Settings (use visudo)
or addin "gksudo tpb" in any X-Startscript (the last will ask for an
password on startup).

That's it - if you have a better Idea, please do not hesitate to edit
this page!

> External Audio still on (and you use XFCE):

Go to Applications->Settings->Keyboard->Application Shortcuts tab. Hit
Add and for the command, use 'amixer sset Master toggle'. For the key,
hit the mute button. Protip, to make sure the led state is correct,
start with the led in the opposite state of your mutedness so that when
you map the button, it starts out in the correct state. Alternatively,
you could just reboot and make sure the led is off before you get into
your XFCE session.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ThinkPad:_Mute_button&oldid=306011"

Category:

-   Lenovo

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
