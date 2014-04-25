Nvidia TV-out and Video Tearing
===============================

Contents
--------

-   1 Introduction
-   2 Possible Issues
-   3 Step 1: Clone desktop to TV (CRT).
-   4 Step 2: Using the correct settings for NVIDIA X Server Settings
-   5 Step 3: Using the correct settings for MPlayer
-   6 Step 4: Gnome Video Playback with Totem (Videos)
-   7 REFERENCES

Introduction
------------

This article tries to address the problem of video tearing on the TV via
Nvidia video card. The scenario typically involves the VGA (D-sub or
DVI) connection to the monitor (LCD or CRT) with the S-Video handling
the TV output.

This approach has been confirmed to work with Geforce 5900XT, Geforce
7300GT, and Geforce 7600GS. (All three have onboard TV-encoders on the
GPU.)

Possible Issues
---------------

Be aware that you may run into possible issues with Beryl 0.20, if the
wrong Option in xorg.conf is used. (You will encounter unusual graphical
issues).

There is a known issue with HD mode of Nvidia cards and PAL standard. As
in it doesn't work! :(

Step 1: Clone desktop to TV (CRT).
----------------------------------

In this example we have connected the TV-OUT of the video card to the
S-Video IN of our TV (CRT solution). The driver version we're using is
1.0-9755 with Xorg 7.2. Typically, you can let the Nvidia driver handle
detecting TV-Out (S-Video). However, there are times where the driver
will not detect things correctly, and you may have to manually override
it via xorg.conf, (by specifically setting the values). CRT-0 is the
computer monitor, and TV-0 is obviously the TV.

NOTE: PAL-B is seen below as this is the standard for Australian TVs.
(See [1] in the REFERENCES section for other regions around the world).

Use nano or vim to open /etc/X11/xorg.conf file, scroll down until you
find the "Device" section.

It will be something like:

    Section "Device"
        Identifier   "Card0"
        Driver       "nvidia"
        VendorName   "ALL"
        BoardName    "ALL"
    EndSection

Add the following:

        Option "TwinView"
        Option "TwinViewOrientation" "Clone"
        Option "MetaModes"           "CRT-0: 1024x768,  TV-0: 1024x768"
        Option "HorizSync"           "CRT-0: 30-81;  TV-0: 30-50"
        Option "VertRefresh"         "CRT-0: 56-76;  TV-0: 60"
        Option "ConnectedMonitor"    "CRT-0, TV-0"
        Option "TVStandard"          "PAL-B"
        Option "TVOutFormat"         "SVIDEO" 

So it becomes:

    Section "Device"
        Identifier   "Card0"
        Driver       "nvidia"
        VendorName   "ALL"
        BoardName    "ALL"
        Option       "TwinView"
        Option       "TwinViewOrientation" "Clone"
        Option       "MetaModes"           "CRT-0: 1024x768,  TV-0: 1024x768"
        Option       "HorizSync"           "CRT-0: 30-81;  TV-0: 30-50"
        Option       "VertRefresh"         "CRT-0: 56-76;  TV-0: 60"
        Option       "ConnectedMonitor"    "CRT-0, TV-0"
        Option       "TVStandard"          "PAL-B"
        Option       "TVOutFormat"         "SVIDEO" 
    EndSection

Save changes, log out of the system, and restart X-Server by pressing
Ctrl-Alt-Backspace. This should bring you back to the login screen. You
will notice a clone of the screen will appear on your TV.

For more options and details, please see [2] and [3] in the REFERENCES
section.

Step 2: Using the correct settings for NVIDIA X Server Settings
---------------------------------------------------------------

Go to NVIDIA X Server Settings.

(In KDE, this is done by K-menu (icon) => System => NVIDIA X Server
Settings).

In the section X Screen 0, there is an entry called X Server XVideo
Settings, click on that.

Now you will see three entries:

1.  Video Texture Adaptor   
     Enable => Sync to VBlank (Make sure this is checked with a tick)
2.  Video Blitter Adaptor   
     Enable => Sync to VBlank (Make sure this is checked with a tick)
3.  Sync to this display device   
     Select => TV-0 (TV-0)

Then click on Quit to save changes.

Step 3: Using the correct settings for MPlayer
----------------------------------------------

Now in MPlayer, right-click and select Preferences. Select the Video
tab. Select xv in the Available Drivers: section.

Also enable (checkmark appears in box): Enable double buffering, Enable
direct rendering, and Enable frame dropping.

Select OK, close MPlayer and then restart MPlayer to enable changes. Do
a test with movie or video clip that contains lots of fast action scenes
(eg: Anime). There should be little or no tearing when playing video
through MPlayer on your TV.

If you still have issues with tearing, consider adjusting the values for
"VertRefresh" first. As a last resort, you can also adjust the modeline
in xorg.conf. See [4] and [5] in REFERENCES section for details.

Step 4: Gnome Video Playback with Totem (Videos)
------------------------------------------------

You can enable vsync on your driver's options if you like.

Edit /etc/enviroment and add the lines:

    CLUTTER_PAINT=disable-clipped-redraws:disable-culling
    CLUTTER_VBLANK=True

Then reboot your system.

REFERENCES
----------

[1] http://en.wikibooks.org/wiki/NVidia/TV-OUT

[2]
http://us.download.nvidia.com/XFree86/Linux-x86/1.0-9755/README/appendix-g.html

[3]
http://us.download.nvidia.com/XFree86/Linux-x86/1.0-9755/README/appendix-h.html

[4] http://www.mythtv.org/wiki/Working_with_Modelines

[5] http://www.mythtv.org/wiki/Modeline_Database

[6] https://bbs.archlinux.org/viewtopic.php?pid=1017705#p1017705

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nvidia_TV-out_and_Video_Tearing&oldid=243136"

Category:

-   X Server

-   This page was last modified on 7 January 2013, at 02:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
