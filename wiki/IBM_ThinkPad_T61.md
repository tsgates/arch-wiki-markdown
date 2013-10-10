IBM ThinkPad T61
================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Lenovo      
                           Thinkpad T61.            
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Detect hardware by hwdetect                                        |
| -   2 SATA and Linux                                                     |
| -   3 Wireless                                                           |
|     -   3.1 Intel 4965 WiFi                                              |
|                                                                          |
| -   4 Xorg                                                               |
|     -   4.1 Widescreen                                                   |
|     -   4.2 Synaptic                                                     |
|                                                                          |
| -   5 Graphics                                                           |
|     -   5.1 Nvidia                                                       |
|         -   5.1.1 Tweaks                                                 |
|                                                                          |
|     -   5.2 Intel                                                        |
|                                                                          |
| -   6 Power Management                                                   |
|     -   6.1 ACPI                                                         |
|     -   6.2 SpeedStep                                                    |
|     -   6.3 Suspend/Resume                                               |
|         -   6.3.1 T61p nvidia graphics and the proprietary driver        |
|         -   6.3.2 For the T61 with 140M and proprietary driver:          |
|                                                                          |
| -   7 Thinkvantage Rescue and Recovery                                   |
| -   8 Fingerprint Reader                                                 |
| -   9 Sound                                                              |
| -   10 HDAPS                                                             |
| -   11 Built-in Camera                                                   |
| -   12 Multimedia Keys                                                   |
|     -   12.1 XFCE                                                        |
+--------------------------------------------------------------------------+

Detect hardware by hwdetect
---------------------------

     hwdetect --modules  # add these data into /etc/rc.conf

This step will save much work on following sections.

on my T61, here is the listing by hwdetect 0.9-1

     MODULES=(ac battery bay button dock processor thermal video wmi cdrom \
       agpgart intel-agp nvram firewire-core firewire-ohci i2c-i801 i2c-core \
       evdev joydev pcspkr psmouse serio_raw compat_ioctl32 uvcvideo v4l1-compat \
       videodev thinkpad_acpi pci_hotplug shpchp rtc-cmos rtc-core rtc-lib nvidia \    
       output crc-itu-t snd-mixer-oss snd-pcm-oss snd-hwdep snd-page-alloc \
       snd-pcm snd-timer snd snd-hda-intel soundcore pata_acpi ata_generic \
       scsi_mod ahci ata_piix e1000e mac80211 iwl4965 cfg80211 pcmcia_core \
       rsrc_nonstatic yenta_socket usbcore ehci-hcd uhci-hcd firewire-core \
       firewire-ohci ieee1394 ohci1394 sd_mod sr_mod)

SATA and Linux
--------------

If there are boot problems, try going from AHCI to compatibility in the
BIOS. I do not really know what is going on here, but my computer works
in compatibility, I haven't tried AHCI.

AHCI works with the latest arch release.

Wireless
--------

> Intel 4965 WiFi

If you have the Intel 4965 NIC, simply install iwlwifi-4965-ucode, run
depmod, and run "modprobe iwl4965" to activate. For wpa_supplicant, use
the WEXT driver, not the deprecated ipw200.

The latest Kismet runs well on the iwl4965, but occasionally has
problems changing the mode back to Managed from Monitor.

If you have the AR5212 802.11abg NIC all you need is madwifi. Install
it, and the kernel module is ath_pci.

Xorg
----

> Widescreen

Hwd did not do the monitor widescreen (1280x800) properly, and it was
instead doing 1024x768. In xorg.conf, here is the relevant section:

    Section "Screen"
           Identifier "Screen0"
           Device     "Card0"
            Monitor    "Monitor0"
           DefaultColorDepth 24
           SubSection "Display"
                   Depth     24
                   Modes "1280x800"
           EndSubSection
    EndSection

For the framebuffer in /boot/grub/menu.lst, I just used vga=773 and it
doesn't look too bad. It freaks out with the vga=871 or whatever number
you need for widescreen. (Note from reader who owns new T61: This is
because the hex calculation presented at first is not what you need.
1280x800 requires "vga=865" at the end of the "kernel ..." line in
menu.lst; I put that in instead and it works fine. If things are okay
you do not really need that much more real estate in the text session,
but if anything isn't working when you're setting up the system I find
it nice to be able to fit more text on the screen.)

The Nvidia driver has it's own way of doing resolution, but I didn't
find any conflict between the xorg setting and nvidia setting, so it
really doesn't matter. I think the nvidia trumps the xorg.conf, though.
(Another note from reader: I did not find that the above modification
was needed. Run "Xorg --configure" and "nvidia-xconfig." That will put
an "xorg.conf" in /etc/X11 and another conf file with a different name
in the /root directory. If you look at the contents of the two files and
just edit the one from the root directory until instances of 'type 1'
and 'dri' are commented out, then move it to the /etc/X11 directory,
rename the original xorg.conf so it won't be noticed, and then call the
edited conf file xorg.conf, you should be okay.)

> Synaptic

Works great with the settings provided in the Pacman output

Graphics
--------

> Nvidia

Driver works great, even with composite enabled.

Tweaks

When I have time

> Intel

Don't have it, so cannot say.

xf86-video-intel from testing should support the Intel video. I haven't
tried it yet, but I'll report back when I do.

Power Management
----------------

> ACPI

Install acpi, acpid. Add acpid to the daemons list. Load module
thinkpad_acpi. You might have to blacklist asus_acpi/toshiba_acpi, it
doesn't hurt anyway. It should work, and is able to provide accurate
information to such programs as Conky and GKrellm, as well as the GNOME
battery monitor.

> SpeedStep

The regular way works fine.

> Suspend/Resume

Suspend/Resume technically worked out of the box for me, however
resuming took about 2+ minutes, while my screen stayed off and my
speaker beeped 2-3 times. Sometimes it hung up too. These changes seemed
to have worked for me and where found here. Remember to remove the boot
parameters acpi_sleep=s3_bios or acpi_sleep=s3_mode if you have them,
they do not seem to be needed anymore and may cause the system to crash
on resume.

T61p nvidia graphics and the proprietary driver

(You do not need to do the following any more if you have hal-info
0.20080508-1 or newer.) In
/usr/share/hal/fdi/information/10freedesktop/20-video-quirk-pm-lenovo.fdi,
change line 51 from:

    <merge key="power_management.quirk.s3_bios" type="bool">true</merge>
    <merge key="power_management.quirk.vbemode_restore" type="bool">true</merge>

to

    <merge key="power_management.quirk.s3_bios" type="bool">false</merge></math>
    <merge key="power_management.quirk.vbemode_restore" type="bool">true</merge>

For the T61 with 140M and proprietary driver:

The above should probably work here too but is currently untested. If
there's still breakage, try making the same changes to line 46.

Tested the T61 with suspend with the Nvidia 140M the above changes fix
the suspend problem, but the wireless stops working, my fix right now is
to

      $ sudo modprobe -r ath_pci
      $ sudo modprobe ath_pci

Thinkvantage Rescue and Recovery
--------------------------------

The Rescue and Recovery partition can be /dev/sda1 or /dev/sda2, not
sure which this depends on

The following GRUB entry did work on my T61

         title ThinkPad Rescue and Recovery
         rootnoverify    (hd0,0)
         chainloader     +1

Fingerprint Reader
------------------

Install Thinkfinger

    pacman -S thinkfinger

Update PAM configuration to accept thinkfinger as auth input. See
Thinkfinger Configuration

Sound
-----

The module is snd-hda-intel. It works, albeit with several unresolved
quirks. The mute button works partially out of the box (it can mute but
not unmute.) To unmute, press either the volume up or volume down
buttons. However, one workaround is enabling the volume up/down buttons
as Keyboard shortcuts in your Desktop environment.

--Edit: Since Kernel 2.6.25 the mute/unmute function works out of the
box. Now it unmutes also!

--Edit: To enable sound you must unmute the internal speaker channel,
and turn down or mute the microphone channels, otherwise you will get
nothing but a squeaking sound from the speaker.

--Edit: On my t61 sounds did not work till I added
"snd-hda-codec-analog" to the modules, recompiled the modules (sudo
mkinitcpio -p linux) and restarted.

HDAPS
-----

Note: this information is out of date for 2.6.28 and newer kernels. See
the HDAPS wiki page and follow the directions there.

Install the the Kernel(kernel26tp) from AUR and add it into your
bootloader menu. Boot the new Kernel.

Install hdapsd and tp_smapi from AUR.

Load the Modules:

    modprobe tp_smapi
    modprobe hdaps

Start the hdaps daemon:

    hdapsd -d sda -s 15

Built-in Camera
---------------

Install the linux-uvc-svn on community, version 211-1 is workable

  

Multimedia Keys
---------------

Use pacman to install xmodmap (xmodmap is included in the
xorg-server-utils package), then create a text file ~/.Xmodmap and put
this in it:

these are for the pager buttons

     keycode 234 = XF86Back
     keycode 233 = XF86Forward

  
 these are the music changing buttons:

     keycode 144 = XF86AudioPrev
     keycode 164 = XF86AudioStop
     keycode 162 = XF86AudioPlay
     keycode 153 = XF86AudioNext

this is for the silver volume buttons:

     keycode 160 = XF86AudioMute
     keycode 174 = XF86AudioLowerVolume
     keycode 176 = XF86AudioRaiseVolume

based on which Desktop environment you are in you will have to edit your
hotkeys to get it working, if you are in a WM that doesn't provide this
functionality, try installing xbindkeys

> XFCE

Assuming you are using alsa, open the XFCE keyboard configuragtion GUI
(XFCE Menu > Settings > Keyboard) and add the following to the
'Application Shortcuts' tab. When prompted press the appropriate
multimedia key.

> Mute

     amixer -q set Master toggle

Volume Down

     amixer -q set PCM 2- unmute

Volume Up

     amixer -q set PCM 2+ unmute

The previous two will adjust the PCM value by 2, if you desire you can
change this number.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T61&oldid=238842"

Category:

-   IBM
