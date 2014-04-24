Sony Vaio VGN-FE21B
===================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Last real        
                           contributions to this    
                           article were in 2006 and 
                           2008. This needs a       
                           massive overhaul.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Specs
-   3 Power management
-   4 Wireless
-   5 xorg
-   6 Audio
-   7 Special keys (Fn and so...) Part 1
    -   7.1 Part 2(About Volume Keys)
-   8 Quake 4 sound fix

Introduction
------------

This is a mini guide to configure a Sony Vaio VGN-FE21B on Arch Linux
0.7.2

Specs
-----

-   Intel Core Duo T2300 1.66 MHz
-   1GB DDR2 SDRAM
-   80GB disk
-   1280x800 WXGA 15,4" LCD
-   Double layer DVD-RW
-   Nvidia GeForce Go 7400
-   Intel pro wireless 3945

lspci output:

    00:00.0 Host bridge: Intel Corporation Mobile Memory Controller Hub (rev 03)
    00:01.0 PCI bridge: Intel Corporation Mobile PCI Express Graphics Port (rev 03)
    00:1b.0 Class 0403: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controllers cc=IDE (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation Unknown device 01d8 (rev a1)
    06:00.0 Network controller: Intel Corporation Unknown device 4222 (rev 02)
    0a:03.0 CardBus bridge: Texas Instruments Unknown device 8039
    0a:03.1 FireWire (IEEE 1394): Texas Instruments Unknown device 803a
    0a:03.2 Mass storage controller: Texas Instruments Unknown device 803b
    0a:08.0 Ethernet controller: Intel Corporation Unknown device 1092 (rev 02

  

Power management
----------------

See the main Power management article.

Wireless
--------

That one is easy:

1.  pacman -S iwlwifi-3945-ucode
2.  Add module iwl3945 to rc.conf

I recommend to use this with WICD networkmanager. It works out of the
box.

xorg
----

Nvidia drivers works fine (2D and 3D), you should set resolution to
1280x800

TODO:

-   make tvout work
-   make touch pad scrolling work

Audio
-----

No problems here

Special keys (Fn and so...) Part 1
----------------------------------

I didn't manage to make the Fn key work, but that is what I have done:

-   Mute key is hardware driven
-   Volume keys:

1.  edit .kde/Autostart/keycodes.sh and add:

    xmodmap -e 'keycode 174=F21' # lower volume
    xmodmap -e 'keycode 176=F22' # raise volume
    exit 0

1.  Run source .kde/Autostart/keycodes.sh
2.  Go to Preferences -> Regional settings -> Add actions
3.  Create a group named Vaio keys (or whatever)
4.  Add acctions:
    1.  volup: dcop action, app: kmix, remote object: mixer0, function:
        IncreaseVolume, args: 0
    2.  voldown: dcop action, app: kmix, remote object: mixer0,
        function: DecreaseVolume, args: 0
    3.  brightup: command, I use ctrl+F5 bind key, command:
        ~/bin/brightdown.sh
    4.  brightdown: command, I use ctrl+F6 bind key, command:
        ~/bin/brightup.sh

This is the contents of the bright scripts:

brightdown.sh:

    #!/bin/sh
    smartdimmer -d

brightup.sh:

    #!/bin/sh
    smartdimmer -i

> Part 2(About Volume Keys)

The method above works fine if you have only one keyboard layout. But if
you use couple languages then keycodes are reseted. What I did to bypass
this problem was to set these keys as F20 and F21 modifying keycodes in
xkb.

Ok here's what I did:

I use "Generic 105-key PC" keyboard as my keyboard model.(You can change
it in Control Center--> Regional& Accessibility-->Keyboard Layout).

after that edit corresponding keycode file(for "Generic 105-key PC" it
was /usr/share/X11/xkb/keycodes/digital_vndr/pc), add key codes to your
keyboard section or as I did it to pc_common section. It should look
something like this:

<part of file>

       xkb_keycodes "pc_common" {
       // "Function" keys
       <FK20>       = 174; // <--- Volume button key code assigned to FK20
       <FK21>       = 176; //<--- Volume button key code assigned to FK20
       <FK01>      = 9;
       <FK02>      = 15;
       <FK03>      = 23;
       <FK04>      = 31;
       <FK05>      = 39;

</part of file>

after that you need to assign it as F20 and F21 buttons on your
keyboard. To do that edit file /usr/share/X11/xkb/symbols/pc (or
corresponding file if you use other keyboard model in Settings)

there you gonna find a part where F keys are assigned it should be
something like this

<part of file>

           key <FK10> {
           type="CTRL+ALT",
           symbols[Group1]= [ F10, XF86_Switch_VT_10 ]
       };
       key <FK11> {
           type="CTRL+ALT",
           symbols[Group1]= [ F11, XF86_Switch_VT_11 ]
       };
       key <FK12> {
           type="CTRL+ALT",
           symbols[Group1]= [ F12, XF86_Switch_VT_12 ]
       };

</part of file>

All you have to do now is to add our "new" keys here:

<part of file>

       key <FK12> {
           type="CTRL+ALT",
           symbols[Group1]= [ F12, XF86_Switch_VT_12 ]
       };
       key <FK20> {
           type="CTRL+ALT",                                  //<-- for F20 key
           symbols[Group1]= [ F20, XF86_Switch_VT_20 ]
       };
       key <FK21> {
           type="CTRL+ALT",                                  //<-- for F21 key
           symbols[Group1]= [ F21, XF86_Switch_VT_20 ]
       };

</part of file>

That is it - now your volume keys are assigned. But they do not change
the volume yet. To do that go to Control
Center-->Regional&Accessibility-->Input Actions and add new group(name
it as you like). Add new action, set Action Type to "Keyboard Shortcut
-> DCOP Call(simple)". In a "Keyboard Shortcut" press the box and press
Vol- button on your keyboard. In "Dcop Call Settings" set(case
sensetive):

-   Remote application: kmix
-   Remote object: Mixer0
-   Called function: decreaseVolume
-   Arguments:0

Then press try. And your volume should go down. Press Apply button

Add the same action for your Vol+ button. except change "decreaseVolume"
to "increaseVolume".

That's it now your volume keys shoud work. Hit/Tip: To check keycodes
use type "xev" in terminal. Pressing button should give you output with
keycode.

Nomail 08:40, 14 June 2008 (EDT)

Quake 4 sound fix
-----------------

Yeah, I also play on arch linux

1.  Edit ~/.quake4-demo/q4base/Quake4Config.cfg
2.  Change s_driver value to oss

And you are done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VGN-FE21B&oldid=299470"

Category:

-   Sony

-   This page was last modified on 21 February 2014, at 22:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
