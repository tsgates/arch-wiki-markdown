HP Pavilion dv6018
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Things you should know                                             |
| -   2 Foreword                                                           |
| -   3 Video                                                              |
| -   4 Sound                                                              |
| -   5 Ports and drives                                                   |
| -   6 Power management                                                   |
| -   7 Input devices                                                      |
| -   8 Networking                                                         |
+--------------------------------------------------------------------------+

Things you should know
----------------------

1.  THIS PAGE IS NOT MAINTAINED ANYMORE. ORIGINAL AUTHOR OF IT (Stalwart
    <stlwrtDOGgmail.com>) SOLD HIS PAVILION AND ADVISES LINUX USERS NOT
    TO BUY HP LAPTOPS. IF ANYONE HAS SAME LAPPY AND WANTS TO MAINTAIN
    PAGE - FEEL FREE TO DO IT
2.  Kernels 2.6.20.4, 2.6.20.5 and 2.6.20.6 don’t boot, use newest
    install medium possible, 2.6.21 and higher is recommended.
3.  bcm43xx driver is unstable, ndiswrapper is buggy - wifi is painful
4.  Touchpad is buggy - after a while driver loses contact with it and
    all fancy options become disabled

Foreword
--------

To install linux on this shiny pile of great hardware you need to use
“noapic” or “acpi=noirq” kernel parameters. After you install distro you
need to load modules in proper order or kernel will freeze. Ron Kuris
reported lucky module order in kernel bugzilla - i2c_core nvidia
snd_hda_codec cpufreq_conservative ohci_hcd snd_hda_intel ndiswrapper. I
installed Arch64 and modified module preloading parameter in
/etc/mkinitcpio.conf:

       MODULES="i2c_core bcm43xx nvidia cpufreq_conservative cpufreq_powersave cpufreq_ondemand ohci_hcd fuse usbhid powernow-k8 snd_hda_intel pata_amd ata_generic sata_nv"

... and rebuild initramfs (mkinitcpio -p linux)

System should work now.

Video
-----

This lappy has GeForceGo 7200 adapter and glossy widescreen LCD. You’ll
need nvidia proprietary driver. To make use of LCD’s native resolution
you need to place correct mode in /etc/X11/xorg.conf:

       Section "Screen"
       Identifier "Screen 1"
       Device "nVidia"
       Monitor "LCD"
       DefaultDepth 24

       Subsection "Display"
       Depth 24
       Modes "1280x800"
       ViewPort 0 0
       EndSubsection
       EndSection

TV-Out works! WebCam works with recent linux-uvc driver. I tested
linux-uvc-svn rev.110 and it worked great with resolution up to
1280x1024

Sound
-----

You need 2.6.18 to get sound, 2.6.19 to enable headphone jack and 2.6.21
to make it work right.

Ports and drives
----------------

DVD-RW drive works out-of-box. What else did you expect? :) USB and card
reader also do work out-of-box. Tested with iPod, USB mouse and several
SD cards. FireWire and Bluetooth are detected by kernel, but i have no
devices to test them. Dunno if xpressCard/54 expansion slot works, i
don’t see any xpresscard-specific messages in dmesg. No devices to test.

Power management
----------------

CPU stepping works flawlessly out-of-box with recent kernel. CPU can be
clocked down to 800mhz (per core). There are many ways to manage current
frequency, just google. Power button works, lid switch works. Suspend to
RAM works!

Input devices
-------------

To use sensor keys and remote control you need to set keyboard model in
/etc/X11/xorg.conf

       Option "XkbModel" "hpzt11xx"

Add this command to some startup script, /etc/rc.local in Arch Linux:

       setkeycodes e008 221 e00e 226 e00c 213

And finally add these commands to startup of your windowmanager or
desktop environment. I put them to ~/.xinitrc

       xmodmap -e "keycode 197 = XF86Pictures"
       xmodmap -e "keycode 237 = XF86Video"
       xmodmap -e "keycode 118 = XF86Music"

TODO: Add Fn+fx keys Remote control mimics keyboard, no additional
software needed. Range is about 4 meters.

Touchpad is generic Synaptic. On/off switch on it is hardware, kernel
seems not to like the way it works - after a while driver loses contact
with device and touchpad loses all fancy features like 3rd button
emulation and scrollbar.

Networking
----------

bcm43xx is unstable. NDISWrapper is buggy. bcm43xx developers swear
bcm4311 (used in this lappy) is stable in 2.6.22, yet to test...
Ethernet: works flawlessly with forcedeth module. Modem: Don’t know
anything about it, i don’t think i will ever use it.

On A similar dv6000, ndiswrapper works flawlessly with the bcm4311
chipset.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv6018&oldid=196639"

Category:

-   HP
