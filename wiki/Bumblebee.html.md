Bumblebee
=========

Related articles

-   NVIDIA Optimus
-   Nouveau
-   NVIDIA
-   Intel Graphics

From Bumblebee's FAQ:

"Bumblebee is an effort to make NVIDIA Optimus enabled laptops work in
GNU/Linux systems. Such feature involves two graphics cards with two
different power consumption profiles plugged in a layered way sharing a
single framebuffer."

Contents
--------

-   1 Bumblebee: Optimus for Linux
-   2 Installation
    -   2.1 Installing Bumblebee with Intel/NVIDIA
    -   2.2 Installing Bumblebee with Intel/Nouveau
-   3 Start Bumblebee
-   4 Usage
-   5 Configuration
    -   5.1 Optimizing speed when using VirtualGL as bridge
    -   5.2 Power management
        -   5.2.1 Default power state of NVIDIA card using bbswitch
        -   5.2.2 Enable NVIDIA card during shutdown
    -   5.3 Multiple monitors
        -   5.3.1 Outputs wired to the Intel chip
        -   5.3.2 Output wired to the NVIDIA chip
            -   5.3.2.1 xf86-video-intel-virtual-crtc and
                hybrid-screenclone
-   6 Switch between discrete and integrated like Windows
-   7 CUDA without Bumblebee
-   8 Troubleshooting
    -   8.1 [VGL] ERROR: Could not open display :8
    -   8.2 [ERROR]Cannot access secondary GPU
        -   8.2.1 No devices detected
        -   8.2.2 NVIDIA(0): Failed to assign any connected display
            devices to X screen 0
        -   8.2.3 Could not load GPU driver
        -   8.2.4 Failed to initialize the NVIDIA GPU at PCI:1:0:0 (GPU
            fallen off the bus)
    -   8.3 ERROR: ld.so: object 'libdlfaker.so' from LD_PRELOAD cannot
        be preloaded: ignored
    -   8.4 Fatal IO error 11 (Resource temporarily unavailable) on X
        server
    -   8.5 Video tearing
    -   8.6 Bumblebee cannot connect to socket
-   9 See also

Bumblebee: Optimus for Linux
----------------------------

Optimus Technology is an hybrid graphics implementation without a
hardware multiplexer. The integrated GPU manages the display while the
dedicated GPU manages the most demanding rendering and ships the work to
the integrated GPU to be displayed. When the laptop is running on
battery supply, the dedicated GPU is turned off to save power and
prolong the battery life. It has also been tested successfully with
desktop machines with Intel integrated graphics and an nVidia dedicated
graphics card.

Bumblebee is a software implementation comprising of two parts:

-   Render programs off-screen on the dedicated video card and display
    it on the screen using the integrated video card. This bridge is
    provided by VirtualGL or primus (read further) and connects to a X
    server started for the discrete video card.
-   Disable the dedicated video card when it is not in use (see the
    Power management section)

It tries to mimic the Optimus technology behavior; using the dedicated
GPU for rendering when needed and power it down when not in use. The
present releases only support rendering on-demand, automatically
starting a program with the discrete video card based on workload is not
implemented.

Installation
------------

Before installing Bumblebee check your BIOS and activate Optimus (older
laptops call it "switchable graphics") if possible (BIOS doesn't have to
provide this option), and install the Intel driver for the secondary on
board graphics card.

Several packages are available for a complete setup:

-   bumblebee - The main package providing the daemon and client
    programs.
-   (optional) bbswitch (or bbswitch-dkms) - Recommended for saving
    power by disable the NVIDIA card.
-   (optional) If you want more than just saving power, that is
    rendering programs on the discrete NVDIA card you also need:
    -   a driver for the NVIDIA card. The open-source nouveau driver or
        the more closed-source NVIDIA driver. See the subsection.
    -   a render/display bridge. Two packages are currently available
        for that, primus (or primus-git) and virtualgl. Only one of them
        is necessary, but installing them side-by-side does not hurt.

Note:If you want to run a 32-bit application on a 64-bit system you must
install the proper lib32-* libraries for the program. In addition to
this, you also need to install lib32-virtualgl or lib32-primus,
depending on your choice for the render bridge. Just make sure you run
primusrun instead of optirun if you decide to use Primus render bridge.

> Installing Bumblebee with Intel/NVIDIA

Install intel-dri, xf86-video-intel, bumblebee and nvidia. If you have
intel-dri and xf86-video-intel installed, you will have to reinstall
them together with the rest to avoid a dependency conflict between
intel-dri and nvidia.

If you want to run 32-bit applications (like games with wine) on a
64-bit system you need the lib32-nvidia-utils (and lib32-intel-dri if
you intend to use primusrun) package too.

Warning:Do not install lib32-nvidia-libgl. Bumblebee will find the
correct lib32 NVIDIA libraries without it.

> Installing Bumblebee with Intel/Nouveau

Install:

-   xf86-video-nouveau - experimental 3D acceleration driver.
-   nouveau-dri - Mesa classic DRI + Gallium3D drivers.
-   mesa - Mesa 3D graphics libraries.

Start Bumblebee
---------------

In order to use Bumblebee it is necessary add yourself (and other users)
to the bumblebee group:

    # gpasswd -a $USER bumblebee

where $USER is the login name of the user to be added. Then log off and
on again to apply the group changes.

Tip:If you wish bumblebee to start at boot, you have to enable systemd
service bumblebeed.

Finished. Reboot system and use the shell program optirun for Optimus
NVIDIA rendering!

If you simply wish to disable your NVIDIA card, this should be all that
is needed, apart from having bbswitch installed. The bumblebeed daemon
will, by default, instruct bbswitch to turn off the card when it starts.
See also the power management section below.

Usage
-----

The command line programm optirun shipped with Bumblebee is your best
friend for running applications on your Optimus NVIDIA card.

Test Bumblebee if it works with your Optimus system:

    $ optirun glxgears -info

If it succeeds and the terminal you are running from mentions something
about your NVIDIA - Optimus with Bumblebee is working!

General usage:

    $ optirun [options] application [application-parameters]

Some Examples:

Start Windows applications with Optimus:

    $ optirun wine windows application.exe

Use NVIDIA Settings with Optimus:

    $ optirun -b none nvidia-settings -c :8

For a list of options for optirun view its manual page.

A new program is soon becoming the default choice because of better
performance, namely primus. Currently you need to run this program
separately (it does not accept options unlike optirun), but in the
future it will be started by optirun. Usage:

    $ primusrun glxgears

Configuration
-------------

You can configure the behaviour of Bumblebee to fit your needs. Fine
tuning like speed optimization, power management and other stuff can be
configured in /etc/bumblebee/bumblebee.conf

> Optimizing speed when using VirtualGL as bridge

Bumblebee renders frames for your Optimus NVIDIA card in an invisible X
Server with VirtualGL and transports them back to your visible X Server.

Frames will be compressed before they are transported - this saves
bandwidth and can be used for speed-up optimization of bumblebee:

To use an other compression method for a single application:

    $ optirun -c compress-method application

The method of compres will affect performance in the GPU/GPU usage.
Compressed methods (such as jpeg) will load the CPU the most but will
load GPU the minimum necessary; uncompressed methods loads the most on
GPU and the CPU will have the minimum load possible.

Compressed methods are: jpeg, rgb, yuv.

Uncompressed methods are: proxy, xv.

To use a standard compression for all applications set the VGLTransport
to compress-method in /etc/bumblebee/bumblebee.conf:

    /etc/bumblebee/bumblebee.conf

    [...]
    [optirun]
    VGLTransport=proxy
    [...]

You can also play with the way VirtualGL reads back the pixels from your
graphic card. Setting VGL_READBACK environment variable to pbo should
increase the performance. Compare these two:

    # PBO should be faster.
    VGL_READBACK=pbo optirun glxspheres
    # The default value is sync.
    VGL_READBACK=sync optirun glxspheres

Note:CPU frequency scaling will affect directly on render performance

> Power management

The goal of power management feature is to turn off the NVIDIA card when
it is not used by bumblebee any more. If bbswitch is installed, it will
be detected automatically when the Bumblebee daemon starts. No
additional configuration is necessary.

Default power state of NVIDIA card using bbswitch

The default behavior of bbswitch is to leave the card power state
unchanged. bumblebeed does disable the card when started, so the
following is only necessary if you use bbswitch without bumblebeed.

Set load_state and unload_state module options according to your needs
(see bbswitch documentation).

    /etc/modprobe.d/bbswitch.conf

    options bbswitch load_state=0 unload_state=1

Enable NVIDIA card during shutdown

The NVIDIA card may not correctly initialize during boot if the card was
powered off when the system was last shutdown. One option is to set
TurnCardOffAtExit=false in /etc/bumblebee/bumblebee.conf, however this
will enable the card everytime you stop the Bumblebee daemon, even if
done manually. To ensure that the NVIDIA card is always powered on
during shutdown, add the following systemd service (if using bbswitch):

    /etc/systemd/system/nvidia-enable.service

    [Unit]
    Description=Enable NVIDIA card
    DefaultDependencies=no

    [Service]
    Type=oneshot
    ExecStart=/bin/sh -c 'echo ON > /proc/acpi/bbswitch'

    [Install]
    WantedBy=shutdown.target

Then enable the service by running
systemctl enable nvidia-enable.service at the root prompt.

> Multiple monitors

Outputs wired to the Intel chip

If the port (DisplayPort/HDMI/VGA) is wired to the Intel chip, you can
set up multiple monitors with xorg.conf. Set them to use the Intel card,
but Bumblebee can still use the NVIDIA card. One example configuration
is below for two identical screens with 1080p resolution and using the
HDMI out.

    /etc/X11/xorg.conf

    Section "Screen"
        Identifier     "Screen0"
        Device         "intelgpu0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
            Modes          "1980x1080_60.00"
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen1"
        Device         "intelgpu1"
        Monitor        "Monitor1"
        DefaultDepth   24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
            Modes          "1980x1080_60.00"
        EndSubSection
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option         "Enable" "true"
    EndSection

    Section "Monitor"
        Identifier     "Monitor1"
        Option         "Enable" "true"
    EndSection

    Section "Device"
        Identifier     "intelgpu0"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Device"
        Identifier     "intelgpu1"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Device"
        Identifier "nvidiagpu1"
        Driver "nvidia"
        BusID "PCI:0:1:0"
    EndSection

You need to probably change the BusID for both the Intel and the NVIDIA
card.

    $ lspci | grep VGA

    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)

The BusID is 0:2:0

Output wired to the NVIDIA chip

On some notebooks, the digital Video Output (HDMI or DisplayPort) is
hardwired to the NVIDIA chip. If you want to use all the displays on
such a system simultaniously, you have to run 2 X Servers. The first
will be using the Intel driver for the notebooks panel and a display
connected on VGA. The second will be started through optirun on the
NVIDIA card, and drives the digital display.

There are currently several instructions on the web how such a setup can
be made to work. One can be found on the bumblebee wiki page. Another
approach is described below.

xf86-video-intel-virtual-crtc and hybrid-screenclone

This method uses a patched Intel driver, which is extended to have a
VIRTUAL Display, and the program hybrid-screenclone which is used to
copy the display over from the virtual display to a second X Server
which is running on the NVIDIA card using Optirun. Credit goes to
Triple-head monitors on a Thinkpad T520 which has a detailed explanation
on how this is done on a Ubuntu system.

For simplicity, DP is used below to refer to the Digital Output
(DisplayPort). The instructions should be the same if the notebook has a
HDMI port instead.

-   Set system to use NVIDIA card exclusively, test DP/Monitor
    combination and generate xorg.nvidia.conf. This step is not
    required, but recommended if your system Bios has an option to
    switch the graphics into NVIDIA-only mode. To do this, first
    uninstall the bumblebee package and install just the NVIDIA driver.
    Then reboot, enter the Bios and switch the Graphics to NVIDIA-only.
    When back in Arch, connect you Monitor on DP and use startx to test
    if it is working in principle. Use Xorg -configure to generate an
    xorg.conf file for your NVIDIA card. This will come in handy further
    down below.

-   Reinstall bumlbebee and bbswitch, reboot and set the system Gfx back
    to Hybrid in the BIOS.
-   Install xf86-video-intel-virtual-crtc, and replace your
    xf86-video-intel package with it.
-   Install screenclone-git
-   Change these bumblebee.conf settings:

    /etc/bumblebee/bumblebee.conf

    KeepUnusedXServer=true
    Driver=nvidia

Note:Leave the PMMethod set to "bumblebee". This is contrary to the
instructions linked in the article above, but on arch this options needs
to be left alone so that bbswitch module is automatically loaded

-   Copy the xorg.conf generated in Step 1 to /etc/X11 (e.g.
    /etc/X11/xorg.nvidia.conf). In the [driver-nvidia] section of
    bumblebee.conf, change XorgConfFile to point to it.
-   Test if your /etc/X11/xorg.nvidia.conf is working with
    startx -- -config /etc/X11/xorg.nvidia.conf
-   In order for your DP Monitor to show up with the correct resolution
    in your VIRTUAL Display you might have to edit the Monitor section
    in your /etc/xorg.nvidia.conf. Since this is extra work, you could
    try to continue with your auto-generated file. Come back to this
    step in the instructions if you find that the resolution of the
    VIRTUAL Display as shown by xrandr is not correct.
    -   First you have to generate a Modeline. You can use the tool
        amlc, which will genearte a Modeline if you input a few basic
        parameters.

Example: 24" 1920x1080 Monitor

start the tool with amlc -c

    Monitor Identifier: Samsung 2494
    Aspect Ratio: 2
    physical size[cm]: 60
    Ideal refresh rate, in Hz: 60
    min HSync, kHz: 40
    max HSync, kHz: 90
    min VSync, Hz: 50
    max VSync, Hz: 70
    max pixel Clock, MHz: 400

This is the Monitor section which amlc generated for this input:

    Section "Monitor"
        Identifier     "Samsung 2494"
        ModelName      "Generated by Another Modeline Calculator"
        HorizSync      40-90
        VertRefresh    50-70
        DisplaySize    532 299  # Aspect ratio 1.778:1
        # Custom modes
        Modeline "1920x1080" 174.83 1920 2056 2248 2536 1080 1081 1084 1149             # 174.83 MHz,  68.94 kHz,  60.00 Hz
    EndSection  # Samsung 2494

Change your xorg.nvidia.conf to include this Monitor section. You can
also trim down your file so that it only contains ServerLayout, Monitor,
Device and Screen sections. For reference, here is mine:

    /etc/X11/xorg.nvidia.conf

    Section "ServerLayout"
            Identifier     "X.org Nvidia DP"
            Screen      0  "Screen0" 0 0
            InputDevice    "Mouse0" "CorePointer"
            InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

    Section "Monitor"
        Identifier     "Samsung 2494"
        ModelName      "Generated by Another Modeline Calculator"
        HorizSync      40-90
        VertRefresh    50-70
        DisplaySize    532 299  # Aspect ratio 1.778:1
        # Custom modes
        Modeline "1920x1080" 174.83 1920 2056 2248 2536 1080 1081 1084 1149             # 174.83 MHz,  68.94 kHz,  60.00 Hz
    EndSection  # Samsung 2494

    Section "Device"
            Identifier  "DiscreteNvidia"
            Driver      "nvidia"
            BusID       "PCI:1:0:0"
    EndSection

    Section "Screen"
            Identifier "Screen0"
            Device     "DiscreteNvidia"
            Monitor    "Samsung 2494"
            SubSection "Display"
                    Viewport   0 0
                    Depth     24
            EndSubSection
    EndSection

-   Plug in both external monitors and startx. Look at your
    /var/log/Xorg.0.log. Check that your VGA Monitor is detected with
    the correct Modes there. You should also see a VIRTUAL output with
    modes show up.
-   Run xrandr and three displays should be listed there, along with the
    supported modes.
-   If the listed Modelines for your VIRTUAL display doesn't have your
    Monitors native resolution, make note of the exact output name. For
    me that is VIRTUAL1. Then have a look again in the Xorg.0.log file.
    You should see a message: "Output VIRTUAL1 has no monitor section"
    there. We will change this by putting a file with the needed Monitor
    section into /etc/X11/xorg.conf.d. Exit and Restart X afterward.

    /etc/X11/xorg.conf.d/20-monitor_samsung.conf

    Section "Monitor"
        Identifier     "VIRTUAL1"
        ModelName      "Generated by Another Modeline Calculator"
        HorizSync      40-90
        VertRefresh    50-70
        DisplaySize    532 299  # Aspect ratio 1.778:1
        # Custom modes
        Modeline "1920x1080" 174.83 1920 2056 2248 2536 1080 1081 1084 1149             # 174.83 MHz,  68.94 kHz,  60.00 Hz
    EndSection  # Samsung 2494

-   Turn the NVIDIA card on by running:
    sudo tee /proc/acpi/bbswitch <<< ON
-   Start another X server for the DisplayPort monitor:
    sudo optirun true
-   Check the log of the second X server in /var/log/Xorg.8.log
-   Run xrandr to set up the VIRTUAL display to be the right size and
    placement, eg.:
    xrandr --output VGA1 --auto --rotate normal --pos 0x0 --output VIRTUAL1 --mode 1920x1080 --right-of VGA1 --output LVDS1 --auto --rotate normal --right-of VIRTUAL1
-   Take note of the position of the VIRTUAL display in the list of
    Outputs as shown by xrandr. The counting starts from zero, i.e. if
    it is the third display shown, you would specify -x 2 as parameter
    to screenclone (Note: This might not always be correct. If you see
    your internal laptop display cloned on the monitor, try -x 2
    anyway.)
-   Clone the contents of the VIRTUAL display onto the X server created
    by bumblebee, which is connected to the DisplayPort monitor via the
    NVIDIA chip:

screenclone -d :8 -x 2

Thats it, all three displays should be up and running now.

Switch between discrete and integrated like Windows
---------------------------------------------------

In Windows, the way that Optimus works is NVIDIA has a whitelist of
applications that require Optimus for, and you can add applications to
this whitelist as needed. When you launch the application, it
automatically decides which card to use.

To mimic this behavior in Linux, you can use libgl-switcheroo-git. After
installing, you can add the below in your .xprofile.

    ~/.xprofile

    mkdir -p /tmp/libgl-switcheroo-$USER/fs
    gtkglswitch &
    libgl-switcheroo /tmp/libgl-switcheroo-$USER/fs &

To enable this, you must add the below to the shell that you intend to
launch applications from (I simply added it to the .xprofile file)

    export LD_LIBRARY_PATH=/tmp/libgl-switcheroo-$USER/fs/\$LIB${LD_LIBRARY_PATH+:}$LD_LIBRARY_PATH

Once this has all been done, every application you launch from this
shell will pop up a GTK+ window asking which card you want to run it
with (you can also add an application to the whitelist in the
configuration). The configuration is located in
$XDG_CONFIG_HOME/libgl-switcheroo.conf, usually
~/.config/libgl-switcheroo.conf

CUDA without Bumblebee
----------------------

This is not well documented, but you do not need Bumblebee to use CUDA
and it may work even on machines where optirun fails. For a guide on how
to get it working with the Lenovo IdeaPad Y580 (which uses the GeForce
660M), see:
https://wiki.archlinux.org/index.php/Lenovo_IdeaPad_Y580#NVIDIA_Card.
Those instructions are very likely to work with other machines.

Troubleshooting
---------------

Note:Please report bugs at Bumblebee-Project's GitHub tracker as
described in its wiki.

> [VGL] ERROR: Could not open display :8

There is a known problem with some wine applications that fork and kill
the parent process without keeping track of it (for example the free to
play online game "Runes of Magic")

This is a known problem with VirtualGL. As of bumblebee 3.1, so long as
you have it installed, you can use Primus as your render bridge:

    $ optirun -b primus wine windows program.exe

If this does not work, an alternative walkaround for this problem is:

    $ optirun bash
    $ optirun wine windows program.exe

If using NVIDIA drivers a fix for this problem is to edit
/etc/bumblebee/xorg.conf.nvidia and change Option ConnectedMonitor to
CRT-0.

> [ERROR]Cannot access secondary GPU

No devices detected

In some instances, running optirun will return:

    [ERROR]Cannot access secondary GPU - error: [XORG] (EE) No devices detected.
    [ERROR]Aborting because fallback start is disabled.

In this case, you will need to move the file
/etc/X11/xorg.conf.d/20-intel.conf to somewhere else. Restart the
bumblebeed daemon, and it should work. If you do need to change some
features on Intel module, a workaround is to move your
/etc/X11/xorg.conf.d/20-intel.conf to /etc/X11/xorg.conf.

It could be also necessary to comment the driver line in
/etc/X11/xorg.conf.d/10-monitor.conf.

If you're using the nouveau driver you could try switching to the nVidia
driver.

You might need to define the NVIDIA card somewhere (e.g. file
/etc/X11/xorg.conf.d), and remember to change the BusID using lspci.

    Section "Device"
        Identifier "nvidiagpu1"
        Driver "nvidia"
        BusID "PCI:0:1:0"
    EndSection

NVIDIA(0): Failed to assign any connected display devices to X screen 0

If the console output is:

    [ERROR]Cannot access secondary GPU - error: [XORG] (EE) NVIDIA(0): Failed to assign any connected display devices to X screen 0
    [ERROR]Aborting because fallback start is disabled.

  
 You can change this line in /etc/bumblebee/xorg.conf.nvidia:

    Option "ConnectedMonitor" "DFP"

to:

    Option "ConnectedMonitor" "CRT"

Could not load GPU driver

If the console output is:

    [ERROR]Cannot access secondary GPU - error: Could not load GPU driver

and if you try to load the nvidia module you get:

    modprobe nvidia
    modprobe: ERROR: could not insert 'nvidia': Exec format error

You should try manually compiling the nvidia packages against your
current kernel.

    yaourt -Sb nvidia

Should do the trick

Failed to initialize the NVIDIA GPU at PCI:1:0:0 (GPU fallen off the bus)

You can try to add rcutree.rcu_idle_gp_delay=1 to the
GRUB_CMDLINE_LINUX_DEFAULT parameter located in /etc/default/grub (don't
forget the # grub-mkconfig -o /boot/grub/grub.cfg). Original topic can
be found here.

> ERROR: ld.so: object 'libdlfaker.so' from LD_PRELOAD cannot be preloaded: ignored

You probably want to start a 32-bit application with bumblebee on a
64-bit system. See the "Note" box in Installation.

> Fatal IO error 11 (Resource temporarily unavailable) on X server

Change KeepUnusedXServer in /etc/bumblebee/bumblebee.conf from false to
true. Your program forks into background and bumblebee don't know
anything about it.

> Video tearing

Video tearing is a somewhat common problem on Bumblebee. To fix it, you
need to enable vsync. It should be enabled by default on the Intel card,
but verify that from Xorg logs. To check whether or not it is enabled
for NVIDIA, run:

    $ optirun nvidia-settings -c :8

X Server XVideo Settings -> Sync to VBlank and
OpenGL Settings -> Sync to VBlank should both be enabled. The Intel card
has in general less tearing, so use it for video playback. Especially
use VA-API for video decoding (e.g. mplayer-vaapi and with -vsync
parameter).

Refer to the Intel article on how to fix tearing on the Intel card.

If it is still not fixed, try to disable compositing from your desktop
environment. Try also disabling triple buffering.

> Bumblebee cannot connect to socket

You might get something like:

    $ optirun glxspheres

    [ 1648.179533] [ERROR]You've no permission to communicate with the Bumblebee daemon. Try adding yourself to the 'bumblebee' group
    [ 1648.179628] [ERROR]Could not connect to bumblebee daemon - is it running?

If you are already in the bumblebee group ($ groups | grep bumblebee),
you may try removing the socket /var/run/bumblebeed.socket.

See also
--------

-   Bumblebee project repository
-   Bumblebee project wiki
-   Bumblebee project bbswitch repository

Join us at #bumblebee at freenode.net.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bumblebee&oldid=306017"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
