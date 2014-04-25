Xorg multiseat
==============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Show how         
                           PulseAudio can be        
                           configured for multiple  
                           users without running    
                           PulseAudio system-wide.  
                           Explain how Multiseat be 
                           done using only one      
                           video card (and/or X     
                           Server) and without      
                           Xephyr. (Discuss)        
  ------------------------ ------------------------ ------------------------

Multiseat is a certain setup where multiple users work simultaneously on
one computer. This is achieved by having two monitors, two keyboards and
two mice. The advantages are quite obvious:

-   Less power consumption (only one computer)
-   Less hardware to purchase
-   All the cool kids do it

Contents
--------

-   1 Requirements
    -   1.1 Keyboards and mice
    -   1.2 Graphics hardware
    -   1.3 Processors and memory
    -   1.4 Software
    -   1.5 Some X knowledge
-   2 Definitions
-   3 Tips and tricks
-   4 About evdev
-   5 Setting up Xorg
    -   5.1 The basics
    -   5.2 Defining available input devices
    -   5.3 Graphics card
    -   5.4 Screens
    -   5.5 Monitors
    -   5.6 Serverlayout
-   6 Testing
-   7 Setting up the loginmanager
    -   7.1 For KDM (KDE's Display Manager)
    -   7.2 For GDM (Gnome's Display Manager)
    -   7.3 For XDM (X Display Manager)
    -   7.4 For LightDM (Light Display Manager)
    -   7.5 For Auto Login multiseat (without Display Manager)
-   8 Troubleshooting
    -   8.1 My Windows key doesn't work anymore
    -   8.2 Unreliable behaviour (black picture without cursor)
    -   8.3 Little black boxes/dots on the desktop
    -   8.4 Multimedia keys not working
    -   8.5 The Ctrl-Alt-Fx, Alt-Fx keys mess up with virtual terminals
-   9 Final configuration
    -   9.1 /etc/X11/xorg.conf
    -   9.2 /opt/kde/share/config/kdm/kdmrc
-   10 Related problems
    -   10.1 PulseAudio
-   11 See also

Requirements
------------

> Keyboards and mice

Any standard PS/2 or USB keyboards will suffice. Same thing for mice.

> Graphics hardware

For the best possible result you'll need two graphics cards. I used an
nVidia FX5500 AGP and an nVidia 6200 PCI. If you look around a bit you
can certainly find new and decent PCI graphics card for a soft price.

It is possible to use only one videocard which has dual heads (like most
nvidia cards will have), but this has some limitations: you have to use
Xephyr on the second monitor which seems quite a messy solution from
what I've read, and for optimal usage both screens need the same
resolution.

If you have two pci-express slots, take advantage of them! That way
you'll even be able to play two games at the same time. (PCI is too slow
to play comfortably)

> Processors and memory

If you really are working with two users on the same computer, I'd at
least recommend a dual-core processor and plenty of RAM. A fast hard
drive (10.000 RPM or higher) is also recommended for comfortable use.

> Software

You'll need Xorg with the drivers for your graphics card (according to
some sources, the closed source nvidia driver works better than the open
source nv driver for this, I have t tested this myself) and the evdev
(xf86-input-evdev) driver. That's all. All this can be found in the Arch
Linux core and extra repositories.

> Some X knowledge

If you know how X works this will be a lot easier. Before you start, I
recommend generating a clean configuration with xorgconfig that works
with a single screen. Read through this xorg configuration and make
yourself familiar. And as usual the manpages will provide you with most
of the answers. You may reference some man pages: xorg, xserver, startx,
xdm, xinit. sudo X -configure, X -showopts may give you some hint.

Definitions
-----------

For this article to be clear, I'll be using the following definitions:

-   screen: A screen is something Xorg can display its stuff on. A
    screen has a monitor and a graphics card assigned to it.
-   monitor: A physical monitor like the one you're now sitting in front
    of.
-   server layout: a definition of which screen, keyboard and mouse to
    use.
-   seat: A workplace with a physical monitor, physical keyboard and
    physical mouse.

Tips and tricks
---------------

-   Set up ssh on your computer, so you can ssh to the machine from
    another computer (such as a laptop). This is very useful because
    you'll probably run into X not responding anymore or not giving you
    picture at all.
-   Finding out which keyboard and mouse is which: open a terminal and
    use cat to find out. For example, cat /dev/input/mouse1. If you then
    move your mouse and you see all weird things happening than that is
    the mouse you're moving. Same goes for keyboards, which are called
    eventN.
-   Try a basic configuration first. Don't start with the fancy stuff
    yet, get a very basic Xorg working first.
-   Leave your xorg.conf alone and create a new file, called
    xorg.conf.multiseat in /etc/X11 to store your new multiseat
    configuration. After this configuration is working you can overwrite
    the xorg.conf file with your new xorg.conf.multiseat.
-   Create a backup of all relevant configuration files. What do you
    mean you'll skip this one?
-   Take a look at the full configuration I used at the end of this
    article before you start.

About evdev
-----------

evdev is an Xorg driver which can make use of the kernel event devices,
which you can find in /dev/input.

Setting up Xorg
---------------

The logic behind this is that you have two server layouts, each assigned
with their own keyboard, mouse, video card and monitor.

> The basics

First of all we'll set up the basics for xorg.

    Section "ServerFlags"
            Option "AutoAddDevices"     "false"
            Option "AutoEnableDevices"  "false"
            Option "AllowMouseOpenFail" "on"
            Option "AllowEmptyInput" "on"
            Option "ZapWarning"         "on"
            Option "HandleSpecialKeys"  "off" # Zapping on
            Option "DRI2" "on"
            Option "Xinerama" "off"
    EndSection

> Defining available input devices

This part of the configuration tells Xorg which input devices it has
available. Input devices are keyboards and mice, but can also be, for
example, touchscreens and pens.

This section defines my first keyboard, called keyboard0. As you can
seen it uses the evdev driver. /dev/input/event1 corresponds with the
keyboard connected to the PS/2 port of my computer. Create a section
like this for each keyboard you have. Don't forget to modify the
identifier of course. Keep the identifier simple and match it with the
other names. This keyboard0 will be used for screen0 together with
mouse0.

    Section "InputDevice"
            Identifier      "keyboard0"
            Driver          "evdev"
            Option          "Device"                "/dev/input/event1"
    #     Option  "Device" "/dev/input/by-path/platform-i8042-serio-0-event-kbd"  
    #     Option "Device" "/dev/input/by-id/usb-Tangtop_Generic_USBPS2-event-kbd"
            Option "xkb_rules" "evdev"
            Option "xkb_model" "evdev"
            Option "xkb_layout" "us"
            Option "GrabDevice" "on" # prevent send event to other X-servers
    # If you are using a non en_US keyboard, set the layout here.
    #       Option          "XkbLayout"             "be"
    EndSection

  
 This section defines my first mouse, called mouse0. This uses the
regular mouse driver. /dev/input/mouse2 corresponds with the mouse
connected to the PS/2 port of my computer. Create a section like this
for each mouse you have.

    Section "InputDevice"
            Identifier      "mouse0"
            Driver          "mouse"
            Option          "Protocol"              "IMPS/2"
            Option          "Device"                "/dev/input/mouse2"
    EndSection
    # or use evdev, that could assign by id
    Section "InputDevice"
            Identifier "Mouse0"
            Driver "evdev"
            Option "Device" "/dev/input/by-id/usb-Tangtop_Generic_USBPS2-event-mouse"
            Option "GrabDevice" "on"
    EndSection

> Graphics card

Now we'll set up the graphics card for each screen.

    Section "Device"
            Identifier      "nvidia0"
            Driver          "nvidia"
            Option          "NoLogo"                "1"  # Remove nvidia branding at startup
            BusId           "PCI:1:0:0"
            Option          "ProbeAllGpus"          "false"  # Only required for nvidia
    EndSection

This section defines my first graphics card, called nvidia0. This uses
the closed source nvidia driver. Take a close look at the BusID. This
option specifies which hardware card to use. You can find out the
BusId's with lspci. However, you'll soon find out this doesn't always
match. That's because lspci displays the device address in hexadecimal
form. Xorg however uses decimal form. So you'll need to convert your
address from hexadecimal form to decimal. Thus a device address of
0:0a:0 in lspci would become 0:10:0 in xorg.conf.

Create a section like this for every graphics card you have.

> Screens

This section defines my first screen, called screen0. Pay close
attention to the "monitor" option. For easy recognition I called it the
model of my monitor.

    Section "Screen"
            Identifier              "screen0"
            Device                  "nvidia0"
            Monitor                 "l1730s"
            DefaultDepth    24
            Option                  "DPI"   "100x100"

            Subsection "Display"
                    Depth   24
                    Modes   "1280x1024"     "1024x768"
            EndSubsection

    EndSection

Create a section like this for every screen you have.

> Monitors

This section defines my first monitor, l1730s. Pay close attention to
the identifier.

    Section "Monitor"
            Identifier      "l1730s"
            HorizSync       30-93
            VertRefresh     60
            Option          "dpms"
    EndSection

Create section like this for every monitor you have.

> Serverlayout

Here's the fun stuff. This is how everything is added up. This is my
first seat, called seat0. Here I tell Xorg for the server layout called
"seat0" to use my screen0, which is attached to nvidia0, using keyboard0
and mouse0.

The AutoAddDevices option is now needed to keep HAL from automatically
adding all your input devices to all the X servers.

    Section "ServerLayout"
            Identifier      "seat0"
            Screen          "screen0"       0                   0
            InputDevice     "mouse0"        "CorePointer"
            InputDevice     "keyboard0"     "CoreKeyboard"
            Option "Clone" "off"
            Option "AutoAddDevices" "off"
            Option "DisableModInDev" "true"
            Option "SingleCard" "on"   # use this to simplfied isolatedevice option        
    EndSection

Create a section like this for every seat you have with their respective
keyboards, mice and screens.

Testing
-------

Before we start modifying our login manager, we'll first start with
testing out the individual seats. If these are working, then we're good
to go.

I've used twm (tiny window manager) to test out if my seats work, but
there's no reason you can't use KDE, gnome, or any other desktop
environment or window manager. I've used this in my ~/.xinitrc:

    exec twm

Use the following command to test out an individual seat:

    startx -- -layout seat0 -config xorg.conf.multiseat

Do this for every seat you have. If they are all working correctly and
the keyboard/mouse combination matches, then congratulations! You are
almost finished! In case you are wondering why I didn't you use the full
path to my new configuration file, that's because X doesn't allow that
when running as non-root. It will search for xorg.conf.multiseat
relative to /etc/X11.

Setting up the loginmanager
---------------------------

> For KDM (KDE's Display Manager)

Open /usr/share/config/kdm/kdmrc and set the following variables:

    StaticServers=:0,:1 #In the case of two seats. If you have three this would become :0,:1,:2 and so forth.
    ReserveServers=:2,:3 #You can define here as many as you want, but these should always start at the highest seat + 1.

Next you'll need to add an [X-:n-Core] for each seat (where n = the
seat)

    [X-:0-Core]
    ServerArgsLocal=-nolisten tcp -layout seat0

    [X-:1-Core]
    ServerArgsLocal=-nolisten tcp -layout seat1 -sharevts -novtswitch

Add section like this for every seat you have, and do not forget to
change the :0 and the -layout seat0. Note that the "-sharevts" and
"-novtswitch" options should be added for all seats except the first
one. Otherwise, you can end with rectangles of virtual terminals
"showing through" on your primary screen.

> For GDM (Gnome's Display Manager)

Note:The following will work with GDM 2.20 but not with newer versions
of GDM. GDM 2.20 is in AUR.

Open /etc/gdm/custom.conf and set the following variables (This sample
demos two seats):

    [servers]
    0=Standard0
    1=Standard1

    [server-Standard0]
    name=Standard server
    command=/usr/bin/X -nolisten tcp -novtswitch -sharevts -r -config xorg.conf.multiseat
     -layout seat0
    flexible=true

    [server-Standard1]
    name=Standard server
    command=/usr/bin/X -nolisten tcp -novtswitch -sharevts -r -config xorg.conf.multiseat
     -layout seat1
    flexible=true

> For XDM (X Display Manager)

Open /etc/X11/xdm/Xservers and set the following variables (This sample
demos two seats):

    # NOTE: don't add -sharevts on seat0, otherwise it may reset in about 10~20 minutes automatically.
    :0 local /usr/bin/X :0 vt07 -nolisten tcp  -novtswitch -layout seat0 -config xorg.conf.multiseat
    :1 local /usr/bin/X :1 vt08 -nolisten tcp -sharevts -novtswitch -layout seat1 -config xorg.conf.multiseat

Also if you use the Archlinux theme edit /etc/X11/xdm/xdm-config for
every screen:

    DisplayManager._0.setup:        /etc/X11/xdm/arch-xdm/Xsetup
    DisplayManager._0.startup:      /etc/X11/xdm/arch-xdm/Xstartup
    DisplayManager._0.reset:        /etc/X11/xdm/arch-xdm/Xreset
    DisplayManager._1.setup:        /etc/X11/xdm/arch-xdm/Xsetup
    DisplayManager._1.startup:      /etc/X11/xdm/arch-xdm/Xstartup
    DisplayManager._1.reset:        /etc/X11/xdm/arch-xdm/Xreset

> For LightDM (Light Display Manager)

LightDM works well with ALSA only and PulseAudio removed if you wish to
have shared audio, an alsamixer equalizer and software mixing.

In the example below LightDM and MATE with ALSA was installed with
PulseAudio removed. PulseAudio could also be used but it requires a more
complicated configuration to maintain high audio quality. The relevant
hardware used is an ATI Radeon HD 5850 and an Intel Sandy Bridge
(onboard) HD 3000. You configuration may vary.

Open /etc/lightdm/lightdm.conf and follow the sample. Autologin is
optional. This works both as multi-user multiseat and single user
multi-seat. In the first case only the last user to login will have
audio control and access. Specific hardware could be addressed in
/etc/asound.conf to allocate audio to both users simultaneously if
required. Another option enables two different users to both access
audio with their own equalizer (described further down). The sound card
will be shared equally among the seats using ALSA with PulseAudio
removed - libpulse itself should be kept for various software
dependencies however:

    [LightDM]
    greeter-user=lightdm
    log-directory=/var/log/lightdm
    run-directory=/run/lightdm

    [SeatDefaults]
    xserver-command=/usr/bin/X
    greeter-session=lightdm-gtk-greeter
    greeter-show-manual-login=true
    user-session=mate
    session-wrapper=/etc/lightdm/Xsession
    pam-service=lightdm-autologin
    exit-on-failure=true

    [Seat:0]
    xserver-command=/usr/bin/X :0 -sharevts
    xserver-layout=Layout0
    #autologin-user=joeblow
    #autologin-user-timeout=-1
    #session-setup-script=/etc/lightdm/scripts/sound_start
    #session-cleanup-script=/etc/lightdm/scripts/sound_stop
     
    [Seat:1]
    xserver-command=/usr/bin/X :1 -sharevts
    xserver-layout=Layout1
    #autologin-user=jillschmill
    #autologin-user-timeout=-1

Next, remove respective ~/.asoundrc files (as well as related PulseAudio
config files if you removed that) and follow this template with
/etc/asound.conf for sound:

    defaults.pcm.rate_converter "samplerate_best"

    ctl.equal {
     type equal;
    }

    pcm.plugequal {
      type equal;
      # Modify the line below if you do not
      # want to use sound card 0.
      #slave.pcm "plughw:0,0";
      #by default we want to play from more sources at time:
      slave.pcm "plug:dmix";
    }
    #pcm.equal {
      # If you do not want the equalizer to be your
      # default soundcard comment the following
      # line and uncomment the above line. (You can
      # choose it as the output device by addressing
      # it with specific apps,eg mpg123 -a equal 06.Back_In_Black.mp3)
    pcm.!default {
      type plug;
      slave.pcm plugequal;
    }

But if you wish to share audio equally among different users, add each
user to the audio group:

Example:

    usermod -a -G ftp joeblow
    usermod -a -G ftp jillschmill

Then put this in each user's respective ~/.asoundrc rather than using
/etc/asound.conf (this option also contains various tweaks to improve
audio quality):

    defaults.pcm.rate_converter "samplerate_best"

    ctl.equal {
     type equal;
    }

    pcm.ossmix {
        type dmix
        ipc_key 1024 # must be unique!
        ipc_key_add_uid false   # let multiple users share
        ipc_perm 0666           # IPC permissions for multi-user sharing (octal, default 0600)
        slave {
            pcm "hw:0,0"      # you cannot use a "plug" device here, darn.
            period_time 0
            period_size 1024 # must be power of 2.
            buffer_size 8192  # ditto.
            rate 44100
           #format "S32_LE"
           #periods 128 # dito.
           #rate 8000 # with rate 8000 you *will* hear,
           # if ossmix is used :)
        }
        # bindings are cool. This says, that only the first
        # two channels are to be used by dmix, which is
        # enough for (most) oss apps and also lets 
        # multichannel chips work much faster:
        bindings {
            0 0 # from 0 => to 0
            1 1 # from 1 => to 1
        }
    }

    pcm.plugequal {
      type equal;
      # Modify the line below if you do not
      # want to use sound card 0.
      #slave.pcm "plughw:0,0";
      #by default we want to play from more sources at time:
      slave.pcm "plug:ossmix";
    }

    #pcm.equal {
      # If you do not want the equalizer to be your
      # default soundcard comment the following
      # line and uncomment the above line. (You can
      # choose it as the output device by addressing
      # it with specific apps,eg mpg123 -a equal 06.Back_In_Black.mp3)
    pcm.!default {
      type plug;
      slave.pcm plugequal;
    }

Accessing the equalizer can be done with:

    alsaequal -D equal

In the previous case, each user has an equalizer they can configure
separately.

Make sure to turn down and mute the audio channels that you do not use,
turn off auto-mute microphone, and make sure no channel has a gain
higher than 0 to avoid ALSA audio bugs. This can be done via alsamixer.

Finally you must set the /etc/X11/xorg.conf file. You'll notice some
options have been commented out which could be set according to your
needs. Here is a sample, adjust to your own system configuration after
determing hardware information:

    Section "ServerFlags"
        Option         "DefaultServerLayout" "Layout1"
    #    Option         "AllowMouseOpenFail"  "true"
        Option         "AutoAddDevices"      "false"
        Option         "AutoEnableDevices"   "false"
        Option         "DontZap"             "false"
        Option         "Xinerama" "0"
        Option         "AutoAddGPU" "FALSE"
    EndSection

    Section "ServerLayout"
        Identifier     "Layout0"
        Screen         0  "Screen0" 0 0
        InputDevice    "kbd_0" "CoreKeyboard"
        InputDevice    "mouse_0" "CorePointer"
        Option         "AllowEmptyInput"       "true"
        Option 	   "DontVTSwitch"          "true" 
    EndSection

    Section "ServerLayout"
        Identifier     "Layout1"
        Screen         0  "Screen1" 0 0
        InputDevice    "kbd_1" "CoreKeyboard"
        InputDevice    "mouse_1" "CorePointer"
        Option         "AllowEmptyInput"       "true"
        Option 	   "DontVTSwitch"          "true"
    EndSection

    Section "Module"
    #    Load 	   "dri2"
    #    Load 	   "glamoregl"
    EndSection

    Section "InputDevice"
        Identifier     "kbd_0"
        Driver 	   "evdev"
        Option         "Device"        "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.6:1.0-event-kbd"
        Option         "GrabDevice"    "on"
        Option 	   "XkbRules" "xorg"
        Option 	   "XkbModel" "105"
        Option 	   "XkbLayout" "us"
        Option  	   "Protocol"      "Standard"
    EndSection

    Section "InputDevice"
        Identifier     "kbd_1"
        Driver         "evdev"
        Option         "Device"        "/dev/input/by-path/pci-0000:04:00.0-usb-0:1:1.0-event-kbd"
        Option         "GrabDevice"    "on"
        Option 	   "XkbRules" "xorg"
        Option 	   "XkbModel" "105"
        Option 	   "XkbLayout" "us"
        Option  	   "Protocol"      "Standard"
    EndSection

    Section "InputDevice"
        Identifier     "mouse_0"
        Driver         "evdev"
        Option         "Device"        "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.5:1.0-event-mouse"
        Option         "GrabDevice"    "on"
    EndSection

    Section "InputDevice"
        Identifier     "mouse_1"
        Driver         "evdev"
        Option         "Device"        "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.3:1.0-event-mouse"
        Option         "GrabDevice"    "on"
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option	   "VendorName" "Unknown"
        Option	   "ModelName" "Generic Autodetecting Monitor"
    #    Option	   "DPMS" "true"
    EndSection

    Section "Monitor"
        Identifier     "Monitor1"
        Option	   "VendorName" "Unknown"
        Option	   "ModelName" "Generic Autodetecting Monitor"
    EndSection

    Section "Device"
        Identifier     "Device0"
        Driver         "radeon"
    #    Option 	   "AccelMethod" "glamor"
        Option 	   "AccelMethod" "EXA"
        VendorName     ""
        BoardName      ""
        BusID          "PCI:1:0:0"
        Screen          0
    #    Option         "EXAVSync"
    EndSection

    Section "Device"
        Identifier     "Device1"
        Driver         "intel"
        VendorName     ""
        BoardName      ""
        BusID          "PCI:0:2:0"
        Screen          0
    #    Option         "AccelMethod" "UXA"
    #    Option         "TearFree" "1"
    EndSection

    Section "Screen"
        Identifier "Screen0"
        Device     "Device0"
        Monitor    "Monitor0"
        DefaultDepth     24
        SubSection "Display"
        	Depth     24
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen1"
        Device         "Device1"
        Monitor        "Monitor1"
        DefaultDepth    24
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection

Additional Tips:

-   Make sure to delete the ~/.Xauthority file in respective user
    directories before the initial reboot.

-   To avoid tearing this seems to help on nearly all configurations -
    add this to /etc/environment:

    CLUTTER_PAINT=disable-clipped-redraws:disable-culling
    CLUTTER_VBLANK=True

-   To help avoid tearing on the web and maintain site compatibility it
    is advisable to install Pipelight for playing media online.

> For Auto Login multiseat (without Display Manager)

edit a script /boot/twin.sh

    #!/bin/bash
    cmd1="/bin/bash --login -c \"/usr/bin/xinit --"
    cmd2="-nolisten tcp -keeptty -novtswitch -config xorg.multiseat.conf"
    usr=(user1 user2)  # FIXME: assume user1, user2 is valid user id
    declare -a pid
    while true ; do
      for ((i=0; i<${#usr[*]}; i++)) ; do
        echo "usr[$i]=${usr[$i]} pid=${pid[$i]}"
        if [ -z "${pid[$i]}" ] || [ ! -d "/proc/${pid[$i]}" ] ; then
          # echo "pid ${pid[$i]} killed, execute again"  
          cmd3="-layout seat$i vt0"$((7+i))"\""
          if [ $i -gt 0 ] ; then
            cmd3="-sharevts $cmd3"
          fi
          #echo "cmd3=$cmd3"
          /bin/su ${usr[$i]} -l -c "$cmd1 :$i $cmd2 $cmd3" &
          pid[$i]=$!
          #echo "new pid=${pid[$i]}"
        fi
      done
      sleep 5  # check process exist per 5 second
    done

Open /etc/inittab and setup as follows:

    #id:3:initdefault:
    id:5:initdefault:
    ...
    x2:5:once:/root/twin.sh > /root/twin.log 2>&1

Troubleshooting
---------------

> My Windows key doesn't work anymore

Put this in a startup file:

    xmodmap -e "add Mod4 = Super_L Super_R"

> Unreliable behaviour (black picture without cursor)

If everything seems to be set up correctly, but for some reason you
always get a black picture without a cursor, try setting the first
initialized card in the BIOS to be the PCI card one.

> Little black boxes/dots on the desktop

This is actually portions of the virtual terminals being painted on top
of X. It seems to be caused by the Linux kernel framebuffer. This can be
fixed by disabling the framebuffer, or by removing the "-sharevts"
option from the primary seat's X args.

> Multimedia keys not working

If your keyboard(s) has extra "multimedia" keys, you may find that they
stopped working in your multiseat setup. This is because such keyboards
are often represented as more then one "event" device. As you did above,
cat each /dev/input/event* device, this time pressing multimedia keys.
Once you've found the right event device, add a separate keyboard
InputDevice section for it, then add that InputDevice section to the
corresponding ServerLayout section with the "SendCoreEvents" option,
which indicates that input from this device should be handled, despite
not being the core keyboard. In the end you should have sections
something like the following:

    Section "InputDevice"
        Identifier      "Keyboard0"
        Driver          "evdev"
        Option          "Device" "/dev/input/event6"
        Option          "XkbModel" "evdev"
    EndSection

    Section "InputDevice"
        Identifier      "Keyboard0Multimedia"
        Driver          "evdev"
        Option          "Device" "/dev/input/event7"
        Option          "XkbModel" "evdev"
    EndSection

    Section "ServerLayout"
        Identifier     "Layout0"
        Screen      0  "Screen0" 0 0
        InputDevice    "Keyboard0" "CoreKeyboard"
        InputDevice    "Keyboard0Multimedia" "SendCoreEvents"
        InputDevice    "Mouse0" "CorePointer"
        Option         "AutoAddDevices" "no"
    EndSection

> The Ctrl-Alt-Fx, Alt-Fx keys mess up with virtual terminals

(Oct 2010) I follows this guide and everything works, except for Atl-F1,
Atl-F2,... mess things up. Then I follow this guide
https://help.ubuntu.com/community/MultiseatX (read the part for Ubuntu
10.04):

    # cd /usr/bin
    # ln -s X X0
    # ln -s X X1

Then fix in the /usr/share/config/kdm/kdmrc as follow

    [General]
    ConsoleTTYs=tty1,tty2,tty3,tty4,tty5,tty6
    ServerVTs=7,8
    StaticServers=:0,:1
    ReserveServers=:2,:3
    ...

    [X-:0-Core]
    ServerVT=8
    ServerCmd=/usr/bin/X1
    ServerArgsLocal=-nolisten tcp -sharevts -novtswitch -keeptty -layout Seat1 -isolateDevice PCI:1:0:0

    [X-:1-Core]
    ServerVT=7
    ServerCmd=/usr/bin/X0
    ServerArgsLocal=-nolisten tcp -novtswitch -keeptty -layout Seat0 -isolateDevice PCI:0:2:0
    ...

It works for my computer: one on-board Intel card (xf86-video-intel
driver), and one Nvidia card (xf86-video-nouveau driver). You can check
if the parameters are passed correctly by:

    $ ps aux | grep 'PCI' | grep -Ev 'grep'
    root     16993  1.6  1.3  32900 26772 ?        S    08:09   0:19 /usr/bin/X0 :1 vt7 -nolisten tcp -novtswitch -keeptty -layout Seat0 -isolateDevice PCI:0:2:0 -auth /var/run/xauth/A:1-ES6CCb
    root     17124  5.9  0.5  18996 11980 ?        S    08:09   1:09 /usr/bin/X1 :0 vt8 -nolisten tcp -sharevts -novtswitch -keeptty -layout Seat1 -isolateDevice PCI:1:0:0 -auth /var/run/xauth/A:0-Wgiyza

The ServerVT=7, ServerVT=8 would be pass to as vt7, vt8

Final configuration
-------------------

> /etc/X11/xorg.conf

This is my full xorg.conf with multiseat that works:

    Section "Module"
    	Load        "dbe"

    	SubSection  "extmod"
    		Option    "omit xfree86-dga"
    	EndSubSection
    	
    	Load	"type1"
    	Load	"speedo"
    	Load	"freetype"
    	Load	"glx"
    EndSection


    Section "Files"
    	RgbPath	"/usr/share/X11/rgb"

    	FontPath 	"/usr/share/fonts/misc"
    	FontPath 	"/usr/share/fonts/75dpi"
    	FontPath 	"/usr/share/fonts/100dpi"
    	FontPath 	"/usr/share/fonts/TTF"
    	FontPath 	"/usr/share/fonts/Type1"
    	FontPath 	"/usr/share/fonts/msfonts"
    	FontPath 	"/usr/share/fonts/misc2"
    	FontPath 	"/usr/share/fonts/local"
    	FontPath 	"/usr/local/share/fonts"
    EndSection


    Section "ServerFlags"
    	# Option	"DontZap"
    	Option	"AllowMouseOpenFail"	"true"
    	# Option	"DefaultServerLayout"	"alltogether"
    	Option	"Xinerama"	"0"
    EndSection

    Section "InputDevice"
    	Identifier	"keyboard0"
    	Driver		"evdev"
    	Option		"Device"		"/dev/input/event1"
    	Option		"XkbModel"		"evdev"
    	Option		"XkbLayout"		"be"
    EndSection

    Section "InputDevice"
    	Identifier	"keyboard1"
    	Driver		"evdev"
    	Option		"Device"		"/dev/input/event5"
    	Option		"XkbModel"		"evdev"
    	Option		"XkbLayout"		"be"
    EndSection


    Section "InputDevice"
    	Identifier	"mouse0"
    	Driver		"mouse"
    	Option		"Protocol"		"IMPS/2"	# Auto detect
    	Option		"Device"		"/dev/input/mouse2"
    	Option		"ZAxisMapping"	"4 5"
    EndSection

    Section "InputDevice"
    	Identifier	"mouse1"
    	Driver		"mouse"
    	Option		"Protocol"		"IMPS/2"
    	Option		"Device"		"/dev/input/mouse1"
    EndSection


    Section "Device"
    	Identifier	"nvidia0"
    	Driver		"nvidia"
    	Option		"RenderAccel"	"true"
    	Option		"TripleBuffer"	"True"
    	Option		"NoLogo"		"1"
    	BusId		"PCI:1:0:0"
    EndSection

    Section "Device"
    	Identifier	"nvidia1"
    	Driver		"nvidia"
    	Option		"RenderAccel"	"true"
    	Option		"TripleBuffer"	"True"
    	Option		"NoLogo"		"1"
    	BusId		"PCI:0:10:0"
    EndSection


    Section "Screen"
    	Identifier		"screen0"
    	Device			"nvidia0"
    	Monitor			"l1730s"
    	DefaultDepth	24
    	Option			"DPI"	"100x100"

    	Subsection "Display"
    		Depth	24
    		Modes	"1280x1024"	"1024x768"
    	EndSubsection
    	
    EndSection

    Section "Screen"
     	Identifier		"screen1"
     	Device			"nvidia1"
     	Monitor			"cpdm151"
     	DefaultDepth	24
     	Option			"DPI"	"100x100"
     
     	Subsection "Display"
    		Depth	24
    		Modes	"1024x768"	"800x600"
     	EndSubsection
     	
    EndSection

    Section "ServerLayout"
    	Identifier	"seat0"
    	Screen		"screen0"	0				0
    	InputDevice	"mouse0"	"CorePointer"
    	InputDevice	"keyboard0"	"CoreKeyboard"
    	Option          "AutoAddDevices"        "off"
    EndSection

    Section "ServerLayout"
     	Identifier	"seat1"
    	Screen		"screen1"	0				0
    	InputDevice	"mouse1"	"CorePointer"
    	InputDevice	"keyboard1"	"CoreKeyboard"
    	Option          "AutoAddDevices"        "off"
    EndSection

    Section "Extensions"
    	Option	"Composite"	"Disable"
    	Option	"RENDER"	"Enable"
    EndSection

    Section "Monitor"
    	Identifier	"l1730s"
    	HorizSync	30-93
    	VertRefresh	60
    	Option		"dpms"
    EndSection

    Section "Monitor"
    	Identifier	"cpdm151"
    	Option		"dpms"
    	HorizSync	30-61
    	VertRefresh	60
    EndSection

> /opt/kde/share/config/kdm/kdmrc

This is my kdmrc:

    [General]
    ConfigVersion=2.3
    ConsoleTTYs=vc/1,vc/2,vc/3,vc/4,vc/5,vc/6
    PidFile=/var/run/kdm.pid
    ReserveServers=:2,:3
    ServerVTs=-7
    StaticServers=:0,:1

    [Shutdown]
    BootManager=Grub
    HaltCmd=/sbin/halt
    RebootCmd=/sbin/reboot

    [X-*-Core]
    AllowNullPasswd=false
    AllowRootLogin=false
    AllowShutdown=Root
    Authorize=true
    AutoReLogin=false
    ClientLogFile=.xsession-errors-%s
    Reset=/opt/kde/share/config/kdm/Xreset
    Resources=/opt/kde/share/config/kdm/Xresources
    Session=/opt/kde/share/config/kdm/Xsession
    SessionsDirs=/etc/X11/sessions,/usr/share/xsessions,/opt/kde/share/apps/kdm/sessions
    Setup=/opt/kde/share/config/kdm/Xsetup
    Startup=/opt/kde/share/config/kdm/Xstartup

    [X-*-Greeter]
    AllowConsole=true
    AntiAliasing=true
    AuthComplain=true
    BackgroundCfg=/opt/kde/share/config/kdm/backgroundrc
    ColorScheme=
    DefaultUser=
    EchoMode=OneStar
    FaceSource=PreferUser
    FailFont=Tahoma,11,-1,5,75,0,0,0,0,0
    FocusPasswd=false
    ForgingSeed=1097313140
    GUIStyle=
    GreetFont=Tahoma,11,-1,5,75,0,0,0,0,0
    GreetString=Arch Linux %r (%h)
    GreeterPos=50,50
    HiddenUsers=root
    Language=en_US
    LogoArea=None
    LogoPixmap=
    MaxShowUID=65000
    MinShowUID=500
    PreselectUser=None
    SelectedUsers=
    ShowUsers=NotHidden
    SortUsers=true
    StdFont=Tahoma,11,-1,5,50,0,0,0,0,0
    UseBackground=false
    UserCompletion=false
    UserList=true

    [X-:*-Core]
    AllowNullPasswd=true
    AllowRootLogin=true
    AllowShutdown=All
    NoPassEnable=false
    NoPassUsers=

    [X-:*-Greeter]
    AllowClose=true
    DefaultUser=glenn
    FocusPasswd=true
    LoginMode=DefaultLocal
    PreselectUser=Previous

    [X-:0-Core]
    AutoLoginAgain=false
    AutoLoginDelay=0
    AutoLoginEnable=false
    AutoLoginLocked=false
    AutoLoginUser=glenn
    ClientLogFile=.xsession-errors
    ServerArgsLocal=-nolisten tcp -layout seat0 -sharevts -novtswitch 

    [X-:1-Core]
    ServerArgsLocal=-nolisten tcp -layout seat1 -sharevts -novtswitch 

    [Xdmcp]
    Enable=false
    Willing=/opt/kde/share/config/kdm/Xwilling
    Xaccess=/opt/kde/share/config/kdm/Xaccess

Related problems
----------------

> PulseAudio

If two users want to use the sound card simultaneously, it is necessary
to use a sound server, PulseAudio being most prevalent. Usually, the
PulseAudio server runs only for active user and does not allow for
multiple user instances. Solution to this problem is using the
system-wide PulseAudio server. Although this approach is discouraged by
its authors, it is probably most applicable setup.

Configuring for system-wide PulseAudio

-   Create user pulse and put him into group audio (PulseAudio drops
    root privileges and changes to user pulse. Group membership allows
    for device access.)
-   Create group pulse-access and put users, who will play sound locally
    into it (Group membership is used for access control for local
    access to PA daemon.)
-   In /etc/pulse/default.pa state explicitly the access rights

    load-module module-native-protocol-unix auth-group=pulse-access auth-group-enable=1

Start PA as system-wide, under root:

    pulseaudio --system

In /var/run/pulse should appear files for communication with daemon,
namely pid and native.

User access

You can check communication with system daemon as non-root by e.g.
pactl -s "unix:/var/run/pulse/native" list.

It is possible to enable automatic connection to local daemon in
/etc/pulse/client.conf

    auto-connect-localhost = yes

The users should be able to connect to PA server. All the cons for
system-wide daemon become essentially pros, e.g. ability to control
volume of other users streams in pavucontrol.

Troubleshooting

It is possible to enable the http interface to PA for debugging in
/etc/pulse/default.pa load-module module-http-protocol-tcp and then
connect to it at http://localhost:4714/

See also
--------

-   The original Arch Forums thread.

-   The arckwiki page Multi-pointer X explains how to setup two separate
    pair of devices on the same session.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xorg_multiseat&oldid=297667"

Category:

-   X Server

-   This page was last modified on 15 February 2014, at 08:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
