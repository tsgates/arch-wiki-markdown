XLayout
=======

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: The method is    
                           initscript only. And I   
                           do think the use case is 
                           gone nowadays. (Discuss) 
  ------------------------ ------------------------ ------------------------

This document will help you choose which X layout to load on bootup via
a grub (lilo should be possible too) entry.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Background                                                         |
| -   2 Principle                                                          |
| -   3 Manipulation                                                       |
|     -   3.1 Setting config file                                          |
|     -   3.2 Creating the script                                          |
|     -   3.3 Launching the "daemon"                                       |
|     -   3.4 Giving the right parameter to the kernel                     |
|                                                                          |
| -   4 Package                                                            |
+--------------------------------------------------------------------------+

Background
----------

I then made two versions of xorg.conf: /etc/X11/xorg.conf.nvidia and
/etc/X11/xorg.conf.nv I created a symbolic link to the one I wanted to
use:

    # telinit 3
    # ln -s xorg.conf.nvidia xorg.conf
    # telinit 5

or

    # telinit 3
    # ln -s xorg.conf.nv xorg.conf
    # telinit 5

But I had to shutdown X (telinit 3) and restart it (telinit 5) to edit
the configuration file and it was a pain. I tough that a kernel
parameter could have be given at boot time.

Principle
---------

Edit your bootloader so it will give an extra parameter to the kernel.
Then, launch a daemon that will edit the proper config file. The daemon
does not do anything on shutdown.

Manipulation
------------

> Setting config file

First, you will need to check your /etc/X11/xorg.conf file. In that
file, it is possible to choose many configurations, called
"ServerLayout". Each of your ServerLayout section let you choose wich
devices to use. My idea was to put at least two ServerLayout, one that
will use the NVIDIA driver, and the other the nv driver. I have also
included another ServerLayout with "safe" values.

First, you will need to create the multiple ServerLayouts. As root, open
up /etc/X11/xorg.conf and copy the ServerLayout (generaly at the end of
the file) :

    Section "ServerLayout"
        Identifier  "safe"
        Screen "Ecran LCD (nv)"
        InputDevice "Clavier" "CoreKeyboard"
        InputDevice "Souris (Safe)" "CorePointer"
    EndSection

    Section "ServerLayout"
        Identifier  "nv"
        Screen "Ecran LCD (nv)"
        InputDevice "Clavier" "CoreKeyboard"
        InputDevice "Alps Touchpad Glidepoint" "SendCoreEvents"
        InputDevice "Alps Touchpad Stickpointer" "SendCoreEvents"
        InputDevice "LogitechMX700Duo_souris" "CorePointer"
        InputDevice "LogitechMX700Duo_clavier" "SendCoreEvents"
    EndSection

    Section "ServerLayout"
        Identifier  "nvidia"
        Screen "Ecran LCD (nvidia)"
        InputDevice "Clavier" "CoreKeyboard"
        InputDevice "Alps Touchpad Glidepoint" "SendCoreEvents"
        InputDevice "Alps Touchpad Stickpointer" "SendCoreEvents"
        InputDevice "LogitechMX700Duo_souris" "CorePointer"
        InputDevice "LogitechMX700Duo_clavier" "SendCoreEvents"
    EndSection

Note that the video driver is set in the "Screen" section. So you will
need to have at least two Section "Screen" like this:

    Section "Screen"
        Identifier  "Ecran LCD (nv)"
        Device      "nVidia GForce4 4200 Go (nv)"
        Monitor     "Moniteur"
        DefaultDepth 24
        SubSection  "Display"
    	Depth       24
    	Modes       "1920x1200"
        EndSubsection
        Subsection "Display"
            Depth       8
            Modes       "1280x1024" "1024x768" "800x600" "640x480"
            ViewPort    0 0
        EndSubsection
        Subsection "Display"
            Depth       16
            Modes       "1280x1024" "1024x768" "800x600" "640x480"
            ViewPort    0 0
        EndSubsection
        Subsection "Display"
            Depth       24
            Modes       "1600x1200" "1280x1024" "800x600"
            ViewPort    0 0
        EndSubsection
    EndSection

    Section "Screen"
        Identifier  "Ecran LCD (nvidia)"
        Device      "nVidia GForce4 4200 Go (nvidia)"
        Monitor     "Moniteur"
        DefaultDepth 24
        SubSection  "Display"
    	Depth       24
    	Modes       "1920x1200"
        EndSubsection
        Subsection "Display"
            Depth       8
            Modes       "1280x1024" "1024x768" "800x600" "640x480"
            ViewPort    0 0
        EndSubsection
        Subsection "Display"
            Depth       16
            Modes       "1280x1024" "1024x768" "800x600" "640x480"
            ViewPort    0 0
        EndSubsection
        Subsection "Display"
            Depth       24
            Modes       "1600x1200" "1280x1024" "800x600"
            ViewPort    0 0
        EndSubsection
    EndSection

    Section "Device"
        Identifier  "nVidia GForce4 4200 Go (nvidia)"
        Driver      "nvidia"
        Option      "RenderAccel"   "false"
        Option      "AllowGLXWithComposite" "true"
    #    Option    "NoLogo"        "true"
        Option  "NvAGP" "1"
    EndSection

    Section "Device"
        Identifier  "nVidia GForce4 4200 Go (nv)"
        Driver      "nv"
    EndSection

Xorg let you choose witch ServerLayout to choose on the command line.
Since you surelly do not load /usr/X11R6/bin/X manually, you will need
to tell the programm you load X from to give it parameters. I personnaly
use kdm launched from the runlevel 5 (see /etc/inittab) so what I have
done is configure it. The file to edit is
/opt/kde/share/config/kdm/kdmrc so add the two lines "ServerCmd" and
"ServerArgsLocal" to the "[[X-:*-Core]]" section :

    [[...]]
    # Core config for local displays
    [[X-:*-Core]]
    ServerCmd=/usr/X11R6/bin/X
    ServerArgsLocal=-layout nv
    [[...]]

Now each time kdm is launched, it will launch /usr/X11R6/bin/X with the
"-layout nv" argument. Now the xorg.conf's "nv" ServerLayout will be
used. You could change "nv" to "nvidia" or "safe", corresponding to the
"Indetifier" option of the "ServerLayout" section wanted. Now lets look
at a way to change this dynamicly.

> Creating the script

The easiest way to launch a script at bootup is adaptying it to
/etc/rc.d/ script structure and placing it in /etc/rc.d/<script name>.
The script below will edit the file /opt/kde/share/config/kdm/kdmrc and
put the right ServerLayout you want depending on a kernel parameter
given at boot time of the one given as parameter to the script. Their is
a "status" option also that will tell you wich layout is currently
active.

I have created a package for the script. Look at the end of the document
for the pkg.tar.bz and PKGBUILD.

> Launching the "daemon"

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: initscripts has  
                           been depreciated. Use    
                           systemd instead.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Open the /etc/rc.conf file and add xlayout to your daemons array:

    DAEMONS=(syslog-ng hotplug !pcmcia network wireless \
            netfs crond acpid cpufreqd \
            !freepopsd alsamixer mysqld !vmware \
            !autofs !privoxy !tor \
            gensplash xlayout)

> Giving the right parameter to the kernel

The last thing to do is give the kernel the right parameter so X will
load the layout you want. I do not use LILO so I do not know how to
change this, but you should be able to do it yourself! Open the
/boot/grub/menu.lst and create new entries for the layout you want :

    [[...]]
    title  Arch Linux (nv)
            root   (hd0,0)
            kernel /vmlinuz-linux root=/dev/discs/disc0/part3 ro devfsnomount vga=792 consoletty1 xlayout=nv
    title  Arch Linux (nvidia)
            root   (hd0,0)
            kernel /vmlinuz-linux root=/dev/discs/disc0/part3 ro devfsnomount vga=792 consoletty1 xlayout=nvidia
    title  Arch Linux (safe)
            root   (hd0,0)
            kernel /vmlinuz-linux root=/dev/discs/disc0/part3 ro devfsnomount vga=792 consoletty1 xlayout=safe
    [[...]]

Note the xlayout=[[...]] at the end of lines begining with "kernel".

That way, you will have, at boot time, the choice to use the X layout
you want.

I hope it helped someone.

Good luck

Package
-------

Here is a xlayout PKGBUILD in AUR that will let you manage the script
via pacman.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XLayout&oldid=254235"

Category:

-   X Server
