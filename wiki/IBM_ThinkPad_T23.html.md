IBM ThinkPad T23
================

  

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: This page may be 
                           missing instructions for 
                           certain hardware         
                           Doesn't cover modem      
                           setup, could use a       
                           section on that. --      
                           mulesryan (talk) 03:51,  
                           8 Feb 2014 (CST)         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Configuration
    -   1.1 Video Card
        -   1.1.1 Easy Installation
        -   1.1.2 Advanced Installation
            -   1.1.2.1 Configuration
            -   1.1.2.2 Troubleshooting
    -   1.2 Power Management
        -   1.2.1 Suspend and Hibernate
        -   1.2.2 Sleepmode
        -   1.2.3 Laptop Mode Tools
        -   1.2.4 CPU frequency scaling
        -   1.2.5 Tp_smapi
    -   1.3 Hotkeys
        -   1.3.1 tpb
        -   1.3.2 NumLock
-   2 See also

Configuration
-------------

> Video Card

Easy Installation

Make sure Xorg is installed, and then install xf86-video-savage from the
official repositories.

Then, edit your xorg.conf to reflect the following contents:  

    # xorg.conf -'man xorg.conf'
    # see also 'man savage' for more detailed options

      ...
      Section "Device"
        Identifier "gfxcard"
        Driver "savage"
      EndSection
      
      Section "Screen"
        Identifier             "Screen0"  #Collapse Monitor and Device section to Screen section
        Device                 "gfxcard"
        Monitor                "Monitor0"
        DefaultDepth            16 
      EndSection
      ...

→ See also: Xorg

Advanced Installation

Thanks to Conor Behan for this post and User:mulesryan for figuring out
this chipset.

The savage driver supports two types of hardware acceleration: XAA and
EXA. Unfortunately, you can use DRI for SuperSavage only if you are
using XAA. Since you want hardware 3D (for instance, opengl/d3d in wine)
then this is probably important.

This means you must run xorg-server < 1.13, because starting in 1.13 XAA
was removed.

Video Card

Xorg Driver

Mesa DRI Driver

Packages needed for DRI

S3 SuperSavage IX

xf86-video-savage

savage-dri†

xf86-video-savage (<2.3.6-2)‡ xorg-server (<1.13)§, xf86-input-evdev
(<2.7.3-2), xf86-video-fbdev (<0.4.3-2), xf86-video-vesa (<2.3.2-2)

† - '--disable-shared-dricore' configure flag required (enabled by
default in official repositories)  
‡ - '--enable-dri' configure flag required  
§ - '--enable-dri' configure flag required  

Configuration

    xorg.conf

     ...
     Section "Extensions"
            Option "Composite" "Enable"
            Option "RENDER" "Enable"
     EndSection

     Section "Device"
            Identifier "gfxcard"
            Driver "savage"
            Option "hwcursor" "1"
            Option "DPMS" "on"
            Option "backingstore"
            Option "BusType" "AGP"
            Option "AGPMode" "4"
            Option "AGPSize" "16" 
            Option "AccelMethod" "XAA" 
            Option "DRI" "true"
            Option "BCIforXv" "true"
            Option "AGPforXv" "true"
     EndSection
     
     Section "DRI"
        Mode 0666
     EndSection
     ...

If you've set up everything correctly, you should see this in
/var/log/Xorg.0.log:

    [ 63286.129] (II) SAVAGE(0): [DRI] installation complete
    ...
    [ 63286.132] (II) SAVAGE(0): Direct rendering enabled
    ..
    [ 63286.233] (II) AIGLX: enabled GLX_SGI_make_current_read
    [ 63286.233] (II) AIGLX: Loaded and initialized savage
    [ 63286.233] (II) GLX: Initialized DRI GL provider for screen 0

Troubleshooting

    [  2864.984] (EE) AIGLX: reverting to software rendering
    [  2865.028] (II) AIGLX: Loaded and initialized swrast
    [  2865.028] (II) GLX: Initialized DRISWRAST GL provider for screen 0

Are you using the versions of the packages specified? Are you using XAA
acceleration? Did you compile with the configure flags specified?  
  

> Power Management

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This section was 
                           written a long time ago, 
                           and may not reflect the  
                           current state of Arch    
                           Linux (Discuss)          
  ------------------------ ------------------------ ------------------------

Suspend and Hibernate

Works flawlessly. See Suspend to Disk. Also known to work with Pm-utils.

Sleepmode

An easy way is to use "suspend to swap" by appending

    resume=/dev/sdx 

to the kernel line in /boot/grub/menu.lst

Sleepmode

Laptop Mode Tools

Works flawlessly. See Laptop Mode Tools.

CPU frequency scaling

Works as described in CPU Frequency Scaling.

Tp_smapi

See Tp_smapi

> Hotkeys

They work better after loading the thinkpad_acpi module, to assign the
generated keycodes to their supposed functions.

tpb

Install tpb, available in the Arch User Repository.

tpb (for Thinkpad Buttons) adds an on-screen volume bar for the volume
buttons, THINKPAD button assignment, on-screen messages for Thinklight,
(on and off) and more.

NumLock

If not already working, this key may be configured by adding:

    keycode 77 = Num_Lock 

to ~/.xmodmap.

See also
--------

-   Thinkwiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T23&oldid=305932"

Category:

-   IBM

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
