TechCom-SSD-TV-675
==================

Contents
--------

-   1 About TechCom SSD-TV-675 INTERNAL TV TUNER
-   2 About the driver
-   3 Changing the kernel source to get the card working
-   4 Watching TV using tvtime
-   5 Recording TV
-   6 More Resources

About TechCom SSD-TV-675 INTERNAL TV TUNER
------------------------------------------

The TechCom SSD-TV-675 INTERNAL TV TUNER is a cheap tuner card available
in India. It uses the PHILIPS 7130 chipset and QSD-MT-S73 RF tuner. The
full specification of this card is available at
http://www.techcomindia.com/ website.

About the driver
----------------

My arch Linux system detected the device and loaded the driver saa7134.
But the system failed to find the exact card and tuner type. After many
trial and error methods I found that the driver option :

    modprobe saa7134 card=3 tuner=55

Is able to produce the sound and the option :

    modprobe saa7134 card=37 tuner=55

gives me the video.

Changing the kernel source to get the card working
--------------------------------------------------

I got help from Hermann pitton of LinuxTv project. I got the card
working after making some source code change and a kernel recompilation.

I will explain the steps that I followed to get this card working in my
Arch Linux system.

Download the kernel from kernel.org

    wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.2.tar.bz2

Extract it and change the source code of saa7134 card

    tar jxvf linux-2.6.30.2.tar.bz2
    cd linux-2.6.30.2
    find . -iname saa7134-cards.c

That will give the path to the file that you need to edit.

    vi ./drivers/media/video/saa7134/saa7134-cards.c

change the vmux value to 3 from 1 in the card SAA7134_BOARD_FLYVIDEO2000
and change the amux to LINE1 and gpio to 0x4000 under the mute section.

     [SAA7134_BOARD_FLYVIDEO2000] = {
                   /* "TC Wan" <tcwan@cs.usm.my> */
                   .name           = "LifeView/Typhoon FlyVIDEO2000",
                   .audio_clock    = 0x00200000,
                   .tuner_type     = TUNER_LG_PAL_NEW_TAPC,
                   .radio_type     = UNSET,
                   .tuner_addr     = ADDR_UNSET,
                   .radio_addr     = ADDR_UNSET,

                   .gpiomask       = 0xe000,
                   .inputs         = {{
                           .name = name_tv,
                           .vmux = 1,        <--change to vmux = 3
                           .amux = LINE2,
                           .gpio = 0x0000,
                           .tv   = 1,
                   },{
                           .name = name_comp1,
                           .vmux = 0,
                           .amux = LINE2,
                           .gpio = 0x4000,
                   },{
                           .name = name_comp2,
                           .vmux = 3,
                           .amux = LINE2,
                           .gpio = 0x4000,
                   },{
                           .name = name_svideo,
                           .vmux = 8,
                           .amux = LINE2,
                           .gpio = 0x4000,
                   }},
                   .radio = {
                           .name = name_radio,
                           .amux = LINE2,
                           .gpio = 0x2000,
                   },
                   .mute = {
                           .name = name_mute,
                           .amux = LINE2,       <----------- change to LINE1
                           .gpio = 0x8000,      <----------- change to 0x4000
                   },
           },

After that I have used the Traditional method (
https://wiki.archlinux.org/index.php/Kernel_Compilation_From_Source#1._Manual.2C_Traditional_method
) to recompile the kernel.

After getting the system up with new kernel, you can use the following
commands to get the tuner card up.

    rmmod saa7134
    modprobe saa7134 card=3 tuner=69

You can add the line options saa7134 card=3 tuner=69 to
/etc/modprobe.d/saa7134.conf to auto load the module after reboot

    # cat /etc/modprobe.d/saa7134.conf 
    options saa7134 card=3 tuner=69

Watching TV using tvtime
------------------------

The tvtime ( http://tvtime.sourceforge.net/ ) is a good TV viewer. You
can install it using pacman. The default frequency in tvtime is set to
us-cable. You need to scan the channels and add the option
--frequencies=custom, if you are in a different country.

    tvtime-scanner
    tvtime --frequencies=custom

Recording TV
------------

You can use the following mencoder command to record TV

    mencoder tv:// -tv driver=v4l2:input=0:norm=pal:width=640:height=480:device=/dev/video0:\
    freq=280.00:alsa:adevice=hw.0,0:audiorate=32000:amode=1:forceaudio:volume=95 buffersize=64\
     -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=400:keyint=30 -oac mp3lame\
     -lameopts br=32:cbr:mode=3 -ffourcc divx -o "test.avi" 

More Resources
--------------

SSD-TV-675

http://tvtime.sourceforge.net

http://www.linuxtv.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=TechCom-SSD-TV-675&oldid=238849"

Category:

-   Sound

-   This page was last modified on 6 December 2012, at 00:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
